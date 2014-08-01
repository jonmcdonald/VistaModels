#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

cd $SW_ROOT/ramdisk

rm -f `find . -name "*~" -print`

rm -rf sysroot
rm -f initrd.cpio.gz
mkdir sysroot

export SYSROOT=$SW_ROOT/ramdisk/sysroot

mkdir -p template/root

cp -r template/* sysroot

source $SW_ROOT/script/setup_kernel.sh
make -C ../packages/linux-$VER_LINUX headers_install INSTALL_HDR_PATH=$SYSROOT/usr

source $SW_ROOT/script/setup_apps.sh
make -C ../packages/busybox-$VER_BUSYBOX install CONFIG_PREFIX=$SYSROOT

cp -ar $TOOL_CHAIN/$TARGET/libc/etc $SYSROOT
cp -ar $TOOL_CHAIN/$TARGET/libc/lib $SYSROOT
cp -ar $TOOL_CHAIN/$TARGET/libc/sbin $SYSROOT
cp -ar $TOOL_CHAIN/$TARGET/libc/usr $SYSROOT

cp ../packages/dropbear-$VER_DROPBEAR/dropbear $SYSROOT/sbin
cp ../packages/dropbear-$VER_DROPBEAR/dbclient $SYSROOT/sbin
cp ../packages/dropbear-$VER_DROPBEAR/dropbearkey $SYSROOT/sbin
cp ../packages/dropbear-$VER_DROPBEAR/scp $SYSROOT/bin

QT=../packages/release/qt-$VER_QT
if [ -d $QT ]; then
	echo "Including QT $VER_QT"
	mkdir -p $SYSROOT/qt
	cp -r $QT/lib $SYSROOT/qt
	mkdir -p $SYSROOT/qt/demos
	mkdir -p $SYSROOT/qt/examples/widgets
	mkdir -p $SYSROOT/qt/examples/painting
	cp -r $QT/demos/embedded $SYSROOT/qt/demos
	cp -r $QT/demos/deform $SYSROOT/qt/demos
	cp -r $QT/demos/pathstroke $SYSROOT/qt/demos
	cp -r $QT/examples/widgets/wiggly $SYSROOT/qt/examples/widgets
	cp -r $QT/examples/painting/concentriccircles $SYSROOT/qt/examples/painting
	sed -i 's/.*LCD_CONSOLE.*/tty1\:\:once\:sh \-c \"source \/etc\/profile\; cd \/qt\/demos\/embedded\/fluidlauncher\; \.\/fluidlauncher -qws"/' $SYSROOT/etc/inittab
	cp $SW_ROOT/ramdisk/misc/config.xml $SYSROOT/qt/demos/embedded/fluidlauncher
fi

RELEASE=../packages/sysroot
if [ -d $RELEASE ]; then
	mkdir -p $SYSROOT/usr/local
	cp -r $RELEASE/* $SYSROOT/usr/local
fi

if [ -f $SW_ROOT/gears/es1gears ]; then
	cp $SW_ROOT/gears/es*gears $SYSROOT/usr/local/bin
fi

mkdir -p $SYSROOT/usr/libexec
cp ../packages/openssh-$VER_OPENSSH/sftp-server $SYSROOT/usr/libexec
cp $SYSROOT/usr/local/lib/libz.so.1 $SYSROOT/lib

mkdir -p $SYSROOT/lib/modules/$VER_LINUX
cp `find $SW_ROOT/kernel_modules -name "*.ko" -print` $SYSROOT/lib/modules/$VER_LINUX

#cp /mnt/store/data/demos/cluster/iviv3-meibp-m6/bin/fbdev_imx6/instrumentcluster3d_demo $SYSROOT/root

cd $SYSROOT 

# preserves links to busybox in /usr/bin /usr/sbin
# also preserves /usr/bin/gdb*

find . | grep -v '^./usr/' > ../sysroot.files
echo "./usr/lib" >> ../sysroot.files
find . | grep '^./usr/lib/lib.*\.so' >> ../sysroot.files
find usr/bin usr/sbin -type d -o -type l -o -name 'gdb*' >> ../sysroot.files
find usr/bin usr/sbin -type d -o -type l -o -name 'ldd*' >> ../sysroot.files

find lib >> ../sysroot.files
find usr/local >> ../sysroot.files
echo usr/libexec >> ../sysroot.files
echo usr/libexec/sftp-server >> ../sysroot.files

cat ../sysroot.files |  cpio -R root:root -o -H newc | gzip > ../initrd.cpio.gz
rm ../sysroot.files

