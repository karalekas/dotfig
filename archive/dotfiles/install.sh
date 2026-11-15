#!/bin/sh
################################################################################
# Usage: ./install.sh
#
# Install dotfiles for each subdirectory
#
# Requires: stow
################################################################################

DOTFIG_HOME="$HOME/.dotfig"
DOTFIG_BACKUP="$DOTFIG_HOME/backup/`date "+%F_%T"`"

back_up_dotfiles () {
    DIR=$1
    echo "Backing up $DIR dotfiles"
    for DOTFILE in `ls -A $DIR`
    do
        if [ -e "$HOME/$DOTFILE" ]
        then
            if [ ! -d "$DOTFIG_BACKUP" ]
            then
                echo "Making dotfig backup directory $DOTFIG_BACKUP"
                mkdir -p $DOTFIG_BACKUP
            fi
            echo "Backing up $HOME/$DOTFILE to $DOTFIG_BACKUP/$DOTFILE"
            if [ -f "$HOME/$DOTFILE" ]
            then
                cp $HOME/$DOTFILE $DOTFIG_BACKUP/$DOTFILE
                rm $HOME/$DOTFILE
            elif [ -d "$HOME/$DOTFILE" ]
            then
                cp -HR $HOME/$DOTFILE $DOTFIG_BACKUP/$DOTFILE
                rm -rf $HOME/$DOTFILE
            else
                echo "Unknown file type for $HOME/$DOTFILE, exiting..."
                exit 1
            fi
        fi
    done
}

stow_dotfiles () {
    DIR=$1
    echo "Installing $DIR dotfiles..."
    stow -t $HOME $DIR
}

if [ ! -d "$DOTFIG_HOME" ]
then
    echo "Making dotfig home directory $DOTFIG_HOME"
    mkdir $DOTFIG_HOME
fi

for DIR in `ls`
do
    if [ -d "$DIR" ]
    then
        back_up_dotfiles $DIR
        stow_dotfiles $DIR
    fi
done
