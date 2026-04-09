#!/usr/bin/env bash
# pre-commit hook — reminds about tests and CLAUDE.md freshness
# Non-blocking: always exits 0. Prints reminders only when relevant.

DOTFILES_DIR="$(git rev-parse --show-toplevel)"

# Config files that warrant a CLAUDE.md refresh
CONFIG_PATTERNS=(
  "nvim/"
  "tmux/"
  "zsh/"
  "aliases/"
  "git/"
  "alacritty/"
  "starship/"
  "claude/"
  "homebrew/Brewfile"
  "install.sh"
)

# Files that warrant a test run reminder
TEST_PATTERNS=(
  "nvim/"
  "tmux/"
  "zsh/"
  "aliases/"
  "homebrew/Brewfile"
  "install.sh"
  "tests/"
)

# Get staged file paths
STAGED=$(git diff --cached --name-only)

needs_claude_update=false
needs_tests=false

for pattern in "${CONFIG_PATTERNS[@]}"; do
  if echo "$STAGED" | grep -q "^${pattern}"; then
    needs_claude_update=true
    break
  fi
done

for pattern in "${TEST_PATTERNS[@]}"; do
  if echo "$STAGED" | grep -q "^${pattern}"; then
    needs_tests=true
    break
  fi
done

if $needs_tests; then
  printf '\033[33m[dotfiles]\033[0m Config files changed — run tests before pushing:\n'
  printf '  make test-dotfiles\n'
fi

if $needs_claude_update; then
  printf '\033[33m[dotfiles]\033[0m Config files changed — consider refreshing CLAUDE.md:\n'
  printf '  bash scripts/update-claude-md.sh\n'
fi

exit 0
