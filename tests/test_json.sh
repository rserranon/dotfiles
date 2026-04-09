#!/usr/bin/env bash
# Tests: JSON syntax validity for all tracked JSON configs
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAIL=$((FAIL+1)); }

printf "\033[1m=== JSON Syntax ===\033[0m\n"

check_json() {
  local file="$DOTFILES_DIR/$1"
  if [[ ! -f "$file" ]]; then
    fail "$1 — file not found"
    return
  fi
  local err
  if err=$(jq empty "$file" 2>&1); then
    pass "$1"
  else
    fail "$1 — $err"
  fi
}

check_json "claude/settings.json"
check_json "claude/local-marketplace/.claude-plugin/marketplace.json"
check_json "claude/local-marketplace/plugins/dotfiles-tools/.claude-plugin/plugin.json"

printf "\nJSON: %d passed, %d failed\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]]
