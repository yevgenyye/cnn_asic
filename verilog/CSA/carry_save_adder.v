module carry_save_adder #(
	parameter N      =  9, // 2; // 3; // 4; // 5; // 6; // 7; // 8; // 9; // 10; // 16; // 25; // 49; // 3+ number of busses 
	parameter E      =  3, // 0; // 1; // 2; // 2; // 2; // 2; // 3; // 3; //  3; // 4;  // 5;  // 6 ; // bit extention ( N=9 -> E=3, N=25 -> E=4)
  parameter W      =  4  //    input data width
)
//(a,b,c,d, sum,cout);
(a, sum, cout);
input  [N*W-1 :0] a; //, b,c,d;
output [W+E-1 :0] sum;
output cout;

wire [W+E :0] cla_sum;

localparam use_cla = 1; // 0 - use RCA

wire [W-1+E:0] cs_sum, cs_c ;

genvar i,j;

// initial begin
//    $display(" carry_save_adder output sum | width= %d ",W+E  );
// end

  generate
    if      (N == 49) begin : gen_N_49
      carry_save_49inputs #(W)   cs_49in(.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 32) begin : gen_N_32
      carry_save_32inputs #(W)   cs_32in(.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 25) begin : gen_N_25
      carry_save_25inputs #(W)   cs_25in(.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 16) begin : gen_N_16
       carry_save_16inputs #(W)  cs_16in(.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 10) begin : gen_N_10
       carry_save_10inputs #(W)  cs_10in(.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 9) begin : gen_N_9
       carry_save_9inputs #(W)   cs_9in (.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 8) begin : gen_N_8
       carry_save_8inputs #(W)   cs_8in (.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 7) begin : gen_N_7
       carry_save_7inputs #(W)   cs_7in (.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 6) begin : gen_N_6
       carry_save_6inputs #(W)   cs_6in (.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 5) begin : gen_N_5
       carry_save_5inputs #(W)   cs_5in (.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 4) begin : gen_N_4
       carry_save_4inputs #(W)   cs_4in (.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 3) begin : gen_N_3
       carry_save_3inputs #(W)   cs_3in (.a(a), .sum(cs_sum), .cout(cs_c)  ); end
    else if (N == 2) begin : gen_N_2
       assign cs_sum = a[0 +: W];
       assign cs_c   = a[W +: W];
     end

    //if (N == 1) begin : gen_N_1
    //      assign sum   = a[W-1 :0];
    //      assign cout  = 1'b0;
    //   end
    //else // if (N != 1)
    //  begin
          carry_lookahead_adder #(W+E) CLA ( .i_add1(cs_sum), .i_add2(cs_c), .o_result(cla_sum) );
          assign sum   = cla_sum[W+E-1 :0];
          assign cout  = cla_sum[W+E];
    //   end

  endgenerate

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
   for (i=0; i<=W-1; i=i+1) begin :gen_3
      full_adder fa1 ( .a(a[0*W+i]), .b(a[1*W+i]),  .cin(a[2*W+i]), .sum(sum[i]), .cout(cout[i+1])  );
   end 
endgenerate

assign cout[0] = 1'b0;
assign sum [W] = 1'b0;

// initial begin
//    $display( " CS 3ins | Win = %d , Wout = %d", W, W+1 );
// end

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

// initial begin
//    $display( " CS 4ins | Win = %d , Wout = %d", W, W+2 );
// end
endmodule

////////////////////////////////////
// Carry Save 5 inputs (three stages)
////////////////////////////////////

module carry_save_5inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [5*W-1:0] a; //, b,c,d;
output [W+1  :0] sum;
output [W+1  :0] cout;

wire [W:0] sum13 ;
wire [W:0] c13   ;

wire [W+2  :0] sum4;
wire [W+2  :0] cout4;

//wire [W+2:0] test5_0, test5_1, test5_2, test5_3 ;
//assign test5_0 = a[0*W +: W] + a[1*W +: W] + a[2*W +: W] + a[3*W +: W] + a[4*W +: W];
//assign test5_1 = c13 + sum13 + a[3*W +: W] + a[4*W +: W];
//assign test5_2 = cout4 + sum4;
//assign test5_3 = cout + sum;

