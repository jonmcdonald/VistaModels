
MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 128K
    SRAM (rwx) : ORIGIN = 0x00020000, LENGTH = 256K
}

SECTIONS
{
    .text :
    {
        KEEP(*(.isr_vector))
        *(.text)
        *(.rodata*)
        _etext = .;
    } > FLASH

    .data : 
    {
        _data = .;
        *(vtable)
        *(.data)
        _edata = .;
    } > SRAM AT > FLASH

    .bss :
    {
        _bss = .;
        *(.bss)
        *(COMMON)
        _ebss = .;
    } > SRAM
}

