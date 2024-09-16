# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#
# Debug
print "..loading .zshrc"

# Yarn path
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# Homebrew path
export PATH="/opt/homebrew/:$PATH" 
# Node version manager path
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Rustup path
export PATH="$HOME/.cargo/bin:$PATH" 

# Config path
export XDG_CONFIG_DIRS="$HOME/.config/"

# tmux plugin manager path
export TMUX_PLUGIN_MANAGER_PATH=~/.tmux/plugins/

# Configure zsh history file
#set history size
export HISTSIZE=100000
#save history after logout
export SAVEHIST=100000
#history file
export HISTFILE=~/.zsh_history
#append into history file
setopt INC_APPEND_HISTORY
setopt extended_history       # record timestamp of command in HISTFILE
setopt HIST_SAVE_NO_DUPS
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward


# Plugins configuration
#  zsh-vi-mode
# The plugin will auto execute this zvm_config function
zvm_config() {
  # Retrieve default cursor styles
  local icur=$(zvm_cursor_style $ZVM_INSERT_MODE_CURSOR)

  # Append your custom color for your cursor
  ZVM_INSERT_MODE_CURSOR=$icur'\e\e]12;orange\a'
}
# Third party add-ons
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Set up fzf key bindings and fuzzy completion
#
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
source <(fzf --zsh)



# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
if [ -f $HOME/dotfiles/aliases/aliases ]; then
  source $HOME/dotfiles/aliases/aliases
fi

# Load starship configuration
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# Load zsh-autosuggestions
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 
    # change suggestion color
    # ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=208'
fi
#
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Check if zsh-autosuggestions is loaded
if [[ $? -eq 0 ]]; then
    echo "zsh-autosuggestions loaded successfully"
else
    echo "Failed to load zsh-autosuggestions"
fi
# Ensure zsh-autosuggestions is loaded correctly
autoload -U add-zsh-hook
add-zsh-hook precmd _zsh_autosuggest_start

# Debug
print "..finished loading .zshrc"
