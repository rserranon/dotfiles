#!/bin/zsh

# Define the dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# Define the target config directory
CONFIG_DIR="$HOME/.config"

# Create symlinks for all directories except 'zsh'
for dir in $DOTFILES_DIR/*; do
  if [[ -d "$dir" && "$(basename "$dir")" != "zsh" ]]; then
    stow -t "$CONFIG_DIR" "$(basename "$dir")" -d "$DOTFILES_DIR"
  fi
done

# Create the symlink for .zshrc
ZSH_DIR="$DOTFILES_DIR/zsh"
if [[ -d "$ZSH_DIR" && -f "$ZSH_DIR/.zshrc" ]]; then
  ln -sf "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
else
  echo "Error: .zshrc not found in $ZSH_DIR"
fi

# Verify the symlinks
echo "Symlinks in $CONFIG_DIR:"
ls -l "$CONFIG_DIR"
echo "Symlink for .zshrc:"
ls -l "$HOME/.zshrc"
