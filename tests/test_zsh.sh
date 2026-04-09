#!/usr/bin/env bash
# Tests: Zsh config syntax, brew plugin files, required binaries
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAIL=$((FAIL+1)); }
warn() { printf "  \033[33m⚠\033[0m %s\n" "$1"; }

printf "\033[1m=== Zsh Config ===\033[0m\n"

ZSHRC="$DOTFILES_DIR/zsh/.zshrc"

# Syntax check (no sourcing, isolated)
if zsh -n "$ZSHRC" 2>/dev/null; then
  pass "zsh/.zshrc syntax"
else
  fail "zsh/.zshrc syntax — $(zsh -n "$ZSHRC" 2>&1)"
fi

# Secrets are guarded before sourcing
if grep -q "\[\[ -f.*secrets.*\]\]" "$ZSHRC"; then
  pass "secrets sourced conditionally"
else
  fail "secrets not guarded with [[ -f ... ]]"
fi

# Brew plugin files — use exact paths from .zshrc
BREW_PREFIX="$(brew --prefix 2>/dev/null)"
if [[ -z "$BREW_PREFIX" ]]; then
  warn "brew not found — skipping plugin file checks"
else
  declare -a PLUGIN_FILES=(
    "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh:zsh-syntax-highlighting"
    "$BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh:zsh-vi-mode"
    "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh:zsh-autosuggestions"
  )
  for entry in "${PLUGIN_FILES[@]}"; do
    file="${entry%%:*}"
    name="${entry##*:}"
    if [[ -f "$file" ]]; then
      pass "brew plugin: $name"
    else
      fail "brew plugin: $name — not found at $file"
    fi
  done
fi

# Required binaries
for bin in fzf starship lsd bat rg fd zoxide; do
  if command -v "$bin" &>/dev/null; then
    pass "binary: $bin"
  else
    fail "binary: $bin — not in PATH"
  fi
done

printf "\nZsh: %d passed, %d failed\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]]
