#!/bin/sh
###############################################################################
# Usage: xcode.sh
#
# Install XCode tools
#
# Requires: None
###############################################################################

if [ `xcode-select -p | echo $?` -ne 0 ]
then
    echo "XCode tools are not installed, installing now..."
    xcode-select --install
else
    echo "XCode tools are already installed, continuing..."
fi
