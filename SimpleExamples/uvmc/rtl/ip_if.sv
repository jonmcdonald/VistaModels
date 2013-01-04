  interface ip_if (input clk);
    logic [7:0] dataa, datab;
    logic [8:0] result;
    modport ip (input clk, dataa, datab, output result);
    modport user (output clk, dataa, datab, input result);
  endinterface


