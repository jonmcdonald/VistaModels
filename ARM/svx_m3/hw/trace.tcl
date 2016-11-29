select_core top.m3.PV.core

add_default_symbol_file

trace_function_calls -kind eff
trace_current_function -kind eff
trace_function_activity * -kind eff

insert_tracepoint tp1 -at-function-entry main -do-raw {
  printf("NIT: entry main\n");
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~

trace_attribute top.m3.PV.core.core_state

trace_register top.adc.PV.DATA
trace_socket top.adc.irq



