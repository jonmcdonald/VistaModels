This example demonstrates how it is possible to perform OpenGL
graphics on a ARM a9 virtual platform utilising the host GPU.

First download and build the latest SDL2 graphics library
for your host linux machine:

http://www.libsdl.org/release/SDL2-2.0.1.tar.gz

Once built and installed at a location, define the LD_LIBRARY_PATH
variable so the environment will find the SDL2 library, eg:

export LD_LIBRARY_PATH=/store/SDL2-2.0.1/lib

*** NOTE ***
Unfortunately the normal vista simulation fails due to a memory problem
this need investigating, this is the reason we need to build the VP.
************

Invoke Vista and build the virtual platform.

Build the software in the software folder.

Run, and you should see the gears demo running using the host GPU
with a very nice frame rate.

*** NOTE ***
Only a small subset of the OpenGL functions have been bridged, 
see the software/opengl_bridge.c file for more info. The corresponding
functions are caught in the SystemC model, and forwarded to 
the host GPU using the SDL2 graphics library
************
