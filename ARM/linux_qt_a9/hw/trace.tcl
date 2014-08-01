
set current_core "stock.cpu.PV.cpu0.core"
trace_linux /mnt/store/data/VistaModels/ARM/linux_qt_a9/sw/packages/linux-3.14.4/vmlinux -libc /mnt/store/data/VistaModels/ARM/linux_qt_a9/sw/ramdisk/sysroot/lib/libc-2.18.so

init_gles2_bridge /mnt/store/data/VistaModels/ARM/linux_qt_a9/sw/ramdisk/sysroot/usr/local/lib/libEGL.so /mnt/store/data/VistaModels/ARM/linux_qt_a9/sw/ramdisk/sysroot/usr/local/lib/libGLESv2.so

