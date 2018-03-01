#!/bin/sh
###############################################################################
# Usage: pyenv.sh
#
# Install pyenv
#
# Requires: curl
###############################################################################

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
pyenv install 3.6.3
pyenv install 2.7.14
pyenv rehash
pyenv global 3.6.3 2.7.14