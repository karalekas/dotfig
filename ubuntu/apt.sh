#!/bin/sh
###############################################################################
# Usage: apt.sh
#
# Install apt packages
#
# Requires: None
###############################################################################

echo "Installing apt packages..."
cat apt-packages | xargs sudo apt-get install -y
