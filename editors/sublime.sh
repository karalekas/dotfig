#!/bin/sh
###############################################################################
# Usage: sublime.sh
#
# Install Sublime settings
#
# Order: After cask and dotfile installation
#
# Requires: None
###############################################################################

ln -s "$HOME/.sublime" "$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
