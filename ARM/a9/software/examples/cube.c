 
#include <GL/gl.h>
#include "glu.h"
#include "ui.h"

GLfloat xrot; 
GLfloat yrot;
GLfloat zrot; 

void reshape( int width, int height)
{
   GLfloat  h = (GLfloat) width / (GLfloat) height;

   glViewport(0, 0, (GLint) width, (GLint) height);
    glMatrixMode( GL_PROJECTION );
    glLoadIdentity( );

    /* Set our perspective */
    gluPerspective( 45, h, 0.1, 100 );

    /* Make sure we're chaning the model view and not the projection */
    glMatrixMode( GL_MODELVIEW );

    /* Reset The View */
    glLoadIdentity( );

   glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
}

/* general OpenGL initialization function */
void init( void )
{
    glShadeModel( GL_FLAT);

    /* Set the background black */
    glClearColor(0, 0, 0, 0.5);

    /* Depth buffer setup */
    glClearDepth(1);

    /* Enables Depth Testing */
    glEnable( GL_DEPTH_TEST) ;

    /* Really Nice Perspective Calculations */
    glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) ;
}

/* Here goes our drawing code */
void draw(void)
{
    /* Clear The Screen And The Depth Buffer */
   glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) ;

    /* Move Into The Screen 5 Units */
    glLoadIdentity( );
    glTranslatef( 0, 0, -5) ;

    glRotatef( xrot, 1, 0, 0); 
    glRotatef( yrot, 0, 1, 0);
    glRotatef( zrot, 0, 0, 1);

    glBegin(GL_QUADS);
      /* Front Face */
glColor3f( 0, 0, 1) ;
glVertex3f( -1,-1, 1) ;
glVertex3f( 1, -1, 1) ;
glVertex3f( 1, 1, 1 );
glVertex3f( -1, 1, 1 );

      /* Back Face */
glColor3f( 0, 1, 0) ;
glVertex3f( -1, -1, -1) ;
glVertex3f( -1, 1, -1) ;
glVertex3f( 1, 1, -1) ;
glVertex3f( 1, -1, -1) ;

      /* Top Face */
glColor3f( 0, 1, 1) ;
glVertex3f( -1,  1, -1) ;
glVertex3f( -1,  1,  1) ;
glVertex3f(  1,  1,  1) ;
glVertex3f(  1,  1, -1) ;

      /* Bottom Face */
glColor3f( 1, 0, 0) ;
 glVertex3f( -1, -1, -1) ;
 glVertex3f(  1, -1, -1) ;
 glVertex3f(  1, -1,  1) ;
glVertex3f( -1 ,-1,  1);

      /* Right face */
glColor3f( 1, 0, 1) ;
glVertex3f( 1, -1, -1) ;
 glVertex3f( 1,  1, -1) ;
glVertex3f( 1,  1,  1) ;
glVertex3f( 1, -1,  1) ;

      /* Left Face */
glColor3f(1, 1, 0);
glVertex3f(-1, -1, -1);
glVertex3f(-1, -1,  1);
glVertex3f(-1,  1,  1);
glVertex3f(-1,  1, -1);
    glEnd();

    swapBuffers();
}

void idle(void)
{
    xrot += 0.4; /* X Axis Rotation */
    yrot += 0.3; /* Y Axis Rotation */
    zrot += 0.5; /* Z Axis Rotation */
    draw();
}

