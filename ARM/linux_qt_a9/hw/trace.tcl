
set current_core "stock.cpu.PV.cpu0.core"
trace_linux ../sw/boot/vmlinux -libc ../sw/sdcard/sysroot/lib/libc-2.18.so

#init_gles2_bridge ../sw/sdcard/sysroot/usr/local/lib/libEGL.so ../sw/sdcard/sysroot/usr/local/lib/libGLESv2.so

trace_linux_process es2gears {
    add_symbol_file ../sw/gears/es2gears
    trace_function_calls -kind eff
}

