#!/bin/sh
###############################################################################
# Usage: pycharm.sh
#
# Install pycharm settings
#
# Order: After cask and dotfile installation
#
# Requires: None
###############################################################################

ln -s "$HOME/.pycharm" "$HOME/Library/Preferences/PyCharm2017.2/settings.jar"
