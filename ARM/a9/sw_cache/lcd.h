typedef int(*PFN)(void);
 
void start(void);

#define PL110_CR_EN		0x001
#define PL110_CR_PWR		0x800
#define PL110_IOBASE		0xc0000000
#define PL110_PALBASE		(PL110_IOBASE + 0x200)
 
typedef unsigned int		uint32;
typedef unsigned char		uint8;
typedef unsigned short		uint16;
 
typedef struct _PL110MMIO 
{
	uint32		volatile tim0;		//0
	uint32		volatile tim1;		//4
	uint32		volatile tim2;		//8
	uint32		volatile d;		//c
	uint32		volatile upbase;	//10
	uint32		volatile f;		//14
	uint32		volatile g;		//18
	uint32		volatile control;	//1c
} PL110MMIO;

extern void init_lcd(void);
extern void swapBuffers(void);
extern int ui_loop();
