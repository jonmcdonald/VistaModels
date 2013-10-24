
set current_core "top.cpu.PV.core"

add_default_symbol_file

trace_function_calls tracing/data/functions_gpu.csv

add_raw_context {
  void* outputFile = 0;
}

insert_tracepoint tp1_entry -at-function-entry swapBuffers -do-raw {
  if(! outputFile) {
     outputFile = (void*) fopen("tracing/data/function_rate_gpu.csv", "w");
  }
  fprintf(outputFile, "%llu;function_rate;;name=swapBuffers_GPU\n", get_time_stamp());
  fflush(outputFile);
 }

