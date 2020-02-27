 `timescale 1 ns/10 ps 

 module Fifo_ctrl    #(
    parameter DELAY   =   4, // delay value for simulation
    parameter LINSIZE =  16, // line size of input frame
    parameter N       =   4  // input data width
) (
    input  wire         clk   ,
    input  wire         rst   ,
    input  wire         en_in ,
    output reg  [N-1:0] AA    ,
    output reg  [N-1:0] AB    ,
    output reg          WEBA  ,
    output wire         rd_smp // sample read data
);

    reg   [LINSIZE-1:0] in_count;
    reg   in1_flag, out1_flag;
    localparam RD = 3;  // read delay
    reg   [RD-1 :0] read_delay;

always @(posedge clk, rst) // or rst)
 if (rst) begin
   AA        <= {(N){1'b0}};
   AB        <= {(N){1'b0}};
   WEBA      <= 1'b1;
   in_count  <= 1'b0;
   in1_flag  <= 1'b1;
   out1_flag <= 1'b1;
   read_delay <= {(RD){1'b1}};
 end else begin
   if (en_in) 
      begin
      AA   <= #DELAY  AA + 1;
      WEBA <= #DELAY  1'b0;
      if (out1_flag == 1'b1)
         if (in_count == LINSIZE)
            out1_flag <= #DELAY 1'b0;
         else
            in_count <= in_count + 1;
      else
         AB <= #DELAY AB +1;
      read_delay <= { read_delay[RD-2 : 0], out1_flag };
      end
   else
      begin
      WEBA <= #DELAY 1'b1;
      read_delay <= { read_delay[RD-2 : 0], 1'b1 };
      end
   end // if

assign rd_smp = ~read_delay[RD-1];

endmodule  
