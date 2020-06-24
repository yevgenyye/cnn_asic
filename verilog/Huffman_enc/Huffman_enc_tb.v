///////////////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
///////////////////////////////////////////////////////////////////////////////
 `timescale 1 ns/10 ps 
//`include "carry_lookahead_adder.v"
 
module Huffman_enc_tb ();
 
  parameter W = 8;
 
  reg           clk     ;
  reg           rst     ;
  wire          d_req   ; 
  reg  [W-1:0]  d_in    ; // Huffman coded data
  reg           en_in   ; // 
  reg           ready_in;
  reg  [W-1:0]  d_conf  ; // configuration stage. encoded data 
  reg  [W-1:0]  h_conf  ; // configuration stage. huffman code data 
  reg  [W-1:0]  w_conf  ; // configuration stage. huffman code  width
  reg           en_conf ; // configuration enable
  reg           new_conf; // new configuration and reset old values
  wire [W-1:0]  d_out   ; // Encoded data
  wire          en_out  ; // 

  reg         init_end     ;
  integer     i,j;
 


localparam  B2_0   = 2'b00;
localparam  B2_1   = 2'b01;
localparam  B3_0   = 3'b100;
localparam  B3_1   = 3'b101;
localparam  B4_0   = 4'b1100;
localparam  B4_1   = 4'b1101;
localparam  B5_0   = 5'b11100;
localparam  B5_1   = 5'b11101;

localparam  B6_0   = 6'b111100;
localparam  B6_1   = 6'b111101;
localparam  B7_0   = 7'b1111100;
localparam  B7_1   = 7'b1111101;
localparam  B8_0   = 8'b11111100;
localparam  B8_1   = 8'b11111101;

