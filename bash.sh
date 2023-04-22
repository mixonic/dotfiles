# Git
export EDITOR=vim
export CLICOLOR=1

# default open files in OSX is very low
# ulimit -n 2048

# default allowable memory for node is very low
# export NODE_OPTIONS=--max_old_space_size=5120

# Volta setup
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

source ~/.dotfiles/bash/aliases.sh
source ~/.dotfiles/bash/base16.sh
source ~/.dotfiles/bash/prompt.sh
