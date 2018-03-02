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

defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
