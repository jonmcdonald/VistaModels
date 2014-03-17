#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/qt-everywhere-opensource-src-$VER_QT

if [ "$QT_MAJOR_VER" == "4.8" ]; then
./configure -embedded arm -xplatform qws/linux-arm-gnueabi-g++ -little-endian -prefix $SW_ROOT/packages/qt-$VER_QT -opensource -confirm-license
else
# Assume QT 5.x
# Currently no open gl library for our platform, when it's available we can enable -opengl es2
./configure -device linux-beagleboard-g++ -device-option CROSS_COMPILE=$CROSS_COMPILE -linuxfb -no-xcb -no-eglfs -no-kms -no-directfb -qpa linuxfb -opensource -confirm-license -optimized-qmake -reduce-exports -release -make libs -make examples -prefix $SW_ROOT/packages/qt-$VER_QT
fi

make -j 15

make install

