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

QT=../packages/qt-$VER_QT
if [ ! -d $QT ]; then
	echo "Please build the QT library: run 'script/build_qt.sh'"
else
	mkdir -p $SYSROOT/qt
	cp -r $QT/lib $SYSROOT/qt
	if [ "$VER_QT_MAJOR" == "4.8" ]; then
		mkdir -p $SYSROOT/qt/demos
		mkdir -p $SYSROOT/qt/examples/widgets
		mkdir -p $SYSROOT/qt/examples/painting
		cp -r $QT/demos/embedded $SYSROOT/qt/demos
		cp -r $QT/demos/deform $SYSROOT/qt/demos
		cp -r $QT/demos/pathstroke $SYSROOT/qt/demos
		cp -r $QT/examples/widgets/wiggly $SYSROOT/qt/examples/widgets
		cp -r $QT/examples/painting/concentriccircles $SYSROOT/qt/examples/painting
		sed -i 's/.*LCD_CONSOLE.*/tty1\:\:respawn\:sh \-c \"source \/etc\/profile\; cd \/qt\/demos\/embedded\/fluidlauncher\; \.\/fluidlauncher -qws"/' $SYSROOT/etc/inittab
	else
		cp -r $QT/plugins $SYSROOT/qt
		cp -r $QT/examples $SYSROOT/qt
	fi
fi

cd $SYSROOT 

# preserves links to busybox in /usr/bin /usr/sbin
# also preserves /usr/bin/gdb*

find . | grep -v '^./usr/' > ../sysroot.files
echo "./usr/lib" >> ../sysroot.files
find . | grep '^./usr/lib/lib.*\.so' >> ../sysroot.files
find usr/bin usr/sbin -type d -o -type l -o -name 'gdb*' >> ../sysroot.files
find usr/bin usr/sbin -type d -o -type l -o -name 'ldd*' >> ../sysroot.files

#find qt >> ../../sysroot.files

cat ../sysroot.files |  cpio -R root:root -o -H newc | gzip > ../initrd.cpio.gz
#rm ../sysroot.files


