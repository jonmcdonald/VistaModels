/**
* program	: glutmech V1.1
* author	: Simon Parkinson-Bates.
* E-mail	: sapb@yallara.cs.rmit.edu.au
* Copyright Simon Parkinson-Bates.
* "source if freely avaliable to anyone to copy as long as they
*  acknowledge me in their work."
*
* Funtional features 
* ------------------
* * online menu system avaliable by pressing left mouse button
* * online cascading help system avaliable, providing information on
*	the several  key strokes and what they do.
* * animation sequence coded which makes the mech walk through an
*	environment.  Shadows will soon be added to make it look
*	more realistic.
* * menu control to view mech in wireframe or sold mode.
* * various key strokes avaliable to control idependently the mechs
*	many joints.
* * various key strokes avaliable to view mech and environment from 
*	different angles
* * various key strokes avaliable to alter positioning of the single
*	light source.
*
*
* Program features
* ----------------
* * uses double buffering
* * uses display lists
* * uses glut to manage windows, callbacks, and online menu.
* * uses glpolygonfill() to maintain colors in wireframe and solid
*	mode.
*
**/

/* start of compilation conditions */
#define SPHERE
#define COLOR
#define LIGHT
#define TORSO
#define HIP
#define SHOULDER
#define UPPER_ARM
#define LOWER_ARM
#define ROCKET_POD
#define UPPER_LEG
#define LOWER_LEG
#define NO_NORM
#define ANIMATION
#define DRAW_MECH
#define DRAW_ENVIRO
#define MOVE_LIGHT
/* end of compilation conditions */

/* start various header files needed */
#include "opengl_bridge.h"

#include <math.h>

#define GLUT
#define GLUT_KEY
#define GLUT_SPEC

#include "glu.h"


/* end of header files */

/* start of display list definitions */
#define SOLID_MECH_TORSO       	1
#define SOLID_MECH_HIP          2
#define SOLID_MECH_SHOULDER     3
#define SOLID_MECH_UPPER_ARM    4
#define SOLID_MECH_FOREARM	5
#define SOLID_MECH_UPPER_LEG   	6
#define SOLID_MECH_FOOT        	7
#define SOLID_MECH_ROCKET      	8
#define SOLID_MECH_VULCAN	9
#define SOLID_ENVIRO		10
#define SOLID_MECH_LOWER_LEG   	11
/* end of display list definitions */

/* start of motion rate variables */
#define ANKLE_RATE	3
#define HEEL_RATE	3
#define ROTATE_RATE	10
#define TILT_RATE	10
#define ELBOW_RATE	2
#define SHOULDER_RATE	5
#define LAT_RATE	5
#define CANNON_RATE	40
#define UPPER_LEG_RATE	3
#define UPPER_LEG_RATE_GROIN 10
#define LIGHT_TURN_RATE	10
#define VIEW_TURN_RATE	10
/* end of motion rate variables */

/* start of motion  variables */
#ifndef PI
#define PI 3.141592654
#endif

char leg = 0;

int shoulder1 = 0, shoulder2 = 0, shoulder3 = 0, shoulder4 = 0, lat1 = 20, lat2 = 20,
  elbow1 = 0, elbow2 = 0, pivot = 0, tilt = 10, ankle1 = 0, ankle2 = 0, heel1 = 0,
  heel2 = 0, hip11 = 0, hip12 = 10, hip21 = 0, hip22 = 10, fire = 1, solid_part = 1,
  anim = 0, turn = 0, turn1 = 0, lightturn = 0, lightturn1 = 0;

float elevation = 0.0, distance = 0.0, frame = 3.0
 /* foot1v[] = {} foot2v[] = {} */ ;

/* end of motion variables */

/* start of material definitions */
#ifdef LIGHT
GLfloat mat_specular[] =
{0.628281, 0.555802, 0.366065, 1.0};
GLfloat mat_ambient[] =
{0.24725, 0.1995, 0.0745, 1.0};
GLfloat mat_diffuse[] =
{0.75164, 0.60648, 0.22648, 1.0};
GLfloat mat_shininess[] =
{128.0 * 0.4};

GLfloat mat_specular2[] =
{0.508273, 0.508273, 0.508373, 1.0};
GLfloat mat_ambient2[] =
{0.19225, 0.19225, 0.19225, 1.0};
GLfloat mat_diffuse2[] =
{0.50754, 0.50754, 0.50754, 1.0};
GLfloat mat_shininess2[] =
{128.0 * 0.6};

