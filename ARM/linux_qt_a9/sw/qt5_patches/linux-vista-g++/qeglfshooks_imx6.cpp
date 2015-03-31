/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the qmake spec of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL21$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia. For licensing terms and
** conditions see http://qt.digia.com/licensing. For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 or version 3 as published by the Free
** Software Foundation and appearing in the file LICENSE.LGPLv21 and
** LICENSE.LGPLv3 included in the packaging of this file. Please review the
** following information to ensure the GNU Lesser General Public License
** requirements will be met: https://www.gnu.org/licenses/lgpl.html and
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights. These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qeglfshooks.h"
//#include <EGL/eglvivante.h>
#include <QDebug>

#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <linux/fb.h>
#include <fcntl.h>

#define EGL_EGLEXT_PROTOTYPES
#include "EGL/egl.h"
#include "EGL/eglext.h"

extern "C" {

typedef void (*EGLUTidleCB)(void);
typedef void (*EGLUTreshapeCB)(int, int);
typedef void (*EGLUTdisplayCB)(void);
typedef void (*EGLUTkeyboardCB)(unsigned char);
typedef void (*EGLUTspecialCB)(int);

void
_eglutFatal(char *format, ...);


struct eglut_window {
   EGLConfig config;
   EGLContext context;

   /* initialized by native display */
   struct {
      union {
         EGLNativeWindowType window;
         EGLNativePixmapType pixmap;
         EGLSurface surface; /* pbuffer or screen surface */
      } u;
      int width, height;
   } native;

   EGLSurface surface;

   int index;

   EGLUTreshapeCB reshape_cb;
   EGLUTdisplayCB display_cb;
   EGLUTkeyboardCB keyboard_cb;
   EGLUTspecialCB special_cb;
};

struct eglut_state {
   int api_mask;
   int window_width, window_height;
   char *display_name;
   int verbose;
   int init_time;

   EGLUTidleCB idle_cb;

   int num_windows;

   /* initialized by native display */
   EGLNativeDisplayType native_dpy;
   EGLint surface_type;

   EGLDisplay dpy;
   EGLint major, minor;

   struct eglut_window *current;

   int redisplay;
};

extern struct eglut_state *_eglut;

/* used by eglutInitAPIMask */
enum {
   EGLUT_OPENGL_BIT     = 0x1,
   EGLUT_OPENGL_ES1_BIT = 0x2,
   EGLUT_OPENGL_ES2_BIT = 0x4,
   EGLUT_OPENVG_BIT     = 0x8
};

#define MAX_MODES 100

static EGLScreenMESA kms_screen;
static EGLModeMESA kms_mode;
static EGLint kms_width, kms_height;

void
_eglutNativeInitDisplay(char* dev)
{
    _eglut->native_dpy = EGL_DEFAULT_DISPLAY;
    if(dev != 0) {
        int fb_fd = open(dev, O_RDWR);
        if(fb_fd != -1) {
	   _eglut->native_dpy = (EGLNativeDisplayType) fb_fd;
        }
    }
   _eglut->surface_type = EGL_SCREEN_BIT_MESA;
}

void
_eglutNativeFiniDisplay(void)
{
   kms_screen = 0;
   kms_mode = 0;
   kms_width = 0;
   kms_height = 0;
}

static void
init_kms(void)
{
   EGLModeMESA modes[MAX_MODES];
   EGLint num_screens, num_modes;
   EGLint width, height, best_mode;
   EGLint i;

   if (!eglGetScreensMESA(_eglut->dpy, &kms_screen, 1, &num_screens) ||
         !num_screens)
      _eglutFatal("eglGetScreensMESA failed\n");

   if (!eglGetModesMESA(_eglut->dpy, kms_screen,
            modes, MAX_MODES, &num_modes) || !num_modes)
      _eglutFatal("eglGetModesMESA failed!\n");

   printf("Found %d modes:\n", num_modes);

   best_mode = 0;
   width = 0;
   height = 0;
   for (i = 0; i < num_modes; i++) {
      EGLint w, h;
      eglGetModeAttribMESA(_eglut->dpy, modes[i], EGL_WIDTH, &w);
      eglGetModeAttribMESA(_eglut->dpy, modes[i], EGL_HEIGHT, &h);
      printf("%3d: %d x %d\n", i, w, h);
      if (w > width && h > height) {
         width = w;
         height = h;
         best_mode = i;
      }
   }

   printf("Will use screen size: %d x %d\n", width, height);

   kms_mode = modes[best_mode];
   kms_width = width;
   kms_height = height;
}

void
_eglutNativeInitWindow(struct eglut_window *win, const char *title,
                       int x, int y, int w, int h)
{
   EGLint surf_attribs[16];
   EGLint i;
   const char *exts;

   exts = eglQueryString(_eglut->dpy, EGL_EXTENSIONS);
   if (!exts || !strstr(exts, "EGL_MESA_screen_surface"))
      _eglutFatal("EGL_MESA_screen_surface is not supported\n");

   init_kms();

   i = 0;
   surf_attribs[i++] = EGL_WIDTH;
   surf_attribs[i++] = kms_width;
   surf_attribs[i++] = EGL_HEIGHT;
   surf_attribs[i++] = kms_height;
   surf_attribs[i++] = EGL_NONE;

   /* create surface */
/*   win->native.u.surface = eglCreateScreenSurfaceMESA(_eglut->dpy,
         win->config, surf_attribs);
   if (win->native.u.surface == EGL_NO_SURFACE)
      _eglutFatal("eglCreateScreenSurfaceMESA failed\n");

   if (!eglShowScreenSurfaceMESA(_eglut->dpy, kms_screen,
            win->native.u.surface, kms_mode))
      _eglutFatal("eglShowScreenSurfaceMESA failed\n");
*/
   win->native.width = kms_width;
   win->native.height = kms_height;
}

void
_eglutNativeFiniWindow(struct eglut_window *win)
{
   eglShowScreenSurfaceMESA(_eglut->dpy,
         kms_screen, EGL_NO_SURFACE, 0);
   eglDestroySurface(_eglut->dpy, win->native.u.surface);
}

static struct eglut_state _eglut_state;

struct eglut_state *_eglut = &_eglut_state;

void
_eglutFatal(char *format, ...)
{
  va_list args;

  va_start(args, format);

  fprintf(stderr, "EGLUT: ");
  vfprintf(stderr, format, args);
  va_end(args);
  putc('\n', stderr);

  exit(1);
}

static void
_eglutDestroyWindow(struct eglut_window *win)
{
   if (_eglut->surface_type != EGL_PBUFFER_BIT &&
       _eglut->surface_type != EGL_SCREEN_BIT_MESA)
      eglDestroySurface(_eglut->dpy, win->surface);

   _eglutNativeFiniWindow(win);

   eglDestroyContext(_eglut->dpy, win->context);
}

static EGLConfig
_eglutChooseConfig(void)
{
   EGLConfig config;
   EGLint config_attribs[32];
   EGLint renderable_type, num_configs, i;

   i = 0;
   config_attribs[i++] = EGL_RED_SIZE;
   config_attribs[i++] = 1;
   config_attribs[i++] = EGL_GREEN_SIZE;
   config_attribs[i++] = 1;
   config_attribs[i++] = EGL_BLUE_SIZE;
   config_attribs[i++] = 1;
   config_attribs[i++] = EGL_DEPTH_SIZE;
   config_attribs[i++] = 1;

   config_attribs[i++] = EGL_SURFACE_TYPE;
   config_attribs[i++] = _eglut->surface_type;

   config_attribs[i++] = EGL_RENDERABLE_TYPE;
   renderable_type = 0x0;
   if (_eglut->api_mask & EGLUT_OPENGL_BIT)
      renderable_type |= EGL_OPENGL_BIT;
   if (_eglut->api_mask & EGLUT_OPENGL_ES1_BIT)
      renderable_type |= EGL_OPENGL_ES_BIT;
   if (_eglut->api_mask & EGLUT_OPENGL_ES2_BIT)
      renderable_type |= EGL_OPENGL_ES2_BIT;
   if (_eglut->api_mask & EGLUT_OPENVG_BIT)
      renderable_type |= EGL_OPENVG_BIT;
   config_attribs[i++] = renderable_type;

   config_attribs[i] = EGL_NONE;

   if (!eglChooseConfig(_eglut->dpy,
            config_attribs, &config, 1, &num_configs) || !num_configs)
      _eglutFatal("failed to choose a config");

   return config;
}

static struct eglut_window *
_eglutCreateWindow(const char *title, int x, int y, int w, int h)
{
   struct eglut_window *win;
   EGLint context_attribs[4];
   EGLint api, i;

   win = (eglut_window*) calloc(1, sizeof(*win));
   if (!win)
      _eglutFatal("failed to allocate window");

   win->config = _eglutChooseConfig();

   i = 0;
   context_attribs[i] = EGL_NONE;

   /* multiple APIs? */

   api = EGL_OPENGL_ES_API;
   if (_eglut->api_mask & EGLUT_OPENGL_BIT) {
      api = EGL_OPENGL_API;
   }
   else if (_eglut->api_mask & EGLUT_OPENVG_BIT) {
      api = EGL_OPENVG_API;
   }
   else if (_eglut->api_mask & EGLUT_OPENGL_ES2_BIT) {
      context_attribs[i++] = EGL_CONTEXT_CLIENT_VERSION;
      context_attribs[i++] = 2;
   }

   context_attribs[i] = EGL_NONE;

   eglBindAPI(api);
   win->context = eglCreateContext(_eglut->dpy,
         win->config, EGL_NO_CONTEXT, context_attribs);
   if (!win->context)
      _eglutFatal("failed to create context");

   _eglutNativeInitWindow(win, title, x, y, w, h);
   switch (_eglut->surface_type) {
   case EGL_WINDOW_BIT:
      win->surface = eglCreateWindowSurface(_eglut->dpy,
            win->config, win->native.u.window, NULL);
      break;
   case EGL_PIXMAP_BIT:
      win->surface = eglCreatePixmapSurface(_eglut->dpy,
            win->config, win->native.u.pixmap, NULL);
      break;
   case EGL_PBUFFER_BIT:
   case EGL_SCREEN_BIT_MESA:
      win->surface = win->native.u.surface;
      break;
   default:
      break;
   }
//   if (win->surface == EGL_NO_SURFACE)
//      _eglutFatal("failed to create surface");

   return win;
}

void
eglutInitAPIMask(int mask)
{
   _eglut->api_mask = mask;
}

void
eglutInitWindowSize(int width, int height)
{
   _eglut->window_width = width;
   _eglut->window_height = height;
}

void
eglutInit(int argc, char **argv)
{
   _eglut->api_mask = EGLUT_OPENGL_ES2_BIT;
   _eglut->window_width = 640;
   _eglut->window_height = 480;
   _eglut->verbose = 1;
   _eglut->num_windows = 0;

   int i;
   _eglut->display_name = 0;
   for (i = 1; i < argc; i++) {
      if (strcmp(argv[i], "-display") == 0)
         _eglut->display_name = argv[++i];
      else if (strcmp(argv[i], "-info") == 0) {
         _eglut->verbose = 1;
      }
   }

   _eglutNativeInitDisplay(_eglut->display_name);
   _eglut->dpy = eglGetDisplay(_eglut->native_dpy);

   if (!eglInitialize(_eglut->dpy, &_eglut->major, &_eglut->minor))
      _eglutFatal("failed to initialize EGL display");

   printf("EGL_VERSION = %s\n", eglQueryString(_eglut->dpy, EGL_VERSION));
   if (_eglut->verbose) {
      printf("EGL_VENDOR = %s\n", eglQueryString(_eglut->dpy, EGL_VENDOR));
      printf("EGL_EXTENSIONS = %s\n",
            eglQueryString(_eglut->dpy, EGL_EXTENSIONS));
      printf("EGL_CLIENT_APIS = %s\n",
            eglQueryString(_eglut->dpy, EGL_CLIENT_APIS));
   }
}

void
eglutDestroyWindow(int win)
{
   struct eglut_window *window = _eglut->current;

   if (window->index != win)
      return;

   /* XXX it causes some bug in st/egl KMS backend */
   if ( _eglut->surface_type != EGL_SCREEN_BIT_MESA)
      eglMakeCurrent(_eglut->dpy, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);

   _eglutDestroyWindow(_eglut->current);
}

int
eglutCreateWindow(const char *title)
{
   struct eglut_window *win;

   win = _eglutCreateWindow(title, 0, 0,
         _eglut->window_width, _eglut->window_height);

   win->index = _eglut->num_windows++;
   win->reshape_cb = NULL;
   win->display_cb = NULL;
   win->keyboard_cb = NULL;
   win->special_cb = NULL;

   if (!eglMakeCurrent(_eglut->dpy, win->surface, win->surface, win->context))
      _eglutFatal("failed to make window current");
   _eglut->current = win;

   return win->index;
}

int
eglutGetWindowWidth(void)
{
   struct eglut_window *win = _eglut->current;
   return win->native.width;
}

int
eglutGetWindowHeight(void)
{
   struct eglut_window *win = _eglut->current;
   return win->native.height;
}


}


