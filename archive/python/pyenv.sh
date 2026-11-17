#!/bin/sh
###############################################################################
# Usage: pyenv.sh
#
# Install pyenv (takes about 5 minutes)
#
# Requires (Mac): curl, readline, xz
# Requires (Centos): bzip2-devel, curl, libffi-devel, llvm, lzma,
#   ncurses-devel, openssl-devel, readline-devel, sqlite-devel, tkinter,
#   wget, xz, zlib-devel
# Requires (Ubuntu): build-essential, curl, libbz2-dev, libncurses5-dev,
#   libncursesw5-dev, libreadline-dev, libsqlite3-dev, libssl-dev
#   llvm, tk-dev, wget, xz-utils, zlib1g-dev
###############################################################################

if [ ! -d "$HOME/.pyenv" ]
then
    echo "Pyenv does not exist, installing now... (this takes about 5 minutes)"
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    echo "Installing Python 3.8.5..."
    pyenv install 3.8.5
    pyenv rehash
    pyenv global 3.8.5
    echo "Installation complete!"
else
    echo "Pyenv already exists, continuing..."
fi
