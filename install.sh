#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info() { printf "\033[1;34m[INFO]\033[0m %s\n" "$1"; }
success() { printf "\033[1;32m[OK]\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$1"; }

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  success "Homebrew installed"
else
  success "Homebrew already installed"
fi

# --- Homebrew packages ---
info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile"
success "Homebrew packages installed"

# --- Create .config directory ---
mkdir -p "$HOME/.config"

# --- Stow ---
info "Linking dotfiles with stow..."
cd "$DOTFILES_DIR"
for dir in alacritty aliases git homebrew nvim starship tmux zsh; do
  if [ -d "$dir" ]; then
    stow "$dir" -v1 --restow 2>&1 | grep -v "BUG" || true
    success "Linked $dir"
  fi
done

# --- ZSH bootstrap ---
ZSHRC_LINE='source ~/dotfiles/zsh/.zshrc'
if [ ! -f "$HOME/.zshrc" ] || ! grep -qF "$ZSHRC_LINE" "$HOME/.zshrc"; then
  info "Creating minimal ~/.zshrc..."
  echo "# Source dotfiles zsh config" > "$HOME/.zshrc"
  echo "$ZSHRC_LINE" >> "$HOME/.zshrc"
  success "~/.zshrc created"
else
  success "~/.zshrc already configured"
fi

# --- Git XDG config ---
# Git reads from ~/.config/git/config (XDG) automatically — no extra setup needed
success "Git config linked via stow to ~/.config/git/config"

# --- Tmux Plugin Manager ---
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  info "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  success "TPM installed"
else
  success "TPM already installed"
fi

# --- GitHub Copilot CLI ---
if command -v gh &>/dev/null; then
  if ! gh extension list 2>/dev/null | grep -q "copilot"; then
    info "Installing GitHub Copilot CLI extension..."
    gh extension install github/gh-copilot
    success "gh copilot installed"
  else
    success "gh copilot already installed"
  fi
fi

# --- Claude Code CLI ---
if command -v node &>/dev/null; then
  if ! command -v claude &>/dev/null; then
    info "Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code
    success "Claude Code installed"
  else
    success "Claude Code already installed"
  fi
else
  warn "Node.js not found — skipping Claude Code install (requires npm)"
fi

CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

if [ -f "$DOTFILES_DIR/claude/CLAUDE.md" ]; then
  ln -sf "$DOTFILES_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
  success "Claude Code CLAUDE.md linked"
fi

if [ -f "$DOTFILES_DIR/claude/settings.json" ]; then
  ln -sf "$DOTFILES_DIR/claude/settings.json" "$CLAUDE_DIR/settings.json"
  success "Claude Code settings.json linked"
fi

if [ -f "$DOTFILES_DIR/claude/statusline.sh" ]; then
  ln -sf "$DOTFILES_DIR/claude/statusline.sh" "$CLAUDE_DIR/statusline.sh"
  chmod +x "$CLAUDE_DIR/statusline.sh"
  success "Claude Code statusline.sh linked"
fi

if [ -d "$DOTFILES_DIR/claude/local-marketplace" ]; then
  ln -sf "$DOTFILES_DIR/claude/local-marketplace" "$CLAUDE_DIR/local-marketplace"
  success "Claude Code local marketplace linked"
  if command -v claude &>/dev/null; then
    claude plugin install dotfiles-tools@local-dotfiles --scope user 2>/dev/null || true
    success "Claude Code dotfiles-tools plugin installed"
  fi
fi

# --- Copilot custom instructions ---
COPILOT_INSTRUCTIONS="$DOTFILES_DIR/copilot/copilot-instructions.md"
if [ -f "$COPILOT_INSTRUCTIONS" ]; then
  mkdir -p "$HOME/.copilot"
  ln -sf "$COPILOT_INSTRUCTIONS" "$HOME/.copilot/copilot-instructions.md"
  success "Copilot custom instructions linked"
fi

# --- Git hooks ---
HOOKS_DIR="$DOTFILES_DIR/.git/hooks"
if [ -d "$HOOKS_DIR" ]; then
  ln -sf "$DOTFILES_DIR/scripts/pre-commit.sh" "$HOOKS_DIR/pre-commit"
  success "pre-commit hook linked"
fi

# --- Markdownlint config ---
if [ -f "$DOTFILES_DIR/.markdownlint.json" ]; then
  ln -sf "$DOTFILES_DIR/.markdownlint.json" "$HOME/.markdownlint.json"
  ln -sf "$DOTFILES_DIR/.markdownlint-cli2.yaml" "$HOME/.markdownlint-cli2.yaml"
  success "Markdownlint config linked"
fi

# --- Summary ---
echo ""
info "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Open a new terminal or run: source ~/.zshrc"
echo "  2. Start tmux and install plugins: tmux, then press \` + Ctrl-I"
echo "  3. Open nvim — plugins will auto-install on first launch"
echo "  4. Run :Copilot auth in nvim to authenticate GitHub Copilot"
echo "  5. Edit git config: nvim ~/.config/git/config (set email, GPG key)"
echo "  6. Run 'claude' to authenticate Claude Code via OAuth"
echo ""
