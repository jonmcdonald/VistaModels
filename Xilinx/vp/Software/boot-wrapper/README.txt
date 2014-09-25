
Before executing build.sh the following env variables must be set appropriately

LINUX=<path-to-linux-build>
ARCH=arm
CROSS_COMPILE=arm-none-eabi-

build.sh must be called with the path to the built linux.

> build.sh $LINUX

To modify the initial file system you can execute the following:

> gzip -d arm_ramdisk.image.gz
> sudo mount -o loop,rw,offset=0 arm_ramdisk.image mnt

The file system is now mounted under ./mnt.  Modify as appropriate then execute:

> sudo umount mnt
> gzip arm_ramdisk.image.gz
