#include <stdint.h>
 
static void* mem = (void*) 0x003000000;

void *vista_malloc(int size)
{
	void *ret = mem;
	mem += size;
	return ret;
}

