dotfiles
===================
![screenshot](https://github.com/rserranon/dotfiles/blob/master/screenshot.png)
(Here's what my setup looks like. Vim/Zsh/Oh-My-Zsh/Tmux)

## New to Vim?
+ [Learning Vim in a Week](https://mikecoutermarsh.com/boston-vim-learning-vim-in-a-week/)
+ [Upcase: The Art of Vim](https://upcase.com/vim) 


## Installation 

Clone this repo (or your own fork!) to your **home** directory (`/Users/username`).
```
git clone https://github.com/rserranon/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

### Recommended tools

**iterm2**

On OS X Use iterm2 instead of Terminal: http://iterm2.com/

Install fonts:
[Ubuntu Mono Derivative Powerline Font](https://github.com/powerline/fonts/archive/master.zip)

1. download the font archive, and unzip it. Go to fonts-master/UbuntuMono/ and install each of the four TTFs: simply double-click and let Font Book install them for you.
2. Open Terminal, then navigate to Terminal Preferences > Profiles > Font and click the Change button.
3. Select Ubuntu Mono derivative Powerline and set the font size to your liking.
4. Close preferences, and quit Terminal.

**zsh**

OS X:
```
brew install zsh

zsh --version
```

Linux:
```
sudo apt-get update
sudo apt-get install zsh 
```


**oh-my-zsh**

clone the repository under the ~/ directory
```
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
```

**Tmux**
   
OS X:
```
$ brew install Tmux 
```

to set up the Tmux environment (several windows and panels) run:

```
./.setTmuxGo
```

Linux:

```
sudo apt-get update
sudo apt-get install tmux
```

**Marked**

a low-level markdown compiler for parsing markdown without cachig or blocking for long periods of time

Istallation: 

```
npm install -g marked
```


**ENTR(1)**

entr -- run arbitrary commands when files change

Update README.html everytime README.md changes

Installation OSX:

``` 
brew install entr

ls README.md | entr -s 'marked README.md > README.html'

```

-s option uses the shell interpreter specified by the $SHELL environment variable. In our case /bin/zsh 

Open, generate/update and refresh README.html in broswer everytime README.md changes

```
ls README.md|entr -s 'marked README.md > README.html ; open README.html'
```

Using reload-browser (better option to maintain cursor focus on vim editor), requires [reload-browser](https://github.com/rserranon/reload-browser)

```
ls README.md|entr -s 'marked README.md > README.html ; reload-browser safari README'
```

#### Contributing
Did you have trouble installing this? Could I make the documentation better? 
Let me know [@StartupsPal](http://twitter.com/StartupsPal). Or please fork & create a pull request with your suggestions.
