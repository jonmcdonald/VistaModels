VISTA_HOME = /store/tools/vista4.2.1

CROSS_COMPILER ?= powerpc-eabi-

CC = ${CROSS_COMPILER}gcc

INCLUDE = -I${VISTA_HOME}/papoulis/include

all: mybit.elf

mybit.elf: mybit.c regs.h crt0.S link_script.ld
	${CC} ${INCLUDE} mybit.c crt0.S -mcpu=e5500 -m32 -nostdlib -nodefaultlibs -g -Wa,-mregnames -DPPC440 -Tlink_script.ld -o mybit.elf

clean:
	rm -f *.elf *.o *~ *.map

