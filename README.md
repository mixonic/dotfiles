Built on:

* https://github.com/chriskempson/base16-shell
* And more.

## Installation

```
brew install vim fd the_silver_searcher cmake boost tmux
brew install bash-completion # optional
brew install git # suggested, required for bash completion
git clone git@github.com:mixonic/dotfiles.git ~/.dotfiles
# if using bash:
echo "source ~/.dotfiles/bash.sh" >> ~/.bash_profile
# if using zsh:
echo "source ~/.dotfiles/zsh.sh" >> ~/.zshrc
echo "source-file ~/.dotfiles/tmux.conf" >> ~/.tmux.conf
echo "so ~/.dotfiles/vimrc" >> ~/.vimrc
echo -e "[include]\n  path = ~/.dotfiles/gitconfig" >> ~/.gitconfig
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
git clone https://github.com/VundleVim/Vundle.vim.git ~/.dotfiles/vim/bundle/Vundle.vim
vim +PluginInstall +qall
cd ~/.dotfiles/vim/bundle/cpsm/; ./install.sh
source .bash_profile
base16_railscasts
```

### Notes

You can create a `~/.gitconfig.local` for any local git config overrides. It
is automatically included.
