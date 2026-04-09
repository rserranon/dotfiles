# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). All symlinks target `~/.config` (configured in `.stowrc`). Each top-level directory is a stow package.

## Key Commands

```bash
# Full install (idempotent)
./install.sh

# Link/relink a specific package
stow <package> --restow

# Link all packages
cd ~/dotfiles && stow */ -v2

# Install Homebrew packages
brew bundle --file=homebrew/Brewfile

# After tmux config changes, reload
tmux source-file ~/.config/tmux/tmux.conf
```

## Repository Architecture

### Stow Layout

Each directory maps directly to `~/.config/<dir>/`. Example: `nvim/nvim/init.lua` → `~/.config/nvim/init.lua`.

**Exceptions** (special symlink targets outside `~/.config`):
- `zsh/.zshrc` → macOS reads `~/.zshrc` directly; `install.sh` creates `~/.zshrc` that sources `~/dotfiles/zsh/.zshrc`
- `claude/CLAUDE.md` + `claude/settings.json` + `claude/local-marketplace` → `~/.claude/` (Claude Code config)
- `copilot/copilot-instructions.md` → `~/.copilot/`
- `.markdownlint.json` / `.markdownlint-cli2.yaml` → `~/`
- TPM → `~/.tmux/plugins/tpm` (installed via `git clone`)

### Config Packages

- **`nvim/`** — LazyVim-based Neovim. Plugins in `nvim/nvim/lua/plugins/`: `ai.lua` (Copilot, CopilotChat, Avante, Claude terminal), `lspconfig.lua`, `formatting.lua`, `nvimdap.lua`, `rustacean.lua`
- **`tmux/`** — TPM-managed. Prefix is backtick. `` ` ``+`a` opens Claude Code in a vertical split
- **`zsh/`** — Loads secrets from `~/.config/secrets` (not stowed; created manually). Sets `XDG_CONFIG_HOME`, `EDITOR`, `PATH`
- **`aliases/`** — Covers git, Unix, cargo, Bitcoin regtest/signet, AWS/RDS, and AI CLI tools
- **`git/`** — XDG-compliant (`~/.config/git/config`). Uses delta with gruvbox-dark theme and side-by-side diffs
- **`claude/`** — Global Claude Code config (CLAUDE.md, settings.json, local-marketplace). install.sh symlinks these to `~/.claude/` and installs the dotfiles-tools plugin

### Secrets

`~/.config/secrets` is sourced by `.zshrc` for API keys (`ANTHROPIC_API_KEY`, AWS credentials, etc.). This file is not in the repo.
