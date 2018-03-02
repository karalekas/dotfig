#!/bin/sh
################################################################################
# Usage: ./restore.sh
#
# Restore dotfiles from latest backup
#
# Requires: None
################################################################################

DOTFIG_HOME="$HOME/.dotfig"

if [ ! -d "$DOTFIG_HOME/backup" ]
then
    echo "No dotfig backups exist, exiting..."
fi

LATEST_BACKUP="$DOTFIG_HOME/backup/`ls -r $DOTFIG_HOME/backup/ | sed -n 1p`"

for DOTFILE in `ls -A $LATEST_BACKUP`
do
    if [ -e "$HOME/$DOTFILE" ]
    then
        echo "$HOME/$DOTFILE still exists, run make clean before restoring"
        exit 1
    fi
done

for DOTFILE in `ls -A $LATEST_BACKUP`
do
    echo "Restoring $LATEST_BACKUP/$DOTFILE to $HOME/$DOTFILE"
    if [ -f "$LATEST_BACKUP/$DOTFILE" ]
    then
        cp $LATEST_BACKUP/$DOTFILE $HOME/$DOTFILE
    elif [ -d "$LATEST_BACKUP/$DOTFILE" ]
    then
        cp -R $LATEST_BACKUP/$DOTFILE $HOME/$DOTFILE
    else
        echo "Unknown file type for $LATEST_BACKUP/$DOTFILE, exiting..."
    fi
done
