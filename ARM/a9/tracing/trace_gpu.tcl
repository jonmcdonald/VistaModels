
set current_core "top.cpu.PV.core"

add_default_symbol_file

trace_function_calls
trace_function_activity * -kind eff
trace_attribute top.cpu.PV.core.core_state
trace_current_function -kind eff

trace_socket top.gpu.mem_access
trace_socket top.gpu.reg_access

trace_register top.gpu.PV.GPU_ZERO_START
trace_register top.gpu.PV.GPU_ZERO_SIZE
trace_register top.gpu.PV.GPU_TRIANGLE_ZB
trace_register top.gpu.PV.GPU_TRIANGLE_P0
trace_register top.gpu.PV.GPU_TRIANGLE_P1
trace_register top.gpu.PV.GPU_TRIANGLE_P2
trace_register top.gpu.PV.GPU_TRIANGLE_DRAW

add_raw_context {
  void* outputFile = 0;
}

insert_tracepoint tp1_entry -at-function-entry swapBuffers -do-raw {
  // Stop simulation after 3 seconds
  if(get_time_stamp() > 3000000000) {
     exit(0);
  }

  if(! outputFile) {
     outputFile = (void*) fopen("tracing/data/function_rate_gpu.csv", "w");
  }
  fprintf(outputFile, "%llu;function_rate;;name=swapBuffers_GPU\n", get_time_stamp());
  fflush(outputFile);
 }

