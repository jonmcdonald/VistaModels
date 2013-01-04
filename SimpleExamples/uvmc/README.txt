
This is an example of connecting a Vista project to a verilog IP using UVMC.

I used Questa 10.0d but had to obtain and build later versions of UVM (1.1c) and UVMC (2.2).

The Makefile is configured to build and run using pure Questa compiler and simulator, you
will need to alter the paths to the tools and compiled UVMC library.

The design contains a driver, bus, & ip block, you can look at the top schematic and model 
code within Vista. 

The system verilog UVMC wrapper and actual ip (it's a simple adder) is in the rtl folder.

The Vista ip block converts the transaction address/data/size to a tlm generic payload and
sends this out to the system verilog ip_wrapper. 

The adder_wrapper.sv implements a simple register read/write protocol in the transaction handler:
0x0 dataa
0x4 datab
0x8 result

The adder_wrapper.sv also implements the clock to drive the ip. The ip_if.sv defines an interface
to the ip, in this case it is very simple, just a clock, dataa, datab, and the result.


I wonder if there is a way to use the UVM register package in conjunction with UVMC ?

