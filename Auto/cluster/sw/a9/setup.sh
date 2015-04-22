
export TOOL_CHAIN=$(dirname $(dirname `which arm-none-eabi-gcc`))

export VER_LINUX=3.18.11     # kernel version
export VER_BUSYBOX=1.23.2    # base commands
export VER_DROPBEAR=2015.67  # secure shell support
export VER_ZLIB=1.2.8        # zlib for sftp
export VER_OPENSSL=1.0.2a    # open ssl
export VER_OPENSSH=6.8p1     # sftp support

# QT
export VER_QT_MAJOR=5.4      # qt 5.4.0
export VER_QT_MINOR=1
export VER_QT=$VER_QT_MAJOR.$VER_QT_MINOR