carry_save_3inputs #(W) cs_3in (.a(a[  0 +: 3*W]), .sum(sum13), .cout(c13) );
carry_save_4inputs #(W+1) cs_4in (.a({ { 1'b0, a[4*W +: W] }, { 1'b0, a[3*W +: W] } ,sum13 , c13 }), .sum(sum4), .cout(cout4)  );
assign cout = cout4[W+1  :0];
assign sum  = sum4 [W+1  :0];

endmodule

////////////////////////////////////
// Carry Save 6 inputs (three stages)
////////////////////////////////////

module carry_save_6inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [6*W-1:0] a; //, b,c,d;
 output [W+1  :0] sum;  
 output [W+1  :0] cout; 

 wire [W:0] sum13, sum46;
 wire [W:0] c13  , c46 ;

 wire [W+2  :0] sum1, cout1 ;

 carry_save_3inputs #(W) cs_3in_11 (.a(a[  0 +: 3*W]), .sum(sum13), .cout(c13)  );
 carry_save_3inputs #(W) cs_3in_12 (.a(a[3*W +: 3*W]), .sum(sum46), .cout(c46)  );

 carry_save_4inputs #(W+1) cs_4in (.a({sum13 ,c13 ,sum46,c46 }), .sum(sum1), .cout(cout1)  );
 assign sum  = sum1 [W+1  :0];
 assign cout = cout1[W+1  :0];

// initial begin
//    $display(" CS 6ins | Win = %d , Wout = %d", W, W+2 );
// end
endmodule

////////////////////////////////////
// Carry Save 7 inputs (four stages)
////////////////////////////////////

module carry_save_7inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [7*W-1:0] a; //, b,c,d;
output [W+1  :0] sum;
output [W+1  :0] cout;

wire [W:0] sum13, sum46;
wire [W:0] c13  , c46  ;
wire [W+2  :0] sum5;
wire [W+2  :0] cout5;

//wire [W+4:0] test7_0, test7_1, test7_2, test7_3 ;
//assign test7_0 = a[0*W +: W] + a[1*W +: W] + a[2*W +: W] + a[3*W +: W] + a[4*W +: W] + a[5*W +: W] + a[6*W +: W];
//assign test7_1 = c13 + sum13 + sum46 + c46 + a[6*W +: W];
//assign test7_2 = cout5 + sum5;
//assign test7_3 = cout  + sum;

carry_save_3inputs #(W) cs_3in1 (.a(a[0*W +: 3*W ]), .sum(sum13), .cout(c13) );
carry_save_3inputs #(W) cs_3in2 (.a(a[3*W +: 3*W ]), .sum(sum46), .cout(c46) );

carry_save_5inputs #(W+1) cs_5in (.a({sum13, sum46, c13, c46, { 1'b0, a[6*W +: W ]}  }), .sum(sum5), .cout(cout5)  );
assign cout = cout5[W+1  :0];
assign sum  = sum5 [W+1  :0];


endmodule


////////////////////////////////////
// Carry Save 8 inputs (four stages)
////////////////////////////////////

module carry_save_8inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [8*W-1:0] a; //, b,c,d;
output [W+2  :0] sum;
output [W+2  :0] cout;

wire [W:0] sum13, sum46;
wire [W:0] c13  , c46  ;

//wire [W+2:0] test8_0, test8_1, test8_2 ;
//assign test8_0 = a[0*W +: W] + a[1*W +: W] + a[2*W +: W] + a[3*W +: W] + a[4*W +: W] + a[5*W +: W] + a[6*W +: W] + a[7*W +: W];
//assign test8_1 = c13 + sum13 + sum46 + c46 + a[6*W +: W] + a[7*W +: W];
//assign test8_2 = cout + sum;

carry_save_3inputs #(W) cs_3in1 (.a(a[0*W +: 3*W ]), .sum(sum13), .cout(c13) );
carry_save_3inputs #(W) cs_3in2 (.a(a[3*W +: 3*W ]), .sum(sum46), .cout(c46) );

