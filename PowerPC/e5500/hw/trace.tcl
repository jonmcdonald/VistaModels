select_cluster e5500

add_default_symbol_file -all

trace_function_calls -kind eff
trace_function_activity * -kind eff
trace_current_function -kind eff

trace_attribute top.cpu.PV.core.core_state -kind eff

trace_socket     top.uart.slave
trace_socket     top.uart.irq
trace_socket     top.uart.transmit
trace_socket     top.uart.receive
trace_register   top.uart.PV.RBR_THR_DLL
trace_register   top.uart.PV.IER_DLM
trace_register   top.uart.PV.MSR

trace_socket     top.fabric.slave
trace_socket     top.fabric.master
trace_socket     top.fabric.irq
trace_register   top.fabric.PV.CTL
trace_register   top.fabric.PV.ADR

trace_socket     top.ic.Internal0
trace_socket     top.ic.Internal1
trace_socket     top.ic.bus_slave
trace_socket     top.ic.int_n
trace_socket     top.ic.cint_n
trace_socket     top.ic.mcp_n
trace_socket     top.ic.IACK_read

enable_coverage -design mybit.dgn -test mybit.tst

insert_tracepoint tp1 -at-function-entry main -do-raw {
  printf("NIT: ENTRY main()\n");
}

insert_tracepoint tp2 -at-function-exit main -do-raw {
  printf("NIT: EXIT main()\n");
  request_sim_stop();
}

