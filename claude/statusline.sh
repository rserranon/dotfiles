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

printf "${MAUVE}%s${RESET}" "$model"
printf " ${SURFACE}·${RESET} ${BLUE}%s${RESET}" "$dir"
printf " ${SURFACE}·${RESET} ctx ${ctx_color}%s%%%s ${SURFACE}%s${RESET}" "$ctx" "$RESET" "$bar"
printf " ${SURFACE}·${RESET} ${PEACH}\$%s${RESET}" "$cost"
printf "%s" "$rate_segment"
printf "%s\n" "$vim_badge"