GLfloat mat_specular3[] =
{0.296648, 0.296648, 0.296648, 1.0};
GLfloat mat_ambient3[] =
{0.25, 0.20725, 0.20725, 1.0};
GLfloat mat_diffuse3[] =
{1, 0.829, 0.829, 1.0};
GLfloat mat_shininess3[] =
{128.0 * 0.088};

GLfloat mat_specular4[] =
{0.633, 0.727811, 0.633, 1.0};
GLfloat mat_ambient4[] =
{0.0215, 0.1745, 0.0215, 1.0};
GLfloat mat_diffuse4[] =
{0.07568, 0.61424, 0.07568, 1.0};
GLfloat mat_shininess4[] =
{128 * 0.6};

GLfloat mat_specular5[] =
{0.60, 0.60, 0.50, 1.0};
GLfloat mat_ambient5[] =
{0.0, 0.0, 0.0, 1.0};
GLfloat mat_diffuse5[] =
{0.5, 0.5, 0.0, 1.0};
GLfloat mat_shininess5[] =
{128.0 * 0.25};

#endif
/* end of material definitions */

/* start of geometric shape functions */
void
Box(float width, float height, float depth, char solid)
{
  char i, j = 0;
  float x = width / 2.0, y = height / 2.0, z = depth / 2.0;

  for (i = 0; i < 4; i++) {
    glRotatef(90.0, 0.0, 0.0, 1.0);
    if (j) {
      if (!solid)
        glBegin(GL_LINE_LOOP);
      else
        glBegin(GL_QUADS);
      glNormal3f(-1.0, 0.0, 0.0);
      glVertex3f(-x, y, z);
      glVertex3f(-x, -y, z);
      glVertex3f(-x, -y, -z);
      glVertex3f(-x, y, -z);
      glEnd();
      if (solid) {
        glBegin(GL_TRIANGLES);
        glNormal3f(0.0, 0.0, 1.0);
        glVertex3f(0.0, 0.0, z);
        glVertex3f(-x, y, z);
        glVertex3f(-x, -y, z);
        glNormal3f(0.0, 0.0, -1.0);
        glVertex3f(0.0, 0.0, -z);
        glVertex3f(-x, -y, -z);
        glVertex3f(-x, y, -z);
        glEnd();
      }
      j = 0;
    } else {
      if (!solid)
        glBegin(GL_LINE_LOOP);
      else
        glBegin(GL_QUADS);
      glNormal3f(-1.0, 0.0, 0.0);
      glVertex3f(-y, x, z);
      glVertex3f(-y, -x, z);
      glVertex3f(-y, -x, -z);
      glVertex3f(-y, x, -z);
      glEnd();
      if (solid) {
        glBegin(GL_TRIANGLES);
        glNormal3f(0.0, 0.0, 1.0);
        glVertex3f(0.0, 0.0, z);
        glVertex3f(-y, x, z);
        glVertex3f(-y, -x, z);
        glNormal3f(0.0, 0.0, -1.0);
        glVertex3f(0.0, 0.0, -z);
        glVertex3f(-y, -x, -z);
        glVertex3f(-y, x, -z);
        glEnd();
      }
      j = 1;
    }
  }
}

void
Octagon(float side, float height, char solid)
{
  char j;
  float x = sin(0.785398163) * side, y = side / 2.0, z = height / 2.0, c;

  c = x + y;
  for (j = 0; j < 8; j++) {
    glTranslatef(-c, 0.0, 0.0);
    if (!solid)
      glBegin(GL_LINE_LOOP);
    else
      glBegin(GL_QUADS);
    glNormal3f(-1.0, 0.0, 0.0);
    glVertex3f(0.0, -y, z);
    glVertex3f(0.0, y, z);
    glVertex3f(0.0, y, -z);
    glVertex3f(0.0, -y, -z);
    glEnd();
    glTranslatef(c, 0.0, 0.0);
    if (solid) {
      glBegin(GL_TRIANGLES);
      glNormal3f(0.0, 0.0, 1.0);
      glVertex3f(0.0, 0.0, z);
      glVertex3f(-c, -y, z);
      glVertex3f(-c, y, z);
      glNormal3f(0.0, 0.0, -1.0);
      glVertex3f(0.0, 0.0, -z);
      glVertex3f(-c, y, -z);
      glVertex3f(-c, -y, -z);
      glEnd();
    }
    glRotatef(45.0, 0.0, 0.0, 1.0);
  }
}

/* end of geometric shape functions */
#ifdef NORM
void
Normalize(float v[3])
{
  GLfloat d = sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3]);

  if (d == 0.0) {
    return;
  }
  v[1] /= d;
  v[2] /= d;
  v[3] /= d;
}

