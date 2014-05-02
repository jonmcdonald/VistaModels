
#pragma once

void mmu_init();

void page_set_cacheable(unsigned long addr, int enabled);

#endif
