export TOOL_CHAIN=$(dirname $(dirname `which arm-none-eabi-gcc`))
export TARGET=arm-none-linux-gnueabi
export CROSS_COMPILE=$TOOL_CHAIN/bin/$TARGET-
export ARCH=arm

make; scp -P2022 testbench root@localhost:/
