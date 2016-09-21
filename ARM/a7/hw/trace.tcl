
trace_attribute top.cpu.PV.cpu0.core.core_state
trace_attribute top.cpu.PV.cpu1.core.core_state

trace_socket   top.sm.slave
trace_socket   top.sm.irq

trace_register top.sm.PV.ADR
trace_register top.sm.PV.CTL

select_cluster A7_X2

trace_linux ../sw/linux-4.6.1/vmlinux

trace_linux_process uio_example {
  add_symbol_file ../sw/uio_example/uio_example
  trace_function_calls -kind eff
  trace_current_function -kind eff
  trace_function_activity * -kind eff

  insert_tracepoint tp1 -at-function-entry main -do-raw {
    printf("NIT: entry main\n");
  }
}

