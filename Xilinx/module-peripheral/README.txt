Building this kernel module requires linux source/build tree be available.

LINUX=<path-to-linux-build-area>
ARCH=arm
CROSS_COMPILE=arm-none-eabi-

Call to build if above are set appropriatly:

> make -C $LINUX M=`pwd`

or just:

> make

To recreate the ../vp/Software/boot-wrapper/linux-system.axf with an updated
peripheral_driver.ko execute:

> make update

The .ko file created can be placed in the linux file system and loaded with
"insmod" from the rcS.
