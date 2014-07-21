#RTOS=CoOS
#RTOS=FunkOS
#RTOS=FreeRTOS
RTOS=BareMetal

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TARGET=$(RTOS).axf

CC=arm-none-eabi-gcc
AS=arm-none-eabi-as
LD=arm-none-eabi-ld

RM=rm -f $(1)

CFLAGS=-g -mcpu=cortex-m3 -mthumb -I $(RTOS) -I$(MODEL_BUILDER_HOME)/include -fpack-struct

LIBGCC=${shell ${CC} -mthumb -march=armv6t2 -print-libgcc-file-name}
LIBC=${shell ${CC} -mthumb -march=armv6t2 -print-file-name=libc.a}

LDFLAGS=-T standalone.ld --entry Reset_Handler
# -Map $(RTOS).map 

ifeq (${RTOS}, FreeRTOS)
EXTRALIBS=$(LIBC) $(LIBGCC)
endif

SETUP=setup
ifeq (${RTOS}, BareMetal)
SETUP=bare_setup
endif

CSRCS = $(wildcard *.c)
SSRCS = $(wildcard *.S)
COBJS = $(CSRCS:.c=.o)
SOBJS = $(SSRCS:.S=.o)

RTOSOBJS = $(wildcard $(RTOS)/*.o)

all: $(SETUP) $(TARGET)

setup: clean
	ln -sf main.c.$(RTOS) main.c
	cd $(RTOS); make; cd ..

bare_setup: clean
	ln -sf main.c.$(RTOS) main.c

$(TARGET) : $(COBJS) $(SOBJS)
	$(LD) $(LDFLAGS) -o $(TARGET) $(COBJS) $(SOBJS) $(RTOSOBJS) $(EXTRALIBS)
	ln -sf $(TARGET) image.axf

.c.o : 
	$(CC) -c $(CFLAGS) -c $< -o $*.o

.S.o : 
	$(CC) -c $(CFLAGS) -c $< -o $*.o

rebuild: clean all

clean:
	$(call RM,*.o)
	$(call RM,*~)



