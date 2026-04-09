#!/usr/bin/env bash
# Tests: Lua syntax for all nvim plugin files, duplicate keymap detection
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAIL=$((FAIL+1)); }
warn() { printf "  \033[33m⚠\033[0m %s\n" "$1"; }

printf "\033[1m=== Neovim Lua Syntax ===\033[0m\n"

NVIM_DIR="$DOTFILES_DIR/nvim/nvim"

if ! command -v luac &>/dev/null; then
  warn "luac not found — install lua from Brewfile to enable syntax checks"
else
  while IFS= read -r f; do
    rel="${f#$DOTFILES_DIR/}"
    if err=$(luac -p "$f" 2>&1); then
      pass "$rel"
    else
      fail "$rel — $err"
    fi
  done < <(find "$NVIM_DIR" -name "*.lua")
fi

printf "\n\033[1m=== Neovim Keybinding Conflicts ===\033[0m\n"

PLUGINS_DIR="$NVIM_DIR/lua/plugins"

# Collect all normal-mode vim.keymap.set keys into a temp file, then find dups
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

# Extract: vim.keymap.set("n", "KEY" — use rg for Perl regex support
if command -v rg &>/dev/null; then
  rg --no-heading -n 'vim\.keymap\.set\("n"' "$NVIM_DIR/lua/" 2>/dev/null \
    | while IFS= read -r line; do
        key=$(echo "$line" | rg -o '"n",\s*"[^"]*"' | awk -F'"' '{print $4}')
        src=$(echo "$line" | awk -F: '{print $1}')
        [[ -n "$key" ]] && printf "n:%s\t%s\n" "$key" "${src#$DOTFILES_DIR/}"
      done >> "$TMPFILE"
else
  warn "rg not found — skipping vim.keymap.set conflict detection"
fi

# Check for duplicates
DUP_KEYS=$(awk '{print $1}' "$TMPFILE" | sort | uniq -d)
if [[ -z "$DUP_KEYS" ]]; then
  pass "no duplicate normal-mode vim.keymap.set bindings"
else
  while IFS= read -r dup; do
    sources=$(grep "^${dup}" "$TMPFILE" | awk '{print $2}' | tr '\n' ' ')
    fail "duplicate binding '$dup' in: $sources"
  done <<< "$DUP_KEYS"
fi

# LazyVim keys spec: find { "KEY", ... } entries, flag per-key duplicates
# Only normal-mode entries (no mode = "v")
LAZY_TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE" "$LAZY_TMPFILE"' EXIT

if command -v rg &>/dev/null; then
  rg --no-heading -n '^\s*\{ "<' "$PLUGINS_DIR" 2>/dev/null \
    | grep -v 'mode\s*=\s*"v"' \
    | while IFS= read -r line; do
        key=$(echo "$line" | rg -o '"<[^"]*>"' | head -n1)
        src=$(echo "$line" | awk -F: '{print $1}')
        [[ -n "$key" ]] && printf "%s\t%s\n" "$key" "${src#$DOTFILES_DIR/}"
      done >> "$LAZY_TMPFILE"

  LAZY_DUPS=$(awk '{print $1}' "$LAZY_TMPFILE" | sort | uniq -d)
  if [[ -z "$LAZY_DUPS" ]]; then
    pass "no duplicate LazyVim keys spec bindings"
  else
    while IFS= read -r dup; do
      sources=$(grep "^${dup}" "$LAZY_TMPFILE" | awk '{print $2}' | tr '\n' ' ')
      fail "duplicate LazyVim key '$dup' in: $sources"
    done <<< "$LAZY_DUPS"
  fi
else
  warn "rg not found — skipping LazyVim keys spec conflict detection"
fi

printf "\n\033[1m=== Neovim Hardcoded Paths ===\033[0m\n"

LLDB_DAP="/opt/homebrew/opt/llvm/bin/lldb-dap"
if [[ -x "$LLDB_DAP" ]]; then
  pass "lldb-dap exists at $LLDB_DAP"
else
  fail "lldb-dap missing at $LLDB_DAP (Rust DAP debugging broken — brew install llvm)"
fi

printf "\nNeovim: %d passed, %d failed\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]]