void
NormXprod(float v1[3], float v2[3], float v[3], float out[3])
{
  GLint i, j;
  GLfloat length;

  out[0] = v1[1] * v2[2] - v1[2] * v2[1];
  out[1] = v1[2] * v2[0] - v1[0] * v2[2];
  out[2] = v1[0] * v2[1] - v1[1] * v2[0];
  Normalize(out);
}

#endif

void
SetMaterial(GLfloat spec[], GLfloat amb[], GLfloat diff[], GLfloat shin[])
{

  glMaterialfv(GL_FRONT, GL_SPECULAR, spec);
  glMaterialfv(GL_FRONT, GL_SHININESS, shin);
  glMaterialfv(GL_FRONT, GL_AMBIENT, amb);
  glMaterialfv(GL_FRONT, GL_DIFFUSE, diff);
}

void
MechTorso(char solid)
{
  glNewList(SOLID_MECH_TORSO, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  Box(1.0, 1.0, 3.0, solid);
  glTranslatef(0.75, 0.0, 0.0);
#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);
  Box(0.5, 0.6, 2.0, solid);
  glTranslatef(-1.5, 0.0, 0.0);
  Box(0.5, 0.6, 2.0, solid);
  glTranslatef(0.75, 0.0, 0.0);
  glEndList();
}

void
MechHip(char solid)
{
  int i;
  GLUquadricObj *hip[2];

  glNewList(SOLID_MECH_HIP, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  Octagon(0.7, 0.5, solid);
#ifdef SPHERE
  for (i = 0; i < 2; i++) {
    if (i)
      glScalef(-1.0, 1.0, 1.0);
    glTranslatef(1.0, 0.0, 0.0);
    hip[i] = gluNewQuadric();
#ifdef LIGHT
    SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
    glColor3f(0.5, 0.5, 0.5);
    if (!solid)
      gluQuadricDrawStyle(hip[i], GLU_LINE);
    gluSphere(hip[0], 0.2, 16, 16);
    glTranslatef(-1.0, 0.0, 0.0);
  }
  glScalef(-1.0, 1.0, 1.0);
#endif
  glEndList();
}

void
Shoulder(char solid)
{
  GLUquadricObj *deltoid = gluNewQuadric();

  glNewList(SOLID_MECH_SHOULDER, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  Box(1.0, 0.5, 0.5, solid);
  glTranslatef(0.9, 0.0, 0.0);
#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);
#ifdef SPHERE
  if (!solid)
    gluQuadricDrawStyle(deltoid, GLU_LINE);
  gluSphere(deltoid, 0.6, 16, 16);
#endif
  glTranslatef(-0.9, 0.0, 0.0);
  glEndList();
}

void
UpperArm(char solid)
{
  GLUquadricObj *upper = gluNewQuadric();
  GLUquadricObj *joint[2];
  GLUquadricObj *joint1[2];
  int i;

  glNewList(SOLID_MECH_UPPER_ARM, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  Box(1.0, 2.0, 1.0, solid);
  glTranslatef(0.0, -0.95, 0.0);
  glRotatef(90.0, 1.0, 0.0, 0.0);
#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);
  if (!solid)
    gluQuadricDrawStyle(upper, GLU_LINE);
  gluCylinder(upper, 0.4, 0.4, 1.5, 16, 10);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  glRotatef(-90.0, 1.0, 0.0, 0.0);
  glTranslatef(-0.4, -1.85, 0.0);
  glRotatef(90.0, 0.0, 1.0, 0.0);
  for (i = 0; i < 2; i++) {
    joint[i] = gluNewQuadric();
    if (!solid)
      gluQuadricDrawStyle(joint[i], GLU_LINE);
    if (i)
      gluCylinder(joint[i], 0.5, 0.5, 0.8, 16, 10);
    else
      gluCylinder(joint[i], 0.2, 0.2, 0.8, 16, 10);
  }
  for (i = 0; i < 2; i++) {
    if (i)
      glScalef(-1.0, 1.0, 1.0);
    joint1[i] = gluNewQuadric();
    if (!solid)
      gluQuadricDrawStyle(joint1[i], GLU_LINE);
    if (i)
      glTranslatef(0.0, 0.0, 0.8);
    gluDisk(joint1[i], 0.2, 0.5, 16, 10);
    if (i)
      glTranslatef(0.0, 0.0, -0.8);
  }
  glScalef(-1.0, 1.0, 1.0);
  glRotatef(-90.0, 0.0, 1.0, 0.0);
  glTranslatef(0.4, 2.9, 0.0);
  glEndList();
}

void
VulcanGun(char solid)
{
  int i;
  GLUquadricObj *Barrel[5];
  GLUquadricObj *BarrelFace[5];
  GLUquadricObj *Barrel2[5];
  GLUquadricObj *Barrel3[5];
  GLUquadricObj *BarrelFace2[5];
  GLUquadricObj *Mount = gluNewQuadric();
  GLUquadricObj *Mount_face = gluNewQuadric();

  glNewList(SOLID_MECH_VULCAN, GL_COMPILE);

#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);

  if (!solid) {
    gluQuadricDrawStyle(Mount, GLU_LINE);
    gluQuadricDrawStyle(Mount_face, GLU_LINE);
  }
  gluCylinder(Mount, 0.5, 0.5, 0.5, 16, 10);
  glTranslatef(0.0, 0.0, 0.5);
  gluDisk(Mount_face, 0.0, 0.5, 16, 10);

  for (i = 0; i < 5; i++) {
    Barrel[i] = gluNewQuadric();
    BarrelFace[i] = gluNewQuadric();
    BarrelFace2[i] = gluNewQuadric();
    Barrel2[i] = gluNewQuadric();
    Barrel3[i] = gluNewQuadric();
    glRotatef(72.0, 0.0, 0.0, 1.0);
    glTranslatef(0.0, 0.3, 0.0);
    if (!solid) {
      gluQuadricDrawStyle(Barrel[i], GLU_LINE);
      gluQuadricDrawStyle(BarrelFace[i], GLU_LINE);
      gluQuadricDrawStyle(BarrelFace2[i], GLU_LINE);
      gluQuadricDrawStyle(Barrel2[i], GLU_LINE);
      gluQuadricDrawStyle(Barrel3[i], GLU_LINE);
    }
    gluCylinder(Barrel[i], 0.15, 0.15, 2.0, 16, 10);
    gluCylinder(Barrel3[i], 0.06, 0.06, 2.0, 16, 10);
    glTranslatef(0.0, 0.0, 2.0);
    gluDisk(BarrelFace[i], 0.1, 0.15, 16, 10);
    gluCylinder(Barrel2[i], 0.1, 0.1, 0.1, 16, 5);
    glTranslatef(0.0, 0.0, 0.1);
    gluDisk(BarrelFace2[i], 0.06, 0.1, 16, 5);
    glTranslatef(0.0, -0.3, -2.1);
  }
  glEndList();
}

void
ForeArm(char solid)
{
  char i;

  glNewList(SOLID_MECH_FOREARM, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  for (i = 0; i < 5; i++) {
    glTranslatef(0.0, -0.1, -0.15);
    Box(0.6, 0.8, 0.2, solid);
    glTranslatef(0.0, 0.1, -0.15);
    Box(0.4, 0.6, 0.1, solid);
  }
  glTranslatef(0.0, 0.0, 2.45);
  Box(1.0, 1.0, 2.0, solid);
  glTranslatef(0.0, 0.0, -1.0);
  glEndList();
}

void
UpperLeg(char solid)
{
  int i;
  GLUquadricObj *Hamstring = gluNewQuadric();
  GLUquadricObj *Knee = gluNewQuadric();
  GLUquadricObj *joint[2];

  glNewList(SOLID_MECH_UPPER_LEG, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  if (!solid) {
    gluQuadricDrawStyle(Hamstring, GLU_LINE);
    gluQuadricDrawStyle(Knee, GLU_LINE);
  }
  glTranslatef(0.0, -1.0, 0.0);
  Box(0.4, 1.0, 0.7, solid);
  glTranslatef(0.0, -0.65, 0.0);
  for (i = 0; i < 5; i++) {
    Box(1.2, 0.3, 1.2, solid);
    glTranslatef(0.0, -0.2, 0.0);
    Box(1.0, 0.1, 1.0, solid);
    glTranslatef(0.0, -0.2, 0.0);
  }
  glTranslatef(0.0, -0.15, -0.4);
  Box(2.0, 0.5, 2.0, solid);
  glTranslatef(0.0, -0.3, -0.2);
  glRotatef(90.0, 1.0, 0.0, 0.0);
#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);
  gluCylinder(Hamstring, 0.6, 0.6, 3.0, 16, 10);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  glRotatef(-90.0, 1.0, 0.0, 0.0);
  glTranslatef(0.0, -1.5, 1.0);
  Box(1.5, 3.0, 0.5, solid);
  glTranslatef(0.0, -1.75, -0.8);
  Box(2.0, 0.5, 2.0, solid);
  glTranslatef(0.0, -0.9, -0.85);
#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);
  gluCylinder(Knee, 0.8, 0.8, 1.8, 16, 10);
  for (i = 0; i < 2; i++) {
    if (i)
      glScalef(-1.0, 1.0, 1.0);
    joint[i] = gluNewQuadric();
    if (!solid)
      gluQuadricDrawStyle(joint[i], GLU_LINE);
    if (i)
      glTranslatef(0.0, 0.0, 1.8);
    gluDisk(joint[i], 0.0, 0.8, 16, 10);
    if (i)
      glTranslatef(0.0, 0.0, -1.8);
  }
  glScalef(-1.0, 1.0, 1.0);
  glEndList();
}

void
Foot(char solid)
{
  glNewList(SOLID_MECH_FOOT, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);
  glRotatef(90.0, 1.0, 0.0, 0.0);
  Octagon(1.5, 0.6, solid);
  glRotatef(-90.0, 1.0, 0.0, 0.0);
  glEndList();
}

void
LowerLeg(char solid)
{
  glNewList(SOLID_MECH_LOWER_LEG, GL_COMPILE);

  float k, l;
  GLUquadricObj *ankle = gluNewQuadric();
  GLUquadricObj *ankle_face[2],*joints;

#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  for (k = 0.0; k < 2.0; k++) {
    for (l = 0.0; l < 2.0; l++) {
      glPushMatrix();
      glTranslatef(k, 0.0, l);
#ifdef LIGHT
      SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
      glColor3f(1.0, 1.0, 0.0);
      Box(1.0, 0.5, 1.0, solid);
      glTranslatef(0.0, -0.45, 0.0);
#ifdef LIGHT
      SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
      glColor3f(0.5, 0.5, 0.5);
#ifdef SPHERE
      joints = gluNewQuadric();
      if(!solid)gluQuadricDrawStyle(joints, GLU_LINE);
      gluSphere(joints,0.2, 16, 16); 
//      gl_free(joints);
#endif
      if (leg)
        glRotatef((GLfloat) heel1, 1.0, 0.0, 0.0);
      else
        glRotatef((GLfloat) heel2, 1.0, 0.0, 0.0);
      /* glTranslatef(0.0, -0.2, 0.0); */
      glTranslatef(0.0, -1.7, 0.0);
#ifdef LIGHT
      SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
      glColor3f(1.0, 1.0, 0.0);
      Box(0.25, 3.0, 0.25, solid);
      glTranslatef(0.0, -1.7, 0.0);
#ifdef LIGHT
      SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
      glColor3f(0.5, 0.5, 0.5);
#ifdef SPHERE
      joints = gluNewQuadric();
      if(!solid)gluQuadricDrawStyle(joints, GLU_LINE);
      gluSphere(joints, 0.2, 16, 16);
#endif
      if (leg)
        glRotatef((GLfloat) - heel1, 1.0, 0.0, 0.0);
      else
        glRotatef((GLfloat) - heel2, 1.0, 0.0, 0.0);
      glTranslatef(0.0, -0.45, 0.0);
#ifdef LIGHT
      SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
      glColor3f(1.0, 1.0, 0.0);
      Box(1.0, 0.5, 1.0, solid);
      if (!k && !l) {
        int j;

        glTranslatef(-0.4, -0.8, 0.5);
        if (leg)
          glRotatef((GLfloat) ankle1, 1.0, 0.0, 0.0);
        else
          glRotatef((GLfloat) ankle2, 1.0, 0.0, 0.0);
        glRotatef(90.0, 0.0, 1.0, 0.0);
        if (!solid)
          gluQuadricDrawStyle(ankle, GLU_LINE);
        gluCylinder(ankle, 0.8, 0.8, 1.8, 16, 10);
        for (j = 0; j < 2; j++) {
          ankle_face[j] = gluNewQuadric();
          if (!solid)
            gluQuadricDrawStyle(ankle_face[j], GLU_LINE);
          if (j) {
            glScalef(-1.0, 1.0, 1.0);
            glTranslatef(0.0, 0.0, 1.8);
          }
          gluDisk(ankle_face[j], 0.0, 0.8, 16, 10);
          if (j)
            glTranslatef(0.0, 0.0, -1.8);
        }
        glScalef(-1.0, 1.0, 1.0);
        glRotatef(-90.0, 0.0, 1.0, 0.0);
        glTranslatef(0.95, -0.8, 0.0);
        glCallList(SOLID_MECH_FOOT);
      }
      glPopMatrix();
    }
  }
  glEndList();
}

void
RocketPod(char solid)
{

  int i, j, k = 0;
  GLUquadricObj *rocket[6];
  GLUquadricObj *rocket1[6];

  glNewList(SOLID_MECH_ROCKET, GL_COMPILE);
#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glColor3f(0.5, 0.5, 0.5);
  glScalef(0.4, 0.4, 0.4);
  glRotatef(45.0, 0.0, 0.0, 1.0);
  glTranslatef(1.0, 0.0, 0.0);
  Box(2.0, 0.5, 3.0, solid);
  glTranslatef(1.0, 0.0, 0.0);
  glRotatef(45.0, 0.0, 0.0, 1.0);
  glTranslatef(0.5, 0.0, 0.0);
  Box(1.2, 0.5, 3.0, solid);
  glTranslatef(2.1, 0.0, 0.0);
  glRotatef(-90.0, 0.0, 0.0, 1.0);
#ifdef LIGHT
  SetMaterial(mat_specular, mat_ambient, mat_diffuse, mat_shininess);
#endif
  glColor3f(1.0, 1.0, 0.0);
  Box(2.0, 3.0, 4.0, solid);
  glTranslatef(-0.5, -1.0, 1.3);
  for (i = 0; i < 2; i++) {
    for (j = 0; j < 3; j++) {
      rocket[k] = gluNewQuadric();
      rocket1[k] = gluNewQuadric();
      if (!solid) {
        gluQuadricDrawStyle(rocket[k], GLU_LINE);
        gluQuadricDrawStyle(rocket1[k], GLU_LINE);
      }
      glTranslatef(i, j, 0.6);
#ifdef LIGHT
      SetMaterial(mat_specular3, mat_ambient3, mat_diffuse3, mat_shininess3);
#endif
      glColor3f(1.0, 1.0, 1.0);
      gluCylinder(rocket[k], 0.4, 0.4, 0.3, 16, 10);
      glTranslatef(0.0, 0.0, 0.3);
#ifdef LIGHT
      SetMaterial(mat_specular4, mat_ambient4, mat_diffuse4, mat_shininess4);
#endif
      glColor3f(0.0, 1.0, 0.0);
      gluCylinder(rocket1[k], 0.4, 0.0, 0.5, 16, 10);
      k++;
      glTranslatef(-i, -j, -0.9);
    }
  }
  glEndList();
}

void
Enviro(char solid)
{

  int i, j;

  glNewList(SOLID_ENVIRO, GL_COMPILE);
  SetMaterial(mat_specular4, mat_ambient4, mat_diffuse4, mat_shininess4);
  glColor3f(0.0, 1.0, 0.0);
  Box(20.0, 0.5, 30.0, solid);

  SetMaterial(mat_specular4, mat_ambient3, mat_diffuse2, mat_shininess);
  glColor3f(0.6, 0.6, 0.6);
  glTranslatef(0.0, 0.0, -10.0);
  for (j = 0; j < 6; j++) {
    for (i = 0; i < 2; i++) {
      if (i)
        glScalef(-1.0, 1.0, 1.0);
      glTranslatef(10.0, 4.0, 0.0);
      Box(4.0, 8.0, 2.0, solid);
      glTranslatef(0.0, -1.0, -3.0);
      Box(4.0, 6.0, 2.0, solid);
      glTranslatef(-10.0, -3.0, 3.0);
    }
    glScalef(-1.0, 1.0, 1.0);
    glTranslatef(0.0, 0.0, 5.0);
  }

  glEndList();
}

void
Toggle(void)
{
  if (solid_part)
    solid_part = 0;
  else
    solid_part = 1;
}

void
disable(void)
{
  glDisable(GL_LIGHTING);
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_NORMALIZE);
  glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
}

void
lighting(void)
{

  GLfloat position[] =
  {0.0, 0.0, 2.0, 1.0};

#ifdef MOVE_LIGHT
  glRotatef((GLfloat) lightturn1, 1.0, 0.0, 0.0);
  glRotatef((GLfloat) lightturn, 0.0, 1.0, 0.0);
  glRotatef(0.0, 1.0, 0.0, 0.0);
#endif
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_NORMALIZE);
  /* glEnable(GL_FLAT); */
  /*  glDepthFunc(GL_LESS); */
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

  glLightfv(GL_LIGHT0, GL_POSITION, position);
  glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 80.0);

  glTranslatef(0.0, 0.0, 2.0);
  glDisable(GL_LIGHTING);
  Box(0.1, 0.1, 0.1, 0);
  glEnable(GL_LIGHTING);
  /* glEnable(GL_CULL_FACE); */
}

void
DrawMech(void)
{
  int i, j;

  glScalef(0.5, 0.5, 0.5);
  glPushMatrix();
  glTranslatef(0.0, -0.75, 0.0);
  glRotatef((GLfloat) tilt, 1.0, 0.0, 0.0);

  glRotatef(90.0, 1.0, 0.0, 0.0);
#ifdef HIP
  glCallList(SOLID_MECH_HIP);
#endif
  glRotatef(-90.0, 1.0, 0.0, 0.0);

  glTranslatef(0.0, 0.75, 0.0);
  glPushMatrix();
  glRotatef((GLfloat) pivot, 0.0, 1.0, 0.0);
  glPushMatrix();
#ifdef TORSO
  glCallList(SOLID_MECH_TORSO);
#endif
  glPopMatrix();
  glPushMatrix();
  glTranslatef(0.5, 0.5, 0.0);
#ifdef ROCKET_POD
  glCallList(SOLID_MECH_ROCKET);
#endif
  glPopMatrix();
  for (i = 0; i < 2; i++) {
    glPushMatrix();
    if (i)
      glScalef(-1.0, 1.0, 1.0);
    glTranslatef(1.5, 0.0, 0.0);
#ifdef SHOULDER
    glCallList(SOLID_MECH_SHOULDER);
#endif
    glTranslatef(0.9, 0.0, 0.0);
    if (i) {
      glRotatef((GLfloat) lat1, 0.0, 0.0, 1.0);
      glRotatef((GLfloat) shoulder1, 1.0, 0.0, 0.0);
      glRotatef((GLfloat) shoulder3, 0.0, 1.0, 0.0);
    } else {
      glRotatef((GLfloat) lat2, 0.0, 0.0, 1.0);
      glRotatef((GLfloat) shoulder2, 1.0, 0.0, 0.0);
      glRotatef((GLfloat) shoulder4, 0.0, 1.0, 0.0);
    }
    glTranslatef(0.0, -1.4, 0.0);
#ifdef UPPER_ARM
    glCallList(SOLID_MECH_UPPER_ARM);
#endif
    glTranslatef(0.0, -2.9, 0.0);
    if (i)
      glRotatef((GLfloat) elbow1, 1.0, 0.0, 0.0);
    else
      glRotatef((GLfloat) elbow2, 1.0, 0.0, 0.0);
    glTranslatef(0.0, -0.9, -0.2);
#ifdef LOWER_ARM
    glCallList(SOLID_MECH_FOREARM);
    glPushMatrix();
    glTranslatef(0.0, 0.0, 2.0);
    glRotatef((GLfloat) fire, 0.0, 0.0, 1.0);
    glCallList(SOLID_MECH_VULCAN);
    glPopMatrix();
#endif
    glPopMatrix();
  }
  glPopMatrix();

  glPopMatrix();

  for (j = 0; j < 2; j++) {
    glPushMatrix();
    if (j) {
      glScalef(-0.5, 0.5, 0.5);
      leg = 1;
    } else {
      glScalef(0.5, 0.5, 0.5);
      leg = 0;
    }
    glTranslatef(2.0, -1.5, 0.0);
    if (j) {
      glRotatef((GLfloat) hip11, 1.0, 0.0, 0.0);
      glRotatef((GLfloat) hip12, 0.0, 0.0, 1.0);
    } else {
      glRotatef((GLfloat) hip21, 1.0, 0.0, 0.0);
      glRotatef((GLfloat) hip22, 0.0, 0.0, 1.0);
    }
    glTranslatef(0.0, 0.3, 0.0);
#ifdef UPPER_LEG
    glPushMatrix();
    glCallList(SOLID_MECH_UPPER_LEG);
    glPopMatrix();
#endif
    glTranslatef(0.0, -8.3, -0.4);
    if (j)
      glRotatef((GLfloat) - hip12, 0.0, 0.0, 1.0);
    else
      glRotatef((GLfloat) - hip22, 0.0, 0.0, 1.0);
    glTranslatef(-0.5, -0.85, -0.5);
#ifdef LOWER_LEG
//    LowerLeg(1);
    glPushMatrix();
    glCallList(SOLID_MECH_LOWER_LEG);
    glPopMatrix();
#endif
    glPopMatrix();
  }
}

void
display(void)
{
  glClearColor(0.0, 0.0, 0.0, 0.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glEnable(GL_DEPTH_TEST);

  glPushMatrix();
  glRotatef((GLfloat) turn, 0.0, 1.0, 0.0);
  glRotatef((GLfloat) turn1, 1.0, 0.0, 0.0);
#ifdef LIGHT
  if (solid_part) {
    glPushMatrix();
    lighting();
    glPopMatrix();
  } else
    disable();
#endif
#ifdef DRAW_MECH
  glPushMatrix();
  glTranslatef(0.0, elevation, 0.0);
  DrawMech();
  glPopMatrix();
#endif
#ifdef DRAW_ENVIRO
  glPushMatrix();
  if (distance >= 20.136)
    distance = 0.0;
  glTranslatef(0.0, -5.0, -distance);
  glCallList(SOLID_ENVIRO);
  glTranslatef(0.0, 0.0, 10.0);
  glCallList(SOLID_ENVIRO);
  glPopMatrix();
#endif
  glPopMatrix();
  glFlush();

}

void
reshape(int w, int h)
{
  glViewport(0, 0, w, h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(65.0, (GLfloat) w / (GLfloat) h, 1.0, 20.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(0.0, 1.2, -5.5);  /* viewing transform  */
}


void
init(void)
{
  char i = 1;

#ifdef LIGHT
  SetMaterial(mat_specular2, mat_ambient2, mat_diffuse2, mat_shininess2);
#endif
  glEnable(GL_DEPTH_TEST);
  MechTorso(i);
  MechHip(i);
  Shoulder(i);
  RocketPod(i);
  UpperArm(i);
  ForeArm(i);
  UpperLeg(i);
  LowerLeg(i);
  Foot(i);
  VulcanGun(i);
  Enviro(i);

   reshape(640,480);
}

#ifdef ANIMATION
void
animation_walk(void)
{
  float angle;
  static int step;

  if (step == 0 || step == 2) {
    /* for(frame=3.0; frame<=21.0; frame=frame+3.0){ */
    if (frame >= 0.0 && frame <= 21.0) {
      if (frame == 0.0)
        frame = 3.0;
      angle = (180 / PI) * (acos(((cos((PI / 180) * frame) * 2.043) + 1.1625) / 3.2059));
      if (frame > 0) {
        elevation = -(3.2055 - (cos((PI / 180) * angle) * 3.2055));
      } else
        elevation = 0.0;
      if (step == 0) {
        hip11 = -(frame * 1.7);
        if (1.7 * frame > 15)
          heel1 = frame * 1.7;
        heel2 = 0;
        ankle1 = frame * 1.7;
        if (frame > 0)
          hip21 = angle;
        else
          hip21 = 0;
        ankle2 = -hip21;
        shoulder1 = frame * 1.5;
        shoulder2 = -frame * 1.5;
        elbow1 = frame;
        elbow2 = -frame;
      } else {
        hip21 = -(frame * 1.7);
        if (1.7 * frame > 15)
          heel2 = frame * 1.7;
        heel1 = 0;
        ankle2 = frame * 1.7;
        if (frame > 0)
          hip11 = angle;
        else
          hip11 = 0;
        ankle1 = -hip11;
        shoulder1 = -frame * 1.5;
        shoulder2 = frame * 1.5;
        elbow1 = -frame;
        elbow2 = frame;
      }
      if (frame == 21)
        step++;
      if (frame < 21)
        frame = frame + 3.0;
    }
  }
  if (step == 1 || step == 3) {
    /* for(x=21.0; x>=0.0; x=x-3.0){ */
    if (frame <= 21.0 && frame >= 0.0) {
      angle = (180 / PI) * (acos(((cos((PI / 180) * frame) * 2.043) + 1.1625) / 3.2029));
      if (frame > 0)
        elevation = -(3.2055 - (cos((PI / 180) * angle) * 3.2055));
      else
        elevation = 0.0;
      if (step == 1) {
        elbow2 = hip11 = -frame;
        elbow1 = heel1 = frame;
        heel2 = 15;
        ankle1 = frame;
        if (frame > 0)
          hip21 = angle;
        else
          hip21 = 0;
        ankle2 = -hip21;
        shoulder1 = 1.5 * frame;
        shoulder2 = -frame * 1.5;
      } else {
        elbow1 = hip21 = -frame;
        elbow2 = heel2 = frame;
        heel1 = 15;
        ankle2 = frame;
        if (frame > 0)
          hip11 = angle;
        else
          hip11 = 0;
        ankle1 = -hip11;
        shoulder1 = -frame * 1.5;
        shoulder2 = frame * 1.5;
      }
      if (frame == 0.0)
        step++;
      if (frame > 0)
        frame = frame - 3.0;
    }
  }
  if (step == 4)
    step = 0;
  distance += 0.1678;
}

void
animation(void)
{
  animation_walk();
}

#endif

void draw( void )
{
    animation();
    display();
}

