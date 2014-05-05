
BOOTLOADER	= boot.S
KERNEL		= zImage
KERNEL_HDR_SZ	= 0x0	# 0x40 for uImage

IMAGE		= linux-system.axf
LD_SCRIPT	= model.lds.S

CROSS_COMPILE	= arm-linux-gnueabi-

CC		= $(CROSS_COMPILE)gcc -g
LD		= $(CROSS_COMPILE)ld

CPPFLAGS	+= -DKERNEL=$(KERNEL)
CPPFLAGS	+= -DKERNEL_HDR_SZ=$(KERNEL_HDR_SZ)
CPPFLAGS	+= -DFILESYSTEM=$(FILESYSTEM)

CPPFLAGS	+= -DUSE_INITRD
CPPFLAGS	+= -march=armv7-a

all: $(IMAGE)

clean:
	rm -f $(IMAGE) boot.o model.lds *Image

$(IMAGE): boot.o model.lds $(KERNEL) $(FILESYSTEM)
	$(LD) -g -o $@ --script=model.lds

boot.o: $(BOOTLOADER)
	$(CC) $(CPPFLAGS) -g -c -o $@ $<

model.lds: $(LD_SCRIPT)
	$(CC) $(CPPFLAGS) -g -E -P -C -o $@ $<
