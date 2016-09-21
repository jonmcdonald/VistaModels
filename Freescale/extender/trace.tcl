set trace_script  trace.tcl

select_cluster "top.iMX6_inst.CORTEX_A9MP.PV"
 
add_default_symbol_file
    
trace_function_activity i2c_imx_* -kind eff 

#trace_function_calls -kind eff
#trace_current_function -kind eff      
#trace_attribute top.iMX6_inst.CORTEX_A9MP.PV.cpu0.core.core_state -kind eff
#trace_attribute top.iMX6_inst.CORTEX_A9MP.PV.cpu1.core.core_state -kind eff

trace_socket "top.i2c_0x04.*" -tree -kind eff
trace_socket "top.iMX6_inst.I2C1.irq" -tree -kind eff

trace_socket "top.led_switch.*" -tree -kind eff

#trace_register "top.iMX6_inst.I2C1.*" -tree -kind eff


trace_linux /mnt/store/data/customers/barco/sw/packages/linux-mel-3.10.45/vmlinux -libc /mnt/store/data/customers/barco/sw/sdcard/sysroot/lib/libc-2.20.so
 
trace_linux_process i2ctest {
  add_symbol_file "/mnt/store/data/customers/barco/sw/commtests/i2ctest"

  insert_tracepoint tp1 -at-function-entry sendCommand -do-raw {
  	printf("--- NON INTRUSIVE debug sendCommand\n");
  }
  
# insert_tracepoint tp2 -at-function-exit receiveData -do-raw {
#   	printf("--- NON INTRUSIVE injection receiveData exit\n");
#   	str32(R1, 0x21444142); // Inject "BAD!" into the data.
# }

  trace_function_calls -kind csv 
  trace_current_function -kind csv 
  trace_function_activity * -kind csv
}

trace_linux_process gpiotest {
  add_symbol_file "/mnt/store/data/customers/barco/sw/commtests/gpiotest"
  trace_function_calls -kind csv 
  trace_current_function -kind csv 
  trace_function_activity * -kind csv
}
