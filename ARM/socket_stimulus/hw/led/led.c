// gcc led.c -o led -lX11

#include <stdio.h>
#include <errno.h>
#include <X11/Xlib.h>
#include <stdlib.h>
#include <X11/Xutil.h>
#include <X11/Xos.h>
#include <string.h>

Display *dis;
int screen;
Window win;
GC gc;
XColor red;
XColor green;
XColor blue;

int redEnable, greenEnable, blueEnable;

void init_x();
void close_x();
void redraw();

main () {
	redEnable = 0;
	greenEnable = 0;
	blueEnable = 0;

	init_x();
	
	fd_set in_fds;

	char string[100];

   	int x11_fd = ConnectionNumber(dis);

	XEvent event;
	while(1) {		
		FD_ZERO(&in_fds);
        	FD_SET(x11_fd, &in_fds);
	        FD_SET(0, &in_fds);

	     	if (select (FD_SETSIZE, &in_fds, NULL, NULL, NULL) < 0) {
	               close_x();
                }

	        if(FD_ISSET (0, &in_fds)) {
			if(! fgets(string,100,stdin)) { close_x(); }
			if(strstr(string,"r1")) { redEnable = 1; }
			if(strstr(string,"r0")) { redEnable = 0; }
			if(strstr(string,"g1")) { greenEnable = 1; }
			if(strstr(string,"g0")) { greenEnable = 0; }
			if(strstr(string,"b1")) { blueEnable = 1; }
			if(strstr(string,"b0")) { blueEnable = 0; }
			redraw();
		}
	
		while(XPending(dis)) {
			XNextEvent(dis, &event);
			if (event.type==Expose && event.xexpose.count==0) {
				redraw();
			}
		}
	}

	
	return 0;
}

void init_x() {     
	unsigned long black,white;
	dis=XOpenDisplay((char *)0);
   	screen=DefaultScreen(dis);
	black=BlackPixel(dis,screen),
	white=WhitePixel(dis, screen);
   	win=XCreateSimpleWindow(dis, DefaultRootWindow(dis), 0, 0, 192, 64, 0, white, black);
	XSetStandardProperties(dis,win,"LED","LED",None,NULL,0,NULL);
	XSelectInput(dis, win, ExposureMask);
        gc=XCreateGC(dis, win, 0,0);        
	XSetBackground(dis,gc,black);
	XSetForeground(dis,gc,white);

	XParseColor(dis, DefaultColormap(dis,screen), "red", &red);
	XAllocColor(dis,DefaultColormap(dis,screen),&red);
	XParseColor(dis, DefaultColormap(dis,screen), "green", &green);
	XAllocColor(dis,DefaultColormap(dis,screen),&green);
	XParseColor(dis, DefaultColormap(dis,screen), "blue", &blue);
	XAllocColor(dis,DefaultColormap(dis,screen),&blue);

	redraw();
	XMapRaised(dis, win);
	XFlush(dis);
};

void close_x() {
	XFreeGC(dis, gc);
	XDestroyWindow(dis,win);
	XCloseDisplay(dis);
        exit (0);	
};

void redraw() {
	XClearWindow(dis, win);

	XSetForeground(dis,gc,red.pixel);
	if(redEnable) {
	        XFillArc(dis,win,gc,1,1, 61,61,0,23040);
	}
	else {
	        XDrawArc(dis,win,gc,1,1, 61,61,0,23040);
	}

	XSetForeground(dis,gc,green.pixel);
	if(greenEnable) {
        	XFillArc(dis,win,gc,64,1, 61,61,0,23040);
	}
	else {
	        XDrawArc(dis,win,gc,64,1, 61,61,0,23040);
	}

	XSetForeground(dis,gc,blue.pixel);
	if(blueEnable) {
	        XFillArc(dis,win,gc,128,1, 61,61,0,23040);
	}
	else {
	        XDrawArc(dis,win,gc,128,1, 61,61,0,23040);
	}
};

