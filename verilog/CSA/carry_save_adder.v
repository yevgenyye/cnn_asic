module carry_save_adder #(
	parameter N      =  3, // 3; // 4; // 5; // 6; // 7; // 9; // 25; // 3+ number of busses 
	parameter E      =  1, // 1; // 1; // 2; // 2; // 2; // 3; // 4;  // bit extention ( N=9 -> E=3, N=25 -> E=4)
    parameter W      =  4  //    input data width
)
//(a,b,c,d, sum,cout);
(a, sum, cout, cla_sum);
input  [N*W-1 :0] a; //, b,c,d;
output [W+E-1 :0] sum;
output cout;
output [W+E :0] cla_sum;

//// inputs 1-4
//wire [W-1:0] s0, s1;
//wire [W-1:0] c0, c1;
//
//
/////////
//wire [W:0] sum1, sum2, sum3;
//wire [W:0] ca1 , ca2 , ca3 ;
//
//
//wire [W+1:0] sum4, sum5;
//wire [W+1:0] ca4 , ca5 ;
//
////wire [W+2:0] sum6;
////wire [W+2:0] ca6 ;
//
//
//wire [W+5:0] sum7;
//wire [W+5:0] ca7 ;
//wire [W+5:0] sum_7test, c7test;
//
//wire [W+5:0] sum7test;
//wire [W+5:0] ca7test ;
//
//wire [W+4:0] test1, test2, test3, test4, test1_18;
//wire [W+3:0] sum1_9  , c1_9  ;
//wire [W+3:0] sum10_18, c10_18;
//wire [W+3:0] sum19_25, c19_25;
//
//
//wire [W:0] sum18_20, c18_20;
//wire [W:0] sum21_23, c21_23;
//wire [W+1:0] sum_3, c3;
//wire [W+3:0] sum_4, c4;
//wire [W+3:0] sum_4test, c4test;
///
//wire [W+E+1:0] cs_sum, cs_c ;
wire [W-1+E:0] cs_sum, cs_c ;

genvar i,j;

  generate
    if      (N == 49) 
      carry_save_49inputs #(W)   cs_49in(.a(a), .sum(cs_sum), .cout(cs_c)  );
    else if (N == 25) 
      carry_save_25inputs #(W)   cs_25in(.a(a), .sum(cs_sum), .cout(cs_c)  );
    else if (N == 9) 
       carry_save_9inputs #(W)   cs_9in (.a(a), .sum(cs_sum), .cout(cs_c)  );
    else if (N == 7) 
       carry_save_7inputs #(W)   cs_7in (.a(a), .sum(cs_sum), .cout(cs_c)  );
    else if (N == 6) 
       carry_save_6inputs #(W)   cs_6in (.a(a), .sum(cs_sum), .cout(cs_c)  );
    else if (N == 5) 
       carry_save_5inputs #(W)   cs_5in (.a(a), .sum(cs_sum), .cout(cs_c)  );
    else if (N == 4) 
       carry_save_4inputs #(W)   cs_4in (.a(a), .sum(cs_sum), .cout(cs_c)  );
    else if (N == 3) 
       carry_save_3inputs #(W)   cs_3in (.a(a), .sum(cs_sum), .cout(cs_c)  );
  endgenerate

  ripple_carry #(W+E) rca1 (.a(cs_sum),.b(cs_c), .cin(1'b0),.sum(sum), .cout(cout));

  carry_lookahead_adder #(W+E) CLA ( .i_add1(cs_sum), .i_add2(cs_c), .o_result(cla_sum) );


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

//carry_save_9inputs #(W)  cs_9in1 (.a(             a[ 0*W +: 9*W ] ), .sum(sum1_9),   .cout(c1_9  )  );
//carry_save_9inputs #(W)  cs_9in2 (.a(             a[ 9*W +: 9*W ] ), .sum(sum10_18), .cout(c10_18)  );
//
//carry_save_9inputs #(W)  cs_9in3 (.a({{(N*2){1'b0}},a[18*W +: 7*W ]}), .sum(sum19_25), .cout(c19_25)  );
//
//assign test1    = sum1_9 + sum10_18 + c1_9 + c10_18 + sum19_25 + c19_25;
//assign test1_18 = sum1_9 + sum10_18 + c1_9 + c10_18;
////////////////////////////////////////
////1
////carry_save_3inputs #(W) cs_3in1 (.a(a[18*W +: 3*W ]), .sum(sum18_20), .cout(c18_20) );
////carry_save_3inputs #(W) cs_3in2 (.a(a[21*W +: 3*W ]), .sum(sum21_23), .cout(c21_23) );
////  assign test2 = test1_18 + a[18*W +: W ] + a[19*W +: W ] + a[20*W +: W ] + a[21*W +: W ]+ a[22*W +: W ] + a[23*W +: W ];
//////assign test2 = test1_18 + sum18_20 + sum21_23 + c18_20 + c21_23 + a[24*W +: W ] ;
////
////////2 - CS_5
//////carry_save_3inputs #(W+1) cs_3in3 (.a({ sum18_20,sum21_23,c18_20 }), .sum(sum_3), .cout(c3) );
////////assign test3 = test1_18 + sum_3 + c3 + c21_23 + a[24*W +: W ];
////////3
//////carry_save_4inputs #(W+2) cs_4in (.a({2'b00, {a[24*W +: W ] } ,sum_3 ,c3,{1'b0,c21_23} }), .sum(sum_4), .cout(c4)  );
//////assign test3 = test1_18 + sum7test + ca7test ;
////////////////////////////////////////
////carry_save_5inputs #(W+1) cs_5in (.a({sum18_20,sum21_23,c18_20,c21_23,{1'b0,a[24*W +: W ]} }), .sum(sum_4), .cout(c4)  );
//
//carry_save_7inputs #(W)   cs_7in (.a(a[18*W +: 7*W ]), .sum(sum_4), .cout(c4)  );
//
//carry_save_6inputs #(W+4) cs_6in (.a({sum1_9,sum10_18,sum_4, c1_9 ,c10_18 ,c4 }), .sum(sum7), .cout(ca7)  );

