module carry_save_adder #(
	parameter N      = 9, // number of busses (3/4/6/9)
	parameter E      = 3, // bit extention (N=9 => E=2)
    parameter W      = 16  //    input data width
)
//(a,b,c,d, sum,cout);
(a, sum, cout);
input  [N*W-1 :0] a; //, b,c,d;
output [W+E-1 :0] sum;
output cout;

// inputs 1-4
wire [W-1:0] s0, s1;
wire [W-1:0] c0, c1;


///////
wire [W:0] sum1, sum2, sum3;
wire [W:0] ca1 , ca2 , ca3 ;


wire [W+1:0] sum4, sum5;
wire [W+1:0] ca4 , ca5 ;

//wire [W+2:0] sum6;
//wire [W+2:0] ca6 ;


wire [W+4:0] sum7;
wire [W+4:0] ca7 ;

wire [W+3:0] sum7test;
wire [W+3:0] ca7test ;

wire [W+4:0] test1, test2, test3, test4;
wire [W+3:0] sum1_9  , c1_9  ;
wire [W+3:0] sum10_18, c10_18;
wire [W+3:0] sum19_25, c19_25;

genvar i,j;

//carry_save_3inputs #(W) cs_3in_1 (.a(a[0*W +: 3*W ]), .sum(sum1), .cout(ca1)  );
//carry_save_3inputs #(W) cs_3in_2 (.a(a[3*W +: 3*W ]), .sum(sum2), .cout(ca2)  );
//carry_save_3inputs #(W) cs_3in_3 (.a(a[6*W +: 3*W ]), .sum(sum3), .cout(ca3)  );
//
//assign test1 = sum1 + ca1 + sum2 + ca2 + sum3 + ca3;
//
////carry_save_3inputs #(W+1) cs_3in_11 (.a({sum1,sum2,sum3}), .sum(sum4), .cout(ca4)  );
////carry_save_3inputs #(W+1) cs_3in_12 (.a({ca1 ,ca2 ,ca3 }), .sum(sum5), .cout(ca5)  );
////
////assign test2 = sum4 + ca4 + sum5 + ca5;
////
//////carry_save_3inputs #(W+2) cs_3in_21 (.a({sum4 ,sum5 ,ca4 }), .sum(sum6), .cout(ca6)  );
//////
//////assign test3 = sum6 + ca6 + ca5;
//////
//////carry_save_3inputs #(W+3) cs_3in_22 (.a({1'b0,ca5,sum6 ,ca6 }), .sum(sum7), .cout(ca7)  );
////
////carry_save_4inputs #(W+2) cs_4in (.a({sum4 ,sum5 ,ca4,ca5 }), .sum(sum7), .cout(ca7)  );
//
//carry_save_6inputs #(W+1) cs_6in (.a({sum1,sum2,sum3, ca1 ,ca2 ,ca3 }), .sum(sum7), .cout(ca7)  );

carry_save_9inputs #(W)  cs_9in1 (.a(             a[ 0*W +: 9*W ] ), .sum(sum1_9),   .cout(c1_9  )  );
carry_save_9inputs #(W)  cs_9in2 (.a(             a[ 9*W +: 9*W ] ), .sum(sum10_18), .cout(c10_18)  );
//carry_save_9inputs #(W)  cs_9in3 (.a({(N*2){1'b0},a[18*W +: 7*W ]}), .sum(sum19_25), .cout(c19_25)  );
carry_save_9inputs #(W)  cs_9in3 (.a({4'h00,a[18*W +: 7*W ]}), .sum(sum19_25), .cout(c19_25)  );

assign test1 = sum1_9 + sum10_18 + sum19_25 + c1_9 + c10_18 + c19_25;

carry_save_6inputs #(W+3) cs_6in (.a({sum1_9,sum10_18,sum19_25, c1_9 ,c10_18 ,c19_25 }), .sum(sum7), .cout(ca7)  );

assign test4 = sum7 + ca7;



ripple_carry #(W+E) rca1 (.a(sum7),.b(ca7), .cin(1'b0),.sum(sum), .cout(cout));


endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////
// Carry Save 3 inputs (one stage)
////////////////////////////////////

module carry_save_3inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [3*W-1:0] a; //, b,c,d;
output [W  :0] sum;
output [W  :0] cout;
genvar i;

generate
   for (i=0; i<=W-1; i=i+1) begin
      full_adder fa1 ( .a(a[0*W+i]), .b(a[1*W+i]),  .cin(a[2*W+i]), .sum(sum[i]), .cout(cout[i+1])  );
   end 
endgenerate

assign cout[0] = 1'b0;
assign sum [W] = 1'b0;

