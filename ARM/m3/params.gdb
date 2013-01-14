
clock = 10 NS
ahb_master_clock = 10 NS
ahb_slave_clock = 10 NS
signal_clock = 10 NS

tlm_timing_model = LT

io_debug_enabled = 1

Top.cpu_inst.PV.core.elf_image_file = CBwork/demo/Debug/demo
Top.cpu_inst.PV.core.gdbstub_port = 1234

Top.bus_inst.s0_base_address = 0xFFFFFFFF
Top.bus_inst.s0_subtract_base_address = 0

Top.bus_inst.s1_base_address = 0x40000000
Top.bus_inst.s1_size         = 0x00000100

Top.mem_inst.PageSize = 0x100000

