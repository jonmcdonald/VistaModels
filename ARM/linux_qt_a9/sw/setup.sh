
export TOOL_CHAIN=$(dirname $(dirname `which arm-none-eabi-gcc`))

export VER_LINUX=3.14-rc7    # kernel version
export VER_BUSYBOX=1.22.1    # base commands
export VER_DROPBEAR=2014.63  # secure shell support

export VER_QT_MAJOR=4.8
export VER_QT_MINOR=5

#export VER_QT_MAJOR=5.2
#export VER_QT_MINOR=1

export VER_QT=$VER_QT_MAJOR.$VER_QT_MINOR   # eg: 5.2.1

