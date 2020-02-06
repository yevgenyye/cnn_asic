 module Saved_lines    #(
    parameter LINES  = 16, // line size of input frame
    parameter N      = 4,  // input data width
    parameter M      = 4,  // input weight width
    parameter USE_MEM= 0   // 1/0  
) (
    input wire            clk      ,
    input wire  [  N-1:0] d_in     ,
    input wire            en_in    ,

    input wire  [  M-1:0] w_in     ,
    input  wire           w_conf   , // w_in configuration enable ( 9 clocks)
    output reg  [  M-1:0] w_out    ,

    output wire [9*N-1:0] d_grp    ,
    output wire [9*M-1:0] w_grp     
);

 

//FIFOs
reg [7:0]  buf1, buf2 [LINES -2 : 0];
reg [      N -1 : 0]  d_1_1, d_1_2, d_1_3;
reg [      N -1 : 0]  d_2_1, d_2_2, d_2_3;
reg [      N -1 : 0]  d_3_1, d_3_2, d_3_3;
reg [      M -1 : 0]  w_1_1, w_1_2, w_1_3;
reg [      M -1 : 0]  w_2_1, w_2_2, w_2_3;
reg [      M -1 : 0]  w_3_1, w_3_2, w_3_3;


// FIFO organisation
always @(posedge clk)
   if (en_in) begin
      d_1_1      <= d_in     ;
      d_1_2      <= d_1_1    ;
      d_1_3      <= d_1_2    ;
      if (USE_MEM == 1)
        begin
        buf1[LINES -2] <= d_1_3;
        d_2_1          <= buf1[0]  ;
        end
      else
        d_2_1         <= d_1_3;
      d_2_2      <= d_2_1    ;
      d_2_3      <= d_2_2    ;
      if (USE_MEM == 1)
        begin
        buf2[LINES -2] <= d_2_3;
        d_3_1          <= buf2[0]  ;
        end
      else
        d_3_1          <= d_2_3;
      d_3_2      <= d_3_1    ;
      d_3_3      <= d_3_2    ;
   end 

always @(posedge clk)
   if (w_conf) begin
      w_1_1      <= w_in     ;
      w_1_2      <= w_1_1    ;
      w_1_3      <= w_1_2    ;
      w_2_1      <= w_1_3    ;
      w_2_2      <= w_2_1    ;
      w_2_3      <= w_2_2    ;
      w_3_1      <= w_2_3    ;
      w_3_2      <= w_3_1    ;
      w_3_3      <= w_3_2    ;
      w_out      <= w_3_3    ;
   end 

assign d_grp = {d_1_1, d_1_2, d_1_3, d_2_1, d_2_2, d_2_3, d_3_1, d_3_2, d_3_3 };
assign w_grp = {w_1_1, w_1_2, w_1_3, w_2_1, w_2_2, w_2_3, w_3_1, w_3_2, w_3_3 };


endmodule  
