set current_core "top.cpu.PV.cpu0.core"
add_default_symbol_file

trace_function_calls -kind eff
trace_attribute top.cpu.PV.cpu0.core.core_state -kind eff
trace_current_function -kind eff
trace_function_activity * -kind eff

trace_socket top.cpu.master1 -kind eff
trace_socket top.cpu.master0 -kind eff
trace_socket top.sram.slave -kind eff 

enable_coverage -design tracing/data/gears.dgn -test tracing/data/gears.tst

start_profiling -cache L1/D cache_prof

insert_tracepoint tp1 -at-function-entry ui_loop -do-raw {
  tcl_eval("enable_profiling -all");
  set_parameter("lt_cache_modeling", "DYNAMIC");
}

insert_tracepoint tp2 -at-function-exit ui_loop -do-raw {
  set_parameter("lt_cache_modeling", "STATIC");
}

add_raw_context {
  void* outputFile = 0;
}

insert_tracepoint tp1_entry -at-function-entry swapBuffers -do-raw {
  // Stop simulation after 3 seconds
  if(get_time_stamp() > 3000000000) {
     exit(0);
  }

  if(! outputFile) {
     outputFile = (void*) fopen("tracing/data/function_rate_sw.csv", "w");
  }
  fprintf(outputFile, "%llu;function_rate;;name=swapBuffers_SW\n", get_time_stamp());
  fflush(outputFile);
}

