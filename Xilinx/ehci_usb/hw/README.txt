Please build the software in the sw folder before doing this...


You can try to attach USB devices to your host, once they are attached type:

lsusb

Then note the ID numbers to add to the parameters.txt file, for example:

> lsusb
Bus 001 Device 003: ID 0204:6025 Chipsbank Microelectronics Co., Ltd CBM2080 / CBM2090 Flash drive controller
Bus 001 Device 005: ID 090c:1000 Silicon Motion, Inc. - Taiwan (formerly Feiya Technology Corp.) Flash Drive

> gedit parameters.txt
...
top.Zynq_SoC_inst.USB0.PV.devices = 0204:6025
top.Zynq_SoC_inst.USB1.PV.devices = 090c:1000
...


Just use the Makefile to build and run:

make clean
make mb
make
make run


Once booted, you can mount the USB devices, for example:

> mkdir /usb0
> mkdir /usb1
> mount /dev/sda1 /usb0
> mount /dev/sdb1 /usb1

Then try copying a file from one device to the other, most likely it will fail!

> echo "hello world" > /usb0/hello.txt
> cp /usb0/hello.txt /usb1

[Kernel crash, or loads of error messages and hangs]

