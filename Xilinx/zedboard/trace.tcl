set current_core "top.Zynq_SoC_inst.cpu_inst0.CPU_INST0.PV.cpu0.core"

add_default_symbol_file
#add_symbol_file nuc_secure/output/csgnu_arm/zedboard/Debug_s.zedboard/bin/secure_demo.out

trace_function_activity * -kind eff
trace_function_calls -kind eff

#start_profiling profiling
#enable_profiling -all
trace_attribute top.Zynq_SoC_inst.cpu_inst0.CPU_INST0.PV.cpu0.core.core_state -kind eff


set current_core "top.Zynq_SoC_inst.cpu_inst0.CPU_INST0.PV.cpu1.core"
add_symbol_file nuc_secure/output/csgnu_arm/zedboard/Debug_ns.zedboard/bin/non_secure_demo.out
trace_function_activity * -kind eff
trace_function_calls -kind eff
trace_attribute top.Zynq_SoC_inst.cpu_inst0.CPU_INST0.PV.cpu1.core.core_state -kind eff
