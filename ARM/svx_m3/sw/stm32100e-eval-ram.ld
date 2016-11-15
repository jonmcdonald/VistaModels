/* Linker script for STMicroelectronics STM32100E-EVAL
 *
 * Version: Sourcery CodeBench 2015.17-13
 * Support: https://supportnet.mentor.com/
 *
 * Copyright (c) 2007-2010 CodeSourcery, Inc.
 * Copyright (c) 2010-2016 Mentor Graphics, Inc.
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions.  No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */
OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
ENTRY(__cs3_reset)
SEARCH_DIR(.)
GROUP(-lgcc -lc -lcs3 -lcs3unhosted -lcs3stm32f10)

MEMORY
{
  extsram (rwx) : ORIGIN = 0x64000000, LENGTH = 2M
  rom (rx) : ORIGIN = 0x8000000, LENGTH = 512k
  ram (rwx) : ORIGIN = 0x20000000, LENGTH = 32k
  option_bytes_rom (rx) : ORIGIN = 0x1ffff800, LENGTH = 16
}

/* These force the linker to search for particular symbols from
 * the start of the link process and thus ensure the user's
 * overrides are picked up
 */
EXTERN(__cs3_reset __cs3_reset_stm32100e_eval_ram)
EXTERN(__cs3_start_asm _start)
/* Bring in the interrupt routines & vector */
INCLUDE stm32f10-names.inc
EXTERN(__cs3_interrupt_vector_stm32f10)
EXTERN(__cs3_start_c main __cs3_stack __cs3_heap_end)

/* Provide fall-back values */
PROVIDE(__cs3_heap_start = _end);
PROVIDE(__cs3_heap_end = __cs3_region_start_ram + __cs3_region_size_ram);
PROVIDE(__cs3_region_num = (__cs3_regions_end - __cs3_regions) / 20);
PROVIDE(__cs3_stack = __cs3_region_start_ram + __cs3_region_size_ram);

