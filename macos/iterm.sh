#!/bin/sh
###############################################################################
# Usage: iterm.sh
#
# Install iTerm2 profile
#
# Order: After cask and dotfile installation
#
# Requires: None
###############################################################################

if [ `defaults read com.googlecode.iterm2.plist PrefsCustomFolder` = "~/.iterm" ]
then
    echo "iTerm2 already configured with a custom preferences folder, continuing..."
else
    echo "Setting the iTerm2 custom preferences folder to ~/.iterm..."
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm"
fi

if [ `defaults read com.googlecode.iterm2.plist LoadPrefsFromCustomFolder` -eq 1 ]
then
    echo "iTerm2 already loading preferences from a custom folder, continuing..."
else
    echo "Telling iTerm2 to load its preferences from a custom folder..."
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi
