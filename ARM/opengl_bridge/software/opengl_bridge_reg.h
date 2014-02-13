#ifndef __bridge_gl_reg_h_
#define __bridge_gl_reg_h_

typedef unsigned int uint32;

typedef struct _OPENGL_MMIO 
{
    double volatile arg0; // 0x0
    double volatile arg1; // 0x8
    double volatile arg2; // 0x10
    double volatile arg3; // 0x18
    double volatile arg4; // 0x20
    double volatile arg5; // 0x28
    double volatile arg6; // 0x30
    double volatile arg7; // 0x38

    uint32 volatile sdl2Open; // 0x40
    uint32 volatile sdl2Swap;
    uint32 volatile sdl2Close;

    uint32 volatile glBegin;
    uint32 volatile glCallList;
    uint32 volatile glClear;
    uint32 volatile glClearColor;
    uint32 volatile glColor3f;
    uint32 volatile glDisable;    
    uint32 volatile glEnable;
    uint32 volatile glEnd;
    uint32 volatile glEndList;
    uint32 volatile glFlush;
    uint32 volatile glFrustum;
    uint32 volatile glGenLists;
    uint32 volatile glLightf;
    uint32 volatile glLightfv;
    uint32 volatile glLoadIdentity;
    uint32 volatile glMaterialfv;
    uint32 volatile glMatrixMode;
    uint32 volatile glNewList;
    uint32 volatile glNormal3f;
    uint32 volatile glOrtho;
    uint32 volatile glPolygonMode;
    uint32 volatile glPopMatrix;
    uint32 volatile glPushMatrix;
    uint32 volatile glRectf;
    uint32 volatile glRotatef;
    uint32 volatile glScalef;
    uint32 volatile glShadeModel;
    uint32 volatile glTexCoord2f;
    uint32 volatile glTranslatef;
    uint32 volatile glVertex2f;
    uint32 volatile glVertex3f;
    uint32 volatile glViewport;

} OPENGL_MMIO;

#endif

