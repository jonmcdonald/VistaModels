
# Build flags
CFLAGS    += -g

# build rules
all: testbench

testbench: main.c
	$(TARGET)-gcc $(CFLAGS) main.c $(LDLAGS) -o $@

clean:
	$(RM) -f *.o *.a *~ testbench
 

