#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

export PKG_CONFIG_PATH=$SW_ROOT/packages/systemroot/lib/pkgconfig

cd $SW_ROOT/packages/SDL-$VER_SDL
./configure --target=arm-linux --host=arm-linux --prefix=$SW_ROOT/packages/sysroot --enable-audio=no --enable-joystick=yes --enable-cdrom=no --enable-oss=no --enable-alsa=no --disable-alsatest --enable-esd=no -enable-pulseaudio=no --enable-arts=no --enable-nas=no --enable-diskaudio=no --enable-mintaudio=no --enable-video-x11=no --enable-dga=no --enable-video-x11-dgamouse=no --enable-video-x11-vm=no --enable-video-x11-xv=no --enable-video-x11-xinerama=no --enable-video-x11-xme=no --enable-video-x11-xrandr=no --enable-video-photon=no --enable-video-directfb=no --enable-video-ps2gs=no --enable-video-ps3=no --enable-video-svga=no --enable-video-vgl=no --enable-video-wscons=no --enable-video-xbios=no --enable-video-gem=no --enable-input-tslib=no --enable-directx=no --enable-video-opengl=no CC=arm-none-linux-gnueabi-gcc

make -j 15
make install

#./ioquake3.arm +set s_initsound 0

