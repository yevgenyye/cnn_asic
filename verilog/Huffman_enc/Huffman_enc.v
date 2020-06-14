//`include "full_adder.v"
 
module Huffman_enc
  #(
   parameter W = 8
  )
  (
   input wire          clk     ,
   input wire          rst     ,
   output reg          d_req   , 
   input wire [W-1:0]  d_in    , // Huffman coded data
   input wire          en_in   , // 
   input wire [W-1:0]  d_conf  , // configuration stage. encoded data 
   input wire [W-1:0]  h_conf  , // configuration stage. huffman code data 
   input wire [W-1:0]  w_conf  , // configuration stage. huffman code  width
   input wire          en_conf , // configuration enable
   input wire          new_conf, // new configuration and reset old values
   output reg [W-1:0]  d_out   , // Encoded data
   output              en_out    // 
   );

localparam  W_A = (W == 8) ? 3 : 2;

localparam [2:0] // 3 states are required for Moore
    empty2 = 3'b000,
    ws2    = 3'b001,
    empty1 = 3'b010, 
    ws1    = 3'b011, 
    empty0 = 3'b100;
reg [2:0] state,next_state;

localparam  NUM_OF_2_BIT_CHARS   =   4; // less than 4
localparam  NUM_OF_3_BIT_CHARS   =   8; // less than 8
localparam  NUM_OF_4_BIT_CHARS   =  16; // less than 16
localparam  NUM_OF_5_BIT_CHARS   =  32; // less than 32
localparam  NUM_OF_6_BIT_CHARS   =  64; // less than 64 
localparam  NUM_OF_7_BIT_CHARS   = 128; // less than 128
localparam  NUM_OF_8_BIT_CHARS   = 256; 

// input shift reg
reg [W   -1 : 0]  d_s, d_s2, d_s3  ; // input data sampled data 
reg [W   -1 : 0]  d2check;
reg [W_A +1 : 0]  pointer;
//reg               d_s1_empty, d_s2_empty; 
wire  d_s2_empty;
//reg               shift_sig; 

// encoder
//reg  [NUM_OF_2_BIT_CHARS*W - 1 : 0] Huff_table;
//reg  [NUM_OF_2_BIT_CHARS   - 1 : 0] Huff_active; // active addresses
wire [W : 2]           code_matched; 
wire [(W+1)*W : 2*W]   data_encoded;
///////////////////////////////
///// input shift register
///////////////////////////////

 assign d_s2_empty = (pointer >= W) ? 1'b1 : 1'b0;
