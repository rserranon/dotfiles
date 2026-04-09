#!/usr/bin/env bash
# Tests: All Brewfile tools are installed (formulas + casks + key binaries)
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAIL=$((FAIL+1)); }
warn() { printf "  \033[33m⚠\033[0m %s\n" "$1"; }

printf "\033[1m=== Homebrew Formulas ===\033[0m\n"

BREWFILE="$DOTFILES_DIR/homebrew/Brewfile"

if ! command -v brew &>/dev/null; then
  warn "brew not found — skipping all tool checks"
  exit 0
fi

INSTALLED_FORMULAS=$(brew list --formula 2>/dev/null)
INSTALLED_CASKS=$(brew list --cask 2>/dev/null)

check_formula() {
  if echo "$INSTALLED_FORMULAS" | grep -qx "$1"; then
    pass "brew: $1"
  else
    fail "brew: $1 — not installed"
  fi
}

check_cask() {
  if echo "$INSTALLED_CASKS" | grep -qx "$1"; then
    pass "cask: $1"
  else
    fail "cask: $1 — not installed"
  fi
}

while IFS= read -r line; do
  formula=$(echo "$line" | sed -n 's/^brew "\([^"]*\)".*/\1/p')
  [[ -n "$formula" ]] && check_formula "$formula"
done < "$BREWFILE"

printf "\n\033[1m=== Homebrew Casks ===\033[0m\n"

while IFS= read -r line; do
  cask=$(echo "$line" | sed -n 's/^cask "\([^"]*\)".*/\1/p')
  [[ -n "$cask" ]] && check_cask "$cask"
done < "$BREWFILE"

printf "\n\033[1m=== Key Binary Availability ===\033[0m\n"

# Format: "binary:description"
BINARIES=(
  "bat:bat (cat replacement)"
  "rg:ripgrep"
  "fd:fd (find replacement)"
  "fzf:fzf"
  "delta:git-delta"
  "lsd:lsd (ls replacement)"
  "starship:starship prompt"
  "tmux:tmux"
  "nvim:neovim"
  "stow:gnu stow"
  "jq:jq"
  "gh:github cli"
  "zoxide:zoxide"
  "lua:lua"
  "luac:luac (lua compiler)"
  "cargo:rust/cargo"
  "trash:trash"
)

for entry in "${BINARIES[@]}"; do
  bin="${entry%%:*}"
  desc="${entry##*:}"
  if command -v "$bin" &>/dev/null; then
    pass "$desc ($bin)"
  else
    fail "$desc ($bin) — not in PATH"
  fi
done

# NVM: not a binary, check directory
NVM_PATH="${NVM_DIR:-$HOME/.nvm}"
if [[ -d "$NVM_PATH" ]]; then
  pass "nvm ($NVM_PATH)"
else
  fail "nvm — $NVM_PATH not found"
fi

printf "\nTools: %d passed, %d failed\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]]
