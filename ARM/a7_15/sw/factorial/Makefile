
# Build flags
export TOOL_CHAIN=../buildroot-2016.05/output/host/usr
export TOOL_CHAIN=/home/tools/linaro/gcc-linaro-arm-linux-gnueabihf-4.8-2013.12_linux
export TARGET=arm-linux-
export TARGET=arm-linux-gnueabihf-
export CROSS_COMPILE=$(TOOL_CHAIN)/bin/$(TARGET)
export ARCH=arm

# build rules
all: factorial

factorial: factorial.o
	$(CROSS_COMPILE)gcc factorial.o -g -o $@
clean:
	$(RM) -f *.o *.a *~ factorial

%.o: %.c Makefile
	$(CROSS_COMPILE)gcc $(CFLAGS) -g -c $< -o $@
 