//localparam  B6_33  = 6'b110011;
//localparam  B7_63  = 7'b1100011;
//localparam  B8_C0  = 8'b11000011;

  Huffman_enc  #(
    .W(W)
    )
  DUT
  (
   .clk     (clk     ),
   .rst     (rst     ),
   .d_req   (d_req   ), 
   .d_in    (d_in    ), // Huffman coded data
   .en_in   (en_in   ), // 
   .ready_in(ready_in),
   .d_conf  (d_conf  ), // configuration stage. encoded data 
   .h_conf  (h_conf  ), // configuration stage. huffman code data 
   .w_conf  (w_conf  ), // configuration stage. huffman code  width
   .en_conf (en_conf ), // configuration enable
   .new_conf(new_conf), // new configuration and reset old values
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
          init_end <= 1'b0;
          en_in    <= 0; 
          ready_in <= 0;
          d_in     <= 150;
      #10;
          rst   <= 1'b0; 

      #10;
      new_conf <= 1;
      #10;
      new_conf <= 0;

      en_conf  <= 1;

      w_conf   <= 2;
      h_conf  <= {6'b000000 , B2_0};
      d_conf  <= 8'h20;

      #10;
      w_conf   <= 2;
      h_conf  <= {6'b000000 , B2_1};
      d_conf  <= 8'h21;

      //////////////////////////  3 /////////////////
      #10;
      w_conf  <= 3;
      h_conf  <= {5'b00000 , B3_0};
      d_conf  <= 8'h30;
      #10;
      w_conf  <= 3;
      h_conf  <= {5'b00000 , B3_1};
      d_conf  <= 8'h31;
      //////////////////////////  4 /////////////////
      #10;
      w_conf  <= 4;
      h_conf  <= {4'b0000 , B4_0};
      d_conf  <= 8'h40;

      #10;
      w_conf  <= 4;
      h_conf  <= {4'b0000 , B4_1};
      d_conf  <= 8'h41;
      //////////////////////////  5 /////////////////
      #10;
      w_conf  <= 5;
      h_conf  <= {3'b000 , B5_0};
      d_conf  <= 8'h50;

      #10;
      w_conf  <= 5;
      h_conf  <= {3'b000 , B5_1};
      d_conf  <= 8'h51;

      //////////////////////////  6 /////////////////
      #10;
      w_conf  <= 6;
      h_conf  <= {2'b00 , B6_0};
      d_conf  <= 8'h60;
      #10;
      w_conf  <= 6;
      h_conf  <= {2'b00 , B6_1};
      d_conf  <= 8'h61;

      //////////////////////////  7 /////////////////
      #10;
      w_conf  <= 7;
      h_conf  <= {1'b0 , B7_0};
      d_conf  <= 8'h70;
      #10;
      w_conf  <= 7;
      h_conf  <= {1'b0 , B7_1};
      d_conf  <= 8'h71;

      //////////////////////////  8 /////////////////
      #10;
      w_conf  <= 8;
      h_conf  <=        B8_0;
      d_conf  <= 8'h80;
      #10;
      w_conf  <= 8;
      h_conf  <=        B8_1;
      d_conf  <= 8'h81;

      init_end <= 1'b1;
      new_conf <= 0;
      #10;
////////////////////////////// operational part
       j= 0;
       ready_in <= 1;
       #10;
      for (i = 0; i < 200; i = i + 1) 
        begin
         #10;
         if (d_req) 
          begin
            j <= j + 1;
            en_in <= 1;
            $display("din(%h)= %h",i, d_in);
          end
         else
            en_in <= 0; 
        end

        #100;
        //ready_in <= 0;

      //for (i = 0; i < 100; i = i + 1) 
      //  begin
      //   #10;
      //   if (d_req) 
      //    begin
      //      d_in <= d_in + 1;
      //      en_in <= 1;
      //      $display("din(%h)= %h",i, d_in);
      //    end
      //   else
      //      en_in <= 0; 
      //  end
  
    end



always @*
 case (j)

    1:      d_in = {B2_0, B2_1, B2_0, B2_1};   // w2 -> 8 in 2 bytes
    2:      d_in = {B2_0, B2_1, B2_0, B2_1};   //
//    3:      d_in = {B2_0, B2_1, B2_0, B2_1}; // w2 -> 8 in 2 bytes
//    4:      d_in = {B2_0, B2_1, B2_0, B2_1}; //
    3:      d_in = {B3_0, B3_1, B3_0[2:1]};   // w3 -> 8 in 3 bytes
    4:      d_in = {B3_0[0]  , B3_1, B3_0,B3_1[2] };         //
    5:      d_in = {B3_1[1:0], B3_0, B3_1 };         //
    6:      d_in = {B4_0, B4_1                 }; // w4 -> 4 in 2 bytes
    7:      d_in = {B4_0, B4_1                 }; //
    8:      d_in = {B5_0, B5_1[4:2]               }; // w5 -> 8 in 5 bytes
    9:      d_in = {B5_1[1:0], B5_0, B5_1[4]      }; //
   10:      d_in = {B5_1[3:0], B5_0[4:1]          }; //
   11:      d_in = {B5_0[0], B5_1, B5_0[4:3]      }; //
   12:      d_in = {B5_0[2:0], B5_1               }; //
   13:      d_in = {B6_0, B6_1[5:4]            }; // w6 -> 4 in 3 bytes
   14:      d_in = {B6_1[3:0], B6_0[5:2]       }; //
   15:      d_in = {B6_0[1:0], B6_1            }; //
   16:      d_in = {B7_0,      B7_1[6]            }; // w7 -> 8 in 7 bytes
   17:      d_in = {B7_1[5:0], B7_0[6:5]          }; //
   18:      d_in = {B7_0[4:0], B7_1[6:4]          }; //
   19:      d_in = {B7_1[3:0], B7_0[6:3]          }; //
   20:      d_in = {B7_0[2:0], B7_1[6:2]          }; //
   21:      d_in = {B7_1[1:0], B7_0[6:1]          }; //
   22:      d_in = {B7_0[  0], B7_1               }; //
   23:      d_in = {B3_0, B8_1[7:3]              }; // w3, w8, w5 -> in 2 bytes
   24:      d_in = {B8_1[2:0],B5_1               };
   25:      d_in = {B8_0                    }; // w8 -> 2 in 2 bytes
   26:      d_in = {B8_1                    }; //

//    1:      d_in = {B2_0, B2_1, B6_33[5:2]}; //|1 0|1 0|5 4 3 2 
//    2:      d_in = {B6_33[1:0], B7_63[6:1]}; // 1 0|6 5 4 3 2 1
//    3:      d_in = {B7_63[0], B8_C0[7:1]};   // 0|7 6 5 4 3 2 1
//    4:      d_in = {B8_C0[0],B7_63};         // 0|6 5 4 3 2 1 0

//   10, 11: d_in = 7'b1000000;    // "–" for invalid code
 default:  d_in = 8'hFF;  
endcase

endmodule // carry_lookahead_adder_tb