#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/cluster

$SW_ROOT/packages/qt5-host/bin/qmake

make

export SYSROOT=$SW_ROOT/sdcard/sysroot
cp cluster $SYSROOT/root

