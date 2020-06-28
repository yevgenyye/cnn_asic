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
   input wire          ready_in, // input pool is not empty
   input wire [W-1:0]  d_conf  , // configuration stage. encoded data 
   input wire [W-1:0]  h_conf  , // configuration stage. huffman code data 
   input wire [W-1:0]  w_conf  , // configuration stage. huffman code  width
   input wire          en_conf , // configuration enable
   input wire          new_conf, // new configuration and reset old values
   output      [W-1:0] d_out   , // Encoded data
   output              en_out    // 
   );

localparam SIM = 0;

localparam  W_A = (W == 8) ? 3 : 2;

localparam [2:0] 
    empty2 = 3'b000,
    ws2    = 3'b001,
    empty1 = 3'b010, 
    ws1    = 3'b011, 
    empty0 = 3'b100,
    ws0    = 3'b101,
    work   = 3'b110,
    wsw    = 3'b111;
reg [2:0] state, state_prev;

localparam [1:0] 
    IDLE   = 2'b00,
    CHECK6 = 2'b01,
    CHECK7 = 2'b10, 
    CHECK8 = 2'b11;

reg [1:0]          check_big, check_big_prev;        // FSM for big (6,7,8) width of Huff code
reg [256 - 1 : 0]  Huff_big_active;  // vector of precentce of codes 6,7,and 8 bit width
wire               WR_big_table;     // write enable to code table during initialisation
wire               code_matched_big; // big with (6,7,8) code matched indication
reg  [8-1:0]       d2check_big;      // giggest (8) code width
wire [8-1:0]       Addr_table_big;   // 
reg  [8-1:0]       ram [256-1:0];
wire [8-1:0]       data_encoded_big;
wire [15:0]       test_shiftr;

localparam  NUM_OF_2_BIT_CHARS   =   4; // less than 4
localparam  NUM_OF_3_BIT_CHARS   =   8; // less than 8
localparam  NUM_OF_4_BIT_CHARS   =  16; // less than 16
localparam  NUM_OF_5_BIT_CHARS   =  32; // less than 32
localparam  NUM_OF_6_BIT_CHARS   =   5; // 
localparam  NUM_OF_7_BIT_CHARS   =   5; //
localparam  NUM_OF_8_BIT_CHARS   =  15; //

localparam  OFFSET_ADDR_6        =   0;
localparam  OFFSET_ADDR_7        =   0;
localparam  OFFSET_ADDR_8        =   0;

localparam  ADDR_BIG = 5; // addr for NUM_OF_6/7/8_BIT_CHARS vectors
wire  [NUM_OF_6_BIT_CHARS  -1 : 0]      en_conf_6bit;
wire  [NUM_OF_7_BIT_CHARS  -1 : 0]      en_conf_7bit;
wire  [NUM_OF_8_BIT_CHARS  -1 : 0]      en_conf_8bit;
reg   [ADDR_BIG  -1 : 0]      count_conf6;
reg   [ADDR_BIG  -1 : 0]      count_conf7;
reg   [ADDR_BIG  -1 : 0]      count_conf8;
wire  [NUM_OF_6_BIT_CHARS*W-1 : 0] code_matched_6bit;
wire  [NUM_OF_7_BIT_CHARS*W-1 : 0] code_matched_7bit;
wire  [NUM_OF_8_BIT_CHARS*W-1 : 0] code_matched_8bit;
wire  [W -1 : 0] code_matched_6bit1;
wire  [W -1 : 0] code_matched_7bit1;
wire  [W -1 : 0] code_matched_8bit1;
wire  [NUM_OF_6_BIT_CHARS  -1 : 0] data_encoded_6bit;
wire  [NUM_OF_7_BIT_CHARS  -1 : 0] data_encoded_7bit;
wire  [NUM_OF_8_BIT_CHARS  -1 : 0] data_encoded_8bit;
reg   [ADDR_BIG  -1 : 0]           addr_6bit;
reg   [ADDR_BIG  -1 : 0]           addr_7bit;
reg   [ADDR_BIG  -1 : 0]           addr_8bit;
genvar   j;
integer  i;

