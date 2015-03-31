
EGL_OBJS  += eglut.o eglut_screen.o

# Build flags
SW_ROOT := $(CURDIR)/..
CFLAGS    += -g -I$(SW_ROOT)/packages/sysroot/include -DMESA_EGL_NO_X11_HEADERS 
LDLAGS    += -L$(SW_ROOT)/packages/sysroot/lib -ldrm -lglapi -lEGL -lm

# build rules
all: es1gears es2gears

es1gears: $(EGL_OBJS) es1gears.c
	$(TARGET)-gcc $(CFLAGS) es1gears.c eglut.o eglut_screen.o $(LDLAGS) -lGLESv1_CM -o $@

es2gears: $(EGL_OBJS) es2gears.c
	$(TARGET)-gcc $(CFLAGS) es2gears.c eglut.o eglut_screen.o $(LDLAGS) -lGLESv2 -o $@

clean:
	$(RM) -f *.o *.a *~ es1gears es2gears
 
%.o: %.c Makefile
	$(TARGET)-gcc $(CFLAGS) -c $< -o $@
 
