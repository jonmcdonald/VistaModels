
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
TARGET(binary)

INPUT(./boot.o)
INPUT(./KERNEL)
INPUT(FILESYSTEM)

PHYS_OFFSET = 0x80000000;

SECTIONS
{
	. = PHYS_OFFSET;
	.text : { boot.o }

	. = PHYS_OFFSET + 0x8000 - KERNEL_HDR_SZ;
	kernel = . + KERNEL_HDR_SZ;
	.kernel : { ./KERNEL }

	. = . + 0x4000000;

	filesystem = .;
	.filesystem : { FILESYSTEM }
	fs_size = . - filesystem;

	.data : { *(.data) }
	.bss : { *(.bss) }
}
