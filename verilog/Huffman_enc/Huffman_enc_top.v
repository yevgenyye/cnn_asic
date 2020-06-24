//`include "full_adder.v"
 
module Huffman_enc_top
  #(
   parameter W  = 8, // bus width
   parameter CH = 8  // number of channels
  )
  (
   input wire          clk     ,
   input wire          rst     ,
   output wire [CH  -1:0] d_req   , 
   input wire [CH*W-1:0]  d_in    , // Huffman coded data
   input wire [CH  -1:0]  en_in   , // 
   input wire [CH  -1:0]  ready_in, // input pool is not empty
   input wire [8   -1:0]  n_conf , //configuration stage. number of channel (max 256)
   input wire [   W-1:0]  d_conf  , // configuration stage. encoded data 
   input wire [   W-1:0]  h_conf  , // configuration stage. huffman code data 
   input wire [   W-1:0]  w_conf  , // configuration stage. huffman code  width
   input wire             en_conf , // configuration enable
   input wire             new_conf, // new configuration and reset old values
   output     [CH*W-1:0]  d_out   , // Encoded data
   output     [CH  -1:0]  en_out    // 
   );

localparam BUFFER_LD = 100; // buffer size to read from all encoders
localparam WTSEL = 2'b01 ;
localparam RTSEL = 2'b01 ;
localparam VG    = 1'b1;
localparam VS    = 1'b1;
localparam CEBA  = 1'b0; // enable must be 0
localparam WEBB  = 1'b1; // active low signal
localparam CEBB  = 1'b0; // enable must be 0
localparam BWEBA = {(W){1'b0}};
localparam BWEBB = {(W){1'b0}};
reg   [W-1:0] DB1, QA1; // not connected

reg [CH*W-1:0]  d_count;
wire [CH  -1:0]  buffer_ready;
reg             buffer_rd;

wire    [CH*W-1:0]  d_huff   , // Encoded data
wire    [CH  -1:0]  en_huff    // 
wire [CH  -1:0] en2_conf;
genvar          i,j;

assign en2_conf = (en_conf) ? (1 << n_conf) : {(CH){1'b0}};

generate 
   for (j = 0; j <= CH-1; j = j + 1) begin : gen_Huff
      Huffman_enc #(
            .W    (W    ) 
            )   Huff_enc1   (
            .clk      ( clk              ),
            .rst      ( rst              ),
            .d_req    ( d_req[j]         ), 
            .d_in     ( d_in  [j*W +:W ] ), 
            .en_in    ( en_in[j]         ),  
            .ready_in ( ready_in[j]      ), 
            .d_conf   ( d_conf           ),  
            .h_conf   ( h_conf           ),  
            .w_conf   ( w_conf           ), 
            .en_conf  ( en2_conf[j]      ), 
            .new_conf ( new_conf         ), 
            .d_out    ( d_huff  [j*W+:W] ), 
            .en_out   ( en_huff [j]      )   
            );

     // gen_mem
      TSDN28HPCA256X4M8FW   
      fifo1
         (
          .WTSEL(WTSEL),
          .RTSEL(RTSEL),
          .VG   (VG   ),
          .VS   (VS   ),
          .AA   ( addr_wr[j*W+:W] ), // addr portA
          .DA   (d_huff  [j*W+:W]  ), // data portA 
          .BWEBA(BWEBA),
          .WEBA (en_huff [j] ), //
          .CEBA (CEBA ),
          .CLKA (clk  ),
          .AB   (addr_rd[j*W+:W]  ), // porrtB
          .DB   (DB1  ), // porrtB
          .BWEBB(BWEBB),
          .WEBB (WEBB ),
          .CEBB (CEBB ),
          .CLKB (clk  ),
          .QA   (QA1  ), // outputs
          .QB   (d_out  [j*W+:W]  )  // outputs
        );


         always @(posedge clk, rst) // or rst)
            if (rst) begin
               d_count <= 0;
               addr_wr[j*W+:W]<= 0;
               addr_rd[j*W+:W]<= 0;
            end else begin
               if (en_huff [j] && ~buffer_rd)
                 d_count <= d_count +1;
               else if (~en_huff [j] && buffer_rd)
                 d_count <= d_count -1;

               if (en_huff [j])
                 addr_wr[j*W+:W] <= addr_wr[j*W+:W] +1;
               if (buffer_rd)
                 addr_rd[j*W+:W] <= addr_rd[j*W+:W] -1;
         end // always if
         
         assign  buffer_ready[j] = (addr_wr > addr_rd)? 1'b1 : 1'b0; // (d_count >= BUFFER_LD)
    end
endgenerate

assign  buffer_rd = (buffer_ready > {(W){1'b1}})? 1'b1 : 1'b0;

always @(posedge clk, rst) // or rst)
         if (rst) begin
            en_out <= 0;
         end else begin
            en_out <= buffer_rd;
      end // always if

endmodule // carry_lookahead_adder
