module carry_save_adder #(
	parameter N      =  256, // 2; // 3; // 4; // 5; // 6; // 7; // 8; // 9 ... 15; // 16; // 25; // 49; //64; //128; //256;  3+ number of busses 
	parameter E      =    8, // 0; // 1; // 2; // 2; // 2; // 2; // 3; // 3 ...  3; // 4;  // 4;  // 5 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  parameter W      =  4  //    input data width
)

(a, sum, cout);
input  [N*W-1 :0] a; 
output [W+E-1 :0] sum;
output [W+E-1 :0] cout;

  generate
    if      (N ==256) begin : gen_N_256
      carry_save_256inputs #(W) cs_256in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N ==128) begin : gen_N_128
      carry_save_128inputs #(W) cs_128in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 64) begin : gen_N_64
      carry_save_64inputs #(W)   cs_64in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 49) begin : gen_N_49
      carry_save_49inputs #(W)   cs_49in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 32) begin : gen_N_32
      carry_save_32inputs #(W)   cs_32in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 25) begin : gen_N_25
      carry_save_25inputs #(W)   cs_25in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 16) begin : gen_N_16
       carry_save_16inputs #(W)  cs_16in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 15) begin : gen_N_15
       carry_save_15inputs #(W)  cs_15in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 14) begin : gen_N_14
       carry_save_14inputs #(W)  cs_14in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 13) begin : gen_N_13
       carry_save_13inputs #(W)  cs_13in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 12) begin : gen_N_12
       carry_save_12inputs #(W)  cs_12in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 11) begin : gen_N_11
       carry_save_11inputs #(W)  cs_11in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 10) begin : gen_N_10
       carry_save_10inputs #(W)  cs_10in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 9) begin : gen_N_9
       carry_save_9inputs #(W)   cs_9in (.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 8) begin : gen_N_8
       carry_save_8inputs #(W)   cs_8in (.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 7) begin : gen_N_7
       carry_save_7inputs #(W)   cs_7in (.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 6) begin : gen_N_6
       carry_save_6inputs #(W)   cs_6in (.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 5) begin : gen_N_5
       carry_save_5inputs #(W)   cs_5in (.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 4) begin : gen_N_4
       carry_save_4inputs #(W)   cs_4in (.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 3) begin : gen_N_3
       carry_save_3inputs #(W)   cs_3in (.a(a), .sum(sum), .cout(cout)  ); end
    else if (N == 2) begin : gen_N_2
       assign sum = a[0 +: W];
       assign cout   = a[W +: W];
     end

//          carry_lookahead_adder #(W+E) CLA ( .i_add1(cs_sum), .i_add2(cs_c), .o_result(cla_sum) );
//          assign sum   = cla_sum[W+E-1 :0];
//          assign cout  = cla_sum[W+E];

  endgenerate

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

//wire [W+5:0] test10_0, test10_1, test10_2, test10_3 ;
//assign test10_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W];
//assign test10_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + a[9*W +: W ] ;
//assign test10_2 = sum_1 + c_1 + sum_2 + c_2 + a[9*W +: W ] ;
//assign test10_3 = cout + sum;

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
// Carry Save 11 inputs (four stages)
////////////////////////////////////

module carry_save_11inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [11*W-1:0] a; //, b,c,d;
 output [W+2  :0] sum;   
 output [W+2  :0] cout;  
 
 wire [W:0]   sum1_3, sum4_6, sum7_9;
 wire [W:0]   c1_3  , c4_6  , c7_9  ;
 wire [W+1:0] sum_1 , c_1   , sum_2  , c_2;
 wire [W+3:0] sum5  , cout5;

//wire [W+5:0] test10_0, test10_1, test10_2, test10_3 ;
//assign test10_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W];
//assign test10_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + a[9*W +: W ] ;
//assign test10_2 = sum_1 + c_1 + sum_2 + c_2 + a[9*W +: W ] ;
//assign test10_3 = cout + sum;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[ 0*W +: 3*W ]), .sum(sum1_3  ), .cout(c1_3  )  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[ 3*W +: 3*W ]), .sum(sum4_6  ), .cout(c4_6  )  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[ 6*W +: 3*W ]), .sum(sum7_9  ), .cout(c7_9  )  );  // a(10,11) do not added

 carry_save_3inputs #(W+1) cs_3in_4(.a({ sum1_3, sum4_6, sum7_9 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_5(.a({ c1_3, c4_6, c7_9 }),       .sum(sum_2), .cout(c_2) );

 carry_save_6inputs #(W+2) cs_6in (.a({sum_1, sum_2, c_1, c_2 , { 2'b00, a[ 9*W +: W ]} , { 2'b00, a[10*W +: W ]}  }), .sum(sum5), .cout(cout5)  );
assign cout = cout5[W+2  :0];
assign sum  = sum5 [W+2  :0];
// initial begin
//    $display(" CS 9ins | Win = %d , Wout = %d", W, W+3 );
// end

endmodule

////////////////////////////////////
// Carry Save 12 inputs (four stages)
////////////////////////////////////

module carry_save_12inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [12*W-1:0] a; //, b,c,d;
 output [W+2  :0] sum;   
 output [W+2  :0] cout;  
 
 wire [W:0]   sum1_3, sum4_6, sum7_9, sum10_12;
 wire [W:0]   c1_3  , c4_6  , c7_9  , c10_12  ;
 wire [W+1:0] sum_1 , c_1   , sum_2  , c_2;
 wire [W+3:0] sum6  , cout6;

//wire [W+5:0] test12_0, test12_1, test12_2, test12_3 ;
//assign test12_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W]+ a[10*W +: W] + a[11*W +: W];
//assign test12_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + sum10_12 + c10_12;
//assign test12_2 = sum_1 + c_1 + sum_2 + c_2 + sum10_12 + c10_12 ;
//assign test12_3 = cout + sum;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[ 0*W +: 3*W ]), .sum(sum1_3  ), .cout(c1_3  )  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[ 3*W +: 3*W ]), .sum(sum4_6  ), .cout(c4_6  )  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[ 6*W +: 3*W ]), .sum(sum7_9  ), .cout(c7_9  )  );
 carry_save_3inputs #(W) cs_3in_4 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );

 carry_save_3inputs #(W+1) cs_3in_5(.a({ sum1_3, sum4_6, sum7_9 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_6(.a({ c1_3, c4_6, c7_9 }),       .sum(sum_2), .cout(c_2) ); // sum10_12, c10_12 do not added

 carry_save_6inputs #(W+2) cs_6in (.a({sum_1, sum_2, c_1, c_2, {1'b0,sum10_12}, {1'b0,c10_12}  }), .sum(sum6), .cout(cout6)  );
assign cout = cout6[W+2  :0];
assign sum  = sum6 [W+2  :0];
// initial begin
//    $display(" CS 9ins | Win = %d , Wout = %d", W, W+3 );
// end

endmodule

////////////////////////////////////
// Carry Save 13 inputs (four stages)
////////////////////////////////////

module carry_save_13inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [13*W-1:0] a; //, b,c,d;
 output [W+2  :0] sum;   
 output [W+2  :0] cout;  
 
 wire [W:0]   sum1_3, sum4_6, sum7_9, sum10_12;
 wire [W:0]   c1_3  , c4_6  , c7_9  , c10_12  ;
 wire [W+1:0] sum_1 , c_1   , sum_2  , c_2, sum_3  , c_3;
 wire [W+3:0] sum6  , cout6;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[ 0*W +: 3*W ]), .sum(sum1_3  ), .cout(c1_3  )  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[ 3*W +: 3*W ]), .sum(sum4_6  ), .cout(c4_6  )  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[ 6*W +: 3*W ]), .sum(sum7_9  ), .cout(c7_9  )  );
 carry_save_3inputs #(W) cs_3in_4 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );// a[12*W +: W]  do not added

 carry_save_3inputs #(W+1) cs_3in_5(.a({ sum1_3  , sum4_6 , sum7_9              }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_6(.a({ c1_3    , c4_6   , c7_9                }), .sum(sum_2), .cout(c_2) ); 
 carry_save_3inputs #(W+1) cs_3in_7(.a({ sum10_12, c10_12 , {1'b0,a[12*W +: W]} }), .sum(sum_3), .cout(c_3) );

 carry_save_6inputs #(W+2) cs_6in (.a({sum_1, sum_2, sum_3, c_1, c_2, c_3 }), .sum(sum6), .cout(cout6)  );
assign cout = cout6[W+2  :0];
assign sum  = sum6 [W+2  :0];

endmodule

////////////////////////////////////
// Carry Save 14 inputs (four stages)
////////////////////////////////////

module carry_save_14inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [14*W-1:0] a; //, b,c,d;
 output [W+2  :0] sum;   
 output [W+2  :0] cout;  
 
 wire [W:0]   sum1_3, sum4_6, sum7_9, sum10_12;
 wire [W:0]   c1_3  , c4_6  , c7_9  , c10_12  ;
 wire [W+1:0] sum_1 , c_1   , sum_2  , c_2, sum_3  , c_3;
 wire [W+3:0] sum6  , cout6;

//wire [W+5:0] test14_0, test14_1, test14_2, test14_3 ;
//assign test14_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] 
//                + a[ 7*W +: W] + a[ 8*W +: W] + a[ 9*W +: W] + a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W];
//assign test14_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + sum10_12 + c10_12  + a[12*W +: W] + a[13*W +: W];
//assign test14_2 = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + c10_12;
//assign test14_3 = cout + sum;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[ 0*W +: 3*W ]), .sum(sum1_3  ), .cout(c1_3  )  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[ 3*W +: 3*W ]), .sum(sum4_6  ), .cout(c4_6  )  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[ 6*W +: 3*W ]), .sum(sum7_9  ), .cout(c7_9  )  );
 carry_save_3inputs #(W) cs_3in_4 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );// a[12*W +: W] + a[13*W +: W] do not added

 carry_save_3inputs #(W+1) cs_3in_5(.a({ sum1_3  , sum4_6             , sum7_9              }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_6(.a({ c1_3    , c4_6               , c7_9                }), .sum(sum_2), .cout(c_2) ); 
 carry_save_3inputs #(W+1) cs_3in_7(.a({ sum10_12, {1'b0,a[12*W +: W]}, {1'b0,a[13*W +: W]} }), .sum(sum_3), .cout(c_3) ); // c10_12 do not added

 carry_save_7inputs #(W+2) cs_7in (.a({sum_1, sum_2, sum_3, c_1, c_2, c_3, {1'b0,c10_12}  }), .sum(sum6), .cout(cout6)  );
assign cout = cout6[W+2  :0];
assign sum  = sum6 [W+2  :0];

endmodule

////////////////////////////////////
// Carry Save 15 inputs (four stages)
////////////////////////////////////

module carry_save_15inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [15*W-1:0] a; //, b,c,d;
 output [W+2  :0] sum;   
 output [W+2  :0] cout;  
 
 wire [W:0]   sum1_3, sum4_6, sum7_9, sum10_12, sum13_15;
 wire [W:0]   c1_3  , c4_6  , c7_9  , c10_12  , c13_15  ;
 wire [W+1:0] sum_1 , c_1   , sum_2  , c_2, sum_3  , c_3;
 wire [W+3:0] sum6  , cout6;

//wire [W+5:0] test14_0, test14_1, test14_2, test14_3 ;
//assign test14_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] 
//                + a[ 7*W +: W] + a[ 8*W +: W] + a[ 9*W +: W] + a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W];
//assign test14_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + sum10_12 + c10_12  + a[12*W +: W] + a[13*W +: W];
//assign test14_2 = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + c10_12;
//assign test14_3 = cout + sum;

 carry_save_3inputs #(W) cs_3in_1 (.a(a[ 0*W +: 3*W ]), .sum(sum1_3  ), .cout(c1_3  )  );
 carry_save_3inputs #(W) cs_3in_2 (.a(a[ 3*W +: 3*W ]), .sum(sum4_6  ), .cout(c4_6  )  );
 carry_save_3inputs #(W) cs_3in_3 (.a(a[ 6*W +: 3*W ]), .sum(sum7_9  ), .cout(c7_9  )  );
 carry_save_3inputs #(W) cs_3in_4 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );
 carry_save_3inputs #(W) cs_3in_5 (.a(a[12*W +: 3*W ]), .sum(sum13_15), .cout(c13_15)  );

 carry_save_3inputs #(W+1) cs_3in_6(.a({ sum1_3  , sum4_6  , sum7_9 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_7(.a({ c1_3    , c4_6    , c7_9   }), .sum(sum_2), .cout(c_2) ); 
 carry_save_3inputs #(W+1) cs_3in_8(.a({ sum10_12, sum13_15, c10_12 }), .sum(sum_3), .cout(c_3) ); // c13_15 do not added

 carry_save_7inputs #(W+2) cs_7in (.a({sum_1, sum_2, sum_3, c_1, c_2, c_3, {1'b0,c13_15}  }), .sum(sum6), .cout(cout6)  );
assign cout = cout6[W+2  :0];
assign sum  = sum6 [W+2  :0];

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
output [W+3  :0] sum;
output [W+3  :0] cout;


