# dotfiles

Personal development environment managed with [GNU Stow](https://www.gnu.org/software/stow/). All symlinks target `$HOME/.config` as defined in `.stowrc`.

## What's Included

| Directory   | Description |
|------------|-------------|
| `alacritty/` | Terminal emulator config (JetBrains Mono, opacity, 256-color) |
| `aliases/`   | Shell aliases (git, unix, rust, bitcoin, AWS/RDS, AI tools) |
| `claude/`    | Claude Code global config (CLAUDE.md, settings.json, local marketplace) |
| `copilot/`   | Copilot CLI global custom instructions |
| `git/`       | Git config with delta, aliases, global gitignore |
| `homebrew/`  | Brewfile with all dependencies |
| `nvim/`      | Neovim (LazyVim) with AI plugins, LSP, DAP, formatters |
| `osx/`       | macOS-specific automations |
| `starship/`  | Starship prompt (Gruvbox Dark, AWS profile/region indicator) |
| `tmux/`      | Tmux config with TPM, session management, catppuccin |
| `zsh/`       | Zsh config with vi-mode, fzf, autosuggestions |

## Quick Install

```bash
git clone https://github.com/rserranon/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script is idempotent — safe to run multiple times.

## Manual Installation

1. Install Homebrew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install packages:
```bash
brew bundle --file=homebrew/Brewfile
```

3. Link dotfiles:
```bash
cd ~/dotfiles
stow */ -v2
```

4. Create minimal `~/.zshrc` (macOS doesn't read from `~/.config`):
```bash
echo 'source ~/dotfiles/zsh/.zshrc' > ~/.zshrc
```

5. Install tmux plugins:
```bash
# Start tmux, then press: ` + Ctrl-I
tmux
```

6. Set up Neovim — plugins install automatically on first launch.

## AI Workflow

### Neovim AI Plugins
- **GitHub Copilot** (`copilot.lua`): Inline AI completions, auto-triggered on `InsertEnter`
- **CopilotChat**: AI chat sidebar — `<leader>aa` to toggle, visual select + `<leader>ae` to explain
- **Avante**: Multi-model AI assistant (Claude, GPT, Copilot) — `<leader>av` to toggle

### Terminal AI
- `gcs` — GitHub Copilot suggest (shell commands)
- `gce` — GitHub Copilot explain (shell commands)
- `gcai` — generate conventional commit message from staged diff (via Copilot)

### Claude Code
- `cc` — `claude` (open Claude Code)
- `ccc` — `claude --continue` (resume last session)
- `ccr` — `claude --resume` (pick a past session)
- `ccp` — `claude --print` (non-interactive output)

### AWS & RDS
- `awswho` — show current AWS identity (`sts get-caller-identity`)
- `awsuse <profile>` — switch AWS profile and confirm identity
- `rdsls` — list RDS instances with endpoints
- `rdsstatus` — quick RDS instance status check
- `rds-ssm-tunnel <ec2-id> <rds-host>` — SSM port-forward to RDS/proxy
- `rds-ssh-tunnel <bastion> <rds-host>` — SSH tunnel to RDS/proxy
- Starship prompt shows active AWS profile and region

### Setup
```bash
# Authenticate GitHub Copilot CLI
gh auth login
gh extension install github/gh-copilot

# Authenticate Copilot in Neovim
nvim -c ":Copilot auth"

# Authenticate Claude Code
claude
```

## Testing

```bash
make test-dotfiles
```

Runs 6 test suites (116 checks total):

| Suite | What's checked |
|-------|----------------|
| JSON syntax | `claude/settings.json`, marketplace plugin configs |
| Zsh config | `zsh -n` syntax, brew plugin files, required binaries |
| Tmux config | Runtime syntax, duplicate keybindings, expected keys present |
| Neovim/Lua | `luac -p` on all 16 lua files, duplicate keymap detection, hardcoded paths |
| Tool availability | All Brewfile formulas + casks installed, key binaries in PATH |
| Stow layout | Package dirs, symlink targets, `~/.zshrc` bootstrap, tracked marketplace JSONs |

**When to run:**
- After modifying any config file
- After adding tools to the Brewfile
- On a new machine after `./install.sh`

## Key Bindings

### Tmux (prefix: `` ` ``)
| Key | Action |
|-----|--------|
| `` ` `` + `\|` | Split horizontal |
| `` ` `` + `-` | Split vertical |
| `` ` `` + `h/j/k/l` | Navigate panes |
| `` ` `` + `a` | Open Claude Code (vertical split) |
| `` ` `` + `p` | Floax floating pane |
| `` ` `` + `v` | Enter copy mode |
| `` ` `` + `o` | Session picker (sessionx) |
| `` ` `` + `Ctrl-I` | Install plugins |

### Neovim
| Key | Action |
|-----|--------|
| `<leader>aa` | Toggle Copilot Chat |
| `<leader>ac` | Open Claude Code terminal |
| `<leader>ae` | Explain selection (visual) |
| `<leader>af` | Fix selection (visual) |
| `<leader>ao` | Optimize selection (visual) |
| `<leader>ar` | Review selection (visual) |
| `<leader>at` | Generate tests (visual) |
| `<leader>ad` | Generate docs (visual) |
| `<leader>av` | Toggle Avante |
| `<space>b` | Toggle breakpoint |
| `F1-F5` | Debug controls |
