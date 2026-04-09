#!/usr/bin/env bash
# Tests: Tmux config syntax, duplicate keybindings, sourced file existence
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAIL=$((FAIL+1)); }
warn() { printf "  \033[33m⚠\033[0m %s\n" "$1"; }

printf "\033[1m=== Tmux Config ===\033[0m\n"

CONF="$DOTFILES_DIR/tmux/tmux/tmux.conf"
RESET="$DOTFILES_DIR/tmux/tmux/tmux.reset"

[[ -f "$CONF" ]]  && pass "tmux.conf exists" || fail "tmux.conf missing"
[[ -f "$RESET" ]] && pass "tmux.reset exists" || fail "tmux.reset missing"

# Runtime syntax check via isolated socket (requires stow symlinks)
STOWED_CONF="$HOME/.config/tmux/tmux.conf"
SOCK="dotfiles-test-$$"
if [[ -f "$STOWED_CONF" ]]; then
  if tmux -L "$SOCK" -f "$STOWED_CONF" start-server \; kill-server 2>/dev/null; then
    pass "tmux config runtime syntax"
  else
    ERR=$(tmux -L "$SOCK" -f "$STOWED_CONF" start-server \; kill-server 2>&1 | head -3)
    fail "tmux config runtime syntax — $ERR"
  fi
  tmux -L "$SOCK" kill-server 2>/dev/null || true
else
  warn "~/.config/tmux/tmux.conf not stowed — skipping runtime check"
fi

# Duplicate bind-key detection within tmux.conf (excluding tmux.reset overrides)
printf "\n  Checking for duplicate keybindings in tmux.conf...\n"
DUPS=$(grep -E '^\s*(bind|bind-key)\s' "$CONF" \
  | sed "s/^\s*bind-key\s*//" \
  | sed "s/^\s*bind\s*//" \
  | sed "s/^'\(.\)'.*/\1/" \
  | awk '{print $1}' \
  | sort | uniq -d)

if [[ -z "$DUPS" ]]; then
  pass "no duplicate bindings in tmux.conf"
else
  fail "duplicate bindings in tmux.conf: $DUPS"
fi

# Check plugin keybind options don't conflict with explicit bindings
EXPLICIT_KEYS=$(grep -E '^\s*(bind|bind-key)\s' "$CONF" \
  | sed "s/^\s*bind-key\s*//" | sed "s/^\s*bind\s*//" \
  | sed "s/^'\(.\)'.*/\1/" | awk '{print $1}' | sort -u)

# Extract plugin bind values (e.g. @floax-bind 'p', @sessionx-bind 'o')
PLUGIN_KEYS=$(grep -E "@(floax|sessionx)-bind" "$CONF" \
  | sed "s/.*'\(.\)'.*/\1/")

CONFLICTS=""
while IFS= read -r pk; do
  [[ -z "$pk" ]] && continue
  if echo "$EXPLICIT_KEYS" | grep -qx "$pk"; then
    CONFLICTS="$CONFLICTS $pk"
  fi
done <<< "$PLUGIN_KEYS"

if [[ -z "$CONFLICTS" ]]; then
  pass "no plugin/explicit keybinding conflicts"
else
  fail "plugin keys conflict with explicit bindings:$CONFLICTS"
fi

# Expected keybindings are present
for key in '|' '-' 'a' 'v'; do
  # Use rg if available, fall back to grep -E
  if command -v rg &>/dev/null; then
    if rg -q "bind(-key)?\s+['\"]?${key}['\"]?" "$CONF"; then
      pass "keybinding defined: '$key'"
    else
      fail "expected keybinding missing: '$key'"
    fi
  else
    if grep -E "bind(-key)?[[:space:]]+['\"]?${key}['\"]?" "$CONF" &>/dev/null; then
      pass "keybinding defined: '$key'"
    else
      fail "expected keybinding missing: '$key'"
    fi
  fi
done

printf "\nTmux: %d passed, %d failed\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]]
