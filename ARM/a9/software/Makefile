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

ifeq (${GPU}, 1)
CFLAGS += -DGPU
endif

ifeq (${HWZERO}, 1)
CFLAGS += -DHWZERO
endif

LIBGCC=${shell $(ARMGNU)-gcc ${CFLAGS} -print-libgcc-file-name}
LIBC=${shell $(ARMGNU)-gcc ${CFLAGS} -print-file-name=libc.a}
LIBM=${shell $(ARMGNU)-gcc ${CFLAGS} -print-file-name=libm.a}
 
EXTRALIBS=-Ltinygl -lTinyGL $(LIBM)

DIRS:=tinygl examples

# build rules
all: 
	( for f in $(DIRS); do ( cd $$f ; make all ) || exit 1 ; done )
	make gears.axf mech.axf

include $(wildcard *.d)
 
gears.axf: $(OBJS) link-arm-eabi.ld
	$(ARMGNU)-gcc $(OBJS) examples/gears.o $(EXTRALIBS) -Tlink-arm-eabi.ld -o $@

mech.axf: $(OBJS) link-arm-eabi.ld
	$(ARMGNU)-gcc $(OBJS) examples/mech.o $(EXTRALIBS) -Tlink-arm-eabi.ld -o $@

cube.axf: $(OBJS) link-arm-eabi.ld
	$(ARMGNU)-gcc $(OBJS) examples/cube.o $(EXTRALIBS) -Tlink-arm-eabi.ld -o $@
 
clean:
	( for f in $(DIRS); do ( cd $$f ; make clean ) || exit 1 ; done )
	$(RM) -f *.o *.axf *~
 
dist-clean: clean
	$(RM) -f *.d
 
# C.
%.o: %.c Makefile
	$(ARMGNU)-gcc $(CFLAGS) -c $< -o $@
 
# AS.
%.o: %.S Makefile
	$(ARMGNU)-gcc $(ASFLAGS) -c $< -o $@

