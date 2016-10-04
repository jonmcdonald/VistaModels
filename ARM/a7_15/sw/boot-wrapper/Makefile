
PLATFORM        = A7
BOOTLOADER	= boot.S
BOOT_O          = $(PLATFORM)/boot.o
KERNEL		= $(PLATFORM)/zImage
KERNEL_HDR_SZ	= 0x0	


IMAGE		= $(PLATFORM)/linux-system.axf
LD_SCRIPT	= model.lds.S

CROSS_COMPILE	= arm-none-eabi-

CC		= $(CROSS_COMPILE)gcc -g
LD		= $(CROSS_COMPILE)ld

CPPFLAGS	+= -DBOOT_O=$(BOOT_O)
CPPFLAGS	+= -DKERNEL=$(KERNEL)
CPPFLAGS	+= -DKERNEL_HDR_SZ=$(KERNEL_HDR_SZ)
CPPFLAGS	+= -march=armv7-a

all: $(IMAGE)

clean:
	rm -rf $(IMAGE) $(PLATFORM)

$(IMAGE): $(PLATFORM)/boot.o $(PLATFORM)/model.lds $(KERNEL) $(FILESYSTEM)
	$(LD) -o $@ --script=$(PLATFORM)/model.lds

$(PLATFORM)/boot.o: $(BOOTLOADER)
	mkdir -p $(PLATFORM)
	$(CC) $(CPPFLAGS) -c -o $@ $<

$(PLATFORM)/model.lds: $(LD_SCRIPT)
	mkdir -p $(PLATFORM)
	$(CC) $(CPPFLAGS) -E -P -C -o $@ $<