SECTIONS
{
  .text :
  {
    CREATE_OBJECT_SYMBOLS
    __cs3_region_start_ram = .;
    _ftext = .;
    *(.cs3.region-head.ram)
    __cs3_interrupt_vector = __cs3_interrupt_vector_stm32f10;
    *(.cs3.interrupt_vector)
    /* Make sure we pulled in an interrupt vector.  */
    ASSERT (. != __cs3_interrupt_vector_stm32f10, "No interrupt vector");

    PROVIDE(__cs3_reset = __cs3_reset_stm32100e_eval_ram);
    *(.cs3.reset)
    _start = DEFINED(__cs3_start_asm) ? __cs3_start_asm : _start;

    *(.text.cs3.init)
    *(.text .text.* .gnu.linkonce.t.*)
    *(.plt)
    *(.gnu.warning)
    *(.glue_7t) *(.glue_7) *(.vfp11_veneer)

    *(.ARM.extab* .gnu.linkonce.armextab.*)
    *(.gcc_except_table)
  } >ram
  .eh_frame_hdr : ALIGN (4)
  {
    KEEP (*(.eh_frame_hdr))
    *(.eh_frame_entry .eh_frame_entry.*)
  } >ram
  .eh_frame : ALIGN (4)
  {
    KEEP (*(.eh_frame)) *(.eh_frame.*)
  } >ram
  /* .ARM.exidx is sorted, so has to go in its own output section.  */
  PROVIDE_HIDDEN (__exidx_start = .);
  .ARM.exidx :
  {
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
  } >ram
  PROVIDE_HIDDEN (__exidx_end = .);
  .note.gnu.build-id : ALIGN (4)
  {
    KEEP (*(.note.gnu.build-id))
  } >ram
  .rodata : ALIGN (4)
  {
    *(.rodata .rodata.* .gnu.linkonce.r.*)

    . = ALIGN(4);
    KEEP(*(.init))

    . = ALIGN(4);
    __preinit_array_start = .;
    KEEP (*(.preinit_array))
    __preinit_array_end = .;

    . = ALIGN(4);
    __init_array_start = .;
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array))
    __init_array_end = .;

    . = ALIGN(4);
    KEEP(*(.fini))

    . = ALIGN(4);
    __fini_array_start = .;
    KEEP (*(.fini_array))
    KEEP (*(SORT(.fini_array.*)))
    __fini_array_end = .;

    . = ALIGN(0x4);
    KEEP (*crtbegin.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*crtend.o(.ctors))

    . = ALIGN(0x4);
    KEEP (*crtbegin.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*crtend.o(.dtors))

    . = ALIGN(4);
    __cs3_regions = .;
    LONG (0)
    LONG (__cs3_region_init_extsram)
    LONG (__cs3_region_start_extsram)
    LONG (__cs3_region_init_size_extsram)
    LONG (__cs3_region_zero_size_extsram)
    LONG (0)
    LONG (__cs3_region_init_ram)
    LONG (__cs3_region_start_ram)
    LONG (__cs3_region_init_size_ram)
    LONG (__cs3_region_zero_size_ram)
    __cs3_regions_end = .;
    . = ALIGN (8);
    _etext = .;
  } >ram

  ASSERT (!(__cs3_region_init_extsram & 7), "__cs3_region_init_extsram not aligned")
  ASSERT (!(__cs3_region_start_extsram & 7), "__cs3_region_start_extsram not aligned")
  ASSERT (!(__cs3_region_init_size_extsram & 7), "__cs3_region_init_size_extsram not aligned")
  ASSERT (!(__cs3_region_zero_size_extsram & 7), "__cs3_region_zero_size_extsram not aligned")
  ASSERT (!(__cs3_region_init_ram & 7), "__cs3_region_init_ram not aligned")
  ASSERT (!(__cs3_region_start_ram & 7), "__cs3_region_start_ram not aligned")
  ASSERT (!(__cs3_region_init_size_ram & 7), "__cs3_region_init_size_ram not aligned")
  ASSERT (!(__cs3_region_zero_size_ram & 7), "__cs3_region_zero_size_ram not aligned")
  .cs3.extsram : ALIGN (8)
  {
    __cs3_region_start_extsram = .;
    *(.cs3.region-head.extsram)
    *(.extsram)
    . = ALIGN (8);
  } >extsram
  .cs3.extsram.bss :
  {
    *(.extsram.b .bss.extsram)
    . = ALIGN (8);
  } >extsram
  /* __cs3_region_end_extsram is deprecated */
  __cs3_region_end_extsram = __cs3_region_start_extsram + LENGTH(extsram);
  __cs3_region_size_extsram = LENGTH(extsram);
  __cs3_region_init_extsram = LOADADDR (.cs3.extsram);
  __cs3_region_init_size_extsram = LOADADDR (.cs3.extsram.bss) - LOADADDR (.cs3.extsram);
  __cs3_region_zero_size_extsram = SIZEOF(.cs3.extsram.bss);

  .cs3.rom : ALIGN (8)
  {
    __cs3_region_start_rom = .;
    *(.cs3.region-head.rom)
    *(.rom)
    . = ALIGN (8);
  } >rom
  .cs3.rom.bss :
  {
    *(.rom.b .bss.rom)
    . = ALIGN (8);
  } >rom
  /* __cs3_region_end_rom is deprecated */
  __cs3_region_end_rom = __cs3_region_start_rom + LENGTH(rom);
  __cs3_region_size_rom = LENGTH(rom);
  __cs3_region_init_rom = LOADADDR (.cs3.rom);
  __cs3_region_init_size_rom = LOADADDR (.cs3.rom.bss) - LOADADDR (.cs3.rom);
  __cs3_region_zero_size_rom = SIZEOF(.cs3.rom.bss);

  .cs3.option_bytes_rom : ALIGN (8)
  {
    __cs3_region_start_option_bytes_rom = .;
    *(.cs3.region-head.option_bytes_rom)
    *(.option_bytes_rom)
    . = ALIGN (8);
  } >option_bytes_rom
  .cs3.option_bytes_rom.bss :
  {
    *(.option_bytes_rom.b .bss.option_bytes_rom)
    . = ALIGN (8);
  } >option_bytes_rom
  /* __cs3_region_end_option_bytes_rom is deprecated */
  __cs3_region_end_option_bytes_rom = __cs3_region_start_option_bytes_rom + LENGTH(option_bytes_rom);
  __cs3_region_size_option_bytes_rom = LENGTH(option_bytes_rom);
  __cs3_region_init_option_bytes_rom = LOADADDR (.cs3.option_bytes_rom);
  __cs3_region_init_size_option_bytes_rom = LOADADDR (.cs3.option_bytes_rom.bss) - LOADADDR (.cs3.option_bytes_rom);
  __cs3_region_zero_size_option_bytes_rom = SIZEOF(.cs3.option_bytes_rom.bss);

  .data : ALIGN (8)
  {
    KEEP(*(.jcr))
    *(.shdata)
    *(.data .data.* .gnu.linkonce.d.*)
    *(.got.plt) *(.got)
    . = ALIGN (8);
    *(.ram)
    . = ALIGN (8);
    _edata = .;
  } >ram
  .bss : ALIGN (8)
  {
    *(.shbss)
    *(.bss .bss.* .gnu.linkonce.b.*)
    *(COMMON)
    . = ALIGN (8);
    *(.ram.b .bss.ram)
    . = ALIGN (8);
    _end = .;
    __end = .;
  } >ram
  /* __cs3_region_end_ram is deprecated */
  __cs3_region_end_ram = __cs3_region_start_ram + LENGTH(ram);
  __cs3_region_size_ram = LENGTH(ram);
  __cs3_region_init_ram = LOADADDR (.text);
  __cs3_region_init_size_ram = _edata - ADDR (.text);
  __cs3_region_zero_size_ram = _end - _edata;

  .stab 0 (NOLOAD) : { *(.stab) }
  .stabstr 0 (NOLOAD) : { *(.stabstr) }
  /* DWARF debug sections.
   * Symbols in the DWARF debugging sections are relative to
   * the beginning of the section so we begin them at 0.
   */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* DWARF 2.1 */
  .debug_ranges   0 : { *(.debug_ranges) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }

  .note.gnu.arm.ident 0 : { KEEP (*(.note.gnu.arm.ident)) }
  .ARM.attributes 0 : { KEEP (*(.ARM.attributes)) }
  /DISCARD/ : { *(.note.GNU-stack) }
}
/* checksum: 19d62322155990b740e1e24 */
