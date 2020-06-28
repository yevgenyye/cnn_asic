//`include "full_adder.v"
 
module Huffman_one_detect
  #(
   parameter D_W          = 4 , // data width
   parameter C_W          = 4   // code width
  )
  (
   input  wire        clk     ,
   input  wire        rst     ,

   input  wire [D_W-1:0]  d_conf  , // configuration stage. encoded data 
   input  wire [C_W-1:0]  h_conf  , // configuration stage. huffman code data 
   input  wire            en_conf , // configuration enable
   input  wire            new_conf, // new configuration and reset old values

   input  wire [C_W-1:0]  d2check,
   output reg             code_matched,
   output reg   [D_W-1:0] data_encoded
   );


reg [C_W-1:0]  d_huff;// huffman code
reg            d_flg; // non/active reg

always @(posedge clk) 
  if (rst) begin
     d_flg   <= 1'b0;
  end else begin
    if (new_conf)
       d_flg   <= 1'b0;
    else
       if ( en_conf)
          d_flg  <= 1'b1;
  end //rst

always @(posedge clk)   
  if ( en_conf)
   begin
     data_encoded  <= d_conf;
     d_huff        <= h_conf;
   end
 //  else if  (d_huff == d2check && d_flg)
 //   data_encoded <= 0;

always @(posedge clk)   
  if (d_huff == d2check && d_flg)
     code_matched <= 1'b1;
   else 
     code_matched <= 1'b0;

endmodule 
