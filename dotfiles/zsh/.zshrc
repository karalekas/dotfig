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

# oh-my-zsh
ZSH_CUSTOM="$HOME/.zsh"
ZSH_THEME="karalekas"
ZSH_TMUX_AUTOSTART=true
plugins=(tmux zsh-syntax-highlighting)
export ZSH="$HOME/.oh-my-zsh"
source "$ZSH/oh-my-zsh.sh"
