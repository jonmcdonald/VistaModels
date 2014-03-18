TINYGL_USE_PL110=y

CC=arm-none-eabi-gcc

CFLAGS := -DTINYGL_USE_PL110 -gdwarf-3 -fpic -nostdlib
CFLAGS += -DNDEBUG -DNO_DEBUG_OUTPUT
CFLAGS += -nostartfiles -ffreestanding -nodefaultlibs
CFLAGS += -fno-builtin -fomit-frame-pointer -mcpu=cortex-a9

ifeq (${GPU}, 1)
CFLAGS += -DGPU
endif
ifeq (${HWZERO}, 1)
CFLAGS += -DHWZERO
endif

UI_LIBS=
UI_INCLUDES=-I../src

UI_OBJS=pl110_init.o


OBJS= api.o list.o vertex.o init.o matrix.o texture.o \
      misc.o clear.o light.o clip.o select.o get.o error.o \
      zbuffer.o zline.o zdither.o ztriangle.o \
      zmath.o image_util.o oscontext.o msghandling.o \
      arrays.o specbuf.o memory.o glu.o
OBJS += pl110.o

INCLUDES = -Iinclude
LIB = libTinyGL.a

all: $(LIB)

$(LIB): $(OBJS)
	rm -f $(LIB)
	ar rcs $(LIB) $(OBJS)

clean:
	rm -f *~ *.o *.a $(LIB)

.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -c $*.c

clip.o: zgl.h zfeatures.h
vertex.o: zgl.h zfeatures.h
light.o: zgl.h zfeatures.h
matrix.o: zgl.h zfeatures.h
list.o: zgl.h opinfo.h zfeatures.h
arrays.c: zgl.h zfeatures.h
specbuf.o: zgl.h zfeatures.h
glx.o: zgl.h zfeatures.h
nglx.o: zgl.h zfeatures.h
zline.o: zgl.h zfeatures.h zline.h

ztriangle.o: ztriangle.c ztriangle.h zgl.h zfeatures.h
	$(CC) $(CFLAGS) -Wno-uninitialized $(INCLUDES) -c $*.c
