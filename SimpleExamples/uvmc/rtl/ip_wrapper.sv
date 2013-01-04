`include "uvm_macros.svh"

import uvm_pkg::*; 
import uvmc_pkg::*;

class ip_wrapper_uvmc extends uvm_component;
   `uvm_component_utils(ip_wrapper_uvmc)

   uvm_tlm_b_target_socket #(ip_wrapper_uvmc) slave;

   virtual ip_if.user m_ip_if;

   function new(string name, uvm_component parent = null);
      super.new(name, parent);
      slave = new("slave",  this);
   endfunction

   virtual task b_transport(uvm_tlm_gp t, uvm_tlm_time delay);
     byte unsigned p[] = new[1];
     bit [63:0] addr = t.get_address();

     if(t.is_write()) begin
       t.get_data(p);
       unique case(addr) 
         'h0: m_ip_if.dataa = p[0]; 
         'h4: m_ip_if.datab = p[0]; 
       endcase
     end else begin
       unique case(addr) 
         'h8: p[0] = m_ip_if.result; 
       endcase
       t.set_data(p);
     end

     #(delay.get_realtime(1ns,1e-9));
   endtask

endclass

module ip_wrapper;
  reg clock = 0;
  ip_if m_ip_if(.clk(clock));
  ip m_ip(.ip_if(m_ip_if));
  ip_wrapper_uvmc m_ip_wrapper_uvmc = new("ip_wrapper_uvmc");

  initial begin
    uvmc_tlm #()::connect(m_ip_wrapper_uvmc.slave, "sv_in");
    m_ip_wrapper_uvmc.m_ip_if = m_ip_if;
    run_test();
  end

  always begin
    #2500 clock = 1;
    #2500 clock = 0;
  end
endmodule

