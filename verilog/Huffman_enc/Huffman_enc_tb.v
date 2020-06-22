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
 


localparam  B2_2   = 2'b10;
localparam  B2_1   = 2'b01;
localparam  B6_33  = 6'b110011;
localparam  B7_63  = 7'b1100011;
localparam  B8_C0  = 8'b11000011;

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
      h_conf  <= {6'b000000 , B2_2};
      d_conf  <= 8'h11;

      #10;
      w_conf   <= 2;
      h_conf  <= {6'b000000 , B2_1};
      d_conf  <= 8'h33;

      //#10;
      //w_conf   <= 2;
      //h_conf  <= {6'b000000 , 2'b10};
      //d_conf  <= 8'h30;

      //#10;
      //w_conf   <= 2;
      //h_conf  <= {6'b000000 , 2'b11};
      //d_conf  <= 8'h32;

      //////////////////////////  3 /////////////////
      //#10;
      //w_conf  <= 3;
      //h_conf  <= {5'b00000 , 3'b100};
      //d_conf  <= 8'h55;


      //#10;
      //w_conf  <= 3;
      //h_conf  <= {5'b00000 , 3'b101};
      //d_conf  <= 8'h77;


      //#10;
      //w_conf  <= 3;
      //h_conf  <= {5'b00000 , 3'b110};
      //d_conf  <= 8'h99;


      //#10;
      //w_conf  <= 3;
      //h_conf  <= {5'b00000 , 3'b111};
      //d_conf  <= 8'hbb;

      //////////////////////////  4 /////////////////
      //#10;
      //w_conf  <= 4;
      //h_conf  <= {4'b0000 , 4'b000};
      //d_conf  <= 8'h51;

      //#10;
      //w_conf  <= 4;
      //h_conf  <= {4'b0000 , 4'b001};
      //d_conf  <= 8'h52;


      //#10;
      //w_conf  <= 4;
      //h_conf  <= {4'b0000 , 4'b010};
      //d_conf  <= 8'h52;


      //#10;
      //w_conf  <= 4;
      //h_conf  <= {4'b0000 , 4'b011};
      //d_conf  <= 8'h53;

      #10;
      w_conf  <= 6;
      h_conf  <= {2'b00 , B6_33};
      d_conf  <= 8'h66;

      #10;
      w_conf  <= 7;
      h_conf  <= {1'b0 , B7_63};
      d_conf  <= 8'h77;

      #10;
      w_conf  <= 8;
      h_conf  <=        B8_C0;
      d_conf  <= 8'h88;

      init_end <= 1'b1;
      new_conf <= 0;
      #10;
////////////////////////////// operational part
       j= 0;
       ready_in <= 1;
       #10;
      for (i = 0; i < 100; i = i + 1) 
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

        ready_in <= 0;

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
    1:      d_in = {B2_2, B2_1, B6_33[5:2]}; //|1 0|1 0|5 4 3 2 
    2:      d_in = {B6_33[1:0], B7_63[6:1]}; // 1 0|6 5 4 3 2 1
    3:      d_in = {B7_63[0], B8_C0[7:1]};   // 0|7 6 5 4 3 2 1
    4:      d_in = {B8_C0[0],B7_63};         // 0|6 5 4 3 2 1 0

   10, 11: d_in = 7'b1000000;    // "–" for invalid code
 default:  d_in = 7'b0000000;  
endcase

endmodule // carry_lookahead_adder_tb