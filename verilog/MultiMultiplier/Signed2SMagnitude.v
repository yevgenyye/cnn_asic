///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////
//Generic Ripple Carry Adder
////////////////////////////////////
 
module Signed2SMagnitude

(d_in, convtype, sign, d_out);
input      [8-1:0] d_in ;
input      [  1:0] convtype;
output reg [  3:0] sign ;
output reg [8-1:0] d_out;

wire   [8-1:0] a1, b;
wire   [8-1:0] d1 ;
wire   [7  :1] c_i;
wire   [8  :1] c_o;
wire cout;

/// test variables
wire [3:0] ndin74, ndin30;

localparam NO_CONV = 2'b00;  // not in use
localparam CONV_2  = 2'b01;
localparam CONV_4  = 2'b10;
localparam CONV_8  = 2'b11;

genvar i;

//generate
//   for (i=0; i<=8-1; i=i+1) begin  :gen_rca
//      full_adder fa1 ( .a(a1[i]), .b(b[i]),  .cin(c_i[i]), .sum(sum[i]), .cout(c_o[i+1])  );
//   end 
//endgenerate

half_adder ha  ( .a(~d_in[0]), .b(b[0]),                .sum(d1[0]), .cout(c_o[0+1]) );
full_adder fa1 ( .a(~d_in[1]), .b(b[1]),  .cin(c_i[1]), .sum(d1[1]), .cout(c_o[1+1])  );
full_adder fa2 ( .a(~d_in[2]), .b(b[2]),  .cin(c_i[2]), .sum(d1[2]), .cout(c_o[2+1])  );
full_adder fa3 ( .a(~d_in[3]), .b(b[3]),  .cin(c_i[3]), .sum(d1[3]), .cout(c_o[3+1])  );
full_adder fa4 ( .a(~d_in[4]), .b(b[4]),  .cin(c_i[4]), .sum(d1[4]), .cout(c_o[4+1])  );
full_adder fa5 ( .a(~d_in[5]), .b(b[5]),  .cin(c_i[5]), .sum(d1[5]), .cout(c_o[5+1])  );
full_adder fa6 ( .a(~d_in[6]), .b(b[6]),  .cin(c_i[6]), .sum(d1[6]), .cout(c_o[6+1])  );
full_adder fa7 ( .a(~d_in[7]), .b(b[7]),  .cin(c_i[7]), .sum(d1[7]), .cout(c_o[7+1])  );

//assign a1 = ~d_in;

assign c_i[1] =                               c_o[1];
assign c_i[2] = (convtype == CONV_2) ? 1'b0 : c_o[2];
assign c_i[3] =                               c_o[3];
assign c_i[4] = (convtype == CONV_4) ? 1'b0 :
                (convtype == CONV_2) ? 1'b0 : c_o[4];
assign c_i[5] =                               c_o[5];
assign c_i[6] = (convtype == CONV_2) ? 1'b0 : c_o[6];
assign c_i[7] =                               c_o[7];


//assign b[0] = (convtype == NO_CONV) ? 1'b0 : 1'b1 ;
  assign b[0] = 1'b1 ;
assign b[1] = 1'b0;
assign b[2] = (convtype ==  CONV_2) ? 1'b1 : 1'b0 ;
assign b[3] = 1'b0;
assign b[4] = (convtype ==  CONV_4) ? 1'b1 :
              (convtype ==  CONV_2) ? 1'b1 : 1'b0 ;
assign b[5] = 1'b0;
assign b[6] = (convtype ==  CONV_2) ? 1'b1 : 1'b0 ;
assign b[7] = 1'b0;

always @(d_in or convtype) 
 begin
   if      (convtype == CONV_8)
     begin
       sign[3  ] = d_in[7];
       sign[2:0] = 3'b000;
       if (d_in[7] == 1) //  negative 8bit number 
       	 d_out = d1;
       else
       	 d_out = d_in;
     end
   else if (convtype == CONV_4)
     begin
       sign[3] = d_in[7];
       sign[2] = 1'b0;
       sign[1] = d_in[3];
       sign[0] = 1'b0;

   	   if ( d_in[7] == 1) //  negative 4MSB number 
       	 d_out[7:4] = d1[7:4];
       else
       	 d_out[7:4] = d_in[7:4];
   	   if ( d_in[3] == 1) //  negative 4LSB number 
       	 d_out[3:0] = d1[3:0];
       else
       	 d_out[3:0] = d_in[3:0];
     end
   else // if (convtype == CONV_2)
     begin
       sign[3] = d_in[7];
       sign[2] = d_in[5];
       sign[1] = d_in[3];
       sign[0] = d_in[1];

   	   if ( d_in[7] == 1) //  negative 2MSB number 
       	 d_out[7:6] = d1[7:6];
       else
       	 d_out[7:6] = d_in[7:6];
   	   if ( d_in[5] == 1) //  negative 2Middle2SB number 
       	 d_out[5:4] = d1[5:4];
       else
       	 d_out[5:4] = d_in[5:4];
   	   if ( d_in[3] == 1) //  negative 1Middle2SB number 
       	 d_out[3:2] = d1[3:2];
       else
       	 d_out[3:2] = d_in[3:2];
   	   if ( d_in[1] == 1) //  negative 2LSB number 
       	 d_out[1:0] = d1[1:0];
       else
       	 d_out[1:0] = d_in[1:0];
     end
//   else  //  NO_CONV
//   	 begin
//   	   d_out = d_in;
//       sign[3:0] = 4'b0000;
//     end
 end	
//assign d_out[0] = (convtype == CONV_8 && d_in[7] = 1) ?  ;
//assign d_out[1] = (convtype == CONV_8 && ) ? ;
//assign d_out[2] = (convtype == CONV_8 && ) ? ;
//assign d_out[3] = (convtype == CONV_8 && ) ? ;
//assign d_out[4] = (convtype == CONV_8 && ) ? ;
//assign d_out[5] = (convtype == CONV_8 && ) ? ;
//assign d_out[6] = (convtype == CONV_8 && ) ? ;
//assign d_out[7] = (convtype == CONV_8 && ) ? ;
////////
endmodule
