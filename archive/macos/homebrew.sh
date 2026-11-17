#!/bin/sh
###############################################################################
# Usage: homebrew.sh
#
# Install Homebrew
#
# Requires: xcode-tools (curl, ruby)
###############################################################################

if [ `which brew > /dev/null ; echo $?` -ne 0 ]
then
    echo "Homebrew is not installed, installing now..."
    yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew is already installed, continuing..."
fi

echo "Installing brew formulae..."
cat brew-formulae | xargs brew install

echo "Installing cask formulae..."
cat cask-formulae | xargs brew cask install
