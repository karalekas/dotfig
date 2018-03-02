#!/bin/sh
################################################################################
# Usage: ./clean.sh
#
# Uninstall dotfiles
#
# Requires: stow
################################################################################

DOTFIG_HOME="$HOME/.dotfig"

function unstow_dotfiles() {
    DIR=$1
    echo "Uninstalling $DIR dotfiles..."
    stow -D -t $HOME $DIR
}

if [ ! -d "$DOTFIG_HOME" ]
then
    echo "The dotfig home directory $DOTFIG_HOME does not exist, exiting..."
    exit 1
fi

for DIR in `ls`
do
    if [ -d "$DIR" ]
    then
        unstow_dotfiles $DIR
    fi
done