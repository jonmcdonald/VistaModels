#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

export PATH=$SW_ROOT/tools/build/bin\:$PATH

cd $SW_ROOT/tools/autoconf-$VER_AUTOCONF
./configure -prefix $SW_ROOT/tools/build 
make -j 15
make install

cd $SW_ROOT/tools/automake-$VER_AUTOMAKE
./configure -prefix $SW_ROOT/tools/build 
make -j 15
make install

cd $SW_ROOT/tools/pkg-config-$VER_PKGCONFIG
./configure -prefix $SW_ROOT/tools/build --with-internal-glib
make -j 15
make install

cd $SW_ROOT/tools/libtool-$VER_LIBTOOL
./configure -prefix $SW_ROOT/tools/build 
make -j 15
make install

