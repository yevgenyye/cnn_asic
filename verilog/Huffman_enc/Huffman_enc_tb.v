///////////////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
///////////////////////////////////////////////////////////////////////////////
 `timescale 1 ns/10 ps 
//`include "carry_lookahead_adder.v"
 
module Huffman_enc_tb ();
 
  parameter W = 8;
  parameter C = 4;

  reg           clk     ;
  reg           rst     ;
  reg  [W-1:0]  d_in    ; // Huffman coded data
  reg  [C-1:0]  w_in    ;
  reg           en_in   ; // 
 
  wire [W-1:0]  d_out   ; // Encoded data
  wire          en_out  ; // 

  reg         init_end     ;

  integer     i,j;
 


localparam  B2_0   = 2'b00;    //W2_1 = 2;
localparam  B2_1   = 2'b01;    //W2_0 = 2;
localparam  B2_2   = 2'bZZ;    //W2_0 = 2;
localparam  B3_0   = 3'b100;   //W3_1 = 3;
localparam  B3_1   = 3'b101;   //W3_0 = 3;
localparam  B3_3   = 3'b10Z;   //W3_0 = 3;
localparam  B4_0   = 4'b1100;  //W4_1 = 4;
localparam  B4_1   = 4'b1101;  //W4_0 = 4;
localparam  B5_0   = 5'b11100; //W5_1 = 5;
localparam  B5_1   = 5'b11101; //W5_0 = 5;
localparam  B5_Z   = 5'b1110Z; //W5_0 = 5;
localparam  B5_X   = 5'bX110Z; //W5_0 = 5;

localparam  B6_0   = 6'b111100;   //W6_1 = 6; 
localparam  B6_1   = 6'b111101;   //W6_0 = 6; 
localparam  B6_X   = 6'bX1110Z;   //W6_1 = 6; 
localparam  B6_Z   = 6'b11110Z;   //W6_0 = 6; 

localparam  B7_0   = 7'b1111100;  //W7_1 = 7; 
localparam  B7_1   = 7'b1111101;  //W7_0 = 7; 
localparam  B7_X   = 7'bX11110Z;  //W7_1 = 7; 
localparam  B7_Z   = 7'b111110Z;  //W7_0 = 7; 


localparam  B8_0   = 8'b11111100; //W8_1 = 8; 
localparam  B8_1   = 8'b11111101; //W8_0 = 8; 


  Huffman_enc  #(
    .W(W),
    .C(C)
    )
  DUT
  (
   .clk     (clk     ),
   .rst     (rst     ),
   .d_in    (d_in    ), // Huffman coded data
   .w_in    (w_in    ), 
   .en_in   (en_in   ), // 
   .d_out   (d_out   ), // Encoded data
   .en_out  (en_out  )  // 
   );

always 
begin
    clk = 1'b1; 
    #5; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #5; // low for 20 * timescale = 20 ns
