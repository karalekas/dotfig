#!/bin/sh
################################################################################
# Usage: ./install.sh
#
# Install dotfiles for each subdirectory
#
# Requires: stow
################################################################################

for DIR in `ls`
do
    if [ -d $DIR ]
    then
        echo "Installing $DIR dotfiles..."
        stow -t $HOME $DIR
    fi
done
