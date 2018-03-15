#!/bin/sh
###############################################################################
# Usage: chsh.sh
#
# Change shell to zsh
#
# Order: After homebrew
#
# Requires: None
###############################################################################

if [ `echo $SHELL` = "/bin/zsh" ]
then
    echo "Shell is already set to zsh, continuing..."
else
    echo "Setting shell to zsh..."
    chsh -s /bin/zsh
fi
