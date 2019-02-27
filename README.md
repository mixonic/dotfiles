Built on:

* https://github.com/chriskempson/base16-shell
* And more.

## Installation

```
brew install vim
brew install the_silver_searcher
brew install bash-completion # optional
brew install git # suggested, required for bash completion
brew install tmux
git clone git@github.com:mixonic/dotfiles.git ~/.dotfiles
# if using bash:
echo "source ~/.dotfiles/bash.sh" >> ~/.bash_profile
# if using zsh:
echo "source ~/.dotfiles/zsh.sh" >> ~/.zshrc
echo "source-file ~/.dotfiles/tmux.conf" >> ~/.tmux.conf
echo "so ~/.dotfiles/vimrc" >> ~/.vimrc
echo -e "[include]\n  path = ~/.dotfiles/gitconfig" >> ~/.gitconfig
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
echo -e "if filereadable(expand(\"~/.vimrc_background\"))\n  let
base16colorspace=256\n  source ~/.vimrc_background\nendif""
git clone https://github.com/VundleVim/Vundle.vim.git ~/.dotfiles/vim/bundle/Vundle.vim
vim +PluginInstall +qall
```

### Notes

You can create a `~/.gitconfig.local` for any local git config overrides. It
is automatically included.
