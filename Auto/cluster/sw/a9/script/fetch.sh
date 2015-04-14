#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

mkdir -p $SW_ROOT/packages

cd $SW_ROOT/packages

if [ ! -f linux-$VER_LINUX.tar.xz ]; then
	wget ftp://ftp.kernel.org/pub/linux/kernel/v3.x/linux-$VER_LINUX.tar.xz
#	wget ftp://ftp.kernel.org/pub/linux/kernel/v4.x/linux-$VER_LINUX.tar.xz
fi

if [ ! -f busybox-$VER_BUSYBOX.tar.bz2 ]; then
	wget http://www.busybox.net/downloads/busybox-$VER_BUSYBOX.tar.bz2
fi

if [ ! -f dropbear-$VER_DROPBEAR.tar.bz2 ]; then
	wget https://matt.ucc.asn.au/dropbear/dropbear-$VER_DROPBEAR.tar.bz2 
fi

if [ ! -f zlib-$VER_ZLIB.tar.gz ]; then
	wget http://zlib.net/zlib-$VER_ZLIB.tar.gz
fi

if [ ! -f openssl-$VER_OPENSSL.tar.gz ]; then
	wget https://www.openssl.org/source/openssl-$VER_OPENSSL.tar.gz
fi

if [ ! -f openssh-$VER_OPENSSH.tar.gz ]; then
	wget http://mirror.ox.ac.uk/pub/OpenBSD/OpenSSH/portable/openssh-$VER_OPENSSH.tar.gz
fi

if [ ! -f qt-everywhere-opensource-src-$VER_QT.tar.xz ]; then
	wget http://download.qt-project.org/official_releases/qt/$VER_QT_MAJOR/$VER_QT/single/qt-everywhere-opensource-src-$VER_QT.tar.xz
fi

if [ ! -f genext2fs-1.4.1.tar.gz ]; then
	wget http://repository.timesys.com/buildsources/g/genext2fs/genext2fs-1.4.1/genext2fs-1.4.1.tar.gz
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

if [ ! -d zlib-$VER_ZLIB ]; then
	tar xvf zlib-$VER_ZLIB.tar.gz
fi

if [ ! -d openssl-$VER_OPENSSL ]; then
	tar xvf openssl-$VER_OPENSSL.tar.gz
fi

if [ ! -d openssh-$VER_OPENSSH ]; then
	tar xvf openssh-$VER_OPENSSH.tar.gz
fi

if [ ! -d qt-everywhere-opensource-src-$VER_QT ]; then
	tar xvf qt-everywhere-opensource-src-$VER_QT.tar.xz
fi

if [ ! -d genext2fs-1.4.1 ]; then
	tar xvf genext2fs-1.4.1.tar.gz
fi

echo "*** fetch.sh COMPLETED"

