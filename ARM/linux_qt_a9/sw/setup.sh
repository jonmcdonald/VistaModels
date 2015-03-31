
export TOOL_CHAIN=$(dirname $(dirname `which arm-none-eabi-gcc`))

# version of target software
# kernel and base commands and ssh
export VER_LINUX=3.19        # kernel version
export VER_BUSYBOX=1.22.1    # base commands
export VER_DROPBEAR=2015.67  # secure shell support
export VER_ZLIB=1.2.8        # zlib for sftp
export VER_OPENSSL=1.0.1g    # open ssl
export VER_OPENSSH=6.6p1     # sftp support

# QT
export VER_QT_MAJOR=5.4      # qt 5.4.0
export VER_QT_MINOR=0
export VER_QT=$VER_QT_MAJOR.$VER_QT_MINOR

# opengl
#export VER_AUTOCONF=2.69     
#export VER_AUTOMAKE=1.14.1
#export VER_PKGCONFIG=0.28
#export VER_LIBTOOL=2.4.2
#export VER_MESA3D=10.1.6     # opengl
#export VER_DRM=2.4.52        # DRM
#export VER_EXPAT=2.1.0	     # expat XML parser
#export VER_PNG=1.4.13        # gfx png support
#export VER_FREETYPE=2.5.3    # gfx font support
#export VER_SDL=1.2.15        # SDL