carry_save_6inputs #(W+1) cs_6in (.a({sum13, sum46, c13, c46, { 1'b0, a[6*W +: W ]} , { 1'b0, a[7*W +: W ]} }), .sum(sum), .cout(cout)  );

endmodule

////////////////////////////////////
// Carry Save 9 inputs (four stages)
////////////////////////////////////

module carry_save_9inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [9*W-1:0] a; //, b,c,d;
 output [W+2  :0] sum;   
 output [W+2  :0] cout;  
 
 wire [W:0] sum13, sum46, sum79;
 wire [W:0] c13  , c46  , c79  ;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[0*W +: 3*W ]), .sum(sum13), .cout(c13)  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[3*W +: 3*W ]), .sum(sum46), .cout(c46)  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[6*W +: 3*W ]), .sum(sum79), .cout(c79)  );

 carry_save_6inputs #(W+1) cs_6in (.a({sum13,sum46,sum79, c13 ,c46 ,c79 }), .sum(sum), .cout(cout)  );

// initial begin
//    $display(" CS 9ins | Win = %d , Wout = %d", W, W+3 );
// end

endmodule


////////////////////////////////////
// Carry Save 10 inputs (four stages)
////////////////////////////////////

module carry_save_10inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [10*W-1:0] a; //, b,c,d;
 output [W+2  :0] sum;   
 output [W+2  :0] cout;  
 
 wire [W:0]   sum1_3, sum4_6, sum7_9;
 wire [W:0]   c1_3  , c4_6  , c7_9  ;
 wire [W+1:0] sum_1 , c_1   , sum_2  , c_2;
 wire [W+3:0] sum5  , cout5;

wire [W+5:0] test10_0, test10_1, test10_2, test10_3 ;
assign test10_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W];
assign test10_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + a[9*W +: W ] ;
assign test10_2 = sum_1 + c_1 + sum_2 + c_2 + a[9*W +: W ] ;
assign test10_3 = cout + sum;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[ 0*W +: 3*W ]), .sum(sum1_3  ), .cout(c1_3  )  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[ 3*W +: 3*W ]), .sum(sum4_6  ), .cout(c4_6  )  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[ 6*W +: 3*W ]), .sum(sum7_9  ), .cout(c7_9  )  );  // a(10) do not added

 carry_save_3inputs #(W+1) cs_3in_4(.a({ sum1_3, sum4_6, sum7_9 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_5(.a({ c1_3, c4_6, c7_9 }),       .sum(sum_2), .cout(c_2) );

 carry_save_5inputs #(W+2) cs_5in (.a({sum_1, sum_2, c_1, c_2 , { 2'b00, a[ 9*W +: W ]}  }), .sum(sum5), .cout(cout5)  );
assign cout = cout5[W+2  :0];
assign sum  = sum5 [W+2  :0];
// initial begin
//    $display(" CS 9ins | Win = %d , Wout = %d", W, W+3 );
// end

endmodule

////////////////////////////////////
// Carry Save 16 inputs (four stages)
////////////////////////////////////

module carry_save_16inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [16*W-1:0] a; //, b,c,d;
 output [W+3  :0] sum;   
 output [W+3  :0] cout;  
 
 wire [W:0] sum1_3, sum4_6, sum7_9, sum10_12, c10_12;
 wire [W:0] c1_3  , c4_6  , c7_9  , sum13_15, c13_15;

 wire [W+1:0] sum_1, c_1, sum_2, c_2, sum_3, c_3;
 wire [W+4:0] sum8, cout8;

