#!/bin/sh
###############################################################################
# Usage: expokit.sh
#
# Install expokit
#
# Requires: gfortran, tar, wget
###############################################################################

# download expokit
cd /tmp
wget https://www.maths.uq.edu.au/expokit/expokit.tar.gz
tar -xf expokit.tar.gz
rm expokit.tar.gz

# compile shared / dynamic library
cd /tmp/expokit/fortran
gfortran -fPIC -c expokit.f
if [ `uname` = "Linux" ]
then
    gfortran -shared -o expokit.so expokit.o -lblas -L/usr/lib/libblas.so -llapack -L/usr/lib/liblapack.so
    mv expokit.so /usr/local/lib
elif [ `uname` = "Darwin" ]
then
    gfortran -dynamiclib -o expokit.dylib expokit.o -lblas -llapack
    mv expokit.dylib /usr/local/lib
else
    echo "Platform `uname` not supported, exiting..."
fi
rm -rf /tmp/expokit
