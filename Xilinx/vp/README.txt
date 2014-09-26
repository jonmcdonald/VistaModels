This directory contains a top level project with an example Xilinx Zynq design and application.
There are a number of prerequisites for this design:

	Vista Zynq design must be available.  The Project and library files assume ../zynq will
	contain the Vista zynq and zynq_catalogue libraries as well as corresponding v2p files.


To build and execute the platform run:

> make
> make run

The included linux filesystem and axf has the custom peripheral module loaded.
The custom peripheral creates a python gui with 4 LEDs and switches.  A kernel
module (../module-peripheral/peripheral_driver.ko) handles the interrupts from
the custom peripheral when the switches are toggled and sets the LEDs based on
the switch settings.  The kernel module also creates a /proc/peripheral file.
A string of 4 1s and 0s written to this file will set the LEDs accordingly.
At the vp linux command line execute:

zynq> echo 1010 > /proc/peripheral

This will set the LEDs on off on off
