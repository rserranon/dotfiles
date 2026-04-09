---
name: dotfiles-check
description: Check dotfiles health - validate config files, keybindings, symlinks, and gitignore
---

# Dotfiles Health Check

Perform a comprehensive health check on the dotfiles repo at the current working directory:

1. Glob for all config files (*.conf, .zshrc, init.lua, *.json, *.toml, etc.)
2. Check for duplicate or conflicting keybindings across tmux, neovim, and shell
3. Verify .gitignore covers secrets files (.secrets, .env, *.key)
4. Confirm symlinks are consistent if using stow/symlink management
5. Check for stray/unused files in the repo
6. Verify all referenced plugins, paths, and tools exist
7. Report findings as a checklist with clear pass/fail status
