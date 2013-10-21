
set current_core "top.cpu.PV.core"

add_default_symbol_file

trace_function_calls tracing/data/functions.csv
#trace_call_counter tracing/data/counters.csv

add_raw_context {
  void* outputFile = 0;
}

# It's possible to use the irq frequency agent to show the fps, if we fool the 
# agent by generating irq tracing events like this:
insert_tracepoint tp1_entry -at-function-entry swapBuffers -do-raw {
  if(! outputFile) {
     outputFile = (void*) fopen("tracing/data/fps.csv", "w");
  }
  fprintf(outputFile, "%llu;kernel.irq_entry;cpu=0;irq_id=0\n", get_time_stamp());
  fflush(outputFile);
 }

 insert_tracepoint tp1_exit -at-function-exit swapBuffers -do-raw {
  fprintf(outputFile, "%llu;kernel.irq_exit;cpu=0;irq_id=0\n", get_time_stamp());
  fflush(outputFile);
 }

