
set current_core "stock.cpu.PV.cpu0.core"
trace_linux ../sw/boot/vmlinux -libc ../sw/sdcard/sysroot/lib/libc-2.18.so

#init_gles2_bridge ../sw/sdcard/sysroot/usr/local/lib/libEGL.so ../sw/sdcard/sysroot/usr/local/lib/libGLESv2.so

#trace_linux_process es2gears {
#    add_symbol_file ../sw/gears/es2gears
#    trace_function_calls -kind eff
#}

#trace_linux_process { instrumentcluster3d_demo libc-2.18.so } {
#    add_symbol_file ../sw/sdcard/sysroot/root/instrumentcluster3d_demo
#    trace_function_calls -disabled -kind eff -tag MY_TRACE
#    insert_tracepoint tp1 -at-function-entry LcCSpace::paintCanvas -do-tcl {
#        enable_tag MY_TRACE
#    }
#    insert_tracepoint tp2 -at-function-exit LcCSpace::paintCanvas -do-tcl {
#        disable_tag MY_TRACE
#    }
#    add_raw_context {
#        int my_counter;
#    }
#    insert_tracepoint tp1_raw -at-function-entry LcCSpace::paintCanvas -do-raw {
#        my_counter++;
#        printf("LcCSpace::paintCanvas - called %d times\n", my_counter);
#    }
#}