//assign d_req = d_s1_empty;
always @(posedge clk) // or rst)
  if (rst) begin
    d_s        <= 0;
    d_s2       <= 0;
    d_s3       <= 0;
  //d_s1_empty <= 1;
  //d_s2_empty <= 1;
    d_req      <= 1;
    d2check    <= 0;
    pointer    <= 2*2**W_A;
    state      <= empty2; 
  end else begin
    case (state)
      empty2 :      if ( en_in                ) begin state <= ws2;    d_req <= 0; d_s2  <= d_in; $display("_1_ %b",state); end
         ws2 :      if ( en_in                ) begin state <= empty0; d_req <= 0; d_s   <= d_in; $display("_2_ %b",state); end 
                  else                          begin state <= empty1; d_req <= 1;                $display("_3_ %b",state); end
      empty1 :      if ( en_in &&  ~d_s2_empty) begin state <= empty0; d_req <= 0; d_s   <= d_in; $display("_4_ %b",state); end 
               else if ( en_in &&   d_s2_empty) begin state <= empty1; d_req <= 1; d_s2  <= d_in; $display("_5_ %b",state); end
               else if (~en_in &&   d_s2_empty) begin state <= empty2; d_req <= 1;                $display("_6_ %b",state); end
         ws1 :                                  begin state <= empty1; d_req <= 0; d_s2  <= d_s; end
      empty0 :      if (            d_s2_empty) begin state <= ws1;    d_req <= 1;                $display("_7_ %b",state); end
    //  default: state <= empty2;  
    endcase

    if (state != empty2)
       if (pointer >= W)  // get new data - 2 clock cycles
          begin
             pointer    <= pointer-W;
            // d_s2_empty <= 1;
             case(pointer)
             //  0    : begin d2check <= {d2check[W-1 - 0 : 0], d_s2[W-1 : W-1 -(0-1)]};  d_s3 <= {d_s2 [W-1 -(2-2) : 0], 2'b00  }; end
             //  1    : begin d2check <= {d2check[W-1 - 1 : 0], d_s2[W-1 : W-1 -(1-1)]};  d_s3 <= {d_s2 [W-1 -(2-2) : 0], 2'b00  }; end
             //  2    : begin d2check <= {d2check[W-1 - 2 : 0], d_s2[W-1 : W-1 -(2-1)]};  d_s3 <= {d_s2 [W-1 -(2-2) : 0], 2'b00  }; end
             //  3    : begin d2check <= {d2check[W-1 - 3 : 0], d_s2[W-1 : W-1 -(3-1)]};  d_s3 <= {d_s2 [W-1 -(2-2) : 0], 2'b00  }; end
             //  4    : begin d2check <= {d2check[W-1 - 4 : 0], d_s2[W-1 : W-1 -(4-1)]};  d_s3 <= {d_s2 [W-1 -(3-2) : 0], 3'b000 }; end
             //  5    : begin d2check <= {d2check[W-1 - 5 : 0], d_s2[W-1 : W-1 -(5-1)]};  d_s3 <= {d_s2 [W-1 -(2-2) : 0], 2'b00  }; end
             //  6    : begin d2check <= {d2check[W-1 - 6 : 0], d_s2[W-1 : W-1 -(6-1)]};  d_s3 <= {d_s2 [W-1 -(2-2) : 0], 2'b00  }; end
             //  7    : begin d2check <= {d2check[W-1 - 7 : 0], d_s2[W-1 : W-1 -(7-1)]};  d_s3 <= {d_s2 [W-1 -(2-2) : 0], 2'b00  }; end
                8    : begin                                     d_s2 <=  d_s; end
                9    : begin d2check[  0] <= d_s2[W-1        ];  d_s2 <= {d_s [W-1 - 1 : 0], 1'b0 }; end
               10    : begin d2check[1:0] <= d_s2[W-1 : W-1-1];  d_s2 <= {d_s [W-1 - 2 : 0], 2'b00 }; end
               11    : begin d2check[2:0] <= d_s2[W-1 : W-1-2];  d_s2 <= {d_s [W-1 - 3 : 0], 3'b000 }; end
               12    : begin d2check[3:0] <= d_s2[W-1 : W-1-3];  d_s2 <= {d_s [W-1 - 4 : 0], 4'b0000 }; end
               13    : begin d2check[4:0] <= d_s2[W-1 : W-1-4];  d_s2 <= {d_s [W-1 - 5 : 0], 5'b00000 }; end
               14    : begin d2check[5:0] <= d_s2[W-1 : W-1-5];  d_s2 <= {d_s [W-1 - 6 : 0], 6'b000000 }; end
               15    : begin d2check[6:0] <= d_s2[W-1 : W-1-6];  d_s2 <= {d_s [W-1 - 7 : 0], 7'b0000000 }; end
               16    : begin d2check      <= d_s2;  end
               default  : d2check <= d2check;     
             endcase
          end
       else // (pointer < W) encoding
          begin
                 if (code_matched[2]) begin pointer<=pointer+2; d2check<={d2check[W-1-2:0], d_s3[W-1:W-1-(2-1)]};  d_s3 <= {d_s3[W-1-(2-2):0],2'b00 }; end
            else if (code_matched[3]) begin pointer<=pointer+3; d2check<={d2check[W-1-3:0], d_s3[W-1:W-1-(3-1)]};  d_s3 <= {d_s3[W-1-(3-2):0],3'b000 }; end
            else if (code_matched[4]) begin pointer<=pointer+4; d2check<={d2check[W-1-4:0], d_s3[W-1:W-1-(4-1)]};  d_s3 <= {d_s3[W-1-(4-2):0],4'b0000}; end

             //case(code_matched)
             //  2    : begin pointer <= pointer + 2; d2check <= {d2check[W-1 - 2 : 0], d_s3[W-1 : W-1 -(2-1)]};  d_s3 <= {d_s3 [W-1 -(2-2) : 0], 2'b00  }; end
             //  4    : begin pointer <= pointer + 3; d2check <= {d2check[W-1 - 3 : 0], d_s3[W-1 : W-1 -(3-1)]};  d_s3 <= {d_s3 [W-1 -(3-2) : 0], 3'b000 }; end
             //  8    : begin pointer <= pointer + 4; d2check <= {d2check[W-1 - 4 : 0], d_s3[W-1 : W-1 -(4-1)]};  d_s3 <= {d_s3 [W-1 -(4-2) : 0], 4'b0000}; end
             //  default  : pointer <= pointer;     
             //endcase
          end



  end // always

   Huffman_grp_detect #(
      .NUM_OF_CHARS  (NUM_OF_2_BIT_CHARS), 
      .D_W      (W),
      .C_W      (2)     
   )   grp2_detect   (
      .clk    (clk                 ) ,
      .rst    (rst                 ) ,
      .d_conf      (d_conf), 
      .h_conf      (h_conf),  
      .w_conf      (w_conf), 
      .en_conf     (en_conf), 
      .new_conf    (new_conf), 
      .d2check     (d2check[W-1 : W-1-(2-1)]),
      .code_matched(code_matched[2]),
      .data_encoded(data_encoded[2*W +: W])
   );

   Huffman_grp_detect #(
      .NUM_OF_CHARS  (NUM_OF_3_BIT_CHARS), 
      .D_W      (W),
      .C_W      (3)     
   )   grp3_detect   (
      .clk    (clk                 ) ,
      .rst    (rst                 ) ,
      .d_conf      (d_conf), 
      .h_conf      (h_conf),  
      .w_conf      (w_conf), 
      .en_conf     (en_conf), 
      .new_conf    (new_conf), 
      .d2check     (d2check[W-1 : W-1-(3-1)]),
      .code_matched(code_matched[3]),
      .data_encoded(data_encoded[3*W +: W])
   );

      Huffman_grp_detect #(
      .NUM_OF_CHARS  (NUM_OF_4_BIT_CHARS), 
      .D_W      (W),
      .C_W      (4)     
   )   grp4_detect   (
      .clk    (clk                 ) ,
      .rst    (rst                 ) ,
      .d_conf      (d_conf), 
      .h_conf      (h_conf),  
      .w_conf      (w_conf), 
      .en_conf     (en_conf), 
      .new_conf    (new_conf), 
      .d2check     (d2check[W-1 : W-1-(4-1)]),
      .code_matched(code_matched[4]),
      .data_encoded(data_encoded[4*W +: W])
   );


assign code_matched[5] = 1'b0;
assign code_matched[6] = 1'b0;
assign code_matched[7] = 1'b0;
assign code_matched[8] = 1'b0;

always   @(code_matched,data_encoded ) 
  if      (code_matched[2]) d_out <= data_encoded[2*W +: W];
  else if (code_matched[3]) d_out <= data_encoded[3*W +: W];
  else if (code_matched[4]) d_out <= data_encoded[4*W +: W];
  else if (code_matched[5]) d_out <= data_encoded[5*W +: W];
  else if (code_matched[6]) d_out <= data_encoded[6*W +: W];
  else if (code_matched[7]) d_out <= data_encoded[7*W +: W];
  else if (code_matched[8]) d_out <= data_encoded[8*W +: W];

assign en_out = (code_matched == 0) ? 1'b0 : 1'b1;
 

endmodule // carry_lookahead_adder
