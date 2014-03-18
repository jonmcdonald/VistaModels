#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/Mesa-$VER_MESA3D

./configure --target=arm-none-linux-gnueabi --host=arm-none-linux-gnueabi -prefix $SW_ROOT/packages/mesa-install-$VER_MESA3D --disable-dri --disable-glx --with-gallium-drivers="swrast"


  --enable-selinux        Build SELinux-aware Mesa [default=disabled]
  --disable-opengl        disable support for standard OpenGL API [default=no]
  --enable-gles1          enable support for OpenGL ES 1.x API [default=no]
  --enable-gles2          enable support for OpenGL ES 2.x API [default=no]
  --enable-openvg         enable support for OpenVG API [default=no]
  --enable-dri            enable DRI modules [default=enabled]
  --enable-glx            enable GLX library [default=enabled]
  --enable-osmesa         enable OSMesa library [default=disabled]
  --enable-gallium-osmesa enable Gallium implementation of the OSMesa library
                          [default=disabled]
  --disable-egl           disable EGL library [default=enabled]
  --enable-xa             enable build of the XA X Acceleration API
                          [default=no]
  --enable-gbm            enable gbm library [default=auto]
  --enable-xvmc           enable xvmc library [default=auto]
  --enable-vdpau          enable vdpau library [default=auto]
  --enable-opencl         enable OpenCL library NOTE: Enabling this option
                          will also enable --with-llvm-shared-libs
                          [default=no]
  --enable-opencl-icd     Build an OpenCL ICD library to be loaded by an ICD
                          implementation [default=no]
  --enable-xlib-glx       make GLX library Xlib-based instead of DRI-based
                          [default=disabled]
  --enable-gallium-egl    enable optional EGL state tracker (not required for
                          EGL support in Gallium with OpenGL and OpenGL ES)
                          [default=disable]
  --enable-gallium-gbm    enable optional gbm state tracker (not required for
                          gbm support in Gallium) [default=auto]
  --enable-r600-llvm-compiler
                          Enable experimental LLVM backend for graphics
                          shaders [default=disable]
  --enable-gallium-tests  Enable optional Gallium tests) [default=disable]
  --enable-shared-glapi   Enable shared glapi for OpenGL [default=yes]
  --disable-driglx-direct disable direct rendering in GLX and EGL for DRI
                          [default=auto]
  --enable-glx-tls        enable TLS support in GLX [default=disabled]
  --enable-gallium-llvm   build gallium LLVM support [default=enabled on
                          x86/x86_64]

Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
                          both]
  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
  --with-sysroot=DIR Search for dependent libraries within DIR
                        (or the compiler's sysroot if not specified).
  --with-gl-lib-name[=NAME]
                          specify GL library name [default=GL]
  --with-osmesa-lib-name[=NAME]
                          specify OSMesa library name [default=OSMesa]
  --with-gallium-drivers[=DIRS...]
                          comma delimited Gallium drivers list, e.g.
                          "i915,ilo,nouveau,r300,r600,radeonsi,freedreno,svga,swrast"
                          [default=r300,r600,svga,swrast]
  --with-dri-driverdir=DIR
                          directory for the DRI drivers [${libdir}/dri]
  --with-dri-searchpath=DIRS...
                          semicolon delimited DRI driver search directories
                          [${libdir}/dri]
  --with-dri-drivers[=DIRS...]
                          comma delimited DRI drivers list, e.g.
                          "swrast,i965,radeon" [default=auto]
  --with-osmesa-bits=BITS OSMesa channel bits and library name: 8, 16, 32
                          [default=8]
  --with-libclc-path      DEPRECATED: See
                          http://dri.freedesktop.org/wiki/GalliumCompute#How_to_Install
  --with-clang-libdir     Path to Clang libraries [default=llvm-config
                          --libdir]
  --with-egl-platforms[=DIRS...]
                          comma delimited native platforms libEGL supports,
                          e.g. "x11,drm" [default=auto]
  --with-egl-driver-dir=DIR
                          directory for EGL drivers [[default=${libdir}/egl]]
  --with-max-width=N      Maximum framebuffer width (4096)
  --with-max-height=N     Maximum framebuffer height (4096)
  --with-llvm-shared-libs link with LLVM shared libraries [default=disabled]
  --with-llvm-prefix      Prefix for LLVM installations in non-standard
                          locations
  --with-xvmc-libdir=DIR  directory for the XVMC libraries [default=${libdir}]
  --with-vdpau-libdir=DIR directory for the VDPAU libraries
                          [default=${libdir}/vdpau]
  --with-opencl-libdir=DIR

#make -j 15

#make install

