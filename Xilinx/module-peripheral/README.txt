Building this kernel module requires linux source/build tree be available.

LINUX=<path-to-linux-build-area>
ARCH=arm
CROSS_COMPILE=arm-none-eabi-

Call to build if above are set appropriatly:

> make -C $LINUX M=`pwd`

or just:

> make

The .ko file created can be placed in the linux file system and loaded with
"insmod" from the rcS.
