
static void* mem = (void*) 0x20000000;

void *vista_malloc(int size)
{
	void *ret = mem;
	mem += size;
	return ret;
}

