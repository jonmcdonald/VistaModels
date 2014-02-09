#include "opengl_bridge.h"
#include "opengl_bridge_reg.h"

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define OPENGL_IOBASE		0xc0000000

OPENGL_MMIO *opengl = (OPENGL_MMIO*) OPENGL_IOBASE;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void sdl2Open()
{
    opengl->sdl2Open = 0x1;
}

void sdl2Swap()
{
    opengl->sdl2Swap = 0x1;
}

void sdl2Close()
{
    opengl->sdl2Close = 0x1;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

GLAPI void GLAPIENTRY glBegin( GLenum mode ) 
{
    opengl->arg0 = (double) mode;
    opengl->glBegin = 0x1;
}

GLAPI void GLAPIENTRY glCallList( GLuint list )
{
    opengl->arg0 = (double) list;
    opengl->glCallList = 0x1;
}

GLAPI void GLAPIENTRY glClear( GLbitfield mask )
{
    opengl->arg0 = (double) mask;
    opengl->glClear = 0x1;
}

GLAPI void GLAPIENTRY glColor3f( GLfloat red, GLfloat green, GLfloat blue )
{
    opengl->arg0 = (double) red;
    opengl->arg1 = (double) green;
    opengl->arg2 = (double) blue;
    opengl->glColor3f = 0x1;
}

GLAPI void GLAPIENTRY glEnable( GLenum cap )
{
    opengl->arg0 = (double) cap;
    opengl->glEnable = 0x1;
}

GLAPI void GLAPIENTRY glEnd( void )
{
    opengl->glEnd = 0x1;
}

GLAPI void GLAPIENTRY glEndList( void )
{
    opengl->glEndList = 0x1;
}

GLAPI void GLAPIENTRY glFrustum( GLdouble left, GLdouble right,
                                   GLdouble bottom, GLdouble top,
                                   GLdouble near_val, GLdouble far_val )
{
    opengl->arg0 = (double) left;
    opengl->arg1 = (double) right;
    opengl->arg2 = (double) bottom;
    opengl->arg3 = (double) top;
    opengl->arg4 = (double) near_val;
    opengl->arg5 = (double) far_val;
    opengl->glFrustum = 0x1;
}

static GLuint list = 1;

GLAPI GLuint GLAPIENTRY glGenLists( GLsizei range )
{
    opengl->arg0 = (double) range;
    opengl->glGenLists = 0x1;
    return list++;
}

GLAPI void GLAPIENTRY glLightfv( GLenum light, GLenum pname,
                                 const GLfloat *params )
{
    opengl->arg0 = (double) light;
    opengl->arg1 = (double) pname;
    opengl->arg2 = (double) (unsigned int) params;
    opengl->glLightfv = 0x1;
}

GLAPI void GLAPIENTRY glLoadIdentity( void )
{
    opengl->glLoadIdentity = 0x1;
}

GLAPI void GLAPIENTRY glMaterialfv( GLenum face, GLenum pname, const GLfloat *params )
{
    opengl->arg0 = (double) face;
    opengl->arg1 = (double) pname;
    opengl->arg2 = (double) (unsigned int) params;
    opengl->glMaterialfv = 0x1;
}

GLAPI void GLAPIENTRY glMatrixMode( GLenum mode )
{
    opengl->arg0 = (double) mode;
    opengl->glMatrixMode = 0x1;
}

GLAPI void GLAPIENTRY glNewList( GLuint list, GLenum mode )
{
    opengl->arg0 = (double) list;
    opengl->arg1 = (double) mode;
    opengl->glNewList = 0x1;
}

GLAPI void GLAPIENTRY glNormal3f( GLfloat nx, GLfloat ny, GLfloat nz )
{
    opengl->arg0 = (double) nx;
    opengl->arg1 = (double) ny;
    opengl->arg2 = (double) nz;
    opengl->glNormal3f = 0x1;
}

GLAPI void GLAPIENTRY glOrtho( GLdouble left, GLdouble right,
                                 GLdouble bottom, GLdouble top,
                                 GLdouble near_val, GLdouble far_val )
{
    opengl->arg0 = (double) left;
    opengl->arg1 = (double) right;
    opengl->arg2 = (double) bottom;
    opengl->arg3 = (double) top;
    opengl->arg4 = (double) near_val;
    opengl->arg5 = (double) far_val;
    opengl->glOrtho = 0x1;
}

GLAPI void GLAPIENTRY glPopMatrix( void )
{
    opengl->glPopMatrix = 0x1;
}

GLAPI void GLAPIENTRY glPushMatrix( void )
{
    opengl->glPushMatrix = 0x1;
}

GLAPI void GLAPIENTRY glRectf( GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2 )
{
    opengl->arg0 = (double) x1;
    opengl->arg1 = (double) y1;
    opengl->arg2 = (double) x2;
    opengl->arg3 = (double) y2;
    opengl->glRectf = 0x1;
}

GLAPI void GLAPIENTRY glRotatef( GLfloat angle,
                                   GLfloat x, GLfloat y, GLfloat z )
{
    opengl->arg0 = (double) angle;
    opengl->arg1 = (double) x;
    opengl->arg2 = (double) y;
    opengl->arg3 = (double) z;
    opengl->glRotatef = 0x1;
}

GLAPI void GLAPIENTRY glShadeModel( GLenum mode )
{
    opengl->arg0 = (double) mode;
    opengl->glShadeModel = 0x1;
}

GLAPI void GLAPIENTRY glTranslatef( GLfloat x, GLfloat y, GLfloat z )
{
    opengl->arg0 = (double) x;
    opengl->arg1 = (double) y;
    opengl->arg2 = (double) z;
    opengl->glTranslatef = 0x1;
}

GLAPI void GLAPIENTRY glVertex3f( GLfloat x, GLfloat y, GLfloat z )
{
    opengl->arg0 = (double) x;
    opengl->arg1 = (double) y;
    opengl->arg2 = (double) z;
    opengl->glVertex3f = 0x1;
}

GLAPI void GLAPIENTRY glViewport( GLint x, GLint y,
                                    GLsizei width, GLsizei height )
{
    opengl->arg0 = (double) x;
    opengl->arg1 = (double) y;
    opengl->arg2 = (double) width;
    opengl->arg3 = (double) height;
    opengl->glViewport = 0x1;
}


