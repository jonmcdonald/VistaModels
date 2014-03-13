#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/qt-everywhere-opensource-src-4.8.5

./configure -embedded arm -xplatform qws/linux-arm-gnueabi-g++ -little-endian -prefix $SW_ROOT/packages/qt-4.8.5

make -j 15

make install

