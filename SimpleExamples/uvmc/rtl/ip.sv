
module ip(ip_if.ip ip_if);
  always @(posedge ip_if.clk) begin
    ip_if.result <= ip_if.dataa + ip_if.datab;
  end
endmodule

