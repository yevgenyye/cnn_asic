//`include "full_adder.v"
 
module Huffman_grp_detect
  #(
   parameter NUM_OF_CHARS = 4 ,
   parameter D_W          = 4 , // data width
   parameter C_W          = 4   // code width
  )
  (
   input  wire        clk     ,
   input  wire        rst     ,

   input  wire [D_W-1:0]  d_conf  , // configuration stage. encoded data 
   input  wire [D_W-1:0]  h_conf  , // configuration stage. huffman code data 
   input  wire [D_W-1:0]  w_conf  , // configuration stage. huffman code  width
   input  wire            en_conf , // configuration enable
   input  wire            new_conf, // new configuration and reset old values

   input  wire [C_W-1:0]  d2check,
   output wire             code_matched,
   output wire  [D_W-1:0]  data_encoded
   );

// encoder
reg  [NUM_OF_CHARS*D_W - 1 : 0] Huff_table;
reg  [NUM_OF_CHARS   - 1 : 0]   Huff_active; // active addresses
wire                            WR_table;

///////////////////////////////
////////////// encoding
//////////////////////////////

assign WR_table = ( {1'b0,w_conf} == C_W && en_conf) ? 1'b1 : 1'b0;

always @(posedge clk) // or rst)
  if (rst) begin
     Huff_active   <= 0;
  end else begin
    if (new_conf)
       Huff_active   <= 0;
    else
       if ( WR_table)
         begin
          Huff_active[h_conf] <= 1'b1;
        //Huff_table[D_W*h_conf +: D_W] <= d_conf ;
         end
  end //rst
 
 always @(posedge clk) // or rst)
    if ( WR_table)
       Huff_table[D_W*h_conf +: D_W] <= d_conf ;


 assign code_matched = (Huff_active[d2check]) ? 1'b1 : 1'b0;
 assign data_encoded = Huff_table[D_W * {1'b0 , d2check} +: D_W];

endmodule 
