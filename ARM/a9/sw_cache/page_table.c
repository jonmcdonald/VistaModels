#include <assert.h>

extern void clean_dcache_mva();
extern void enable_mmu();

/*
  1 MB descriptor format:

  ;  31                  20 19 18 17 16  15 14 12 11 10  9  8    5  4 3 2 1 0
  ; |<section base address>| 0  0|nG| S|APX| TEX |  AP |IMP|Domain|XN| CB|1 0|
*/

static unsigned long page_table[4096] __attribute__((aligned(0x4000)));

static void clean_dcache(unsigned long begin, unsigned long end)
{
  unsigned long addr;
  for (addr = begin; addr < end; addr += 32) {
    clean_dcache_mva(addr & ~31);   //0xffffffe0
  }
}

static void page_table_flush(unsigned long* table)
{
  clean_dcache((unsigned long)&(table[0]),
               (unsigned long)&(table[4096]));
}

static void page_table_init(unsigned long* table)
{
  const unsigned long default_desc = 0b00000000000000000000110111100010;
  unsigned idx;
  for (idx = 0; idx < 4096; idx++) {
    unsigned long desc = default_desc;
    desc |= (idx << 20);
    table[idx] = desc;
  }
}

static void page_table_set_attrs(unsigned long* table, unsigned long addr,
                                 unsigned S, unsigned TEX, unsigned CB)
{
  unsigned idx = addr >> 20;
  unsigned long desc = table[idx];
  assert((desc >> 20) == (addr >> 20));

  const unsigned S_MASK = (1 << 16);
  const unsigned TEX_MASK = (7 << 12);
  const unsigned CB_MASK = (3 << 2);

  desc &= ~(S_MASK | TEX_MASK | CB_MASK);
  desc |= ((S & 1) << 16);
  desc |= ((TEX & 7) << 12);
  desc |= ((CB & 3) << 2);

  table[idx] = desc;
}

void mmu_init()
{
  int idx;

  page_table_init(page_table);

  /* First 64M: 0:0x0400_0000 is cacheable. */
  for (idx = 0; idx < 64; idx++)
    page_table_set_attrs(page_table, idx << 20, 0, 0b001, 0b11);

  page_table_flush(page_table);

  enable_mmu(page_table);
}
