#!/bin/bash

SW_ROOT=$(dirname $0)/..

source $SW_ROOT/setup.sh

mkdir -p $SW_ROOT/packages

cd $SW_ROOT/packages


if [ ! -f linux-$VER_LINUX.tar.xz ]; then
	wget ftp://ftp.kernel.org/pub/linux/kernel/v3.x/testing/linux-$VER_LINUX.tar.xz
fi

if [ ! -f busybox-$VER_BUSYBOX.tar.bz2 ]; then
	wget http://www.busybox.net/downloads/busybox-$VER_BUSYBOX.tar.bz2
fi

if [ ! -f dropbear-$VER_DROPBEAR.tar.bz2 ]; then
	wget https://matt.ucc.asn.au/dropbear/dropbear-$VER_DROPBEAR.tar.bz2 
fi

#if [ ! -f MesaLib-$VER_MESA3D.tar.bz2 ]; then
#	wget ftp://ftp.freedesktop.org/pub/mesa/$VER_MESA3D/MesaLib-$VER_MESA3D.tar.bz2
#	wget http://cgit.freedesktop.org/xorg/proto/glproto/snapshot/glproto-1.4.17.tar.gz
#fi

if [ ! -f qt-everywhere-opensource-src-$VER_QT.tar.gz ]; then
	wget http://download.qt-project.org/official_releases/qt/$VER_QT_MAJOR/$VER_QT/single/qt-everywhere-opensource-src-$VER_QT.tar.gz
fi

if [ ! -d linux-$VER_LINUX ]; then
	tar xvf linux-$VER_LINUX.tar.xz
fi

if [ ! -d busybox-$VER_BUSYBOX ]; then
	tar xvf busybox-$VER_BUSYBOX.tar.bz2
fi

if [ ! -d dropbear-$VER_DROPBEAR ]; then
	tar xvf dropbear-$VER_DROPBEAR.tar.bz2
fi

#if [ ! -d Mesa-$VER_MESA3D ]; then
#	tar xvf MesaLib-$VER_MESA3D.tar.bz2
#	tar xvf glproto-1.4.17.tar.gz
#fi

if [ ! -d qt-everywhere-opensource-src-$VER_QT ]; then
	tar xvf qt-everywhere-opensource-src-$VER_QT.tar.gz
fi


