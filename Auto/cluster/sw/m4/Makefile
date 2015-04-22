
TARGET=image.axf

CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
LD=arm-none-eabi-ld

RM=rm -f $(1)

VISTA_BIN := $(dir $(shell which vista) )

CFLAGS=-g -mcpu=cortex-m4 -mthumb -I$(VISTA_BIN)../../papoulis/include

LDFLAGS=-T standalone.ld --entry Reset_Handler

CSRCS = $(wildcard *.c)
SSRCS = $(wildcard *.S)
COBJS = $(CSRCS:.c=.o)
SOBJS = $(SSRCS:.S=.o)

all: $(TARGET)

$(TARGET) : $(COBJS) $(SOBJS)
	$(LD) $(LDFLAGS) -o $(TARGET) $(COBJS) $(SOBJS)

.c.o : 
	echo $(PAPOULIS)
	$(CC) -c $(CFLAGS) -c $< -o $*.o

.S.o : 
	$(CC) -c $(CFLAGS) -c $< -o $*.o

rebuild: clean all

clean:
	$(call RM,*.o)
	$(call RM,*~)
	$(call RM,$(TARGET))


