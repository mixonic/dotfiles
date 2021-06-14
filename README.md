Built on:

* https://github.com/chriskempson/base16-shell
* And more.

## Installation

```
# On macOS
brew install vim fd the_silver_searcher cmake boost tmux fzf bash-completion git

# On Ubuntu
apt install rg fd-find silversearcher-ag cmake tmux fzf bash-completion git

# Clone this repo
git clone git@github.com:mixonic/dotfiles.git ~/.dotfiles

# If using bash:
echo "source ~/.dotfiles/bash.sh" >> ~/.bash_profile

# If using zsh:
echo "source ~/.dotfiles/zsh.sh" >> ~/.zshrc

# The rest of it
curl https://get.volta.sh | bash
volta install node
echo "source-file ~/.dotfiles/tmux.conf" >> ~/.tmux.conf
echo "so ~/.dotfiles/vimrc" >> ~/.vimrc
echo -e "[include]\n  path = ~/.dotfiles/gitconfig" >> ~/.gitconfig
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
vim +PlugInstall
source .bash_profile
base16_railscasts
```

### Notes

You can create a `~/.gitconfig.local` for any local git config overrides. It
is automatically included.
