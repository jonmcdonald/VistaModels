# Makefile - build script */
 
# build environment
ARMGNU ?= arm-none-eabi
 
# source files
SOURCES_ASM := $(wildcard *.S)
SOURCES_C   := $(wildcard *.c)
 
# object files
OBJS        := $(patsubst %.S,%.o,$(SOURCES_ASM))
OBJS        += $(patsubst %.c,%.o,$(SOURCES_C))

# find the Vista model builder include for the semi-hosting
VISTA_BIN=${shell dirname `which vista`}
VISTA_INCLUDE=${shell dirname $(VISTA_BIN)}/papoulis/include

# Build flags
DEPENDFLAGS :=
INCLUDES    := -I$(VISTA_INCLUDE) -Itinygl/include -Itinygl
BASEFLAGS   := -g -fpic -nostdlib
BASEFLAGS   += -nostartfiles -ffreestanding -nodefaultlibs
BASEFLAGS   += -fno-builtin -fomit-frame-pointer -mcpu=cortex-a9
WARNFLAGS   :=
ASFLAGS     := -g -mcpu=cortex-a9 $(INCLUDES) $(DEPENDFLAGS) -D__ASSEMBLY__
CFLAGS      := $(INCLUDES) $(DEPENDFLAGS) $(BASEFLAGS) $(WARNFLAGS)
CFLAGS      += -std=gnu99

LIBGCC=${shell $(ARMGNU)-gcc ${CFLAGS} -print-libgcc-file-name}
LIBC=${shell $(ARMGNU)-gcc ${CFLAGS} -print-file-name=libc.a}
LIBM=${shell $(ARMGNU)-gcc ${CFLAGS} -print-file-name=libm.a}

# build rules
all: 
	make image.axf

include $(wildcard *.d)
 
image.axf: $(OBJS) link-arm-eabi.ld
	$(ARMGNU)-ld $(OBJS) -Tlink-arm-eabi.ld -o $@
 
clean:
	$(RM) -f *.o *.axf *~
 
# C.
%.o: %.c Makefile
	$(ARMGNU)-gcc $(CFLAGS) -c $< -o $@
 
# AS.
%.o: %.S Makefile
	$(ARMGNU)-gcc $(ASFLAGS) -c $< -o $@

