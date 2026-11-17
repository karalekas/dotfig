#!/bin/sh
###############################################################################
# Usage: yum.sh
#
# Install yum packages
#
# Requires: None
###############################################################################

echo "Installing yum packages..."
cat yum-packages.txt | xargs sudo yum install -y
