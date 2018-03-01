#!/bin/zsh
###############################################################################
# ZSH configuration file
###############################################################################

# completion
autoload bashcompinit && bashcompinit

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# vim
export VISUAL=vim
export EDITOR="$VISUAL"
