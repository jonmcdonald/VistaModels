
set current_core "stock.cpu.PV.cpu0.core"
trace_linux ../sw/boot/vmlinux -libc ../sw/ramdisk/sysroot/lib/libc-2.18.so

init_gles2_bridge ../sw/ramdisk/sysroot/usr/local/lib/libEGL.so ../sw/ramdisk/sysroot/usr/local/lib/libGLESv2.so

