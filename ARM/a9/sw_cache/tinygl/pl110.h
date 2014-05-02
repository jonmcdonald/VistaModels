
#ifndef TEDDY__TINY_GL__PL110_H
#define TEDDY__TINY_GL__PL110_H


#ifdef __cplusplus
extern "C" {
#endif

#include <GL/gl.h>
#include "zgl.h"

typedef unsigned short		uint16;

typedef struct {
	GLContext   *gl_context;
} pl110_Context;


extern pl110_Context *pl110_CreateContext ();
extern void           pl110_DestroyContext( pl110_Context *ctx );
extern int            pl110_MakeCurrent   ( pl110_Context *ctx );
extern void           pl110_SwapBuffers   ();


#ifdef __cplusplus
}
#endif


#endif


