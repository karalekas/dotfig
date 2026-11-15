#!/bin/zsh
###############################################################################
# ZSH login file
#
# /etc/zprofile runs path_helper after .zshenv, which moves our PATH entries
# behind the system ones. Re-apply them so they win again.
###############################################################################

source "$HOME/.zsh/path.zsh"
