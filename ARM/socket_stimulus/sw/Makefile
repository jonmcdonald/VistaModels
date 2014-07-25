
TARGET=image.axf

CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
LD=arm-none-eabi-ld

RM=rm -f $(1)

CFLAGS=-g -mcpu=cortex-m3 -mthumb -fpack-struct

LIBGCC=${shell ${CC} -mthumb -march=armv6t2 -print-libgcc-file-name}
LIBC=${shell ${CC} -mthumb -march=armv6t2 -print-file-name=libc.a}

LDFLAGS=-T standalone.ld --entry Reset_Handler

CSRCS = $(wildcard *.c)
SSRCS = $(wildcard *.S)
COBJS = $(CSRCS:.c=.o)
SOBJS = $(SSRCS:.S=.o)

all: $(TARGET)

$(TARGET) : $(COBJS) $(SOBJS)
	$(LD) $(LDFLAGS) -o $(TARGET) $(COBJS) $(SOBJS)

.c.o : 
	$(CC) -c $(CFLAGS) -c $< -o $*.o

.S.o : 
	$(CC) -c $(CFLAGS) -c $< -o $*.o

rebuild: clean all

clean:
	$(call RM,*.o)
	$(call RM,*~)
	$(call RM,*.axf)


