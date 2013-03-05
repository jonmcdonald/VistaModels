
Check the cross compiler is in the PATH. For example:

$ arm-none-eabi-gcc --version
arm-none-eabi-gcc (Sourcery CodeBench Lite 2012.03-56) 4.6.3

Use make to build an image, the options are:

$ make or make RTOS=BareMetal  =>  BareMetal.axf (main.c.BareMetal)
$ make RTOS=FreeRTOS           =>  FreeRTOS.axf  (main.c.FreeRTOS - FreeRTOS 7.1.1)
$ make RTOS=CoOS               =>  CoOS.axf      (main.c.CoOS     - CoOS 1.1.4)
$ make RTOS=FunkOS             =>  FunkOS.axf    (main.c.FunkOS   - FunkOS R3)

By default all images contain debug information.

A symbolic link called "image.axf" points at the last image that has been built.

The same link script and startup code is used for all of the examples, examine
"startup.c" and "standalone.ld" for more information.

