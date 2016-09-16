
# Build flags
export TOOL_CHAIN=../buildroot-2016.05/output/host/usr
export TARGET=arm-linux
export CROSS_COMPILE=$(TOOL_CHAIN)/bin/$(TARGET)
export ARCH=arm

# build rules
all: uio_example

uio_example: uio_example.o
	$(CROSS_COMPILE)-gcc uio_example.o -g -o $@
clean:
	$(RM) -f *.o *.a *~ uio_example

%.o: %.c Makefile
	$(CROSS_COMPILE)-gcc $(CFLAGS) -g -c $< -o $@
 
