
Just execute the ./build_kernel.sh script which will:

* Clone the Xilinx Linux
* Reset to the version of Xilinx Linux that boots on the platform
* Install the patch for device tree support for EHCI USB
* Copies in the .config file
* Builds the kernel
* Builds the image file (including fetching a minimal Xilinx filesystem)

