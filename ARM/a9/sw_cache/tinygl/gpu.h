
#if defined(GPU) || defined(HWZERO)
#define GPU_IOBASE 0xD0000000
typedef struct _GPU_MMIO
{
	unsigned int volatile GPU_ZERO_START;     //0
	unsigned int volatile GPU_ZERO_SIZE;      //4
	unsigned int volatile GPU_TRIANGLE_ZB;    //8
	unsigned int volatile GPU_TRIANGLE_P0;    //C
	unsigned int volatile GPU_TRIANGLE_P1;    //10
	unsigned int volatile GPU_TRIANGLE_P2;    //14
	unsigned int volatile GPU_TRIANGLE_DRAW;  //18
} GPU_MMIO;
#endif