end
 

   initial
     begin
           rst      <= 1'b1; 
           en_in    <= 0; 
       #10;
           rst   <= 1'b0; 
 
       #10;
       #10;
       #10;
 ////////////////////////////// operational part
        j= 0;
        #10;
        for (i = 0; i < 200; i = i + 1) 
          begin
            #10;
            j <= j + 1;
            en_in <= 1;
            $display("din(%h)= %h",i, d_in);
          end
         #10;
         en_in <= 0; 
 
         #100;
     end



 always @*
  case (j)
 
     1:  begin    d_in = { B2_0 , {(8-2){1'b0}} } ; w_in = 2; end // 1 byte 4x2
     2:  begin    d_in = { B2_1 , {(8-2){1'b0}} } ; w_in = 2; end //
     3:  begin    d_in = { B2_0 , {(8-2){1'b0}} } ; w_in = 2; end //
     4:  begin    d_in = { B2_1 , {(8-2){1'b0}} } ; w_in = 2; end //
     5:  begin    d_in = { B2_0 , {(8-2){1'b0}} } ; w_in = 2; end // 1 byte 4x2
     6:  begin    d_in = { B2_1 , {(8-2){1'b0}} } ; w_in = 2; end //
     7:  begin    d_in = { B2_0 , {(8-2){1'b0}} } ; w_in = 2; end //
     8:  begin    d_in = { B2_2 , {(8-2){1'b0}} } ; w_in = 2; end // 
     9:  begin    d_in = { B3_0 , {(8-3){1'b0}} } ; w_in = 3; end // 4 bytes 8x3
    10:  begin    d_in = { B3_1 , {(8-3){1'b0}} } ; w_in = 3; end //
    11:  begin    d_in = { B3_0 , {(8-3){1'b0}} } ; w_in = 3; end //
    12:  begin    d_in = { B3_1 , {(8-3){1'b0}} } ; w_in = 3; end //
    13:  begin    d_in = { B3_0 , {(8-3){1'b0}} } ; w_in = 3; end // 
    14:  begin    d_in = { B3_1 , {(8-3){1'b0}} } ; w_in = 3; end //
    15:  begin    d_in = { B3_0 , {(8-3){1'b0}} } ; w_in = 3; end //
    16:  begin    d_in = { B3_3 , {(8-3){1'b0}} } ; w_in = 3; end // 
    17:  begin    d_in = { B4_0 , {(8-4){1'b0}} } ; w_in = 4; end // 1 byte 2x4
    18:  begin    d_in = { B4_1 , {(8-4){1'b0}} } ; w_in = 4; end // 
    19:  begin    d_in = { B2_0 , {(8-2){1'b0}} } ; w_in = 2; end // 1 byte 2+4+2
    20:  begin    d_in = { B4_1 , {(8-4){1'b0}} } ; w_in = 4; end //
    21:  begin    d_in = { B2_2 , {(8-2){1'b0}} } ; w_in = 2; end //
    22:  begin    d_in = { B8_0                 } ; w_in = 8; end // 1 byte 1x8
    23:  begin    d_in = { B8_1                 } ; w_in = 8; end // 1 byte 1x8 
    24:  begin    d_in = { B6_0 , {(8-6){1'b0}} } ; w_in = 6; end // 1 byte 6+2
    25:  begin    d_in = { B2_0 , {(8-2){1'b0}} } ; w_in = 2; end

    26:  begin    d_in = { B5_0 , {(8-5){1'b0}} } ; w_in = 5; end // 5 bytes 5x8
    27:  begin    d_in = { B5_0 , {(8-5){1'b0}} } ; w_in = 5; end // 
    28:  begin    d_in = { B5_0 , {(8-5){1'b0}} } ; w_in = 5; end // 
    29:  begin    d_in = { B5_0 , {(8-5){1'b0}} } ; w_in = 5; end // 
    30:  begin    d_in = { B5_0 , {(8-5){1'b0}} } ; w_in = 5; end //
    31:  begin    d_in = { B5_0 , {(8-5){1'b0}} } ; w_in = 5; end // 
    32:  begin    d_in = { B5_0 , {(8-5){1'b0}} } ; w_in = 5; end // 
    33:  begin    d_in = { B5_Z , {(8-5){1'b0}} } ; w_in = 5; end //


    34:  begin    d_in = { B6_0 , {(8-6){1'b0}} } ; w_in = 6; end // 3 bytes 6x4
    35:  begin    d_in = { B6_0 , {(8-6){1'b0}} } ; w_in = 6; end // 
    36:  begin    d_in = { B6_0 , {(8-6){1'b0}} } ; w_in = 6; end // 
    37:  begin    d_in = { B6_1 , {(8-6){1'b0}} } ; w_in = 6; end //
 
    38:  begin    d_in = { B7_X , {(8-7){1'b0}} } ; w_in = 7; end // 7 bytes 8x7
    39:  begin    d_in = { B7_X , {(8-7){1'b0}} } ; w_in = 7; end // 
    40:  begin    d_in = { B7_X , {(8-7){1'b0}} } ; w_in = 7; end //
    41:  begin    d_in = { B7_X , {(8-7){1'b0}} } ; w_in = 7; end // 
    42:  begin    d_in = { B7_X , {(8-7){1'b0}} } ; w_in = 7; end // 
    43:  begin    d_in = { B7_X , {(8-7){1'b0}} } ; w_in = 7; end //
    44:  begin    d_in = { B7_X , {(8-7){1'b0}} } ; w_in = 7; end // 
    45:  begin    d_in = { B7_Z , {(8-7){1'b0}} } ; w_in = 7; end //
      
  default:  d_in = 8'hFF;  
 endcase

endmodule // carry_lookahead_adder_tb