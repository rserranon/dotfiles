#!/usr/bin/env bash
# Tests: Stow package layout, Claude symlinks, zshrc bootstrap
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; PASS=$((PASS+1)); }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAIL=$((FAIL+1)); }
warn() { printf "  \033[33m⚠\033[0m %s\n" "$1"; }

printf "\033[1m=== Stow Package Layout ===\033[0m\n"

STOW_PACKAGES=(alacritty aliases git homebrew nvim starship tmux zsh)

for pkg in "${STOW_PACKAGES[@]}"; do
  pkg_dir="$DOTFILES_DIR/$pkg"
  if [[ ! -d "$pkg_dir" ]]; then
    fail "$pkg — directory missing"
  elif [[ -n "$(ls -A "$pkg_dir" 2>/dev/null)" ]]; then
    pass "$pkg — exists and non-empty"
  else
    fail "$pkg — directory is empty"
  fi
done

printf "\n\033[1m=== Active Symlinks ===\033[0m\n"

# Resolve a path to its canonical absolute path (follows symlinks)
resolve() { python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$1"; }

check_symlink() {
  local link="$1" expected_target="$2" label="$3"
  if [[ ! -e "$link" && ! -L "$link" ]]; then
    fail "$label — missing (run ./install.sh)"
    return
  fi
  if [[ ! -L "$link" ]]; then
    fail "$label — exists but is not a symlink"
    return
  fi
  actual=$(resolve "$link")
  expected=$(resolve "$expected_target")
  if [[ "$actual" == "$expected" ]]; then
    pass "$label"
  else
    fail "$label → resolves to $actual (expected $expected)"
  fi
}

check_symlink "$HOME/.claude/CLAUDE.md"          "$DOTFILES_DIR/claude/CLAUDE.md"          "~/.claude/CLAUDE.md"
check_symlink "$HOME/.claude/settings.json"      "$DOTFILES_DIR/claude/settings.json"      "~/.claude/settings.json"
check_symlink "$HOME/.claude/local-marketplace"  "$DOTFILES_DIR/claude/local-marketplace"  "~/.claude/local-marketplace"
check_symlink "$HOME/.copilot/copilot-instructions.md" \
              "$DOTFILES_DIR/copilot/copilot-instructions.md" \
              "~/.copilot/copilot-instructions.md"
check_symlink "$HOME/.config/nvim"  "$DOTFILES_DIR/nvim/nvim"   "~/.config/nvim"
check_symlink "$HOME/.config/tmux"  "$DOTFILES_DIR/tmux/tmux"   "~/.config/tmux"
check_symlink "$HOME/.config/git"   "$DOTFILES_DIR/git/git"     "~/.config/git"

printf "\n\033[1m=== Zsh Bootstrap ===\033[0m\n"

ZSHRC="$HOME/.zshrc"
if [[ ! -f "$ZSHRC" ]]; then
  fail "~/.zshrc not found (run ./install.sh)"
else
  # Accept either direct dotfiles path or via stow symlink through ~/.config
  if grep -qE "source\s+(~/.config/.zshrc|~/dotfiles/zsh/.zshrc)" "$ZSHRC"; then
    pass "~/.zshrc sources dotfiles zsh config"
  else
    fail "~/.zshrc does not source dotfiles zsh config (expected: source ~/.config/.zshrc or ~/dotfiles/zsh/.zshrc)"
  fi
fi

printf "\n\033[1m=== Git-tracked Marketplace JSONs ===\033[0m\n"

TRACKED=$(git -C "$DOTFILES_DIR" ls-files claude/local-marketplace/)
for f in \
  "claude/local-marketplace/.claude-plugin/marketplace.json" \
  "claude/local-marketplace/plugins/dotfiles-tools/.claude-plugin/plugin.json"; do
  if echo "$TRACKED" | grep -qF "$f"; then
    pass "tracked: $f"
  else
    fail "not git-tracked: $f (*.json gitignore missing exception)"
  fi
done

printf "\nStow: %d passed, %d failed\n" "$PASS" "$FAIL"
[[ $FAIL -eq 0 ]]
