# dotfiles

## Structure of the project

## Installation

use this command to install individual symlinks

```
> stow <directory> -v2
```

use this command to install all symlinks

```
> stow */ -v2
```

## Usage

Start TMUX
```
> tmux
```

Install Tmx plugins

```shell
# leader is `
> <leader> I
```
## VIP > [Note]

Since there is no a standard and easy way for Mac to read the .zshrc file from $HOME/.config , we have to create a minimal $HOME/.zshrc file

```shell
# sorce our dotfiles .zshrc file
source ~/dotfiles/zsh-old/.zshrc
```
