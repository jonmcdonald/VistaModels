wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.6.1.tar.xz
wget https://buildroot.org/downloads/buildroot-2016.05.tar.gz

Extract buildroot
cd buildroot_patches
  tar cf - . | (cd ../buildroot-2016.05; tar xf -)

cd ../buildroot-2016.05
  make vista_defconfig
  make -j10

Now you have root filesystem and cross-compiler, all in output dir

Then cd ..
./script/build_kernel.sh

source 
  setup.sh
  script/setup_kernel.sh

cd boot-wrapper
  build.sh

parameters.txt references axf and img from sd build
