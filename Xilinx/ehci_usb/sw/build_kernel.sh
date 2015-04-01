export TOOL_CHAIN=$(dirname $(dirname `which arm-none-eabi-gcc`))
export TARGET=arm-none-eabi
export CROSS_COMPILE=$TOOL_CHAIN/bin/$TARGET-
export ARCH=arm

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"/sw

cd $SW_ROOT

if [ ! -d linux-xlnx ]; then
  git clone git://github.com/Xilinx/linux-xlnx.git
  cd $SW_ROOT/linux-xlnx
  git reset --hard f9d391370402f7428cd12e7aaa5c8ab768ba5332
  patch -p1 < ../ehci.patch 
  cp $SW_ROOT/config .config
fi

cd $SW_ROOT/linux-xlnx
make -j 15

cd $SW_ROOT/boot-wrapper
./build.sh $SW_ROOT/linux-xlnx

cd $SW_ROOT

