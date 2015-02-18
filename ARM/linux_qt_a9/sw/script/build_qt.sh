#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/qt-everywhere-opensource-src-$VER_QT

if [ "$VER_QT_MAJOR" == "4.8" ]; then

./configure -embedded arm -xplatform qws/linux-arm-gnueabi-g++ -little-endian -prefix $SW_ROOT/packages/release/qt-$VER_QT -confirm-license -no-glib -no-opengl -no-largefile -no-accessibility -no-openssl -no-gtkstyle -nomake tests -no-audio-backend -no-phonon -no-phonon-backend -no-webkit -no-script -no-scripttools -no-javascript-jit -no-nis -no-qt3support -qt-sql-sqlite -qt-zlib -no-gif -no-libtiff -qt-libpng -no-libmng -qt-libjpeg -qt-freetype -opensource -no-multimedia -nomake docs -nomake tools

make -j 15

make install

else

cp -rv $SW_ROOT/qt5_patches/linux-vista-g++ qtbase/mkspecs/devices

export SW_ROOT

./configure -v -opensource -confirm-license -release -sysroot $SW_ROOT/sdcard/sysroot -device linux-vista-g++ -device-option CROSS_COMPILE=$CROSS_COMPILE -prefix /usr/local/qt5 -no-sql-psql -no-sql-mysql -no-sql-odbc -no-sql-tds -no-sql-oci -no-sql-db2 -no-sql-sqlite -no-sql-sqlite2 -no-sql-ibase -no-cups -no-nis -no-dbus -no-xcb -no-wayland -nomake examples -nomake tests -no-openssl -no-gtkstyle -no-audio-backend -no-gif -no-widgets -no-qml-debug -no-accessibility -no-eglfs

make -j 15

make -k -j 15 install

fi