QT_BEGIN_NAMESPACE

class QEglFSImx6Hooks : public QEglFSHooks
{
public:
    QEglFSImx6Hooks();
    virtual QSize screenSize() const;
    virtual EGLNativeWindowType createNativeWindow(QPlatformWindow *window, const QSize &size, const QSurfaceFormat &format);
    virtual void destroyNativeWindow(EGLNativeWindowType window);
    virtual EGLNativeDisplayType platformDisplay() const;

private:
    QSize mScreenSize;
    EGLNativeDisplayType mNativeDisplay;
    int win;
};


QEglFSImx6Hooks::QEglFSImx6Hooks()
{
   int width = 640, height = 480;
   eglutInitWindowSize(width, height);
   eglutInitAPIMask(EGLUT_OPENGL_ES2_BIT);
   eglutInit(0, 0);
   win = 0;
   mScreenSize.setWidth(width);
   mScreenSize.setHeight(height);

   printf(">>>>>>>>>>>>> here creating the win\n");

   win = eglutCreateWindow("egl_qt5");

   printf(">>>>>>>>>>>>> here done the init\n");
}

QSize QEglFSImx6Hooks::screenSize() const
{
   return mScreenSize;
}

EGLNativeDisplayType QEglFSImx6Hooks::platformDisplay() const
{
    return _eglut->native_dpy;
}

EGLNativeWindowType QEglFSImx6Hooks::createNativeWindow(QPlatformWindow *window, const QSize &size, const QSurfaceFormat &format)
{
    Q_UNUSED(window)
    Q_UNUSED(format)

   printf(">>>>>>>>>>>>> here getting win %p\n", _eglut->current->native.u.window);

   return _eglut->current->native.u.window;
}


void QEglFSImx6Hooks::destroyNativeWindow(EGLNativeWindowType window)
{
   eglutDestroyWindow(win);
   win = 0;
}

QEglFSImx6Hooks eglFSImx6Hooks;
QEglFSHooks *platformHooks = &eglFSImx6Hooks;

QT_END_NAMESPACE
