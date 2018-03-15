#!/bin/sh
###############################################################################
# Usage: pyenv.sh
#
# Install pyenv (takes about 10 minutes)
#
# Requires (Mac): curl, readline, xz
# Requires (Ubuntu): build-essential, curl, libbz2-dev, libncurses5-dev,
#   libncursesw5-dev, libreadline-dev, libsqlite3-dev, libssl-dev
#   llvm, tk-dev, wget, xz-utils, zlib1g-dev
###############################################################################

if [ ! -d "$HOME/.pyenv" ]
then
    echo "Pyenv does not exist, installing now... (this takes about 10 minutes)"
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    echo "Installing Python 3.6.3..."
    pyenv install 3.6.3
    echo "Installing Python 2.7.14..."
    pyenv install 2.7.14
    pyenv rehash
    pyenv global 3.6.3 2.7.14
    echo "Installation complete!"
else
    echo "Pyenv already exists, continuing..."
fi
