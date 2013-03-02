# This makefile is intended for use with GNU make

CC=arm-none-eabi-gcc


RM=rm -f $(1)

CFLAGS=-g -mcpu=cortex-m3 -mthumb -I.

CSRCS = $(wildcard *.c)
COBJS = $(CSRCS:.c=.o)

all: clean $(COBJS)

.c.o : 
	$(CC) -c $(CFLAGS) -c $< -o $*.o

rebuild: clean all

clean:
	$(call RM,*.o)
	$(call RM,*~)


