/*
 * Memory allocator for TinyGL
 */
#include "zgl.h"

/* modify these functions so that they suit your needs */

void gl_free(void *p)
{
//    free(p);
}

void *gl_malloc(int size)
{
#if defined(TINYGL_USE_PL110)
    return (void*) vista_malloc(size);
#else
    return malloc(size);
#endif
}

void *gl_zalloc(int size)
{
//    return calloc(1, size);
   int i;
   unsigned char *mem = gl_malloc(size);
   for(i = 0; i < size; i++) {
	mem[i] = 0;
   }
   return mem;
}

void *gl_memcpy(void *dest, const void *src, size_t n)
{
   const unsigned char *s = src;
   unsigned char *d = dest;
   int i;
   for(i = 0; i < n; i++) {
	d[i] = s[i];
   }
}

