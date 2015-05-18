# ~~~~~~~~~~~~~~
# Hardware tracing

trace_socket top.cluster1.clusterdriver0.m4.irq_0 -kind eff -tag TRACE_IRQ -disabled

# ~~~~~~~~~~~~~~
# Software on M4

set current_core "top.cluster1.clusterdriver0.m4.PV.core"
add_default_symbol_file

trace_function_calls -kind eff -tag TRACE_M4 -disabled

# ~~~~~~~~~~~~~~
# Software on A9

set current_core "top.cluster1.clusterdriver0.a9x2.PV.cpu0.core"

trace_linux ../sw/a9/packages/linux-3.18.11/vmlinux -libc ../sw/a9/sdcard/sysroot/lib/libc-2.20.so

trace_function_calls -kind eff -tag TRACE_LINUX -disabled

trace_linux_process { cluster libc-2.20.so } {
    add_symbol_file ../sw/a9/cluster/cluster

    trace_function_calls -kind eff -tag TRACE_QT -disabled

    insert_tracepoint tp1 -at-function-entry main -do-tcl {
        enable_tag TRACE_IRQ
        enable_tag TRACE_M4
        enable_tag TRACE_LINUX
        enable_tag TRACE_QT
    }

    insert_tracepoint tp2 -at-function-exit main -do-tcl {
        disable_tag TRACE_IRQ
        disable_tag TRACE_M4
        disable_tag TRACE_LINUX
        disable_tag TRACE_QT
    }
}

