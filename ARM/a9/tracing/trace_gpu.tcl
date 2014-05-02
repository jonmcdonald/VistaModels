
set current_core "top.cpu.PV.cpu0.core"
add_default_symbol_file

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

