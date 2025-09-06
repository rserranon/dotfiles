# dotfiles

## Structure of the project

```
.
├── README.md
├── alacritty
│   └── alacritty.toml
├── aliases
│   └── aliases
├── homebrew
│   ├── prerequisites-minimal.txt
├── nvim
│   └── nvim
├── osx
│   └── disable-cmd-Q.workflow
├── starship
│   └── starship.toml
├── tmux
│   └── tmux
│       ├── README.md
│       ├── tmux.conf
│       └── tmux.reset
└── zsh
    └── .zshrc 
```



## Installation

1. First install homebrew
```
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install stow
```shell
> brew install stow
```

3. Clone dotfiles (this repository)

```shell
> git clone https://github.com/rserranon/dotfiles.git
```

4. Create .config directory in $HOME
```shell
>mkdir .config
```

5. enter dotfiles directory
 dotfiles
```shell
> cd dotfiles
```

6. Install dotfiles symlinks using stow
```shell
dotfiles> stow */ -v2
```

7. Install an individual directory (optional)
```shell
dotfiles> stow <directory> -v2
```

8. Install hombrew packages
```shell
dotfiles>xargs brew install < homebrew/prerequisites-minimal.txt
```

9. Start TMUX

```shell
> tmux
```

10. Install Tmx plugins

```shell
# leader is `
> <leader> <ctrl> I
```

11. Create minimal .zshrc file
## VIP > [Note]

**Since there is no a standard and easy way for Mac to read the .zshrc file from $HOME/.config , we have to create a minimal $HOME/.zshrc file**

```shell
# source our dotfiles .zshrc file
source ~/dotfiles/.zshrc
```