// input shift reg
reg [W   -1 : 0]  d_s, d_s3  ; // input data sampled data 
reg [W   -1 : 0]  d2check;
reg [W_A +1 : 0]  pointer;
//reg               d_s1_empty, d_s2_empty; 
wire  d_s2;
wire  d_s2_empty;
wire  d_empty;
reg d_empty_d;
//reg               shift_sig; 

// encoder
//reg  [NUM_OF_2_BIT_CHARS*W - 1 : 0] Huff_table;
//reg  [NUM_OF_2_BIT_CHARS   - 1 : 0] Huff_active; // active addresses
wire [W : 2]           code_matched; 
wire [(W+1)*W : 2*W]   data_encoded;
///////////////////////////////
///// input shift register
///////////////////////////////

 assign d_s2_empty = (pointer >= W ) ? 1'b1 : 1'b0;
 assign d_empty = (pointer >= W ) ? 1'b1 : 1'b0;
 assign d_s2 = d_s3;
//assign d_req = d_s1_empty;
always @(posedge clk) // or rst)
  if (rst) begin
    d_s        <= 0;
   // d_s2       <= 0;
    d_s3       <= 0;
  //d_s1_empty <= 1;
  //d_s2_empty <= 1;
    d_req      <= 0;
    d2check    <= 0;
    pointer    <= 0; //2*2**W_A;
    state      <= empty2; 
    state_prev <= empty2; 
    d_empty_d <= 0;
  end else begin
    state_prev <= state;
    d_empty_d  <= d_empty;
    case (state)
      empty2 :      if ( ready_in               ) begin state <= ws2;   d_req <= 1;                $display("_empty2_ %b",state); end // 3'b000

         ws2 :                                    begin state <= empty1;d_req <= 1;                $display("_w2_a %b",state);    end // 3'b001

      empty1 : begin
                    if ( ready_in               ) begin state <= ws1;    d_req <= 1;                $display("_empty1_a %b",state); end // 3'b010 
               else if (~ready_in               ) begin state <= empty2; d_req <= 0;                $display("_empty1_b %b",state); end // 
                    if (en_in)                                                       d_s   <= d_in;
               end

         ws1 :                                    begin state <= empty0; d_req <= 0;                $display("_w1_ %b",state);
                      if (en_in)  begin                                              d_s   <= d_in;
                                                                                     d_s3  <= d_s; 
                                  end
                                                                                                                                     end // 3'b011



         empty0 :    if ( ready_in         )
                                         begin                                                                                                // 3'b100
                                                       state <= work; d_req <= 0;   d_s   <= d_in;
                                                                                    d_s3    <= d_s;
                                                                                    d2check <= d_s3; 
                                          end

         ws0 :                                    begin state <= work; d_req <= 0;                $display("_w0_ %b",state);  
                                                                                // d2check <= d_s3             ;
                                                                                // d_s3    <= d_s2;
                                                                                 d_s    <= d_in;    end // 3'b101

        work : begin                                                   d_req <= 0;
                      if ( ready_in         ) begin 
                                                       if (en_in)  begin         d_s    <= d_in; 
                                                                             //    d_s2   <= d_s; 
                                                                    end
                                 if ( pointer >= W) 
                                                  begin state <= ws0;    d_req <= 1;                 $display("_work_a %b",state); 
                                                  end
                                                                                                                                    end // 3'b110
               else if ( ~ready_in              ) begin state <= empty2; d_req <= 0;                $display("_work_b %b",state); end // 
                    if (en_in)                                                       
                                d_s  <= d_in;
                    if (pointer >= W)  // get new data - 2 clock cycles
                        begin
                           pointer    <= pointer-W;
                           case(pointer)
                              8    : begin                                    d_s3 <=  d_s;                      end  
                              9    : begin d2check[  0] <= d_s[W-1        ];  d_s3 <= {d_s [W-1 - 1 : 0], 1'b0 }; end
                             10    : begin d2check[1:0] <= d_s[W-1 : W-1-1];  d_s3 <= {d_s [W-1 - 2 : 0], 2'b00 }; end
                             11    : begin d2check[2:0] <= d_s[W-1 : W-1-2];  d_s3 <= {d_s [W-1 - 3 : 0], 3'b000 }; end
                             12    : begin d2check[3:0] <= d_s[W-1 : W-1-3];  d_s3 <= {d_s [W-1 - 4 : 0], 4'b0000 }; end
                             13    : begin d2check[4:0] <= d_s[W-1 : W-1-4];  d_s3 <= {d_s [W-1 - 5 : 0], 5'b00000 }; end
                             14    : begin d2check[5:0] <= d_s[W-1 : W-1-5];  d_s3 <= {d_s [W-1 - 6 : 0], 6'b000000 }; end
                             15    : begin d2check[6:0] <= d_s[W-1 : W-1-6];  d_s3 <= {d_s [W-1 - 7 : 0], 7'b0000000 }; end
                             16    : begin                                    d_s3 <=  d_s; end
                             default  : d2check <= d2check;     
                           endcase
                        end
                     else // (pointer < W) encoding
                        begin
                               if (code_matched[2]) begin pointer<=pointer+2; d2check<={d2check[W-1-2:0], d_s3[W-1:W-1-(2-1)]};  d_s3 <= {d_s3[W-1-(2-2):0],2'b00      }; end
                          else if (code_matched[3]) begin pointer<=pointer+3; d2check<={d2check[W-1-3:0], d_s3[W-1:W-1-(3-1)]};  d_s3 <= {d_s3[W-1-(3-2):0],3'b000     }; end
                          else if (code_matched[4]) begin pointer<=pointer+4; d2check<={d2check[W-1-4:0], d_s3[W-1:W-1-(4-1)]};  d_s3 <= {d_s3[W-1-(4-2):0],4'b0000    }; end
                          else if (code_matched[5]) begin pointer<=pointer+5; d2check<={d2check[W-1-5:0], d_s3[W-1:W-1-(5-1)]};  d_s3 <= {d_s3[W-1-(5-2):0],5'b00000   }; end
                          else if (code_matched[6]) begin pointer<=pointer+6; d2check<={d2check[W-1-6:0], d_s3[W-1:W-1-(6-1)]};  d_s3 <= {d_s3[W-1-(6-2):0],6'b000000  }; end
                          else if (code_matched[7]) begin pointer<=pointer+7; d2check<={d2check[W-1-7:0], d_s3[W-1:W-1-(7-1)]};  d_s3 <= {d_s3[W-1-(7-2):0],7'b0000000 }; end
                        end
              
               end
   
    endcase


  end // always

assign test_shiftr = {d2check, d_s3};

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

      Huffman_grp_detect #(
      .NUM_OF_CHARS  (NUM_OF_5_BIT_CHARS), 
      .D_W      (W),
      .C_W      (5)     
   )   grp5_detect   (
      .clk    (clk                 ) ,
      .rst    (rst                 ) ,
      .d_conf      (d_conf), 
      .h_conf      (h_conf),  
      .w_conf      (w_conf), 
      .en_conf     (en_conf), 
      .new_conf    (new_conf), 
      .d2check     (d2check[W-1 : W-1-(5-1)]),
      .code_matched(code_matched[5]),
      .data_encoded(data_encoded[5*W +: W])
   );


always @(posedge clk) 
  if (rst) begin
     count_conf6   <= 0;
     count_conf7   <= 0;
     count_conf8   <= 0;
  end else begin
    if (new_conf)
      begin
        count_conf6   <= 0;
        count_conf7   <= 0;
        count_conf8   <= 0;
      end
    else
      begin
        if ( {1'b0,w_conf} == 6)  count_conf6  <= count_conf6 + 1;
        if ( {1'b0,w_conf} == 7)  count_conf7  <= count_conf7 + 1;
        if ( {1'b0,w_conf} == 8)  count_conf8  <= count_conf8 + 1;
      end
  end //rst

assign en_conf_6bit = ( {1'b0,w_conf} == 6 && en_conf) ? ( 1'b1 << count_conf6 ) : 1'b0;
assign en_conf_7bit = ( {1'b0,w_conf} == 7 && en_conf) ? ( 1'b1 << count_conf7 ) : 1'b0;
assign en_conf_8bit = ( {1'b0,w_conf} == 8 && en_conf) ? ( 1'b1 << count_conf8 ) : 1'b0;

//assign en_conf_6bit = ( {1'b0,w_conf} == 6 && en_conf) ? 1'b1 : 1'b0;
//assign en_conf_7bit = ( {1'b0,w_conf} == 7 && en_conf) ? 1'b1 : 1'b0;
//assign en_conf_8bit = ( {1'b0,w_conf} == 8 && en_conf) ? 1'b1 : 1'b0;



generate 
   for (j = 0; j <= NUM_OF_6_BIT_CHARS-1; j = j + 1) begin : gen_6bit
       Huffman_one_detect
       #(
          .D_W(W),
          .C_W(6) 
       )
       Huff_1_6
       (
         .clk         (clk                        ),
         .rst         (rst                        ),
         .d_conf      (d_conf                     ), // 
         .h_conf      (h_conf                     ), //  
         .en_conf     (en_conf_6bit[j]            ), // 
         .new_conf    (new_conf                   ), // 
         .d2check     (d2check[W-1 : W-1-(6-1)]   ),
         .code_matched(code_matched_6bit[j*W +: W]),
         .data_encoded(data_encoded_6bit[j]       )
        );
   end //for
endgenerate


generate 
   for (j = 0; j <= NUM_OF_7_BIT_CHARS-1; j = j + 1) begin : gen_7bit
       Huffman_one_detect
       #(
          .D_W(W),
          .C_W(7) 
       )
       Huff_1_7
       (
         .clk         (clk                        ),
         .rst         (rst                        ),
         .d_conf      (d_conf                     ), // 
         .h_conf      (h_conf                     ), //  
         .en_conf     (en_conf_7bit[j]            ), // 
         .new_conf    (new_conf                   ), // 
         .d2check     (d2check[W-1 : W-1-(7-1)]   ),
         .code_matched(code_matched_7bit[j*W +: W]),
         .data_encoded(data_encoded_7bit[j]       )
        );
   end //for
endgenerate

generate 
   for (j = 0; j <= NUM_OF_8_BIT_CHARS-1; j = j + 1) begin : gen_8bit
      Huffman_one_detect
       #(
          .D_W(W),
          .C_W(8) 
       )
       Huff_1_8
       (
         .clk         (clk                        ),
         .rst         (rst                        ),
         .d_conf      (d_conf                     ), // 
         .h_conf      (h_conf                     ), //  
         .en_conf     (en_conf_8bit[j]            ), // 
         .new_conf    (new_conf                   ), // 
         .d2check     (d2check[W-1 : W-1-(8-1)]   ),
         .code_matched(code_matched_8bit[j*W +: W]),
         .data_encoded(data_encoded_8bit[j]       )
        );
 
   end //for
endgenerate

assign code_matched[6] = ( data_encoded_6bit == 0) ? 1'b0 : 1'b1;
assign code_matched[7] = ( data_encoded_7bit == 0) ? 1'b0 : 1'b1;
assign code_matched[8] = ( data_encoded_8bit == 0) ? 1'b0 : 1'b1;

  always @* begin
    addr_6bit = 0; 
    for (i=7; i>=0; i=i-1)
        if (data_encoded_6bit[i]) 
          addr_6bit = i;
  end
assign code_matched_6bit1 = code_matched_6bit[addr_6bit*W +: W];

  always @* begin
    addr_7bit = 0; 
    for (i=7; i>=0; i=i-1)
        if (data_encoded_7bit[i]) 
          addr_7bit = i;
  end
assign code_matched_7bit1 = code_matched_7bit[addr_7bit*W +: W];

  always @* begin
    addr_8bit = 0; 
    for (i=7; i>=0; i=i-1)
        if (data_encoded_8bit[i]) 
          addr_8bit = i;
  end
assign code_matched_8bit1 = code_matched_8bit[addr_8bit*W +: W];

assign d_out  = (code_matched[2]) ? data_encoded[2*W +: W] :
                (code_matched[3]) ? data_encoded[3*W +: W] :
                (code_matched[4]) ? data_encoded[4*W +: W] :
                (code_matched[5]) ? data_encoded[5*W +: W] :
                (code_matched[6]) ? code_matched_6bit1 :
                (code_matched[7]) ? code_matched_7bit1 :
                                    code_matched_8bit1 ;

assign en_out = (code_matched != 0 && (state == work && pointer < W) ) ? 1'b1 : 1'b0;


//assign WR_big_table = ( ( {1'b0,w_conf} == 6 || 
//                          {1'b0,w_conf} == 7 || 
//                          {1'b0,w_conf} == 8 ) && en_conf) ? 1'b1 : 1'b0;
//
//always @(posedge clk) // or rst)
//  if (rst) begin
//     Huff_big_active   <= 0;
//  end else begin
//    if (new_conf)
//       Huff_big_active   <= 0;
//    else
//       if ( WR_big_table )
//         begin
//          Huff_big_active[Addr_table_big] <= 1'b1;
//        //Huff_table[D_W*h_conf +: D_W] <= d_conf ;
//         end
//  end //rst
//
//always @(posedge clk) // or rst)
//  if (rst) begin
//     check_big      <= CHECK6;
//     check_big_prev <= CHECK6;
//  end else begin
//    check_big_prev <= check_big;
//    if (state != work || pointer >= W)
//       begin            check_big <= CHECK6;   end
//       //begin            check_big <= CHECK7; d2check_big <= { 2'b00, d2check[W-1 : W-1-(6-1)] } + OFFSET_ADDR_6; end
//    else
//      case(check_big)
//        CHECK6  : begin check_big <= CHECK7; d2check_big <= { 2'b00, d2check[W-1 : W-1-(6-1)] } + OFFSET_ADDR_6; end  // 2'b01
//        CHECK7  : begin check_big <= CHECK8; d2check_big <= { 1'b0 , d2check[W-1 : W-1-(7-1)] } + OFFSET_ADDR_7; end  // 2'b10
//        CHECK8  : begin check_big <= CHECK6; d2check_big <=          d2check[W-1 : W-1-(8-1)]   + OFFSET_ADDR_8; end  // 2'b11
//        default :       check_big <= check_big;     
//      endcase
//  end //rst
//
//
//assign  Addr_table_big = ( {1'b0,w_conf} == 6 ) ? h_conf + OFFSET_ADDR_6 : 
//                         ( {1'b0,w_conf} == 7 ) ? h_conf + OFFSET_ADDR_7 : 
//                                                  h_conf + OFFSET_ADDR_8 ; 
//// FOr simulation
////  always @(posedge clk) begin   
////    if (WR_big_table)   
////      ram[Addr_table_big] <= d_conf;   
////  end   
////
////  assign data_encoded_big = ram[d2check_big]; 
//
//      TSDN28HPCA256X8M8FW   
//      fifo1
//         (
//          .WTSEL(WTSEL),
//          .RTSEL(RTSEL),
//          .VG   (VG   ),
//          .VS   (VS   ),
//          .AA   ( Addr_table_big), // addr portA
//          .DA   (d_conf  ), // data portA 
//          .BWEBA(BWEBA),
//          .WEBA (WR_big_table ), //
//          .CEBA (CEBA ),
//          .CLKA (clk  ),
//          .AB   (d2check_big  ), // porrtB
//          .DB   (DB1  ), // porrtB
//          .BWEBB(BWEBB),
//          .WEBB (WEBB ),
//          .CEBB (CEBB ),
//          .CLKB (clk  ),
//          .QA   (QA1  ), // outputs
//          .QB   (data_encoded_big  )  // outputs
//        );
//
//
// //     assign code_matched = (Huff_active[d2check]) ? 1'b1 : 1'b0; 
///////////////////////////////////////////////////
//
//assign code_matched[6] = ( Huff_big_active[d2check_big] == 1'b1 && check_big_prev == CHECK6) ? 1'b1 : 1'b0;
//assign code_matched[7] = ( Huff_big_active[d2check_big] == 1'b1 && check_big_prev == CHECK7) ? 1'b1 : 1'b0;
//assign code_matched[8] = ( Huff_big_active[d2check_big] == 1'b1 && check_big_prev == CHECK8) ? 1'b1 : 1'b0;
//
//assign d_out  = (code_matched[2]) ? data_encoded[2*W +: W] :
//                (code_matched[3]) ? data_encoded[3*W +: W] :
//                (code_matched[4]) ? data_encoded[4*W +: W] :
//                (code_matched[5]) ? data_encoded[5*W +: W] :
//                (code_matched[6]) ? data_encoded_big :
//                (code_matched[7]) ? data_encoded_big :
//                                    data_encoded_big ;
//
//
////assign en_out = (code_matched == 0 || state != work ) ? 1'b0 : 1'b1;
//assign en_out = (code_matched != 0 && (state == work && pointer < W) ) ? 1'b1 : 1'b0;
 

endmodule // carry_lookahead_adder
