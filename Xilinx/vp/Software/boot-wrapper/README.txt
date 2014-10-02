
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

The Makefile in this directory has a number of targets to make the process easier:

> make mount	# Uncompress and mount arm_ramdisk.image on ./mnt
> make umount	# Unmount and compress arm_ramdisk.image
> make build	# Calls build.sh $LINUX
> make update	# Updates peripheral_driver.ko in linux-system.axf.  .ko must already exist
