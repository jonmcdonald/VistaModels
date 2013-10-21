
set current_core "top.cpu.PV.core"

add_default_symbol_file

#trace_function_calls tracing/data/trace_functions.csv

# trace_call_counter not working in Vista 3.7.0
# trace_call_counter tracing/data/trace_call_counter.csv 

add_raw_context {
  void* outputFile = 0;
  uint64_t lastTimeStamp = 0;
  unsigned int fps = 0;
}

#insert_tracepoint tp_sb_exit -at-function-exit swapBuffers -do-raw {
#  if(! outputFile) {
#     outputFile = (void*) fopen("tracing/data/graphics.csv", "w");
#  }
#
#  if(get_time_stamp() >= (lastTimeStamp + (uint64_t) 2000000000)) {
#    fprintf(outputFile, "%llu;graphics;;fps=%d\n", (lastTimeStamp + (uint64_t) 1000000000), 0);
#    fflush(outputFile);
#  }
#
#  fps++;
#
#  if(get_time_stamp() >= (lastTimeStamp + (uint64_t) 1000000000)) {
#    fprintf(outputFile, "%llu;graphics;;fps=%d\n", get_time_stamp(), fps);
#    fflush(outputFile);
#    lastTimeStamp = get_time_stamp();
#    fps = 0;
#  }
#}

# It's possible to use the irq frequency agent to show the fps, if we fool the 
# agent by generating irq tracing events like this:
insert_tracepoint tp1_entry -at-function-entry swapBuffers -do-raw {
  if(! outputFile) {
     outputFile = (void*) fopen("tracing/data/fake_irq_gpu.csv", "w");
  }
  fprintf(outputFile, "%llu;kernel.irq_entry;cpu=0;irq_id=999\n", get_time_stamp());
  fflush(outputFile);
 }

 insert_tracepoint tp1_exit -at-function-exit swapBuffers -do-raw {
  fprintf(outputFile, "%llu;kernel.irq_exit;cpu=0;irq_id=999\n", get_time_stamp());
  fflush(outputFile);
 }