//carry_save_25inputs #(W)   cs_25in (.a(a), .sum(sum7), .cout(ca7)  );

// prev version
//carry_save_6inputs #(W+4) cs_6in (.a({sum1_9,sum10_18,sum19_25, c1_9 ,c10_18 ,c19_25 }), .sum(sum7), .cout(ca7)  );

//assign test4 = sum7 + ca7;



//ripple_carry #(W+E) rca1 (.a(sum7),.b(ca7), .cin(1'b0),.sum(sum), .cout(cout));


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
// Carry Save 5 inputs (three stages)
////////////////////////////////////

module carry_save_5inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [5*W-1:0] a; //, b,c,d;
output [W+2  :0] sum;
output [W+2  :0] cout;

wire [W:0] sum13 ;
wire [W:0] c13   ;

wire [W+2:0] test5_1, test5_2 ;

assign test5_1 = {c13,sum13} + a[3*W +: W] + a[4*W +: W];
assign test5_2 = {cout,sum};

carry_save_3inputs #(W) cs_3in (.a(a[  0 +: 3*W]), .sum(sum13), .cout(c13) );
carry_save_4inputs #(W+1) cs_4in (.a({ { 1'b0, a[4*W +: W] }, { 1'b0, a[3*W +: W] } ,sum13 , c13 }), .sum(sum), .cout(cout)  );

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
// Carry Save 7 inputs (four stages)
////////////////////////////////////

module carry_save_7inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [7*W-1:0] a; //, b,c,d;
output [W+3  :0] sum;
output [W+3  :0] cout;

wire [W:0] sum13, sum46;
wire [W:0] c13  , c46  ;

carry_save_3inputs #(W) cs_3in1 (.a(a[0*W +: 3*W ]), .sum(sum13), .cout(c13) );
carry_save_3inputs #(W) cs_3in2 (.a(a[3*W +: 3*W ]), .sum(sum46), .cout(c46) );

carry_save_5inputs #(W+1) cs_5in (.a({sum13, sum46, c13, c46, { 1'b0, a[6*W +: W ]}  }), .sum(sum), .cout(cout)  );

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
// Carry Save 25 inputs (seven stages)
////////////////////////////////////

module carry_save_25inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [25*W-1:0] a; //, b,c,d;
output [W+5  :0] sum;
output [W+5  :0] cout;

wire [W+3:0] sum1_9, sum10_18, sum19_25;
wire [W+3:0] c1_9  , c10_18  , c19_25  ;

carry_save_9inputs #(W)  cs_9in1 (.a( a[ 0*W +: 9*W ] ), .sum(sum1_9)  , .cout(c1_9)   );
carry_save_9inputs #(W)  cs_9in2 (.a( a[ 9*W +: 9*W ] ), .sum(sum10_18), .cout(c10_18) );
carry_save_7inputs #(W)  cs_7in  (.a( a[18*W +: 7*W ] ), .sum(sum19_25), .cout(c19_25) );

carry_save_6inputs #(W+4) cs_6in (.a({sum1_9, sum10_18, sum19_25, c1_9  , c10_18  , c19_25 }), .sum(sum), .cout(cout)  );

endmodule

////////////////////////////////////
// Carry Save 49 inputs (seven stages)
////////////////////////////////////

module carry_save_49inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [49*W-1:0] a; //, b,c,d;
output [W+6  :0] sum;
output [W+6  :0] cout;

wire [W+5:0] sum1_25, sum26_49;
wire [W+5:0] c1_25  , c26_49  ;
//wire [W-1 :0] zeros;
//
//assign zeros = {(N){1'b0}};

carry_save_25inputs #(W)  cs_25in1 (.a(                a[  0*W +: 25*W ]   ), .sum(sum1_25)  , .cout(c1_25 ) );
carry_save_25inputs #(W)  cs_25in2 (.a( { {(W){1'b0}}, a[ 25*W +: 24*W ] } ), .sum(sum26_49) , .cout(c26_49) );

carry_save_4inputs #(W+3) cs_4in (.a({sum1_25 ,sum26_49 ,c1_25,c26_49 }), .sum(sum), .cout(cout)  );

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