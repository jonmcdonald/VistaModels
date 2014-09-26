README files for each subdirectory's setup can be found under:

  pyex/README.txt
  module-peripheral/README.txt
  vp/Software/boot-wrapper/README.txt
  vp/README.txt

Quick start:

./zynq must be a link to the Vista supplied zynq platform.
This design requires Vista3.9 and SystemC 2.3
> cd VistaModels/Xilinx
> ln -s <path-to-Vista-Zynq>/zynq .
The ./zynq/zynq Project must be compiled and ready to run.

To run the virtual platform with the prebuilt linux-system.axf:
> cd pyex
> make mb
> make
> cd ../vp
> make
> make run

To modify the contents of the linux filesystem:
> cd vp/Software/boot-wrapper
> make mount
> # The filesystem is mounted as ./mnt.  Modify as appropriate
> make umount
> # Run the VP, changes should be present.

To modify the driver and recreate the linux-system.axf:
> export LINUX=<path-to-linux-build-area>  # linux build area not supplied
> export ARCH=arm
> export CROSS_COMPILE=arm-none-eabi-	# assumes arm-none-eabi-gcc is in your path
> cd module-peripheral
> # Modify peripheral_driver.c as appropriate
> make
> make update
