#!/bin/sh
###############################################################################
# Usage: install_sbcl.sh [VERSION]
#
# Upgrade sbcl from source
#
# Requires (Mac): xcode tools (make, zlib.sh)
# Requires (Ubuntu): build-essential (make), libz-dev (zlib.h), sbcl, wget
###############################################################################

# check for version
DEFAULT_SBCL_VERSION=1.4.3
if [ -z "$1" ]
then
    SBCL_VERSION=$DEFAULT_SBCL_VERSION
else
    SBCL_VERSION=$1
fi

# download sbcl
cd /tmp
wget -O sbcl.tar.bz2 http://prdownloads.sourceforge.net/sbcl/sbcl-$SBCL_VERSION-source.tar.bz2
mkdir sbcl
tar -xf sbcl.tar.bz2 -C sbcl --strip-components=1

# install sbcl
cd /tmp/sbcl
bash make.sh --fancy
bash install.sh
rm /tmp/sbcl.tar.bz2
rm -rf /tmp/sbcl