wire [W:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W+1:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5;
wire [W+2:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14;
wire [W+5:0] sum8, cout8;

// wire [W+1:0] sum19_25;
// wire [W+1:0] c19_25  ;
// wire [W+2:0] sum1_9, sum10_18;
// wire [W+2:0] c1_9  , c10_18  ;
// wire [W+5:0] test6_0, test6_1, test6_2, test6_3, test6_4  ;
// assign test6_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W] + 
//                  a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + a[15*W +: W] + a[16*W +: W] + a[17*W +: W]+ a[18*W +: W] + a[19*W +: W] + 
//                  a[20*W +: W] + a[21*W +: W] + a[22*W +: W] + a[23*W +: W] + a[24*W +: W];
// assign test6_1 = sum_1 + sum_2 + sum_3 + sum_4 + sum_5 + c_1 + c_2 + c_3 + c_4 + c_5 + c22_24 + a[24*W +: W];
// assign test6_2 = sum_11 + sum_12 + sum_13 + sum_14 + c_11 + c_12 + c_13 + c_14;
// assign test6_3 = sum8 + cout8; 
// assign test6_4 = cout + sum;

 carry_save_3inputs #(W) cs_3in_01 (.a(a[ 0*W +: 3*W ]), .sum(sum01_03), .cout(c01_03)  );
 carry_save_3inputs #(W) cs_3in_02 (.a(a[ 3*W +: 3*W ]), .sum(sum04_06), .cout(c04_06)  );
 carry_save_3inputs #(W) cs_3in_03 (.a(a[ 6*W +: 3*W ]), .sum(sum07_09), .cout(c07_09)  );
 carry_save_3inputs #(W) cs_3in_04 (.a(a[ 9*W +: 3*W ]), .sum(sum10_12), .cout(c10_12)  );
 carry_save_3inputs #(W) cs_3in_05 (.a(a[12*W +: 3*W ]), .sum(sum13_15), .cout(c13_15)  );
 carry_save_3inputs #(W) cs_3in_06 (.a(a[15*W +: 3*W ]), .sum(sum16_18), .cout(c16_18)  );
 carry_save_3inputs #(W) cs_3in_07 (.a(a[18*W +: 3*W ]), .sum(sum19_21), .cout(c19_21)  );
 carry_save_3inputs #(W) cs_3in_08 (.a(a[21*W +: 3*W ]), .sum(sum22_24), .cout(c22_24)  ); // a(25) do not added

carry_save_3inputs #(W+1) cs_3in_11 (.a({ sum01_03, sum04_06, sum07_09 }), .sum(sum_1), .cout(c_1)  );
carry_save_3inputs #(W+1) cs_3in_12 (.a({ sum10_12, sum13_15, sum16_18 }), .sum(sum_2), .cout(c_2)  );
carry_save_3inputs #(W+1) cs_3in_13 (.a({ c01_03  , c04_06  , c07_09   }), .sum(sum_3), .cout(c_3)  );
carry_save_3inputs #(W+1) cs_3in_14 (.a({ c10_12  , c13_15  , c16_18   }), .sum(sum_4), .cout(c_4)  );
carry_save_3inputs #(W+1) cs_3in_15 (.a({ sum19_21, c19_21  , sum22_24 }), .sum(sum_5), .cout(c_5)  );//c22_24 and  a(25) do not added

 carry_save_3inputs #(W+2) cs_3in_21 (.a({ sum_1, sum_2, sum_3                            }), .sum(sum_11), .cout(c_11)  );
 carry_save_3inputs #(W+2) cs_3in_22 (.a({ c_1  , c_2  , c_3                              }), .sum(sum_12), .cout(c_12)  );
 carry_save_3inputs #(W+2) cs_3in_23 (.a({ sum_4, c_4  , sum_5                            }), .sum(sum_13), .cout(c_13)  );
 carry_save_3inputs #(W+2) cs_3in_24 (.a({ c_5  , {1'b0, c22_24}, { 2'b00, a[24*W +: W] } }), .sum(sum_14), .cout(c_14)  );


 carry_save_8inputs #(W+3) cs_8in (.a({ sum_11, sum_12, sum_13, sum_14, c_11, c_12, c_13 , c_14 }), .sum(sum8), .cout(cout8)  );
assign cout = cout8[W+3  :0];
assign sum  = sum8 [W+3  :0];

//carry_save_9inputs #(W)  cs_9in1 (.a( a[ 0*W +: 9*W ] ), .sum(sum1_9)  , .cout(c1_9)   );
//carry_save_9inputs #(W)  cs_9in2 (.a( a[ 9*W +: 9*W ] ), .sum(sum10_18), .cout(c10_18) );
//carry_save_7inputs #(W)  cs_7in  (.a( a[18*W +: 7*W ] ), .sum(sum19_25), .cout(c19_25) );
//
//carry_save_6inputs #(W+3) cs_6in (.a({sum1_9, sum10_18, { 1'b0, sum19_25}, c1_9  , c10_18  , { 1'b0, c19_25} }), .sum(sum), .cout(cout)  );

endmodule


////////////////////////////////////
// Carry Save 32 inputs (seven stages)
////////////////////////////////////

module carry_save_32inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [32*W-1:0] a; //, b,c,d;
output [W+4  :0] sum;
output [W+4  :0] cout;

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
output [W+4  :0] sum;
output [W+4  :0] cout;

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

endmodule


////////////////////////////////////
// Carry Save 64 inputs (seven stages)
////////////////////////////////////

module carry_save_64inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [64*W-1:0] a; //, b,c,d;
output [W+5  :0] sum;
output [W+5  :0] cout;

wire [W:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W:0] sum25_27, c25_27, sum28_30, c28_30, sum31_33, c31_33, sum34_36, c34_36, sum37_39, c37_39, sum40_42, c40_42, sum43_45, c43_45, sum46_48, c46_48;
wire [W:0] sum49_51, c49_51, sum52_54, c52_54, sum55_57, c55_57, sum58_60, c58_60, sum61_63, c61_63;

wire [W+1:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5,  sum_6,  c_6,  sum_7,  c_7, sum_8, c_8, sum_9, c_9, sum_A, c_A, sum_B, c_B;
wire [W+1:0] sum_C, sum_D, sum_E, c_C, c_D, c_E;

wire [W+2:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16, sum_17, c_17, sum_18, c_18, sum_19, c_19;
wire [W+3:0] sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24, sum_25, c_25, sum_26, c_26;
wire [W+4:0] sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34; 
wire [W+5:0] sum_41, c_41, sum_42, c_42, sum_43, c_43;
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
//                 a[45*W +: W] + a[46*W +: W] + a[47*W +: W] + a[48*W +: W] + a[49*W +: W] +
//                 a[50*W +: W] + a[51*W +: W] + a[52*W +: W] + a[53*W +: W] + a[54*W +: W] + 
//                 a[55*W +: W] + a[56*W +: W] + a[57*W +: W] + a[58*W +: W] + a[59*W +: W] + 
//                 a[60*W +: W] + a[61*W +: W] + a[62*W +: W] + a[63*W +: W];
//assign test_1_stage = sum01_03 + c01_03 + sum04_06 + c04_06 + sum07_09 + c07_09 + sum10_12 + c10_12 + sum13_15 + c13_15 + sum16_18 + c16_18 + sum19_21 + c19_21 + sum22_24 + c22_24 +
//                      sum25_27 + c25_27 + sum28_30 + c28_30 + sum31_33 + c31_33 + sum34_36 + c34_36 + sum37_39 + c37_39 + sum40_42 + c40_42 + sum43_45 + c43_45 + sum46_48 + c46_48 +
//                      sum49_51 + c49_51 + sum52_54 + c52_54 + sum55_57 + c55_57 + sum58_60 + c58_60 + sum61_63 + c61_63        + a[63*W +: W];
//
//assign test_2_stage = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + sum_4 + c_4 + sum_5 + c_5 + sum_6 + c_6 + sum_7 + c_7 + sum_8 + c_8 + sum_9 + c_9 + sum_A + c_A + sum_B + c_B +
//                      sum_C + c_C + sum_D + c_D + sum_E + c_E          + c61_63;
//
//assign test_3_stage = sum_11+ c_11+ sum_12+ c_12+ sum_13+ c_13+ sum_14+ c_14+ sum_15+ c_15+ sum_16+ c_16+ sum_17+ c_17 + sum_18 + c_18 + sum_19 + c_19     + sum_D + sum_E;
//assign test_4_stage = sum_21 + c_21 + sum_22 + c_22 + sum_23 + c_23 + sum_24 + c_24 + sum_25 + c_25 + sum_26 + c_26    + sum_D + sum_E;
//assign test_5_stage = sum_31 + c_31 + sum_32 + c_32 + sum_33 + c_33 + sum_34 + c_34           + sum_D + sum_E;
//assign test_6_stage = sum_41 + c_41 + sum_42 + c_42 + sum_43 + c_43        + sum_E;
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
 carry_save_3inputs #(W) cs_3in_16 (.a(a[45*W +: 3*W ]), .sum(sum46_48), .cout(c46_48)  );
 carry_save_3inputs #(W) cs_3in_17 (.a(a[48*W +: 3*W ]), .sum(sum49_51), .cout(c49_51)  );
 carry_save_3inputs #(W) cs_3in_18 (.a(a[51*W +: 3*W ]), .sum(sum52_54), .cout(c52_54)  );
 carry_save_3inputs #(W) cs_3in_19 (.a(a[54*W +: 3*W ]), .sum(sum55_57), .cout(c55_57)  );
 carry_save_3inputs #(W) cs_3in_1A (.a(a[57*W +: 3*W ]), .sum(sum58_60), .cout(c58_60)  );
 carry_save_3inputs #(W) cs_3in_1B (.a(a[60*W +: 3*W ]), .sum(sum61_63), .cout(c61_63)  ); // a(63) do not added
 

 carry_save_3inputs #(W+1) cs_3in_20(.a({ sum01_03, sum04_06, sum07_09 }),        .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+1) cs_3in_21(.a({ sum10_12, sum13_15, sum16_18 }),        .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+1) cs_3in_22(.a({ sum19_21, sum22_24, sum25_27 }),        .sum(sum_3), .cout(c_3) );
 carry_save_3inputs #(W+1) cs_3in_23(.a({ sum28_30, sum31_33, sum34_36 }),        .sum(sum_4), .cout(c_4) );
 carry_save_3inputs #(W+1) cs_3in_24(.a({ sum37_39, sum40_42, sum43_45 }),        .sum(sum_5), .cout(c_5) );
 carry_save_3inputs #(W+1) cs_3in_25(.a({ sum46_48, sum49_51, sum52_54 }),        .sum(sum_6), .cout(c_6) );
 carry_save_3inputs #(W+1) cs_3in_26(.a({ sum55_57, sum58_60, sum61_63 }),        .sum(sum_7), .cout(c_7) );
 carry_save_3inputs #(W+1) cs_3in_27(.a({ c01_03, c04_06, c07_09}),               .sum(sum_8), .cout(c_8) );
 carry_save_3inputs #(W+1) cs_3in_28(.a({ c10_12, c13_15, c16_18}),               .sum(sum_9), .cout(c_9) );
 carry_save_3inputs #(W+1) cs_3in_29(.a({ c19_21, c22_24, c25_27}),               .sum(sum_A), .cout(c_A) );
 carry_save_3inputs #(W+1) cs_3in_2A(.a({ c28_30, c31_33, c34_36}),               .sum(sum_B), .cout(c_B) );
 carry_save_3inputs #(W+1) cs_3in_2B(.a({ c37_39, c40_42, c43_45}),               .sum(sum_C), .cout(c_C) );
 carry_save_3inputs #(W+1) cs_3in_2C(.a({ c46_48, c49_51, c52_54}),               .sum(sum_D), .cout(c_D) );
 carry_save_3inputs #(W+1) cs_3in_2D(.a({ c55_57, c58_60, {1'b0, a[63*W +: W ]}}),.sum(sum_E), .cout(c_E) );// c61_63 do not added

 carry_save_3inputs #(W+2) cs_3in_30(.a({ sum_1, sum_2, sum_3 }),     .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+2) cs_3in_31(.a({ sum_4, sum_5, sum_6 }),     .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+2) cs_3in_32(.a({ sum_7, sum_8, sum_9 }),     .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+2) cs_3in_33(.a({ sum_A, sum_B, sum_C}),      .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+2) cs_3in_34(.a({ c_1, c_2, c_3}),            .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+2) cs_3in_35(.a({ c_4, c_5, c_6}),            .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+2) cs_3in_36(.a({ c_7, c_8, c_9}),            .sum(sum_17), .cout(c_17) );   
 carry_save_3inputs #(W+2) cs_3in_37(.a({ c_A, c_B, c_C}),            .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+2) cs_3in_38(.a({ c_E, c_D, {1'b0, c61_63}}), .sum(sum_19), .cout(c_19) ); // sum_D, sum_E, do not added

 carry_save_3inputs #(W+3) cs_3in_40(.a({ sum_11, sum_12, sum_13 }), .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+3) cs_3in_41(.a({ sum_14, sum_15, sum_16 }), .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+3) cs_3in_43(.a({ sum_17, sum_18, sum_19 }), .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+3) cs_3in_44(.a({ c_11, c_12, c_13}),        .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+3) cs_3in_45(.a({ c_14, c_15, c_16}),        .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+3) cs_3in_46(.a({ c_17, c_18, c_19}),        .sum(sum_26), .cout(c_26) ); // sum_D, sum_E, do not added + 2


 carry_save_3inputs #(W+4) cs_3in_50(.a({ sum_21, sum_22, sum_23 }), .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+4) cs_3in_51(.a({ sum_24, sum_25, sum_26 }), .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+4) cs_3in_52(.a({ c_21, c_22, c_23}),        .sum(sum_33), .cout(c_33) ); 
 carry_save_3inputs #(W+4) cs_3in_53(.a({ c_24, c_25, c_26}),        .sum(sum_34), .cout(c_34) ); // sum_D, sum_E, do not added + 3

 carry_save_3inputs #(W+5) cs_3in_60(.a({ sum_31, sum_32, sum_33 }),         .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+5) cs_3in_61(.a({ c_31, c_32, c_33 }),               .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+5) cs_3in_62(.a({ sum_34, c_34, { 3'b000, sum_D} }), .sum(sum_43), .cout(c_43) );// sum_E, do not added + 4

carry_save_7inputs #(W+6) cs_7in (.a({sum_41, sum_42, sum_43, c_41, c_42, c_43 , { 4'b0000, sum_E} }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+5  :0];
assign sum  = sum5 [W+5  :0];


endmodule


////////////////////////////////////
// Carry Save 128 inputs 
////////////////////////////////////

module carry_save_128inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [128*W-1:0] a; //, b,c,d;
output [W+6  :0] sum;
output [W+6  :0] cout;

wire [W:0] sum000, c000, sum003, c003, sum006, c006, sum009, c009, sum012, c012, sum015, c015, sum018, c018, sum021, c021; 
wire [W:0] sum024, c024, sum027, c027, sum030, c030, sum033, c033, sum036, c036, sum039, c039, sum042, c042, sum045, c045; 
wire [W:0] sum048, c048, sum051, c051, sum054, c054, sum057, c057, sum060, c060, sum063, c063, sum066, c066, sum069, c069; 
wire [W:0] sum072, c072, sum075, c075, sum078, c078, sum081, c081, sum084, c084, sum087, c087, sum090, c090, sum093, c093; 
wire [W:0] sum096, c096, sum099, c099, sum102, c102, sum105, c105, sum108, c108, sum111, c111, sum114, c114, sum117, c117, sum120, c120, sum123, c123;

wire [W+1:0] sum_01, c_01, sum_02, c_02, sum_03, c_03, sum_04, c_04, sum_05, c_05, sum_06, c_06, sum_07, c_07, sum_08, c_08;
wire [W+1:0] sum_09, c_09, sum_10, c_10, sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16;
wire [W+1:0] sum_17, c_17, sum_18, c_18, sum_19, c_19, sum_20, c_20, sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+1:0] sum_25, c_25, sum_26, c_26, sum_27, c_27, sum_28, c_28;

wire [W+2:0] sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34, sum_35, c_35, sum_36, c_36, sum_37, c_37, sum_38, c_38;
wire [W+2:0] sum_39, c_39, sum_40, c_40, sum_41, c_41, sum_42, c_42, sum_43, c_43, sum_44, c_44, sum_45, c_45, sum_46, c_46; 
wire [W+2:0] sum_47, c_47, sum_48, c_48, sum_49, c_49;

wire [W+3:0] sum_51, c_51, sum_52, c_52, sum_53, c_53, sum_54, c_54, sum_55, c_55, sum_56, c_56, sum_57, c_57, sum_58, c_58;
wire [W+3:0] sum_59, c_59, sum_60, c_60, sum_61, c_61, sum_62, c_62, sum_63, c_63;
wire [W+4:0] sum_71, c_71, sum_72, c_72, sum_73, c_73, sum_74, c_74, sum_75, c_75, sum_76, c_76, sum_77, c_77, sum_78, c_78;
wire [W+5:0] sum_81, c_81, sum_82, c_82, sum_83, c_83, sum_84, c_84, sum_85, c_85, sum_86, c_86;
wire [W+6:0] sum_91, c_91, sum_92, c_92, sum_93, c_93, sum_94, c_94;

wire [W+9:0] sum5, cout5;

//wire [W+8:0]  test_in, test_1_stage, test_2_stage, test_3_stage, test_4_stage, test_5_stage, test_6_stage, test_7_stage, test_8_preout, test_9_out;
//assign test_in = a[  0*W +: W] + a[  1*W +: W] + a[  2*W +: W] + a[  3*W +: W] + a[  4*W +: W] + 
//                 a[  5*W +: W] + a[  6*W +: W] + a[  7*W +: W] + a[  8*W +: W] + a[  9*W +: W] + 
//                 a[ 10*W +: W] + a[ 11*W +: W] + a[ 12*W +: W] + a[ 13*W +: W] + a[ 14*W +: W] + 
//                 a[ 15*W +: W] + a[ 16*W +: W] + a[ 17*W +: W] + a[ 18*W +: W] + a[ 19*W +: W] + 
//                 a[ 20*W +: W] + a[ 21*W +: W] + a[ 22*W +: W] + a[ 23*W +: W] + a[ 24*W +: W] +
//                 a[ 25*W +: W] + a[ 26*W +: W] + a[ 27*W +: W] + a[ 28*W +: W] + a[ 29*W +: W] + 
//                 a[ 30*W +: W] + a[ 31*W +: W] + a[ 32*W +: W] + a[ 33*W +: W] + a[ 34*W +: W] + 
//                 a[ 35*W +: W] + a[ 36*W +: W] + a[ 37*W +: W] + a[ 38*W +: W] + a[ 39*W +: W] + 
//                 a[ 40*W +: W] + a[ 41*W +: W] + a[ 42*W +: W] + a[ 43*W +: W] + a[ 44*W +: W] + 
//                 a[ 45*W +: W] + a[ 46*W +: W] + a[ 47*W +: W] + a[ 48*W +: W] + a[ 49*W +: W] +
//                 a[ 50*W +: W] + a[ 51*W +: W] + a[ 52*W +: W] + a[ 53*W +: W] + a[ 54*W +: W] + 
//                 a[ 55*W +: W] + a[ 56*W +: W] + a[ 57*W +: W] + a[ 58*W +: W] + a[ 59*W +: W] + 
//                 a[ 60*W +: W] + a[ 61*W +: W] + a[ 62*W +: W] + a[ 63*W +: W] + a[ 64*W +: W] +
//                 a[ 65*W +: W] + a[ 66*W +: W] + a[ 67*W +: W] + a[ 68*W +: W] + a[ 69*W +: W] + 
//                 a[ 70*W +: W] + a[ 71*W +: W] + a[ 72*W +: W] + a[ 73*W +: W] + a[ 74*W +: W] +
//                 a[ 75*W +: W] + a[ 76*W +: W] + a[ 77*W +: W] + a[ 78*W +: W] + a[ 79*W +: W] + 
//                 a[ 80*W +: W] + a[ 81*W +: W] + a[ 82*W +: W] + a[ 83*W +: W] + a[ 84*W +: W] + 
//                 a[ 85*W +: W] + a[ 86*W +: W] + a[ 87*W +: W] + a[ 88*W +: W] + a[ 89*W +: W] + 
//                 a[ 90*W +: W] + a[ 91*W +: W] + a[ 92*W +: W] + a[ 93*W +: W] + a[ 94*W +: W] + 
//                 a[ 95*W +: W] + a[ 96*W +: W] + a[ 97*W +: W] + a[ 98*W +: W] + a[ 99*W +: W] +
//                 a[100*W +: W] + a[101*W +: W] + a[102*W +: W] + a[103*W +: W] + a[104*W +: W] + 
//                 a[105*W +: W] + a[106*W +: W] + a[107*W +: W] + a[108*W +: W] + a[109*W +: W] + 
//                 a[110*W +: W] + a[111*W +: W] + a[112*W +: W] + a[113*W +: W] + a[114*W +: W] +
//                 a[115*W +: W] + a[116*W +: W] + a[117*W +: W] + a[118*W +: W] + a[119*W +: W] + 
//                 a[120*W +: W] + a[121*W +: W] + a[122*W +: W] + a[123*W +: W] + a[124*W +: W] +
//                 a[125*W +: W] + a[126*W +: W] + a[127*W +: W] ;
//
//assign test_1_stage = 
//         sum000 + c000 + sum003 + c003 + sum006 + c006 + sum009 + c009 + sum012 + c012 + sum015 + c015 + sum018 + c018 + sum021 + c021 + a[126*W +:W] + a[127*W +:W] +
//         sum024 + c024 + sum027 + c027 + sum030 + c030 + sum033 + c033 + sum036 + c036 + sum039 + c039 + sum042 + c042 + sum045 + c045 + 
//         sum048 + c048 + sum051 + c051 + sum054 + c054 + sum057 + c057 + sum060 + c060 + sum063 + c063 + sum066 + c066 + sum069 + c069 + 
//         sum072 + c072 + sum075 + c075 + sum078 + c078 + sum081 + c081 + sum084 + c084 + sum087 + c087 + sum090 + c090 + sum093 + c093 + 
//         sum096 + c096 + sum099 + c099 + sum102 + c102 + sum105 + c105 + sum108 + c108 + sum111 + c111 + sum114 + c114 + sum117 + c117 + sum120 + c120 + sum123 + c123;
//assign test_2_stage = 
//         sum_01 + c_01 + sum_02 + c_02 + sum_03 + c_03 + sum_04 + c_04 + sum_05 + c_05 + sum_06 + c_06 + sum_07 + c_07 + sum_08 + c_08 + a[126*W +:W] + a[127*W +:W] +
//         sum_09 + c_09 + sum_10 + c_10 + sum_11 + c_11 + sum_12 + c_12 + sum_13 + c_13 + sum_14 + c_14 + sum_15 + c_15 + sum_16 + c_16 +
//         sum_17 + c_17 + sum_18 + c_18 + sum_19 + c_19 + sum_20 + c_20 + sum_21 + c_21 + sum_22 + c_22 + sum_23 + c_23 + sum_24 + c_24 +
//         sum_25 + c_25 + sum_26 + c_26 + sum_27 + c_27 + sum_28 + c_28;
//assign test_3_stage = 
//         sum_31 + c_31 + sum_32 + c_32 + sum_33 + c_33 + sum_34 + c_34 + sum_35 + c_35 + sum_36 + c_36 + sum_37 + c_37 + sum_38 + c_38 +              c_28 +
//         sum_39 + c_39 + sum_40 + c_40 + sum_41 + c_41 + sum_42 + c_42 + sum_43 + c_43 + sum_44 + c_44 + sum_45 + c_45 + sum_46 + c_46 +
//         sum_47 + c_47 + sum_48 + c_48 + sum_49 + c_49;
//assign test_4_stage = sum_51 + c_51 + sum_52 + c_52 + sum_53 + c_53 + sum_54 + c_54 + sum_55 + c_55 + sum_56 + c_56 + sum_57 + c_57 + sum_58 + c_58 +
//                      sum_59 + c_59 + sum_60 + c_60 + sum_61 + c_61 + sum_62 + c_62 + sum_63 + c_63;
//assign test_5_stage = sum_71 + c_71 + sum_72 + c_72 + sum_73 + c_73 + sum_74 + c_74 + sum_75 + c_75 + sum_76 + c_76 + sum_77 + c_77 + sum_78 + c_78 +    sum_63 + c_63;
//assign test_6_stage = sum_81 + c_81 + sum_82 + c_82 + sum_83 + c_83 + sum_84 + c_84 + sum_85 + c_85 + sum_86 + c_86;
//assign test_7_stage = sum_91 + c_91 + sum_92 + c_92 + sum_93 + c_93 + sum_94 + c_94;
//assign test_8_preout = sum5 + cout5;
//assign test_9_out    = sum + cout;

 carry_save_3inputs #(W) cs_3in_000 (.a(a[  0*W +: 3*W ]), .sum(sum000), .cout(c000) );
 carry_save_3inputs #(W) cs_3in_003 (.a(a[  3*W +: 3*W ]), .sum(sum003), .cout(c003) );
 carry_save_3inputs #(W) cs_3in_006 (.a(a[  6*W +: 3*W ]), .sum(sum006), .cout(c006) );
 carry_save_3inputs #(W) cs_3in_009 (.a(a[  9*W +: 3*W ]), .sum(sum009), .cout(c009) );
 carry_save_3inputs #(W) cs_3in_012 (.a(a[ 12*W +: 3*W ]), .sum(sum012), .cout(c012) );
 carry_save_3inputs #(W) cs_3in_015 (.a(a[ 15*W +: 3*W ]), .sum(sum015), .cout(c015) );
 carry_save_3inputs #(W) cs_3in_018 (.a(a[ 18*W +: 3*W ]), .sum(sum018), .cout(c018) );
 carry_save_3inputs #(W) cs_3in_021 (.a(a[ 21*W +: 3*W ]), .sum(sum021), .cout(c021) );
 carry_save_3inputs #(W) cs_3in_024 (.a(a[ 24*W +: 3*W ]), .sum(sum024), .cout(c024) );
 carry_save_3inputs #(W) cs_3in_027 (.a(a[ 27*W +: 3*W ]), .sum(sum027), .cout(c027) );
 carry_save_3inputs #(W) cs_3in_030 (.a(a[ 30*W +: 3*W ]), .sum(sum030), .cout(c030) );
 carry_save_3inputs #(W) cs_3in_033 (.a(a[ 33*W +: 3*W ]), .sum(sum033), .cout(c033) );
 carry_save_3inputs #(W) cs_3in_036 (.a(a[ 36*W +: 3*W ]), .sum(sum036), .cout(c036) );
 carry_save_3inputs #(W) cs_3in_039 (.a(a[ 39*W +: 3*W ]), .sum(sum039), .cout(c039) );
 carry_save_3inputs #(W) cs_3in_042 (.a(a[ 42*W +: 3*W ]), .sum(sum042), .cout(c042) );
 carry_save_3inputs #(W) cs_3in_045 (.a(a[ 45*W +: 3*W ]), .sum(sum045), .cout(c045) );
 carry_save_3inputs #(W) cs_3in_048 (.a(a[ 48*W +: 3*W ]), .sum(sum048), .cout(c048) );
 carry_save_3inputs #(W) cs_3in_051 (.a(a[ 51*W +: 3*W ]), .sum(sum051), .cout(c051) );
 carry_save_3inputs #(W) cs_3in_054 (.a(a[ 54*W +: 3*W ]), .sum(sum054), .cout(c054) );
 carry_save_3inputs #(W) cs_3in_057 (.a(a[ 57*W +: 3*W ]), .sum(sum057), .cout(c057) );
 carry_save_3inputs #(W) cs_3in_060 (.a(a[ 60*W +: 3*W ]), .sum(sum060), .cout(c060) ); 
 carry_save_3inputs #(W) cs_3in_063 (.a(a[ 63*W +: 3*W ]), .sum(sum063), .cout(c063) );
 carry_save_3inputs #(W) cs_3in_066 (.a(a[ 66*W +: 3*W ]), .sum(sum066), .cout(c066) );
 carry_save_3inputs #(W) cs_3in_069 (.a(a[ 69*W +: 3*W ]), .sum(sum069), .cout(c069) );
 carry_save_3inputs #(W) cs_3in_072 (.a(a[ 72*W +: 3*W ]), .sum(sum072), .cout(c072) );
 carry_save_3inputs #(W) cs_3in_075 (.a(a[ 75*W +: 3*W ]), .sum(sum075), .cout(c075) );
 carry_save_3inputs #(W) cs_3in_078 (.a(a[ 78*W +: 3*W ]), .sum(sum078), .cout(c078) );
 carry_save_3inputs #(W) cs_3in_081 (.a(a[ 81*W +: 3*W ]), .sum(sum081), .cout(c081) );
 carry_save_3inputs #(W) cs_3in_084 (.a(a[ 84*W +: 3*W ]), .sum(sum084), .cout(c084) );
 carry_save_3inputs #(W) cs_3in_087 (.a(a[ 87*W +: 3*W ]), .sum(sum087), .cout(c087) );
 carry_save_3inputs #(W) cs_3in_090 (.a(a[ 90*W +: 3*W ]), .sum(sum090), .cout(c090) );
 carry_save_3inputs #(W) cs_3in_093 (.a(a[ 93*W +: 3*W ]), .sum(sum093), .cout(c093) );
 carry_save_3inputs #(W) cs_3in_096 (.a(a[ 96*W +: 3*W ]), .sum(sum096), .cout(c096) );
 carry_save_3inputs #(W) cs_3in_099 (.a(a[ 99*W +: 3*W ]), .sum(sum099), .cout(c099) );
 carry_save_3inputs #(W) cs_3in_102 (.a(a[102*W +: 3*W ]), .sum(sum102), .cout(c102) );
 carry_save_3inputs #(W) cs_3in_105 (.a(a[105*W +: 3*W ]), .sum(sum105), .cout(c105) );
 carry_save_3inputs #(W) cs_3in_108 (.a(a[108*W +: 3*W ]), .sum(sum108), .cout(c108) );
 carry_save_3inputs #(W) cs_3in_111 (.a(a[111*W +: 3*W ]), .sum(sum111), .cout(c111) );
 carry_save_3inputs #(W) cs_3in_114 (.a(a[114*W +: 3*W ]), .sum(sum114), .cout(c114) );
 carry_save_3inputs #(W) cs_3in_117 (.a(a[117*W +: 3*W ]), .sum(sum117), .cout(c117) );
 carry_save_3inputs #(W) cs_3in_120 (.a(a[120*W +: 3*W ]), .sum(sum120), .cout(c120) );
 carry_save_3inputs #(W) cs_3in_123 (.a(a[123*W +: 3*W ]), .sum(sum123), .cout(c123) ); // a(126) , a(127) do not added

 carry_save_3inputs #(W+1) cs_3in_01(.a({ sum000, sum003, sum006 }), .sum(sum_01), .cout(c_01) );
 carry_save_3inputs #(W+1) cs_3in_02(.a({ sum009, sum012, sum015 }), .sum(sum_02), .cout(c_02) );
 carry_save_3inputs #(W+1) cs_3in_03(.a({ sum018, sum021, sum024 }), .sum(sum_03), .cout(c_03) );
 carry_save_3inputs #(W+1) cs_3in_04(.a({ sum027, sum030, sum033 }), .sum(sum_04), .cout(c_04) );
 carry_save_3inputs #(W+1) cs_3in_05(.a({ sum036, sum039, sum042 }), .sum(sum_05), .cout(c_05) );
 carry_save_3inputs #(W+1) cs_3in_06(.a({ sum045, sum048, sum051 }), .sum(sum_06), .cout(c_06) );
 carry_save_3inputs #(W+1) cs_3in_07(.a({ sum054, sum057, sum060 }), .sum(sum_07), .cout(c_07) );
 carry_save_3inputs #(W+1) cs_3in_08(.a({ sum063, sum066, sum069 }), .sum(sum_08), .cout(c_08) );
 carry_save_3inputs #(W+1) cs_3in_09(.a({ sum072, sum075, sum078 }), .sum(sum_09), .cout(c_09) );
 carry_save_3inputs #(W+1) cs_3in_10(.a({ sum081, sum084, sum087 }), .sum(sum_10), .cout(c_10) );
 carry_save_3inputs #(W+1) cs_3in_11(.a({ sum090, sum093, sum096 }), .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+1) cs_3in_12(.a({ sum099, sum102, sum105 }), .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+1) cs_3in_13(.a({ sum108, sum111, sum114 }), .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+1) cs_3in_14(.a({ sum117, sum120, sum123 }), .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+1) cs_3in_15(.a({ c000, c003, c006 }),       .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+1) cs_3in_16(.a({ c009, c012, c015 }),       .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+1) cs_3in_17(.a({ c018, c021, c024 }),       .sum(sum_17), .cout(c_17) );
 carry_save_3inputs #(W+1) cs_3in_18(.a({ c027, c030, c033 }),       .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+1) cs_3in_19(.a({ c036, c039, c042 }),       .sum(sum_19), .cout(c_19) );
 carry_save_3inputs #(W+1) cs_3in_20(.a({ c045, c048, c051 }),       .sum(sum_20), .cout(c_20) );
 carry_save_3inputs #(W+1) cs_3in_21(.a({ c054, c057, c060 }),       .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+1) cs_3in_22(.a({ c063, c066, c069 }),       .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+1) cs_3in_23(.a({ c072, c075, c078 }),       .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+1) cs_3in_24(.a({ c081, c084, c087 }),       .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+1) cs_3in_25(.a({ c090, c093, c096 }),       .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+1) cs_3in_26(.a({ c099, c102, c105 }),       .sum(sum_26), .cout(c_26) );
 carry_save_3inputs #(W+1) cs_3in_27(.a({ c108, c111, c114 }),       .sum(sum_27), .cout(c_27) );
 carry_save_3inputs #(W+1) cs_3in_28(.a({ c117, c120, c123 }),       .sum(sum_28), .cout(c_28) ); // a(126) , a(127) do not added +2

 carry_save_3inputs #(W+2) cs_3in_31(.a({ sum_01, sum_02, sum_03 }),                                  .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+2) cs_3in_32(.a({ sum_04, sum_05, sum_06 }),                                  .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+2) cs_3in_33(.a({ sum_07, sum_08, sum_09 }),                                  .sum(sum_33), .cout(c_33) );
 carry_save_3inputs #(W+2) cs_3in_34(.a({ sum_10, sum_11, sum_12 }),                                  .sum(sum_34), .cout(c_34) );
 carry_save_3inputs #(W+2) cs_3in_35(.a({ sum_13, sum_14, sum_15 }),                                  .sum(sum_35), .cout(c_35) );
 carry_save_3inputs #(W+2) cs_3in_36(.a({ sum_16, sum_17, sum_18 }),                                  .sum(sum_36), .cout(c_36) );
 carry_save_3inputs #(W+2) cs_3in_37(.a({ sum_19, sum_20, sum_21 }),                                  .sum(sum_37), .cout(c_37) );
 carry_save_3inputs #(W+2) cs_3in_38(.a({ sum_22, sum_23, sum_24 }),                                  .sum(sum_38), .cout(c_38) );
 carry_save_3inputs #(W+2) cs_3in_39(.a({ sum_25, sum_26, sum_27 }),                                  .sum(sum_39), .cout(c_39) );
 carry_save_3inputs #(W+2) cs_3in_40(.a({ c_01, c_02, c_03 }),                                        .sum(sum_40), .cout(c_40) );
 carry_save_3inputs #(W+2) cs_3in_41(.a({ c_04, c_05, c_06 }),                                        .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+2) cs_3in_42(.a({ c_07, c_08, c_09 }),                                        .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+2) cs_3in_43(.a({ c_10, c_11, c_12 }),                                        .sum(sum_43), .cout(c_43) );
 carry_save_3inputs #(W+2) cs_3in_44(.a({ c_13, c_14, c_15 }),                                        .sum(sum_44), .cout(c_44) );
 carry_save_3inputs #(W+2) cs_3in_45(.a({ c_16, c_17, c_18 }),                                        .sum(sum_45), .cout(c_45) );
 carry_save_3inputs #(W+2) cs_3in_46(.a({ c_19, c_20, c_21 }),                                        .sum(sum_46), .cout(c_46) );
 carry_save_3inputs #(W+2) cs_3in_47(.a({ c_22, c_23, c_24 }),                                        .sum(sum_47), .cout(c_47) );
 carry_save_3inputs #(W+2) cs_3in_48(.a({ c_25, c_26, c_27 }),                                        .sum(sum_48), .cout(c_48) ); 
 carry_save_3inputs #(W+2) cs_3in_49(.a({ sum_28, {2'b00, a[126*W +: W ]}, {2'b00, a[127*W +: W ]}}), .sum(sum_49), .cout(c_49) ); // c_28 do not added


 carry_save_3inputs #(W+3) cs_3in_51(.a({ sum_31, sum_32, sum_33 }), .sum(sum_51), .cout(c_51) );
 carry_save_3inputs #(W+3) cs_3in_52(.a({ sum_34, sum_35, sum_36 }), .sum(sum_52), .cout(c_52) );
 carry_save_3inputs #(W+3) cs_3in_53(.a({ sum_37, sum_38, sum_39 }), .sum(sum_53), .cout(c_53) );
 carry_save_3inputs #(W+3) cs_3in_54(.a({ sum_40, sum_41, sum_42 }), .sum(sum_54), .cout(c_54) );
 carry_save_3inputs #(W+3) cs_3in_55(.a({ sum_43, sum_44, sum_45 }), .sum(sum_55), .cout(c_55) );
 carry_save_3inputs #(W+3) cs_3in_56(.a({ sum_46, sum_47, sum_48 }), .sum(sum_56), .cout(c_56) ); 
 carry_save_3inputs #(W+3) cs_3in_57(.a({ c_31,   c_32,   c_33   }), .sum(sum_57), .cout(c_57) );
 carry_save_3inputs #(W+3) cs_3in_58(.a({ c_34,   c_35,   c_36   }), .sum(sum_58), .cout(c_58) );
 carry_save_3inputs #(W+3) cs_3in_59(.a({ c_37,   c_38,   c_39   }), .sum(sum_59), .cout(c_59) );
 carry_save_3inputs #(W+3) cs_3in_60(.a({ c_40,   c_41,   c_42   }), .sum(sum_60), .cout(c_60) );
 carry_save_3inputs #(W+3) cs_3in_61(.a({ c_43,   c_44,   c_45   }), .sum(sum_61), .cout(c_61) );
 carry_save_3inputs #(W+3) cs_3in_62(.a({ c_46,   c_47,   c_48   }), .sum(sum_62), .cout(c_62) ); 
 carry_save_3inputs #(W+3) cs_3in_63(.a({ sum_49,c_49,{1'b0,c_28}}), .sum(sum_63), .cout(c_63) ); 

 carry_save_3inputs #(W+4) cs_3in_71(.a({ sum_51, sum_52, sum_53 }), .sum(sum_71), .cout(c_71) );
 carry_save_3inputs #(W+4) cs_3in_72(.a({ sum_54, sum_55, sum_56 }), .sum(sum_72), .cout(c_72) );
 carry_save_3inputs #(W+4) cs_3in_73(.a({ sum_57, sum_58, sum_59 }), .sum(sum_73), .cout(c_73) );
 carry_save_3inputs #(W+4) cs_3in_74(.a({ sum_60, sum_61, sum_62 }), .sum(sum_74), .cout(c_74) );
 carry_save_3inputs #(W+4) cs_3in_75(.a({ c_51  , c_52  , c_53   }), .sum(sum_75), .cout(c_75) );
 carry_save_3inputs #(W+4) cs_3in_76(.a({ c_54  , c_55  , c_56   }), .sum(sum_76), .cout(c_76) );
 carry_save_3inputs #(W+4) cs_3in_77(.a({ c_57  , c_58  , c_59   }), .sum(sum_77), .cout(c_77) );
 carry_save_3inputs #(W+4) cs_3in_78(.a({ c_60  , c_61  , c_62   }), .sum(sum_78), .cout(c_78) ); //sum_63, c_63 do not added

 carry_save_3inputs #(W+5) cs_3in_81(.a({ sum_71, sum_72, sum_73       }), .sum(sum_81), .cout(c_81) );
 carry_save_3inputs #(W+5) cs_3in_82(.a({ sum_74, sum_75, sum_76       }), .sum(sum_82), .cout(c_82) );
 carry_save_3inputs #(W+5) cs_3in_83(.a({ c_71  , c_72  , c_73         }), .sum(sum_83), .cout(c_83) );
 carry_save_3inputs #(W+5) cs_3in_84(.a({ c_74  , c_75  , c_76         }), .sum(sum_84), .cout(c_84) );
 carry_save_3inputs #(W+5) cs_3in_85(.a({ sum_77, c_77  , {1'b0,sum_63}}), .sum(sum_85), .cout(c_85) );
 carry_save_3inputs #(W+5) cs_3in_86(.a({ sum_78, c_78  , {1'b0,c_63}  }), .sum(sum_86), .cout(c_86) );

 carry_save_3inputs #(W+6) cs_3in_91(.a({ sum_81, sum_82, sum_83 }), .sum(sum_91), .cout(c_91) );
 carry_save_3inputs #(W+6) cs_3in_92(.a({ sum_84, sum_85, sum_86 }), .sum(sum_92), .cout(c_92) );
 carry_save_3inputs #(W+6) cs_3in_93(.a({ c_81  , c_82  , c_83   }), .sum(sum_93), .cout(c_93) );
 carry_save_3inputs #(W+6) cs_3in_94(.a({ c_84  , c_85  , c_86   }), .sum(sum_94), .cout(c_94) );
  
carry_save_8inputs #(W+7) cs_7in (.a({ sum_91, sum_92, sum_93, sum_94, c_91, c_92, c_93, c_94  }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+6  :0];
assign sum  = sum5 [W+6  :0];


endmodule

////////////////////////////////////
// Carry Save 256 inputs 
////////////////////////////////////

module carry_save_256inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [256*W-1:0] a; //, b,c,d;
output [W+7  :0] sum;
output [W+7  :0] cout;

wire [W:0] sum000, c000, sum003, c003, sum006, c006, sum009, c009, sum012, c012, sum015, c015, sum018, c018, sum021, c021; 
wire [W:0] sum024, c024, sum027, c027, sum030, c030, sum033, c033, sum036, c036, sum039, c039, sum042, c042, sum045, c045; 
wire [W:0] sum048, c048, sum051, c051, sum054, c054, sum057, c057, sum060, c060, sum063, c063, sum066, c066, sum069, c069; 
wire [W:0] sum072, c072, sum075, c075, sum078, c078, sum081, c081, sum084, c084, sum087, c087, sum090, c090, sum093, c093; 
wire [W:0] sum096, c096, sum099, c099, sum102, c102, sum105, c105, sum108, c108, sum111, c111, sum114, c114, sum117, c117, sum120, c120, sum123, c123;
wire [W:0] sum126, c126, sum129, c129, sum132, c132, sum135, c135, sum138, c138, sum141, c141, sum144, c144, sum147, c147;
wire [W:0] sum150, c150, sum153, c153, sum156, c156, sum159, c159, sum162, c162, sum165, c165, sum168, c168, sum171, c171;
wire [W:0] sum174, c174, sum177, c177, sum180, c180, sum183, c183, sum186, c186, sum189, c189, sum192, c192, sum195, c195;
wire [W:0] sum198, c198, sum201, c201, sum204, c204, sum207, c207, sum210, c210, sum213, c213, sum216, c216, sum219, c219;
wire [W:0] sum222, c222, sum225, c225, sum228, c228, sum231, c231, sum234, c234, sum237, c237, sum240, c240, sum243, c243, sum246, c246, sum249, c249, sum252, c252; 

wire [W+1:0] sum_01, c_01, sum_02, c_02, sum_03, c_03, sum_04, c_04, sum_05, c_05, sum_06, c_06, sum_07, c_07, sum_08, c_08;
wire [W+1:0] sum_09, c_09, sum_10, c_10, sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16;
wire [W+1:0] sum_17, c_17, sum_18, c_18, sum_19, c_19, sum_20, c_20, sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+1:0] sum_25, c_25, sum_26, c_26, sum_27, c_27, sum_28, c_28;
wire [W+1:0] sum_29, c_29, sum_30, c_30, sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34, sum_35, c_35, sum_36, c_36;
wire [W+1:0] sum_37, c_37, sum_38, c_38, sum_39, c_39, sum_40, c_40, sum_41, c_41, sum_42, c_42, sum_43, c_43, sum_44, c_44;
wire [W+1:0] sum_45, c_45, sum_46, c_46, sum_47, c_47, sum_48, c_48, sum_49, c_49, sum_50, c_50, sum_51, c_51, sum_52, c_52;
wire [W+1:0] sum_53, c_53, sum_54, c_54, sum_55, c_55, sum_56, c_56, sum_57, c_57;

wire [W+2:0] sum_61, c_61, sum_62, c_62, sum_63, c_63, sum_64, c_64, sum_65, c_65, sum_66, c_66, sum_67, c_67, sum_68, c_68; 
wire [W+2:0] sum_69, c_69, sum_70, c_70, sum_71, c_71, sum_72, c_72, sum_73, c_73, sum_74, c_74, sum_75, c_75, sum_76, c_76; 
wire [W+2:0] sum_77, c_77, sum_78, c_78, sum_79, c_79, sum_80, c_80, sum_81, c_81, sum_82, c_82, sum_83, c_83, sum_84, c_84; 
wire [W+2:0] sum_85, c_85, sum_86, c_86, sum_87, c_87, sum_88, c_88, sum_89, c_89, sum_90, c_90, sum_91, c_91, sum_92, c_92; 
wire [W+2:0] sum_93, c_93, sum_94, c_94, sum_95, c_95, sum_96, c_96, sum_97, c_97, sum_98, c_98;

wire [W+3:0] sum_301, c_301, sum_302, c_302, sum_303, c_303, sum_304, c_304, sum_305, c_305, sum_306, c_306, sum_307, c_307, sum_308, c_308; 
wire [W+3:0] sum_309, c_309, sum_310, c_310, sum_311, c_311, sum_312, c_312, sum_313, c_313, sum_314, c_314, sum_315, c_315, sum_316, c_316;
wire [W+3:0] sum_317, c_317, sum_318, c_318, sum_319, c_319, sum_320, c_320, sum_321, c_321, sum_322, c_322, sum_323, c_323, sum_324, c_324, sum_325, c_325;

wire [W+4:0] sum_331, c_331, sum_332, c_332, sum_333, c_333, sum_334, c_334, sum_335, c_335, sum_336, c_336, sum_337, c_337, sum_338, c_338;
wire [W+4:0] sum_339, c_339, sum_340, c_340, sum_341, c_341, sum_342, c_342, sum_343, c_343, sum_344, c_344, sum_345, c_345, sum_346, c_346, sum_347, c_347; 


wire [W+5:0] sum_351, c_351, sum_352, c_352, sum_353, c_353, sum_354, c_354, sum_355, c_355, sum_356, c_356, sum_357, c_357, sum_358, c_358;
wire [W+5:0] sum_359, c_359, sum_360, c_360, sum_361, c_361;

wire [W+6:0] sum_371, c_371, sum_372, c_372, sum_373, c_373, sum_374, c_374, sum_375, c_375, sum_376, c_376, sum_377, c_377; 

wire [W+7:0] sum_381, c_381, sum_382, c_382, sum_383, c_383, sum_384, c_384, sum_385, c_385; 
wire [W+8:0] sum_391, c_391, sum_392, c_392, sum_393, c_393; 

wire [W+11:0] sum5, cout5;

wire [W+11:0]  test_in, test_1_stage, test_2_stage, test_3_stage, test_4_stage, test_5_stage, test_6_stage, test_7_stage, test_8_stage, test_9_stage, test_preout, test_out;
assign test_in = a[  0*W +: W] + a[  1*W +: W] + a[  2*W +: W] + a[  3*W +: W] + a[  4*W +: W] + a[  5*W +: W] + a[  6*W +: W] + a[  7*W +: W] + a[  8*W +: W] + a[  9*W +: W] + 
                 a[ 10*W +: W] + a[ 11*W +: W] + a[ 12*W +: W] + a[ 13*W +: W] + a[ 14*W +: W] + a[ 15*W +: W] + a[ 16*W +: W] + a[ 17*W +: W] + a[ 18*W +: W] + a[ 19*W +: W] + 
                 a[ 20*W +: W] + a[ 21*W +: W] + a[ 22*W +: W] + a[ 23*W +: W] + a[ 24*W +: W] + a[ 25*W +: W] + a[ 26*W +: W] + a[ 27*W +: W] + a[ 28*W +: W] + a[ 29*W +: W] + 
                 a[ 30*W +: W] + a[ 31*W +: W] + a[ 32*W +: W] + a[ 33*W +: W] + a[ 34*W +: W] + a[ 35*W +: W] + a[ 36*W +: W] + a[ 37*W +: W] + a[ 38*W +: W] + a[ 39*W +: W] +
                 a[ 40*W +: W] + a[ 41*W +: W] + a[ 42*W +: W] + a[ 43*W +: W] + a[ 44*W +: W] + a[ 45*W +: W] + a[ 46*W +: W] + a[ 47*W +: W] + a[ 48*W +: W] + a[ 49*W +: W] +
                 a[ 50*W +: W] + a[ 51*W +: W] + a[ 52*W +: W] + a[ 53*W +: W] + a[ 54*W +: W] + a[ 55*W +: W] + a[ 56*W +: W] + a[ 57*W +: W] + a[ 58*W +: W] + a[ 59*W +: W] + 
                 a[ 60*W +: W] + a[ 61*W +: W] + a[ 62*W +: W] + a[ 63*W +: W] + a[ 64*W +: W] + a[ 65*W +: W] + a[ 66*W +: W] + a[ 67*W +: W] + a[ 68*W +: W] + a[ 69*W +: W] + 
                 a[ 70*W +: W] + a[ 71*W +: W] + a[ 72*W +: W] + a[ 73*W +: W] + a[ 74*W +: W] + a[ 75*W +: W] + a[ 76*W +: W] + a[ 77*W +: W] + a[ 78*W +: W] + a[ 79*W +: W] + 
                 a[ 80*W +: W] + a[ 81*W +: W] + a[ 82*W +: W] + a[ 83*W +: W] + a[ 84*W +: W] + a[ 85*W +: W] + a[ 86*W +: W] + a[ 87*W +: W] + a[ 88*W +: W] + a[ 89*W +: W] + 
                 a[ 90*W +: W] + a[ 91*W +: W] + a[ 92*W +: W] + a[ 93*W +: W] + a[ 94*W +: W] + a[ 95*W +: W] + a[ 96*W +: W] + a[ 97*W +: W] + a[ 98*W +: W] + a[ 99*W +: W] +
                 a[100*W +: W] + a[101*W +: W] + a[102*W +: W] + a[103*W +: W] + a[104*W +: W] + a[105*W +: W] + a[106*W +: W] + a[107*W +: W] + a[108*W +: W] + a[109*W +: W] + 
                 a[110*W +: W] + a[111*W +: W] + a[112*W +: W] + a[113*W +: W] + a[114*W +: W] + a[115*W +: W] + a[116*W +: W] + a[117*W +: W] + a[118*W +: W] + a[119*W +: W] + 
                 a[120*W +: W] + a[121*W +: W] + a[122*W +: W] + a[123*W +: W] + a[124*W +: W] + a[125*W +: W] + a[126*W +: W] + a[127*W +: W] + a[128*W +: W] + a[129*W +: W] +
                 a[130*W +: W] + a[131*W +: W] + a[132*W +: W] + a[133*W +: W] + a[134*W +: W] + a[135*W +: W] + a[136*W +: W] + a[137*W +: W] + a[138*W +: W] + a[139*W +: W] + 
                 a[140*W +: W] + a[141*W +: W] + a[142*W +: W] + a[143*W +: W] + a[144*W +: W] + a[145*W +: W] + a[146*W +: W] + a[147*W +: W] + a[148*W +: W] + a[149*W +: W] +
                 a[150*W +: W] + a[151*W +: W] + a[152*W +: W] + a[153*W +: W] + a[154*W +: W] + a[155*W +: W] + a[156*W +: W] + a[157*W +: W] + a[158*W +: W] + a[159*W +: W] + 
                 a[160*W +: W] + a[161*W +: W] + a[162*W +: W] + a[163*W +: W] + a[164*W +: W] + a[165*W +: W] + a[166*W +: W] + a[167*W +: W] + a[168*W +: W] + a[169*W +: W] + 
                 a[170*W +: W] + a[171*W +: W] + a[172*W +: W] + a[173*W +: W] + a[174*W +: W] + a[175*W +: W] + a[176*W +: W] + a[177*W +: W] + a[178*W +: W] + a[179*W +: W] + 
                 a[180*W +: W] + a[181*W +: W] + a[182*W +: W] + a[183*W +: W] + a[184*W +: W] + a[185*W +: W] + a[186*W +: W] + a[187*W +: W] + a[188*W +: W] + a[189*W +: W] + 
                 a[190*W +: W] + a[191*W +: W] + a[192*W +: W] + a[193*W +: W] + a[194*W +: W] + a[195*W +: W] + a[196*W +: W] + a[197*W +: W] + a[198*W +: W] + a[199*W +: W] +
                 a[200*W +: W] + a[201*W +: W] + a[202*W +: W] + a[203*W +: W] + a[204*W +: W] + a[205*W +: W] + a[206*W +: W] + a[207*W +: W] + a[208*W +: W] + a[209*W +: W] + 
                 a[210*W +: W] + a[211*W +: W] + a[212*W +: W] + a[213*W +: W] + a[214*W +: W] + a[215*W +: W] + a[216*W +: W] + a[217*W +: W] + a[218*W +: W] + a[219*W +: W] + 
                 a[220*W +: W] + a[221*W +: W] + a[222*W +: W] + a[223*W +: W] + a[224*W +: W] + a[225*W +: W] + a[226*W +: W] + a[227*W +: W] + a[228*W +: W] + a[229*W +: W] +
                 a[230*W +: W] + a[231*W +: W] + a[232*W +: W] + a[233*W +: W] + a[234*W +: W] + a[235*W +: W] + a[236*W +: W] + a[237*W +: W] + a[238*W +: W] + a[239*W +: W] + 
                 a[240*W +: W] + a[241*W +: W] + a[242*W +: W] + a[243*W +: W] + a[244*W +: W] + a[245*W +: W] + a[246*W +: W] + a[247*W +: W] + a[248*W +: W] + a[249*W +: W] +
                 a[250*W +: W] + a[251*W +: W] + a[252*W +: W] + a[253*W +: W] + a[254*W +: W] + a[255*W +: W];

assign test_1_stage = 
         sum000 + c000 + sum003 + c003 + sum006 + c006 + sum009 + c009 + sum012 + c012 + sum015 + c015 + sum018 + c018 + sum021 + c021 + a[255*W +:W] +
         sum024 + c024 + sum027 + c027 + sum030 + c030 + sum033 + c033 + sum036 + c036 + sum039 + c039 + sum042 + c042 + sum045 + c045 + 
         sum048 + c048 + sum051 + c051 + sum054 + c054 + sum057 + c057 + sum060 + c060 + sum063 + c063 + sum066 + c066 + sum069 + c069 + 
         sum072 + c072 + sum075 + c075 + sum078 + c078 + sum081 + c081 + sum084 + c084 + sum087 + c087 + sum090 + c090 + sum093 + c093 + 
         sum096 + c096 + sum099 + c099 + sum102 + c102 + sum105 + c105 + sum108 + c108 + sum111 + c111 + sum114 + c114 + sum117 + c117 + sum120 + c120 + sum123 + c123+
         sum126 + c126 + sum129 + c129 + sum132 + c132 + sum135 + c135 + sum138 + c138 + sum141 + c141 + sum144 + c144 + sum147 + c147 +
         sum150 + c150 + sum153 + c153 + sum156 + c156 + sum159 + c159 + sum162 + c162 + sum165 + c165 + sum168 + c168 + sum171 + c171 +
         sum174 + c174 + sum177 + c177 + sum180 + c180 + sum183 + c183 + sum186 + c186 + sum189 + c189 + sum192 + c192 + sum195 + c195 +
         sum198 + c198 + sum201 + c201 + sum204 + c204 + sum207 + c207 + sum210 + c210 + sum213 + c213 + sum216 + c216 + sum219 + c219 +
         sum222 + c222 + sum225 + c225 + sum228 + c228 + sum231 + c231 + sum234 + c234 + sum237 + c237 + sum240 + c240 + sum243 + c243 + sum246 + c246 + sum249 + c249 + sum252 + c252;
assign test_2_stage = 
         sum_01 + c_01 + sum_02 + c_02 + sum_03 + c_03 + sum_04 + c_04 + sum_05 + c_05 + sum_06 + c_06 + sum_07 + c_07 + sum_08 + c_08 + 
         sum_09 + c_09 + sum_10 + c_10 + sum_11 + c_11 + sum_12 + c_12 + sum_13 + c_13 + sum_14 + c_14 + sum_15 + c_15 + sum_16 + c_16 +
         sum_17 + c_17 + sum_18 + c_18 + sum_19 + c_19 + sum_20 + c_20 + sum_21 + c_21 + sum_22 + c_22 + sum_23 + c_23 + sum_24 + c_24 +
         sum_25 + c_25 + sum_26 + c_26 + sum_27 + c_27 + sum_28 + c_28 +
         sum_29 + c_29 + sum_30 + c_30 + sum_31 + c_31 + sum_32 + c_32 + sum_33 + c_33 + sum_34 + c_34 + sum_35 + c_35 + sum_36 + c_36 + 
         sum_37 + c_37 + sum_38 + c_38 + sum_39 + c_39 + sum_40 + c_40 + sum_41 + c_41 + sum_42 + c_42 + sum_43 + c_43 + sum_44 + c_44 + 
         sum_45 + c_45 + sum_46 + c_46 + sum_47 + c_47 + sum_48 + c_48 + sum_49 + c_49 + sum_50 + c_50 + sum_51 + c_51 + sum_52 + c_52 + 
         sum_53 + c_53 + sum_54 + c_54 + sum_55 + c_55 + sum_56 + c_56 + sum_57 + c_57;

assign test_3_stage = 
        sum_61 + c_61 + sum_62 + c_62 + sum_63 + c_63 + sum_64 + c_64 + sum_65 + c_65 + sum_66 + c_66 + sum_67 + c_67 + sum_68 + c_68 + 
        sum_69 + c_69 + sum_70 + c_70 + sum_71 + c_71 + sum_72 + c_72 + sum_73 + c_73 + sum_74 + c_74 + sum_75 + c_75 + sum_76 + c_76 + 
        sum_77 + c_77 + sum_78 + c_78 + sum_79 + c_79 + sum_80 + c_80 + sum_81 + c_81 + sum_82 + c_82 + sum_83 + c_83 + sum_84 + c_84 + 
        sum_85 + c_85 + sum_86 + c_86 + sum_87 + c_87 + sum_88 + c_88 + sum_89 + c_89 + sum_90 + c_90 + sum_91 + c_91 + sum_92 + c_92 + 
        sum_93 + c_93 + sum_94 + c_94 + sum_95 + c_95 + sum_96 + c_96 + sum_97 + c_97 + sum_98 + c_98;

assign test_4_stage = 
       sum_301 + c_301 + sum_302 + c_302 + sum_303 + c_303 + sum_304 + c_304 + sum_305 + c_305 + sum_306 + c_306 + sum_307 + c_307 + sum_308 + c_308 + c_98 +
       sum_309 + c_309 + sum_310 + c_310 + sum_311 + c_311 + sum_312 + c_312 + sum_313 + c_313 + sum_314 + c_314 + sum_315 + c_315 + sum_316 + c_316 +
       sum_317 + c_317 + sum_318 + c_318 + sum_319 + c_319 + sum_320 + c_320 + sum_321 + c_321 + sum_322 + c_322 + sum_323 + c_323 + sum_324 + c_324 + sum_325 + c_325;
assign test_5_stage = 
       sum_331 + c_331 + sum_332 + c_332 + sum_333 + c_333 + sum_334 + c_334 + sum_335 + c_335 + sum_336 + c_336 + sum_337 + c_337 + sum_338 + c_338 +
       sum_339 + c_339 + sum_340 + c_340 + sum_341 + c_341 + sum_342 + c_342 + sum_343 + c_343 + sum_344 + c_344 + sum_345 + c_345 + sum_346 + c_346 + sum_347 + c_347; 
assign test_6_stage = sum_359 + c_359 + sum_360 + c_360 + sum_361 + c_361 +      c_347 +
                      sum_351 + c_351 + sum_352 + c_352 + sum_353 + c_353 + sum_354 + c_354 + sum_355 + c_355 + sum_356 + c_356 + sum_357 + c_357 + sum_358 + c_358;

assign test_7_stage = sum_371 + c_371 + sum_372 + c_372 + sum_373 + c_373 + sum_374 + c_374 + sum_375 + c_375 + sum_376 + c_376 + sum_377 + c_377 +
                      sum_361 + c_361;
assign test_8_stage = sum_381 + c_381 + sum_382 + c_382 + sum_383 + c_383 + sum_384 + c_384 + sum_385 + c_385 +     c_377;
assign test_9_stage = sum_391 + c_391 + sum_392 + c_392 + sum_393 + c_393  +      sum_385 + c_385;
assign test_preout = sum5 + cout5;
assign test_out    = sum + cout;

 carry_save_3inputs #(W) cs_3in_000 (.a(a[  0*W +: 3*W ]), .sum(sum000), .cout(c000) );
 carry_save_3inputs #(W) cs_3in_003 (.a(a[  3*W +: 3*W ]), .sum(sum003), .cout(c003) );
 carry_save_3inputs #(W) cs_3in_006 (.a(a[  6*W +: 3*W ]), .sum(sum006), .cout(c006) );
 carry_save_3inputs #(W) cs_3in_009 (.a(a[  9*W +: 3*W ]), .sum(sum009), .cout(c009) );
 carry_save_3inputs #(W) cs_3in_012 (.a(a[ 12*W +: 3*W ]), .sum(sum012), .cout(c012) );
 carry_save_3inputs #(W) cs_3in_015 (.a(a[ 15*W +: 3*W ]), .sum(sum015), .cout(c015) );
 carry_save_3inputs #(W) cs_3in_018 (.a(a[ 18*W +: 3*W ]), .sum(sum018), .cout(c018) );
 carry_save_3inputs #(W) cs_3in_021 (.a(a[ 21*W +: 3*W ]), .sum(sum021), .cout(c021) );
 carry_save_3inputs #(W) cs_3in_024 (.a(a[ 24*W +: 3*W ]), .sum(sum024), .cout(c024) );
 carry_save_3inputs #(W) cs_3in_027 (.a(a[ 27*W +: 3*W ]), .sum(sum027), .cout(c027) );
 carry_save_3inputs #(W) cs_3in_030 (.a(a[ 30*W +: 3*W ]), .sum(sum030), .cout(c030) );
 carry_save_3inputs #(W) cs_3in_033 (.a(a[ 33*W +: 3*W ]), .sum(sum033), .cout(c033) );
 carry_save_3inputs #(W) cs_3in_036 (.a(a[ 36*W +: 3*W ]), .sum(sum036), .cout(c036) );
 carry_save_3inputs #(W) cs_3in_039 (.a(a[ 39*W +: 3*W ]), .sum(sum039), .cout(c039) );
 carry_save_3inputs #(W) cs_3in_042 (.a(a[ 42*W +: 3*W ]), .sum(sum042), .cout(c042) );
 carry_save_3inputs #(W) cs_3in_045 (.a(a[ 45*W +: 3*W ]), .sum(sum045), .cout(c045) );
 carry_save_3inputs #(W) cs_3in_048 (.a(a[ 48*W +: 3*W ]), .sum(sum048), .cout(c048) );
 carry_save_3inputs #(W) cs_3in_051 (.a(a[ 51*W +: 3*W ]), .sum(sum051), .cout(c051) );
 carry_save_3inputs #(W) cs_3in_054 (.a(a[ 54*W +: 3*W ]), .sum(sum054), .cout(c054) );
 carry_save_3inputs #(W) cs_3in_057 (.a(a[ 57*W +: 3*W ]), .sum(sum057), .cout(c057) );
 carry_save_3inputs #(W) cs_3in_060 (.a(a[ 60*W +: 3*W ]), .sum(sum060), .cout(c060) );
 carry_save_3inputs #(W) cs_3in_063 (.a(a[ 63*W +: 3*W ]), .sum(sum063), .cout(c063) );
 carry_save_3inputs #(W) cs_3in_066 (.a(a[ 66*W +: 3*W ]), .sum(sum066), .cout(c066) );
 carry_save_3inputs #(W) cs_3in_069 (.a(a[ 69*W +: 3*W ]), .sum(sum069), .cout(c069) );
 carry_save_3inputs #(W) cs_3in_072 (.a(a[ 72*W +: 3*W ]), .sum(sum072), .cout(c072) );
 carry_save_3inputs #(W) cs_3in_075 (.a(a[ 75*W +: 3*W ]), .sum(sum075), .cout(c075) );
 carry_save_3inputs #(W) cs_3in_078 (.a(a[ 78*W +: 3*W ]), .sum(sum078), .cout(c078) );
 carry_save_3inputs #(W) cs_3in_081 (.a(a[ 81*W +: 3*W ]), .sum(sum081), .cout(c081) );
 carry_save_3inputs #(W) cs_3in_084 (.a(a[ 84*W +: 3*W ]), .sum(sum084), .cout(c084) );
 carry_save_3inputs #(W) cs_3in_087 (.a(a[ 87*W +: 3*W ]), .sum(sum087), .cout(c087) );
 carry_save_3inputs #(W) cs_3in_090 (.a(a[ 90*W +: 3*W ]), .sum(sum090), .cout(c090) );
 carry_save_3inputs #(W) cs_3in_093 (.a(a[ 93*W +: 3*W ]), .sum(sum093), .cout(c093) );
 carry_save_3inputs #(W) cs_3in_096 (.a(a[ 96*W +: 3*W ]), .sum(sum096), .cout(c096) );
 carry_save_3inputs #(W) cs_3in_099 (.a(a[ 99*W +: 3*W ]), .sum(sum099), .cout(c099) );
 carry_save_3inputs #(W) cs_3in_102 (.a(a[102*W +: 3*W ]), .sum(sum102), .cout(c102) );
 carry_save_3inputs #(W) cs_3in_105 (.a(a[105*W +: 3*W ]), .sum(sum105), .cout(c105) );
 carry_save_3inputs #(W) cs_3in_108 (.a(a[108*W +: 3*W ]), .sum(sum108), .cout(c108) );
 carry_save_3inputs #(W) cs_3in_111 (.a(a[111*W +: 3*W ]), .sum(sum111), .cout(c111) );
 carry_save_3inputs #(W) cs_3in_114 (.a(a[114*W +: 3*W ]), .sum(sum114), .cout(c114) );
 carry_save_3inputs #(W) cs_3in_117 (.a(a[117*W +: 3*W ]), .sum(sum117), .cout(c117) );
 carry_save_3inputs #(W) cs_3in_120 (.a(a[120*W +: 3*W ]), .sum(sum120), .cout(c120) );
 carry_save_3inputs #(W) cs_3in_123 (.a(a[123*W +: 3*W ]), .sum(sum123), .cout(c123) ); 

 carry_save_3inputs #(W) cs_3in_126 (.a(a[126*W +: 3*W ]), .sum(sum126), .cout(c126) );
 carry_save_3inputs #(W) cs_3in_129 (.a(a[129*W +: 3*W ]), .sum(sum129), .cout(c129) );
 carry_save_3inputs #(W) cs_3in_132 (.a(a[132*W +: 3*W ]), .sum(sum132), .cout(c132) );
 carry_save_3inputs #(W) cs_3in_135 (.a(a[135*W +: 3*W ]), .sum(sum135), .cout(c135) );
 carry_save_3inputs #(W) cs_3in_138 (.a(a[138*W +: 3*W ]), .sum(sum138), .cout(c138) );
 carry_save_3inputs #(W) cs_3in_141 (.a(a[141*W +: 3*W ]), .sum(sum141), .cout(c141) );
 carry_save_3inputs #(W) cs_3in_144 (.a(a[144*W +: 3*W ]), .sum(sum144), .cout(c144) );
 carry_save_3inputs #(W) cs_3in_147 (.a(a[147*W +: 3*W ]), .sum(sum147), .cout(c147) );
 carry_save_3inputs #(W) cs_3in_150 (.a(a[150*W +: 3*W ]), .sum(sum150), .cout(c150) );
 carry_save_3inputs #(W) cs_3in_153 (.a(a[153*W +: 3*W ]), .sum(sum153), .cout(c153) );
 carry_save_3inputs #(W) cs_3in_156 (.a(a[156*W +: 3*W ]), .sum(sum156), .cout(c156) );
 carry_save_3inputs #(W) cs_3in_159 (.a(a[159*W +: 3*W ]), .sum(sum159), .cout(c159) );
 carry_save_3inputs #(W) cs_3in_162 (.a(a[162*W +: 3*W ]), .sum(sum162), .cout(c162) );
 carry_save_3inputs #(W) cs_3in_165 (.a(a[165*W +: 3*W ]), .sum(sum165), .cout(c165) );
 carry_save_3inputs #(W) cs_3in_168 (.a(a[168*W +: 3*W ]), .sum(sum168), .cout(c168) );
 carry_save_3inputs #(W) cs_3in_171 (.a(a[171*W +: 3*W ]), .sum(sum171), .cout(c171) );
 carry_save_3inputs #(W) cs_3in_174 (.a(a[174*W +: 3*W ]), .sum(sum174), .cout(c174) );
 carry_save_3inputs #(W) cs_3in_177 (.a(a[177*W +: 3*W ]), .sum(sum177), .cout(c177) );
 carry_save_3inputs #(W) cs_3in_180 (.a(a[180*W +: 3*W ]), .sum(sum180), .cout(c180) );
 carry_save_3inputs #(W) cs_3in_183 (.a(a[183*W +: 3*W ]), .sum(sum183), .cout(c183) );
 carry_save_3inputs #(W) cs_3in_186 (.a(a[186*W +: 3*W ]), .sum(sum186), .cout(c186) );
 carry_save_3inputs #(W) cs_3in_189 (.a(a[189*W +: 3*W ]), .sum(sum189), .cout(c189) );
 carry_save_3inputs #(W) cs_3in_192 (.a(a[192*W +: 3*W ]), .sum(sum192), .cout(c192) );
 carry_save_3inputs #(W) cs_3in_195 (.a(a[195*W +: 3*W ]), .sum(sum195), .cout(c195) );
 carry_save_3inputs #(W) cs_3in_198 (.a(a[198*W +: 3*W ]), .sum(sum198), .cout(c198) );
 carry_save_3inputs #(W) cs_3in_201 (.a(a[201*W +: 3*W ]), .sum(sum201), .cout(c201) );
 carry_save_3inputs #(W) cs_3in_204 (.a(a[204*W +: 3*W ]), .sum(sum204), .cout(c204) );
 carry_save_3inputs #(W) cs_3in_207 (.a(a[207*W +: 3*W ]), .sum(sum207), .cout(c207) );
 carry_save_3inputs #(W) cs_3in_210 (.a(a[210*W +: 3*W ]), .sum(sum210), .cout(c210) );
 carry_save_3inputs #(W) cs_3in_213 (.a(a[213*W +: 3*W ]), .sum(sum213), .cout(c213) );
 carry_save_3inputs #(W) cs_3in_216 (.a(a[216*W +: 3*W ]), .sum(sum216), .cout(c216) );
 carry_save_3inputs #(W) cs_3in_219 (.a(a[219*W +: 3*W ]), .sum(sum219), .cout(c219) );
 carry_save_3inputs #(W) cs_3in_222 (.a(a[222*W +: 3*W ]), .sum(sum222), .cout(c222) );
 carry_save_3inputs #(W) cs_3in_225 (.a(a[225*W +: 3*W ]), .sum(sum225), .cout(c225) );
 carry_save_3inputs #(W) cs_3in_228 (.a(a[228*W +: 3*W ]), .sum(sum228), .cout(c228) );
 carry_save_3inputs #(W) cs_3in_231 (.a(a[231*W +: 3*W ]), .sum(sum231), .cout(c231) );
 carry_save_3inputs #(W) cs_3in_234 (.a(a[234*W +: 3*W ]), .sum(sum234), .cout(c234) );
 carry_save_3inputs #(W) cs_3in_237 (.a(a[237*W +: 3*W ]), .sum(sum237), .cout(c237) );
 carry_save_3inputs #(W) cs_3in_240 (.a(a[240*W +: 3*W ]), .sum(sum240), .cout(c240) );
 carry_save_3inputs #(W) cs_3in_243 (.a(a[243*W +: 3*W ]), .sum(sum243), .cout(c243) );
 carry_save_3inputs #(W) cs_3in_246 (.a(a[246*W +: 3*W ]), .sum(sum246), .cout(c246) );
 carry_save_3inputs #(W) cs_3in_249 (.a(a[249*W +: 3*W ]), .sum(sum249), .cout(c249) );
 carry_save_3inputs #(W) cs_3in_252 (.a(a[252*W +: 3*W ]), .sum(sum252), .cout(c252) ); // a(255) do not added


 carry_save_3inputs #(W+1) cs_3in_01(.a({ sum000, sum003, sum006 }),               .sum(sum_01), .cout(c_01) );
 carry_save_3inputs #(W+1) cs_3in_02(.a({ sum009, sum012, sum015 }),               .sum(sum_02), .cout(c_02) );
 carry_save_3inputs #(W+1) cs_3in_03(.a({ sum018, sum021, sum024 }),               .sum(sum_03), .cout(c_03) );
 carry_save_3inputs #(W+1) cs_3in_04(.a({ sum027, sum030, sum033 }),               .sum(sum_04), .cout(c_04) );
 carry_save_3inputs #(W+1) cs_3in_05(.a({ sum036, sum039, sum042 }),               .sum(sum_05), .cout(c_05) );
 carry_save_3inputs #(W+1) cs_3in_06(.a({ sum045, sum048, sum051 }),               .sum(sum_06), .cout(c_06) );
 carry_save_3inputs #(W+1) cs_3in_07(.a({ sum054, sum057, sum060 }),               .sum(sum_07), .cout(c_07) );
 carry_save_3inputs #(W+1) cs_3in_08(.a({ sum063, sum066, sum069 }),               .sum(sum_08), .cout(c_08) );
 carry_save_3inputs #(W+1) cs_3in_09(.a({ sum072, sum075, sum078 }),               .sum(sum_09), .cout(c_09) );
 carry_save_3inputs #(W+1) cs_3in_10(.a({ sum081, sum084, sum087 }),               .sum(sum_10), .cout(c_10) );
 carry_save_3inputs #(W+1) cs_3in_11(.a({ sum090, sum093, sum096 }),               .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+1) cs_3in_12(.a({ sum099, sum102, sum105 }),               .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+1) cs_3in_13(.a({ sum108, sum111, sum114 }),               .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+1) cs_3in_14(.a({ sum117, sum120, sum123 }),               .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+1) cs_3in_15(.a({ sum126, sum129, sum132 }),               .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+1) cs_3in_16(.a({ sum135, sum138, sum141 }),               .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+1) cs_3in_17(.a({ sum144, sum147, sum150 }),               .sum(sum_17), .cout(c_17) );
 carry_save_3inputs #(W+1) cs_3in_18(.a({ sum153, sum156, sum159 }),               .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+1) cs_3in_19(.a({ sum162, sum165, sum168 }),               .sum(sum_19), .cout(c_19) );
 carry_save_3inputs #(W+1) cs_3in_20(.a({ sum171, sum174, sum177 }),               .sum(sum_20), .cout(c_20) );
 carry_save_3inputs #(W+1) cs_3in_21(.a({ sum180, sum183, sum186 }),               .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+1) cs_3in_22(.a({ sum189, sum192, sum195 }),               .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+1) cs_3in_23(.a({ sum198, sum201, sum204 }),               .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+1) cs_3in_24(.a({ sum207, sum210, sum213 }),               .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+1) cs_3in_25(.a({ sum216, sum219, sum222 }),               .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+1) cs_3in_26(.a({ sum225, sum228, sum231 }),               .sum(sum_26), .cout(c_26) );
 carry_save_3inputs #(W+1) cs_3in_27(.a({ sum234, sum237, sum240 }),               .sum(sum_27), .cout(c_27) );
 carry_save_3inputs #(W+1) cs_3in_28(.a({ sum243, sum246, sum249 }),               .sum(sum_28), .cout(c_28) );
 carry_save_3inputs #(W+1) cs_3in_29(.a({ c000, c003, c006 }),                     .sum(sum_29), .cout(c_29) );
 carry_save_3inputs #(W+1) cs_3in_30(.a({ c009, c012, c015 }),                     .sum(sum_30), .cout(c_30) );
 carry_save_3inputs #(W+1) cs_3in_31(.a({ c018, c021, c024 }),                     .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+1) cs_3in_32(.a({ c027, c030, c033 }),                     .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+1) cs_3in_33(.a({ c036, c039, c042 }),                     .sum(sum_33), .cout(c_33) );
 carry_save_3inputs #(W+1) cs_3in_34(.a({ c045, c048, c051 }),                     .sum(sum_34), .cout(c_34) );
 carry_save_3inputs #(W+1) cs_3in_35(.a({ c054, c057, c060 }),                     .sum(sum_35), .cout(c_35) );
 carry_save_3inputs #(W+1) cs_3in_36(.a({ c063, c066, c069 }),                     .sum(sum_36), .cout(c_36) );
 carry_save_3inputs #(W+1) cs_3in_37(.a({ c072, c075, c078 }),                     .sum(sum_37), .cout(c_37) );
 carry_save_3inputs #(W+1) cs_3in_38(.a({ c081, c084, c087 }),                     .sum(sum_38), .cout(c_38) );
 carry_save_3inputs #(W+1) cs_3in_39(.a({ c090, c093, c096 }),                     .sum(sum_39), .cout(c_39) );
 carry_save_3inputs #(W+1) cs_3in_40(.a({ c099, c102, c105 }),                     .sum(sum_40), .cout(c_40) );
 carry_save_3inputs #(W+1) cs_3in_41(.a({ c108, c111, c114 }),                     .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+1) cs_3in_42(.a({ c117, c120, c123 }),                     .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+1) cs_3in_43(.a({ c126, c129, c132 }),                     .sum(sum_43), .cout(c_43) );
 carry_save_3inputs #(W+1) cs_3in_44(.a({ c135, c138, c141 }),                     .sum(sum_44), .cout(c_44) );
 carry_save_3inputs #(W+1) cs_3in_45(.a({ c144, c147, c150 }),                     .sum(sum_45), .cout(c_45) );
 carry_save_3inputs #(W+1) cs_3in_46(.a({ c153, c156, c159 }),                     .sum(sum_46), .cout(c_46) );
 carry_save_3inputs #(W+1) cs_3in_47(.a({ c162, c165, c168 }),                     .sum(sum_47), .cout(c_47) );
 carry_save_3inputs #(W+1) cs_3in_48(.a({ c171, c174, c177 }),                     .sum(sum_48), .cout(c_48) );
 carry_save_3inputs #(W+1) cs_3in_49(.a({ c180, c183, c186 }),                     .sum(sum_49), .cout(c_49) );
 carry_save_3inputs #(W+1) cs_3in_50(.a({ c189, c192, c195 }),                     .sum(sum_50), .cout(c_50) );
 carry_save_3inputs #(W+1) cs_3in_51(.a({ c198, c201, c204 }),                     .sum(sum_51), .cout(c_51) );
 carry_save_3inputs #(W+1) cs_3in_52(.a({ c207, c210, c213 }),                     .sum(sum_52), .cout(c_52) );
 carry_save_3inputs #(W+1) cs_3in_53(.a({ c216, c219, c222 }),                     .sum(sum_53), .cout(c_53) );
 carry_save_3inputs #(W+1) cs_3in_54(.a({ c225, c228, c231 }),                     .sum(sum_54), .cout(c_54) );
 carry_save_3inputs #(W+1) cs_3in_55(.a({ c234, c237, c240 }),                     .sum(sum_55), .cout(c_55) );
 carry_save_3inputs #(W+1) cs_3in_56(.a({ c243, c246, c249 }),                     .sum(sum_56), .cout(c_56) );
 carry_save_3inputs #(W+1) cs_3in_57(.a({ sum252, c252, {1'b0, a[255*W +: W ]} }), .sum(sum_57), .cout(c_57) );

 
 carry_save_3inputs #(W+2) cs_3in_61(.a({ sum_01, sum_02, sum_03 }), .sum(sum_61), .cout(c_61) );
 carry_save_3inputs #(W+2) cs_3in_62(.a({ sum_04, sum_05, sum_06 }), .sum(sum_62), .cout(c_62) );
 carry_save_3inputs #(W+2) cs_3in_63(.a({ sum_07, sum_08, sum_09 }), .sum(sum_63), .cout(c_63) );
 carry_save_3inputs #(W+2) cs_3in_64(.a({ sum_10, sum_11, sum_12 }), .sum(sum_64), .cout(c_64) );
 carry_save_3inputs #(W+2) cs_3in_65(.a({ sum_13, sum_14, sum_15 }), .sum(sum_65), .cout(c_65) );
 carry_save_3inputs #(W+2) cs_3in_66(.a({ sum_16, sum_17, sum_18 }), .sum(sum_66), .cout(c_66) );
 carry_save_3inputs #(W+2) cs_3in_67(.a({ sum_19, sum_20, sum_21 }), .sum(sum_67), .cout(c_67) );
 carry_save_3inputs #(W+2) cs_3in_68(.a({ sum_22, sum_23, sum_24 }), .sum(sum_68), .cout(c_68) );
 carry_save_3inputs #(W+2) cs_3in_69(.a({ sum_25, sum_26, sum_27 }), .sum(sum_69), .cout(c_69) );
 carry_save_3inputs #(W+2) cs_3in_70(.a({ sum_28, sum_29, sum_30 }), .sum(sum_70), .cout(c_70) );
 carry_save_3inputs #(W+2) cs_3in_71(.a({ sum_31, sum_32, sum_33 }), .sum(sum_71), .cout(c_71) );
 carry_save_3inputs #(W+2) cs_3in_72(.a({ sum_34, sum_35, sum_36 }), .sum(sum_72), .cout(c_72) );
 carry_save_3inputs #(W+2) cs_3in_73(.a({ sum_37, sum_38, sum_39 }), .sum(sum_73), .cout(c_73) );
 carry_save_3inputs #(W+2) cs_3in_74(.a({ sum_40, sum_41, sum_42 }), .sum(sum_74), .cout(c_74) );
 carry_save_3inputs #(W+2) cs_3in_75(.a({ sum_43, sum_44, sum_45 }), .sum(sum_75), .cout(c_75) );
 carry_save_3inputs #(W+2) cs_3in_76(.a({ sum_46, sum_47, sum_48 }), .sum(sum_76), .cout(c_76) );
 carry_save_3inputs #(W+2) cs_3in_77(.a({ sum_49, sum_50, sum_51 }), .sum(sum_77), .cout(c_77) );
 carry_save_3inputs #(W+2) cs_3in_78(.a({ sum_52, sum_53, sum_54 }), .sum(sum_78), .cout(c_78) );
 carry_save_3inputs #(W+2) cs_3in_79(.a({ sum_55, sum_56, sum_57 }), .sum(sum_79), .cout(c_79) );
 carry_save_3inputs #(W+2) cs_3in_80(.a({ c_01, c_02, c_03 }),       .sum(sum_80), .cout(c_80) );
 carry_save_3inputs #(W+2) cs_3in_81(.a({ c_04, c_05, c_06 }),       .sum(sum_81), .cout(c_81) );
 carry_save_3inputs #(W+2) cs_3in_82(.a({ c_07, c_08, c_09 }),       .sum(sum_82), .cout(c_82) );
 carry_save_3inputs #(W+2) cs_3in_83(.a({ c_10, c_11, c_12 }),       .sum(sum_83), .cout(c_83) );
 carry_save_3inputs #(W+2) cs_3in_84(.a({ c_13, c_14, c_15 }),       .sum(sum_84), .cout(c_84) );
 carry_save_3inputs #(W+2) cs_3in_85(.a({ c_16, c_17, c_18 }),       .sum(sum_85), .cout(c_85) );
 carry_save_3inputs #(W+2) cs_3in_86(.a({ c_19, c_20, c_21 }),       .sum(sum_86), .cout(c_86) );
 carry_save_3inputs #(W+2) cs_3in_87(.a({ c_22, c_23, c_24 }),       .sum(sum_87), .cout(c_87) );
 carry_save_3inputs #(W+2) cs_3in_88(.a({ c_25, c_26, c_27 }),       .sum(sum_88), .cout(c_88) );
 carry_save_3inputs #(W+2) cs_3in_89(.a({ c_28, c_29, c_30 }),       .sum(sum_89), .cout(c_89) );
 carry_save_3inputs #(W+2) cs_3in_90(.a({ c_31, c_32, c_33 }),       .sum(sum_90), .cout(c_90) );
 carry_save_3inputs #(W+2) cs_3in_91(.a({ c_34, c_35, c_36 }),       .sum(sum_91), .cout(c_91) );
 carry_save_3inputs #(W+2) cs_3in_92(.a({ c_37, c_38, c_39 }),       .sum(sum_92), .cout(c_92) );
 carry_save_3inputs #(W+2) cs_3in_93(.a({ c_40, c_41, c_42 }),       .sum(sum_93), .cout(c_93) );
 carry_save_3inputs #(W+2) cs_3in_94(.a({ c_43, c_44, c_45 }),       .sum(sum_94), .cout(c_94) );
 carry_save_3inputs #(W+2) cs_3in_95(.a({ c_46, c_47, c_48 }),       .sum(sum_95), .cout(c_95) );
 carry_save_3inputs #(W+2) cs_3in_96(.a({ c_49, c_50, c_51 }),       .sum(sum_96), .cout(c_96) );
 carry_save_3inputs #(W+2) cs_3in_97(.a({ c_52, c_53, c_54 }),       .sum(sum_97), .cout(c_97) );
 carry_save_3inputs #(W+2) cs_3in_98(.a({ c_55, c_56, c_57 }),       .sum(sum_98), .cout(c_98) );


 carry_save_3inputs #(W+3) cs_3in_301(.a({ sum_61, sum_62, sum_63 }), .sum(sum_301), .cout(c_301) );
 carry_save_3inputs #(W+3) cs_3in_302(.a({ sum_64, sum_65, sum_66 }), .sum(sum_302), .cout(c_302) );
 carry_save_3inputs #(W+3) cs_3in_303(.a({ sum_67, sum_68, sum_69 }), .sum(sum_303), .cout(c_303) );
 carry_save_3inputs #(W+3) cs_3in_304(.a({ sum_70, sum_71, sum_72 }), .sum(sum_304), .cout(c_304) );
 carry_save_3inputs #(W+3) cs_3in_305(.a({ sum_73, sum_74, sum_75 }), .sum(sum_305), .cout(c_305) );
 carry_save_3inputs #(W+3) cs_3in_306(.a({ sum_76, sum_77, sum_78 }), .sum(sum_306), .cout(c_306) );
 carry_save_3inputs #(W+3) cs_3in_307(.a({ sum_79, sum_80, sum_81 }), .sum(sum_307), .cout(c_307) );
 carry_save_3inputs #(W+3) cs_3in_308(.a({ sum_82, sum_83, sum_84 }), .sum(sum_308), .cout(c_308) );
 carry_save_3inputs #(W+3) cs_3in_309(.a({ sum_85, sum_86, sum_87 }), .sum(sum_309), .cout(c_309) );
 carry_save_3inputs #(W+3) cs_3in_310(.a({ sum_88, sum_89, sum_90 }), .sum(sum_310), .cout(c_310) );
 carry_save_3inputs #(W+3) cs_3in_311(.a({ sum_91, sum_92, sum_93 }), .sum(sum_311), .cout(c_311) );
 carry_save_3inputs #(W+3) cs_3in_312(.a({ sum_94, sum_95, sum_96 }), .sum(sum_312), .cout(c_312) );
 carry_save_3inputs #(W+3) cs_3in_313(.a({ c_61, c_62, c_63}),        .sum(sum_313), .cout(c_313) ); 
 carry_save_3inputs #(W+3) cs_3in_314(.a({ c_64, c_65, c_66}),        .sum(sum_314), .cout(c_314) );
 carry_save_3inputs #(W+3) cs_3in_315(.a({ c_67, c_68, c_69}),        .sum(sum_315), .cout(c_315) );
 carry_save_3inputs #(W+3) cs_3in_316(.a({ c_70, c_71, c_72}),        .sum(sum_316), .cout(c_316) );
 carry_save_3inputs #(W+3) cs_3in_317(.a({ c_73, c_74, c_75}),        .sum(sum_317), .cout(c_317) );
 carry_save_3inputs #(W+3) cs_3in_318(.a({ c_76, c_77, c_78}),        .sum(sum_318), .cout(c_318) );
 carry_save_3inputs #(W+3) cs_3in_319(.a({ c_79, c_80, c_81}),        .sum(sum_319), .cout(c_319) );
 carry_save_3inputs #(W+3) cs_3in_320(.a({ c_82, c_83, c_84}),        .sum(sum_320), .cout(c_320) );
 carry_save_3inputs #(W+3) cs_3in_321(.a({ c_85, c_86, c_87}),        .sum(sum_321), .cout(c_321) );
 carry_save_3inputs #(W+3) cs_3in_322(.a({ c_88, c_89, c_90}),        .sum(sum_322), .cout(c_322) );
 carry_save_3inputs #(W+3) cs_3in_323(.a({ c_91, c_92, c_93}),        .sum(sum_323), .cout(c_323) );
 carry_save_3inputs #(W+3) cs_3in_324(.a({ c_94, c_95, c_96}),        .sum(sum_324), .cout(c_324) );
 carry_save_3inputs #(W+3) cs_3in_325(.a({ sum_97, sum_98,c_97}),     .sum(sum_325), .cout(c_325) ); // c_98 do not added

 carry_save_3inputs #(W+4) cs_3in_331(.a({ sum_301, sum_302, sum_303 }), .sum(sum_331), .cout(c_331) );
 carry_save_3inputs #(W+4) cs_3in_332(.a({ sum_304, sum_305, sum_306 }), .sum(sum_332), .cout(c_332) );
 carry_save_3inputs #(W+4) cs_3in_333(.a({ sum_307, sum_308, sum_309 }), .sum(sum_333), .cout(c_333) );
 carry_save_3inputs #(W+4) cs_3in_334(.a({ sum_310, sum_311, sum_312 }), .sum(sum_334), .cout(c_334) );
 carry_save_3inputs #(W+4) cs_3in_335(.a({ sum_313, sum_314, sum_315 }), .sum(sum_335), .cout(c_335) );
 carry_save_3inputs #(W+4) cs_3in_336(.a({ sum_316, sum_317, sum_318 }), .sum(sum_336), .cout(c_336) );
 carry_save_3inputs #(W+4) cs_3in_337(.a({ sum_319, sum_320, sum_321 }), .sum(sum_337), .cout(c_337) );
 carry_save_3inputs #(W+4) cs_3in_338(.a({ sum_322, sum_323, sum_324 }), .sum(sum_338), .cout(c_338) );
 carry_save_3inputs #(W+4) cs_3in_339(.a({ c_301, c_302, c_303       }), .sum(sum_339), .cout(c_339) );
 carry_save_3inputs #(W+4) cs_3in_340(.a({ c_304, c_305, c_306       }), .sum(sum_340), .cout(c_340) );
 carry_save_3inputs #(W+4) cs_3in_341(.a({ c_307, c_308, c_309       }), .sum(sum_341), .cout(c_341) );
 carry_save_3inputs #(W+4) cs_3in_342(.a({ c_310, c_311, c_312       }), .sum(sum_342), .cout(c_342) );
 carry_save_3inputs #(W+4) cs_3in_343(.a({ c_313, c_314, c_315       }), .sum(sum_343), .cout(c_343) );
 carry_save_3inputs #(W+4) cs_3in_344(.a({ c_316, c_317, c_318       }), .sum(sum_344), .cout(c_344) );
 carry_save_3inputs #(W+4) cs_3in_345(.a({ c_319, c_320, c_321       }), .sum(sum_345), .cout(c_345) );
 carry_save_3inputs #(W+4) cs_3in_346(.a({ c_322, c_323, c_324       }), .sum(sum_346), .cout(c_346) );
 carry_save_3inputs #(W+4) cs_3in_347(.a({ sum_325,c_325,{1'b0, c_98}}), .sum(sum_347), .cout(c_347) );


 carry_save_3inputs #(W+5) cs_3in_351(.a({ sum_331, sum_332, sum_333 }), .sum(sum_351), .cout(c_351) );
 carry_save_3inputs #(W+5) cs_3in_352(.a({ sum_334, sum_335, sum_336 }), .sum(sum_352), .cout(c_352) );
 carry_save_3inputs #(W+5) cs_3in_353(.a({ sum_337, sum_338, sum_339 }), .sum(sum_353), .cout(c_353) );
 carry_save_3inputs #(W+5) cs_3in_354(.a({ sum_340, sum_341, sum_342 }), .sum(sum_354), .cout(c_354) );
 carry_save_3inputs #(W+5) cs_3in_355(.a({ sum_343, sum_344, sum_345 }), .sum(sum_355), .cout(c_355) );
 carry_save_3inputs #(W+5) cs_3in_356(.a({ c_331, c_332, c_333 }),       .sum(sum_356), .cout(c_356) );
 carry_save_3inputs #(W+5) cs_3in_357(.a({ c_334, c_335, c_336 }),       .sum(sum_357), .cout(c_357) );
 carry_save_3inputs #(W+5) cs_3in_358(.a({ c_337, c_338, c_339 }),       .sum(sum_358), .cout(c_358) );
 carry_save_3inputs #(W+5) cs_3in_359(.a({ c_340, c_341, c_342 }),       .sum(sum_359), .cout(c_359) );
 carry_save_3inputs #(W+5) cs_3in_360(.a({ c_343, c_344, c_345 }),       .sum(sum_360), .cout(c_360) );
 carry_save_3inputs #(W+5) cs_3in_361(.a({ sum_346, sum_347,c_346 }),    .sum(sum_361), .cout(c_361) ); // c_347 do not added


 carry_save_3inputs #(W+6) cs_3in_371(.a({ sum_351, sum_352, sum_353 }), .sum(sum_371), .cout(c_371) );
 carry_save_3inputs #(W+6) cs_3in_372(.a({ sum_354, sum_355, sum_356 }), .sum(sum_372), .cout(c_372) );
 carry_save_3inputs #(W+6) cs_3in_373(.a({ sum_357, sum_358, sum_359 }), .sum(sum_373), .cout(c_373) );
 carry_save_3inputs #(W+6) cs_3in_374(.a({ c_351, c_352, c_353       }), .sum(sum_374), .cout(c_374) );
 carry_save_3inputs #(W+6) cs_3in_375(.a({ c_354, c_355, c_356       }), .sum(sum_375), .cout(c_375) );
 carry_save_3inputs #(W+6) cs_3in_376(.a({ c_357, c_358, c_359       }), .sum(sum_376), .cout(c_376) );
 carry_save_3inputs #(W+6) cs_3in_377(.a({ sum_360,c_360,{1'b0,c_347}}), .sum(sum_377), .cout(c_377) ); // sum_361, c_361 do not added
  

 carry_save_3inputs #(W+7) cs_3in_381(.a({ sum_371, sum_372, sum_373             }), .sum(sum_381), .cout(c_381) );
 carry_save_3inputs #(W+7) cs_3in_382(.a({ sum_374, sum_375, sum_376             }), .sum(sum_382), .cout(c_382) );
 carry_save_3inputs #(W+7) cs_3in_383(.a({ c_371, c_372, c_373                   }), .sum(sum_383), .cout(c_383) );
 carry_save_3inputs #(W+7) cs_3in_384(.a({ c_374, c_375, c_376                   }), .sum(sum_384), .cout(c_384) );
 carry_save_3inputs #(W+7) cs_3in_385(.a({ sum_377, {1'b0,sum_361}, {1'b0,c_361} }), .sum(sum_385), .cout(c_385) );  // c_377 do not added

 carry_save_3inputs #(W+8) cs_3in_391(.a({ sum_381, sum_382, sum_383    }), .sum(sum_391), .cout(c_391) );
 carry_save_3inputs #(W+8) cs_3in_392(.a({ c_381, c_382, c_383          }), .sum(sum_392), .cout(c_392) );
 carry_save_3inputs #(W+8) cs_3in_393(.a({ sum_384, c_384, {1'b0,c_377} }), .sum(sum_393), .cout(c_393) ); // sum_385 c_385 do not added


carry_save_8inputs #(W+9) cs_8in (.a({ sum_391, c_391, sum_392, c_392, sum_393, c_393, {1'b0,sum_385}, {1'b0,c_385} }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+7  :0];
assign sum  = sum5 [W+7  :0];


endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
