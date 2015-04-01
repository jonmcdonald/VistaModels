
//************************************************************
//                                                            
//      Copyright Mentor Graphics Corporation 2006 - 2012     
//                  All Rights Reserved                       
//                                                            
//       THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY      
//         INFORMATION WHICH IS THE PROPERTY OF MENTOR        
//         GRAPHICS CORPORATION OR ITS LICENSORS AND IS       
//                 SUBJECT TO LICENSE TERMS.                  
//                                                            
//************************************************************

`timescale 1 ps / 1 ps

(* bus_master *)
(* bus_slave *)
module generic_hscan #(parameter WIDTH = 32)
  (
    (* clock  *)                                          input CLK,
    (* master *)                                          input CS,
    (* master *)                                          input CMD,
    (* master *) (* default_value = 0 *)                  input [7 : 0] PRIORITY,
    (* master *) (* default_value = 1 *)                  input [7 : 0] BURST,
    (* master *) (* default_value = 2 *) (* block_size *) input [7 : 0] SIZE,
    (* master *) (* address *)                            input [WIDTH-1 : 0] ADDR,
    (* master *)                                          input [WIDTH-1 : 0] wDATA,
    (* slave *)                                           input [WIDTH-1 : 0] rDATA,
    (* slave *)  (* default_value = 1 *)                  input STATUS
  );

  int BurstCount = 0;

  (* master *)
  function void G_WRITE (int ADDR, int PRIORITY, int BURST, int SIZE);
`ifdef DEBUG
    $display ("%0t/O, %m :- G_WRITE(ADDR=%0h, PRIORITY=%0d, BURST=%0d, SIZE=%0d)", $time, ADDR, PRIORITY, BURST, SIZE);
`endif
  endfunction

  (* master *)
  function void G_WRITE_DATA (int wDATA);
`ifdef DEBUG
    $display ("%0t/O, %m :- G_WRITE_DATA(wDATA=%0h)", $time, wDATA);
`endif
  endfunction

  (* slave *)
  function void g_write_resp (int STATUS, int BurstCount);
`ifdef DEBUG
    $display ("%0t/I, %m :- g_write_resp(STATUS=%0b, BurstCount=%0d)", $time, STATUS, BurstCount);
`endif
  endfunction

  (* master *)
  function void G_READ (int ADDR, int PRIORITY, int BURST, int SIZE);
`ifdef DEBUG
    $display ("%0t/O, %m :- G_READ(ADDR=%0h, PRIORITY=%0d, BURST=%0d, SIZE=%0d)", $time, ADDR, PRIORITY, BURST, SIZE);
`endif
  endfunction

  (* master *)
  function void G_READ_DATA ();
`ifdef DEBUG
    $display ("%0t/O, %m :- G_READ_DATA()", $time);
`endif
  endfunction

  (* slave *)
  function void g_read_resp (int rDATA, int STATUS, int BurstCount);
`ifdef DEBUG
    $display ("%0t/I, %m :- g_read_resp(rDATA=%0h, STATUS=%0b, BurstCount=%0d)", $time, rDATA, STATUS, BurstCount);
`endif
  endfunction

  (* master *)
  function void END_TRANSACTION ();
`ifdef DEBUG
    $display ("%0t/O, %m :- END_TRANSACTION()", $time);
`endif
  endfunction

  (* transaction *) (* default_read *)
  function void READ  (int ADDR,  input int rDATA[], output int PRIORITY, output int BURST, output int SIZE, input int STATUS);
  endfunction

  (* transaction *) (* default_write *)
  function void WRITE (int ADDR, output int wDATA[], output int PRIORITY, output int BURST, output int SIZE, input int STATUS);
  endfunction

  typedef enum { IDLE, R_DATA, R_RESP, W_DATA, W_RESP } PROTOCOL_STATES;

  PROTOCOL_STATES protocolState;

  (* protocol_initial *)
  initial protocolState = IDLE;

  (* protocol_SM *)
  always
  begin

    case (protocolState)

      IDLE :
      begin
        if ( (CS === 1'b1) && (CMD === 1'b1) ) // WRITE
        begin
          protocolState = W_DATA;
          (* WRITE *)
          G_WRITE (ADDR, PRIORITY, BURST, 1 << SIZE);
          BurstCount = BURST;
        end
        else if ( (CS === 1'b1) && (CMD === 1'b0) ) // READ
        begin
          protocolState = R_DATA;
          (* READ *)
          G_READ (ADDR, PRIORITY, BURST, 1 << SIZE);
          BurstCount = BURST;
        end
        else
        begin
          protocolState = IDLE;
          @ (negedge CLK);
        end
      end

      W_DATA :
      begin
        if (BurstCount == 0)
        begin
          protocolState = IDLE;
          END_TRANSACTION ();
          @ (negedge CLK);
        end
        else if (STATUS)
        begin
          protocolState = W_RESP;
          G_WRITE_DATA (wDATA);
          BurstCount = BurstCount - 1;
        end
        else
        begin
          protocolState = W_DATA;
          @ (negedge CLK);
        end
      end

      W_RESP :
      begin
        protocolState = W_DATA;
        g_write_resp (STATUS, BurstCount);
        @ (negedge CLK);
      end

      R_DATA :
      begin
        if (BurstCount == 0)
        begin
          protocolState = IDLE;
          END_TRANSACTION ();
          @ (negedge CLK);
        end
        else if (STATUS)
        begin
          protocolState = R_RESP;
          G_READ_DATA ();
          BurstCount = BurstCount - 1;
        end
        else
        begin
          protocolState = R_DATA;
          @ (negedge CLK);
        end
      end

      R_RESP :
      begin
        protocolState = R_DATA;
        g_read_resp (rDATA, STATUS, BurstCount);
        @ (negedge CLK);
      end

    endcase

  end

endmodule