endmodule

////////////////////////////////////
// Carry Save 4 inputs (two stages)
////////////////////////////////////

module carry_save_4inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [4*W-1:0] a; //, b,c,d;
output [W+1  :0] sum;
output [W+1  :0] cout;

wire [W:0] sum13; //, sum7;
wire [W:0] c13 ; //, ca7 ;

carry_save_3inputs #(W  ) cs1 (.a(a[3*W-1:0])                    , .sum(sum13), .cout(c13 )  );
carry_save_3inputs #(W+1) cs2 (.a({1'b0,a[3*W +: W],sum13 ,c13 }), .sum(sum  ), .cout(cout)  );

endmodule

////////////////////////////////////
// Carry Save 6 inputs (three stages)
////////////////////////////////////

module carry_save_6inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [6*W-1:0] a; //, b,c,d;
output [W+2  :0] sum;
output [W+2  :0] cout;

wire [W:0] sum13, sum46;
wire [W:0] c13  , c46 ;


carry_save_3inputs #(W) cs_3in_11 (.a(a[  0 +: 3*W]), .sum(sum13), .cout(c13)  );
carry_save_3inputs #(W) cs_3in_12 (.a(a[3*W +: 3*W]), .sum(sum46), .cout(c46)  );

carry_save_4inputs #(W+1) cs_4in (.a({sum13 ,c13 ,sum46,c46 }), .sum(sum), .cout(cout)  );

endmodule

////////////////////////////////////
// Carry Save 9 inputs (four stages)
////////////////////////////////////

module carry_save_9inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [9*W-1:0] a; //, b,c,d;
output [W+3  :0] sum;
output [W+3  :0] cout;

wire [W:0] sum13, sum46, sum79;
wire [W:0] c13  , c46  , c79  ;

carry_save_3inputs #(W) cs_3in_1 (.a(a[0*W +: 3*W ]), .sum(sum13), .cout(c13)  );
carry_save_3inputs #(W) cs_3in_2 (.a(a[3*W +: 3*W ]), .sum(sum46), .cout(c46)  );
carry_save_3inputs #(W) cs_3in_3 (.a(a[6*W +: 3*W ]), .sum(sum79), .cout(c79)  );

carry_save_6inputs #(W+1) cs_6in (.a({sum13,sum46,sum79, c13 ,c46 ,c79 }), .sum(sum), .cout(cout)  );

endmodule

////////////////////////////////////
//Generic Ripple Carry Adder
////////////////////////////////////
 
module ripple_carry#(
    parameter W      = 4  //    input data width
)
(a, b, cin, sum, cout);
input  [W-1:0] a,b;
input          cin;
wire   [W  :0] c1;
output [W-1:0] sum;
output cout;

genvar i;

generate
   for (i=0; i<=W-1; i=i+1) begin
      full_adder fa1 ( .a(a[i]), .b(b[i]),  .cin(c1[i]), .sum(sum[i]), .cout(c1[i+1])  );
   end 
endgenerate
assign c1[0] = cin;
assign cout  = c1[W];

//full_adder fa0(.a(a[0]), .b(b[0]),.cin(cin), .sum(sum[0]),.cout(c1));
//full_adder fa1(.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]),.cout(c2));
//full_adder fa2(.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]),.cout(c3));
//full_adder fa3(.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]),.cout(cout));
endmodule
 

//////////////////////////////////////
////4-bit Ripple Carry Adder
//////////////////////////////////////
// 
//module ripple_carry_4_bit(a, b, cin, sum, cout);
//input [3:0] a,b;
//input cin;
//wire c1,c2,c3;
//output [3:0] sum;
//output cout;
//
//
//full_adder fa0(.a(a[0]), .b(b[0]),.cin(cin), .sum(sum[0]),.cout(c1));
//full_adder fa1(.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]),.cout(c2));
//full_adder fa2(.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]),.cout(c3));
//full_adder fa3(.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]),.cout(cout));
//endmodule
 

////////////////////////////////////////////
//1bit Full Adder
///////////////////////////////////////////
module full_adder(a,b,cin,sum, cout);
input a,b,cin;
output sum, cout;
wire x,y,z;
half_adder  h1(.a(a), .b(b), .sum(x), .cout(y));
half_adder  h2(.a(x), .b(cin), .sum(sum), .cout(z));
assign cout= y|z;
endmodule
///////////////////////////////////////////
// 1 bit Half Adder
////////////////////////////////////////////
module half_adder( a,b, sum, cout );
input a,b;
output sum,  cout;
assign sum= a^b;
assign cout= a & b;
endmodule