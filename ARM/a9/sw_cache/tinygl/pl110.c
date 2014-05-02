
#include "pl110.h"
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>


/*  Prototype  */
static int pl110_resize_viewport( GLContext *c, int *xsize_ptr, int *ysize_ptr );


/*  Create context  */
pl110_Context *pl110_CreateContext(){
	pl110_Context *ctx;

	ctx = (pl110_Context*)gl_malloc( sizeof(pl110_Context) );
	if( ctx == NULL ){
		return NULL;
	}
	ctx->gl_context = NULL;
	return ctx;
}


/*!  Destroy context  */
void pl110_DestroyContext( pl110_Context *ctx ){
	if( ctx->gl_context != NULL ){
		glClose();
	}
	gl_free( ctx );
}


int pl110_MakeCurrent(pl110_Context *ctx ){
	int	mode;
	int	xsize;
	int	ysize;

	ZBuffer *zb;

	if( ctx->gl_context == NULL ){
		xsize = 640;
		ysize = 480;
		mode = ZB_MODE_5R6G5B;

		zb = ZB_open( xsize, ysize, mode, 0, NULL, NULL, NULL);
		
		if( zb == NULL ) {
			return 0;
		}

		/* initialisation of the TinyGL interpreter */
		glInit( zb );
		ctx->gl_context                     = gl_get_context();
		ctx->gl_context->opaque             = (void *) ctx;
		ctx->gl_context->gl_resize_viewport = pl110_resize_viewport;

		/* set the viewport */
		/*  TIS: !!! HERE SHOULD BE -1 on both to force reshape  */
		/*  which is needed to make sure initial reshape is  */
		/*  called, otherwise it is not called..  */
		ctx->gl_context->viewport.xsize = xsize;
		ctx->gl_context->viewport.ysize = ysize;
		glViewport( 0, 0, xsize, ysize );
	}
	return 1;
}


/*!  Swap buffers  */
void pl110_SwapBuffers(){
	GLContext        *gl_context;
        pl110_Context *ctx;

    gl_context = gl_get_context();
    ctx = (pl110_Context *)gl_context->opaque;

    void *fb = (uint16*) 0x40000000;
    ZB_copyFrameBuffer(ctx->gl_context->zb, fb, 640 * 2);
}


/*!  Resize context  */
static int pl110_resize_viewport( GLContext *c, int *xsize_ptr, int *ysize_ptr ){
	pl110_Context *ctx;
	int               xsize;
	int               ysize;
  
	ctx = (pl110_Context *)c->opaque;

	xsize = *xsize_ptr;
	ysize = *ysize_ptr;

	/* we ensure that xsize and ysize are multiples of 2 for the zbuffer. 
	   TODO: find a better solution */
	xsize &= ~3;
	ysize &= ~3;

	if (xsize == 0 || ysize == 0) return -1;

	*xsize_ptr = xsize;
	*ysize_ptr = ysize;

	/* resize the Z buffer */
        void *fb = (uint16*) 0x40000000;
	ZB_resize( c->zb, fb, xsize, ysize );
	return 0;
}

