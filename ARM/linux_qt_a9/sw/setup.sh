
export TOOL_CHAIN=$(dirname $(dirname `which arm-none-eabi-gcc`))

export VER_LINUX=3.14-rc7    # kernel version
export VER_BUSYBOX=1.22.1    # base commands
export VER_DROPBEAR=2014.63  # secure shell support

export VER_MESA3D=10.0.4     # opengl
export VER_DIRECTFB=1.7.2    # directFB

export VER_QT_MAJOR=4.8      # qt 4.8.5
export VER_QT_MINOR=5

#export VER_QT_MAJOR=5.2      # qt 5.2.1
#export VER_QT_MINOR=1

export VER_QT=$VER_QT_MAJOR.$VER_QT_MINOR

