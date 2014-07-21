set current_core "top.cpu.PV.core"
add_default_symbol_file

trace_function_calls -kind eff
trace_attribute top.cpu.PV.core.core_state -kind eff
trace_current_function -kind eff
trace_function_activity * -kind eff

trace_socket top.cpu.icode -kind eff
trace_socket top.cpu.dcode -kind eff
trace_socket top.cpu.system -kind eff
trace_socket top.flash.slave -kind eff 
trace_socket top.led.ahb_slave -kind eff 

trace_register top.led.PV.RED_EN  -kind eff
trace_register top.led.PV.GREEN_EN  -kind eff
trace_register top.led.PV.BLUE_EN  -kind eff

# enable_coverage -design tracing/data/image.dgn -test tracing/data/image.tst

