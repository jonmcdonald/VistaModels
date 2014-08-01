#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

mkdir -p $SW_ROOT/packages

cd $SW_ROOT/packages


if [ ! -f linux-$VER_LINUX.tar.xz ]; then
	wget ftp://ftp.kernel.org/pub/linux/kernel/v3.x/linux-$VER_LINUX.tar.xz
fi

if [ ! -f busybox-$VER_BUSYBOX.tar.bz2 ]; then
	wget http://www.busybox.net/downloads/busybox-$VER_BUSYBOX.tar.bz2
fi

if [ ! -f dropbear-$VER_DROPBEAR.tar.bz2 ]; then
	wget https://matt.ucc.asn.au/dropbear/dropbear-$VER_DROPBEAR.tar.bz2 
fi

if [ ! -f MesaLib-$VER_MESA3D.tar.bz2 ]; then
	wget ftp://ftp.freedesktop.org/pub/mesa/$VER_MESA3D/MesaLib-$VER_MESA3D.tar.bz2
fi

if [ ! -f libdrm-$VER_DRM.tar.gz ]; then
	wget http://dri.freedesktop.org/libdrm/libdrm-$VER_DRM.tar.gz 
fi

if [ ! -f expat-$VER_EXPAT.tar.gz ]; then
	wget http://fossies.org/linux/www/expat-2.1.0.tar.gz
fi

#if [ ! -f SDL-$VER_SDL.tar.gz ]; then
#	wget http://www.libsdl.org/release/SDL-$VER_SDL.tar.gz
#fi

if [ ! -f zlib-$VER_ZLIB.tar.gz ]; then
	wget http://zlib.net/zlib-$VER_ZLIB.tar.gz
fi

if [ ! -f openssl-$VER_OPENSSL.tar.gz ]; then
	wget https://www.openssl.org/source/openssl-$VER_OPENSSL.tar.gz
fi

if [ ! -f openssh-$VER_OPENSSH.tar.gz ]; then
	wget http://mirror.ox.ac.uk/pub/OpenBSD/OpenSSH/portable/openssh-$VER_OPENSSH.tar.gz
fi

if [ "$VER_QT_MAJOR" == "4.8" ]; then
	if [ ! -f qt-everywhere-opensource-src-$VER_QT.tar.gz ]; then
		wget http://download.qt-project.org/official_releases/qt/$VER_QT_MAJOR/$VER_QT/qt-everywhere-opensource-src-$VER_QT.tar.gz
	fi
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

if [ ! -d Mesa-$VER_MESA3D ]; then
	tar xvf MesaLib-$VER_MESA3D.tar.bz2
fi

if [ ! -d libdrm-$VER_DRM ]; then
	tar xvf libdrm-$VER_DRM.tar.gz
fi

if [ ! -d expat-$VER_EXPAT ]; then
	tar xvf expat-$VER_EXPAT.tar.gz
fi

#if [ ! -d SDL-$VER_SDL ]; then
#	tar xvf SDL-$VER_SDL.tar.gz
#fi

if [ ! -d zlib-$VER_ZLIB ]; then
	tar xvf zlib-$VER_ZLIB.tar.gz
fi

if [ ! -d openssl-$VER_OPENSSL ]; then
	tar xvf openssl-$VER_OPENSSL.tar.gz
fi

if [ ! -d openssh-$VER_OPENSSH ]; then
	tar xvf openssh-$VER_OPENSSH.tar.gz
fi

if [ "$VER_QT_MAJOR" == "4.8" ]; then
	if [ ! -d qt-everywhere-opensource-src-$VER_QT ]; then
		tar xvf qt-everywhere-opensource-src-$VER_QT.tar.gz
	fi
fi



mkdir -p $SW_ROOT/tools

cd $SW_ROOT/tools

if [ ! -f autoconf-$VER_AUTOCONF.tar.xz ]; then
	wget ftp://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz
fi

if [ ! -f automake-$VER_AUTOMAKE.tar.xz ]; then
	wget ftp://ftp.gnu.org/gnu/automake/automake-$VER_AUTOMAKE.tar.xz
fi

if [ ! -f pkg-config-$VER_PKGCONFIG.tar.gz ]; then
	wget http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz
fi

if [ ! -f libtool-$VER_LIBTOOL.tar.xz ]; then
	wget ftp://ftp.gnu.org/gnu/libtool/libtool-$VER_LIBTOOL.tar.xz
fi

if [ ! -d autoconf-$VER_AUTOCONF ]; then
	tar xvf autoconf-$VER_AUTOCONF.tar.xz
fi

if [ ! -d automake-$VER_AUTOMAKE ]; then
	tar xvf automake-$VER_AUTOMAKE.tar.xz
fi

if [ ! -d pkg-config-$VER_PKGCONFIG ]; then
	tar xvf pkg-config-0.28.tar.gz
fi

if [ ! -d libtool-$VER_LIBTOOL ]; then
	tar xvf libtool-$VER_LIBTOOL.tar.xz
fi


echo "*** fetch.sh COMPLETED"

