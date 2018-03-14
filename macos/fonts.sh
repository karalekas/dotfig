#!/bin/sh
###############################################################################
# Usage: fonts.sh
#
# Install Deja Vu fonts
#
# Requires: tar, wget
###############################################################################

pushd /tmp
wget https://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-ttf-2.37.tar.bz2
tar -xvf dejavu-fonts-ttf-2.37.tar.bz2
cp dejavu-fonts-ttf-2.37/ttf/* ~/Library/Fonts
rm -rf dejavu-fonts-ttf-2.37
rm dejavu-fonts-ttf-2.37.tar.bz2
popd