//wire [W+5:0] test9_0, test9_1, test9_2, test9_3 ;
//
//assign test9_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W] + 
//                 a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + a[15*W +: W];
//assign test9_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9   + sum10_12 + c10_12 + sum13_15 + c13_15 + a[15*W +: W ] ;
//assign test9_2 = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + c13_15 +a[15*W +: W ];
//assign test9_3 = cout + sum;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[ 0*W +: 3*W ]), .sum(sum1_3  ), .cout(c1_3  )  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[ 3*W +: 3*W ]), .sum(sum4_6  ), .cout(c4_6  )  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[ 6*W +: 3*W ]), .sum(sum7_9  ), .cout(c7_9  )  );
 carry_save_3inputs #(W) cs_3in_4 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );
 carry_save_3inputs #(W) cs_3in_5 (.a(a[12*W +: 3*W ]), .sum(sum13_15), .cout(c13_15)  );

 carry_save_3inputs #(W+1) cs_3in_11(.a({ sum1_3  , c1_3  , sum4_6  }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_12(.a({ c4_6    , sum7_9, c7_9    }), .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+1) cs_3in_13(.a({ sum10_12, c10_12, sum13_15}), .sum(sum_3), .cout(c_3) );

 carry_save_8inputs #(W+2) cs_8in (.a({  sum_1, c_1, sum_2, c_2, sum_3, c_3,{1'b0, c13_15} , {2'b00, a[15*W +: W ]} }), .sum(sum8), .cout(cout8)  );
assign cout = cout8[W+3  :0];
assign sum  = sum8 [W+3  :0];

endmodule

////////////////////////////////////
// Carry Save 25 inputs (seven stages)
////////////////////////////////////

module carry_save_25inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [25*W-1:0] a; //, b,c,d;
output [W+4  :0] sum;
output [W+4  :0] cout;

wire [W+1:0] sum19_25;
wire [W+1:0] c19_25  ;
wire [W+2:0] sum1_9, sum10_18;
wire [W+2:0] c1_9  , c10_18  ;

//wire [W+5:0] test6_0, test6_1, test6_2 ;
//assign test6_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W] + 
//                 a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + a[15*W +: W] + a[16*W +: W] + a[17*W +: W]+ a[18*W +: W] + a[19*W +: W] + 
//                 a[20*W +: W] + a[21*W +: W] + a[22*W +: W] + a[23*W +: W] + a[24*W +: W];
//assign test6_1 = sum1_9 + sum10_18 + sum19_25 + c1_9 + c10_18 + c19_25;
//assign test6_2 = cout + sum;

carry_save_9inputs #(W)  cs_9in1 (.a( a[ 0*W +: 9*W ] ), .sum(sum1_9)  , .cout(c1_9)   );
carry_save_9inputs #(W)  cs_9in2 (.a( a[ 9*W +: 9*W ] ), .sum(sum10_18), .cout(c10_18) );
carry_save_7inputs #(W)  cs_7in  (.a( a[18*W +: 7*W ] ), .sum(sum19_25), .cout(c19_25) );

carry_save_6inputs #(W+3) cs_6in (.a({sum1_9, sum10_18, { 1'b0, sum19_25}, c1_9  , c10_18  , { 1'b0, c19_25} }), .sum(sum), .cout(cout)  );

endmodule


////////////////////////////////////
// Carry Save 32 inputs (seven stages)
////////////////////////////////////

module carry_save_32inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [32*W-1:0] a; //, b,c,d;
output [W+3  :0] sum;
output [W+3  :0] cout;

