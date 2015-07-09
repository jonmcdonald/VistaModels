
# Build flags
SW_ROOT := $(CURDIR)/..
CFLAGS    += -g -I$(SW_ROOT)/sdcard/sysroot/include 
LDLAGS    += 

# build rules
all:  i2ctest spitest gpiotest

i2ctest: linux-i2c-test.o
	$(TARGET)-gcc $(CFLAGS) linux-i2c-test.o $(LDLAGS) -o $@

spitest: spitest.o
	$(TARGET)-gcc $(CFLAGS) spitest.o $(LDLAGS) -o $@

gpiotest: gpiotest.o
	$(TARGET)-gcc $(CFLAGS) gpiotest.o $(LDLAGS) -o $@

clean:
	$(RM) -f *.o *.a *~ i2ctest spitest gpiotest
 
%.o: %.c Makefile
	$(TARGET)-gcc $(CFLAGS) -c $< -o $@
 
