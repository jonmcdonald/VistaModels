
trace_attribute top.cpu.PV.cpu0.core.core_state
#trace_attribute top.cpu.PV.cpu1.core.core_state

trace_socket   top.sm.slave
trace_socket   top.sm.irq

trace_register top.sm.PV.ADR
trace_register top.sm.PV.CTL

select_core "top.cpu.PV.cpu0.core"
add_default_symbol_file

insert_tracepoint mainEntry -at-function-entry main -do-raw {
  printf("Entered main function at %d MS.\n", get_time_stamp()/1000000);
}

insert_tracepoint mainExit -at-function-exit main -do-raw {
  printf("Exiting main function at %d MS.\n", get_time_stamp()/1000000);
  //request_shutdown();
  request_sim_stop();
}

#select_core "top.cpu.PV.cpu1.core"
#add_default_symbol_file

#insert_tracepoint mainEntry -at-function-entry wfiLoop -do-raw {
#  printf("Stopping core 1 at %d MS.\n", get_time_stamp()/1000000);
#  request_shutdown();
#}
