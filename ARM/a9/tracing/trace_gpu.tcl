
set current_core "top.cpu.PV.core"

add_default_symbol_file

trace_function_calls tracing/data/functions_gpu.csv

add_raw_context {
  void* outputFile = 0;
}

insert_tracepoint tp1_entry -at-function-entry swapBuffers -do-raw {
  // Stop simulation after 3 seconds
  if(get_time_stamp() > 3000000000) {
     // Write to SYS_HALT register within the CUSTOM_CTL hardware to stop the platform
     str32((uint32_t) 0xE0000000, 1);
  }

  if(! outputFile) {
     outputFile = (void*) fopen("tracing/data/function_rate_gpu.csv", "w");
  }
  fprintf(outputFile, "%llu;function_rate;;name=swapBuffers_GPU\n", get_time_stamp());
  fflush(outputFile);
 }

