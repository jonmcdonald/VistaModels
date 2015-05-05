
set current_core "Top.cpu_inst.PV.core"

add_default_symbol_file

trace_function_activity * -kind eff
trace_function_calls -kind eff

#start_profiling profiling
#enable_profiling -all
trace_attribute Top.cpu_inst.PV.core.core_state -kind eff

trace_socket Top.cpu_inst.icode -kind eff
trace_socket Top.cpu_inst.dcode -kind eff
trace_socket Top.cpu_inst.system -kind eff
trace_socket Top.cpu_inst.irq_1 -kind eff

trace_register Top.aes_inst.PV.Source -kind eff
trace_register Top.aes_inst.PV.Destination -kind eff
trace_register Top.aes_inst.PV.Size -kind eff
trace_register Top.aes_inst.PV.status -kind eff
trace_register Top.aes_inst.PV.clrIRQ -kind eff

enable_coverage -design AEShw.dgn -test AEShw.tst
