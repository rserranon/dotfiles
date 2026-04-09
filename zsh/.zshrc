# --- Secrets (not committed) ---
[[ -f "$HOME/.config/secrets" ]] && source "$HOME/.config/secrets"

# --- Environment ---
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# tmux plugin manager
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/"

# --- History ---
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# --- Plugins ---

# zsh-vi-mode
zvm_config() {
  local icur=$(zvm_cursor_style $ZVM_INSERT_MODE_CURSOR)
  ZVM_INSERT_MODE_CURSOR=$icur'\e\e]12;orange\a'
}
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# fzf key bindings and fuzzy completion
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
source <(fzf --zsh)

# --- Aliases ---
if [ -f "$XDG_CONFIG_HOME/aliases" ]; then
  source "$XDG_CONFIG_HOME/aliases"
fi

# --- Starship prompt ---
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
eval "$(starship init zsh)"

# --- zsh-autosuggestions ---
if [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=208'
fi
