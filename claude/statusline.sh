#!/usr/bin/env bash
# ~/.claude/statusline.sh — Claude Code status line
# Catppuccin macchiato palette, matches nvim/tmux theme

input=$(cat)

# Extract fields
model=$(echo "$input" | jq -r '.model.display_name // "claude"' \
  | sed 's/Claude //' | sed 's/ Latest//')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""' | xargs basename 2>/dev/null)
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0' | awk '{printf "%.3f", $1}')
rate=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | awk '{printf "%.0f", $1}')
vim_mode=$(echo "$input" | jq -r '.vim.mode // ""')

# Catppuccin macchiato colors
RESET=$'\033[0m'
MAUVE=$'\033[38;2;198;160;246m'   # model name
BLUE=$'\033[38;2;138;173;244m'    # directory
GREEN=$'\033[38;2;166;218;149m'   # ctx ok / vim insert
YELLOW=$'\033[38;2;238;212;159m'  # ctx mid
RED=$'\033[38;2;237;135;150m'     # ctx high
PEACH=$'\033[38;2;245;169;127m'   # cost
TEAL=$'\033[38;2;139;213;202m'    # vim normal
SURFACE=$'\033[38;2;147;154;183m' # separators / dim

# Context progress bar (10 chars)
bar=""
for ((i=0; i<10; i++)); do
  [[ $i -lt $((ctx / 10)) ]] && bar+="█" || bar+="░"
done

# Context color
if   [[ $ctx -ge 90 ]]; then ctx_color="$RED"
elif [[ $ctx -ge 70 ]]; then ctx_color="$YELLOW"
else                          ctx_color="$GREEN"
fi

# Vim mode badge
vim_badge=""
if [[ -n "$vim_mode" ]]; then
  if [[ "$vim_mode" == "NORMAL" ]]; then
    vim_badge=" ${SURFACE}[${TEAL}N${SURFACE}]${RESET}"
  else
    vim_badge=" ${SURFACE}[${GREEN}I${SURFACE}]${RESET}"
  fi
fi

# Rate limit (only show when non-zero)
rate_segment=""
if [[ $rate -gt 0 ]]; then
  rate_segment=" ${SURFACE}·${RESET} 5hr ${SURFACE}${rate}%${RESET}"
fi

# Reasoning effort (only present on models that support it). Color escalates
# with cost: high is yellow, xhigh/max are red.
effort=$(echo "$input" | jq -r '.effort.level // ""')
effort_segment=""
if [[ -n "$effort" ]]; then
  case "$effort" in
    xhigh|max) effort_color="$RED"     ;;
    high)      effort_color="$YELLOW"  ;;
    *)         effort_color="$SURFACE" ;;
  esac
  effort_segment=" ${SURFACE}·${RESET} ${effort_color}${effort}${RESET}"
fi

# Bondage pin status (cached, 5-min TTL). Re-runs `bondage doctor` only when
# the cache is missing or older than 300s; status line refreshes too often
# to hash binaries on every render.
bondage_segment=""
if command -v bondage &>/dev/null; then
  bondage_cache="$HOME/.cache/dotfiles-bondage-status"
  bondage_conf="$HOME/.config/bondage/bondage.conf"
  mkdir -p "$(dirname "$bondage_cache")"
  age=$(( $(date +%s) - $(stat -f %m "$bondage_cache" 2>/dev/null || echo 0) ))
  if [[ ! -f $bondage_cache || $age -gt 300 ]]; then
    if [[ ! -f $bondage_conf ]]; then
      echo "error" > "$bondage_cache"
    elif bondage doctor "$bondage_conf" 2>/dev/null | grep -q "status: clean"; then
      echo "clean" > "$bondage_cache"
    else
      echo "stale" > "$bondage_cache"
    fi
  fi
  bondage_status="$(cat "$bondage_cache" 2>/dev/null)"
  case "$bondage_status" in
    clean) dot_color="$GREEN"  ;;
    stale) dot_color="$RED"    ;;
    *)     dot_color="$YELLOW" ;;
  esac
  # Pulse anything that isn't clean/green: dim the dot on alternating seconds so
  # a stale or errored pin blinks to draw attention. The status line re-renders
  # often enough that this animates without any timer of our own.
  if [[ "$bondage_status" != clean ]] && (( $(date +%s) % 2 == 0 )); then
    dot_color="$SURFACE"
  fi
  bondage_segment=" ${SURFACE}·${RESET} bondage ${dot_color}●${RESET}"
fi

printf "${MAUVE}%s${RESET}" "$model"
printf "%s" "$effort_segment"
printf " ${SURFACE}·${RESET} ${BLUE}%s${RESET}" "$dir"
printf " ${SURFACE}·${RESET} ctx ${ctx_color}%s%%%s ${SURFACE}%s${RESET}" "$ctx" "$RESET" "$bar"
printf " ${SURFACE}·${RESET} ${PEACH}\$%s${RESET}" "$cost"
printf "%s" "$rate_segment"
printf "%s" "$vim_badge"
printf "%s\n" "$bondage_segment"
