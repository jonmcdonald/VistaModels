
# vista_sw_tool -c "coverage::create_design software/gears.axf -output tracing/data/gears.dgn"

set current_core "top.cpu.PV.core"

add_default_symbol_file

enable_coverage -design tracing/data/gears.dgn -test tracing/data/coverage.tst


insert_tracepoint tp1_entry -at-function-entry swapBuffers -do-raw {
  // Stop simulation after 3 seconds
  if(get_time_stamp() > 3000000000) {
     // Write to SYS_HALT register within the CUSTOM_CTL hardware to stop the platform
     str32((uint32_t) 0xE0000000, 1);
  }
}