wire [W:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W:0] sum25_27, c25_27, sum28_30, c28_30;
wire [W+1:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5,  sum_6,  c_6,  sum_7,  c_7;
wire [W+2:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15;
wire [W+3:0] sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+4:0] sum_31, c_31, sum_32, c_32, sum_33, c_33; 
wire [W+5:0] sum10, cout10;

//wire [W+7:0]  test_in, test_1_stage, test_2_stage, test_3_stage, test_4_stage, test_5_stage, test_6_stage, test_7_preout, test_8_out;
//assign test_in = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + 
//                 a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W] + a[ 8*W +: W] + a[ 9*W +: W] + 
//                 a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + 
//                 a[15*W +: W] + a[16*W +: W] + a[17*W +: W] + a[18*W +: W] + a[19*W +: W] + 
//                 a[20*W +: W] + a[21*W +: W] + a[22*W +: W] + a[23*W +: W] + a[24*W +: W] +
//                 a[25*W +: W] + a[26*W +: W] + a[27*W +: W] + a[28*W +: W] + a[29*W +: W] + 
//                 a[30*W +: W] + a[31*W +: W];
//assign test_1_stage = sum01_03 + c01_03 + sum04_06 + c04_06 + sum07_09 + c07_09 + sum10_12 + c10_12 + sum13_15 + c13_15 + sum16_18 + c16_18 + sum19_21 + c19_21 + sum22_24 + c22_24 +
//                      sum25_27 + c25_27 + sum28_30 + c28_30 + a[30*W +: W ] + a[31*W +: W ];
//assign test_2_stage = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + sum_4 + c_4 + sum_5 + c_5 + sum_6 + c_6 + sum_7 + c_7 + a[31*W +: W ];
//assign test_3_stage = sum_11+ c_11+ sum_12+ c_12+ sum_13+ c_13+ sum_14+ c_14+ sum_15+ c_15;
//assign test_7_preout = sum10 + cout10;
//assign test_8_out    = sum + cout;

 carry_save_3inputs #(W) cs_3in_01 (.a(a[ 0*W +: 3*W ]), .sum(sum01_03), .cout(c01_03)  );
 carry_save_3inputs #(W) cs_3in_02 (.a(a[ 3*W +: 3*W ]), .sum(sum04_06), .cout(c04_06)  );
 carry_save_3inputs #(W) cs_3in_03 (.a(a[ 6*W +: 3*W ]), .sum(sum07_09), .cout(c07_09)  );
 carry_save_3inputs #(W) cs_3in_04 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );
 carry_save_3inputs #(W) cs_3in_05 (.a(a[12*W +: 3*W ]), .sum(sum13_15), .cout(c13_15)  );
 carry_save_3inputs #(W) cs_3in_06 (.a(a[15*W +: 3*W ]), .sum(sum16_18), .cout(c16_18)  );
 carry_save_3inputs #(W) cs_3in_07 (.a(a[18*W +: 3*W ]), .sum(sum19_21), .cout(c19_21)  );
 carry_save_3inputs #(W) cs_3in_08 (.a(a[21*W +: 3*W ]), .sum(sum22_24), .cout(c22_24)  );
 carry_save_3inputs #(W) cs_3in_09 (.a(a[24*W +: 3*W ]), .sum(sum25_27), .cout(c25_27)  );
 carry_save_3inputs #(W) cs_3in_10 (.a(a[27*W +: 3*W ]), .sum(sum28_30), .cout(c28_30)  );// a(30,31) do not added

 carry_save_3inputs #(W+1) cs_3in_20(.a({ sum01_03, sum04_06, sum07_09 }),              .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_21(.a({ sum10_12, sum13_15, sum16_18 }),              .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+1) cs_3in_22(.a({ sum19_21, sum22_24, sum25_27 }),              .sum(sum_3), .cout(c_3) );
 carry_save_3inputs #(W+1) cs_3in_23(.a({ sum28_30, c28_30, {1'b0, a[30*W +: W ]}   }), .sum(sum_4), .cout(c_4) );
 carry_save_3inputs #(W+1) cs_3in_25(.a({ c01_03, c04_06, c07_09 }),                    .sum(sum_5), .cout(c_5) );
 carry_save_3inputs #(W+1) cs_3in_26(.a({ c10_12, c13_15, c16_18 }),                    .sum(sum_6), .cout(c_6) );
 carry_save_3inputs #(W+1) cs_3in_27(.a({ c19_21, c22_24, c25_27 }),                    .sum(sum_7), .cout(c_7) );// a(31) do not added (+2)

 carry_save_3inputs #(W+2) cs_3in_30(.a({ sum_1, sum_2, sum_3 }),                .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+2) cs_3in_31(.a({ sum_4, sum_5, sum_6 }),                .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+2) cs_3in_32(.a({ sum_7, c_7, {2'b00, a[31*W +: W ]} }), .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+2) cs_3in_33(.a({ c_1, c_2, c_3}),                       .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+2) cs_3in_34(.a({ c_4, c_5, c_6}),                       .sum(sum_15), .cout(c_15) ); 

 carry_save_10inputs #(W+3) cs_10in (.a({sum_11, sum_12, sum_13, sum_14, sum_15, c_11, c_12, c_13, c_14, c_15}), .sum(sum10), .cout(cout10)  );

assign cout = cout10[W+4  :0];
assign sum  = sum10 [W+4  :0];
endmodule

////////////////////////////////////
// Carry Save 49 inputs (seven stages)
////////////////////////////////////

module carry_save_49inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [49*W-1:0] a; //, b,c,d;
output [W+5  :0] sum;
output [W+5  :0] cout;

wire [W:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W:0] sum25_27, c25_27, sum28_30, c28_30, sum31_33, c31_33, sum34_36, c34_36, sum37_39, c37_39, sum40_42, c40_42, sum43_45, c43_45, sum46_48, c46_48;
wire [W+1:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5,  sum_6,  c_6,  sum_7,  c_7, sum_8, c_8, sum_9, c_9, sum_A, c_A, sum_B, c_B;
wire [W+2:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16, sum_17, c_17;
wire [W+3:0] sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24, sum_25, c_25;
wire [W+4:0] sum_31, c_31, sum_32, c_32, sum_33, c_33; 
wire [W+5:0] sum_41, c_41, sum_42, c_42;
wire [W+7:0] sum5, cout5;

//wire [W+7:0]  test_in, test_1_stage, test_2_stage, test_3_stage, test_4_stage, test_5_stage, test_6_stage, test_7_preout, test_8_out;
//assign test_in = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + 
//                 a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W] + a[ 8*W +: W] + a[ 9*W +: W] + 
//                 a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + 
//                 a[15*W +: W] + a[16*W +: W] + a[17*W +: W] + a[18*W +: W] + a[19*W +: W] + 
//                 a[20*W +: W] + a[21*W +: W] + a[22*W +: W] + a[23*W +: W] + a[24*W +: W] +
//                 a[25*W +: W] + a[26*W +: W] + a[27*W +: W] + a[28*W +: W] + a[29*W +: W] + 
//                 a[30*W +: W] + a[31*W +: W] + a[32*W +: W] + a[33*W +: W] + a[34*W +: W] + 
//                 a[35*W +: W] + a[36*W +: W] + a[37*W +: W] + a[38*W +: W] + a[39*W +: W] + 
//                 a[40*W +: W] + a[41*W +: W] + a[42*W +: W] + a[43*W +: W] + a[44*W +: W] + 
//                 a[45*W +: W] + a[46*W +: W] + a[47*W +: W] + a[48*W +: W];
//assign test_1_stage = sum01_03 + c01_03 + sum04_06 + c04_06 + sum07_09 + c07_09 + sum10_12 + c10_12 + sum13_15 + c13_15 + sum16_18 + c16_18 + sum19_21 + c19_21 + sum22_24 + c22_24 + a[48*W +: W ] +
//                      sum25_27 + c25_27 + sum28_30 + c28_30 + sum31_33 + c31_33 + sum34_36 + c34_36 + sum37_39 + c37_39 + sum40_42 + c40_42 + sum43_45 + c43_45 + sum46_48 + c46_48;
//assign test_2_stage = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + sum_4 + c_4 + sum_5 + c_5 + sum_6 + c_6 + sum_7 + c_7 + sum_8 + c_8 + sum_9 + c_9 + sum_A + c_A + sum_B + c_B;
//assign test_3_stage = sum_11+ c_11+ sum_12+ c_12+ sum_13+ c_13+ sum_14+ c_14+ sum_15+ c_15+ sum_16+ c_16+ sum_17+ c_17 + c_B;
//assign test_4_stage = sum_21 + c_21 + sum_22 + c_22 + sum_23 + c_23 + sum_24 + c_24 + sum_25 + c_25;
//assign test_5_stage = sum_31 + c_31 + sum_32 + c_32 + sum_33 + c_33 + c_25;
//assign test_6_stage = sum_41 + c_41 + sum_42 + c_42 + c_25;
//assign test_7_preout = sum5 + cout5;
//assign test_8_out    = sum + cout;

 carry_save_3inputs #(W) cs_3in_01 (.a(a[ 0*W +: 3*W ]), .sum(sum01_03), .cout(c01_03)  );
 carry_save_3inputs #(W) cs_3in_02 (.a(a[ 3*W +: 3*W ]), .sum(sum04_06), .cout(c04_06)  );
 carry_save_3inputs #(W) cs_3in_03 (.a(a[ 6*W +: 3*W ]), .sum(sum07_09), .cout(c07_09)  );
 carry_save_3inputs #(W) cs_3in_04 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );
 carry_save_3inputs #(W) cs_3in_05 (.a(a[12*W +: 3*W ]), .sum(sum13_15), .cout(c13_15)  );
 carry_save_3inputs #(W) cs_3in_06 (.a(a[15*W +: 3*W ]), .sum(sum16_18), .cout(c16_18)  );
 carry_save_3inputs #(W) cs_3in_07 (.a(a[18*W +: 3*W ]), .sum(sum19_21), .cout(c19_21)  );
 carry_save_3inputs #(W) cs_3in_08 (.a(a[21*W +: 3*W ]), .sum(sum22_24), .cout(c22_24)  );
 carry_save_3inputs #(W) cs_3in_09 (.a(a[24*W +: 3*W ]), .sum(sum25_27), .cout(c25_27)  );
 carry_save_3inputs #(W) cs_3in_10 (.a(a[27*W +: 3*W ]), .sum(sum28_30), .cout(c28_30)  );
 carry_save_3inputs #(W) cs_3in_11 (.a(a[30*W +: 3*W ]), .sum(sum31_33), .cout(c31_33)  );
 carry_save_3inputs #(W) cs_3in_12 (.a(a[33*W +: 3*W ]), .sum(sum34_36), .cout(c34_36)  );
 carry_save_3inputs #(W) cs_3in_13 (.a(a[36*W +: 3*W ]), .sum(sum37_39), .cout(c37_39)  );
 carry_save_3inputs #(W) cs_3in_14 (.a(a[39*W +: 3*W ]), .sum(sum40_42), .cout(c40_42)  );
 carry_save_3inputs #(W) cs_3in_15 (.a(a[42*W +: 3*W ]), .sum(sum43_45), .cout(c43_45)  );
 carry_save_3inputs #(W) cs_3in_16 (.a(a[45*W +: 3*W ]), .sum(sum46_48), .cout(c46_48)  ); // a(48) do not added
 

 carry_save_3inputs #(W+1) cs_3in_20(.a({ sum01_03, sum04_06, sum07_09 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_21(.a({ sum10_12, sum13_15, sum16_18 }), .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+1) cs_3in_22(.a({ sum19_21, sum22_24, sum25_27 }), .sum(sum_3), .cout(c_3) );
 carry_save_3inputs #(W+1) cs_3in_23(.a({ sum28_30, sum31_33, sum34_36 }), .sum(sum_4), .cout(c_4) );
 carry_save_3inputs #(W+1) cs_3in_24(.a({ sum37_39, sum40_42, sum43_45 }), .sum(sum_5), .cout(c_5) );
 carry_save_3inputs #(W+1) cs_3in_25(.a({ c01_03, c04_06, c07_09 }),       .sum(sum_6), .cout(c_6) );
 carry_save_3inputs #(W+1) cs_3in_26(.a({ c10_12, c13_15, c16_18 }),       .sum(sum_7), .cout(c_7) );
 carry_save_3inputs #(W+1) cs_3in_27(.a({ c19_21, c22_24, c25_27 }),       .sum(sum_8), .cout(c_8) );
 carry_save_3inputs #(W+1) cs_3in_28(.a({ c28_30, c31_33, c34_36 }),       .sum(sum_9), .cout(c_9) );
 carry_save_3inputs #(W+1) cs_3in_29(.a({ c37_39, c40_42, c43_45 }),       .sum(sum_A), .cout(c_A) );
 carry_save_3inputs #(W+1) cs_3in_2A(.a({ sum46_48, c46_48, {1'b0, a[48*W +: W ]}  }), .sum(sum_B), .cout(c_B) );

 carry_save_3inputs #(W+2) cs_3in_30(.a({ sum_1, sum_2, sum_3 }), .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+2) cs_3in_31(.a({ sum_4, sum_5, sum_6 }), .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+2) cs_3in_32(.a({ sum_7, sum_8, sum_9 }), .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+2) cs_3in_33(.a({ c_1, c_2, c_3}),        .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+2) cs_3in_34(.a({ c_4, c_5, c_6}),        .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+2) cs_3in_35(.a({ c_7, c_8, c_9}),        .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+2) cs_3in_36(.a({ sum_A, c_A, sum_B }),   .sum(sum_17), .cout(c_17) );    // c_B do not added

 carry_save_3inputs #(W+3) cs_3in_40(.a({ sum_11, sum_12, sum_13 }),    .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+3) cs_3in_41(.a({ sum_14, sum_15, sum_16 }),    .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+3) cs_3in_43(.a({ c_11, c_12, c_13}),           .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+3) cs_3in_44(.a({ c_14, c_15, c_16}),           .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+3) cs_3in_45(.a({ sum_17, c_17, {1'b0, c_B} }), .sum(sum_25), .cout(c_25) );

 carry_save_3inputs #(W+4) cs_3in_50(.a({ sum_21, sum_22, sum_23 }), .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+4) cs_3in_51(.a({ sum_24, sum_25, c_21 }),   .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+4) cs_3in_53(.a({ c_22, c_23, c_24}),        .sum(sum_33), .cout(c_33) ); // c_25 do not added

 carry_save_3inputs #(W+5) cs_3in_60(.a({ sum_31, sum_32, sum_33 }), .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+5) cs_3in_61(.a({ c_31, c_32, c_33 }),       .sum(sum_42), .cout(c_42) );

carry_save_5inputs #(W+6) cs_5in (.a({sum_41, sum_42, c_41, c_42, { 2'b00, c_25}  }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+5  :0];
assign sum  = sum5 [W+5  :0];

///wire [W+3:0] sum1_25, sum26_49;
///wire [W+3:0] c1_25  , c26_49  ;
///wire [W+7:0] test1_25_in, test26_49_in, test1_25_out, test26_49_out, test_out, test_in;

///carry_save_25inputs #(W)  cs_25in1 (.a(                a[  0*W +: 25*W ]   ), .sum(sum1_25)  , .cout(c1_25 ) );
///carry_save_25inputs #(W)  cs_25in2 (.a( { {(W){1'b0}}, a[ 25*W +: 24*W ] } ), .sum(sum26_49) , .cout(c26_49) );
///carry_save_4inputs #(W+4) cs_4in (.a({sum1_25 ,sum26_49 ,c1_25,c26_49 }), .sum(sum), .cout(cout)  );

//assign test1_25_in = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + 
//                     a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W] + a[ 8*W +: W] + a[ 9*W +: W] + 
//                     a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + 
//                     a[15*W +: W] + a[16*W +: W] + a[17*W +: W] + a[18*W +: W] + a[19*W +: W] + 
//                     a[20*W +: W] + a[21*W +: W] + a[22*W +: W] + a[23*W +: W] + a[24*W +: W];
// 
//assign test26_49_in = a[25*W +: W] + a[26*W +: W] + a[27*W +: W] + a[28*W +: W] + a[29*W +: W] + 
//                      a[30*W +: W] + a[31*W +: W] + a[32*W +: W] + a[33*W +: W] + a[34*W +: W] + 
//                      a[35*W +: W] + a[36*W +: W] + a[37*W +: W] + a[38*W +: W] + a[39*W +: W] + 
//                      a[40*W +: W] + a[41*W +: W] + a[42*W +: W] + a[43*W +: W] + a[44*W +: W] + 
//                      a[45*W +: W] + a[46*W +: W] + a[47*W +: W] + a[48*W +: W];
//
//assign test1_25_out  = sum1_25  + c1_25;
//assign test26_49_out = sum26_49 + c26_49;
//assign test_in       = test1_25_out + test26_49_out;
//assign test_out      = sum + cout;

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
   for (i=0; i<=W-1; i=i+1) begin  :gen_rca
      full_adder fa1 ( .a(a[i]), .b(b[i]),  .cin(c1[i]), .sum(sum[i]), .cout(c1[i+1])  );
   end 
endgenerate
assign c1[0] = cin;
assign cout  = c1[W];

endmodule

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
