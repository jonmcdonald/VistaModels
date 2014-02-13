# Makefile - build script */
 
# build environment
ARMGNU ?= arm-none-eabi
 
# source files
SOURCES_C   := $(wildcard *.c)
 
# object files
OBJS        += $(patsubst %.c,%.o,$(SOURCES_C))
 
# Build flags
DEPENDFLAGS :=
INCLUDES    := -I..
BASEFLAGS   := -g -fpic -nostdlib
BASEFLAGS   += -nostartfiles -ffreestanding -nodefaultlibs
BASEFLAGS   += -fno-builtin -fomit-frame-pointer -mcpu=cortex-a9
WARNFLAGS   :=
ASFLAGS     := -g -mcpu=cortex-a9 $(INCLUDES) $(DEPENDFLAGS) -D__ASSEMBLY__
CFLAGS      := $(INCLUDES) $(DEPENDFLAGS) $(BASEFLAGS) $(WARNFLAGS)
CFLAGS      += -std=gnu99

CFLAGS      += -DGPU

DIRS:=tinygl

# build rules
all: gears.o mech.o 

clean:
	$(RM) -f $(OBJS) *~
 
# C.
%.o: %.c Makefile
	$(ARMGNU)-gcc $(CFLAGS) -c $< -o $@
 

