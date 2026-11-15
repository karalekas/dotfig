#!/bin/sh
###############################################################################
# Usage: keyboard.sh
#
# Change keyboard settings to increase key rate
#
# Order: After homebrew
#
# Requires: None
###############################################################################

if [ `defaults read -g InitialKeyRepeat` -eq 10 ]
then
    echo "InitialKeyRepeat is already set to 10, continuing..."
else
    echo "Setting the InitialKeyRepeat to 10..."
    defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
fi

if [ `defaults read -g KeyRepeat` -eq 1 ]
then
    echo "KeyRepeat is already set to 1, continuing..."
else
    echo "Setting KeyRepeat to 1..."
    defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
fi
