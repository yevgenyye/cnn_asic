//`include "full_adder.v"
 
module Huffman_enc
  #(
   parameter W = 8, // in/out bus width
   parameter C = 4
  )
  (
   input wire          clk     ,
   input wire          rst     ,
   input wire [W-1:0]  d_in    , // Huffman coded data
   input wire [C-1:0]  w_in    , // Huffman width data
   input wire          en_in   , // 
   output reg [W-1:0]  d_out   , // Encoded data
   output reg          en_out    // 
   );

reg [2*W-1 : 0] data_acc;
reg [ C+1   : 0] pointer;

always @(posedge clk) // or rst)
  if (rst) begin
    pointer   <= 15;
    en_out    <= 0;
  end else begin
    if (en_in)
      begin
        if ( {1'b0 , pointer } >= 8)
          begin
            pointer <= pointer -  w_in;
            case(pointer)
              15    : begin data_acc[15    : 8    ] <= d_in; end
              14    : begin data_acc[15 - 1: 8 - 1] <= d_in; end  
              13    : begin data_acc[15 - 2: 8 - 2] <= d_in; end
              12    : begin data_acc[15 - 3: 8 - 3] <= d_in; end
              11    : begin data_acc[15 - 4: 8 - 4] <= d_in; end
              10    : begin data_acc[15 - 5: 8 - 5] <= d_in; end
               9    : begin data_acc[15 - 6: 8 - 6] <= d_in; end
               8    : begin data_acc[15 - 7: 8 - 7] <= d_in; end
              default  : data_acc <= data_acc;     
            endcase
            en_out    <= 0;
          end
        else //
          begin
            pointer <= pointer -  w_in + 8;
            case(pointer)
               7    : begin                                       data_acc[15     : 8  ] <= d_in; end
               6    : begin data_acc[15     ] <= data_acc[7    ]; data_acc[15 - 1 : 8- 1] <= d_in; end  
               5    : begin data_acc[15 : 14] <= data_acc[7 : 6]; data_acc[15 - 2 : 8- 2] <= d_in; end
               4    : begin data_acc[15 : 13] <= data_acc[7 : 5]; data_acc[15 - 3 : 8- 3] <= d_in; end
               3    : begin data_acc[15 : 12] <= data_acc[7 : 4]; data_acc[15 - 4 : 8- 4] <= d_in; end
               2    : begin data_acc[15 : 11] <= data_acc[7 : 3]; data_acc[15 - 5 : 8- 5] <= d_in; end
               1    : begin data_acc[15 : 10] <= data_acc[7 : 2]; data_acc[15 - 6 : 8- 6] <= d_in; end
               0    : begin data_acc[15 :  9] <= data_acc[7 : 1]; data_acc[15 - 7 : 8- 7] <= d_in; end
              default  : data_acc <= data_acc;     
            endcase
            d_out    <= data_acc[15 : 8];
            en_out   <= 1;
          end
        end // else if pointer 
 //     end // if en_in
      else
        en_out    <= 0;

  end // always

 

endmodule // carry_lookahead_adder
