#!/bin/sh
###############################################################################
# Usage: pyenv.sh
#
# Install pyenv
#
# Requires (Mac): curl, readline, xz
# Requires (Ubuntu): build-essential, curl, libbz2-dev, libncurses5-dev,
#   libncursesw5-dev, libreadline-dev, libsqlite3-dev, libssl-dev
#   llvm, tk-dev, wget, xz-utils, zlib1g-dev
###############################################################################

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
pyenv install 3.6.3
pyenv install 2.7.14
pyenv rehash
pyenv global 3.6.3 2.7.14
