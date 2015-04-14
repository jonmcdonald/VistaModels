#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

cd $SW_ROOT/sdcard

export SYSROOT=$SW_ROOT/sdcard/sysroot

mkdir -p template/root
cp -r template/* sysroot

mkdir -p $SYSROOT/lib/modules/$VER_LINUX
cp `find $SW_ROOT/kernel_modules -name "*.ko" -print` $SYSROOT/lib/modules/$VER_LINUX
sed -i 's/VER_LINUX/'"$VER_LINUX"'/' $SYSROOT/etc/init.d/rcS

sed -i 's/.*LCD_CONSOLE.*/tty1\:\:once\:\/root\/cluster \-platform linuxfb/' $SYSROOT/etc/inittab

rm -rf sysroot.ext2

echo "Generating sysroot.ext2..."
$SW_ROOT/packages/genext2fs-1.4.1/genext2fs -q -b 500000 -d $SYSROOT $SW_ROOT/sdcard/sysroot.ext2
echo "Completed..."

