module carry_save_adder #(
	parameter N      =  1024, // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
	parameter E      =    10, // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  parameter W      =  4  //    input data width
)

(a, sum, cout);
input  [N*W-1 :0] a; 
output [W+E-1 :0] sum;
output [W+E-1 :0] cout;

  generate
    if      (N ==1024) begin : gen_N_1024
      carry_save_1024inputs #(W) cs_1024in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N ==512) begin : gen_N_512
      carry_save_512inputs #(W) cs_512in(.a(a), .sum(sum), .cout(cout)  ); end
    else if (N ==256) begin : gen_N_256
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
    else if (N == 17) begin : gen_N_17
       carry_save_17inputs #(W)  cs_17in(.a(a), .sum(sum), .cout(cout)  ); end
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

wire [W+1:0] sum13;  
wire [W+1:0] c13 ;   
wire [W+2:0] sumE;   
wire [W+2:0] coutE ; 

carry_save_3inputs #(W+1) cs1 (.a({ {a[0*W+W-1], a[ 0*W +: W]} , 
                                    {a[1*W+W-1], a[ 1*W +: W]} , 
                                    {a[2*W+W-1], a[ 2*W +: W]} }), .sum(sum13), .cout(c13 )  );
carry_save_3inputs #(W+2) cs2 (.a(  {a[3*W+W-1], a[ 3*W+W-1] ,a[3*W +: W],sum13 ,c13 }), .sum(sumE ), .cout(coutE)  );
assign sum  = sumE [W+1  :0];
assign cout = coutE[W+1  :0];
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

wire [W+1:0] sum13 ;
wire [W+1:0] c13   ;

wire [W+3  :0] sum4;
wire [W+3  :0] cout4;

//wire [W+2:0] test5_0, test5_1, test5_2, test5_3 ;
//assign test5_0 = a[0*W +: W] + a[1*W +: W] + a[2*W +: W] + a[3*W +: W] + a[4*W +: W];
//assign test5_1 = c13 + sum13 + a[3*W +: W] + a[4*W +: W];
//assign test5_2 = cout4 + sum4;
//assign test5_3 = cout + sum;
carry_save_3inputs #(W+1) cs1    (.a({ {a[0*W+W-1],             a[ 0*W +: W]} , 
                                       {a[1*W+W-1],             a[ 1*W +: W]} , 
                                       {a[2*W+W-1],             a[ 2*W +: W]} }), .sum(sum13), .cout(c13 )  );
carry_save_4inputs #(W+2) cs2    (.a({ {a[4*W+W-1], a[4*W+W-1], a[ 4*W +: W]} , 
                                       {a[3*W+W-1], a[3*W+W-1], a[ 3*W +: W]} ,sum13 , c13 }), .sum(sum4), .cout(cout4)  );
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

 wire [W+1 :0] sum13, sum46;
 wire [W+1 :0] c13  , c46 ;

 wire [W+3 :0] sum1, cout1 ;

carry_save_3inputs #(W+1) cs1    (.a({ {a[0*W+W-1], a[ 0*W +: W]} , 
                                       {a[1*W+W-1], a[ 1*W +: W]} , 
                                       {a[2*W+W-1], a[ 2*W +: W]} }), .sum(sum13), .cout(c13 )  );
carry_save_3inputs #(W+1) cs2    (.a({ {a[3*W+W-1], a[ 3*W +: W]} , 
                                       {a[4*W+W-1], a[ 4*W +: W]} , 
                                       {a[5*W+W-1], a[ 5*W +: W]} }), .sum(sum46), .cout(c46 )  );

 carry_save_4inputs #(W+2) cs_4in (.a({sum13 ,c13 ,sum46,c46 }), .sum(sum1), .cout(cout1)  );
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

wire [W+1:0] sum13, sum46;
wire [W+1:0] c13  , c46  ;
wire [W+3  :0] sum5;
wire [W+3  :0] cout5;

//wire [W+4:0] test7_0, test7_1, test7_2, test7_3 ;
//assign test7_0 = a[0*W +: W] + a[1*W +: W] + a[2*W +: W] + a[3*W +: W] + a[4*W +: W] + a[5*W +: W] + a[6*W +: W];
//assign test7_1 = c13 + sum13 + sum46 + c46 + a[6*W +: W];
//assign test7_2 = cout5 + sum5;
//assign test7_3 = cout  + sum;

carry_save_3inputs #(W+1) cs1    (.a({ {a[0*W+W-1],             a[ 0*W +: W]} , 
                                       {a[1*W+W-1],             a[ 1*W +: W]} , 
                                       {a[2*W+W-1],             a[ 2*W +: W]} }), .sum(sum13), .cout(c13 )  );
carry_save_3inputs #(W+1) cs2    (.a({ {a[3*W+W-1],             a[ 3*W +: W]} , 
                                       {a[4*W+W-1],             a[ 4*W +: W]} , 
                                       {a[5*W+W-1],             a[ 5*W +: W]} }), .sum(sum46), .cout(c46 )  );
carry_save_5inputs #(W+2) cs_5in (.a({{ a[6*W+W-1], a[6*W+W-1], a[ 6*W +: W]}, sum13, sum46, c13, c46 }), .sum(sum5), .cout(cout5)  );
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

wire [W+2:0] sum13, sum46;
wire [W+2:0] c13  , c46  ;
wire [W+4:0] sumE;   
wire [W+4:0] coutE ; 

//wire [W+2:0] test8_0, test8_1, test8_2 ;
//assign test8_0 = a[0*W +: W] + a[1*W +: W] + a[2*W +: W] + a[3*W +: W] + a[4*W +: W] + a[5*W +: W] + a[6*W +: W] + a[7*W +: W];
//assign test8_1 = c13 + sum13 + sum46 + c46 + a[6*W +: W] + a[7*W +: W];
//assign test8_2 = cout + sum;

carry_save_3inputs #(W+2) cs1    (.a({ {a[0*W+W-1], a[0*W+W-1],             a[ 0*W +: W]} , 
                                       {a[1*W+W-1], a[1*W+W-1],             a[ 1*W +: W]} , 
                                       {a[2*W+W-1], a[2*W+W-1],             a[ 2*W +: W]} }), .sum(sum13), .cout(c13 )  );
carry_save_3inputs #(W+2) cs2    (.a({ {a[3*W+W-1], a[3*W+W-1],             a[ 3*W +: W]} , 
                                       {a[4*W+W-1], a[4*W+W-1],             a[ 4*W +: W]} , 
                                       {a[5*W+W-1], a[5*W+W-1],             a[ 5*W +: W]} }), .sum(sum46), .cout(c46 )  );
carry_save_6inputs #(W+3) cs_6in (.a({ {a[6*W+W-1], a[6*W+W-1], a[6*W+W-1], a[ 6*W +: W]} , 
                                       {a[7*W+W-1], a[7*W+W-1], a[7*W+W-1], a[ 7*W +: W]} , sum13, sum46, c13, c46 }), .sum(sumE), .cout(coutE)  );
assign sum  = sumE [W+2  :0];
assign cout = coutE[W+2  :0];
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
 
 wire [W+2:0] sum13, sum46, sum79;
 wire [W+2:0] c13  , c46  , c79  ;
 wire [W+4:0] sum9 , cout9  ;

wire [W+1:0] test9_0, test9_1, test9_2, test9_3, test9_4 ;
assign test9_0 = {a[0*W+W-1],a[0*W+W-1], a[ 0*W +: W]} + {a[1*W+W-1],a[1*W+W-1],a[ 1*W +: W]} + {a[2*W+W-1],a[2*W+W-1],a[ 2*W +: W]} + 
                 {a[3*W+W-1],a[3*W+W-1], a[ 3*W +: W]} + {a[4*W+W-1],a[4*W+W-1],a[ 4*W +: W]} + {a[5*W+W-1],a[5*W+W-1],a[ 5*W +: W]} + 
                 {a[6*W+W-1],a[6*W+W-1], a[ 6*W +: W]} + {a[7*W+W-1],a[7*W+W-1],a[ 7*W +: W]} + {a[8*W+W-1],a[8*W+W-1],a[ 8*W +: W]};
assign test9_1 = sum13   + c13   + sum46   + c46   + sum79   + c79 ;
assign test9_2 = sum13 + sum46 + sum79 + c13 + c46 + c79 ;
assign test9_3 = cout9 + sum9;
assign test9_4 = cout  + sum ;

 carry_save_3inputs #(W+2) cs_3in_1 (.a({ {a[0*W+W-1], a[0*W+W-1], a[0*W +: W]}, 
                                          {a[1*W+W-1], a[1*W+W-1], a[1*W +: W]}, 
                                          {a[2*W+W-1], a[2*W+W-1], a[2*W +: W]} }), .sum(sum13), .cout(c13)  );
 carry_save_3inputs #(W+2) cs_3in_2 (.a({ {a[3*W+W-1], a[3*W+W-1], a[3*W +: W]}, 
                                          {a[4*W+W-1], a[4*W+W-1], a[4*W +: W]}, 
                                          {a[5*W+W-1], a[5*W+W-1], a[5*W +: W]} }), .sum(sum46), .cout(c46)  );
 carry_save_3inputs #(W+2) cs_3in_3 (.a({ {a[6*W+W-1], a[6*W+W-1], a[6*W +: W]}, 
                                          {a[7*W+W-1], a[7*W+W-1], a[7*W +: W]}, 
                                          {a[8*W+W-1], a[8*W+W-1], a[8*W +: W]} }), .sum(sum79), .cout(c79)  );

 carry_save_6inputs #(W+2+1) cs_6in (.a({sum13,sum46,sum79, c13 ,c46 ,c79 }), .sum(sum9), .cout(cout9)  );

 assign sum  = sum9 [W+2  :0];
 assign cout = cout9[W+2  :0];

// carry_save_3inputs #(W) cs_3in_1 (.a(a[0*W +: 3*W ]), .sum(sum13), .cout(c13)  );
// carry_save_3inputs #(W) cs_3in_2 (.a(a[3*W +: 3*W ]), .sum(sum46), .cout(c46)  );
// carry_save_3inputs #(W) cs_3in_3 (.a(a[6*W +: 3*W ]), .sum(sum79), .cout(c79)  );

// carry_save_6inputs #(W+1) cs_6in (.a({sum13,sum46,sum79, c13 ,c46 ,c79 }), .sum(sum), .cout(cout)  );

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
 
 wire [W+2:0]   sum1_3, sum4_6, sum7_9;
 wire [W+2:0]   c1_3  , c4_6  , c7_9  ;
 wire [W+3:0] sum_1 , c_1   , sum_2  , c_2;
 wire [W+5:0] sum5  , cout5;

//wire [W+5:0] test10_0, test10_1, test10_2, test10_3 ;
//assign test10_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W];
//assign test10_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + a[9*W +: W ] ;
//assign test10_2 = sum_1 + c_1 + sum_2 + c_2 + a[9*W +: W ] ;
//assign test10_3 = cout + sum;

 carry_save_3inputs #(W+2) cs_3in_1 (.a({ {a[0*W+W-1], a[0*W+W-1], a[0*W +: W]}, 
                                          {a[1*W+W-1], a[1*W+W-1], a[1*W +: W]}, 
                                          {a[2*W+W-1], a[2*W+W-1], a[2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+2) cs_3in_2 (.a({ {a[3*W+W-1], a[3*W+W-1], a[3*W +: W]}, 
                                          {a[4*W+W-1], a[4*W+W-1], a[4*W +: W]}, 
                                          {a[5*W+W-1], a[5*W+W-1], a[5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+2) cs_3in_3 (.a({ {a[6*W+W-1], a[6*W+W-1], a[6*W +: W]}, 
                                          {a[7*W+W-1], a[7*W+W-1], a[7*W +: W]}, 
                                          {a[8*W+W-1], a[8*W+W-1], a[8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); // a(10) do not added


 carry_save_3inputs #(W+3) cs_3in_4(.a({ sum1_3, sum4_6, c1_3}), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+3) cs_3in_5(.a({ sum7_9, c4_6,  c7_9 }), .sum(sum_2), .cout(c_2) );

 carry_save_5inputs #(W+4) cs_5in (.a({sum_1, sum_2, c_1, c_2 , { {(4){a[9*W+W-1]}}, a[ 9*W +: W ]}  }), .sum(sum5), .cout(cout5)  );
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
 
 wire [W+2:0]   sum1_3, sum4_6, sum7_9;
 wire [W+2:0]   c1_3  , c4_6  , c7_9  ;
 wire [W+3:0] sum_1 , c_1   , sum_2  , c_2;
 wire [W+5:0] sum5  , cout5;

//wire [W+5:0] test10_0, test10_1, test10_2, test10_3 ;
//assign test10_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W];
//assign test10_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + a[9*W +: W ] ;
//assign test10_2 = sum_1 + c_1 + sum_2 + c_2 + a[9*W +: W ] ;
//assign test10_3 = cout + sum;



 carry_save_3inputs #(W+2) cs_3in_1 (.a({ {a[0*W+W-1], a[0*W+W-1], a[0*W +: W]}, 
                                          {a[1*W+W-1], a[1*W+W-1], a[1*W +: W]}, 
                                          {a[2*W+W-1], a[2*W+W-1], a[2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+2) cs_3in_2 (.a({ {a[3*W+W-1], a[3*W+W-1], a[3*W +: W]}, 
                                          {a[4*W+W-1], a[4*W+W-1], a[4*W +: W]}, 
                                          {a[5*W+W-1], a[5*W+W-1], a[5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+2) cs_3in_3 (.a({ {a[6*W+W-1], a[6*W+W-1], a[6*W +: W]}, 
                                          {a[7*W+W-1], a[7*W+W-1], a[7*W +: W]}, 
                                          {a[8*W+W-1], a[8*W+W-1], a[8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); // a(10,11) do not added

 carry_save_3inputs #(W+3) cs_3in_4(.a({ sum1_3, sum4_6, c1_3 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+3) cs_3in_5(.a({ sum7_9, c4_6, c7_9   }), .sum(sum_2), .cout(c_2) );

 carry_save_6inputs #(W+4) cs_6in (.a({sum_1, sum_2, c_1, c_2 , { {(4){a[9*W+W-1]}}, a[ 9*W +: W ]} , { {(4){a[10*W+W-1]}}, a[ 10*W +: W ]} }), .sum(sum5), .cout(cout5)  );
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
 
 wire [W+2:0]   sum1_3, sum4_6, sum7_9, sum10_12;
 wire [W+2:0]   c1_3  , c4_6  , c7_9  , c10_12  ;
 wire [W+3:0] sum_1 , c_1   , sum_2  , c_2;
 wire [W+5:0] sum6  , cout6;

//wire [W+3:0] test12_0, test12_1, test12_2, test12_3 ;
//assign test12_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W]+ a[10*W +: W] + a[11*W +: W];
//assign test12_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + sum10_12 + c10_12;
//assign test12_2 = sum_1 + c_1 + sum_2 + c_2 + sum10_12 + c10_12 ;
//assign test12_3 = cout + sum;

 carry_save_3inputs #(W+2) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+2) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+2) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); 
 carry_save_3inputs #(W+2) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12)  );

 carry_save_3inputs #(W+3) cs_3in_5(.a({ sum1_3, sum4_6, c1_3 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+3) cs_3in_6(.a({ sum7_9, c4_6, c7_9   }), .sum(sum_2), .cout(c_2) ); // sum10_12, c10_12 do not added

 carry_save_6inputs #(W+4) cs_6in (.a({sum_1, sum_2, c_1, c_2, { {(1){sum10_12[W+2]}},sum10_12}, {{(1){c10_12[W+2]}},c10_12}  }), .sum(sum6), .cout(cout6)  );
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
 
 wire [W+2:0]   sum1_3, sum4_6, sum7_9, sum10_12;
 wire [W+2:0]   c1_3  , c4_6  , c7_9  , c10_12  ;
 wire [W+3:0] sum_1 , c_1   , sum_2  , c_2, sum_3  , c_3;
 wire [W+5:0] sum6  , cout6;

 carry_save_3inputs #(W+2) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+2) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+2) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); 
 carry_save_3inputs #(W+2) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12));// a[12*W +: W]  do not added

 carry_save_3inputs #(W+3) cs_3in_5(.a({ sum1_3  , sum4_6 , c1_3                }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+3) cs_3in_6(.a({ sum7_9  , c4_6   , c7_9                }), .sum(sum_2), .cout(c_2) ); 
 carry_save_3inputs #(W+3) cs_3in_7(.a({ sum10_12, c10_12 , {  {(3){a[12*W+W-1]}},a[12*W +: W]}  }), .sum(sum_3), .cout(c_3) );

 carry_save_6inputs #(W+4) cs_6in (.a({sum_1, sum_2, sum_3, c_1, c_2, c_3 }), .sum(sum6), .cout(cout6)  );
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
 
 wire [W+2:0]   sum1_3, sum4_6, sum7_9, sum10_12;
 wire [W+2:0]   c1_3  , c4_6  , c7_9  , c10_12  ;
 wire [W+3:0] sum_1 , c_1   , sum_2  , c_2, sum_3  , c_3;
 wire [W+5:0] sum6  , cout6;

//wire [W+5:0] test14_0, test14_1, test14_2, test14_3 ;
//assign test14_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] 
//                + a[ 7*W +: W] + a[ 8*W +: W] + a[ 9*W +: W] + a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W];
//assign test14_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + sum10_12 + c10_12  + a[12*W +: W] + a[13*W +: W];
//assign test14_2 = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + c10_12;
//assign test14_3 = cout + sum;


 carry_save_3inputs #(W+2) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+2) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+2) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); 
 carry_save_3inputs #(W+2) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12));// a[12*W +: W] + a[13*W +: W] do not added

 carry_save_3inputs #(W+3) cs_3in_5(.a({ sum1_3  , c1_3    , sum4_6                         }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+3) cs_3in_6(.a({  c4_6   , sum7_9  , c7_9                           }), .sum(sum_2), .cout(c_2) ); 
 carry_save_3inputs #(W+3) cs_3in_7(.a({ sum10_12,  {(3){a[12*W+W-1]}},a[12*W +: W] , {(3){a[13*W+W-1]}},a[13*W +: W] }), .sum(sum_3), .cout(c_3) ); // c10_12 do not added

 carry_save_7inputs #(W+4) cs_7in (.a({sum_1, sum_2, sum_3, c_1, c_2, c_3, {c10_12[W+2],c10_12}  }), .sum(sum6), .cout(cout6)  );
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
 
 wire [W+2:0]   sum1_3, sum4_6, sum7_9, sum10_12, sum13_15;
 wire [W+2:0]   c1_3  , c4_6  , c7_9  , c10_12  , c13_15  ;
 wire [W+3:0] sum_1 , c_1   , sum_2  , c_2, sum_3  , c_3;
 wire [W+5:0] sum6  , cout6;

//wire [W+5:0] test14_0, test14_1, test14_2, test14_3 ;
//assign test14_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] 
//                + a[ 7*W +: W] + a[ 8*W +: W] + a[ 9*W +: W] + a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W];
//assign test14_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9  + sum10_12 + c10_12  + a[12*W +: W] + a[13*W +: W];
//assign test14_2 = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + c10_12;
//assign test14_3 = cout + sum;

 carry_save_3inputs #(W+2) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+2) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+2) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); 
 carry_save_3inputs #(W+2) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12));
 carry_save_3inputs #(W+2) cs_3in_5 (.a({ {a[12*W+W-1], a[12*W+W-1], a[12*W +: W]}, 
                                          {a[13*W+W-1], a[13*W+W-1], a[13*W +: W]}, 
                                          {a[14*W+W-1], a[14*W+W-1], a[14*W +: W]} }), .sum(sum13_15), .cout(c13_15));

 carry_save_3inputs #(W+3) cs_3in_6(.a({ sum1_3  , c1_3,     sum4_6 }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+3) cs_3in_7(.a({  c4_6,    sum7_9 ,  c7_9   }), .sum(sum_2), .cout(c_2) ); 
 carry_save_3inputs #(W+3) cs_3in_8(.a({ sum10_12, sum13_15, c10_12 }), .sum(sum_3), .cout(c_3) ); // c13_15 do not added

 carry_save_7inputs #(W+4) cs_7in (.a({sum_1, sum_2, sum_3, c_1, c_2, c_3, {c13_15[W+2],c13_15}  }), .sum(sum6), .cout(cout6)  );
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
 
 wire [W+3:0] sum1_3, sum4_6, sum7_9, sum10_12, c10_12;
 wire [W+3:0] c1_3  , c4_6  , c7_9  , sum13_15, c13_15;
 wire [W+4:0] sum_1, c_1, sum_2, c_2, sum_3, c_3;
 wire [W+7:0] sum8, cout8;

//wire [W+5:0] test9_0, test9_1, test9_2, test9_3 ;
//
//assign test9_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W] + 
//                 a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + a[15*W +: W];
//assign test9_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9   + sum10_12 + c10_12 + sum13_15 + c13_15 + a[15*W +: W ] ;
//assign test9_2 = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + c13_15 +a[15*W +: W ];
//assign test9_3 = cout + sum;

 carry_save_3inputs #(W+3) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+3) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+3) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); 
 carry_save_3inputs #(W+3) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12));
 carry_save_3inputs #(W+3) cs_3in_5 (.a({ {a[12*W+W-1], a[12*W+W-1], a[12*W+W-1], a[12*W +: W]}, 
                                          {a[13*W+W-1], a[13*W+W-1], a[13*W+W-1], a[13*W +: W]}, 
                                          {a[14*W+W-1], a[14*W+W-1], a[14*W+W-1], a[14*W +: W]} }), .sum(sum13_15), .cout(c13_15)); // a[15*W +: W] do not added

 carry_save_3inputs #(W+4) cs_3in_11(.a({ sum1_3  , c1_3  , sum4_6  }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+4) cs_3in_12(.a({ c4_6    , sum7_9, c7_9    }), .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+4) cs_3in_13(.a({ sum10_12, c10_12, sum13_15}), .sum(sum_3), .cout(c_3) );// 2x a[15*W +: W] do not added

 carry_save_8inputs #(W+5) cs_8in (.a({  sum_1, c_1, sum_2, c_2, sum_3, c_3,{c13_15[W+3], c13_15} , { {(5){a[15*W+W-1]}}, a[15*W +: W ]} }), .sum(sum8), .cout(cout8)  );
assign cout = cout8[W+3  :0];
assign sum  = sum8 [W+3  :0];

endmodule

////////////////////////////////////
// Carry Save 17 inputs 
////////////////////////////////////

module carry_save_17inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
 input  [17*W-1:0] a; //, b,c,d;
 output [W+3  :0] sum;   
 output [W+3  :0] cout;  
 
 wire [W+3:0] sum1_3, sum4_6, sum7_9, sum10_12, c10_12;
 wire [W+3:0] c1_3  , c4_6  , c7_9  , sum13_15, c13_15;
 wire [W+4:0] sum_1, c_1, sum_2, c_2, sum_3, c_3, sum_4, c_4;
 wire [W+7:0] sum8, cout8;

//wire [W+5:0] test9_0, test9_1, test9_2, test9_3 ;
//
//assign test9_0 = a[ 0*W +: W] + a[ 1*W +: W] + a[ 2*W +: W] + a[ 3*W +: W] + a[ 4*W +: W] + a[ 5*W +: W] + a[ 6*W +: W] + a[ 7*W +: W]+ a[ 8*W +: W] + a[ 9*W +: W] + 
//                 a[10*W +: W] + a[11*W +: W] + a[12*W +: W] + a[13*W +: W] + a[14*W +: W] + a[15*W +: W];
//assign test9_1 = sum1_3   + c1_3   + sum4_6   + c4_6   + sum7_9   + c7_9   + sum10_12 + c10_12 + sum13_15 + c13_15 + a[15*W +: W ] ;
//assign test9_2 = sum_1 + c_1 + sum_2 + c_2 + sum_3 + c_3 + c13_15 +a[15*W +: W ];
//assign test9_3 = cout + sum;

 carry_save_3inputs #(W+3) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum1_3), .cout(c1_3)  );
 carry_save_3inputs #(W+3) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum4_6), .cout(c4_6)  );
 carry_save_3inputs #(W+3) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum7_9), .cout(c7_9)  ); 
 carry_save_3inputs #(W+3) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12));
 carry_save_3inputs #(W+3) cs_3in_5 (.a({ {a[12*W+W-1], a[12*W+W-1], a[12*W+W-1], a[12*W +: W]}, 
                                          {a[13*W+W-1], a[13*W+W-1], a[13*W+W-1], a[13*W +: W]}, 
                                          {a[14*W+W-1], a[14*W+W-1], a[14*W+W-1], a[14*W +: W]} }), .sum(sum13_15), .cout(c13_15)); // a(15) a(16)  do not added

 carry_save_3inputs #(W+4) cs_3in_11(.a({ sum1_3  , c1_3  , sum4_6                    }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+4) cs_3in_12(.a({ c4_6    , sum7_9, c7_9                      }), .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+4) cs_3in_13(.a({ sum10_12, c10_12, sum13_15                  }), .sum(sum_3), .cout(c_3) );
 carry_save_3inputs #(W+4) cs_3in_14(.a({ c13_15, {(4){a[15*W+W-1]}},a[15*W+:W], {(4){a[16*W+W-1]}}, a[16*W+:W] }), .sum(sum_4), .cout(c_4) );

 carry_save_8inputs #(W+5) cs_8in (.a({  sum_1, c_1, sum_2, c_2, sum_3, c_3,sum_4 , c_4 }), .sum(sum8), .cout(cout8)  );
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

wire [W+3:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W+4:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5;
wire [W+5:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14;
wire [W+8:0] sum8, cout8;

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

 carry_save_3inputs #(W+3) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum01_03), .cout(c01_03)  );
 carry_save_3inputs #(W+3) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum04_06), .cout(c04_06)  );
 carry_save_3inputs #(W+3) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum07_09), .cout(c07_09)  ); 
 carry_save_3inputs #(W+3) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12));
 carry_save_3inputs #(W+3) cs_3in_5 (.a({ {a[12*W+W-1], a[12*W+W-1], a[12*W+W-1], a[12*W +: W]}, 
                                          {a[13*W+W-1], a[13*W+W-1], a[13*W+W-1], a[13*W +: W]}, 
                                          {a[14*W+W-1], a[14*W+W-1], a[14*W+W-1], a[14*W +: W]} }), .sum(sum13_15), .cout(c13_15)); 
 carry_save_3inputs #(W+3) cs_3in_6 (.a({ {a[15*W+W-1], a[15*W+W-1], a[15*W+W-1], a[15*W +: W]}, 
                                          {a[16*W+W-1], a[16*W+W-1], a[16*W+W-1], a[16*W +: W]}, 
                                          {a[17*W+W-1], a[17*W+W-1], a[17*W+W-1], a[17*W +: W]} }), .sum(sum16_18), .cout(c16_18)  ); 
 carry_save_3inputs #(W+3) cs_3in_7 (.a({ {a[18*W+W-1], a[18*W+W-1], a[18*W+W-1], a[18*W +: W]}, 
                                          {a[19*W+W-1], a[19*W+W-1], a[19*W+W-1], a[19*W +: W]}, 
                                          {a[20*W+W-1], a[20*W+W-1], a[20*W+W-1], a[20*W +: W]} }), .sum(sum19_21), .cout(c19_21));
 carry_save_3inputs #(W+3) cs_3in_8 (.a({ {a[21*W+W-1], a[21*W+W-1], a[21*W+W-1], a[21*W +: W]}, 
                                          {a[22*W+W-1], a[22*W+W-1], a[22*W+W-1], a[22*W +: W]}, 
                                          {a[23*W+W-1], a[23*W+W-1], a[23*W+W-1], a[23*W +: W]} }), .sum(sum22_24), .cout(c22_24)); // a(25) do not added

carry_save_3inputs #(W+4) cs_3in_11 (.a({ sum01_03, c01_03, sum04_06   }), .sum(sum_1), .cout(c_1)  );
carry_save_3inputs #(W+4) cs_3in_12 (.a({ c04_06, sum07_09, c07_09     }), .sum(sum_2), .cout(c_2)  );
carry_save_3inputs #(W+4) cs_3in_13 (.a({ sum10_12, c10_12, sum13_15   }), .sum(sum_3), .cout(c_3)  );
carry_save_3inputs #(W+4) cs_3in_14 (.a({ c13_15, sum16_18, c16_18     }), .sum(sum_4), .cout(c_4)  );
carry_save_3inputs #(W+4) cs_3in_15 (.a({ sum19_21, c19_21  , sum22_24 }), .sum(sum_5), .cout(c_5)  );//c22_24 and  a(25) do not added

//carry_save_3inputs #(W+1) cs_3in_11 (.a({ sum01_03, sum04_06, sum07_09 }), .sum(sum_1), .cout(c_1)  );
//carry_save_3inputs #(W+1) cs_3in_12 (.a({ sum10_12, sum13_15, sum16_18 }), .sum(sum_2), .cout(c_2)  );
//carry_save_3inputs #(W+1) cs_3in_13 (.a({ c01_03  , c04_06  , c07_09   }), .sum(sum_3), .cout(c_3)  );
//carry_save_3inputs #(W+1) cs_3in_14 (.a({ c10_12  , c13_15  , c16_18   }), .sum(sum_4), .cout(c_4)  );
//carry_save_3inputs #(W+1) cs_3in_15 (.a({ sum19_21, c19_21  , sum22_24 }), .sum(sum_5), .cout(c_5)  );//c22_24 and  a(25) do not added

 carry_save_3inputs #(W+5) cs_3in_21 (.a({ sum_1, c_1  , sum_2                            }), .sum(sum_11), .cout(c_11)  );
 carry_save_3inputs #(W+5) cs_3in_22 (.a({  c_2 , sum_3, c_3                              }), .sum(sum_12), .cout(c_12)  );
 carry_save_3inputs #(W+5) cs_3in_23 (.a({ sum_4, c_4  , sum_5                            }), .sum(sum_13), .cout(c_13)  );
 carry_save_3inputs #(W+5) cs_3in_24 (.a({ c_5  , {c22_24[W+3], c22_24}, { {(5){a[24*W+W-1]}}, a[24*W +: W] } }), .sum(sum_14), .cout(c_14)  );


 carry_save_8inputs #(W+6) cs_8in (.a({ sum_11, sum_12, sum_13, sum_14, c_11, c_12, c_13 , c_14 }), .sum(sum8), .cout(cout8)  );
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

wire [W+4:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W+4:0] sum25_27, c25_27, sum28_30, c28_30;
wire [W+4+1:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5,  sum_6,  c_6,  sum_7,  c_7;
wire [W+4+2:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15;
wire [W+4+3:0] sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+4+4:0] sum_31, c_31, sum_32, c_32, sum_33, c_33; 
wire [W+4+5:0] sum10, cout10;

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

 carry_save_3inputs #(W+4) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum01_03), .cout(c01_03)  );
 carry_save_3inputs #(W+4) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum04_06), .cout(c04_06)  );
 carry_save_3inputs #(W+4) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum07_09), .cout(c07_09)  ); 
 carry_save_3inputs #(W+4) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12));
 carry_save_3inputs #(W+4) cs_3in_5 (.a({ {a[12*W+W-1], a[12*W+W-1], a[12*W+W-1], a[12*W+W-1], a[12*W +: W]}, 
                                          {a[13*W+W-1], a[13*W+W-1], a[13*W+W-1], a[13*W+W-1], a[13*W +: W]}, 
                                          {a[14*W+W-1], a[14*W+W-1], a[14*W+W-1], a[14*W+W-1], a[14*W +: W]} }), .sum(sum13_15), .cout(c13_15)); 
 carry_save_3inputs #(W+4) cs_3in_6 (.a({ {a[15*W+W-1], a[15*W+W-1], a[15*W+W-1], a[15*W+W-1], a[15*W +: W]}, 
                                          {a[16*W+W-1], a[16*W+W-1], a[16*W+W-1], a[16*W+W-1], a[16*W +: W]}, 
                                          {a[17*W+W-1], a[17*W+W-1], a[17*W+W-1], a[17*W+W-1], a[17*W +: W]} }), .sum(sum16_18), .cout(c16_18)  ); 
 carry_save_3inputs #(W+4) cs_3in_7 (.a({ {a[18*W+W-1], a[18*W+W-1], a[18*W+W-1], a[18*W+W-1], a[18*W +: W]}, 
                                          {a[19*W+W-1], a[19*W+W-1], a[19*W+W-1], a[19*W+W-1], a[19*W +: W]}, 
                                          {a[20*W+W-1], a[20*W+W-1], a[20*W+W-1], a[20*W+W-1], a[20*W +: W]} }), .sum(sum19_21), .cout(c19_21));
 carry_save_3inputs #(W+4) cs_3in_8 (.a({ {a[21*W+W-1], a[21*W+W-1], a[21*W+W-1], a[21*W+W-1], a[21*W +: W]}, 
                                          {a[22*W+W-1], a[22*W+W-1], a[22*W+W-1], a[22*W+W-1], a[22*W +: W]}, 
                                          {a[23*W+W-1], a[23*W+W-1], a[23*W+W-1], a[23*W+W-1], a[23*W +: W]} }), .sum(sum22_24), .cout(c22_24)); 
 carry_save_3inputs #(W+4) cs_3in_9 (.a({ {a[24*W+W-1], a[24*W+W-1], a[24*W+W-1], a[24*W+W-1], a[24*W +: W]}, 
                                          {a[25*W+W-1], a[25*W+W-1], a[25*W+W-1], a[25*W+W-1], a[25*W +: W]}, 
                                          {a[26*W+W-1], a[26*W+W-1], a[26*W+W-1], a[26*W+W-1], a[26*W +: W]} }), .sum(sum25_27), .cout(c25_27)  );
 carry_save_3inputs #(W+4) cs_3in_A (.a({ {a[27*W+W-1], a[27*W+W-1], a[27*W+W-1], a[27*W+W-1], a[27*W +: W]}, 
                                          {a[28*W+W-1], a[28*W+W-1], a[28*W+W-1], a[28*W+W-1], a[28*W +: W]}, 
                                          {a[29*W+W-1], a[29*W+W-1], a[29*W+W-1], a[29*W+W-1], a[29*W +: W]} }), .sum(sum28_30), .cout(c28_30)  );// a(30,31) do not added

 carry_save_3inputs #(W+5) cs_3in_20(.a({ sum01_03, c01_03, sum04_06}),                          .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+5) cs_3in_21(.a({ c04_06,  c07_09, sum07_09 }),                          .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+5) cs_3in_22(.a({ sum10_12, c10_12, sum13_15}),                          .sum(sum_3), .cout(c_3) );
 carry_save_3inputs #(W+5) cs_3in_23(.a({ c13_15,  c16_18, sum16_18 }),                          .sum(sum_4), .cout(c_4) );
 carry_save_3inputs #(W+5) cs_3in_25(.a({ sum19_21, c19_21, sum22_24}),                          .sum(sum_5), .cout(c_5) );
 carry_save_3inputs #(W+5) cs_3in_26(.a({ c22_24,  c25_27, sum25_27 }),                          .sum(sum_6), .cout(c_6) );
 carry_save_3inputs #(W+5) cs_3in_27(.a({ sum28_30, c28_30, {(5){a[30*W+W-1]}}, a[30*W +: W ]}), .sum(sum_7), .cout(c_7) );// a(31) do not added (+2)

 //carry_save_3inputs #(W+1) cs_3in_20(.a({ sum01_03, sum04_06, sum07_09 }),              .sum(sum_1), .cout(c_1) );
 //carry_save_3inputs #(W+1) cs_3in_21(.a({ sum10_12, sum13_15, sum16_18 }),              .sum(sum_2), .cout(c_2) );
 //carry_save_3inputs #(W+1) cs_3in_22(.a({ sum19_21, sum22_24, sum25_27 }),              .sum(sum_3), .cout(c_3) );
 //carry_save_3inputs #(W+1) cs_3in_23(.a({ sum28_30, c28_30, {1'b0, a[30*W +: W ]}   }), .sum(sum_4), .cout(c_4) );
 //carry_save_3inputs #(W+1) cs_3in_25(.a({ c01_03, c04_06, c07_09 }),                    .sum(sum_5), .cout(c_5) );
 //carry_save_3inputs #(W+1) cs_3in_26(.a({ c10_12, c13_15, c16_18 }),                    .sum(sum_6), .cout(c_6) );
 //carry_save_3inputs #(W+1) cs_3in_27(.a({ c19_21, c22_24, c25_27 }),                    .sum(sum_7), .cout(c_7) );// a(31) do not added (+2)


 carry_save_3inputs #(W+6) cs_3in_30(.a({ sum_1, c_1, sum_2}),                           .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+6) cs_3in_31(.a({ c_2, c_3, sum_3  }),                           .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+6) cs_3in_32(.a({ sum_4, c_4, sum_5}),                           .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+6) cs_3in_33(.a({ c_5, c_6, sum_6  }),                           .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+6) cs_3in_34(.a({ sum_7, c_7, {(6){a[31*W+W-1]}}, a[31*W +: W]}),.sum(sum_15), .cout(c_15) );

 //carry_save_3inputs #(W+2) cs_3in_30(.a({ sum_1, sum_2, sum_3 }),                .sum(sum_11), .cout(c_11) );
 //carry_save_3inputs #(W+2) cs_3in_31(.a({ sum_4, sum_5, sum_6 }),                .sum(sum_12), .cout(c_12) );
 //carry_save_3inputs #(W+2) cs_3in_32(.a({ sum_7, c_7, {2'b00, a[31*W +: W ]} }), .sum(sum_13), .cout(c_13) );
 //carry_save_3inputs #(W+2) cs_3in_33(.a({ c_1, c_2, c_3}),                       .sum(sum_14), .cout(c_14) );
 //carry_save_3inputs #(W+2) cs_3in_34(.a({ c_4, c_5, c_6}),                       .sum(sum_15), .cout(c_15) ); 

 carry_save_10inputs #(W+7) cs_10in (.a({sum_11, sum_12, sum_13, sum_14, sum_15, c_11, c_12, c_13, c_14, c_15}), .sum(sum10), .cout(cout10)  );

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

wire [W+4:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W+4:0] sum25_27, c25_27, sum28_30, c28_30, sum31_33, c31_33, sum34_36, c34_36, sum37_39, c37_39, sum40_42, c40_42, sum43_45, c43_45, sum46_48, c46_48;
wire [W+4+1:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5,  sum_6,  c_6,  sum_7,  c_7, sum_8, c_8, sum_9, c_9, sum_A, c_A, sum_B, c_B;
wire [W+4+2:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16, sum_17, c_17;
wire [W+4+3:0] sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24, sum_25, c_25;
wire [W+4+4:0] sum_31, c_31, sum_32, c_32, sum_33, c_33; 
wire [W+4+5:0] sum_41, c_41, sum_42, c_42;
wire [W+4+7:0] sum5, cout5;

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
 
 carry_save_3inputs #(W+4) cs_3in_1 (.a({ {a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W+W-1], a[ 0*W +: W]}, 
                                          {a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W+W-1], a[ 1*W +: W]}, 
                                          {a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W+W-1], a[ 2*W +: W]} }), .sum(sum01_03), .cout(c01_03)  );
 carry_save_3inputs #(W+4) cs_3in_2 (.a({ {a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W+W-1], a[ 3*W +: W]}, 
                                          {a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W+W-1], a[ 4*W +: W]}, 
                                          {a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W+W-1], a[ 5*W +: W]} }), .sum(sum04_06), .cout(c04_06)  );
 carry_save_3inputs #(W+4) cs_3in_3 (.a({ {a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W+W-1], a[ 6*W +: W]}, 
                                          {a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W+W-1], a[ 7*W +: W]}, 
                                          {a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W+W-1], a[ 8*W +: W]} }), .sum(sum07_09), .cout(c07_09)  ); 
 carry_save_3inputs #(W+4) cs_3in_4 (.a({ {a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W+W-1], a[ 9*W +: W]}, 
                                          {a[10*W+W-1], a[10*W+W-1], a[10*W+W-1], a[10*W+W-1], a[10*W +: W]}, 
                                          {a[11*W+W-1], a[11*W+W-1], a[11*W+W-1], a[11*W+W-1], a[11*W +: W]} }), .sum(sum10_12), .cout(c10_12)  );
 carry_save_3inputs #(W+4) cs_3in_5 (.a({ {a[12*W+W-1], a[12*W+W-1], a[12*W+W-1], a[12*W+W-1], a[12*W +: W]}, 
                                          {a[13*W+W-1], a[13*W+W-1], a[13*W+W-1], a[13*W+W-1], a[13*W +: W]}, 
                                          {a[14*W+W-1], a[14*W+W-1], a[14*W+W-1], a[14*W+W-1], a[14*W +: W]} }), .sum(sum13_15), .cout(c13_15)  ); 
 carry_save_3inputs #(W+4) cs_3in_6 (.a({ {a[15*W+W-1], a[15*W+W-1], a[15*W+W-1], a[15*W+W-1], a[15*W +: W]}, 
                                          {a[16*W+W-1], a[16*W+W-1], a[16*W+W-1], a[16*W+W-1], a[16*W +: W]}, 
                                          {a[17*W+W-1], a[17*W+W-1], a[17*W+W-1], a[17*W+W-1], a[17*W +: W]} }), .sum(sum16_18), .cout(c16_18)  ); 
 carry_save_3inputs #(W+4) cs_3in_7 (.a({ {a[18*W+W-1], a[18*W+W-1], a[18*W+W-1], a[18*W+W-1], a[18*W +: W]}, 
                                          {a[19*W+W-1], a[19*W+W-1], a[19*W+W-1], a[19*W+W-1], a[19*W +: W]}, 
                                          {a[20*W+W-1], a[20*W+W-1], a[20*W+W-1], a[20*W+W-1], a[20*W +: W]} }), .sum(sum19_21), .cout(c19_21)  );
 carry_save_3inputs #(W+4) cs_3in_8 (.a({ {a[21*W+W-1], a[21*W+W-1], a[21*W+W-1], a[21*W+W-1], a[21*W +: W]}, 
                                          {a[22*W+W-1], a[22*W+W-1], a[22*W+W-1], a[22*W+W-1], a[22*W +: W]}, 
                                          {a[23*W+W-1], a[23*W+W-1], a[23*W+W-1], a[23*W+W-1], a[23*W +: W]} }), .sum(sum22_24), .cout(c22_24)  ); 
 carry_save_3inputs #(W+4) cs_3in_9 (.a({ {a[24*W+W-1], a[24*W+W-1], a[24*W+W-1], a[24*W+W-1], a[24*W +: W]}, 
                                          {a[25*W+W-1], a[25*W+W-1], a[25*W+W-1], a[25*W+W-1], a[25*W +: W]}, 
                                          {a[26*W+W-1], a[26*W+W-1], a[26*W+W-1], a[26*W+W-1], a[26*W +: W]} }), .sum(sum25_27), .cout(c25_27)  );
 carry_save_3inputs #(W+4) cs_3in_A (.a({ {a[27*W+W-1], a[27*W+W-1], a[27*W+W-1], a[27*W+W-1], a[27*W +: W]}, 
                                          {a[28*W+W-1], a[28*W+W-1], a[28*W+W-1], a[28*W+W-1], a[28*W +: W]}, 
                                          {a[29*W+W-1], a[29*W+W-1], a[29*W+W-1], a[29*W+W-1], a[29*W +: W]} }), .sum(sum28_30), .cout(c28_30)  );
 carry_save_3inputs #(W+4) cs_3in_B (.a({ {a[30*W+W-1], a[30*W+W-1], a[30*W+W-1], a[30*W+W-1], a[30*W +: W]}, 
                                          {a[31*W+W-1], a[31*W+W-1], a[31*W+W-1], a[31*W+W-1], a[31*W +: W]}, 
                                          {a[32*W+W-1], a[32*W+W-1], a[32*W+W-1], a[32*W+W-1], a[32*W +: W]} }), .sum(sum31_33), .cout(c31_33)  );
 carry_save_3inputs #(W+4) cs_3in_C (.a({ {a[33*W+W-1], a[33*W+W-1], a[33*W+W-1], a[33*W+W-1], a[33*W +: W]}, 
                                          {a[34*W+W-1], a[34*W+W-1], a[34*W+W-1], a[34*W+W-1], a[34*W +: W]}, 
                                          {a[35*W+W-1], a[35*W+W-1], a[35*W+W-1], a[35*W+W-1], a[35*W +: W]} }), .sum(sum34_36), .cout(c34_36)  );
 carry_save_3inputs #(W+4) cs_3in_D (.a({ {a[36*W+W-1], a[36*W+W-1], a[36*W+W-1], a[36*W+W-1], a[36*W +: W]}, 
                                          {a[37*W+W-1], a[37*W+W-1], a[37*W+W-1], a[37*W+W-1], a[37*W +: W]}, 
                                          {a[38*W+W-1], a[38*W+W-1], a[38*W+W-1], a[38*W+W-1], a[38*W +: W]} }), .sum(sum37_39), .cout(c37_39)  ); 
 carry_save_3inputs #(W+4) cs_3in_E (.a({ {a[39*W+W-1], a[39*W+W-1], a[39*W+W-1], a[39*W+W-1], a[39*W +: W]}, 
                                          {a[40*W+W-1], a[40*W+W-1], a[40*W+W-1], a[40*W+W-1], a[40*W +: W]}, 
                                          {a[41*W+W-1], a[41*W+W-1], a[41*W+W-1], a[41*W+W-1], a[41*W +: W]} }), .sum(sum40_42), .cout(c40_42)  );
 carry_save_3inputs #(W+4) cs_3in_F (.a({ {a[42*W+W-1], a[42*W+W-1], a[42*W+W-1], a[42*W+W-1], a[42*W +: W]}, 
                                          {a[43*W+W-1], a[43*W+W-1], a[43*W+W-1], a[43*W+W-1], a[43*W +: W]}, 
                                          {a[44*W+W-1], a[44*W+W-1], a[44*W+W-1], a[44*W+W-1], a[44*W +: W]} }), .sum(sum43_45), .cout(c43_45)  ); 
 carry_save_3inputs #(W+4) cs_3in_G (.a({ {a[45*W+W-1], a[45*W+W-1], a[45*W+W-1], a[45*W+W-1], a[45*W +: W]}, 
                                          {a[46*W+W-1], a[46*W+W-1], a[46*W+W-1], a[46*W+W-1], a[46*W +: W]}, 
                                          {a[47*W+W-1], a[47*W+W-1], a[47*W+W-1], a[47*W+W-1], a[47*W +: W]} }), .sum(sum46_48), .cout(c46_48)  ); // a(48) do not added


 carry_save_3inputs #(W+5) cs_3in_20(.a({ sum01_03, c01_03, sum04_06                          }), .sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+5) cs_3in_21(.a({ c04_06, sum07_09, c07_09                            }), .sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+5) cs_3in_22(.a({ sum10_12, c10_12, sum13_15                          }), .sum(sum_3), .cout(c_3) );
 carry_save_3inputs #(W+5) cs_3in_23(.a({ c13_15, sum16_18, c16_18                            }), .sum(sum_4), .cout(c_4) );
 carry_save_3inputs #(W+5) cs_3in_24(.a({ sum19_21, c19_21, sum22_24                          }), .sum(sum_5), .cout(c_5) );
 carry_save_3inputs #(W+5) cs_3in_25(.a({ c22_24, sum25_27, c25_27                            }), .sum(sum_6), .cout(c_6) );
 carry_save_3inputs #(W+5) cs_3in_26(.a({ sum28_30, c28_30, sum31_33                          }), .sum(sum_7), .cout(c_7) );
 carry_save_3inputs #(W+5) cs_3in_27(.a({ c31_33, sum34_36, c34_36                            }), .sum(sum_8), .cout(c_8) );
 carry_save_3inputs #(W+5) cs_3in_28(.a({ sum37_39, c37_39, sum40_42                          }), .sum(sum_9), .cout(c_9) );
 carry_save_3inputs #(W+5) cs_3in_29(.a({ c40_42, sum43_45, c43_45                            }), .sum(sum_A), .cout(c_A) );
 carry_save_3inputs #(W+5) cs_3in_2A(.a({ sum46_48, c46_48, {(5){a[48*W+W-1]}}, a[48*W +: W ] }), .sum(sum_B), .cout(c_B) );


 carry_save_3inputs #(W+6) cs_3in_30(.a({ sum_1, c_1, sum_2 }), .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+6) cs_3in_31(.a({ c_2, sum_3, c_3   }), .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+6) cs_3in_32(.a({ sum_4, c_4, sum_5 }), .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+6) cs_3in_33(.a({ c_5, sum_6, c_6   }), .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+6) cs_3in_34(.a({ sum_7, c_7, sum_8 }), .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+6) cs_3in_35(.a({ c_8, sum_9, c_9   }), .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+6) cs_3in_36(.a({ sum_A, c_A, sum_B }), .sum(sum_17), .cout(c_17) );    // c_B do not added


 carry_save_3inputs #(W+7) cs_3in_40(.a({ sum_11, c_11, sum_12       }), .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+7) cs_3in_41(.a({ c_12, sum_13, c_13         }), .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+7) cs_3in_43(.a({ sum_14, c_14, sum_15       }), .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+7) cs_3in_44(.a({ c_15, sum_16, c_16         }), .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+7) cs_3in_45(.a({ sum_17, c_17, c_B[W+5], c_B}), .sum(sum_25), .cout(c_25) );


 carry_save_3inputs #(W+8) cs_3in_50(.a({ sum_21, c_21, sum_22}), .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+8) cs_3in_51(.a({ c_22, sum_23, c_23  }), .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+8) cs_3in_52(.a({ sum_24, c_24, sum_25}), .sum(sum_33), .cout(c_33) ); // c_25 do not added


 carry_save_3inputs #(W+9) cs_3in_60(.a({ sum_31, c_31, sum_32}), .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+9) cs_3in_61(.a({  c_32, c_33, sum_33 }), .sum(sum_42), .cout(c_42) );

carry_save_5inputs #(W+10) cs_5in (.a({sum_41, sum_42, c_41, c_42, {(2){c_25[W+7]}}, c_25  }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+4  :0];
assign sum  = sum5 [W+4  :0];

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

wire [W+5:0] sum01_03, c01_03, sum04_06, c04_06, sum07_09, c07_09, sum10_12, c10_12, sum13_15, c13_15, sum16_18, c16_18, sum19_21, c19_21, sum22_24, c22_24;
wire [W+5:0] sum25_27, c25_27, sum28_30, c28_30, sum31_33, c31_33, sum34_36, c34_36, sum37_39, c37_39, sum40_42, c40_42, sum43_45, c43_45, sum46_48, c46_48;
wire [W+5:0] sum49_51, c49_51, sum52_54, c52_54, sum55_57, c55_57, sum58_60, c58_60, sum61_63, c61_63;
wire [W+5+1:0] sum_1,  c_1,  sum_2,  c_2,  sum_3,  c_3,  sum_4,  c_4,  sum_5,  c_5,  sum_6,  c_6,  sum_7,  c_7, sum_8, c_8, sum_9, c_9, sum_A, c_A, sum_B, c_B;
wire [W+5+1:0] sum_C, sum_D, sum_E, c_C, c_D, c_E;
wire [W+5+2:0] sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16, sum_17, c_17, sum_18, c_18, sum_19, c_19;
wire [W+5+3:0] sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24, sum_25, c_25, sum_26, c_26;
wire [W+5+4:0] sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34; 
wire [W+5+5:0] sum_41, c_41, sum_42, c_42, sum_43, c_43;
wire [W+5+7:0] sum5, cout5;

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

 carry_save_3inputs #(W+5) cs_3in_1 (.a({ { (5) { a[ 0*W+W-1] }} , a[ 0*W +: W] , 
                                          { (5) { a[ 1*W+W-1] }} , a[ 1*W +: W] , 
                                          { (5) { a[ 2*W+W-1] }} , a[ 2*W +: W]  }), .sum(sum01_03), .cout(c01_03)  );
 carry_save_3inputs #(W+5) cs_3in_2 (.a({ { (5) { a[ 3*W+W-1] }} , a[ 3*W +: W] , 
                                          { (5) { a[ 4*W+W-1] }} , a[ 4*W +: W] , 
                                          { (5) { a[ 5*W+W-1] }} , a[ 5*W +: W]  }), .sum(sum04_06), .cout(c04_06)  );
 carry_save_3inputs #(W+5) cs_3in_3 (.a({ { (5) { a[ 6*W+W-1] }} , a[ 6*W +: W] , 
                                          { (5) { a[ 7*W+W-1] }} , a[ 7*W +: W] , 
                                          { (5) { a[ 8*W+W-1] }} , a[ 8*W +: W]  }), .sum(sum07_09), .cout(c07_09)  ); 
 carry_save_3inputs #(W+5) cs_3in_4 (.a({ { (5) { a[ 9*W+W-1] }} , a[ 9*W +: W] , 
                                          { (5) { a[10*W+W-1] }} , a[10*W +: W] , 
                                          { (5) { a[11*W+W-1] }} , a[11*W +: W]  }), .sum(sum10_12), .cout(c10_12)  );
 carry_save_3inputs #(W+5) cs_3in_5 (.a({ { (5) { a[12*W+W-1] }} , a[12*W +: W] , 
                                          { (5) { a[13*W+W-1] }} , a[13*W +: W] , 
                                          { (5) { a[14*W+W-1] }} , a[14*W +: W]  }), .sum(sum13_15), .cout(c13_15)  ); 
 carry_save_3inputs #(W+5) cs_3in_6 (.a({ { (5) { a[15*W+W-1] }} , a[15*W +: W] , 
                                          { (5) { a[16*W+W-1] }} , a[16*W +: W] , 
                                          { (5) { a[17*W+W-1] }} , a[17*W +: W]  }), .sum(sum16_18), .cout(c16_18)  ); 
 carry_save_3inputs #(W+5) cs_3in_7 (.a({ { (5) { a[18*W+W-1] }} , a[18*W +: W] , 
                                          { (5) { a[19*W+W-1] }} , a[19*W +: W] , 
                                          { (5) { a[20*W+W-1] }} , a[20*W +: W]  }), .sum(sum19_21), .cout(c19_21)  );
 carry_save_3inputs #(W+5) cs_3in_8 (.a({ { (5) { a[21*W+W-1] }} , a[21*W +: W] , 
                                          { (5) { a[22*W+W-1] }} , a[22*W +: W] , 
                                          { (5) { a[23*W+W-1] }} , a[23*W +: W]  }), .sum(sum22_24), .cout(c22_24)  ); 
 carry_save_3inputs #(W+5) cs_3in_9 (.a({ { (5) { a[24*W+W-1] }} , a[24*W +: W] , 
                                          { (5) { a[25*W+W-1] }} , a[25*W +: W] , 
                                          { (5) { a[26*W+W-1] }} , a[26*W +: W]  }), .sum(sum25_27), .cout(c25_27)  );
 carry_save_3inputs #(W+5) cs_3in_A (.a({ { (5) { a[27*W+W-1] }} , a[27*W +: W] , 
                                          { (5) { a[28*W+W-1] }} , a[28*W +: W] , 
                                          { (5) { a[29*W+W-1] }} , a[29*W +: W]  }), .sum(sum28_30), .cout(c28_30)  );
 carry_save_3inputs #(W+5) cs_3in_B (.a({ { (5) { a[30*W+W-1] }} , a[30*W +: W] , 
                                          { (5) { a[31*W+W-1] }} , a[31*W +: W] , 
                                          { (5) { a[32*W+W-1] }} , a[32*W +: W]  }), .sum(sum31_33), .cout(c31_33)  );
 carry_save_3inputs #(W+5) cs_3in_C (.a({ { (5) { a[33*W+W-1] }} , a[33*W +: W] , 
                                          { (5) { a[34*W+W-1] }} , a[34*W +: W] , 
                                          { (5) { a[35*W+W-1] }} , a[35*W +: W]  }), .sum(sum34_36), .cout(c34_36)  );
 carry_save_3inputs #(W+5) cs_3in_D (.a({ { (5) { a[36*W+W-1] }} , a[36*W +: W] , 
                                          { (5) { a[37*W+W-1] }} , a[37*W +: W] , 
                                          { (5) { a[38*W+W-1] }} , a[38*W +: W]  }), .sum(sum37_39), .cout(c37_39)  ); 
 carry_save_3inputs #(W+5) cs_3in_E (.a({ { (5) { a[39*W+W-1] }} , a[39*W +: W] , 
                                          { (5) { a[40*W+W-1] }} , a[40*W +: W] , 
                                          { (5) { a[41*W+W-1] }} , a[41*W +: W]  }), .sum(sum40_42), .cout(c40_42)  );
 carry_save_3inputs #(W+5) cs_3in_F (.a({ { (5) { a[42*W+W-1] }} , a[42*W +: W] , 
                                          { (5) { a[43*W+W-1] }} , a[43*W +: W] , 
                                          { (5) { a[44*W+W-1] }} , a[44*W +: W]  }), .sum(sum43_45), .cout(c43_45)  ); 
 carry_save_3inputs #(W+5) cs_3in_G (.a({ { (5) { a[45*W+W-1] }} , a[45*W +: W] , 
                                          { (5) { a[46*W+W-1] }} , a[46*W +: W] , 
                                          { (5) { a[47*W+W-1] }} , a[47*W +: W]  }), .sum(sum46_48), .cout(c46_48)  );
 carry_save_3inputs #(W+5) cs_3in_H (.a({ { (5) { a[48*W+W-1] }} , a[48*W +: W] , 
                                          { (5) { a[49*W+W-1] }} , a[49*W +: W] , 
                                          { (5) { a[50*W+W-1] }} , a[50*W +: W]  }), .sum(sum49_51), .cout(c49_51)  );
 carry_save_3inputs #(W+5) cs_3in_I (.a({ { (5) { a[51*W+W-1] }} , a[51*W +: W] , 
                                          { (5) { a[52*W+W-1] }} , a[52*W +: W] , 
                                          { (5) { a[53*W+W-1] }} , a[53*W +: W]  }), .sum(sum52_54), .cout(c52_54)  );
 carry_save_3inputs #(W+5) cs_3in_J (.a({ { (5) { a[54*W+W-1] }} , a[54*W +: W] , 
                                          { (5) { a[55*W+W-1] }} , a[55*W +: W] , 
                                          { (5) { a[56*W+W-1] }} , a[56*W +: W]  }), .sum(sum55_57), .cout(c55_57)  ); 
 carry_save_3inputs #(W+5) cs_3in_K (.a({ { (5) { a[57*W+W-1] }} , a[57*W +: W] , 
                                          { (5) { a[58*W+W-1] }} , a[58*W +: W] , 
                                          { (5) { a[59*W+W-1] }} , a[59*W +: W]  }), .sum(sum58_60), .cout(c58_60)  );
 carry_save_3inputs #(W+5) cs_3in_L (.a({ { (5) { a[60*W+W-1] }} , a[60*W +: W] , 
                                          { (5) { a[61*W+W-1] }} , a[61*W +: W] , 
                                          { (5) { a[62*W+W-1] }} , a[62*W +: W]  }), .sum(sum61_63), .cout(c61_63)  ); // a(63) do not added


 carry_save_3inputs #(W+5+1) cs_3in_sum_1(.a({ sum01_03, c01_03, sum04_06                         }),.sum(sum_1), .cout(c_1) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_2(.a({ c04_06, sum07_09, c07_09                           }),.sum(sum_2), .cout(c_2) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_3(.a({ sum10_12, c10_12, sum13_15                         }),.sum(sum_3), .cout(c_3) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_4(.a({ c13_15, sum16_18, c16_18                           }),.sum(sum_4), .cout(c_4) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_5(.a({ sum19_21, c19_21, sum22_24                         }),.sum(sum_5), .cout(c_5) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_6(.a({ c22_24, sum25_27, c25_27                           }),.sum(sum_6), .cout(c_6) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_7(.a({ sum28_30, c28_30, sum31_33                         }),.sum(sum_7), .cout(c_7) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_8(.a({ c31_33, sum34_36, c34_36                           }),.sum(sum_8), .cout(c_8) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_9(.a({ sum37_39, c37_39, sum40_42                         }),.sum(sum_9), .cout(c_9) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_A(.a({ c40_42, sum43_45, c43_45                           }),.sum(sum_A), .cout(c_A) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_B(.a({ sum46_48, c46_48, sum49_51                         }),.sum(sum_B), .cout(c_B) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_C(.a({ c49_51, sum52_54, c52_54                           }),.sum(sum_C), .cout(c_C) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_D(.a({ sum55_57, c55_57, sum58_60                         }),.sum(sum_D), .cout(c_D) );
 carry_save_3inputs #(W+5+1) cs_3in_sum_E(.a({ sum61_63, c58_60, {(6){a[63*W+W-1]}}, a[63*W +: W ]}),.sum(sum_E), .cout(c_E) );// c61_63 do not added


 carry_save_3inputs #(W+5+2) cs_3in_30(.a({ sum_1, c_1, sum_2               }), .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+5+2) cs_3in_31(.a({ c_2, sum_3, c_3                 }), .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+5+2) cs_3in_32(.a({ sum_4, c_4, sum_5               }), .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+5+2) cs_3in_33(.a({ c_5, sum_6, c_6                 }), .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+5+2) cs_3in_34(.a({ sum_7, c_7, sum_8               }), .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+5+2) cs_3in_35(.a({ c_8, sum_9, c_9                 }), .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+5+2) cs_3in_36(.a({ sum_A, c_A, sum_B               }), .sum(sum_17), .cout(c_17) );
 carry_save_3inputs #(W+5+2) cs_3in_37(.a({ c_B, sum_C, c_C                 }), .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+5+2) cs_3in_38(.a({ c_E, c_D, {c61_63[W+6], c61_63} }), .sum(sum_19), .cout(c_19) ); // sum_D, sum_E, do not added


 carry_save_3inputs #(W+5+3) cs_3in_40(.a({ sum_11, c_11, sum_12}), .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+5+3) cs_3in_41(.a({ c_12, sum_13, c_13  }), .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+5+3) cs_3in_43(.a({ sum_14, c_14, sum_15}), .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+5+3) cs_3in_44(.a({ c_15, sum_16, c_16  }), .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+5+3) cs_3in_45(.a({ sum_17, c_17, sum_18}), .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+5+3) cs_3in_46(.a({ c_18, sum_19, c_19  }), .sum(sum_26), .cout(c_26) ); // sum_D, sum_E, do not added + 2


 carry_save_3inputs #(W+5+4) cs_3in_50(.a({ sum_21, c_21, sum_22}), .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+5+4) cs_3in_51(.a({ c_22, sum_23, c_23  }), .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+5+4) cs_3in_52(.a({ sum_24, c_24, sum_25}), .sum(sum_33), .cout(c_33) );
 carry_save_3inputs #(W+5+4) cs_3in_53(.a({ c_25, sum_26, c_26  }), .sum(sum_34), .cout(c_34) ); // sum_D, sum_E, do not added + 3


 carry_save_3inputs #(W+5+5) cs_3in_60(.a({ sum_31, c_31, sum_32                  }), .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+5+5) cs_3in_61(.a({ sum_33, c_32, c_33                    }), .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+5+5) cs_3in_62(.a({ sum_34, c_34, {(3){sum_D[W+7]}},sum_D }), .sum(sum_43), .cout(c_43) );// sum_E, do not added + 4

carry_save_7inputs #(W+5+6) cs_7in (.a({sum_41, sum_42, sum_43, c_41, c_42, c_43 , {(4){sum_E[W+7]}}, sum_E }), .sum(sum5), .cout(cout5)  );

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

wire [W+6:0] sum000, c000, sum003, c003, sum006, c006, sum009, c009, sum012, c012, sum015, c015, sum018, c018, sum021, c021; 
wire [W+6:0] sum024, c024, sum027, c027, sum030, c030, sum033, c033, sum036, c036, sum039, c039, sum042, c042, sum045, c045; 
wire [W+6:0] sum048, c048, sum051, c051, sum054, c054, sum057, c057, sum060, c060, sum063, c063, sum066, c066, sum069, c069; 
wire [W+6:0] sum072, c072, sum075, c075, sum078, c078, sum081, c081, sum084, c084, sum087, c087, sum090, c090, sum093, c093; 
wire [W+6:0] sum096, c096, sum099, c099, sum102, c102, sum105, c105, sum108, c108, sum111, c111, sum114, c114, sum117, c117, sum120, c120, sum123, c123;
wire [W+6+1:0] sum_01, c_01, sum_02, c_02, sum_03, c_03, sum_04, c_04, sum_05, c_05, sum_06, c_06, sum_07, c_07, sum_08, c_08;
wire [W+6+1:0] sum_09, c_09, sum_10, c_10, sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16;
wire [W+6+1:0] sum_17, c_17, sum_18, c_18, sum_19, c_19, sum_20, c_20, sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+6+1:0] sum_25, c_25, sum_26, c_26, sum_27, c_27, sum_28, c_28;
wire [W+6+2:0] sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34, sum_35, c_35, sum_36, c_36, sum_37, c_37, sum_38, c_38;
wire [W+6+2:0] sum_39, c_39, sum_40, c_40, sum_41, c_41, sum_42, c_42, sum_43, c_43, sum_44, c_44, sum_45, c_45, sum_46, c_46; 
wire [W+6+2:0] sum_47, c_47, sum_48, c_48, sum_49, c_49;
wire [W+6+3:0] sum_51, c_51, sum_52, c_52, sum_53, c_53, sum_54, c_54, sum_55, c_55, sum_56, c_56, sum_57, c_57, sum_58, c_58;
wire [W+6+3:0] sum_59, c_59, sum_60, c_60, sum_61, c_61, sum_62, c_62, sum_63, c_63;
wire [W+6+4:0] sum_71, c_71, sum_72, c_72, sum_73, c_73, sum_74, c_74, sum_75, c_75, sum_76, c_76, sum_77, c_77, sum_78, c_78;
wire [W+6+5:0] sum_81, c_81, sum_82, c_82, sum_83, c_83, sum_84, c_84, sum_85, c_85, sum_86, c_86;
wire [W+6+6:0] sum_91, c_91, sum_92, c_92, sum_93, c_93, sum_94, c_94;

wire [W+6+9:0] sum5, cout5;

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



 carry_save_3inputs #(W+6) cs_3in_000 (.a({  {(6){a[  0*W+W-1]}} , a[  0*W +: W] , {(6){a[(  0+1)*W+W-1]}} , a[(  0+1)*W +: W] , {(6){a[(  0+2)*W+W-1]}} , a[(  0+2)*W +: W] }), .sum(sum000), .cout(c000) );
 carry_save_3inputs #(W+6) cs_3in_003 (.a({  {(6){a[  3*W+W-1]}} , a[  3*W +: W] , {(6){a[(  3+1)*W+W-1]}} , a[(  3+1)*W +: W] , {(6){a[(  3+2)*W+W-1]}} , a[(  3+2)*W +: W] }), .sum(sum003), .cout(c003) );
 carry_save_3inputs #(W+6) cs_3in_006 (.a({  {(6){a[  6*W+W-1]}} , a[  6*W +: W] , {(6){a[(  6+1)*W+W-1]}} , a[(  6+1)*W +: W] , {(6){a[(  6+2)*W+W-1]}} , a[(  6+2)*W +: W] }), .sum(sum006), .cout(c006) );
 carry_save_3inputs #(W+6) cs_3in_009 (.a({  {(6){a[  9*W+W-1]}} , a[  9*W +: W] , {(6){a[(  9+1)*W+W-1]}} , a[(  9+1)*W +: W] , {(6){a[(  9+2)*W+W-1]}} , a[(  9+2)*W +: W] }), .sum(sum009), .cout(c009) );
 carry_save_3inputs #(W+6) cs_3in_012 (.a({  {(6){a[ 12*W+W-1]}} , a[ 12*W +: W] , {(6){a[( 12+1)*W+W-1]}} , a[( 12+1)*W +: W] , {(6){a[( 12+2)*W+W-1]}} , a[( 12+2)*W +: W] }), .sum(sum012), .cout(c012) );
 carry_save_3inputs #(W+6) cs_3in_015 (.a({  {(6){a[ 15*W+W-1]}} , a[ 15*W +: W] , {(6){a[( 15+1)*W+W-1]}} , a[( 15+1)*W +: W] , {(6){a[( 15+2)*W+W-1]}} , a[( 15+2)*W +: W] }), .sum(sum015), .cout(c015) );
 carry_save_3inputs #(W+6) cs_3in_018 (.a({  {(6){a[ 18*W+W-1]}} , a[ 18*W +: W] , {(6){a[( 18+1)*W+W-1]}} , a[( 18+1)*W +: W] , {(6){a[( 18+2)*W+W-1]}} , a[( 18+2)*W +: W] }), .sum(sum018), .cout(c018) );
 carry_save_3inputs #(W+6) cs_3in_021 (.a({  {(6){a[ 21*W+W-1]}} , a[ 21*W +: W] , {(6){a[( 21+1)*W+W-1]}} , a[( 21+1)*W +: W] , {(6){a[( 21+2)*W+W-1]}} , a[( 21+2)*W +: W] }), .sum(sum021), .cout(c021) );
 carry_save_3inputs #(W+6) cs_3in_024 (.a({  {(6){a[ 24*W+W-1]}} , a[ 24*W +: W] , {(6){a[( 24+1)*W+W-1]}} , a[( 24+1)*W +: W] , {(6){a[( 24+2)*W+W-1]}} , a[( 24+2)*W +: W] }), .sum(sum024), .cout(c024) );
 carry_save_3inputs #(W+6) cs_3in_027 (.a({  {(6){a[ 27*W+W-1]}} , a[ 27*W +: W] , {(6){a[( 27+1)*W+W-1]}} , a[( 27+1)*W +: W] , {(6){a[( 27+2)*W+W-1]}} , a[( 27+2)*W +: W] }), .sum(sum027), .cout(c027) );
 carry_save_3inputs #(W+6) cs_3in_030 (.a({  {(6){a[ 30*W+W-1]}} , a[ 30*W +: W] , {(6){a[( 30+1)*W+W-1]}} , a[( 30+1)*W +: W] , {(6){a[( 30+2)*W+W-1]}} , a[( 30+2)*W +: W] }), .sum(sum030), .cout(c030) );
 carry_save_3inputs #(W+6) cs_3in_033 (.a({  {(6){a[ 33*W+W-1]}} , a[ 33*W +: W] , {(6){a[( 33+1)*W+W-1]}} , a[( 33+1)*W +: W] , {(6){a[( 33+2)*W+W-1]}} , a[( 33+2)*W +: W] }), .sum(sum033), .cout(c033) );
 carry_save_3inputs #(W+6) cs_3in_036 (.a({  {(6){a[ 36*W+W-1]}} , a[ 36*W +: W] , {(6){a[( 36+1)*W+W-1]}} , a[( 36+1)*W +: W] , {(6){a[( 36+2)*W+W-1]}} , a[( 36+2)*W +: W] }), .sum(sum036), .cout(c036) );
 carry_save_3inputs #(W+6) cs_3in_039 (.a({  {(6){a[ 39*W+W-1]}} , a[ 39*W +: W] , {(6){a[( 39+1)*W+W-1]}} , a[( 39+1)*W +: W] , {(6){a[( 39+2)*W+W-1]}} , a[( 39+2)*W +: W] }), .sum(sum039), .cout(c039) );
 carry_save_3inputs #(W+6) cs_3in_042 (.a({  {(6){a[ 42*W+W-1]}} , a[ 42*W +: W] , {(6){a[( 42+1)*W+W-1]}} , a[( 42+1)*W +: W] , {(6){a[( 42+2)*W+W-1]}} , a[( 42+2)*W +: W] }), .sum(sum042), .cout(c042) );
 carry_save_3inputs #(W+6) cs_3in_045 (.a({  {(6){a[ 45*W+W-1]}} , a[ 45*W +: W] , {(6){a[( 45+1)*W+W-1]}} , a[( 45+1)*W +: W] , {(6){a[( 45+2)*W+W-1]}} , a[( 45+2)*W +: W] }), .sum(sum045), .cout(c045) );
 carry_save_3inputs #(W+6) cs_3in_048 (.a({  {(6){a[ 48*W+W-1]}} , a[ 48*W +: W] , {(6){a[( 48+1)*W+W-1]}} , a[( 48+1)*W +: W] , {(6){a[( 48+2)*W+W-1]}} , a[( 48+2)*W +: W] }), .sum(sum048), .cout(c048) );
 carry_save_3inputs #(W+6) cs_3in_051 (.a({  {(6){a[ 51*W+W-1]}} , a[ 51*W +: W] , {(6){a[( 51+1)*W+W-1]}} , a[( 51+1)*W +: W] , {(6){a[( 51+2)*W+W-1]}} , a[( 51+2)*W +: W] }), .sum(sum051), .cout(c051) );
 carry_save_3inputs #(W+6) cs_3in_054 (.a({  {(6){a[ 54*W+W-1]}} , a[ 54*W +: W] , {(6){a[( 54+1)*W+W-1]}} , a[( 54+1)*W +: W] , {(6){a[( 54+2)*W+W-1]}} , a[( 54+2)*W +: W] }), .sum(sum054), .cout(c054) );
 carry_save_3inputs #(W+6) cs_3in_057 (.a({  {(6){a[ 57*W+W-1]}} , a[ 57*W +: W] , {(6){a[( 57+1)*W+W-1]}} , a[( 57+1)*W +: W] , {(6){a[( 57+2)*W+W-1]}} , a[( 57+2)*W +: W] }), .sum(sum057), .cout(c057) );
 carry_save_3inputs #(W+6) cs_3in_060 (.a({  {(6){a[ 60*W+W-1]}} , a[ 60*W +: W] , {(6){a[( 60+1)*W+W-1]}} , a[( 60+1)*W +: W] , {(6){a[( 60+2)*W+W-1]}} , a[( 60+2)*W +: W] }), .sum(sum060), .cout(c060) ); 
 carry_save_3inputs #(W+6) cs_3in_063 (.a({  {(6){a[ 63*W+W-1]}} , a[ 63*W +: W] , {(6){a[( 63+1)*W+W-1]}} , a[( 63+1)*W +: W] , {(6){a[( 63+2)*W+W-1]}} , a[( 63+2)*W +: W] }), .sum(sum063), .cout(c063) );
 carry_save_3inputs #(W+6) cs_3in_066 (.a({  {(6){a[ 66*W+W-1]}} , a[ 66*W +: W] , {(6){a[( 66+1)*W+W-1]}} , a[( 66+1)*W +: W] , {(6){a[( 66+2)*W+W-1]}} , a[( 66+2)*W +: W] }), .sum(sum066), .cout(c066) );
 carry_save_3inputs #(W+6) cs_3in_069 (.a({  {(6){a[ 69*W+W-1]}} , a[ 69*W +: W] , {(6){a[( 69+1)*W+W-1]}} , a[( 69+1)*W +: W] , {(6){a[( 69+2)*W+W-1]}} , a[( 69+2)*W +: W] }), .sum(sum069), .cout(c069) );
 carry_save_3inputs #(W+6) cs_3in_072 (.a({  {(6){a[ 72*W+W-1]}} , a[ 72*W +: W] , {(6){a[( 72+1)*W+W-1]}} , a[( 72+1)*W +: W] , {(6){a[( 72+2)*W+W-1]}} , a[( 72+2)*W +: W] }), .sum(sum072), .cout(c072) );
 carry_save_3inputs #(W+6) cs_3in_075 (.a({  {(6){a[ 75*W+W-1]}} , a[ 75*W +: W] , {(6){a[( 75+1)*W+W-1]}} , a[( 75+1)*W +: W] , {(6){a[( 75+2)*W+W-1]}} , a[( 75+2)*W +: W] }), .sum(sum075), .cout(c075) );
 carry_save_3inputs #(W+6) cs_3in_078 (.a({  {(6){a[ 78*W+W-1]}} , a[ 78*W +: W] , {(6){a[( 78+1)*W+W-1]}} , a[( 78+1)*W +: W] , {(6){a[( 78+2)*W+W-1]}} , a[( 78+2)*W +: W] }), .sum(sum078), .cout(c078) );
 carry_save_3inputs #(W+6) cs_3in_081 (.a({  {(6){a[ 81*W+W-1]}} , a[ 81*W +: W] , {(6){a[( 81+1)*W+W-1]}} , a[( 81+1)*W +: W] , {(6){a[( 81+2)*W+W-1]}} , a[( 81+2)*W +: W] }), .sum(sum081), .cout(c081) );
 carry_save_3inputs #(W+6) cs_3in_084 (.a({  {(6){a[ 84*W+W-1]}} , a[ 84*W +: W] , {(6){a[( 84+1)*W+W-1]}} , a[( 84+1)*W +: W] , {(6){a[( 84+2)*W+W-1]}} , a[( 84+2)*W +: W] }), .sum(sum084), .cout(c084) );
 carry_save_3inputs #(W+6) cs_3in_087 (.a({  {(6){a[ 87*W+W-1]}} , a[ 87*W +: W] , {(6){a[( 87+1)*W+W-1]}} , a[( 87+1)*W +: W] , {(6){a[( 87+2)*W+W-1]}} , a[( 87+2)*W +: W] }), .sum(sum087), .cout(c087) );
 carry_save_3inputs #(W+6) cs_3in_090 (.a({  {(6){a[ 90*W+W-1]}} , a[ 90*W +: W] , {(6){a[( 90+1)*W+W-1]}} , a[( 90+1)*W +: W] , {(6){a[( 90+2)*W+W-1]}} , a[( 90+2)*W +: W] }), .sum(sum090), .cout(c090) );
 carry_save_3inputs #(W+6) cs_3in_093 (.a({  {(6){a[ 93*W+W-1]}} , a[ 93*W +: W] , {(6){a[( 93+1)*W+W-1]}} , a[( 93+1)*W +: W] , {(6){a[( 93+2)*W+W-1]}} , a[( 93+2)*W +: W] }), .sum(sum093), .cout(c093) );
 carry_save_3inputs #(W+6) cs_3in_096 (.a({  {(6){a[ 96*W+W-1]}} , a[ 96*W +: W] , {(6){a[( 96+1)*W+W-1]}} , a[( 96+1)*W +: W] , {(6){a[( 96+2)*W+W-1]}} , a[( 96+2)*W +: W] }), .sum(sum096), .cout(c096) );
 carry_save_3inputs #(W+6) cs_3in_099 (.a({  {(6){a[ 99*W+W-1]}} , a[ 99*W +: W] , {(6){a[( 99+1)*W+W-1]}} , a[( 99+1)*W +: W] , {(6){a[( 99+2)*W+W-1]}} , a[( 99+2)*W +: W] }), .sum(sum099), .cout(c099) );
 carry_save_3inputs #(W+6) cs_3in_102 (.a({  {(6){a[102*W+W-1]}} , a[102*W +: W] , {(6){a[(102+1)*W+W-1]}} , a[(102+1)*W +: W] , {(6){a[(102+2)*W+W-1]}} , a[(102+2)*W +: W] }), .sum(sum102), .cout(c102) );
 carry_save_3inputs #(W+6) cs_3in_105 (.a({  {(6){a[105*W+W-1]}} , a[105*W +: W] , {(6){a[(105+1)*W+W-1]}} , a[(105+1)*W +: W] , {(6){a[(105+2)*W+W-1]}} , a[(105+2)*W +: W] }), .sum(sum105), .cout(c105) );
 carry_save_3inputs #(W+6) cs_3in_108 (.a({  {(6){a[108*W+W-1]}} , a[108*W +: W] , {(6){a[(108+1)*W+W-1]}} , a[(108+1)*W +: W] , {(6){a[(108+2)*W+W-1]}} , a[(108+2)*W +: W] }), .sum(sum108), .cout(c108) );
 carry_save_3inputs #(W+6) cs_3in_111 (.a({  {(6){a[111*W+W-1]}} , a[111*W +: W] , {(6){a[(111+1)*W+W-1]}} , a[(111+1)*W +: W] , {(6){a[(111+2)*W+W-1]}} , a[(111+2)*W +: W] }), .sum(sum111), .cout(c111) );
 carry_save_3inputs #(W+6) cs_3in_114 (.a({  {(6){a[114*W+W-1]}} , a[114*W +: W] , {(6){a[(114+1)*W+W-1]}} , a[(114+1)*W +: W] , {(6){a[(114+2)*W+W-1]}} , a[(114+2)*W +: W] }), .sum(sum114), .cout(c114) );
 carry_save_3inputs #(W+6) cs_3in_117 (.a({  {(6){a[117*W+W-1]}} , a[117*W +: W] , {(6){a[(117+1)*W+W-1]}} , a[(117+1)*W +: W] , {(6){a[(117+2)*W+W-1]}} , a[(117+2)*W +: W] }), .sum(sum117), .cout(c117) );
 carry_save_3inputs #(W+6) cs_3in_120 (.a({  {(6){a[120*W+W-1]}} , a[120*W +: W] , {(6){a[(120+1)*W+W-1]}} , a[(120+1)*W +: W] , {(6){a[(120+2)*W+W-1]}} , a[(120+2)*W +: W] }), .sum(sum120), .cout(c120) );
 carry_save_3inputs #(W+6) cs_3in_123 (.a({  {(6){a[123*W+W-1]}} , a[123*W +: W] , {(6){a[(123+1)*W+W-1]}} , a[(123+1)*W +: W] , {(6){a[(123+2)*W+W-1]}} , a[(123+2)*W +: W] }), .sum(sum123), .cout(c123) ); // a(126) , a(127) do not added



 carry_save_3inputs #(W+6+1) cs_3in_01(.a({ sum000, c000, sum003 }), .sum(sum_01), .cout(c_01) );
 carry_save_3inputs #(W+6+1) cs_3in_02(.a({ c003, sum006, c006   }), .sum(sum_02), .cout(c_02) );
 carry_save_3inputs #(W+6+1) cs_3in_03(.a({ sum009, c009, sum012 }), .sum(sum_03), .cout(c_03) );
 carry_save_3inputs #(W+6+1) cs_3in_04(.a({ c012, sum015, c015   }), .sum(sum_04), .cout(c_04) );
 carry_save_3inputs #(W+6+1) cs_3in_05(.a({ sum018, c018, sum021 }), .sum(sum_05), .cout(c_05) );
 carry_save_3inputs #(W+6+1) cs_3in_06(.a({ c021, sum024, c024   }), .sum(sum_06), .cout(c_06) );
 carry_save_3inputs #(W+6+1) cs_3in_07(.a({ sum027, c027, sum030 }), .sum(sum_07), .cout(c_07) );
 carry_save_3inputs #(W+6+1) cs_3in_08(.a({ c030, sum033, c033   }), .sum(sum_08), .cout(c_08) );
 carry_save_3inputs #(W+6+1) cs_3in_09(.a({ sum036, c036, sum039 }), .sum(sum_09), .cout(c_09) );
 carry_save_3inputs #(W+6+1) cs_3in_10(.a({ c039, sum042, c042   }), .sum(sum_10), .cout(c_10) );
 carry_save_3inputs #(W+6+1) cs_3in_11(.a({ sum045, c045, sum048 }), .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+6+1) cs_3in_12(.a({ c048, sum051, c051   }), .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+6+1) cs_3in_13(.a({ sum054, c054, sum057 }), .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+6+1) cs_3in_14(.a({ c057, sum060, c060   }), .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+6+1) cs_3in_15(.a({ sum063, c063, sum066 }), .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+6+1) cs_3in_16(.a({ c066, sum069, c069   }), .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+6+1) cs_3in_17(.a({ sum072, c072, sum075 }), .sum(sum_17), .cout(c_17) );
 carry_save_3inputs #(W+6+1) cs_3in_18(.a({ c075, sum078, c078   }), .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+6+1) cs_3in_19(.a({ sum081, c081, sum084 }), .sum(sum_19), .cout(c_19) );
 carry_save_3inputs #(W+6+1) cs_3in_20(.a({ c084, sum087, c087   }), .sum(sum_20), .cout(c_20) );
 carry_save_3inputs #(W+6+1) cs_3in_21(.a({ sum090, c090, sum093 }), .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+6+1) cs_3in_22(.a({ c093, sum096, c096   }), .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+6+1) cs_3in_23(.a({ sum099, c099, sum102 }), .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+6+1) cs_3in_24(.a({ c102, sum105, c105   }), .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+6+1) cs_3in_25(.a({ sum108, c108, sum111 }), .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+6+1) cs_3in_26(.a({ c111, sum114, c114   }), .sum(sum_26), .cout(c_26) );
 carry_save_3inputs #(W+6+1) cs_3in_27(.a({ sum117, c117, sum120 }), .sum(sum_27), .cout(c_27) );
 carry_save_3inputs #(W+6+1) cs_3in_28(.a({ c120, sum123, c123   }), .sum(sum_28), .cout(c_28) ); // a(126) , a(127) do not added +2

 carry_save_3inputs #(W+6+2) cs_3in_31(.a({ sum_01, c_01, sum_02}),                                     .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+6+2) cs_3in_32(.a({ c_02, sum_03, c_03  }),                                     .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+6+2) cs_3in_33(.a({ sum_04, c_04, sum_05}),                                     .sum(sum_33), .cout(c_33) );
 carry_save_3inputs #(W+6+2) cs_3in_34(.a({ c_05, sum_06, c_06  }),                                     .sum(sum_34), .cout(c_34) );
 carry_save_3inputs #(W+6+2) cs_3in_35(.a({ sum_07, c_07, sum_08}),                                     .sum(sum_35), .cout(c_35) );
 carry_save_3inputs #(W+6+2) cs_3in_36(.a({ c_08, sum_09, c_09  }),                                     .sum(sum_36), .cout(c_36) );
 carry_save_3inputs #(W+6+2) cs_3in_37(.a({ sum_10, c_10, sum_11}),                                     .sum(sum_37), .cout(c_37) );
 carry_save_3inputs #(W+6+2) cs_3in_38(.a({ c_11, sum_12, c_12  }),                                     .sum(sum_38), .cout(c_38) );
 carry_save_3inputs #(W+6+2) cs_3in_39(.a({ sum_13, c_13, sum_14}),                                     .sum(sum_39), .cout(c_39) );
 carry_save_3inputs #(W+6+2) cs_3in_40(.a({ c_14, sum_15, c_15  }),                                     .sum(sum_40), .cout(c_40) );
 carry_save_3inputs #(W+6+2) cs_3in_41(.a({ sum_16, c_16, sum_17}),                                     .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+6+2) cs_3in_42(.a({ c_17, sum_18, c_18  }),                                     .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+6+2) cs_3in_43(.a({ sum_19, c_19, sum_20}),                                     .sum(sum_43), .cout(c_43) );
 carry_save_3inputs #(W+6+2) cs_3in_44(.a({ c_20, sum_21, c_21  }),                                     .sum(sum_44), .cout(c_44) );
 carry_save_3inputs #(W+6+2) cs_3in_45(.a({ sum_22, c_22, sum_23}),                                     .sum(sum_45), .cout(c_45) );
 carry_save_3inputs #(W+6+2) cs_3in_46(.a({ c_23, sum_24, c_24  }),                                     .sum(sum_46), .cout(c_46) );
 carry_save_3inputs #(W+6+2) cs_3in_47(.a({ sum_25, c_25, sum_26}),                                     .sum(sum_47), .cout(c_47) );
 carry_save_3inputs #(W+6+2) cs_3in_48(.a({ c_26, sum_27, c_27  }),                                     .sum(sum_48), .cout(c_48) ); 
 carry_save_3inputs #(W+6+2) cs_3in_49(.a({ sum_28, {(6+2){a[126*W+W-1]}}, a[126*W +: W ], {(6+2){a[127*W+W-1]}}, a[127*W +: W ] }), .sum(sum_49), .cout(c_49) ); // c_28 do not added

 carry_save_3inputs #(W+6+3) cs_3in_51(.a({ sum_31, c_31, sum_32        }), .sum(sum_51), .cout(c_51) );
 carry_save_3inputs #(W+6+3) cs_3in_52(.a({ c_32,  sum_33, c_33         }), .sum(sum_52), .cout(c_52) );
 carry_save_3inputs #(W+6+3) cs_3in_53(.a({ sum_34, c_34, sum_35        }), .sum(sum_53), .cout(c_53) );
 carry_save_3inputs #(W+6+3) cs_3in_54(.a({ c_35,  sum_36, c_36         }), .sum(sum_54), .cout(c_54) );
 carry_save_3inputs #(W+6+3) cs_3in_55(.a({ sum_37, c_37, sum_38        }), .sum(sum_55), .cout(c_55) );
 carry_save_3inputs #(W+6+3) cs_3in_56(.a({ c_38,  sum_39, c_39         }), .sum(sum_56), .cout(c_56) );
 carry_save_3inputs #(W+6+3) cs_3in_57(.a({ sum_40, c_40, sum_41        }), .sum(sum_57), .cout(c_57) );
 carry_save_3inputs #(W+6+3) cs_3in_58(.a({ c_41,  sum_42, c_42         }), .sum(sum_58), .cout(c_58) );
 carry_save_3inputs #(W+6+3) cs_3in_59(.a({ sum_43, c_43, sum_44        }), .sum(sum_59), .cout(c_59) );
 carry_save_3inputs #(W+6+3) cs_3in_60(.a({ c_44,  sum_45, c_45         }), .sum(sum_60), .cout(c_60) );
 carry_save_3inputs #(W+6+3) cs_3in_61(.a({ sum_46, c_46, sum_47        }), .sum(sum_61), .cout(c_61) );
 carry_save_3inputs #(W+6+3) cs_3in_62(.a({ c_47,  sum_48, c_48         }), .sum(sum_62), .cout(c_62) ); 
 carry_save_3inputs #(W+6+3) cs_3in_63(.a({ sum_49,c_49,c_28[W+6+1],c_28}), .sum(sum_63), .cout(c_63) ); 

 carry_save_3inputs #(W+6+4) cs_3in_71(.a({ sum_51, c_51, sum_52 }), .sum(sum_71), .cout(c_71) );
 carry_save_3inputs #(W+6+4) cs_3in_72(.a({ c_52, sum_53, c_53   }), .sum(sum_72), .cout(c_72) );
 carry_save_3inputs #(W+6+4) cs_3in_73(.a({ sum_54, c_54, sum_55 }), .sum(sum_73), .cout(c_73) );
 carry_save_3inputs #(W+6+4) cs_3in_74(.a({ c_55, sum_56, c_56   }), .sum(sum_74), .cout(c_74) );
 carry_save_3inputs #(W+6+4) cs_3in_75(.a({ sum_57, c_57, sum_58 }), .sum(sum_75), .cout(c_75) );
 carry_save_3inputs #(W+6+4) cs_3in_76(.a({ c_58, sum_59, c_59   }), .sum(sum_76), .cout(c_76) );
 carry_save_3inputs #(W+6+4) cs_3in_77(.a({ sum_60, c_60, sum_61 }), .sum(sum_77), .cout(c_77) );
 carry_save_3inputs #(W+6+4) cs_3in_78(.a({ c_61, sum_62, c_62   }), .sum(sum_78), .cout(c_78) );//sum_63, c_63 do not added

 carry_save_3inputs #(W+6+5) cs_3in_81(.a({ sum_71, c_71, sum_72              }), .sum(sum_81), .cout(c_81) );
 carry_save_3inputs #(W+6+5) cs_3in_82(.a({ c_72, sum_73, c_73                }), .sum(sum_82), .cout(c_82) );
 carry_save_3inputs #(W+6+5) cs_3in_83(.a({ sum_74, c_74, sum_75              }), .sum(sum_83), .cout(c_83) );
 carry_save_3inputs #(W+6+5) cs_3in_84(.a({ c_75, sum_76, c_76                }), .sum(sum_84), .cout(c_84) );
 carry_save_3inputs #(W+6+5) cs_3in_85(.a({ sum_77, c_77, sum_63[W+6+3],sum_63}), .sum(sum_85), .cout(c_85) );
 carry_save_3inputs #(W+6+5) cs_3in_86(.a({ sum_78, c_78, c_63  [W+6+3],c_63  }), .sum(sum_86), .cout(c_86) );

 carry_save_3inputs #(W+6+6) cs_3in_91(.a({ sum_81, c_81, sum_82 }), .sum(sum_91), .cout(c_91) );
 carry_save_3inputs #(W+6+6) cs_3in_92(.a({ c_82, sum_83, c_83   }), .sum(sum_92), .cout(c_92) );
 carry_save_3inputs #(W+6+6) cs_3in_93(.a({ sum_84, c_84, sum_85 }), .sum(sum_93), .cout(c_93) );
 carry_save_3inputs #(W+6+6) cs_3in_94(.a({ c_85, sum_86, c_86   }), .sum(sum_94), .cout(c_94) );
  
carry_save_8inputs #(W+6+7) cs_7in (.a({ sum_91, sum_92, sum_93, sum_94, c_91, c_92, c_93, c_94  }), .sum(sum5), .cout(cout5)  );

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

wire [W+7:0] sum000, c000, sum003, c003, sum006, c006, sum009, c009, sum012, c012, sum015, c015, sum018, c018, sum021, c021; 
wire [W+7:0] sum024, c024, sum027, c027, sum030, c030, sum033, c033, sum036, c036, sum039, c039, sum042, c042, sum045, c045; 
wire [W+7:0] sum048, c048, sum051, c051, sum054, c054, sum057, c057, sum060, c060, sum063, c063, sum066, c066, sum069, c069; 
wire [W+7:0] sum072, c072, sum075, c075, sum078, c078, sum081, c081, sum084, c084, sum087, c087, sum090, c090, sum093, c093; 
wire [W+7:0] sum096, c096, sum099, c099, sum102, c102, sum105, c105, sum108, c108, sum111, c111, sum114, c114, sum117, c117, sum120, c120, sum123, c123;
wire [W+7:0] sum126, c126, sum129, c129, sum132, c132, sum135, c135, sum138, c138, sum141, c141, sum144, c144, sum147, c147;
wire [W+7:0] sum150, c150, sum153, c153, sum156, c156, sum159, c159, sum162, c162, sum165, c165, sum168, c168, sum171, c171;
wire [W+7:0] sum174, c174, sum177, c177, sum180, c180, sum183, c183, sum186, c186, sum189, c189, sum192, c192, sum195, c195;
wire [W+7:0] sum198, c198, sum201, c201, sum204, c204, sum207, c207, sum210, c210, sum213, c213, sum216, c216, sum219, c219;
wire [W+7:0] sum222, c222, sum225, c225, sum228, c228, sum231, c231, sum234, c234, sum237, c237, sum240, c240, sum243, c243, sum246, c246, sum249, c249, sum252, c252; 

wire [W+7+1:0] sum_01, c_01, sum_02, c_02, sum_03, c_03, sum_04, c_04, sum_05, c_05, sum_06, c_06, sum_07, c_07, sum_08, c_08;
wire [W+7+1:0] sum_09, c_09, sum_10, c_10, sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16;
wire [W+7+1:0] sum_17, c_17, sum_18, c_18, sum_19, c_19, sum_20, c_20, sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+7+1:0] sum_25, c_25, sum_26, c_26, sum_27, c_27, sum_28, c_28;
wire [W+7+1:0] sum_29, c_29, sum_30, c_30, sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34, sum_35, c_35, sum_36, c_36;
wire [W+7+1:0] sum_37, c_37, sum_38, c_38, sum_39, c_39, sum_40, c_40, sum_41, c_41, sum_42, c_42, sum_43, c_43, sum_44, c_44;
wire [W+7+1:0] sum_45, c_45, sum_46, c_46, sum_47, c_47, sum_48, c_48, sum_49, c_49, sum_50, c_50, sum_51, c_51, sum_52, c_52;
wire [W+7+1:0] sum_53, c_53, sum_54, c_54, sum_55, c_55, sum_56, c_56, sum_57, c_57;

wire [W+7+2:0] sum_61, c_61, sum_62, c_62, sum_63, c_63, sum_64, c_64, sum_65, c_65, sum_66, c_66, sum_67, c_67, sum_68, c_68; 
wire [W+7+2:0] sum_69, c_69, sum_70, c_70, sum_71, c_71, sum_72, c_72, sum_73, c_73, sum_74, c_74, sum_75, c_75, sum_76, c_76; 
wire [W+7+2:0] sum_77, c_77, sum_78, c_78, sum_79, c_79, sum_80, c_80, sum_81, c_81, sum_82, c_82, sum_83, c_83, sum_84, c_84; 
wire [W+7+2:0] sum_85, c_85, sum_86, c_86, sum_87, c_87, sum_88, c_88, sum_89, c_89, sum_90, c_90, sum_91, c_91, sum_92, c_92; 
wire [W+7+2:0] sum_93, c_93, sum_94, c_94, sum_95, c_95, sum_96, c_96, sum_97, c_97, sum_98, c_98;

wire [W+7+3:0] sum_301, c_301, sum_302, c_302, sum_303, c_303, sum_304, c_304, sum_305, c_305, sum_306, c_306, sum_307, c_307, sum_308, c_308; 
wire [W+7+3:0] sum_309, c_309, sum_310, c_310, sum_311, c_311, sum_312, c_312, sum_313, c_313, sum_314, c_314, sum_315, c_315, sum_316, c_316;
wire [W+7+3:0] sum_317, c_317, sum_318, c_318, sum_319, c_319, sum_320, c_320, sum_321, c_321, sum_322, c_322, sum_323, c_323, sum_324, c_324, sum_325, c_325;

wire [W+7+4:0] sum_331, c_331, sum_332, c_332, sum_333, c_333, sum_334, c_334, sum_335, c_335, sum_336, c_336, sum_337, c_337, sum_338, c_338;
wire [W+7+4:0] sum_339, c_339, sum_340, c_340, sum_341, c_341, sum_342, c_342, sum_343, c_343, sum_344, c_344, sum_345, c_345, sum_346, c_346, sum_347, c_347; 


wire [W+7+5:0] sum_351, c_351, sum_352, c_352, sum_353, c_353, sum_354, c_354, sum_355, c_355, sum_356, c_356, sum_357, c_357, sum_358, c_358;
wire [W+7+5:0] sum_359, c_359, sum_360, c_360, sum_361, c_361;

wire [W+7+6:0] sum_371, c_371, sum_372, c_372, sum_373, c_373, sum_374, c_374, sum_375, c_375, sum_376, c_376, sum_377, c_377; 

wire [W+7+7:0] sum_381, c_381, sum_382, c_382, sum_383, c_383, sum_384, c_384, sum_385, c_385; 
wire [W+7+8:0] sum_391, c_391, sum_392, c_392, sum_393, c_393; 

wire [W+7+11:0] sum5, cout5;

//wire [W+7+11:0]  test_in, test_1_stage, test_2_stage, test_3_stage, test_4_stage, test_5_stage, test_6_stage, test_7_stage, test_8_stage, test_9_stage, test_preout, test_out;
//assign test_in = a[  0*W +: W] + a[  1*W +: W] + a[  2*W +: W] + a[  3*W +: W] + a[  4*W +: W] + a[  5*W +: W] + a[  6*W +: W] + a[  7*W +: W] + a[  8*W +: W] + a[  9*W +: W] + 
//                 a[ 10*W +: W] + a[ 11*W +: W] + a[ 12*W +: W] + a[ 13*W +: W] + a[ 14*W +: W] + a[ 15*W +: W] + a[ 16*W +: W] + a[ 17*W +: W] + a[ 18*W +: W] + a[ 19*W +: W] + 
//                 a[ 20*W +: W] + a[ 21*W +: W] + a[ 22*W +: W] + a[ 23*W +: W] + a[ 24*W +: W] + a[ 25*W +: W] + a[ 26*W +: W] + a[ 27*W +: W] + a[ 28*W +: W] + a[ 29*W +: W] + 
//                 a[ 30*W +: W] + a[ 31*W +: W] + a[ 32*W +: W] + a[ 33*W +: W] + a[ 34*W +: W] + a[ 35*W +: W] + a[ 36*W +: W] + a[ 37*W +: W] + a[ 38*W +: W] + a[ 39*W +: W] +
//                 a[ 40*W +: W] + a[ 41*W +: W] + a[ 42*W +: W] + a[ 43*W +: W] + a[ 44*W +: W] + a[ 45*W +: W] + a[ 46*W +: W] + a[ 47*W +: W] + a[ 48*W +: W] + a[ 49*W +: W] +
//                 a[ 50*W +: W] + a[ 51*W +: W] + a[ 52*W +: W] + a[ 53*W +: W] + a[ 54*W +: W] + a[ 55*W +: W] + a[ 56*W +: W] + a[ 57*W +: W] + a[ 58*W +: W] + a[ 59*W +: W] + 
//                 a[ 60*W +: W] + a[ 61*W +: W] + a[ 62*W +: W] + a[ 63*W +: W] + a[ 64*W +: W] + a[ 65*W +: W] + a[ 66*W +: W] + a[ 67*W +: W] + a[ 68*W +: W] + a[ 69*W +: W] + 
//                 a[ 70*W +: W] + a[ 71*W +: W] + a[ 72*W +: W] + a[ 73*W +: W] + a[ 74*W +: W] + a[ 75*W +: W] + a[ 76*W +: W] + a[ 77*W +: W] + a[ 78*W +: W] + a[ 79*W +: W] + 
//                 a[ 80*W +: W] + a[ 81*W +: W] + a[ 82*W +: W] + a[ 83*W +: W] + a[ 84*W +: W] + a[ 85*W +: W] + a[ 86*W +: W] + a[ 87*W +: W] + a[ 88*W +: W] + a[ 89*W +: W] + 
//                 a[ 90*W +: W] + a[ 91*W +: W] + a[ 92*W +: W] + a[ 93*W +: W] + a[ 94*W +: W] + a[ 95*W +: W] + a[ 96*W +: W] + a[ 97*W +: W] + a[ 98*W +: W] + a[ 99*W +: W] +
//                 a[100*W +: W] + a[101*W +: W] + a[102*W +: W] + a[103*W +: W] + a[104*W +: W] + a[105*W +: W] + a[106*W +: W] + a[107*W +: W] + a[108*W +: W] + a[109*W +: W] + 
//                 a[110*W +: W] + a[111*W +: W] + a[112*W +: W] + a[113*W +: W] + a[114*W +: W] + a[115*W +: W] + a[116*W +: W] + a[117*W +: W] + a[118*W +: W] + a[119*W +: W] + 
//                 a[120*W +: W] + a[121*W +: W] + a[122*W +: W] + a[123*W +: W] + a[124*W +: W] + a[125*W +: W] + a[126*W +: W] + a[127*W +: W] + a[128*W +: W] + a[129*W +: W] +
//                 a[130*W +: W] + a[131*W +: W] + a[132*W +: W] + a[133*W +: W] + a[134*W +: W] + a[135*W +: W] + a[136*W +: W] + a[137*W +: W] + a[138*W +: W] + a[139*W +: W] + 
//                 a[140*W +: W] + a[141*W +: W] + a[142*W +: W] + a[143*W +: W] + a[144*W +: W] + a[145*W +: W] + a[146*W +: W] + a[147*W +: W] + a[148*W +: W] + a[149*W +: W] +
//                 a[150*W +: W] + a[151*W +: W] + a[152*W +: W] + a[153*W +: W] + a[154*W +: W] + a[155*W +: W] + a[156*W +: W] + a[157*W +: W] + a[158*W +: W] + a[159*W +: W] + 
//                 a[160*W +: W] + a[161*W +: W] + a[162*W +: W] + a[163*W +: W] + a[164*W +: W] + a[165*W +: W] + a[166*W +: W] + a[167*W +: W] + a[168*W +: W] + a[169*W +: W] + 
//                 a[170*W +: W] + a[171*W +: W] + a[172*W +: W] + a[173*W +: W] + a[174*W +: W] + a[175*W +: W] + a[176*W +: W] + a[177*W +: W] + a[178*W +: W] + a[179*W +: W] + 
//                 a[180*W +: W] + a[181*W +: W] + a[182*W +: W] + a[183*W +: W] + a[184*W +: W] + a[185*W +: W] + a[186*W +: W] + a[187*W +: W] + a[188*W +: W] + a[189*W +: W] + 
//                 a[190*W +: W] + a[191*W +: W] + a[192*W +: W] + a[193*W +: W] + a[194*W +: W] + a[195*W +: W] + a[196*W +: W] + a[197*W +: W] + a[198*W +: W] + a[199*W +: W] +
//                 a[200*W +: W] + a[201*W +: W] + a[202*W +: W] + a[203*W +: W] + a[204*W +: W] + a[205*W +: W] + a[206*W +: W] + a[207*W +: W] + a[208*W +: W] + a[209*W +: W] + 
//                 a[210*W +: W] + a[211*W +: W] + a[212*W +: W] + a[213*W +: W] + a[214*W +: W] + a[215*W +: W] + a[216*W +: W] + a[217*W +: W] + a[218*W +: W] + a[219*W +: W] + 
//                 a[220*W +: W] + a[221*W +: W] + a[222*W +: W] + a[223*W +: W] + a[224*W +: W] + a[225*W +: W] + a[226*W +: W] + a[227*W +: W] + a[228*W +: W] + a[229*W +: W] +
//                 a[230*W +: W] + a[231*W +: W] + a[232*W +: W] + a[233*W +: W] + a[234*W +: W] + a[235*W +: W] + a[236*W +: W] + a[237*W +: W] + a[238*W +: W] + a[239*W +: W] + 
//                 a[240*W +: W] + a[241*W +: W] + a[242*W +: W] + a[243*W +: W] + a[244*W +: W] + a[245*W +: W] + a[246*W +: W] + a[247*W +: W] + a[248*W +: W] + a[249*W +: W] +
//                 a[250*W +: W] + a[251*W +: W] + a[252*W +: W] + a[253*W +: W] + a[254*W +: W] + a[255*W +: W];

//assign test_1_stage = 
//         sum000 + c000 + sum003 + c003 + sum006 + c006 + sum009 + c009 + sum012 + c012 + sum015 + c015 + sum018 + c018 + sum021 + c021 + a[255*W +:W] +
//         sum024 + c024 + sum027 + c027 + sum030 + c030 + sum033 + c033 + sum036 + c036 + sum039 + c039 + sum042 + c042 + sum045 + c045 + 
//         sum048 + c048 + sum051 + c051 + sum054 + c054 + sum057 + c057 + sum060 + c060 + sum063 + c063 + sum066 + c066 + sum069 + c069 + 
//         sum072 + c072 + sum075 + c075 + sum078 + c078 + sum081 + c081 + sum084 + c084 + sum087 + c087 + sum090 + c090 + sum093 + c093 + 
//         sum096 + c096 + sum099 + c099 + sum102 + c102 + sum105 + c105 + sum108 + c108 + sum111 + c111 + sum114 + c114 + sum117 + c117 + sum120 + c120 + sum123 + c123+
//         sum126 + c126 + sum129 + c129 + sum132 + c132 + sum135 + c135 + sum138 + c138 + sum141 + c141 + sum144 + c144 + sum147 + c147 +
//         sum150 + c150 + sum153 + c153 + sum156 + c156 + sum159 + c159 + sum162 + c162 + sum165 + c165 + sum168 + c168 + sum171 + c171 +
//         sum174 + c174 + sum177 + c177 + sum180 + c180 + sum183 + c183 + sum186 + c186 + sum189 + c189 + sum192 + c192 + sum195 + c195 +
//         sum198 + c198 + sum201 + c201 + sum204 + c204 + sum207 + c207 + sum210 + c210 + sum213 + c213 + sum216 + c216 + sum219 + c219 +
//         sum222 + c222 + sum225 + c225 + sum228 + c228 + sum231 + c231 + sum234 + c234 + sum237 + c237 + sum240 + c240 + sum243 + c243 + sum246 + c246 + sum249 + c249 + sum252 + c252;
//assign test_2_stage = 
//         sum_01 + c_01 + sum_02 + c_02 + sum_03 + c_03 + sum_04 + c_04 + sum_05 + c_05 + sum_06 + c_06 + sum_07 + c_07 + sum_08 + c_08 + 
//         sum_09 + c_09 + sum_10 + c_10 + sum_11 + c_11 + sum_12 + c_12 + sum_13 + c_13 + sum_14 + c_14 + sum_15 + c_15 + sum_16 + c_16 +
//         sum_17 + c_17 + sum_18 + c_18 + sum_19 + c_19 + sum_20 + c_20 + sum_21 + c_21 + sum_22 + c_22 + sum_23 + c_23 + sum_24 + c_24 +
//         sum_25 + c_25 + sum_26 + c_26 + sum_27 + c_27 + sum_28 + c_28 +
//         sum_29 + c_29 + sum_30 + c_30 + sum_31 + c_31 + sum_32 + c_32 + sum_33 + c_33 + sum_34 + c_34 + sum_35 + c_35 + sum_36 + c_36 + 
//         sum_37 + c_37 + sum_38 + c_38 + sum_39 + c_39 + sum_40 + c_40 + sum_41 + c_41 + sum_42 + c_42 + sum_43 + c_43 + sum_44 + c_44 + 
//         sum_45 + c_45 + sum_46 + c_46 + sum_47 + c_47 + sum_48 + c_48 + sum_49 + c_49 + sum_50 + c_50 + sum_51 + c_51 + sum_52 + c_52 + 
//         sum_53 + c_53 + sum_54 + c_54 + sum_55 + c_55 + sum_56 + c_56 + sum_57 + c_57;
//
//assign test_3_stage = 
//        sum_61 + c_61 + sum_62 + c_62 + sum_63 + c_63 + sum_64 + c_64 + sum_65 + c_65 + sum_66 + c_66 + sum_67 + c_67 + sum_68 + c_68 + 
//        sum_69 + c_69 + sum_70 + c_70 + sum_71 + c_71 + sum_72 + c_72 + sum_73 + c_73 + sum_74 + c_74 + sum_75 + c_75 + sum_76 + c_76 + 
//        sum_77 + c_77 + sum_78 + c_78 + sum_79 + c_79 + sum_80 + c_80 + sum_81 + c_81 + sum_82 + c_82 + sum_83 + c_83 + sum_84 + c_84 + 
//        sum_85 + c_85 + sum_86 + c_86 + sum_87 + c_87 + sum_88 + c_88 + sum_89 + c_89 + sum_90 + c_90 + sum_91 + c_91 + sum_92 + c_92 + 
//        sum_93 + c_93 + sum_94 + c_94 + sum_95 + c_95 + sum_96 + c_96 + sum_97 + c_97 + sum_98 + c_98;
//
//assign test_4_stage = 
//       sum_301 + c_301 + sum_302 + c_302 + sum_303 + c_303 + sum_304 + c_304 + sum_305 + c_305 + sum_306 + c_306 + sum_307 + c_307 + sum_308 + c_308 + c_98 +
//       sum_309 + c_309 + sum_310 + c_310 + sum_311 + c_311 + sum_312 + c_312 + sum_313 + c_313 + sum_314 + c_314 + sum_315 + c_315 + sum_316 + c_316 +
//       sum_317 + c_317 + sum_318 + c_318 + sum_319 + c_319 + sum_320 + c_320 + sum_321 + c_321 + sum_322 + c_322 + sum_323 + c_323 + sum_324 + c_324 + sum_325 + c_325;
//assign test_5_stage = 
//       sum_331 + c_331 + sum_332 + c_332 + sum_333 + c_333 + sum_334 + c_334 + sum_335 + c_335 + sum_336 + c_336 + sum_337 + c_337 + sum_338 + c_338 +
//       sum_339 + c_339 + sum_340 + c_340 + sum_341 + c_341 + sum_342 + c_342 + sum_343 + c_343 + sum_344 + c_344 + sum_345 + c_345 + sum_346 + c_346 + sum_347 + c_347; 
//assign test_6_stage = sum_359 + c_359 + sum_360 + c_360 + sum_361 + c_361 +      c_347 +
//                      sum_351 + c_351 + sum_352 + c_352 + sum_353 + c_353 + sum_354 + c_354 + sum_355 + c_355 + sum_356 + c_356 + sum_357 + c_357 + sum_358 + c_358;
//
//assign test_7_stage = sum_371 + c_371 + sum_372 + c_372 + sum_373 + c_373 + sum_374 + c_374 + sum_375 + c_375 + sum_376 + c_376 + sum_377 + c_377 +
//                      sum_361 + c_361;
//assign test_8_stage = sum_381 + c_381 + sum_382 + c_382 + sum_383 + c_383 + sum_384 + c_384 + sum_385 + c_385 +     c_377;
//assign test_9_stage = sum_391 + c_391 + sum_392 + c_392 + sum_393 + c_393  +      sum_385 + c_385;
//assign test_preout = sum5 + cout5;
//assign test_out    = sum + cout;

 carry_save_3inputs #(W+7) cs_3in_000 (.a({  {(7){a[  0*W+W-1]}} , a[  0*W +: W] , {(7){a[(  0+1)*W+W-1]}} , a[(  0+1)*W +: W] , {(7){a[(  0+2)*W+W-1]}} , a[(  0+2)*W +: W] }), .sum(sum000), .cout(c000) );
 carry_save_3inputs #(W+7) cs_3in_003 (.a({  {(7){a[  3*W+W-1]}} , a[  3*W +: W] , {(7){a[(  3+1)*W+W-1]}} , a[(  3+1)*W +: W] , {(7){a[(  3+2)*W+W-1]}} , a[(  3+2)*W +: W] }), .sum(sum003), .cout(c003) );
 carry_save_3inputs #(W+7) cs_3in_006 (.a({  {(7){a[  6*W+W-1]}} , a[  6*W +: W] , {(7){a[(  6+1)*W+W-1]}} , a[(  6+1)*W +: W] , {(7){a[(  6+2)*W+W-1]}} , a[(  6+2)*W +: W] }), .sum(sum006), .cout(c006) );
 carry_save_3inputs #(W+7) cs_3in_009 (.a({  {(7){a[  9*W+W-1]}} , a[  9*W +: W] , {(7){a[(  9+1)*W+W-1]}} , a[(  9+1)*W +: W] , {(7){a[(  9+2)*W+W-1]}} , a[(  9+2)*W +: W] }), .sum(sum009), .cout(c009) );
 carry_save_3inputs #(W+7) cs_3in_012 (.a({  {(7){a[ 12*W+W-1]}} , a[ 12*W +: W] , {(7){a[( 12+1)*W+W-1]}} , a[( 12+1)*W +: W] , {(7){a[( 12+2)*W+W-1]}} , a[( 12+2)*W +: W] }), .sum(sum012), .cout(c012) );
 carry_save_3inputs #(W+7) cs_3in_015 (.a({  {(7){a[ 15*W+W-1]}} , a[ 15*W +: W] , {(7){a[( 15+1)*W+W-1]}} , a[( 15+1)*W +: W] , {(7){a[( 15+2)*W+W-1]}} , a[( 15+2)*W +: W] }), .sum(sum015), .cout(c015) );
 carry_save_3inputs #(W+7) cs_3in_018 (.a({  {(7){a[ 18*W+W-1]}} , a[ 18*W +: W] , {(7){a[( 18+1)*W+W-1]}} , a[( 18+1)*W +: W] , {(7){a[( 18+2)*W+W-1]}} , a[( 18+2)*W +: W] }), .sum(sum018), .cout(c018) );
 carry_save_3inputs #(W+7) cs_3in_021 (.a({  {(7){a[ 21*W+W-1]}} , a[ 21*W +: W] , {(7){a[( 21+1)*W+W-1]}} , a[( 21+1)*W +: W] , {(7){a[( 21+2)*W+W-1]}} , a[( 21+2)*W +: W] }), .sum(sum021), .cout(c021) );
 carry_save_3inputs #(W+7) cs_3in_024 (.a({  {(7){a[ 24*W+W-1]}} , a[ 24*W +: W] , {(7){a[( 24+1)*W+W-1]}} , a[( 24+1)*W +: W] , {(7){a[( 24+2)*W+W-1]}} , a[( 24+2)*W +: W] }), .sum(sum024), .cout(c024) );
 carry_save_3inputs #(W+7) cs_3in_027 (.a({  {(7){a[ 27*W+W-1]}} , a[ 27*W +: W] , {(7){a[( 27+1)*W+W-1]}} , a[( 27+1)*W +: W] , {(7){a[( 27+2)*W+W-1]}} , a[( 27+2)*W +: W] }), .sum(sum027), .cout(c027) );
 carry_save_3inputs #(W+7) cs_3in_030 (.a({  {(7){a[ 30*W+W-1]}} , a[ 30*W +: W] , {(7){a[( 30+1)*W+W-1]}} , a[( 30+1)*W +: W] , {(7){a[( 30+2)*W+W-1]}} , a[( 30+2)*W +: W] }), .sum(sum030), .cout(c030) );
 carry_save_3inputs #(W+7) cs_3in_033 (.a({  {(7){a[ 33*W+W-1]}} , a[ 33*W +: W] , {(7){a[( 33+1)*W+W-1]}} , a[( 33+1)*W +: W] , {(7){a[( 33+2)*W+W-1]}} , a[( 33+2)*W +: W] }), .sum(sum033), .cout(c033) );
 carry_save_3inputs #(W+7) cs_3in_036 (.a({  {(7){a[ 36*W+W-1]}} , a[ 36*W +: W] , {(7){a[( 36+1)*W+W-1]}} , a[( 36+1)*W +: W] , {(7){a[( 36+2)*W+W-1]}} , a[( 36+2)*W +: W] }), .sum(sum036), .cout(c036) );
 carry_save_3inputs #(W+7) cs_3in_039 (.a({  {(7){a[ 39*W+W-1]}} , a[ 39*W +: W] , {(7){a[( 39+1)*W+W-1]}} , a[( 39+1)*W +: W] , {(7){a[( 39+2)*W+W-1]}} , a[( 39+2)*W +: W] }), .sum(sum039), .cout(c039) );
 carry_save_3inputs #(W+7) cs_3in_042 (.a({  {(7){a[ 42*W+W-1]}} , a[ 42*W +: W] , {(7){a[( 42+1)*W+W-1]}} , a[( 42+1)*W +: W] , {(7){a[( 42+2)*W+W-1]}} , a[( 42+2)*W +: W] }), .sum(sum042), .cout(c042) );
 carry_save_3inputs #(W+7) cs_3in_045 (.a({  {(7){a[ 45*W+W-1]}} , a[ 45*W +: W] , {(7){a[( 45+1)*W+W-1]}} , a[( 45+1)*W +: W] , {(7){a[( 45+2)*W+W-1]}} , a[( 45+2)*W +: W] }), .sum(sum045), .cout(c045) );
 carry_save_3inputs #(W+7) cs_3in_048 (.a({  {(7){a[ 48*W+W-1]}} , a[ 48*W +: W] , {(7){a[( 48+1)*W+W-1]}} , a[( 48+1)*W +: W] , {(7){a[( 48+2)*W+W-1]}} , a[( 48+2)*W +: W] }), .sum(sum048), .cout(c048) );
 carry_save_3inputs #(W+7) cs_3in_051 (.a({  {(7){a[ 51*W+W-1]}} , a[ 51*W +: W] , {(7){a[( 51+1)*W+W-1]}} , a[( 51+1)*W +: W] , {(7){a[( 51+2)*W+W-1]}} , a[( 51+2)*W +: W] }), .sum(sum051), .cout(c051) );
 carry_save_3inputs #(W+7) cs_3in_054 (.a({  {(7){a[ 54*W+W-1]}} , a[ 54*W +: W] , {(7){a[( 54+1)*W+W-1]}} , a[( 54+1)*W +: W] , {(7){a[( 54+2)*W+W-1]}} , a[( 54+2)*W +: W] }), .sum(sum054), .cout(c054) );
 carry_save_3inputs #(W+7) cs_3in_057 (.a({  {(7){a[ 57*W+W-1]}} , a[ 57*W +: W] , {(7){a[( 57+1)*W+W-1]}} , a[( 57+1)*W +: W] , {(7){a[( 57+2)*W+W-1]}} , a[( 57+2)*W +: W] }), .sum(sum057), .cout(c057) );
 carry_save_3inputs #(W+7) cs_3in_060 (.a({  {(7){a[ 60*W+W-1]}} , a[ 60*W +: W] , {(7){a[( 60+1)*W+W-1]}} , a[( 60+1)*W +: W] , {(7){a[( 60+2)*W+W-1]}} , a[( 60+2)*W +: W] }), .sum(sum060), .cout(c060) );
 carry_save_3inputs #(W+7) cs_3in_063 (.a({  {(7){a[ 63*W+W-1]}} , a[ 63*W +: W] , {(7){a[( 63+1)*W+W-1]}} , a[( 63+1)*W +: W] , {(7){a[( 63+2)*W+W-1]}} , a[( 63+2)*W +: W] }), .sum(sum063), .cout(c063) );
 carry_save_3inputs #(W+7) cs_3in_066 (.a({  {(7){a[ 66*W+W-1]}} , a[ 66*W +: W] , {(7){a[( 66+1)*W+W-1]}} , a[( 66+1)*W +: W] , {(7){a[( 66+2)*W+W-1]}} , a[( 66+2)*W +: W] }), .sum(sum066), .cout(c066) );
 carry_save_3inputs #(W+7) cs_3in_069 (.a({  {(7){a[ 69*W+W-1]}} , a[ 69*W +: W] , {(7){a[( 69+1)*W+W-1]}} , a[( 69+1)*W +: W] , {(7){a[( 69+2)*W+W-1]}} , a[( 69+2)*W +: W] }), .sum(sum069), .cout(c069) );
 carry_save_3inputs #(W+7) cs_3in_072 (.a({  {(7){a[ 72*W+W-1]}} , a[ 72*W +: W] , {(7){a[( 72+1)*W+W-1]}} , a[( 72+1)*W +: W] , {(7){a[( 72+2)*W+W-1]}} , a[( 72+2)*W +: W] }), .sum(sum072), .cout(c072) );
 carry_save_3inputs #(W+7) cs_3in_075 (.a({  {(7){a[ 75*W+W-1]}} , a[ 75*W +: W] , {(7){a[( 75+1)*W+W-1]}} , a[( 75+1)*W +: W] , {(7){a[( 75+2)*W+W-1]}} , a[( 75+2)*W +: W] }), .sum(sum075), .cout(c075) );
 carry_save_3inputs #(W+7) cs_3in_078 (.a({  {(7){a[ 78*W+W-1]}} , a[ 78*W +: W] , {(7){a[( 78+1)*W+W-1]}} , a[( 78+1)*W +: W] , {(7){a[( 78+2)*W+W-1]}} , a[( 78+2)*W +: W] }), .sum(sum078), .cout(c078) );
 carry_save_3inputs #(W+7) cs_3in_081 (.a({  {(7){a[ 81*W+W-1]}} , a[ 81*W +: W] , {(7){a[( 81+1)*W+W-1]}} , a[( 81+1)*W +: W] , {(7){a[( 81+2)*W+W-1]}} , a[( 81+2)*W +: W] }), .sum(sum081), .cout(c081) );
 carry_save_3inputs #(W+7) cs_3in_084 (.a({  {(7){a[ 84*W+W-1]}} , a[ 84*W +: W] , {(7){a[( 84+1)*W+W-1]}} , a[( 84+1)*W +: W] , {(7){a[( 84+2)*W+W-1]}} , a[( 84+2)*W +: W] }), .sum(sum084), .cout(c084) );
 carry_save_3inputs #(W+7) cs_3in_087 (.a({  {(7){a[ 87*W+W-1]}} , a[ 87*W +: W] , {(7){a[( 87+1)*W+W-1]}} , a[( 87+1)*W +: W] , {(7){a[( 87+2)*W+W-1]}} , a[( 87+2)*W +: W] }), .sum(sum087), .cout(c087) );
 carry_save_3inputs #(W+7) cs_3in_090 (.a({  {(7){a[ 90*W+W-1]}} , a[ 90*W +: W] , {(7){a[( 90+1)*W+W-1]}} , a[( 90+1)*W +: W] , {(7){a[( 90+2)*W+W-1]}} , a[( 90+2)*W +: W] }), .sum(sum090), .cout(c090) );
 carry_save_3inputs #(W+7) cs_3in_093 (.a({  {(7){a[ 93*W+W-1]}} , a[ 93*W +: W] , {(7){a[( 93+1)*W+W-1]}} , a[( 93+1)*W +: W] , {(7){a[( 93+2)*W+W-1]}} , a[( 93+2)*W +: W] }), .sum(sum093), .cout(c093) );
 carry_save_3inputs #(W+7) cs_3in_096 (.a({  {(7){a[ 96*W+W-1]}} , a[ 96*W +: W] , {(7){a[( 96+1)*W+W-1]}} , a[( 96+1)*W +: W] , {(7){a[( 96+2)*W+W-1]}} , a[( 96+2)*W +: W] }), .sum(sum096), .cout(c096) );
 carry_save_3inputs #(W+7) cs_3in_099 (.a({  {(7){a[ 99*W+W-1]}} , a[ 99*W +: W] , {(7){a[( 99+1)*W+W-1]}} , a[( 99+1)*W +: W] , {(7){a[( 99+2)*W+W-1]}} , a[( 99+2)*W +: W] }), .sum(sum099), .cout(c099) );
 carry_save_3inputs #(W+7) cs_3in_102 (.a({  {(7){a[102*W+W-1]}} , a[102*W +: W] , {(7){a[(102+1)*W+W-1]}} , a[(102+1)*W +: W] , {(7){a[(102+2)*W+W-1]}} , a[(102+2)*W +: W] }), .sum(sum102), .cout(c102) );
 carry_save_3inputs #(W+7) cs_3in_105 (.a({  {(7){a[105*W+W-1]}} , a[105*W +: W] , {(7){a[(105+1)*W+W-1]}} , a[(105+1)*W +: W] , {(7){a[(105+2)*W+W-1]}} , a[(105+2)*W +: W] }), .sum(sum105), .cout(c105) );
 carry_save_3inputs #(W+7) cs_3in_108 (.a({  {(7){a[108*W+W-1]}} , a[108*W +: W] , {(7){a[(108+1)*W+W-1]}} , a[(108+1)*W +: W] , {(7){a[(108+2)*W+W-1]}} , a[(108+2)*W +: W] }), .sum(sum108), .cout(c108) );
 carry_save_3inputs #(W+7) cs_3in_111 (.a({  {(7){a[111*W+W-1]}} , a[111*W +: W] , {(7){a[(111+1)*W+W-1]}} , a[(111+1)*W +: W] , {(7){a[(111+2)*W+W-1]}} , a[(111+2)*W +: W] }), .sum(sum111), .cout(c111) );
 carry_save_3inputs #(W+7) cs_3in_114 (.a({  {(7){a[114*W+W-1]}} , a[114*W +: W] , {(7){a[(114+1)*W+W-1]}} , a[(114+1)*W +: W] , {(7){a[(114+2)*W+W-1]}} , a[(114+2)*W +: W] }), .sum(sum114), .cout(c114) );
 carry_save_3inputs #(W+7) cs_3in_117 (.a({  {(7){a[117*W+W-1]}} , a[117*W +: W] , {(7){a[(117+1)*W+W-1]}} , a[(117+1)*W +: W] , {(7){a[(117+2)*W+W-1]}} , a[(117+2)*W +: W] }), .sum(sum117), .cout(c117) );
 carry_save_3inputs #(W+7) cs_3in_120 (.a({  {(7){a[120*W+W-1]}} , a[120*W +: W] , {(7){a[(120+1)*W+W-1]}} , a[(120+1)*W +: W] , {(7){a[(120+2)*W+W-1]}} , a[(120+2)*W +: W] }), .sum(sum120), .cout(c120) );
 carry_save_3inputs #(W+7) cs_3in_123 (.a({  {(7){a[123*W+W-1]}} , a[123*W +: W] , {(7){a[(123+1)*W+W-1]}} , a[(123+1)*W +: W] , {(7){a[(123+2)*W+W-1]}} , a[(123+2)*W +: W] }), .sum(sum123), .cout(c123) ); 
 carry_save_3inputs #(W+7) cs_3in_126 (.a({  {(7){a[126*W+W-1]}} , a[126*W +: W] , {(7){a[(126+1)*W+W-1]}} , a[(126+1)*W +: W] , {(7){a[(126+2)*W+W-1]}} , a[(126+2)*W +: W] }), .sum(sum126), .cout(c126) );
 carry_save_3inputs #(W+7) cs_3in_129 (.a({  {(7){a[129*W+W-1]}} , a[129*W +: W] , {(7){a[(129+1)*W+W-1]}} , a[(129+1)*W +: W] , {(7){a[(129+2)*W+W-1]}} , a[(129+2)*W +: W] }), .sum(sum129), .cout(c129) );
 carry_save_3inputs #(W+7) cs_3in_132 (.a({  {(7){a[132*W+W-1]}} , a[132*W +: W] , {(7){a[(132+1)*W+W-1]}} , a[(132+1)*W +: W] , {(7){a[(132+2)*W+W-1]}} , a[(132+2)*W +: W] }), .sum(sum132), .cout(c132) );
 carry_save_3inputs #(W+7) cs_3in_135 (.a({  {(7){a[135*W+W-1]}} , a[135*W +: W] , {(7){a[(135+1)*W+W-1]}} , a[(135+1)*W +: W] , {(7){a[(135+2)*W+W-1]}} , a[(135+2)*W +: W] }), .sum(sum135), .cout(c135) );
 carry_save_3inputs #(W+7) cs_3in_138 (.a({  {(7){a[138*W+W-1]}} , a[138*W +: W] , {(7){a[(138+1)*W+W-1]}} , a[(138+1)*W +: W] , {(7){a[(138+2)*W+W-1]}} , a[(138+2)*W +: W] }), .sum(sum138), .cout(c138) );
 carry_save_3inputs #(W+7) cs_3in_141 (.a({  {(7){a[141*W+W-1]}} , a[141*W +: W] , {(7){a[(141+1)*W+W-1]}} , a[(141+1)*W +: W] , {(7){a[(141+2)*W+W-1]}} , a[(141+2)*W +: W] }), .sum(sum141), .cout(c141) );
 carry_save_3inputs #(W+7) cs_3in_144 (.a({  {(7){a[144*W+W-1]}} , a[144*W +: W] , {(7){a[(144+1)*W+W-1]}} , a[(144+1)*W +: W] , {(7){a[(144+2)*W+W-1]}} , a[(144+2)*W +: W] }), .sum(sum144), .cout(c144) );
 carry_save_3inputs #(W+7) cs_3in_147 (.a({  {(7){a[147*W+W-1]}} , a[147*W +: W] , {(7){a[(147+1)*W+W-1]}} , a[(147+1)*W +: W] , {(7){a[(147+2)*W+W-1]}} , a[(147+2)*W +: W] }), .sum(sum147), .cout(c147) );
 carry_save_3inputs #(W+7) cs_3in_150 (.a({  {(7){a[150*W+W-1]}} , a[150*W +: W] , {(7){a[(150+1)*W+W-1]}} , a[(150+1)*W +: W] , {(7){a[(150+2)*W+W-1]}} , a[(150+2)*W +: W] }), .sum(sum150), .cout(c150) );
 carry_save_3inputs #(W+7) cs_3in_153 (.a({  {(7){a[153*W+W-1]}} , a[153*W +: W] , {(7){a[(153+1)*W+W-1]}} , a[(153+1)*W +: W] , {(7){a[(153+2)*W+W-1]}} , a[(153+2)*W +: W] }), .sum(sum153), .cout(c153) );
 carry_save_3inputs #(W+7) cs_3in_156 (.a({  {(7){a[156*W+W-1]}} , a[156*W +: W] , {(7){a[(156+1)*W+W-1]}} , a[(156+1)*W +: W] , {(7){a[(156+2)*W+W-1]}} , a[(156+2)*W +: W] }), .sum(sum156), .cout(c156) );
 carry_save_3inputs #(W+7) cs_3in_159 (.a({  {(7){a[159*W+W-1]}} , a[159*W +: W] , {(7){a[(159+1)*W+W-1]}} , a[(159+1)*W +: W] , {(7){a[(159+2)*W+W-1]}} , a[(159+2)*W +: W] }), .sum(sum159), .cout(c159) );
 carry_save_3inputs #(W+7) cs_3in_162 (.a({  {(7){a[162*W+W-1]}} , a[162*W +: W] , {(7){a[(162+1)*W+W-1]}} , a[(162+1)*W +: W] , {(7){a[(162+2)*W+W-1]}} , a[(162+2)*W +: W] }), .sum(sum162), .cout(c162) );
 carry_save_3inputs #(W+7) cs_3in_165 (.a({  {(7){a[165*W+W-1]}} , a[165*W +: W] , {(7){a[(165+1)*W+W-1]}} , a[(165+1)*W +: W] , {(7){a[(165+2)*W+W-1]}} , a[(165+2)*W +: W] }), .sum(sum165), .cout(c165) );
 carry_save_3inputs #(W+7) cs_3in_168 (.a({  {(7){a[168*W+W-1]}} , a[168*W +: W] , {(7){a[(168+1)*W+W-1]}} , a[(168+1)*W +: W] , {(7){a[(168+2)*W+W-1]}} , a[(168+2)*W +: W] }), .sum(sum168), .cout(c168) );
 carry_save_3inputs #(W+7) cs_3in_171 (.a({  {(7){a[171*W+W-1]}} , a[171*W +: W] , {(7){a[(171+1)*W+W-1]}} , a[(171+1)*W +: W] , {(7){a[(171+2)*W+W-1]}} , a[(171+2)*W +: W] }), .sum(sum171), .cout(c171) );
 carry_save_3inputs #(W+7) cs_3in_174 (.a({  {(7){a[174*W+W-1]}} , a[174*W +: W] , {(7){a[(174+1)*W+W-1]}} , a[(174+1)*W +: W] , {(7){a[(174+2)*W+W-1]}} , a[(174+2)*W +: W] }), .sum(sum174), .cout(c174) );
 carry_save_3inputs #(W+7) cs_3in_177 (.a({  {(7){a[177*W+W-1]}} , a[177*W +: W] , {(7){a[(177+1)*W+W-1]}} , a[(177+1)*W +: W] , {(7){a[(177+2)*W+W-1]}} , a[(177+2)*W +: W] }), .sum(sum177), .cout(c177) );
 carry_save_3inputs #(W+7) cs_3in_180 (.a({  {(7){a[180*W+W-1]}} , a[180*W +: W] , {(7){a[(180+1)*W+W-1]}} , a[(180+1)*W +: W] , {(7){a[(180+2)*W+W-1]}} , a[(180+2)*W +: W] }), .sum(sum180), .cout(c180) );
 carry_save_3inputs #(W+7) cs_3in_183 (.a({  {(7){a[183*W+W-1]}} , a[183*W +: W] , {(7){a[(183+1)*W+W-1]}} , a[(183+1)*W +: W] , {(7){a[(183+2)*W+W-1]}} , a[(183+2)*W +: W] }), .sum(sum183), .cout(c183) );
 carry_save_3inputs #(W+7) cs_3in_186 (.a({  {(7){a[186*W+W-1]}} , a[186*W +: W] , {(7){a[(186+1)*W+W-1]}} , a[(186+1)*W +: W] , {(7){a[(186+2)*W+W-1]}} , a[(186+2)*W +: W] }), .sum(sum186), .cout(c186) );
 carry_save_3inputs #(W+7) cs_3in_189 (.a({  {(7){a[189*W+W-1]}} , a[189*W +: W] , {(7){a[(189+1)*W+W-1]}} , a[(189+1)*W +: W] , {(7){a[(189+2)*W+W-1]}} , a[(189+2)*W +: W] }), .sum(sum189), .cout(c189) );
 carry_save_3inputs #(W+7) cs_3in_192 (.a({  {(7){a[192*W+W-1]}} , a[192*W +: W] , {(7){a[(192+1)*W+W-1]}} , a[(192+1)*W +: W] , {(7){a[(192+2)*W+W-1]}} , a[(192+2)*W +: W] }), .sum(sum192), .cout(c192) );
 carry_save_3inputs #(W+7) cs_3in_195 (.a({  {(7){a[195*W+W-1]}} , a[195*W +: W] , {(7){a[(195+1)*W+W-1]}} , a[(195+1)*W +: W] , {(7){a[(195+2)*W+W-1]}} , a[(195+2)*W +: W] }), .sum(sum195), .cout(c195) );
 carry_save_3inputs #(W+7) cs_3in_198 (.a({  {(7){a[198*W+W-1]}} , a[198*W +: W] , {(7){a[(198+1)*W+W-1]}} , a[(198+1)*W +: W] , {(7){a[(198+2)*W+W-1]}} , a[(198+2)*W +: W] }), .sum(sum198), .cout(c198) );
 carry_save_3inputs #(W+7) cs_3in_201 (.a({  {(7){a[201*W+W-1]}} , a[201*W +: W] , {(7){a[(201+1)*W+W-1]}} , a[(201+1)*W +: W] , {(7){a[(201+2)*W+W-1]}} , a[(201+2)*W +: W] }), .sum(sum201), .cout(c201) );
 carry_save_3inputs #(W+7) cs_3in_204 (.a({  {(7){a[204*W+W-1]}} , a[204*W +: W] , {(7){a[(204+1)*W+W-1]}} , a[(204+1)*W +: W] , {(7){a[(204+2)*W+W-1]}} , a[(204+2)*W +: W] }), .sum(sum204), .cout(c204) );
 carry_save_3inputs #(W+7) cs_3in_207 (.a({  {(7){a[207*W+W-1]}} , a[207*W +: W] , {(7){a[(207+1)*W+W-1]}} , a[(207+1)*W +: W] , {(7){a[(207+2)*W+W-1]}} , a[(207+2)*W +: W] }), .sum(sum207), .cout(c207) );
 carry_save_3inputs #(W+7) cs_3in_210 (.a({  {(7){a[210*W+W-1]}} , a[210*W +: W] , {(7){a[(210+1)*W+W-1]}} , a[(210+1)*W +: W] , {(7){a[(210+2)*W+W-1]}} , a[(210+2)*W +: W] }), .sum(sum210), .cout(c210) );
 carry_save_3inputs #(W+7) cs_3in_213 (.a({  {(7){a[213*W+W-1]}} , a[213*W +: W] , {(7){a[(213+1)*W+W-1]}} , a[(213+1)*W +: W] , {(7){a[(213+2)*W+W-1]}} , a[(213+2)*W +: W] }), .sum(sum213), .cout(c213) );
 carry_save_3inputs #(W+7) cs_3in_216 (.a({  {(7){a[216*W+W-1]}} , a[216*W +: W] , {(7){a[(216+1)*W+W-1]}} , a[(216+1)*W +: W] , {(7){a[(216+2)*W+W-1]}} , a[(216+2)*W +: W] }), .sum(sum216), .cout(c216) );
 carry_save_3inputs #(W+7) cs_3in_219 (.a({  {(7){a[219*W+W-1]}} , a[219*W +: W] , {(7){a[(219+1)*W+W-1]}} , a[(219+1)*W +: W] , {(7){a[(219+2)*W+W-1]}} , a[(219+2)*W +: W] }), .sum(sum219), .cout(c219) );
 carry_save_3inputs #(W+7) cs_3in_222 (.a({  {(7){a[222*W+W-1]}} , a[222*W +: W] , {(7){a[(222+1)*W+W-1]}} , a[(222+1)*W +: W] , {(7){a[(222+2)*W+W-1]}} , a[(222+2)*W +: W] }), .sum(sum222), .cout(c222) );
 carry_save_3inputs #(W+7) cs_3in_225 (.a({  {(7){a[225*W+W-1]}} , a[225*W +: W] , {(7){a[(225+1)*W+W-1]}} , a[(225+1)*W +: W] , {(7){a[(225+2)*W+W-1]}} , a[(225+2)*W +: W] }), .sum(sum225), .cout(c225) );
 carry_save_3inputs #(W+7) cs_3in_228 (.a({  {(7){a[228*W+W-1]}} , a[228*W +: W] , {(7){a[(228+1)*W+W-1]}} , a[(228+1)*W +: W] , {(7){a[(228+2)*W+W-1]}} , a[(228+2)*W +: W] }), .sum(sum228), .cout(c228) );
 carry_save_3inputs #(W+7) cs_3in_231 (.a({  {(7){a[231*W+W-1]}} , a[231*W +: W] , {(7){a[(231+1)*W+W-1]}} , a[(231+1)*W +: W] , {(7){a[(231+2)*W+W-1]}} , a[(231+2)*W +: W] }), .sum(sum231), .cout(c231) );
 carry_save_3inputs #(W+7) cs_3in_234 (.a({  {(7){a[234*W+W-1]}} , a[234*W +: W] , {(7){a[(234+1)*W+W-1]}} , a[(234+1)*W +: W] , {(7){a[(234+2)*W+W-1]}} , a[(234+2)*W +: W] }), .sum(sum234), .cout(c234) );
 carry_save_3inputs #(W+7) cs_3in_237 (.a({  {(7){a[237*W+W-1]}} , a[237*W +: W] , {(7){a[(237+1)*W+W-1]}} , a[(237+1)*W +: W] , {(7){a[(237+2)*W+W-1]}} , a[(237+2)*W +: W] }), .sum(sum237), .cout(c237) );
 carry_save_3inputs #(W+7) cs_3in_240 (.a({  {(7){a[240*W+W-1]}} , a[240*W +: W] , {(7){a[(240+1)*W+W-1]}} , a[(240+1)*W +: W] , {(7){a[(240+2)*W+W-1]}} , a[(240+2)*W +: W] }), .sum(sum240), .cout(c240) );
 carry_save_3inputs #(W+7) cs_3in_243 (.a({  {(7){a[243*W+W-1]}} , a[243*W +: W] , {(7){a[(243+1)*W+W-1]}} , a[(243+1)*W +: W] , {(7){a[(243+2)*W+W-1]}} , a[(243+2)*W +: W] }), .sum(sum243), .cout(c243) );
 carry_save_3inputs #(W+7) cs_3in_246 (.a({  {(7){a[246*W+W-1]}} , a[246*W +: W] , {(7){a[(246+1)*W+W-1]}} , a[(246+1)*W +: W] , {(7){a[(246+2)*W+W-1]}} , a[(246+2)*W +: W] }), .sum(sum246), .cout(c246) );
 carry_save_3inputs #(W+7) cs_3in_249 (.a({  {(7){a[249*W+W-1]}} , a[249*W +: W] , {(7){a[(249+1)*W+W-1]}} , a[(249+1)*W +: W] , {(7){a[(249+2)*W+W-1]}} , a[(249+2)*W +: W] }), .sum(sum249), .cout(c249) );
 carry_save_3inputs #(W+7) cs_3in_252 (.a({  {(7){a[252*W+W-1]}} , a[252*W +: W] , {(7){a[(252+1)*W+W-1]}} , a[(252+1)*W +: W] , {(7){a[(252+2)*W+W-1]}} , a[(252+2)*W +: W] }), .sum(sum252), .cout(c252) ); // a(255) do not added

 carry_save_3inputs #(W+7+1) cs_3in_01(.a({ sum000, c000, sum003 }),               .sum(sum_01), .cout(c_01) ); 
 carry_save_3inputs #(W+7+1) cs_3in_02(.a({ c003, c006, sum006   }),               .sum(sum_02), .cout(c_02) );
 carry_save_3inputs #(W+7+1) cs_3in_03(.a({ sum009, c009, sum012 }),               .sum(sum_03), .cout(c_03) );
 carry_save_3inputs #(W+7+1) cs_3in_04(.a({ c012, c015, sum015   }),               .sum(sum_04), .cout(c_04) );
 carry_save_3inputs #(W+7+1) cs_3in_05(.a({ sum018, c018, sum021 }),               .sum(sum_05), .cout(c_05) );
 carry_save_3inputs #(W+7+1) cs_3in_06(.a({ c021, c024, sum024   }),               .sum(sum_06), .cout(c_06) );
 carry_save_3inputs #(W+7+1) cs_3in_07(.a({ sum027, c027, sum030 }),               .sum(sum_07), .cout(c_07) );
 carry_save_3inputs #(W+7+1) cs_3in_08(.a({ c030, c033, sum033   }),               .sum(sum_08), .cout(c_08) );
 carry_save_3inputs #(W+7+1) cs_3in_09(.a({ sum036, c036, sum039 }),               .sum(sum_09), .cout(c_09) );
 carry_save_3inputs #(W+7+1) cs_3in_10(.a({ c039, c042, sum042   }),               .sum(sum_10), .cout(c_10) );
 carry_save_3inputs #(W+7+1) cs_3in_11(.a({ sum045, c045, sum048 }),               .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+7+1) cs_3in_12(.a({ c048, c051, sum051   }),               .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+7+1) cs_3in_13(.a({ sum054, c054, sum057 }),               .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+7+1) cs_3in_14(.a({ c057, c060, sum060   }),               .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+7+1) cs_3in_15(.a({ sum063, c063, sum066 }),               .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+7+1) cs_3in_16(.a({ c066, c069, sum069   }),               .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+7+1) cs_3in_17(.a({ sum072, c072, sum075 }),               .sum(sum_17), .cout(c_17) );
 carry_save_3inputs #(W+7+1) cs_3in_18(.a({ c075, c078, sum078   }),               .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+7+1) cs_3in_19(.a({ sum081, c081, sum084 }),               .sum(sum_19), .cout(c_19) );
 carry_save_3inputs #(W+7+1) cs_3in_20(.a({ c084, c087, sum087   }),               .sum(sum_20), .cout(c_20) );
 carry_save_3inputs #(W+7+1) cs_3in_21(.a({ sum090, c090, sum093 }),               .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+7+1) cs_3in_22(.a({ c093, c096, sum096   }),               .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+7+1) cs_3in_23(.a({ sum099, c099, sum102 }),               .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+7+1) cs_3in_24(.a({ c102, c105, sum105   }),               .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+7+1) cs_3in_25(.a({ sum108, c108, sum111 }),               .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+7+1) cs_3in_26(.a({ c111, c114, sum114   }),               .sum(sum_26), .cout(c_26) );
 carry_save_3inputs #(W+7+1) cs_3in_27(.a({ sum117, c117, sum120 }),               .sum(sum_27), .cout(c_27) );
 carry_save_3inputs #(W+7+1) cs_3in_28(.a({ c120, c123, sum123   }),               .sum(sum_28), .cout(c_28) );
 carry_save_3inputs #(W+7+1) cs_3in_29(.a({ sum126, c126, sum129 }),               .sum(sum_29), .cout(c_29) );
 carry_save_3inputs #(W+7+1) cs_3in_30(.a({ c129, c132, sum132   }),               .sum(sum_30), .cout(c_30) );
 carry_save_3inputs #(W+7+1) cs_3in_31(.a({ sum135, c135, sum138 }),               .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+7+1) cs_3in_32(.a({ c138, c141, sum141   }),               .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+7+1) cs_3in_33(.a({ sum144, c144, sum147 }),               .sum(sum_33), .cout(c_33) );
 carry_save_3inputs #(W+7+1) cs_3in_34(.a({ c147, c150, sum150   }),               .sum(sum_34), .cout(c_34) );
 carry_save_3inputs #(W+7+1) cs_3in_35(.a({ sum153, c153, sum156 }),               .sum(sum_35), .cout(c_35) );
 carry_save_3inputs #(W+7+1) cs_3in_36(.a({ c156, c159, sum159   }),               .sum(sum_36), .cout(c_36) );
 carry_save_3inputs #(W+7+1) cs_3in_37(.a({ sum162, c162, sum165 }),               .sum(sum_37), .cout(c_37) );
 carry_save_3inputs #(W+7+1) cs_3in_38(.a({ c165, c168, sum168   }),               .sum(sum_38), .cout(c_38) );
 carry_save_3inputs #(W+7+1) cs_3in_39(.a({ sum171, c171, sum174 }),               .sum(sum_39), .cout(c_39) );
 carry_save_3inputs #(W+7+1) cs_3in_40(.a({ c174, c177, sum177   }),               .sum(sum_40), .cout(c_40) );
 carry_save_3inputs #(W+7+1) cs_3in_41(.a({ sum180, c180, sum183 }),               .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+7+1) cs_3in_42(.a({ c183, c186, sum186   }),               .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+7+1) cs_3in_43(.a({ sum189, c189, sum192 }),               .sum(sum_43), .cout(c_43) );
 carry_save_3inputs #(W+7+1) cs_3in_44(.a({ c192, c195, sum195   }),               .sum(sum_44), .cout(c_44) );
 carry_save_3inputs #(W+7+1) cs_3in_45(.a({ sum198, c198, sum201 }),               .sum(sum_45), .cout(c_45) );
 carry_save_3inputs #(W+7+1) cs_3in_46(.a({ c201, c204, sum204   }),               .sum(sum_46), .cout(c_46) );
 carry_save_3inputs #(W+7+1) cs_3in_47(.a({ sum207, c207, sum210 }),               .sum(sum_47), .cout(c_47) );
 carry_save_3inputs #(W+7+1) cs_3in_48(.a({ c210, c213, sum213   }),               .sum(sum_48), .cout(c_48) );
 carry_save_3inputs #(W+7+1) cs_3in_49(.a({ sum216, c216, sum219 }),               .sum(sum_49), .cout(c_49) );
 carry_save_3inputs #(W+7+1) cs_3in_50(.a({ c219, c222, sum222   }),               .sum(sum_50), .cout(c_50) );
 carry_save_3inputs #(W+7+1) cs_3in_51(.a({ sum225, c225, sum228 }),               .sum(sum_51), .cout(c_51) );
 carry_save_3inputs #(W+7+1) cs_3in_52(.a({ c228, c231, sum231   }),               .sum(sum_52), .cout(c_52) );
 carry_save_3inputs #(W+7+1) cs_3in_53(.a({ sum234, c234, sum237 }),               .sum(sum_53), .cout(c_53) );
 carry_save_3inputs #(W+7+1) cs_3in_54(.a({ c237, c240, sum240   }),               .sum(sum_54), .cout(c_54) );
 carry_save_3inputs #(W+7+1) cs_3in_55(.a({ sum243, c243, sum246 }),               .sum(sum_55), .cout(c_55) );
 carry_save_3inputs #(W+7+1) cs_3in_56(.a({ c246, c249, sum249   }),               .sum(sum_56), .cout(c_56) );
 carry_save_3inputs #(W+7+1) cs_3in_57(.a({ sum252, c252, {(7+1){a[255*W+W-1]}} ,a[255*W +: W ] }),.sum(sum_57), .cout(c_57) );


 carry_save_3inputs #(W+7+2) cs_3in_61(.a({ sum_01, c_01, sum_02 }), .sum(sum_61), .cout(c_61) );
 carry_save_3inputs #(W+7+2) cs_3in_62(.a({ c_02, sum_03, c_03   }), .sum(sum_62), .cout(c_62) );
 carry_save_3inputs #(W+7+2) cs_3in_63(.a({ sum_04, c_04, sum_05 }), .sum(sum_63), .cout(c_63) );
 carry_save_3inputs #(W+7+2) cs_3in_64(.a({ c_05, sum_06, c_06   }), .sum(sum_64), .cout(c_64) );
 carry_save_3inputs #(W+7+2) cs_3in_65(.a({ sum_07, c_07, sum_08 }), .sum(sum_65), .cout(c_65) );
 carry_save_3inputs #(W+7+2) cs_3in_66(.a({ c_08, sum_09, c_09   }), .sum(sum_66), .cout(c_66) );
 carry_save_3inputs #(W+7+2) cs_3in_67(.a({ sum_10, c_10, sum_11 }), .sum(sum_67), .cout(c_67) );
 carry_save_3inputs #(W+7+2) cs_3in_68(.a({ c_11, sum_12, c_12   }), .sum(sum_68), .cout(c_68) );
 carry_save_3inputs #(W+7+2) cs_3in_69(.a({ sum_13, c_13, sum_14 }), .sum(sum_69), .cout(c_69) );
 carry_save_3inputs #(W+7+2) cs_3in_70(.a({ c_14, sum_15, c_15   }), .sum(sum_70), .cout(c_70) );
 carry_save_3inputs #(W+7+2) cs_3in_71(.a({ sum_16, c_16, sum_17 }), .sum(sum_71), .cout(c_71) );
 carry_save_3inputs #(W+7+2) cs_3in_72(.a({ c_17, sum_18, c_18   }), .sum(sum_72), .cout(c_72) );
 carry_save_3inputs #(W+7+2) cs_3in_73(.a({ sum_19, c_19, sum_20 }), .sum(sum_73), .cout(c_73) );
 carry_save_3inputs #(W+7+2) cs_3in_74(.a({ c_20, sum_21, c_21   }), .sum(sum_74), .cout(c_74) );
 carry_save_3inputs #(W+7+2) cs_3in_75(.a({ sum_22, c_22, sum_23 }), .sum(sum_75), .cout(c_75) );
 carry_save_3inputs #(W+7+2) cs_3in_76(.a({ c_23, sum_24, c_24   }), .sum(sum_76), .cout(c_76) );
 carry_save_3inputs #(W+7+2) cs_3in_77(.a({ sum_25, c_25, sum_26 }), .sum(sum_77), .cout(c_77) );
 carry_save_3inputs #(W+7+2) cs_3in_78(.a({ c_26, sum_27, c_27   }), .sum(sum_78), .cout(c_78) );
 carry_save_3inputs #(W+7+2) cs_3in_79(.a({ sum_28, c_28, sum_29 }), .sum(sum_79), .cout(c_79) );
 carry_save_3inputs #(W+7+2) cs_3in_80(.a({ c_29, sum_30, c_30   }), .sum(sum_80), .cout(c_80) );
 carry_save_3inputs #(W+7+2) cs_3in_81(.a({ sum_31, c_31, sum_32 }), .sum(sum_81), .cout(c_81) );
 carry_save_3inputs #(W+7+2) cs_3in_82(.a({ c_32, sum_33, c_33   }), .sum(sum_82), .cout(c_82) );
 carry_save_3inputs #(W+7+2) cs_3in_83(.a({ sum_34, c_34, sum_35 }), .sum(sum_83), .cout(c_83) );
 carry_save_3inputs #(W+7+2) cs_3in_84(.a({ c_35, sum_36, c_36   }), .sum(sum_84), .cout(c_84) );
 carry_save_3inputs #(W+7+2) cs_3in_85(.a({ sum_37, c_37, sum_38 }), .sum(sum_85), .cout(c_85) );
 carry_save_3inputs #(W+7+2) cs_3in_86(.a({ c_38, sum_39, c_39   }), .sum(sum_86), .cout(c_86) );
 carry_save_3inputs #(W+7+2) cs_3in_87(.a({ sum_40, c_40, sum_41 }), .sum(sum_87), .cout(c_87) );
 carry_save_3inputs #(W+7+2) cs_3in_88(.a({ c_41, sum_42, c_42   }), .sum(sum_88), .cout(c_88) );
 carry_save_3inputs #(W+7+2) cs_3in_89(.a({ sum_43, c_43, sum_44 }), .sum(sum_89), .cout(c_89) );
 carry_save_3inputs #(W+7+2) cs_3in_90(.a({ c_44, sum_45, c_45   }), .sum(sum_90), .cout(c_90) );
 carry_save_3inputs #(W+7+2) cs_3in_91(.a({ sum_46, c_46, sum_47 }), .sum(sum_91), .cout(c_91) );
 carry_save_3inputs #(W+7+2) cs_3in_92(.a({ c_47, sum_48, c_48   }), .sum(sum_92), .cout(c_92) );
 carry_save_3inputs #(W+7+2) cs_3in_93(.a({ sum_49, c_49, sum_50 }), .sum(sum_93), .cout(c_93) );
 carry_save_3inputs #(W+7+2) cs_3in_94(.a({ c_50, sum_51, c_51   }), .sum(sum_94), .cout(c_94) );
 carry_save_3inputs #(W+7+2) cs_3in_95(.a({ sum_52, c_52, sum_53 }), .sum(sum_95), .cout(c_95) );
 carry_save_3inputs #(W+7+2) cs_3in_96(.a({ c_53, sum_54, c_54   }), .sum(sum_96), .cout(c_96) );
 carry_save_3inputs #(W+7+2) cs_3in_97(.a({ sum_55, c_55, sum_56 }), .sum(sum_97), .cout(c_97) );
 carry_save_3inputs #(W+7+2) cs_3in_98(.a({ c_56, sum_57, c_57   }), .sum(sum_98), .cout(c_98) );


 carry_save_3inputs #(W+7+3) cs_3in_301(.a({ sum_61, c_61, sum_62 }), .sum(sum_301), .cout(c_301) );
 carry_save_3inputs #(W+7+3) cs_3in_302(.a({ c_62, sum_63, c_63   }), .sum(sum_302), .cout(c_302) );
 carry_save_3inputs #(W+7+3) cs_3in_303(.a({ sum_64, c_64, sum_65 }), .sum(sum_303), .cout(c_303) );
 carry_save_3inputs #(W+7+3) cs_3in_304(.a({ c_65, sum_66, c_66   }), .sum(sum_304), .cout(c_304) );
 carry_save_3inputs #(W+7+3) cs_3in_305(.a({ sum_67, c_67, sum_68 }), .sum(sum_305), .cout(c_305) );
 carry_save_3inputs #(W+7+3) cs_3in_306(.a({ c_68, sum_69, c_69   }), .sum(sum_306), .cout(c_306) );
 carry_save_3inputs #(W+7+3) cs_3in_307(.a({ sum_70, c_70, sum_71 }), .sum(sum_307), .cout(c_307) );
 carry_save_3inputs #(W+7+3) cs_3in_308(.a({ c_71, sum_72, c_72   }), .sum(sum_308), .cout(c_308) );
 carry_save_3inputs #(W+7+3) cs_3in_309(.a({ sum_73, c_73, sum_74 }), .sum(sum_309), .cout(c_309) );
 carry_save_3inputs #(W+7+3) cs_3in_310(.a({ c_74, sum_75, c_75   }), .sum(sum_310), .cout(c_310) );
 carry_save_3inputs #(W+7+3) cs_3in_311(.a({ sum_76, c_76, sum_77 }), .sum(sum_311), .cout(c_311) );
 carry_save_3inputs #(W+7+3) cs_3in_312(.a({ c_77, sum_78, c_78   }), .sum(sum_312), .cout(c_312) );
 carry_save_3inputs #(W+7+3) cs_3in_313(.a({ sum_79, c_79, sum_80 }), .sum(sum_313), .cout(c_313) );
 carry_save_3inputs #(W+7+3) cs_3in_314(.a({ c_80, sum_81, c_81   }), .sum(sum_314), .cout(c_314) );
 carry_save_3inputs #(W+7+3) cs_3in_315(.a({ sum_82, c_82, sum_83 }), .sum(sum_315), .cout(c_315) );
 carry_save_3inputs #(W+7+3) cs_3in_316(.a({ c_83, sum_84, c_84   }), .sum(sum_316), .cout(c_316) );
 carry_save_3inputs #(W+7+3) cs_3in_317(.a({ sum_85, c_85, sum_86 }), .sum(sum_317), .cout(c_317) );
 carry_save_3inputs #(W+7+3) cs_3in_318(.a({ c_86, sum_87, c_87   }), .sum(sum_318), .cout(c_318) );
 carry_save_3inputs #(W+7+3) cs_3in_319(.a({ sum_88, c_88, sum_89 }), .sum(sum_319), .cout(c_319) );
 carry_save_3inputs #(W+7+3) cs_3in_320(.a({ c_89, sum_90, c_90   }), .sum(sum_320), .cout(c_320) );
 carry_save_3inputs #(W+7+3) cs_3in_321(.a({ sum_91, c_91, sum_92 }), .sum(sum_321), .cout(c_321) );
 carry_save_3inputs #(W+7+3) cs_3in_322(.a({ c_92, sum_93, c_93   }), .sum(sum_322), .cout(c_322) );
 carry_save_3inputs #(W+7+3) cs_3in_323(.a({ sum_94, c_94, sum_95 }), .sum(sum_323), .cout(c_323) );
 carry_save_3inputs #(W+7+3) cs_3in_324(.a({ c_95, sum_96, c_96   }), .sum(sum_324), .cout(c_324) );
 carry_save_3inputs #(W+7+3) cs_3in_325(.a({ sum_97, sum_98,c_97  }), .sum(sum_325), .cout(c_325) ); // c_98 do not added


 carry_save_3inputs #(W+7+4) cs_3in_331(.a({ sum_301, c_301, sum_302           }), .sum(sum_331), .cout(c_331) );
 carry_save_3inputs #(W+7+4) cs_3in_332(.a({ c_302, sum_303, c_303             }), .sum(sum_332), .cout(c_332) );
 carry_save_3inputs #(W+7+4) cs_3in_333(.a({ sum_304, c_304, sum_305           }), .sum(sum_333), .cout(c_333) );
 carry_save_3inputs #(W+7+4) cs_3in_334(.a({ c_305, sum_306, c_306             }), .sum(sum_334), .cout(c_334) );
 carry_save_3inputs #(W+7+4) cs_3in_335(.a({ sum_307, c_307, sum_308           }), .sum(sum_335), .cout(c_335) );
 carry_save_3inputs #(W+7+4) cs_3in_336(.a({ c_308, sum_309, c_309             }), .sum(sum_336), .cout(c_336) );
 carry_save_3inputs #(W+7+4) cs_3in_337(.a({ sum_310, c_310, sum_311           }), .sum(sum_337), .cout(c_337) );
 carry_save_3inputs #(W+7+4) cs_3in_338(.a({ c_311, sum_312, c_312             }), .sum(sum_338), .cout(c_338) );
 carry_save_3inputs #(W+7+4) cs_3in_339(.a({ sum_313, c_313, sum_314           }), .sum(sum_339), .cout(c_339) );
 carry_save_3inputs #(W+7+4) cs_3in_340(.a({ c_314, sum_315, c_315             }), .sum(sum_340), .cout(c_340) );
 carry_save_3inputs #(W+7+4) cs_3in_341(.a({ sum_316, c_316, sum_317           }), .sum(sum_341), .cout(c_341) );
 carry_save_3inputs #(W+7+4) cs_3in_342(.a({ c_317, sum_318, c_318             }), .sum(sum_342), .cout(c_342) );
 carry_save_3inputs #(W+7+4) cs_3in_343(.a({ sum_319, c_319, sum_320           }), .sum(sum_343), .cout(c_343) );
 carry_save_3inputs #(W+7+4) cs_3in_344(.a({ c_320, sum_321, c_321             }), .sum(sum_344), .cout(c_344) );
 carry_save_3inputs #(W+7+4) cs_3in_345(.a({ sum_322, c_322, sum_323           }), .sum(sum_345), .cout(c_345) );
 carry_save_3inputs #(W+7+4) cs_3in_346(.a({ c_323, sum_324, c_324             }), .sum(sum_346), .cout(c_346) );
 carry_save_3inputs #(W+7+4) cs_3in_347(.a({ sum_325,c_325,{c_98[W+7+2], c_98} }), .sum(sum_347), .cout(c_347) );


 carry_save_3inputs #(W+7+5) cs_3in_351(.a({ sum_331, c_331, sum_332 }), .sum(sum_351), .cout(c_351) );
 carry_save_3inputs #(W+7+5) cs_3in_352(.a({ c_332, sum_333, c_333   }), .sum(sum_352), .cout(c_352) );
 carry_save_3inputs #(W+7+5) cs_3in_353(.a({ sum_334, c_334, sum_335 }), .sum(sum_353), .cout(c_353) );
 carry_save_3inputs #(W+7+5) cs_3in_354(.a({ c_335, sum_336, c_336   }), .sum(sum_354), .cout(c_354) );
 carry_save_3inputs #(W+7+5) cs_3in_355(.a({ sum_337, c_337, sum_338 }), .sum(sum_355), .cout(c_355) );
 carry_save_3inputs #(W+7+5) cs_3in_356(.a({ c_338, sum_339, c_339   }), .sum(sum_356), .cout(c_356) );
 carry_save_3inputs #(W+7+5) cs_3in_357(.a({ sum_340, c_340, sum_341 }), .sum(sum_357), .cout(c_357) );
 carry_save_3inputs #(W+7+5) cs_3in_358(.a({ c_341, sum_342, c_342   }), .sum(sum_358), .cout(c_358) );
 carry_save_3inputs #(W+7+5) cs_3in_359(.a({ sum_343, c_343, sum_344 }), .sum(sum_359), .cout(c_359) );
 carry_save_3inputs #(W+7+5) cs_3in_360(.a({ c_344, sum_345, c_345   }), .sum(sum_360), .cout(c_360) );
 carry_save_3inputs #(W+7+5) cs_3in_361(.a({ sum_346, sum_347,c_346  }), .sum(sum_361), .cout(c_361) ); // c_347 do not added


 carry_save_3inputs #(W+7+6) cs_3in_371(.a({ sum_351, c_351, sum_352             }), .sum(sum_371), .cout(c_371) );
 carry_save_3inputs #(W+7+6) cs_3in_372(.a({ c_352, sum_353, c_353               }), .sum(sum_372), .cout(c_372) );
 carry_save_3inputs #(W+7+6) cs_3in_373(.a({ sum_354, c_354, sum_355             }), .sum(sum_373), .cout(c_373) );
 carry_save_3inputs #(W+7+6) cs_3in_374(.a({ c_355, sum_356, c_356               }), .sum(sum_374), .cout(c_374) );
 carry_save_3inputs #(W+7+6) cs_3in_375(.a({ sum_357, c_357, sum_358             }), .sum(sum_375), .cout(c_375) );
 carry_save_3inputs #(W+7+6) cs_3in_376(.a({ c_358, sum_359, c_359               }), .sum(sum_376), .cout(c_376) );
 carry_save_3inputs #(W+7+6) cs_3in_377(.a({ sum_360,c_360,{ c_347[W+7+4],c_347} }), .sum(sum_377), .cout(c_377) ); // sum_361, c_361 do not added


 carry_save_3inputs #(W+7+7) cs_3in_381(.a({ sum_371,c_371, sum_372                                      }), .sum(sum_381), .cout(c_381) );
 carry_save_3inputs #(W+7+7) cs_3in_382(.a({ c_372, sum_373, c_373                                       }), .sum(sum_382), .cout(c_382) );
 carry_save_3inputs #(W+7+7) cs_3in_383(.a({ sum_374,c_374, sum_375                                      }), .sum(sum_383), .cout(c_383) );
 carry_save_3inputs #(W+7+7) cs_3in_384(.a({ c_375, sum_376, c_376                                       }), .sum(sum_384), .cout(c_384) );
 carry_save_3inputs #(W+7+7) cs_3in_385(.a({ sum_377, { sum_361[W+7+5] ,sum_361}, { c_361[W+7+5] ,c_361} }), .sum(sum_385), .cout(c_385) );  // c_377 do not added


 carry_save_3inputs #(W+7+8) cs_3in_391(.a({ sum_381, sum_382, c_381              }), .sum(sum_391), .cout(c_391) );
 carry_save_3inputs #(W+7+8) cs_3in_392(.a({ sum_383, c_382, c_383                }), .sum(sum_392), .cout(c_392) );
 carry_save_3inputs #(W+7+8) cs_3in_393(.a({ sum_384, c_384, {c_377[W+7+6],c_377} }), .sum(sum_393), .cout(c_393) ); // sum_385 c_385 do not added


carry_save_8inputs #(W+7+9) cs_8in (.a({ sum_391, c_391, sum_392, c_392, sum_393, c_393, {sum_385[W+7+7],sum_385}, {c_385[W+7+7],c_385} }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+7  :0];
assign sum  = sum5 [W+7  :0];


endmodule


////////////////////////////////////
// Carry Save 512 inputs 
////////////////////////////////////

module carry_save_512inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [512*W-1:0] a; //, b,c,d;
output [W+8  :0] sum;
output [W+8  :0] cout;

wire [W+8:0] sum000, c000, sum003, c003, sum006, c006, sum009, c009, sum012, c012, sum015, c015, sum018, c018, sum021, c021; 
wire [W+8:0] sum024, c024, sum027, c027, sum030, c030, sum033, c033, sum036, c036, sum039, c039, sum042, c042, sum045, c045; 
wire [W+8:0] sum048, c048, sum051, c051, sum054, c054, sum057, c057, sum060, c060, sum063, c063, sum066, c066, sum069, c069; 
wire [W+8:0] sum072, c072, sum075, c075, sum078, c078, sum081, c081, sum084, c084, sum087, c087, sum090, c090, sum093, c093; 
wire [W+8:0] sum096, c096, sum099, c099, sum102, c102, sum105, c105, sum108, c108, sum111, c111, sum114, c114, sum117, c117, sum120, c120, sum123, c123;
wire [W+8:0] sum126, c126, sum129, c129, sum132, c132, sum135, c135, sum138, c138, sum141, c141, sum144, c144, sum147, c147;
wire [W+8:0] sum150, c150, sum153, c153, sum156, c156, sum159, c159, sum162, c162, sum165, c165, sum168, c168, sum171, c171;
wire [W+8:0] sum174, c174, sum177, c177, sum180, c180, sum183, c183, sum186, c186, sum189, c189, sum192, c192, sum195, c195;
wire [W+8:0] sum198, c198, sum201, c201, sum204, c204, sum207, c207, sum210, c210, sum213, c213, sum216, c216, sum219, c219;
wire [W+8:0] sum222, c222, sum225, c225, sum228, c228, sum231, c231, sum234, c234, sum237, c237, sum240, c240, sum243, c243, sum246, c246, sum249, c249, sum252, c252; 
wire [W+8:0] sum255, c255, sum258, c258, sum261, c261, sum264, c264, sum267, c267, sum270, c270, sum273, c273, sum276, c276;  
wire [W+8:0] sum279, c279, sum282, c282, sum285, c285, sum288, c288, sum291, c291, sum294, c294, sum297, c297, sum300, c300;  
wire [W+8:0] sum303, c303, sum306, c306, sum309, c309, sum312, c312, sum315, c315, sum318, c318, sum321, c321, sum324, c324;  
wire [W+8:0] sum327, c327, sum330, c330, sum333, c333, sum336, c336, sum339, c339, sum342, c342, sum345, c345, sum348, c348;  
wire [W+8:0] sum351, c351, sum354, c354, sum357, c357, sum360, c360, sum363, c363, sum366, c366, sum369, c369, sum372, c372; 
wire [W+8:0] sum375, c375, sum378, c378, sum381, c381, sum384, c384, sum387, c387, sum390, c390, sum393, c393, sum396, c396;  
wire [W+8:0] sum399, c399, sum402, c402, sum405, c405, sum408, c408, sum411, c411, sum414, c414, sum417, c417, sum420, c420;  
wire [W+8:0] sum423, c423, sum426, c426, sum429, c429, sum432, c432, sum435, c435, sum438, c438, sum441, c441, sum444, c444;  
wire [W+8:0] sum447, c447, sum450, c450, sum453, c453, sum456, c456, sum459, c459, sum462, c462, sum465, c465, sum468, c468;  
wire [W+8:0] sum471, c471, sum474, c474, sum477, c477, sum480, c480, sum483, c483, sum486, c486, sum489, c489, sum492, c492;  
wire [W+8:0] sum495, c495, sum498, c498,  sum501, c501, sum504, c504, sum507, c507; //sum508, c508,

wire [W+8+1:0] sum_01, c_01, sum_02, c_02, sum_03, c_03, sum_04, c_04, sum_05, c_05, sum_06, c_06, sum_07, c_07, sum_08, c_08;
wire [W+8+1:0] sum_09, c_09, sum_10, c_10, sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16;
wire [W+8+1:0] sum_17, c_17, sum_18, c_18, sum_19, c_19, sum_20, c_20, sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+8+1:0] sum_25, c_25, sum_26, c_26, sum_27, c_27, sum_28, c_28;
wire [W+8+1:0] sum_29, c_29, sum_30, c_30, sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34, sum_35, c_35, sum_36, c_36;
wire [W+8+1:0] sum_37, c_37, sum_38, c_38, sum_39, c_39, sum_40, c_40, sum_41, c_41, sum_42, c_42, sum_43, c_43, sum_44, c_44;
wire [W+8+1:0] sum_45, c_45, sum_46, c_46, sum_47, c_47, sum_48, c_48, sum_49, c_49, sum_50, c_50, sum_51, c_51, sum_52, c_52;
wire [W+8+1:0] sum_53, c_53, sum_54, c_54, sum_55, c_55, sum_56, c_56, sum_57, c_57;
wire [W+8+1:0] sum_58, c_58, sum_59, c_59, sum_60, c_60, sum_61, c_61, sum_62, c_62, sum_63, c_63, sum_64, c_64, sum_65, c_65;
wire [W+8+1:0] sum_66, c_66, sum_67, c_67, sum_68, c_68, sum_69, c_69, sum_70, c_70, sum_71, c_71, sum_72, c_72, sum_73, c_73;
wire [W+8+1:0] sum_74, c_74, sum_75, c_75, sum_76, c_76, sum_77, c_77, sum_78, c_78, sum_79, c_79, sum_80, c_80, sum_81, c_81;
wire [W+8+1:0] sum_82, c_82, sum_83, c_83, sum_84, c_84, sum_85, c_85, sum_86, c_86, sum_87, c_87, sum_88, c_88, sum_89, c_89;
wire [W+8+1:0] sum_90, c_90, sum_91, c_91, sum_92, c_92, sum_93, c_93, sum_94, c_94, sum_95, c_95, sum_96, c_96, sum_97, c_97;
wire [W+8+1:0] sum_98, c_98, sum_99, c_99, sum_a0, c_a0, sum_a1, c_a1, sum_a2, c_a2, sum_a3, c_a3, sum_a4, c_a4, sum_a5, c_a5;
wire [W+8+1:0] sum_a6, c_a6, sum_a7, c_a7, sum_a8, c_a8, sum_a9, c_a9, sum_b0, c_b0, sum_b1, c_b1, sum_b2, c_b2, sum_b3, c_b3, sum_b4, c_b4; 


wire [W+8+2:0] sum_161, c_161, sum_162, c_162, sum_163, c_163, sum_164, c_164, sum_165, c_165, sum_166, c_166, sum_167, c_167, sum_168, c_168; 
wire [W+8+2:0] sum_169, c_169, sum_170, c_170, sum_171, c_171, sum_172, c_172, sum_173, c_173, sum_174, c_174, sum_175, c_175, sum_176, c_176; 
wire [W+8+2:0] sum_177, c_177, sum_178, c_178, sum_179, c_179, sum_180, c_180, sum_181, c_181, sum_182, c_182, sum_183, c_183, sum_184, c_184; 
wire [W+8+2:0] sum_185, c_185, sum_186, c_186, sum_187, c_187, sum_188, c_188, sum_189, c_189, sum_190, c_190, sum_191, c_191, sum_192, c_192; 
wire [W+8+2:0] sum_193, c_193, sum_194, c_194, sum_195, c_195, sum_196, c_196, sum_197, c_197, sum_198, c_198;
wire [W+8+2:0] sum_199, c_199, sum_1c0, c_1c0, sum_1c1, c_1c1, sum_1c2, c_1c2, sum_1c3, c_1c3, sum_1c4, c_1c4, sum_1c5, c_1c5, sum_1c6, c_1c6;
wire [W+8+2:0] sum_1c7, c_1c7, sum_1c8, c_1c8, sum_1c9, c_1c9, sum_1d0, c_1d0, sum_1d1, c_1d1, sum_1d2, c_1d2, sum_1d3, c_1d3, sum_1d4, c_1d4;
wire [W+8+2:0] sum_1d5, c_1d5, sum_1d6, c_1d6, sum_1d7, c_1d7, sum_1d8, c_1d8, sum_1d9, c_1d9, sum_1e0, c_1e0, sum_1e1, c_1e1, sum_1e2, c_1e2;
wire [W+8+2:0] sum_1e3, c_1e3, sum_1e4, c_1e4, sum_1e5, c_1e5, sum_1e6, c_1e6, sum_1e7, c_1e7, sum_1e8, c_1e8, sum_1e9, c_1e9, sum_1f0, c_1f0;
wire [W+8+2:0] sum_1f1, c_1f1, sum_1f2, c_1f2, sum_1f3, c_1f3, sum_1f4, c_1f4, sum_1f5, c_1f5, sum_1f6, c_1f6;

wire [W+8+3:0] sum_301, c_301, sum_302, c_302, sum_303, c_303, sum_304, c_304, sum_305, c_305, sum_306, c_306, sum_307, c_307, sum_308, c_308; 
wire [W+8+3:0] sum_309, c_309, sum_310, c_310, sum_311, c_311, sum_312, c_312, sum_313, c_313, sum_314, c_314, sum_315, c_315, sum_316, c_316;
wire [W+8+3:0] sum_317, c_317, sum_318, c_318, sum_319, c_319, sum_320, c_320, sum_321, c_321, sum_322, c_322, sum_323, c_323, sum_324, c_324;
wire [W+8+3:0] sum_400, c_400, sum_401, c_401, sum_402, c_402, sum_403, c_403, sum_404, c_404, sum_405, c_405, sum_406, c_406, sum_407, c_407; 
wire [W+8+3:0] sum_408, c_408, sum_409, c_409, sum_410, c_410, sum_411, c_411, sum_412, c_412, sum_413, c_413, sum_414, c_414, sum_415, c_415, sum_425, c_425;
wire [W+8+3:0] sum_416, c_416, sum_417, c_417, sum_418, c_418, sum_419, c_419, sum_420, c_420, sum_421, c_421, sum_422, c_422, sum_423, c_423, sum_424, c_424; 

wire [W+8+4:0] sum_331, c_331, sum_332, c_332, sum_333, c_333, sum_334, c_334, sum_335, c_335, sum_336, c_336, sum_337, c_337, sum_338, c_338;
wire [W+8+4:0] sum_339, c_339, sum_340, c_340, sum_341, c_341, sum_342, c_342, sum_343, c_343, sum_344, c_344, sum_345, c_345, sum_346, c_346, sum_347, c_347; 
wire [W+8+4:0] sum_430, c_430, sum_431, c_431, sum_432, c_432, sum_433, c_433, sum_434, c_434, sum_435, c_435, sum_436, c_436, sum_437, c_437;
wire [W+8+4:0] sum_438, c_438, sum_439, c_439, sum_440, c_440, sum_441, c_441, sum_442, c_442, sum_443, c_443, sum_444, c_444, sum_445, c_445, sum_446, c_446;

wire [W+8+5:0] sum_351, c_351, sum_352, c_352, sum_353, c_353, sum_354, c_354, sum_355, c_355, sum_356, c_356, sum_357, c_357, sum_358, c_358;
wire [W+8+5:0] sum_359, c_359, sum_360, c_360, sum_361, c_361;
wire [W+8+5:0] sum_450, c_450, sum_451, c_451, sum_452, c_452, sum_453, c_453, sum_454, c_454, sum_455, c_455, sum_456, c_456, sum_457, c_457;
wire [W+8+5:0] sum_458, c_458, sum_459, c_459, sum_45a, c_45a;


wire [W+8+6:0] sum_371, c_371, sum_372, c_372, sum_373, c_373, sum_374, c_374, sum_375, c_375, sum_376, c_376, sum_377, c_377; 
wire [W+8+6:0] sum_460, c_460, sum_461, c_461, sum_462, c_462, sum_463, c_463, sum_464, c_464, sum_465, c_465, sum_466, c_466, sum_467, c_467;

wire [W+8+7:0] sum_381, c_381, sum_382, c_382, sum_383, c_383, sum_384, c_384, sum_385, c_385; 
wire [W+8+7:0] sum_470, c_470, sum_471, c_471, sum_472, c_472, sum_473, c_473, sum_474, c_474;

wire [W+8+8:0] sum_391, c_391, sum_392, c_392, sum_393, c_393; 
wire [W+8+8:0] sum_480, c_480, sum_481, c_481, sum_482, c_482, sum_483, c_483;

wire [W+8+9:0] sum_490, c_490, sum_491, c_491, sum_492, c_492, sum_493, c_493;

wire [W+8+12:0] sum5, cout5;

//wire [W+8+12:0]  test_in, test_1_stage, test_2_stage, test_3_stage, test_4_stage, test_5_stage, test_6_stage, test_7_stage, test_8_stage, test_9_stage, test_A_stage, test_preout, test_out;
//assign test_in = a[  0*W +: W] + a[  1*W +: W] + a[  2*W +: W] + a[  3*W +: W] + a[  4*W +: W] + a[  5*W +: W] + a[  6*W +: W] + a[  7*W +: W] + a[  8*W +: W] + a[  9*W +: W] +
//                 a[ 10*W +: W] + a[ 11*W +: W] + a[ 12*W +: W] + a[ 13*W +: W] + a[ 14*W +: W] + a[ 15*W +: W] + a[ 16*W +: W] + a[ 17*W +: W] + a[ 18*W +: W] + a[ 19*W +: W] +
//                 a[ 20*W +: W] + a[ 21*W +: W] + a[ 22*W +: W] + a[ 23*W +: W] + a[ 24*W +: W] + a[ 25*W +: W] + a[ 26*W +: W] + a[ 27*W +: W] + a[ 28*W +: W] + a[ 29*W +: W] +
//                 a[ 30*W +: W] + a[ 31*W +: W] + a[ 32*W +: W] + a[ 33*W +: W] + a[ 34*W +: W] + a[ 35*W +: W] + a[ 36*W +: W] + a[ 37*W +: W] + a[ 38*W +: W] + a[ 39*W +: W] +
//                 a[ 40*W +: W] + a[ 41*W +: W] + a[ 42*W +: W] + a[ 43*W +: W] + a[ 44*W +: W] + a[ 45*W +: W] + a[ 46*W +: W] + a[ 47*W +: W] + a[ 48*W +: W] + a[ 49*W +: W] +
//                 a[ 50*W +: W] + a[ 51*W +: W] + a[ 52*W +: W] + a[ 53*W +: W] + a[ 54*W +: W] + a[ 55*W +: W] + a[ 56*W +: W] + a[ 57*W +: W] + a[ 58*W +: W] + a[ 59*W +: W] +
//                 a[ 60*W +: W] + a[ 61*W +: W] + a[ 62*W +: W] + a[ 63*W +: W] + a[ 64*W +: W] + a[ 65*W +: W] + a[ 66*W +: W] + a[ 67*W +: W] + a[ 68*W +: W] + a[ 69*W +: W] +
//                 a[ 70*W +: W] + a[ 71*W +: W] + a[ 72*W +: W] + a[ 73*W +: W] + a[ 74*W +: W] + a[ 75*W +: W] + a[ 76*W +: W] + a[ 77*W +: W] + a[ 78*W +: W] + a[ 79*W +: W] +
//                 a[ 80*W +: W] + a[ 81*W +: W] + a[ 82*W +: W] + a[ 83*W +: W] + a[ 84*W +: W] + a[ 85*W +: W] + a[ 86*W +: W] + a[ 87*W +: W] + a[ 88*W +: W] + a[ 89*W +: W] +
//                 a[ 90*W +: W] + a[ 91*W +: W] + a[ 92*W +: W] + a[ 93*W +: W] + a[ 94*W +: W] + a[ 95*W +: W] + a[ 96*W +: W] + a[ 97*W +: W] + a[ 98*W +: W] + a[ 99*W +: W] +
//                 a[100*W +: W] + a[101*W +: W] + a[102*W +: W] + a[103*W +: W] + a[104*W +: W] + a[105*W +: W] + a[106*W +: W] + a[107*W +: W] + a[108*W +: W] + a[109*W +: W] +
//                 a[110*W +: W] + a[111*W +: W] + a[112*W +: W] + a[113*W +: W] + a[114*W +: W] + a[115*W +: W] + a[116*W +: W] + a[117*W +: W] + a[118*W +: W] + a[119*W +: W] +
//                 a[120*W +: W] + a[121*W +: W] + a[122*W +: W] + a[123*W +: W] + a[124*W +: W] + a[125*W +: W] + a[126*W +: W] + a[127*W +: W] + a[128*W +: W] + a[129*W +: W] +
//                 a[130*W +: W] + a[131*W +: W] + a[132*W +: W] + a[133*W +: W] + a[134*W +: W] + a[135*W +: W] + a[136*W +: W] + a[137*W +: W] + a[138*W +: W] + a[139*W +: W] +
//                 a[140*W +: W] + a[141*W +: W] + a[142*W +: W] + a[143*W +: W] + a[144*W +: W] + a[145*W +: W] + a[146*W +: W] + a[147*W +: W] + a[148*W +: W] + a[149*W +: W] +
//                 a[150*W +: W] + a[151*W +: W] + a[152*W +: W] + a[153*W +: W] + a[154*W +: W] + a[155*W +: W] + a[156*W +: W] + a[157*W +: W] + a[158*W +: W] + a[159*W +: W] +
//                 a[160*W +: W] + a[161*W +: W] + a[162*W +: W] + a[163*W +: W] + a[164*W +: W] + a[165*W +: W] + a[166*W +: W] + a[167*W +: W] + a[168*W +: W] + a[169*W +: W] +
//                 a[170*W +: W] + a[171*W +: W] + a[172*W +: W] + a[173*W +: W] + a[174*W +: W] + a[175*W +: W] + a[176*W +: W] + a[177*W +: W] + a[178*W +: W] + a[179*W +: W] +
//                 a[180*W +: W] + a[181*W +: W] + a[182*W +: W] + a[183*W +: W] + a[184*W +: W] + a[185*W +: W] + a[186*W +: W] + a[187*W +: W] + a[188*W +: W] + a[189*W +: W] +
//                 a[190*W +: W] + a[191*W +: W] + a[192*W +: W] + a[193*W +: W] + a[194*W +: W] + a[195*W +: W] + a[196*W +: W] + a[197*W +: W] + a[198*W +: W] + a[199*W +: W] +
//                 a[200*W +: W] + a[201*W +: W] + a[202*W +: W] + a[203*W +: W] + a[204*W +: W] + a[205*W +: W] + a[206*W +: W] + a[207*W +: W] + a[208*W +: W] + a[209*W +: W] +
//                 a[210*W +: W] + a[211*W +: W] + a[212*W +: W] + a[213*W +: W] + a[214*W +: W] + a[215*W +: W] + a[216*W +: W] + a[217*W +: W] + a[218*W +: W] + a[219*W +: W] +
//                 a[220*W +: W] + a[221*W +: W] + a[222*W +: W] + a[223*W +: W] + a[224*W +: W] + a[225*W +: W] + a[226*W +: W] + a[227*W +: W] + a[228*W +: W] + a[229*W +: W] +
//                 a[230*W +: W] + a[231*W +: W] + a[232*W +: W] + a[233*W +: W] + a[234*W +: W] + a[235*W +: W] + a[236*W +: W] + a[237*W +: W] + a[238*W +: W] + a[239*W +: W] +
//                 a[240*W +: W] + a[241*W +: W] + a[242*W +: W] + a[243*W +: W] + a[244*W +: W] + a[245*W +: W] + a[246*W +: W] + a[247*W +: W] + a[248*W +: W] + a[249*W +: W] +
//                 a[250*W +: W] + a[251*W +: W] + a[252*W +: W] + a[253*W +: W] + a[254*W +: W] + a[255*W +: W] + a[256*W +: W] + a[257*W +: W] + a[258*W +: W] + a[259*W +: W] +
//                 a[260*W +: W] + a[261*W +: W] + a[262*W +: W] + a[263*W +: W] + a[264*W +: W] + a[265*W +: W] + a[266*W +: W] + a[267*W +: W] + a[268*W +: W] + a[269*W +: W] +
//                 a[270*W +: W] + a[271*W +: W] + a[272*W +: W] + a[273*W +: W] + a[274*W +: W] + a[275*W +: W] + a[276*W +: W] + a[277*W +: W] + a[278*W +: W] + a[279*W +: W] +
//                 a[280*W +: W] + a[281*W +: W] + a[282*W +: W] + a[283*W +: W] + a[284*W +: W] + a[285*W +: W] + a[286*W +: W] + a[287*W +: W] + a[288*W +: W] + a[289*W +: W] +
//                 a[290*W +: W] + a[291*W +: W] + a[292*W +: W] + a[293*W +: W] + a[294*W +: W] + a[295*W +: W] + a[296*W +: W] + a[297*W +: W] + a[298*W +: W] + a[299*W +: W] +
//                 a[300*W +: W] + a[301*W +: W] + a[302*W +: W] + a[303*W +: W] + a[304*W +: W] + a[305*W +: W] + a[306*W +: W] + a[307*W +: W] + a[308*W +: W] + a[309*W +: W] +
//                 a[310*W +: W] + a[311*W +: W] + a[312*W +: W] + a[313*W +: W] + a[314*W +: W] + a[315*W +: W] + a[316*W +: W] + a[317*W +: W] + a[318*W +: W] + a[319*W +: W] +
//                 a[320*W +: W] + a[321*W +: W] + a[322*W +: W] + a[323*W +: W] + a[324*W +: W] + a[325*W +: W] + a[326*W +: W] + a[327*W +: W] + a[328*W +: W] + a[329*W +: W] +
//                 a[330*W +: W] + a[331*W +: W] + a[332*W +: W] + a[333*W +: W] + a[334*W +: W] + a[335*W +: W] + a[336*W +: W] + a[337*W +: W] + a[338*W +: W] + a[339*W +: W] +
//                 a[340*W +: W] + a[341*W +: W] + a[342*W +: W] + a[343*W +: W] + a[344*W +: W] + a[345*W +: W] + a[346*W +: W] + a[347*W +: W] + a[348*W +: W] + a[349*W +: W] +
//                 a[350*W +: W] + a[351*W +: W] + a[352*W +: W] + a[353*W +: W] + a[354*W +: W] + a[355*W +: W] + a[356*W +: W] + a[357*W +: W] + a[358*W +: W] + a[359*W +: W] +
//                 a[360*W +: W] + a[361*W +: W] + a[362*W +: W] + a[363*W +: W] + a[364*W +: W] + a[365*W +: W] + a[366*W +: W] + a[367*W +: W] + a[368*W +: W] + a[369*W +: W] +
//                 a[370*W +: W] + a[371*W +: W] + a[372*W +: W] + a[373*W +: W] + a[374*W +: W] + a[375*W +: W] + a[376*W +: W] + a[377*W +: W] + a[378*W +: W] + a[379*W +: W] +
//                 a[380*W +: W] + a[381*W +: W] + a[382*W +: W] + a[383*W +: W] + a[384*W +: W] + a[385*W +: W] + a[386*W +: W] + a[387*W +: W] + a[388*W +: W] + a[389*W +: W] +
//                 a[390*W +: W] + a[391*W +: W] + a[392*W +: W] + a[393*W +: W] + a[394*W +: W] + a[395*W +: W] + a[396*W +: W] + a[397*W +: W] + a[398*W +: W] + a[399*W +: W] +
//                 a[400*W +: W] + a[401*W +: W] + a[402*W +: W] + a[403*W +: W] + a[404*W +: W] + a[405*W +: W] + a[406*W +: W] + a[407*W +: W] + a[408*W +: W] + a[409*W +: W] +
//                 a[410*W +: W] + a[411*W +: W] + a[412*W +: W] + a[413*W +: W] + a[414*W +: W] + a[415*W +: W] + a[416*W +: W] + a[417*W +: W] + a[418*W +: W] + a[419*W +: W] +
//                 a[420*W +: W] + a[421*W +: W] + a[422*W +: W] + a[423*W +: W] + a[424*W +: W] + a[425*W +: W] + a[426*W +: W] + a[427*W +: W] + a[428*W +: W] + a[429*W +: W] +
//                 a[430*W +: W] + a[431*W +: W] + a[432*W +: W] + a[433*W +: W] + a[434*W +: W] + a[435*W +: W] + a[436*W +: W] + a[437*W +: W] + a[438*W +: W] + a[439*W +: W] +
//                 a[440*W +: W] + a[441*W +: W] + a[442*W +: W] + a[443*W +: W] + a[444*W +: W] + a[445*W +: W] + a[446*W +: W] + a[447*W +: W] + a[448*W +: W] + a[449*W +: W] +
//                 a[450*W +: W] + a[451*W +: W] + a[452*W +: W] + a[453*W +: W] + a[454*W +: W] + a[455*W +: W] + a[456*W +: W] + a[457*W +: W] + a[458*W +: W] + a[459*W +: W] +
//                 a[460*W +: W] + a[461*W +: W] + a[462*W +: W] + a[463*W +: W] + a[464*W +: W] + a[465*W +: W] + a[466*W +: W] + a[467*W +: W] + a[468*W +: W] + a[469*W +: W] +
//                 a[470*W +: W] + a[471*W +: W] + a[472*W +: W] + a[473*W +: W] + a[474*W +: W] + a[475*W +: W] + a[476*W +: W] + a[477*W +: W] + a[478*W +: W] + a[479*W +: W] +
//                 a[480*W +: W] + a[481*W +: W] + a[482*W +: W] + a[483*W +: W] + a[484*W +: W] + a[485*W +: W] + a[486*W +: W] + a[487*W +: W] + a[488*W +: W] + a[489*W +: W] +
//                 a[490*W +: W] + a[491*W +: W] + a[492*W +: W] + a[493*W +: W] + a[494*W +: W] + a[495*W +: W] + a[496*W +: W] + a[497*W +: W] + a[498*W +: W] + a[499*W +: W] +
//                 a[500*W +: W] + a[501*W +: W] + a[502*W +: W] + a[503*W +: W] + a[504*W +: W] + a[505*W +: W] + a[506*W +: W] + a[507*W +: W] + a[508*W +: W] + a[509*W +: W] +
//                 a[510*W +: W] + a[511*W +: W] ;
//
//assign test_1_stage = 
//         sum000 + c000 + sum003 + c003 + sum006 + c006 + sum009 + c009 + sum012 + c012 + sum015 + c015 + sum018 + c018 + sum021 + c021 + a[510*W +:W] +
//         sum024 + c024 + sum027 + c027 + sum030 + c030 + sum033 + c033 + sum036 + c036 + sum039 + c039 + sum042 + c042 + sum045 + c045 + a[511*W +:W] +
//         sum048 + c048 + sum051 + c051 + sum054 + c054 + sum057 + c057 + sum060 + c060 + sum063 + c063 + sum066 + c066 + sum069 + c069 + 
//         sum072 + c072 + sum075 + c075 + sum078 + c078 + sum081 + c081 + sum084 + c084 + sum087 + c087 + sum090 + c090 + sum093 + c093 + 
//         sum096 + c096 + sum099 + c099 + sum102 + c102 + sum105 + c105 + sum108 + c108 + sum111 + c111 + sum114 + c114 + sum117 + c117 + sum120 + c120 + sum123 + c123+
//         sum126 + c126 + sum129 + c129 + sum132 + c132 + sum135 + c135 + sum138 + c138 + sum141 + c141 + sum144 + c144 + sum147 + c147 +
//         sum150 + c150 + sum153 + c153 + sum156 + c156 + sum159 + c159 + sum162 + c162 + sum165 + c165 + sum168 + c168 + sum171 + c171 +
//         sum174 + c174 + sum177 + c177 + sum180 + c180 + sum183 + c183 + sum186 + c186 + sum189 + c189 + sum192 + c192 + sum195 + c195 +
//         sum198 + c198 + sum201 + c201 + sum204 + c204 + sum207 + c207 + sum210 + c210 + sum213 + c213 + sum216 + c216 + sum219 + c219 +
//         sum222 + c222 + sum225 + c225 + sum228 + c228 + sum231 + c231 + sum234 + c234 + sum237 + c237 + sum240 + c240 + sum243 + c243 + sum246 + c246 + sum249 + c249 + sum252 + c252 + 
//         sum255 + c255 + sum258 + c258 + sum261 + c261 + sum264 + c264 + sum267 + c267 + sum270 + c270 + sum273 + c273 + sum276 + c276 +  
//         sum279 + c279 + sum282 + c282 + sum285 + c285 + sum288 + c288 + sum291 + c291 + sum294 + c294 + sum297 + c297 + sum300 + c300 +  
//         sum303 + c303 + sum306 + c306 + sum309 + c309 + sum312 + c312 + sum315 + c315 + sum318 + c318 + sum321 + c321 + sum324 + c324 +  
//         sum327 + c327 + sum330 + c330 + sum333 + c333 + sum336 + c336 + sum339 + c339 + sum342 + c342 + sum345 + c345 + sum348 + c348 +  
//         sum351 + c351 + sum354 + c354 + sum357 + c357 + sum360 + c360 + sum363 + c363 + sum366 + c366 + sum369 + c369 + sum372 + c372 + 
//         sum375 + c375 + sum378 + c378 + sum381 + c381 + sum384 + c384 + sum387 + c387 + sum390 + c390 + sum393 + c393 + sum396 + c396 +  
//         sum399 + c399 + sum402 + c402 + sum405 + c405 + sum408 + c408 + sum411 + c411 + sum414 + c414 + sum417 + c417 + sum420 + c420 +  
//         sum423 + c423 + sum426 + c426 + sum429 + c429 + sum432 + c432 + sum435 + c435 + sum438 + c438 + sum441 + c441 + sum444 + c444 +  
//         sum447 + c447 + sum450 + c450 + sum453 + c453 + sum456 + c456 + sum459 + c459 + sum462 + c462 + sum465 + c465 + sum468 + c468 +  
//         sum471 + c471 + sum474 + c474 + sum477 + c477 + sum480 + c480 + sum483 + c483 + sum486 + c486 + sum489 + c489 + sum492 + c492 +  
//         sum495 + c495 + sum498 + c498  + sum501 + c501 + sum504 + c504 + sum507 + c507;       //+ sum508 + c508
//
//assign test_2_stage = 
//         sum_01 + c_01 + sum_02 + c_02 + sum_03 + c_03 + sum_04 + c_04 + sum_05 + c_05 + sum_06 + c_06 + sum_07 + c_07 + sum_08 + c_08 + 
//         sum_09 + c_09 + sum_10 + c_10 + sum_11 + c_11 + sum_12 + c_12 + sum_13 + c_13 + sum_14 + c_14 + sum_15 + c_15 + sum_16 + c_16 +
//         sum_17 + c_17 + sum_18 + c_18 + sum_19 + c_19 + sum_20 + c_20 + sum_21 + c_21 + sum_22 + c_22 + sum_23 + c_23 + sum_24 + c_24 +
//         sum_25 + c_25 + sum_26 + c_26 + sum_27 + c_27 + sum_28 + c_28 +
//         sum_29 + c_29 + sum_30 + c_30 + sum_31 + c_31 + sum_32 + c_32 + sum_33 + c_33 + sum_34 + c_34 + sum_35 + c_35 + sum_36 + c_36 + 
//         sum_37 + c_37 + sum_38 + c_38 + sum_39 + c_39 + sum_40 + c_40 + sum_41 + c_41 + sum_42 + c_42 + sum_43 + c_43 + sum_44 + c_44 + 
//         sum_45 + c_45 + sum_46 + c_46 + sum_47 + c_47 + sum_48 + c_48 + sum_49 + c_49 + sum_50 + c_50 + sum_51 + c_51 + sum_52 + c_52 + 
//         sum_53 + c_53 + sum_54 + c_54 + sum_55 + c_55 + sum_56 + c_56 + sum_57 + c_57 +
//         sum_58 + c_58 + sum_59 + c_59 + sum_60 + c_60 + sum_61 + c_61 + sum_62 + c_62 + sum_63 + c_63 + sum_64 + c_64 + sum_65 + c_65 + 
//         sum_66 + c_66 + sum_67 + c_67 + sum_68 + c_68 + sum_69 + c_69 + sum_70 + c_70 + sum_71 + c_71 + sum_72 + c_72 + sum_73 + c_73 + 
//         sum_74 + c_74 + sum_75 + c_75 + sum_76 + c_76 + sum_77 + c_77 + sum_78 + c_78 + sum_79 + c_79 + sum_80 + c_80 + sum_81 + c_81 + 
//         sum_82 + c_82 + sum_83 + c_83 + sum_84 + c_84 + sum_85 + c_85 + sum_86 + c_86 + sum_87 + c_87 + sum_88 + c_88 + sum_89 + c_89 + 
//         sum_90 + c_90 + sum_91 + c_91 + sum_92 + c_92 + sum_93 + c_93 + sum_94 + c_94 + sum_95 + c_95 + sum_96 + c_96 + sum_97 + c_97 + 
//         sum_98 + c_98 + sum_99 + c_99 + sum_a0 + c_a0 + sum_a1 + c_a1 + sum_a2 + c_a2 + sum_a3 + c_a3 + sum_a4 + c_a4 + sum_a5 + c_a5 + sum498 + c498 +
//         sum_a6 + c_a6 + sum_a7 + c_a7 + sum_a8 + c_a8 + sum_a9 + c_a9 + sum_b0 + c_b0 + sum_b1 + c_b1 + sum_b2 + c_b2 + sum_b3 + c_b3 + sum_b4 + c_b4; 
//
//assign test_3_stage = 
//        sum_161 + c_161 + sum_162 + c_162 + sum_163 + c_163 + sum_164 + c_164 + sum_165 + c_165 + sum_166 + c_166 + sum_167 + c_167 + sum_168 + c_168 + 
//        sum_169 + c_169 + sum_170 + c_170 + sum_171 + c_171 + sum_172 + c_172 + sum_173 + c_173 + sum_174 + c_174 + sum_175 + c_175 + sum_176 + c_176 + 
//        sum_177 + c_177 + sum_178 + c_178 + sum_179 + c_179 + sum_180 + c_180 + sum_181 + c_181 + sum_182 + c_182 + sum_183 + c_183 + sum_184 + c_184 + 
//        sum_185 + c_185 + sum_186 + c_186 + sum_187 + c_187 + sum_188 + c_188 + sum_189 + c_189 + sum_190 + c_190 + sum_191 + c_191 + sum_192 + c_192 + 
//        sum_193 + c_193 + sum_194 + c_194 + sum_195 + c_195 + sum_196 + c_196 + sum_197 + c_197 + sum_198 + c_198 +
//        sum_199 + c_199 + sum_1c0 + c_1c0 + sum_1c1 + c_1c1 + sum_1c2 + c_1c2 + sum_1c3 + c_1c3 + sum_1c4 + c_1c4 + sum_1c5 + c_1c5 + sum_1c6 + c_1c6 + 
//        sum_1c7 + c_1c7 + sum_1c8 + c_1c8 + sum_1c9 + c_1c9 + sum_1d0 + c_1d0 + sum_1d1 + c_1d1 + sum_1d2 + c_1d2 + sum_1d3 + c_1d3 + sum_1d4 + c_1d4 + 
//        sum_1d5 + c_1d5 + sum_1d6 + c_1d6 + sum_1d7 + c_1d7 + sum_1d8 + c_1d8 + sum_1d9 + c_1d9 + sum_1e0 + c_1e0 + sum_1e1 + c_1e1 + sum_1e2 + c_1e2 + 
//        sum_1e3 + c_1e3 + sum_1e4 + c_1e4 + sum_1e5 + c_1e5 + sum_1e6 + c_1e6 + sum_1e7 + c_1e7 + sum_1e8 + c_1e8 + sum_1e9 + c_1e9 + sum_1f0 + c_1f0 + 
//        sum_1f1 + c_1f1 + sum_1f2 + c_1f2 + sum_1f3 + c_1f3 + sum_1f4 + c_1f4 + sum_1f5 + c_1f5 + sum_1f6 + c_1f6;
//
//assign test_4_stage = 
//       sum_301 + c_301 + sum_302 + c_302 + sum_303 + c_303 + sum_304 + c_304 + sum_305 + c_305 + sum_306 + c_306 + sum_307 + c_307 + sum_308 + c_308 + c_98 +
//       sum_309 + c_309 + sum_310 + c_310 + sum_311 + c_311 + sum_312 + c_312 + sum_313 + c_313 + sum_314 + c_314 + sum_315 + c_315 + sum_316 + c_316 +
//       sum_317 + c_317 + sum_318 + c_318 + sum_319 + c_319 + sum_320 + c_320 + sum_321 + c_321 + sum_322 + c_322 + sum_323 + c_323 + sum_324 + c_324 +
//       sum_400 + c_400 + sum_401 + c_401 + sum_402 + c_402 + sum_403 + c_403 + sum_404 + c_404 + sum_405 + c_405 + sum_406 + c_406 + sum_407 + c_407 + 
//       sum_408 + c_408 + sum_409 + c_409 + sum_410 + c_410 + sum_411 + c_411 + sum_412 + c_412 + sum_413 + c_413 + sum_414 + c_414 + sum_415 + c_415 + sum_425 + c_425+
//       sum_416 + c_416 + sum_417 + c_417 + sum_418 + c_418 + sum_419 + c_419 + sum_420 + c_420 + sum_421 + c_421 + sum_422 + c_422 + sum_423 + c_423 + sum_424 + c_424;
//
//assign test_5_stage = 
//       sum_331 + c_331 + sum_332 + c_332 + sum_333 + c_333 + sum_334 + c_334 + sum_335 + c_335 + sum_336 + c_336 + sum_337 + c_337 + sum_338 + c_338 +
//       sum_339 + c_339 + sum_340 + c_340 + sum_341 + c_341 + sum_342 + c_342 + sum_343 + c_343 + sum_344 + c_344 + sum_345 + c_345 + sum_346 + c_346 + sum_347 + c_347+
//       sum_430 + c_430 + sum_431 + c_431 + sum_432 + c_432 + sum_433 + c_433 + sum_434 + c_434 + sum_435 + c_435 + sum_436 + c_436 + sum_437 + c_437 +
//       sum_438 + c_438 + sum_439 + c_439 + sum_440 + c_440 + sum_441 + c_441 + sum_442 + c_442 + sum_443 + c_443 + sum_444 + c_444 + sum_445 + c_445 + sum_446 + c_446;
//
//
//assign test_6_stage = sum_359 + c_359 + sum_360 + c_360 + sum_361 + c_361 +   
//                      sum_351 + c_351 + sum_352 + c_352 + sum_353 + c_353 + sum_354 + c_354 + sum_355 + c_355 + sum_356 + c_356 + sum_357 + c_357 + sum_358 + c_358 +
//                      sum_450 + c_450 + sum_451 + c_451 + sum_452 + c_452 + sum_453 + c_453 + sum_454 + c_454 + sum_455 + c_455 + sum_456 + c_456 + sum_457 + c_457 +
//                      sum_458 + c_458 + sum_459 + c_459 + sum_45a + c_45a     +       sum_446 + c_446;
//
//assign test_7_stage = sum_371 + c_371 + sum_372 + c_372 + sum_373 + c_373 + sum_374 + c_374 + sum_375 + c_375 + sum_376 + c_376 + sum_377 + c_377 +   c_45a +
//                      sum_460 + c_460 + sum_461 + c_461 + sum_462 + c_462 + sum_463 + c_463 + sum_464 + c_464 + sum_465 + c_465 + sum_466 + c_466 + sum_467 + c_467;
//
//assign test_8_stage = sum_381 + c_381 + sum_382 + c_382 + sum_383 + c_383 + sum_384 + c_384 + sum_385 + c_385 +     c_467 +
//                      sum_470 + c_470 + sum_471 + c_471 + sum_472 + c_472 + sum_473 + c_473 + sum_474 + c_474;
//
//assign test_9_stage = sum_391 + c_391 + sum_392 + c_392 + sum_393 + c_393  +
//                      sum_480 + c_480 + sum_481 + c_481 + sum_482 + c_482 + sum_483 + c_483 ;
//
//assign test_A_stage = sum_490 + c_490 + sum_491 + c_491 + sum_492 + c_492 + sum_493 + c_493            +  sum_483 + c_483;
//assign test_preout = sum5 + cout5;
//assign test_out    = sum + cout;


 carry_save_3inputs #(W+8) cs_3in_000 (.a({  {(8){a[  0*W+W-1]}} , a[  0*W +: W] , {(8){a[(  0+1)*W+W-1]}} , a[(  0+1)*W +: W] , {(8){a[(  0+2)*W+W-1]}} , a[(  0+2)*W +: W] }), .sum(sum000), .cout(c000) );
 carry_save_3inputs #(W+8) cs_3in_003 (.a({  {(8){a[  3*W+W-1]}} , a[  3*W +: W] , {(8){a[(  3+1)*W+W-1]}} , a[(  3+1)*W +: W] , {(8){a[(  3+2)*W+W-1]}} , a[(  3+2)*W +: W] }), .sum(sum003), .cout(c003) );
 carry_save_3inputs #(W+8) cs_3in_006 (.a({  {(8){a[  6*W+W-1]}} , a[  6*W +: W] , {(8){a[(  6+1)*W+W-1]}} , a[(  6+1)*W +: W] , {(8){a[(  6+2)*W+W-1]}} , a[(  6+2)*W +: W] }), .sum(sum006), .cout(c006) );
 carry_save_3inputs #(W+8) cs_3in_009 (.a({  {(8){a[  9*W+W-1]}} , a[  9*W +: W] , {(8){a[(  9+1)*W+W-1]}} , a[(  9+1)*W +: W] , {(8){a[(  9+2)*W+W-1]}} , a[(  9+2)*W +: W] }), .sum(sum009), .cout(c009) );
 carry_save_3inputs #(W+8) cs_3in_012 (.a({  {(8){a[ 12*W+W-1]}} , a[ 12*W +: W] , {(8){a[( 12+1)*W+W-1]}} , a[( 12+1)*W +: W] , {(8){a[( 12+2)*W+W-1]}} , a[( 12+2)*W +: W] }), .sum(sum012), .cout(c012) );
 carry_save_3inputs #(W+8) cs_3in_015 (.a({  {(8){a[ 15*W+W-1]}} , a[ 15*W +: W] , {(8){a[( 15+1)*W+W-1]}} , a[( 15+1)*W +: W] , {(8){a[( 15+2)*W+W-1]}} , a[( 15+2)*W +: W] }), .sum(sum015), .cout(c015) );
 carry_save_3inputs #(W+8) cs_3in_018 (.a({  {(8){a[ 18*W+W-1]}} , a[ 18*W +: W] , {(8){a[( 18+1)*W+W-1]}} , a[( 18+1)*W +: W] , {(8){a[( 18+2)*W+W-1]}} , a[( 18+2)*W +: W] }), .sum(sum018), .cout(c018) );
 carry_save_3inputs #(W+8) cs_3in_021 (.a({  {(8){a[ 21*W+W-1]}} , a[ 21*W +: W] , {(8){a[( 21+1)*W+W-1]}} , a[( 21+1)*W +: W] , {(8){a[( 21+2)*W+W-1]}} , a[( 21+2)*W +: W] }), .sum(sum021), .cout(c021) );
 carry_save_3inputs #(W+8) cs_3in_024 (.a({  {(8){a[ 24*W+W-1]}} , a[ 24*W +: W] , {(8){a[( 24+1)*W+W-1]}} , a[( 24+1)*W +: W] , {(8){a[( 24+2)*W+W-1]}} , a[( 24+2)*W +: W] }), .sum(sum024), .cout(c024) );
 carry_save_3inputs #(W+8) cs_3in_027 (.a({  {(8){a[ 27*W+W-1]}} , a[ 27*W +: W] , {(8){a[( 27+1)*W+W-1]}} , a[( 27+1)*W +: W] , {(8){a[( 27+2)*W+W-1]}} , a[( 27+2)*W +: W] }), .sum(sum027), .cout(c027) );
 carry_save_3inputs #(W+8) cs_3in_030 (.a({  {(8){a[ 30*W+W-1]}} , a[ 30*W +: W] , {(8){a[( 30+1)*W+W-1]}} , a[( 30+1)*W +: W] , {(8){a[( 30+2)*W+W-1]}} , a[( 30+2)*W +: W] }), .sum(sum030), .cout(c030) );
 carry_save_3inputs #(W+8) cs_3in_033 (.a({  {(8){a[ 33*W+W-1]}} , a[ 33*W +: W] , {(8){a[( 33+1)*W+W-1]}} , a[( 33+1)*W +: W] , {(8){a[( 33+2)*W+W-1]}} , a[( 33+2)*W +: W] }), .sum(sum033), .cout(c033) );
 carry_save_3inputs #(W+8) cs_3in_036 (.a({  {(8){a[ 36*W+W-1]}} , a[ 36*W +: W] , {(8){a[( 36+1)*W+W-1]}} , a[( 36+1)*W +: W] , {(8){a[( 36+2)*W+W-1]}} , a[( 36+2)*W +: W] }), .sum(sum036), .cout(c036) );
 carry_save_3inputs #(W+8) cs_3in_039 (.a({  {(8){a[ 39*W+W-1]}} , a[ 39*W +: W] , {(8){a[( 39+1)*W+W-1]}} , a[( 39+1)*W +: W] , {(8){a[( 39+2)*W+W-1]}} , a[( 39+2)*W +: W] }), .sum(sum039), .cout(c039) );
 carry_save_3inputs #(W+8) cs_3in_042 (.a({  {(8){a[ 42*W+W-1]}} , a[ 42*W +: W] , {(8){a[( 42+1)*W+W-1]}} , a[( 42+1)*W +: W] , {(8){a[( 42+2)*W+W-1]}} , a[( 42+2)*W +: W] }), .sum(sum042), .cout(c042) );
 carry_save_3inputs #(W+8) cs_3in_045 (.a({  {(8){a[ 45*W+W-1]}} , a[ 45*W +: W] , {(8){a[( 45+1)*W+W-1]}} , a[( 45+1)*W +: W] , {(8){a[( 45+2)*W+W-1]}} , a[( 45+2)*W +: W] }), .sum(sum045), .cout(c045) );
 carry_save_3inputs #(W+8) cs_3in_048 (.a({  {(8){a[ 48*W+W-1]}} , a[ 48*W +: W] , {(8){a[( 48+1)*W+W-1]}} , a[( 48+1)*W +: W] , {(8){a[( 48+2)*W+W-1]}} , a[( 48+2)*W +: W] }), .sum(sum048), .cout(c048) );
 carry_save_3inputs #(W+8) cs_3in_051 (.a({  {(8){a[ 51*W+W-1]}} , a[ 51*W +: W] , {(8){a[( 51+1)*W+W-1]}} , a[( 51+1)*W +: W] , {(8){a[( 51+2)*W+W-1]}} , a[( 51+2)*W +: W] }), .sum(sum051), .cout(c051) );
 carry_save_3inputs #(W+8) cs_3in_054 (.a({  {(8){a[ 54*W+W-1]}} , a[ 54*W +: W] , {(8){a[( 54+1)*W+W-1]}} , a[( 54+1)*W +: W] , {(8){a[( 54+2)*W+W-1]}} , a[( 54+2)*W +: W] }), .sum(sum054), .cout(c054) );
 carry_save_3inputs #(W+8) cs_3in_057 (.a({  {(8){a[ 57*W+W-1]}} , a[ 57*W +: W] , {(8){a[( 57+1)*W+W-1]}} , a[( 57+1)*W +: W] , {(8){a[( 57+2)*W+W-1]}} , a[( 57+2)*W +: W] }), .sum(sum057), .cout(c057) );
 carry_save_3inputs #(W+8) cs_3in_060 (.a({  {(8){a[ 60*W+W-1]}} , a[ 60*W +: W] , {(8){a[( 60+1)*W+W-1]}} , a[( 60+1)*W +: W] , {(8){a[( 60+2)*W+W-1]}} , a[( 60+2)*W +: W] }), .sum(sum060), .cout(c060) );
 carry_save_3inputs #(W+8) cs_3in_063 (.a({  {(8){a[ 63*W+W-1]}} , a[ 63*W +: W] , {(8){a[( 63+1)*W+W-1]}} , a[( 63+1)*W +: W] , {(8){a[( 63+2)*W+W-1]}} , a[( 63+2)*W +: W] }), .sum(sum063), .cout(c063) );
 carry_save_3inputs #(W+8) cs_3in_066 (.a({  {(8){a[ 66*W+W-1]}} , a[ 66*W +: W] , {(8){a[( 66+1)*W+W-1]}} , a[( 66+1)*W +: W] , {(8){a[( 66+2)*W+W-1]}} , a[( 66+2)*W +: W] }), .sum(sum066), .cout(c066) );
 carry_save_3inputs #(W+8) cs_3in_069 (.a({  {(8){a[ 69*W+W-1]}} , a[ 69*W +: W] , {(8){a[( 69+1)*W+W-1]}} , a[( 69+1)*W +: W] , {(8){a[( 69+2)*W+W-1]}} , a[( 69+2)*W +: W] }), .sum(sum069), .cout(c069) );
 carry_save_3inputs #(W+8) cs_3in_072 (.a({  {(8){a[ 72*W+W-1]}} , a[ 72*W +: W] , {(8){a[( 72+1)*W+W-1]}} , a[( 72+1)*W +: W] , {(8){a[( 72+2)*W+W-1]}} , a[( 72+2)*W +: W] }), .sum(sum072), .cout(c072) );
 carry_save_3inputs #(W+8) cs_3in_075 (.a({  {(8){a[ 75*W+W-1]}} , a[ 75*W +: W] , {(8){a[( 75+1)*W+W-1]}} , a[( 75+1)*W +: W] , {(8){a[( 75+2)*W+W-1]}} , a[( 75+2)*W +: W] }), .sum(sum075), .cout(c075) );
 carry_save_3inputs #(W+8) cs_3in_078 (.a({  {(8){a[ 78*W+W-1]}} , a[ 78*W +: W] , {(8){a[( 78+1)*W+W-1]}} , a[( 78+1)*W +: W] , {(8){a[( 78+2)*W+W-1]}} , a[( 78+2)*W +: W] }), .sum(sum078), .cout(c078) );
 carry_save_3inputs #(W+8) cs_3in_081 (.a({  {(8){a[ 81*W+W-1]}} , a[ 81*W +: W] , {(8){a[( 81+1)*W+W-1]}} , a[( 81+1)*W +: W] , {(8){a[( 81+2)*W+W-1]}} , a[( 81+2)*W +: W] }), .sum(sum081), .cout(c081) );
 carry_save_3inputs #(W+8) cs_3in_084 (.a({  {(8){a[ 84*W+W-1]}} , a[ 84*W +: W] , {(8){a[( 84+1)*W+W-1]}} , a[( 84+1)*W +: W] , {(8){a[( 84+2)*W+W-1]}} , a[( 84+2)*W +: W] }), .sum(sum084), .cout(c084) );
 carry_save_3inputs #(W+8) cs_3in_087 (.a({  {(8){a[ 87*W+W-1]}} , a[ 87*W +: W] , {(8){a[( 87+1)*W+W-1]}} , a[( 87+1)*W +: W] , {(8){a[( 87+2)*W+W-1]}} , a[( 87+2)*W +: W] }), .sum(sum087), .cout(c087) );
 carry_save_3inputs #(W+8) cs_3in_090 (.a({  {(8){a[ 90*W+W-1]}} , a[ 90*W +: W] , {(8){a[( 90+1)*W+W-1]}} , a[( 90+1)*W +: W] , {(8){a[( 90+2)*W+W-1]}} , a[( 90+2)*W +: W] }), .sum(sum090), .cout(c090) );
 carry_save_3inputs #(W+8) cs_3in_093 (.a({  {(8){a[ 93*W+W-1]}} , a[ 93*W +: W] , {(8){a[( 93+1)*W+W-1]}} , a[( 93+1)*W +: W] , {(8){a[( 93+2)*W+W-1]}} , a[( 93+2)*W +: W] }), .sum(sum093), .cout(c093) );
 carry_save_3inputs #(W+8) cs_3in_096 (.a({  {(8){a[ 96*W+W-1]}} , a[ 96*W +: W] , {(8){a[( 96+1)*W+W-1]}} , a[( 96+1)*W +: W] , {(8){a[( 96+2)*W+W-1]}} , a[( 96+2)*W +: W] }), .sum(sum096), .cout(c096) );
 carry_save_3inputs #(W+8) cs_3in_099 (.a({  {(8){a[ 99*W+W-1]}} , a[ 99*W +: W] , {(8){a[( 99+1)*W+W-1]}} , a[( 99+1)*W +: W] , {(8){a[( 99+2)*W+W-1]}} , a[( 99+2)*W +: W] }), .sum(sum099), .cout(c099) );
 carry_save_3inputs #(W+8) cs_3in_102 (.a({  {(8){a[102*W+W-1]}} , a[102*W +: W] , {(8){a[(102+1)*W+W-1]}} , a[(102+1)*W +: W] , {(8){a[(102+2)*W+W-1]}} , a[(102+2)*W +: W] }), .sum(sum102), .cout(c102) );
 carry_save_3inputs #(W+8) cs_3in_105 (.a({  {(8){a[105*W+W-1]}} , a[105*W +: W] , {(8){a[(105+1)*W+W-1]}} , a[(105+1)*W +: W] , {(8){a[(105+2)*W+W-1]}} , a[(105+2)*W +: W] }), .sum(sum105), .cout(c105) );
 carry_save_3inputs #(W+8) cs_3in_108 (.a({  {(8){a[108*W+W-1]}} , a[108*W +: W] , {(8){a[(108+1)*W+W-1]}} , a[(108+1)*W +: W] , {(8){a[(108+2)*W+W-1]}} , a[(108+2)*W +: W] }), .sum(sum108), .cout(c108) );
 carry_save_3inputs #(W+8) cs_3in_111 (.a({  {(8){a[111*W+W-1]}} , a[111*W +: W] , {(8){a[(111+1)*W+W-1]}} , a[(111+1)*W +: W] , {(8){a[(111+2)*W+W-1]}} , a[(111+2)*W +: W] }), .sum(sum111), .cout(c111) );
 carry_save_3inputs #(W+8) cs_3in_114 (.a({  {(8){a[114*W+W-1]}} , a[114*W +: W] , {(8){a[(114+1)*W+W-1]}} , a[(114+1)*W +: W] , {(8){a[(114+2)*W+W-1]}} , a[(114+2)*W +: W] }), .sum(sum114), .cout(c114) );
 carry_save_3inputs #(W+8) cs_3in_117 (.a({  {(8){a[117*W+W-1]}} , a[117*W +: W] , {(8){a[(117+1)*W+W-1]}} , a[(117+1)*W +: W] , {(8){a[(117+2)*W+W-1]}} , a[(117+2)*W +: W] }), .sum(sum117), .cout(c117) );
 carry_save_3inputs #(W+8) cs_3in_120 (.a({  {(8){a[120*W+W-1]}} , a[120*W +: W] , {(8){a[(120+1)*W+W-1]}} , a[(120+1)*W +: W] , {(8){a[(120+2)*W+W-1]}} , a[(120+2)*W +: W] }), .sum(sum120), .cout(c120) );
 carry_save_3inputs #(W+8) cs_3in_123 (.a({  {(8){a[123*W+W-1]}} , a[123*W +: W] , {(8){a[(123+1)*W+W-1]}} , a[(123+1)*W +: W] , {(8){a[(123+2)*W+W-1]}} , a[(123+2)*W +: W] }), .sum(sum123), .cout(c123) ); 
 carry_save_3inputs #(W+8) cs_3in_126 (.a({  {(8){a[126*W+W-1]}} , a[126*W +: W] , {(8){a[(126+1)*W+W-1]}} , a[(126+1)*W +: W] , {(8){a[(126+2)*W+W-1]}} , a[(126+2)*W +: W] }), .sum(sum126), .cout(c126) );
 carry_save_3inputs #(W+8) cs_3in_129 (.a({  {(8){a[129*W+W-1]}} , a[129*W +: W] , {(8){a[(129+1)*W+W-1]}} , a[(129+1)*W +: W] , {(8){a[(129+2)*W+W-1]}} , a[(129+2)*W +: W] }), .sum(sum129), .cout(c129) );
 carry_save_3inputs #(W+8) cs_3in_132 (.a({  {(8){a[132*W+W-1]}} , a[132*W +: W] , {(8){a[(132+1)*W+W-1]}} , a[(132+1)*W +: W] , {(8){a[(132+2)*W+W-1]}} , a[(132+2)*W +: W] }), .sum(sum132), .cout(c132) );
 carry_save_3inputs #(W+8) cs_3in_135 (.a({  {(8){a[135*W+W-1]}} , a[135*W +: W] , {(8){a[(135+1)*W+W-1]}} , a[(135+1)*W +: W] , {(8){a[(135+2)*W+W-1]}} , a[(135+2)*W +: W] }), .sum(sum135), .cout(c135) );
 carry_save_3inputs #(W+8) cs_3in_138 (.a({  {(8){a[138*W+W-1]}} , a[138*W +: W] , {(8){a[(138+1)*W+W-1]}} , a[(138+1)*W +: W] , {(8){a[(138+2)*W+W-1]}} , a[(138+2)*W +: W] }), .sum(sum138), .cout(c138) );
 carry_save_3inputs #(W+8) cs_3in_141 (.a({  {(8){a[141*W+W-1]}} , a[141*W +: W] , {(8){a[(141+1)*W+W-1]}} , a[(141+1)*W +: W] , {(8){a[(141+2)*W+W-1]}} , a[(141+2)*W +: W] }), .sum(sum141), .cout(c141) );
 carry_save_3inputs #(W+8) cs_3in_144 (.a({  {(8){a[144*W+W-1]}} , a[144*W +: W] , {(8){a[(144+1)*W+W-1]}} , a[(144+1)*W +: W] , {(8){a[(144+2)*W+W-1]}} , a[(144+2)*W +: W] }), .sum(sum144), .cout(c144) );
 carry_save_3inputs #(W+8) cs_3in_147 (.a({  {(8){a[147*W+W-1]}} , a[147*W +: W] , {(8){a[(147+1)*W+W-1]}} , a[(147+1)*W +: W] , {(8){a[(147+2)*W+W-1]}} , a[(147+2)*W +: W] }), .sum(sum147), .cout(c147) );
 carry_save_3inputs #(W+8) cs_3in_150 (.a({  {(8){a[150*W+W-1]}} , a[150*W +: W] , {(8){a[(150+1)*W+W-1]}} , a[(150+1)*W +: W] , {(8){a[(150+2)*W+W-1]}} , a[(150+2)*W +: W] }), .sum(sum150), .cout(c150) );
 carry_save_3inputs #(W+8) cs_3in_153 (.a({  {(8){a[153*W+W-1]}} , a[153*W +: W] , {(8){a[(153+1)*W+W-1]}} , a[(153+1)*W +: W] , {(8){a[(153+2)*W+W-1]}} , a[(153+2)*W +: W] }), .sum(sum153), .cout(c153) );
 carry_save_3inputs #(W+8) cs_3in_156 (.a({  {(8){a[156*W+W-1]}} , a[156*W +: W] , {(8){a[(156+1)*W+W-1]}} , a[(156+1)*W +: W] , {(8){a[(156+2)*W+W-1]}} , a[(156+2)*W +: W] }), .sum(sum156), .cout(c156) );
 carry_save_3inputs #(W+8) cs_3in_159 (.a({  {(8){a[159*W+W-1]}} , a[159*W +: W] , {(8){a[(159+1)*W+W-1]}} , a[(159+1)*W +: W] , {(8){a[(159+2)*W+W-1]}} , a[(159+2)*W +: W] }), .sum(sum159), .cout(c159) );
 carry_save_3inputs #(W+8) cs_3in_162 (.a({  {(8){a[162*W+W-1]}} , a[162*W +: W] , {(8){a[(162+1)*W+W-1]}} , a[(162+1)*W +: W] , {(8){a[(162+2)*W+W-1]}} , a[(162+2)*W +: W] }), .sum(sum162), .cout(c162) );
 carry_save_3inputs #(W+8) cs_3in_165 (.a({  {(8){a[165*W+W-1]}} , a[165*W +: W] , {(8){a[(165+1)*W+W-1]}} , a[(165+1)*W +: W] , {(8){a[(165+2)*W+W-1]}} , a[(165+2)*W +: W] }), .sum(sum165), .cout(c165) );
 carry_save_3inputs #(W+8) cs_3in_168 (.a({  {(8){a[168*W+W-1]}} , a[168*W +: W] , {(8){a[(168+1)*W+W-1]}} , a[(168+1)*W +: W] , {(8){a[(168+2)*W+W-1]}} , a[(168+2)*W +: W] }), .sum(sum168), .cout(c168) );
 carry_save_3inputs #(W+8) cs_3in_171 (.a({  {(8){a[171*W+W-1]}} , a[171*W +: W] , {(8){a[(171+1)*W+W-1]}} , a[(171+1)*W +: W] , {(8){a[(171+2)*W+W-1]}} , a[(171+2)*W +: W] }), .sum(sum171), .cout(c171) );
 carry_save_3inputs #(W+8) cs_3in_174 (.a({  {(8){a[174*W+W-1]}} , a[174*W +: W] , {(8){a[(174+1)*W+W-1]}} , a[(174+1)*W +: W] , {(8){a[(174+2)*W+W-1]}} , a[(174+2)*W +: W] }), .sum(sum174), .cout(c174) );
 carry_save_3inputs #(W+8) cs_3in_177 (.a({  {(8){a[177*W+W-1]}} , a[177*W +: W] , {(8){a[(177+1)*W+W-1]}} , a[(177+1)*W +: W] , {(8){a[(177+2)*W+W-1]}} , a[(177+2)*W +: W] }), .sum(sum177), .cout(c177) );
 carry_save_3inputs #(W+8) cs_3in_180 (.a({  {(8){a[180*W+W-1]}} , a[180*W +: W] , {(8){a[(180+1)*W+W-1]}} , a[(180+1)*W +: W] , {(8){a[(180+2)*W+W-1]}} , a[(180+2)*W +: W] }), .sum(sum180), .cout(c180) );
 carry_save_3inputs #(W+8) cs_3in_183 (.a({  {(8){a[183*W+W-1]}} , a[183*W +: W] , {(8){a[(183+1)*W+W-1]}} , a[(183+1)*W +: W] , {(8){a[(183+2)*W+W-1]}} , a[(183+2)*W +: W] }), .sum(sum183), .cout(c183) );
 carry_save_3inputs #(W+8) cs_3in_186 (.a({  {(8){a[186*W+W-1]}} , a[186*W +: W] , {(8){a[(186+1)*W+W-1]}} , a[(186+1)*W +: W] , {(8){a[(186+2)*W+W-1]}} , a[(186+2)*W +: W] }), .sum(sum186), .cout(c186) );
 carry_save_3inputs #(W+8) cs_3in_189 (.a({  {(8){a[189*W+W-1]}} , a[189*W +: W] , {(8){a[(189+1)*W+W-1]}} , a[(189+1)*W +: W] , {(8){a[(189+2)*W+W-1]}} , a[(189+2)*W +: W] }), .sum(sum189), .cout(c189) );
 carry_save_3inputs #(W+8) cs_3in_192 (.a({  {(8){a[192*W+W-1]}} , a[192*W +: W] , {(8){a[(192+1)*W+W-1]}} , a[(192+1)*W +: W] , {(8){a[(192+2)*W+W-1]}} , a[(192+2)*W +: W] }), .sum(sum192), .cout(c192) );
 carry_save_3inputs #(W+8) cs_3in_195 (.a({  {(8){a[195*W+W-1]}} , a[195*W +: W] , {(8){a[(195+1)*W+W-1]}} , a[(195+1)*W +: W] , {(8){a[(195+2)*W+W-1]}} , a[(195+2)*W +: W] }), .sum(sum195), .cout(c195) );
 carry_save_3inputs #(W+8) cs_3in_198 (.a({  {(8){a[198*W+W-1]}} , a[198*W +: W] , {(8){a[(198+1)*W+W-1]}} , a[(198+1)*W +: W] , {(8){a[(198+2)*W+W-1]}} , a[(198+2)*W +: W] }), .sum(sum198), .cout(c198) );
 carry_save_3inputs #(W+8) cs_3in_201 (.a({  {(8){a[201*W+W-1]}} , a[201*W +: W] , {(8){a[(201+1)*W+W-1]}} , a[(201+1)*W +: W] , {(8){a[(201+2)*W+W-1]}} , a[(201+2)*W +: W] }), .sum(sum201), .cout(c201) );
 carry_save_3inputs #(W+8) cs_3in_204 (.a({  {(8){a[204*W+W-1]}} , a[204*W +: W] , {(8){a[(204+1)*W+W-1]}} , a[(204+1)*W +: W] , {(8){a[(204+2)*W+W-1]}} , a[(204+2)*W +: W] }), .sum(sum204), .cout(c204) );
 carry_save_3inputs #(W+8) cs_3in_207 (.a({  {(8){a[207*W+W-1]}} , a[207*W +: W] , {(8){a[(207+1)*W+W-1]}} , a[(207+1)*W +: W] , {(8){a[(207+2)*W+W-1]}} , a[(207+2)*W +: W] }), .sum(sum207), .cout(c207) );
 carry_save_3inputs #(W+8) cs_3in_210 (.a({  {(8){a[210*W+W-1]}} , a[210*W +: W] , {(8){a[(210+1)*W+W-1]}} , a[(210+1)*W +: W] , {(8){a[(210+2)*W+W-1]}} , a[(210+2)*W +: W] }), .sum(sum210), .cout(c210) );
 carry_save_3inputs #(W+8) cs_3in_213 (.a({  {(8){a[213*W+W-1]}} , a[213*W +: W] , {(8){a[(213+1)*W+W-1]}} , a[(213+1)*W +: W] , {(8){a[(213+2)*W+W-1]}} , a[(213+2)*W +: W] }), .sum(sum213), .cout(c213) );
 carry_save_3inputs #(W+8) cs_3in_216 (.a({  {(8){a[216*W+W-1]}} , a[216*W +: W] , {(8){a[(216+1)*W+W-1]}} , a[(216+1)*W +: W] , {(8){a[(216+2)*W+W-1]}} , a[(216+2)*W +: W] }), .sum(sum216), .cout(c216) );
 carry_save_3inputs #(W+8) cs_3in_219 (.a({  {(8){a[219*W+W-1]}} , a[219*W +: W] , {(8){a[(219+1)*W+W-1]}} , a[(219+1)*W +: W] , {(8){a[(219+2)*W+W-1]}} , a[(219+2)*W +: W] }), .sum(sum219), .cout(c219) );
 carry_save_3inputs #(W+8) cs_3in_222 (.a({  {(8){a[222*W+W-1]}} , a[222*W +: W] , {(8){a[(222+1)*W+W-1]}} , a[(222+1)*W +: W] , {(8){a[(222+2)*W+W-1]}} , a[(222+2)*W +: W] }), .sum(sum222), .cout(c222) );
 carry_save_3inputs #(W+8) cs_3in_225 (.a({  {(8){a[225*W+W-1]}} , a[225*W +: W] , {(8){a[(225+1)*W+W-1]}} , a[(225+1)*W +: W] , {(8){a[(225+2)*W+W-1]}} , a[(225+2)*W +: W] }), .sum(sum225), .cout(c225) );
 carry_save_3inputs #(W+8) cs_3in_228 (.a({  {(8){a[228*W+W-1]}} , a[228*W +: W] , {(8){a[(228+1)*W+W-1]}} , a[(228+1)*W +: W] , {(8){a[(228+2)*W+W-1]}} , a[(228+2)*W +: W] }), .sum(sum228), .cout(c228) );
 carry_save_3inputs #(W+8) cs_3in_231 (.a({  {(8){a[231*W+W-1]}} , a[231*W +: W] , {(8){a[(231+1)*W+W-1]}} , a[(231+1)*W +: W] , {(8){a[(231+2)*W+W-1]}} , a[(231+2)*W +: W] }), .sum(sum231), .cout(c231) );
 carry_save_3inputs #(W+8) cs_3in_234 (.a({  {(8){a[234*W+W-1]}} , a[234*W +: W] , {(8){a[(234+1)*W+W-1]}} , a[(234+1)*W +: W] , {(8){a[(234+2)*W+W-1]}} , a[(234+2)*W +: W] }), .sum(sum234), .cout(c234) );
 carry_save_3inputs #(W+8) cs_3in_237 (.a({  {(8){a[237*W+W-1]}} , a[237*W +: W] , {(8){a[(237+1)*W+W-1]}} , a[(237+1)*W +: W] , {(8){a[(237+2)*W+W-1]}} , a[(237+2)*W +: W] }), .sum(sum237), .cout(c237) );
 carry_save_3inputs #(W+8) cs_3in_240 (.a({  {(8){a[240*W+W-1]}} , a[240*W +: W] , {(8){a[(240+1)*W+W-1]}} , a[(240+1)*W +: W] , {(8){a[(240+2)*W+W-1]}} , a[(240+2)*W +: W] }), .sum(sum240), .cout(c240) );
 carry_save_3inputs #(W+8) cs_3in_243 (.a({  {(8){a[243*W+W-1]}} , a[243*W +: W] , {(8){a[(243+1)*W+W-1]}} , a[(243+1)*W +: W] , {(8){a[(243+2)*W+W-1]}} , a[(243+2)*W +: W] }), .sum(sum243), .cout(c243) );
 carry_save_3inputs #(W+8) cs_3in_246 (.a({  {(8){a[246*W+W-1]}} , a[246*W +: W] , {(8){a[(246+1)*W+W-1]}} , a[(246+1)*W +: W] , {(8){a[(246+2)*W+W-1]}} , a[(246+2)*W +: W] }), .sum(sum246), .cout(c246) );
 carry_save_3inputs #(W+8) cs_3in_249 (.a({  {(8){a[249*W+W-1]}} , a[249*W +: W] , {(8){a[(249+1)*W+W-1]}} , a[(249+1)*W +: W] , {(8){a[(249+2)*W+W-1]}} , a[(249+2)*W +: W] }), .sum(sum249), .cout(c249) );
 carry_save_3inputs #(W+8) cs_3in_252 (.a({  {(8){a[252*W+W-1]}} , a[252*W +: W] , {(8){a[(252+1)*W+W-1]}} , a[(252+1)*W +: W] , {(8){a[(252+2)*W+W-1]}} , a[(252+2)*W +: W] }), .sum(sum252), .cout(c252) );
 carry_save_3inputs #(W+8) cs_3in_255 (.a({  {(8){a[255*W+W-1]}} , a[255*W +: W] , {(8){a[(255+1)*W+W-1]}} , a[(255+1)*W +: W] , {(8){a[(255+2)*W+W-1]}} , a[(255+2)*W +: W] }), .sum(sum255), .cout(c255) );
 carry_save_3inputs #(W+8) cs_3in_258 (.a({  {(8){a[258*W+W-1]}} , a[258*W +: W] , {(8){a[(258+1)*W+W-1]}} , a[(258+1)*W +: W] , {(8){a[(258+2)*W+W-1]}} , a[(258+2)*W +: W] }), .sum(sum258), .cout(c258) );
 carry_save_3inputs #(W+8) cs_3in_261 (.a({  {(8){a[261*W+W-1]}} , a[261*W +: W] , {(8){a[(261+1)*W+W-1]}} , a[(261+1)*W +: W] , {(8){a[(261+2)*W+W-1]}} , a[(261+2)*W +: W] }), .sum(sum261), .cout(c261) );
 carry_save_3inputs #(W+8) cs_3in_264 (.a({  {(8){a[264*W+W-1]}} , a[264*W +: W] , {(8){a[(264+1)*W+W-1]}} , a[(264+1)*W +: W] , {(8){a[(264+2)*W+W-1]}} , a[(264+2)*W +: W] }), .sum(sum264), .cout(c264) );
 carry_save_3inputs #(W+8) cs_3in_267 (.a({  {(8){a[267*W+W-1]}} , a[267*W +: W] , {(8){a[(267+1)*W+W-1]}} , a[(267+1)*W +: W] , {(8){a[(267+2)*W+W-1]}} , a[(267+2)*W +: W] }), .sum(sum267), .cout(c267) );
 carry_save_3inputs #(W+8) cs_3in_270 (.a({  {(8){a[270*W+W-1]}} , a[270*W +: W] , {(8){a[(270+1)*W+W-1]}} , a[(270+1)*W +: W] , {(8){a[(270+2)*W+W-1]}} , a[(270+2)*W +: W] }), .sum(sum270), .cout(c270) );
 carry_save_3inputs #(W+8) cs_3in_273 (.a({  {(8){a[273*W+W-1]}} , a[273*W +: W] , {(8){a[(273+1)*W+W-1]}} , a[(273+1)*W +: W] , {(8){a[(273+2)*W+W-1]}} , a[(273+2)*W +: W] }), .sum(sum273), .cout(c273) );
 carry_save_3inputs #(W+8) cs_3in_276 (.a({  {(8){a[276*W+W-1]}} , a[276*W +: W] , {(8){a[(276+1)*W+W-1]}} , a[(276+1)*W +: W] , {(8){a[(276+2)*W+W-1]}} , a[(276+2)*W +: W] }), .sum(sum276), .cout(c276) );
 carry_save_3inputs #(W+8) cs_3in_279 (.a({  {(8){a[279*W+W-1]}} , a[279*W +: W] , {(8){a[(279+1)*W+W-1]}} , a[(279+1)*W +: W] , {(8){a[(279+2)*W+W-1]}} , a[(279+2)*W +: W] }), .sum(sum279), .cout(c279) );
 carry_save_3inputs #(W+8) cs_3in_282 (.a({  {(8){a[282*W+W-1]}} , a[282*W +: W] , {(8){a[(282+1)*W+W-1]}} , a[(282+1)*W +: W] , {(8){a[(282+2)*W+W-1]}} , a[(282+2)*W +: W] }), .sum(sum282), .cout(c282) );
 carry_save_3inputs #(W+8) cs_3in_285 (.a({  {(8){a[285*W+W-1]}} , a[285*W +: W] , {(8){a[(285+1)*W+W-1]}} , a[(285+1)*W +: W] , {(8){a[(285+2)*W+W-1]}} , a[(285+2)*W +: W] }), .sum(sum285), .cout(c285) );
 carry_save_3inputs #(W+8) cs_3in_288 (.a({  {(8){a[288*W+W-1]}} , a[288*W +: W] , {(8){a[(288+1)*W+W-1]}} , a[(288+1)*W +: W] , {(8){a[(288+2)*W+W-1]}} , a[(288+2)*W +: W] }), .sum(sum288), .cout(c288) );
 carry_save_3inputs #(W+8) cs_3in_291 (.a({  {(8){a[291*W+W-1]}} , a[291*W +: W] , {(8){a[(291+1)*W+W-1]}} , a[(291+1)*W +: W] , {(8){a[(291+2)*W+W-1]}} , a[(291+2)*W +: W] }), .sum(sum291), .cout(c291) );
 carry_save_3inputs #(W+8) cs_3in_294 (.a({  {(8){a[294*W+W-1]}} , a[294*W +: W] , {(8){a[(294+1)*W+W-1]}} , a[(294+1)*W +: W] , {(8){a[(294+2)*W+W-1]}} , a[(294+2)*W +: W] }), .sum(sum294), .cout(c294) );
 carry_save_3inputs #(W+8) cs_3in_297 (.a({  {(8){a[297*W+W-1]}} , a[297*W +: W] , {(8){a[(297+1)*W+W-1]}} , a[(297+1)*W +: W] , {(8){a[(297+2)*W+W-1]}} , a[(297+2)*W +: W] }), .sum(sum297), .cout(c297) );
 carry_save_3inputs #(W+8) cs_3in_300 (.a({  {(8){a[300*W+W-1]}} , a[300*W +: W] , {(8){a[(300+1)*W+W-1]}} , a[(300+1)*W +: W] , {(8){a[(300+2)*W+W-1]}} , a[(300+2)*W +: W] }), .sum(sum300), .cout(c300) );
 carry_save_3inputs #(W+8) cs_3in_303 (.a({  {(8){a[303*W+W-1]}} , a[303*W +: W] , {(8){a[(303+1)*W+W-1]}} , a[(303+1)*W +: W] , {(8){a[(303+2)*W+W-1]}} , a[(303+2)*W +: W] }), .sum(sum303), .cout(c303) );
 carry_save_3inputs #(W+8) cs_3in_306 (.a({  {(8){a[306*W+W-1]}} , a[306*W +: W] , {(8){a[(306+1)*W+W-1]}} , a[(306+1)*W +: W] , {(8){a[(306+2)*W+W-1]}} , a[(306+2)*W +: W] }), .sum(sum306), .cout(c306) );
 carry_save_3inputs #(W+8) cs_3in_309 (.a({  {(8){a[309*W+W-1]}} , a[309*W +: W] , {(8){a[(309+1)*W+W-1]}} , a[(309+1)*W +: W] , {(8){a[(309+2)*W+W-1]}} , a[(309+2)*W +: W] }), .sum(sum309), .cout(c309) );
 carry_save_3inputs #(W+8) cs_3in_312 (.a({  {(8){a[312*W+W-1]}} , a[312*W +: W] , {(8){a[(312+1)*W+W-1]}} , a[(312+1)*W +: W] , {(8){a[(312+2)*W+W-1]}} , a[(312+2)*W +: W] }), .sum(sum312), .cout(c312) );
 carry_save_3inputs #(W+8) cs_3in_315 (.a({  {(8){a[315*W+W-1]}} , a[315*W +: W] , {(8){a[(315+1)*W+W-1]}} , a[(315+1)*W +: W] , {(8){a[(315+2)*W+W-1]}} , a[(315+2)*W +: W] }), .sum(sum315), .cout(c315) );
 carry_save_3inputs #(W+8) cs_3in_318 (.a({  {(8){a[318*W+W-1]}} , a[318*W +: W] , {(8){a[(318+1)*W+W-1]}} , a[(318+1)*W +: W] , {(8){a[(318+2)*W+W-1]}} , a[(318+2)*W +: W] }), .sum(sum318), .cout(c318) );
 carry_save_3inputs #(W+8) cs_3in_321 (.a({  {(8){a[321*W+W-1]}} , a[321*W +: W] , {(8){a[(321+1)*W+W-1]}} , a[(321+1)*W +: W] , {(8){a[(321+2)*W+W-1]}} , a[(321+2)*W +: W] }), .sum(sum321), .cout(c321) );
 carry_save_3inputs #(W+8) cs_3in_324 (.a({  {(8){a[324*W+W-1]}} , a[324*W +: W] , {(8){a[(324+1)*W+W-1]}} , a[(324+1)*W +: W] , {(8){a[(324+2)*W+W-1]}} , a[(324+2)*W +: W] }), .sum(sum324), .cout(c324) );
 carry_save_3inputs #(W+8) cs_3in_327 (.a({  {(8){a[327*W+W-1]}} , a[327*W +: W] , {(8){a[(327+1)*W+W-1]}} , a[(327+1)*W +: W] , {(8){a[(327+2)*W+W-1]}} , a[(327+2)*W +: W] }), .sum(sum327), .cout(c327) );
 carry_save_3inputs #(W+8) cs_3in_330 (.a({  {(8){a[330*W+W-1]}} , a[330*W +: W] , {(8){a[(330+1)*W+W-1]}} , a[(330+1)*W +: W] , {(8){a[(330+2)*W+W-1]}} , a[(330+2)*W +: W] }), .sum(sum330), .cout(c330) );
 carry_save_3inputs #(W+8) cs_3in_333 (.a({  {(8){a[333*W+W-1]}} , a[333*W +: W] , {(8){a[(333+1)*W+W-1]}} , a[(333+1)*W +: W] , {(8){a[(333+2)*W+W-1]}} , a[(333+2)*W +: W] }), .sum(sum333), .cout(c333) );
 carry_save_3inputs #(W+8) cs_3in_336 (.a({  {(8){a[336*W+W-1]}} , a[336*W +: W] , {(8){a[(336+1)*W+W-1]}} , a[(336+1)*W +: W] , {(8){a[(336+2)*W+W-1]}} , a[(336+2)*W +: W] }), .sum(sum336), .cout(c336) );
 carry_save_3inputs #(W+8) cs_3in_339 (.a({  {(8){a[339*W+W-1]}} , a[339*W +: W] , {(8){a[(339+1)*W+W-1]}} , a[(339+1)*W +: W] , {(8){a[(339+2)*W+W-1]}} , a[(339+2)*W +: W] }), .sum(sum339), .cout(c339) );
 carry_save_3inputs #(W+8) cs_3in_342 (.a({  {(8){a[342*W+W-1]}} , a[342*W +: W] , {(8){a[(342+1)*W+W-1]}} , a[(342+1)*W +: W] , {(8){a[(342+2)*W+W-1]}} , a[(342+2)*W +: W] }), .sum(sum342), .cout(c342) );
 carry_save_3inputs #(W+8) cs_3in_345 (.a({  {(8){a[345*W+W-1]}} , a[345*W +: W] , {(8){a[(345+1)*W+W-1]}} , a[(345+1)*W +: W] , {(8){a[(345+2)*W+W-1]}} , a[(345+2)*W +: W] }), .sum(sum345), .cout(c345) );
 carry_save_3inputs #(W+8) cs_3in_348 (.a({  {(8){a[348*W+W-1]}} , a[348*W +: W] , {(8){a[(348+1)*W+W-1]}} , a[(348+1)*W +: W] , {(8){a[(348+2)*W+W-1]}} , a[(348+2)*W +: W] }), .sum(sum348), .cout(c348) );
 carry_save_3inputs #(W+8) cs_3in_351 (.a({  {(8){a[351*W+W-1]}} , a[351*W +: W] , {(8){a[(351+1)*W+W-1]}} , a[(351+1)*W +: W] , {(8){a[(351+2)*W+W-1]}} , a[(351+2)*W +: W] }), .sum(sum351), .cout(c351) );
 carry_save_3inputs #(W+8) cs_3in_354 (.a({  {(8){a[354*W+W-1]}} , a[354*W +: W] , {(8){a[(354+1)*W+W-1]}} , a[(354+1)*W +: W] , {(8){a[(354+2)*W+W-1]}} , a[(354+2)*W +: W] }), .sum(sum354), .cout(c354) );
 carry_save_3inputs #(W+8) cs_3in_357 (.a({  {(8){a[357*W+W-1]}} , a[357*W +: W] , {(8){a[(357+1)*W+W-1]}} , a[(357+1)*W +: W] , {(8){a[(357+2)*W+W-1]}} , a[(357+2)*W +: W] }), .sum(sum357), .cout(c357) );
 carry_save_3inputs #(W+8) cs_3in_360 (.a({  {(8){a[360*W+W-1]}} , a[360*W +: W] , {(8){a[(360+1)*W+W-1]}} , a[(360+1)*W +: W] , {(8){a[(360+2)*W+W-1]}} , a[(360+2)*W +: W] }), .sum(sum360), .cout(c360) );
 carry_save_3inputs #(W+8) cs_3in_363 (.a({  {(8){a[363*W+W-1]}} , a[363*W +: W] , {(8){a[(363+1)*W+W-1]}} , a[(363+1)*W +: W] , {(8){a[(363+2)*W+W-1]}} , a[(363+2)*W +: W] }), .sum(sum363), .cout(c363) );
 carry_save_3inputs #(W+8) cs_3in_366 (.a({  {(8){a[366*W+W-1]}} , a[366*W +: W] , {(8){a[(366+1)*W+W-1]}} , a[(366+1)*W +: W] , {(8){a[(366+2)*W+W-1]}} , a[(366+2)*W +: W] }), .sum(sum366), .cout(c366) );
 carry_save_3inputs #(W+8) cs_3in_369 (.a({  {(8){a[369*W+W-1]}} , a[369*W +: W] , {(8){a[(369+1)*W+W-1]}} , a[(369+1)*W +: W] , {(8){a[(369+2)*W+W-1]}} , a[(369+2)*W +: W] }), .sum(sum369), .cout(c369) );
 carry_save_3inputs #(W+8) cs_3in_372 (.a({  {(8){a[372*W+W-1]}} , a[372*W +: W] , {(8){a[(372+1)*W+W-1]}} , a[(372+1)*W +: W] , {(8){a[(372+2)*W+W-1]}} , a[(372+2)*W +: W] }), .sum(sum372), .cout(c372) );
 carry_save_3inputs #(W+8) cs_3in_375 (.a({  {(8){a[375*W+W-1]}} , a[375*W +: W] , {(8){a[(375+1)*W+W-1]}} , a[(375+1)*W +: W] , {(8){a[(375+2)*W+W-1]}} , a[(375+2)*W +: W] }), .sum(sum375), .cout(c375) );
 carry_save_3inputs #(W+8) cs_3in_378 (.a({  {(8){a[378*W+W-1]}} , a[378*W +: W] , {(8){a[(378+1)*W+W-1]}} , a[(378+1)*W +: W] , {(8){a[(378+2)*W+W-1]}} , a[(378+2)*W +: W] }), .sum(sum378), .cout(c378) );
 carry_save_3inputs #(W+8) cs_3in_381 (.a({  {(8){a[381*W+W-1]}} , a[381*W +: W] , {(8){a[(381+1)*W+W-1]}} , a[(381+1)*W +: W] , {(8){a[(381+2)*W+W-1]}} , a[(381+2)*W +: W] }), .sum(sum381), .cout(c381) );
 carry_save_3inputs #(W+8) cs_3in_384 (.a({  {(8){a[384*W+W-1]}} , a[384*W +: W] , {(8){a[(384+1)*W+W-1]}} , a[(384+1)*W +: W] , {(8){a[(384+2)*W+W-1]}} , a[(384+2)*W +: W] }), .sum(sum384), .cout(c384) );
 carry_save_3inputs #(W+8) cs_3in_387 (.a({  {(8){a[387*W+W-1]}} , a[387*W +: W] , {(8){a[(387+1)*W+W-1]}} , a[(387+1)*W +: W] , {(8){a[(387+2)*W+W-1]}} , a[(387+2)*W +: W] }), .sum(sum387), .cout(c387) );
 carry_save_3inputs #(W+8) cs_3in_390 (.a({  {(8){a[390*W+W-1]}} , a[390*W +: W] , {(8){a[(390+1)*W+W-1]}} , a[(390+1)*W +: W] , {(8){a[(390+2)*W+W-1]}} , a[(390+2)*W +: W] }), .sum(sum390), .cout(c390) ); 
 carry_save_3inputs #(W+8) cs_3in_393 (.a({  {(8){a[393*W+W-1]}} , a[393*W +: W] , {(8){a[(393+1)*W+W-1]}} , a[(393+1)*W +: W] , {(8){a[(393+2)*W+W-1]}} , a[(393+2)*W +: W] }), .sum(sum393), .cout(c393) );
 carry_save_3inputs #(W+8) cs_3in_396 (.a({  {(8){a[396*W+W-1]}} , a[396*W +: W] , {(8){a[(396+1)*W+W-1]}} , a[(396+1)*W +: W] , {(8){a[(396+2)*W+W-1]}} , a[(396+2)*W +: W] }), .sum(sum396), .cout(c396) );
 carry_save_3inputs #(W+8) cs_3in_399 (.a({  {(8){a[399*W+W-1]}} , a[399*W +: W] , {(8){a[(399+1)*W+W-1]}} , a[(399+1)*W +: W] , {(8){a[(399+2)*W+W-1]}} , a[(399+2)*W +: W] }), .sum(sum399), .cout(c399) );
 carry_save_3inputs #(W+8) cs_3in_402 (.a({  {(8){a[402*W+W-1]}} , a[402*W +: W] , {(8){a[(402+1)*W+W-1]}} , a[(402+1)*W +: W] , {(8){a[(402+2)*W+W-1]}} , a[(402+2)*W +: W] }), .sum(sum402), .cout(c402) );
 carry_save_3inputs #(W+8) cs_3in_405 (.a({  {(8){a[405*W+W-1]}} , a[405*W +: W] , {(8){a[(405+1)*W+W-1]}} , a[(405+1)*W +: W] , {(8){a[(405+2)*W+W-1]}} , a[(405+2)*W +: W] }), .sum(sum405), .cout(c405) );
 carry_save_3inputs #(W+8) cs_3in_408 (.a({  {(8){a[408*W+W-1]}} , a[408*W +: W] , {(8){a[(408+1)*W+W-1]}} , a[(408+1)*W +: W] , {(8){a[(408+2)*W+W-1]}} , a[(408+2)*W +: W] }), .sum(sum408), .cout(c408) );
 carry_save_3inputs #(W+8) cs_3in_411 (.a({  {(8){a[411*W+W-1]}} , a[411*W +: W] , {(8){a[(411+1)*W+W-1]}} , a[(411+1)*W +: W] , {(8){a[(411+2)*W+W-1]}} , a[(411+2)*W +: W] }), .sum(sum411), .cout(c411) );
 carry_save_3inputs #(W+8) cs_3in_414 (.a({  {(8){a[414*W+W-1]}} , a[414*W +: W] , {(8){a[(414+1)*W+W-1]}} , a[(414+1)*W +: W] , {(8){a[(414+2)*W+W-1]}} , a[(414+2)*W +: W] }), .sum(sum414), .cout(c414) );
 carry_save_3inputs #(W+8) cs_3in_417 (.a({  {(8){a[417*W+W-1]}} , a[417*W +: W] , {(8){a[(417+1)*W+W-1]}} , a[(417+1)*W +: W] , {(8){a[(417+2)*W+W-1]}} , a[(417+2)*W +: W] }), .sum(sum417), .cout(c417) );
 carry_save_3inputs #(W+8) cs_3in_420 (.a({  {(8){a[420*W+W-1]}} , a[420*W +: W] , {(8){a[(420+1)*W+W-1]}} , a[(420+1)*W +: W] , {(8){a[(420+2)*W+W-1]}} , a[(420+2)*W +: W] }), .sum(sum420), .cout(c420) );
 carry_save_3inputs #(W+8) cs_3in_423 (.a({  {(8){a[423*W+W-1]}} , a[423*W +: W] , {(8){a[(423+1)*W+W-1]}} , a[(423+1)*W +: W] , {(8){a[(423+2)*W+W-1]}} , a[(423+2)*W +: W] }), .sum(sum423), .cout(c423) );
 carry_save_3inputs #(W+8) cs_3in_426 (.a({  {(8){a[426*W+W-1]}} , a[426*W +: W] , {(8){a[(426+1)*W+W-1]}} , a[(426+1)*W +: W] , {(8){a[(426+2)*W+W-1]}} , a[(426+2)*W +: W] }), .sum(sum426), .cout(c426) );
 carry_save_3inputs #(W+8) cs_3in_429 (.a({  {(8){a[429*W+W-1]}} , a[429*W +: W] , {(8){a[(429+1)*W+W-1]}} , a[(429+1)*W +: W] , {(8){a[(429+2)*W+W-1]}} , a[(429+2)*W +: W] }), .sum(sum429), .cout(c429) );
 carry_save_3inputs #(W+8) cs_3in_432 (.a({  {(8){a[432*W+W-1]}} , a[432*W +: W] , {(8){a[(432+1)*W+W-1]}} , a[(432+1)*W +: W] , {(8){a[(432+2)*W+W-1]}} , a[(432+2)*W +: W] }), .sum(sum432), .cout(c432) );
 carry_save_3inputs #(W+8) cs_3in_435 (.a({  {(8){a[435*W+W-1]}} , a[435*W +: W] , {(8){a[(435+1)*W+W-1]}} , a[(435+1)*W +: W] , {(8){a[(435+2)*W+W-1]}} , a[(435+2)*W +: W] }), .sum(sum435), .cout(c435) );
 carry_save_3inputs #(W+8) cs_3in_438 (.a({  {(8){a[438*W+W-1]}} , a[438*W +: W] , {(8){a[(438+1)*W+W-1]}} , a[(438+1)*W +: W] , {(8){a[(438+2)*W+W-1]}} , a[(438+2)*W +: W] }), .sum(sum438), .cout(c438) );
 carry_save_3inputs #(W+8) cs_3in_441 (.a({  {(8){a[441*W+W-1]}} , a[441*W +: W] , {(8){a[(441+1)*W+W-1]}} , a[(441+1)*W +: W] , {(8){a[(441+2)*W+W-1]}} , a[(441+2)*W +: W] }), .sum(sum441), .cout(c441) );
 carry_save_3inputs #(W+8) cs_3in_444 (.a({  {(8){a[444*W+W-1]}} , a[444*W +: W] , {(8){a[(444+1)*W+W-1]}} , a[(444+1)*W +: W] , {(8){a[(444+2)*W+W-1]}} , a[(444+2)*W +: W] }), .sum(sum444), .cout(c444) );
 carry_save_3inputs #(W+8) cs_3in_447 (.a({  {(8){a[447*W+W-1]}} , a[447*W +: W] , {(8){a[(447+1)*W+W-1]}} , a[(447+1)*W +: W] , {(8){a[(447+2)*W+W-1]}} , a[(447+2)*W +: W] }), .sum(sum447), .cout(c447) );
 carry_save_3inputs #(W+8) cs_3in_450 (.a({  {(8){a[450*W+W-1]}} , a[450*W +: W] , {(8){a[(450+1)*W+W-1]}} , a[(450+1)*W +: W] , {(8){a[(450+2)*W+W-1]}} , a[(450+2)*W +: W] }), .sum(sum450), .cout(c450) );
 carry_save_3inputs #(W+8) cs_3in_453 (.a({  {(8){a[453*W+W-1]}} , a[453*W +: W] , {(8){a[(453+1)*W+W-1]}} , a[(453+1)*W +: W] , {(8){a[(453+2)*W+W-1]}} , a[(453+2)*W +: W] }), .sum(sum453), .cout(c453) );
 carry_save_3inputs #(W+8) cs_3in_456 (.a({  {(8){a[456*W+W-1]}} , a[456*W +: W] , {(8){a[(456+1)*W+W-1]}} , a[(456+1)*W +: W] , {(8){a[(456+2)*W+W-1]}} , a[(456+2)*W +: W] }), .sum(sum456), .cout(c456) );
 carry_save_3inputs #(W+8) cs_3in_459 (.a({  {(8){a[459*W+W-1]}} , a[459*W +: W] , {(8){a[(459+1)*W+W-1]}} , a[(459+1)*W +: W] , {(8){a[(459+2)*W+W-1]}} , a[(459+2)*W +: W] }), .sum(sum459), .cout(c459) );
 carry_save_3inputs #(W+8) cs_3in_462 (.a({  {(8){a[462*W+W-1]}} , a[462*W +: W] , {(8){a[(462+1)*W+W-1]}} , a[(462+1)*W +: W] , {(8){a[(462+2)*W+W-1]}} , a[(462+2)*W +: W] }), .sum(sum462), .cout(c462) );
 carry_save_3inputs #(W+8) cs_3in_465 (.a({  {(8){a[465*W+W-1]}} , a[465*W +: W] , {(8){a[(465+1)*W+W-1]}} , a[(465+1)*W +: W] , {(8){a[(465+2)*W+W-1]}} , a[(465+2)*W +: W] }), .sum(sum465), .cout(c465) );
 carry_save_3inputs #(W+8) cs_3in_468 (.a({  {(8){a[468*W+W-1]}} , a[468*W +: W] , {(8){a[(468+1)*W+W-1]}} , a[(468+1)*W +: W] , {(8){a[(468+2)*W+W-1]}} , a[(468+2)*W +: W] }), .sum(sum468), .cout(c468) );
 carry_save_3inputs #(W+8) cs_3in_471 (.a({  {(8){a[471*W+W-1]}} , a[471*W +: W] , {(8){a[(471+1)*W+W-1]}} , a[(471+1)*W +: W] , {(8){a[(471+2)*W+W-1]}} , a[(471+2)*W +: W] }), .sum(sum471), .cout(c471) );
 carry_save_3inputs #(W+8) cs_3in_474 (.a({  {(8){a[474*W+W-1]}} , a[474*W +: W] , {(8){a[(474+1)*W+W-1]}} , a[(474+1)*W +: W] , {(8){a[(474+2)*W+W-1]}} , a[(474+2)*W +: W] }), .sum(sum474), .cout(c474) );
 carry_save_3inputs #(W+8) cs_3in_477 (.a({  {(8){a[477*W+W-1]}} , a[477*W +: W] , {(8){a[(477+1)*W+W-1]}} , a[(477+1)*W +: W] , {(8){a[(477+2)*W+W-1]}} , a[(477+2)*W +: W] }), .sum(sum477), .cout(c477) );
 carry_save_3inputs #(W+8) cs_3in_480 (.a({  {(8){a[480*W+W-1]}} , a[480*W +: W] , {(8){a[(480+1)*W+W-1]}} , a[(480+1)*W +: W] , {(8){a[(480+2)*W+W-1]}} , a[(480+2)*W +: W] }), .sum(sum480), .cout(c480) );
 carry_save_3inputs #(W+8) cs_3in_483 (.a({  {(8){a[483*W+W-1]}} , a[483*W +: W] , {(8){a[(483+1)*W+W-1]}} , a[(483+1)*W +: W] , {(8){a[(483+2)*W+W-1]}} , a[(483+2)*W +: W] }), .sum(sum483), .cout(c483) );
 carry_save_3inputs #(W+8) cs_3in_486 (.a({  {(8){a[486*W+W-1]}} , a[486*W +: W] , {(8){a[(486+1)*W+W-1]}} , a[(486+1)*W +: W] , {(8){a[(486+2)*W+W-1]}} , a[(486+2)*W +: W] }), .sum(sum486), .cout(c486) );
 carry_save_3inputs #(W+8) cs_3in_489 (.a({  {(8){a[489*W+W-1]}} , a[489*W +: W] , {(8){a[(489+1)*W+W-1]}} , a[(489+1)*W +: W] , {(8){a[(489+2)*W+W-1]}} , a[(489+2)*W +: W] }), .sum(sum489), .cout(c489) );
 carry_save_3inputs #(W+8) cs_3in_492 (.a({  {(8){a[492*W+W-1]}} , a[492*W +: W] , {(8){a[(492+1)*W+W-1]}} , a[(492+1)*W +: W] , {(8){a[(492+2)*W+W-1]}} , a[(492+2)*W +: W] }), .sum(sum492), .cout(c492) );
 carry_save_3inputs #(W+8) cs_3in_495 (.a({  {(8){a[495*W+W-1]}} , a[495*W +: W] , {(8){a[(495+1)*W+W-1]}} , a[(495+1)*W +: W] , {(8){a[(495+2)*W+W-1]}} , a[(495+2)*W +: W] }), .sum(sum495), .cout(c495) );
 carry_save_3inputs #(W+8) cs_3in_498 (.a({  {(8){a[498*W+W-1]}} , a[498*W +: W] , {(8){a[(498+1)*W+W-1]}} , a[(498+1)*W +: W] , {(8){a[(498+2)*W+W-1]}} , a[(498+2)*W +: W] }), .sum(sum498), .cout(c498) );
 carry_save_3inputs #(W+8) cs_3in_501 (.a({  {(8){a[501*W+W-1]}} , a[501*W +: W] , {(8){a[(501+1)*W+W-1]}} , a[(501+1)*W +: W] , {(8){a[(501+2)*W+W-1]}} , a[(501+2)*W +: W] }), .sum(sum501), .cout(c501) );
 carry_save_3inputs #(W+8) cs_3in_504 (.a({  {(8){a[504*W+W-1]}} , a[504*W +: W] , {(8){a[(504+1)*W+W-1]}} , a[(504+1)*W +: W] , {(8){a[(504+2)*W+W-1]}} , a[(504+2)*W +: W] }), .sum(sum504), .cout(c504) );
 carry_save_3inputs #(W+8) cs_3in_507 (.a({  {(8){a[507*W+W-1]}} , a[507*W +: W] , {(8){a[(507+1)*W+W-1]}} , a[(507+1)*W +: W] , {(8){a[(507+2)*W+W-1]}} , a[(507+2)*W +: W] }), .sum(sum507), .cout(c507) ); // a(510), a(511) do not added

 carry_save_3inputs #(W+8+1) cs_3in_01(.a({ sum000, c000, sum003  }),               .sum(sum_01), .cout(c_01) );
 carry_save_3inputs #(W+8+1) cs_3in_02(.a({ c003, sum006,  c006   }),               .sum(sum_02), .cout(c_02) );
 carry_save_3inputs #(W+8+1) cs_3in_03(.a({ sum009, c009, sum012  }),               .sum(sum_03), .cout(c_03) );
 carry_save_3inputs #(W+8+1) cs_3in_04(.a({ c012, sum015,  c015   }),               .sum(sum_04), .cout(c_04) );
 carry_save_3inputs #(W+8+1) cs_3in_05(.a({ sum018, c018, sum021  }),               .sum(sum_05), .cout(c_05) );
 carry_save_3inputs #(W+8+1) cs_3in_06(.a({ c021, sum024,  c024   }),               .sum(sum_06), .cout(c_06) );
 carry_save_3inputs #(W+8+1) cs_3in_07(.a({ sum027, c027, sum030  }),               .sum(sum_07), .cout(c_07) );
 carry_save_3inputs #(W+8+1) cs_3in_08(.a({ c030, sum033,  c033   }),               .sum(sum_08), .cout(c_08) );
 carry_save_3inputs #(W+8+1) cs_3in_09(.a({ sum036, c036, sum039  }),               .sum(sum_09), .cout(c_09) );
 carry_save_3inputs #(W+8+1) cs_3in_10(.a({ c039, sum042,  c042   }),               .sum(sum_10), .cout(c_10) );
 carry_save_3inputs #(W+8+1) cs_3in_11(.a({ sum045, c045, sum048  }),               .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+8+1) cs_3in_12(.a({ c048, sum051,  c051   }),               .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+8+1) cs_3in_13(.a({ sum054, c054, sum057  }),               .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+8+1) cs_3in_14(.a({ c057, sum060,  c060   }),               .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+8+1) cs_3in_15(.a({ sum063, c063, sum066  }),               .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+8+1) cs_3in_16(.a({ c066, sum069,  c069   }),               .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+8+1) cs_3in_17(.a({ sum072, c072, sum075  }),               .sum(sum_17), .cout(c_17) );
 carry_save_3inputs #(W+8+1) cs_3in_18(.a({ c075, sum078,  c078   }),               .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+8+1) cs_3in_19(.a({ sum081, c081, sum084  }),               .sum(sum_19), .cout(c_19) );
 carry_save_3inputs #(W+8+1) cs_3in_20(.a({ c084, sum087,  c087   }),               .sum(sum_20), .cout(c_20) );
 carry_save_3inputs #(W+8+1) cs_3in_21(.a({ sum090, c090, sum093  }),               .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+8+1) cs_3in_22(.a({ c093, sum096,  c096   }),               .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+8+1) cs_3in_23(.a({ sum099, c099, sum102  }),               .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+8+1) cs_3in_24(.a({ c102, sum105,  c105   }),               .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+8+1) cs_3in_25(.a({ sum108, c108, sum111  }),               .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+8+1) cs_3in_26(.a({ c111, sum114,  c114   }),               .sum(sum_26), .cout(c_26) );
 carry_save_3inputs #(W+8+1) cs_3in_27(.a({ sum117, c117, sum120  }),               .sum(sum_27), .cout(c_27) );
 carry_save_3inputs #(W+8+1) cs_3in_28(.a({ c120, sum123,  c123   }),               .sum(sum_28), .cout(c_28) );
 carry_save_3inputs #(W+8+1) cs_3in_29(.a({ sum126, c126, sum129  }),               .sum(sum_29), .cout(c_29) );
 carry_save_3inputs #(W+8+1) cs_3in_30(.a({ c129, sum132,  c132   }),               .sum(sum_30), .cout(c_30) );
 carry_save_3inputs #(W+8+1) cs_3in_31(.a({ sum135, c135, sum138  }),               .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+8+1) cs_3in_32(.a({ c138, sum141,  c141   }),               .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+8+1) cs_3in_33(.a({ sum144, c144, sum147  }),               .sum(sum_33), .cout(c_33) );
 carry_save_3inputs #(W+8+1) cs_3in_34(.a({ c147, sum150,  c150   }),               .sum(sum_34), .cout(c_34) );
 carry_save_3inputs #(W+8+1) cs_3in_35(.a({ sum153, c153, sum156  }),               .sum(sum_35), .cout(c_35) );
 carry_save_3inputs #(W+8+1) cs_3in_36(.a({ c156, sum159,  c159   }),               .sum(sum_36), .cout(c_36) );
 carry_save_3inputs #(W+8+1) cs_3in_37(.a({ sum162, c162, sum165  }),               .sum(sum_37), .cout(c_37) );
 carry_save_3inputs #(W+8+1) cs_3in_38(.a({ c165, sum168,  c168   }),               .sum(sum_38), .cout(c_38) );
 carry_save_3inputs #(W+8+1) cs_3in_39(.a({ sum171, c171, sum174  }),               .sum(sum_39), .cout(c_39) );
 carry_save_3inputs #(W+8+1) cs_3in_40(.a({ c174, sum177,  c177   }),               .sum(sum_40), .cout(c_40) );
 carry_save_3inputs #(W+8+1) cs_3in_41(.a({ sum180, c180, sum183  }),               .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+8+1) cs_3in_42(.a({ c183, sum186,  c186   }),               .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+8+1) cs_3in_43(.a({ sum189, c189, sum192  }),               .sum(sum_43), .cout(c_43) );
 carry_save_3inputs #(W+8+1) cs_3in_44(.a({ c192, sum195,  c195   }),               .sum(sum_44), .cout(c_44) );
 carry_save_3inputs #(W+8+1) cs_3in_45(.a({ sum198, c198, sum201  }),               .sum(sum_45), .cout(c_45) );
 carry_save_3inputs #(W+8+1) cs_3in_46(.a({ c201, sum204,  c204   }),               .sum(sum_46), .cout(c_46) );
 carry_save_3inputs #(W+8+1) cs_3in_47(.a({ sum207, c207, sum210  }),               .sum(sum_47), .cout(c_47) );
 carry_save_3inputs #(W+8+1) cs_3in_48(.a({ c210, sum213,  c213   }),               .sum(sum_48), .cout(c_48) );
 carry_save_3inputs #(W+8+1) cs_3in_49(.a({ sum216, c216, sum219  }),               .sum(sum_49), .cout(c_49) );
 carry_save_3inputs #(W+8+1) cs_3in_50(.a({ c219, sum222,  c222   }),               .sum(sum_50), .cout(c_50) );
 carry_save_3inputs #(W+8+1) cs_3in_51(.a({ sum225, c225, sum228  }),               .sum(sum_51), .cout(c_51) );
 carry_save_3inputs #(W+8+1) cs_3in_52(.a({ c228, sum231,  c231   }),               .sum(sum_52), .cout(c_52) );
 carry_save_3inputs #(W+8+1) cs_3in_53(.a({ sum234, c234, sum237  }),               .sum(sum_53), .cout(c_53) );
 carry_save_3inputs #(W+8+1) cs_3in_54(.a({ c237, sum240,  c240   }),               .sum(sum_54), .cout(c_54) );
 carry_save_3inputs #(W+8+1) cs_3in_55(.a({ sum243, c243, sum246  }),               .sum(sum_55), .cout(c_55) );
 carry_save_3inputs #(W+8+1) cs_3in_56(.a({ c246, sum249,  c249   }),               .sum(sum_56), .cout(c_56) );
 carry_save_3inputs #(W+8+1) cs_3in_57(.a({ sum252, c252, sum255  }),               .sum(sum_57), .cout(c_57) );
 carry_save_3inputs #(W+8+1) cs_3in_58(.a({ c255, sum258,  c258   }),               .sum(sum_58), .cout(c_58) );
 carry_save_3inputs #(W+8+1) cs_3in_59(.a({ sum261, c261, sum264  }),               .sum(sum_59), .cout(c_59) );
 carry_save_3inputs #(W+8+1) cs_3in_60(.a({ c264, sum267,  c267   }),               .sum(sum_60), .cout(c_60) );
 carry_save_3inputs #(W+8+1) cs_3in_61(.a({ sum270, c270, sum273  }),               .sum(sum_61), .cout(c_61) );
 carry_save_3inputs #(W+8+1) cs_3in_62(.a({  c273, sum276,  c276  }),               .sum(sum_62), .cout(c_62) );
 carry_save_3inputs #(W+8+1) cs_3in_63(.a({ sum279, c279, sum282  }),               .sum(sum_63), .cout(c_63) );
 carry_save_3inputs #(W+8+1) cs_3in_64(.a({ c282, sum285,  c285   }),               .sum(sum_64), .cout(c_64) );
 carry_save_3inputs #(W+8+1) cs_3in_65(.a({ sum288, c288, sum291  }),               .sum(sum_65), .cout(c_65) );
 carry_save_3inputs #(W+8+1) cs_3in_66(.a({ c291, sum294,  c294   }),               .sum(sum_66), .cout(c_66) );
 carry_save_3inputs #(W+8+1) cs_3in_67(.a({ sum297, c297, sum300  }),               .sum(sum_67), .cout(c_67) );
 carry_save_3inputs #(W+8+1) cs_3in_68(.a({ c300, sum303,  c303   }),               .sum(sum_68), .cout(c_68) );
 carry_save_3inputs #(W+8+1) cs_3in_69(.a({ sum306, c306, sum309  }),               .sum(sum_69), .cout(c_69) );
 carry_save_3inputs #(W+8+1) cs_3in_70(.a({ c309, sum312,  c312   }),               .sum(sum_70), .cout(c_70) );
 carry_save_3inputs #(W+8+1) cs_3in_71(.a({ sum315, c315, sum318  }),               .sum(sum_71), .cout(c_71) );
 carry_save_3inputs #(W+8+1) cs_3in_72(.a({ c318, sum321,  c321   }),               .sum(sum_72), .cout(c_72) );
 carry_save_3inputs #(W+8+1) cs_3in_73(.a({ sum324, c324, sum327  }),               .sum(sum_73), .cout(c_73) );
 carry_save_3inputs #(W+8+1) cs_3in_74(.a({ c327, sum330,  c330   }),               .sum(sum_74), .cout(c_74) );
 carry_save_3inputs #(W+8+1) cs_3in_75(.a({ sum333, c333, sum336  }),               .sum(sum_75), .cout(c_75) );
 carry_save_3inputs #(W+8+1) cs_3in_76(.a({ c336, sum339,  c339   }),               .sum(sum_76), .cout(c_76) );
 carry_save_3inputs #(W+8+1) cs_3in_77(.a({ sum342, c342, sum345  }),               .sum(sum_77), .cout(c_77) );
 carry_save_3inputs #(W+8+1) cs_3in_78(.a({ c345, sum348,  c348   }),               .sum(sum_78), .cout(c_78) );
 carry_save_3inputs #(W+8+1) cs_3in_79(.a({ sum351, c351, sum354  }),               .sum(sum_79), .cout(c_79) );
 carry_save_3inputs #(W+8+1) cs_3in_80(.a({ c354, sum357,  c357   }),               .sum(sum_80), .cout(c_80) );
 carry_save_3inputs #(W+8+1) cs_3in_81(.a({ sum360, c360, sum363  }),               .sum(sum_81), .cout(c_81) );
 carry_save_3inputs #(W+8+1) cs_3in_82(.a({ c363, sum366,  c366   }),               .sum(sum_82), .cout(c_82) );
 carry_save_3inputs #(W+8+1) cs_3in_83(.a({ sum369, c369, sum372  }),               .sum(sum_83), .cout(c_83) );
 carry_save_3inputs #(W+8+1) cs_3in_84(.a({ c372, sum375,  c375   }),               .sum(sum_84), .cout(c_84) );
 carry_save_3inputs #(W+8+1) cs_3in_85(.a({ sum378, c378, sum381  }),               .sum(sum_85), .cout(c_85) );
 carry_save_3inputs #(W+8+1) cs_3in_86(.a({  c381, sum384,  c384  }),               .sum(sum_86), .cout(c_86) );
 carry_save_3inputs #(W+8+1) cs_3in_87(.a({ sum387, c387, sum390  }),               .sum(sum_87), .cout(c_87) );
 carry_save_3inputs #(W+8+1) cs_3in_88(.a({ c390, sum393,  c393   }),               .sum(sum_88), .cout(c_88) );
 carry_save_3inputs #(W+8+1) cs_3in_89(.a({ sum396, c396, sum399  }),               .sum(sum_89), .cout(c_89) );
 carry_save_3inputs #(W+8+1) cs_3in_90(.a({ c399, sum402,  c402   }),               .sum(sum_90), .cout(c_90) );
 carry_save_3inputs #(W+8+1) cs_3in_91(.a({ sum405, c405, sum408  }),               .sum(sum_91), .cout(c_91) );
 carry_save_3inputs #(W+8+1) cs_3in_92(.a({ c408, sum411,  c411   }),               .sum(sum_92), .cout(c_92) );
 carry_save_3inputs #(W+8+1) cs_3in_93(.a({ sum414, c414, sum417  }),               .sum(sum_93), .cout(c_93) );
 carry_save_3inputs #(W+8+1) cs_3in_94(.a({ c417, sum420,  c420   }),               .sum(sum_94), .cout(c_94) );
 carry_save_3inputs #(W+8+1) cs_3in_95(.a({ sum423, c423, sum426  }),               .sum(sum_95), .cout(c_95) );
 carry_save_3inputs #(W+8+1) cs_3in_96(.a({ c426, sum429,  c429   }),               .sum(sum_96), .cout(c_96) );
 carry_save_3inputs #(W+8+1) cs_3in_97(.a({ sum432, c432, sum435  }),               .sum(sum_97), .cout(c_97) );
 carry_save_3inputs #(W+8+1) cs_3in_98(.a({ c435, sum438,  c438   }),               .sum(sum_98), .cout(c_98) );
 carry_save_3inputs #(W+8+1) cs_3in_99(.a({ sum441, c441, sum444  }),               .sum(sum_99), .cout(c_99) );
 carry_save_3inputs #(W+8+1) cs_3in_a0(.a({ c444, sum447,  c447   }),               .sum(sum_a0), .cout(c_a0) );
 carry_save_3inputs #(W+8+1) cs_3in_a1(.a({ sum450, c450, sum453  }),               .sum(sum_a1), .cout(c_a1) );
 carry_save_3inputs #(W+8+1) cs_3in_a2(.a({ c453, sum456,  c456   }),               .sum(sum_a2), .cout(c_a2) );
 carry_save_3inputs #(W+8+1) cs_3in_a3(.a({ sum459, c459, sum462  }),               .sum(sum_a3), .cout(c_a3) );
 carry_save_3inputs #(W+8+1) cs_3in_a4(.a({ c462, sum465,  c465   }),               .sum(sum_a4), .cout(c_a4) );
 carry_save_3inputs #(W+8+1) cs_3in_a5(.a({ sum468, c468, sum471  }),               .sum(sum_a5), .cout(c_a5) );
 carry_save_3inputs #(W+8+1) cs_3in_a6(.a({ c471, sum474,  c474   }),               .sum(sum_a6), .cout(c_a6) );
 carry_save_3inputs #(W+8+1) cs_3in_a7(.a({ sum477, c477, sum480  }),               .sum(sum_a7), .cout(c_a7) );
 carry_save_3inputs #(W+8+1) cs_3in_a8(.a({ c480, sum483,  c483   }),               .sum(sum_a8), .cout(c_a8) );
 carry_save_3inputs #(W+8+1) cs_3in_a9(.a({ sum486, c486, sum489  }),               .sum(sum_a9), .cout(c_a9) );
 carry_save_3inputs #(W+8+1) cs_3in_b0(.a({ c489, sum492,  c492   }),               .sum(sum_b0), .cout(c_b0) );
 carry_save_3inputs #(W+8+1) cs_3in_b1(.a({ sum495, c495, sum498  }),               .sum(sum_b1), .cout(c_b1) );
 carry_save_3inputs #(W+8+1) cs_3in_b2(.a({  c498, sum501,  c501  }),               .sum(sum_b2), .cout(c_b2) );
 carry_save_3inputs #(W+8+1) cs_3in_b3(.a({ sum504, c504, {{(8+1){a[510*W+W-1]}} , a[510*W +: W ]} }),.sum(sum_b3), .cout(c_b3) );
 carry_save_3inputs #(W+8+1) cs_3in_b4(.a({ sum507, c507, {{(8+1){a[511*W+W-1]}} , a[511*W +: W ]} }),.sum(sum_b4), .cout(c_b4) ); 


carry_save_3inputs #(W+8+2) cs_3in_a161(.a({ sum_01, c_01, sum_02 }), .sum(sum_161), .cout(c_161) );
carry_save_3inputs #(W+8+2) cs_3in_a162(.a({ c_02, sum_03, c_03   }), .sum(sum_162), .cout(c_162) );
carry_save_3inputs #(W+8+2) cs_3in_a163(.a({ sum_04, c_04, sum_05 }), .sum(sum_163), .cout(c_163) );
carry_save_3inputs #(W+8+2) cs_3in_a164(.a({ c_05, sum_06, c_06   }), .sum(sum_164), .cout(c_164) );
carry_save_3inputs #(W+8+2) cs_3in_a165(.a({ sum_07, c_07, sum_08 }), .sum(sum_165), .cout(c_165) );
carry_save_3inputs #(W+8+2) cs_3in_a166(.a({ c_08, sum_09, c_09   }), .sum(sum_166), .cout(c_166) );
carry_save_3inputs #(W+8+2) cs_3in_a167(.a({ sum_10, c_10, sum_11 }), .sum(sum_167), .cout(c_167) );
carry_save_3inputs #(W+8+2) cs_3in_a168(.a({ c_11, sum_12, c_12   }), .sum(sum_168), .cout(c_168) );
carry_save_3inputs #(W+8+2) cs_3in_a169(.a({ sum_13, c_13, sum_14 }), .sum(sum_169), .cout(c_169) );
carry_save_3inputs #(W+8+2) cs_3in_a170(.a({ c_14, sum_15, c_15   }), .sum(sum_170), .cout(c_170) );
carry_save_3inputs #(W+8+2) cs_3in_a171(.a({ sum_16, c_16, sum_17 }), .sum(sum_171), .cout(c_171) );
carry_save_3inputs #(W+8+2) cs_3in_a172(.a({ c_17, sum_18, c_18   }), .sum(sum_172), .cout(c_172) );
carry_save_3inputs #(W+8+2) cs_3in_a173(.a({ sum_19, c_19, sum_20 }), .sum(sum_173), .cout(c_173) );
carry_save_3inputs #(W+8+2) cs_3in_a174(.a({ c_20, sum_21, c_21   }), .sum(sum_174), .cout(c_174) );
carry_save_3inputs #(W+8+2) cs_3in_a175(.a({ sum_22, c_22, sum_23 }), .sum(sum_175), .cout(c_175) );
carry_save_3inputs #(W+8+2) cs_3in_a176(.a({ c_23, sum_24, c_24   }), .sum(sum_176), .cout(c_176) );
carry_save_3inputs #(W+8+2) cs_3in_a177(.a({ sum_25, c_25, sum_26 }), .sum(sum_177), .cout(c_177) );
carry_save_3inputs #(W+8+2) cs_3in_a178(.a({ c_26, sum_27, c_27   }), .sum(sum_178), .cout(c_178) );
carry_save_3inputs #(W+8+2) cs_3in_a179(.a({ sum_28, c_28, sum_29 }), .sum(sum_179), .cout(c_179) );
carry_save_3inputs #(W+8+2) cs_3in_a180(.a({ c_29, sum_30, c_30   }), .sum(sum_180), .cout(c_180) );
carry_save_3inputs #(W+8+2) cs_3in_a181(.a({ sum_31, c_31, sum_32 }), .sum(sum_181), .cout(c_181) );
carry_save_3inputs #(W+8+2) cs_3in_a182(.a({ c_32, sum_33, c_33   }), .sum(sum_182), .cout(c_182) );
carry_save_3inputs #(W+8+2) cs_3in_a183(.a({ sum_34, c_34, sum_35 }), .sum(sum_183), .cout(c_183) );
carry_save_3inputs #(W+8+2) cs_3in_a184(.a({ c_35, sum_36, c_36   }), .sum(sum_184), .cout(c_184) );
carry_save_3inputs #(W+8+2) cs_3in_a185(.a({ sum_37, c_37, sum_38 }), .sum(sum_185), .cout(c_185) );
carry_save_3inputs #(W+8+2) cs_3in_a186(.a({ c_38, sum_39, c_39   }), .sum(sum_186), .cout(c_186) );
carry_save_3inputs #(W+8+2) cs_3in_a187(.a({ sum_40, c_40, sum_41 }), .sum(sum_187), .cout(c_187) );
carry_save_3inputs #(W+8+2) cs_3in_a188(.a({ c_41, sum_42, c_42   }), .sum(sum_188), .cout(c_188) );
carry_save_3inputs #(W+8+2) cs_3in_a189(.a({ sum_43, c_43, sum_44 }), .sum(sum_189), .cout(c_189) );
carry_save_3inputs #(W+8+2) cs_3in_a190(.a({ c_44, sum_45, c_45   }), .sum(sum_190), .cout(c_190) );
carry_save_3inputs #(W+8+2) cs_3in_a191(.a({ sum_46, c_46, sum_47 }), .sum(sum_191), .cout(c_191) );
carry_save_3inputs #(W+8+2) cs_3in_a192(.a({ c_47, sum_48, c_48   }), .sum(sum_192), .cout(c_192) );
carry_save_3inputs #(W+8+2) cs_3in_a193(.a({ sum_49, c_49, sum_50 }), .sum(sum_193), .cout(c_193) );
carry_save_3inputs #(W+8+2) cs_3in_a194(.a({ c_50, sum_51, c_51   }), .sum(sum_194), .cout(c_194) );
carry_save_3inputs #(W+8+2) cs_3in_a195(.a({ sum_52, c_52, sum_53 }), .sum(sum_195), .cout(c_195) );
carry_save_3inputs #(W+8+2) cs_3in_a196(.a({ c_53, sum_54, c_54   }), .sum(sum_196), .cout(c_196) );
carry_save_3inputs #(W+8+2) cs_3in_a197(.a({ sum_55, c_55, sum_56 }), .sum(sum_197), .cout(c_197) );
carry_save_3inputs #(W+8+2) cs_3in_a198(.a({ c_56, sum_57, c_57   }), .sum(sum_198), .cout(c_198) );
carry_save_3inputs #(W+8+2) cs_3in_a199(.a({ sum_58, c_58, sum_59 }), .sum(sum_199), .cout(c_199) );
carry_save_3inputs #(W+8+2) cs_3in_a1c0(.a({ c_59, sum_60, c_60   }), .sum(sum_1c0), .cout(c_1c0) );
carry_save_3inputs #(W+8+2) cs_3in_a1c1(.a({ sum_61, c_61, sum_62 }), .sum(sum_1c1), .cout(c_1c1) );
carry_save_3inputs #(W+8+2) cs_3in_a1c2(.a({ c_62, sum_63, c_63   }), .sum(sum_1c2), .cout(c_1c2) );
carry_save_3inputs #(W+8+2) cs_3in_a1c3(.a({ sum_64, c_64, sum_65 }), .sum(sum_1c3), .cout(c_1c3) );
carry_save_3inputs #(W+8+2) cs_3in_a1c4(.a({ c_65, sum_66, c_66   }), .sum(sum_1c4), .cout(c_1c4) );
carry_save_3inputs #(W+8+2) cs_3in_a1c5(.a({ sum_67, c_67, sum_68 }), .sum(sum_1c5), .cout(c_1c5) );
carry_save_3inputs #(W+8+2) cs_3in_a1c6(.a({ c_68, sum_69, c_69   }), .sum(sum_1c6), .cout(c_1c6) );
carry_save_3inputs #(W+8+2) cs_3in_a1c7(.a({ sum_70, c_70, sum_71 }), .sum(sum_1c7), .cout(c_1c7) );
carry_save_3inputs #(W+8+2) cs_3in_a1c8(.a({ c_71, sum_72, c_72   }), .sum(sum_1c8), .cout(c_1c8) );
carry_save_3inputs #(W+8+2) cs_3in_a1c9(.a({ sum_73, c_73, sum_74 }), .sum(sum_1c9), .cout(c_1c9) );
carry_save_3inputs #(W+8+2) cs_3in_a1d0(.a({ c_74, sum_75, c_75   }), .sum(sum_1d0), .cout(c_1d0) );
carry_save_3inputs #(W+8+2) cs_3in_a1d1(.a({ sum_76, c_76, sum_77 }), .sum(sum_1d1), .cout(c_1d1) );
carry_save_3inputs #(W+8+2) cs_3in_a1d2(.a({ c_77, sum_78, c_78   }), .sum(sum_1d2), .cout(c_1d2) );
carry_save_3inputs #(W+8+2) cs_3in_a1d3(.a({ sum_79, c_79, sum_80 }), .sum(sum_1d3), .cout(c_1d3) );
carry_save_3inputs #(W+8+2) cs_3in_a1d4(.a({ c_80, sum_81, c_81   }), .sum(sum_1d4), .cout(c_1d4) );
carry_save_3inputs #(W+8+2) cs_3in_a1d5(.a({ sum_82, c_82, sum_83 }), .sum(sum_1d5), .cout(c_1d5) );
carry_save_3inputs #(W+8+2) cs_3in_a1d6(.a({ c_83, sum_84, c_84   }), .sum(sum_1d6), .cout(c_1d6) );
carry_save_3inputs #(W+8+2) cs_3in_a1d7(.a({ sum_85, c_85, sum_86 }), .sum(sum_1d7), .cout(c_1d7) );
carry_save_3inputs #(W+8+2) cs_3in_a1d8(.a({ c_86, sum_87, c_87   }), .sum(sum_1d8), .cout(c_1d8) );
carry_save_3inputs #(W+8+2) cs_3in_a1d9(.a({ sum_88, c_88, sum_89 }), .sum(sum_1d9), .cout(c_1d9) );
carry_save_3inputs #(W+8+2) cs_3in_a1e0(.a({ c_89, sum_90, c_90   }), .sum(sum_1e0), .cout(c_1e0) );
carry_save_3inputs #(W+8+2) cs_3in_a1e1(.a({ sum_91, c_91, sum_92 }), .sum(sum_1e1), .cout(c_1e1) );
carry_save_3inputs #(W+8+2) cs_3in_a1e2(.a({ c_92, sum_93, c_93   }), .sum(sum_1e2), .cout(c_1e2) );
carry_save_3inputs #(W+8+2) cs_3in_a1e3(.a({ sum_94, c_94, sum_95 }), .sum(sum_1e3), .cout(c_1e3) );
carry_save_3inputs #(W+8+2) cs_3in_a1e4(.a({ c_95, sum_96, c_96   }), .sum(sum_1e4), .cout(c_1e4) );
carry_save_3inputs #(W+8+2) cs_3in_a1e5(.a({ sum_97, c_97, sum_98 }), .sum(sum_1e5), .cout(c_1e5) );
carry_save_3inputs #(W+8+2) cs_3in_a1e6(.a({ c_98, sum_99, c_99   }), .sum(sum_1e6), .cout(c_1e6) );
carry_save_3inputs #(W+8+2) cs_3in_a1e7(.a({ sum_a0, c_a0, sum_a1 }), .sum(sum_1e7), .cout(c_1e7) );
carry_save_3inputs #(W+8+2) cs_3in_a1e8(.a({ c_a1, sum_a2, c_a2   }), .sum(sum_1e8), .cout(c_1e8) );
carry_save_3inputs #(W+8+2) cs_3in_a1e9(.a({ sum_a3, c_a3, sum_a4 }), .sum(sum_1e9), .cout(c_1e9) );
carry_save_3inputs #(W+8+2) cs_3in_a1f0(.a({ c_a4, sum_a5, c_a5   }), .sum(sum_1f0), .cout(c_1f0) );
carry_save_3inputs #(W+8+2) cs_3in_a1f1(.a({ sum_a6, c_a6, sum_a7 }), .sum(sum_1f1), .cout(c_1f1) );
carry_save_3inputs #(W+8+2) cs_3in_a1f2(.a({ c_a7, sum_a8, c_a8   }), .sum(sum_1f2), .cout(c_1f2) );
carry_save_3inputs #(W+8+2) cs_3in_a1f3(.a({ sum_a9, c_a9, sum_b0 }), .sum(sum_1f3), .cout(c_1f3) );
carry_save_3inputs #(W+8+2) cs_3in_a1f4(.a({ c_b0, sum_b1, c_b1   }), .sum(sum_1f4), .cout(c_1f4) );
carry_save_3inputs #(W+8+2) cs_3in_a1f5(.a({ sum_b2, c_b2, sum_b3 }), .sum(sum_1f5), .cout(c_1f5) );
carry_save_3inputs #(W+8+2) cs_3in_a1f6(.a({ c_b3, sum_b4, c_b4   }), .sum(sum_1f6), .cout(c_1f6) );



 carry_save_3inputs #(W+8+3) cs_3in_a301(.a({ sum_161, c_161, sum_162}), .sum(sum_301), .cout(c_301) );
 carry_save_3inputs #(W+8+3) cs_3in_a302(.a({ sum_163, c_162, c_163  }), .sum(sum_302), .cout(c_302) );
 carry_save_3inputs #(W+8+3) cs_3in_a303(.a({ sum_164, c_164, sum_165}), .sum(sum_303), .cout(c_303) );
 carry_save_3inputs #(W+8+3) cs_3in_a304(.a({ sum_166, c_165, c_166  }), .sum(sum_304), .cout(c_304) );
 carry_save_3inputs #(W+8+3) cs_3in_a305(.a({ sum_167, c_167, sum_168}), .sum(sum_305), .cout(c_305) );
 carry_save_3inputs #(W+8+3) cs_3in_a306(.a({ sum_169, c_168, c_169  }), .sum(sum_306), .cout(c_306) );
 carry_save_3inputs #(W+8+3) cs_3in_a307(.a({ sum_170, c_170, sum_171}), .sum(sum_307), .cout(c_307) );
 carry_save_3inputs #(W+8+3) cs_3in_a308(.a({ sum_172, c_171, c_172  }), .sum(sum_308), .cout(c_308) );
 carry_save_3inputs #(W+8+3) cs_3in_a309(.a({ sum_173, c_173, sum_174}), .sum(sum_309), .cout(c_309) );
 carry_save_3inputs #(W+8+3) cs_3in_a310(.a({ sum_175, c_174, c_175  }), .sum(sum_310), .cout(c_310) );
 carry_save_3inputs #(W+8+3) cs_3in_a311(.a({ sum_176, c_176, sum_177}), .sum(sum_311), .cout(c_311) );
 carry_save_3inputs #(W+8+3) cs_3in_a312(.a({ sum_178, c_177, c_178  }), .sum(sum_312), .cout(c_312) );
 carry_save_3inputs #(W+8+3) cs_3in_a313(.a({ sum_179, c_179, sum_180}), .sum(sum_313), .cout(c_313) );
 carry_save_3inputs #(W+8+3) cs_3in_a314(.a({ sum_181, c_180, c_181  }), .sum(sum_314), .cout(c_314) );
 carry_save_3inputs #(W+8+3) cs_3in_a315(.a({ sum_182, c_182, sum_183}), .sum(sum_315), .cout(c_315) );
 carry_save_3inputs #(W+8+3) cs_3in_a316(.a({ sum_184, c_183, c_184  }), .sum(sum_316), .cout(c_316) );
 carry_save_3inputs #(W+8+3) cs_3in_a317(.a({ sum_185, c_185, sum_186}), .sum(sum_317), .cout(c_317) );
 carry_save_3inputs #(W+8+3) cs_3in_a318(.a({ sum_187, c_186, c_187  }), .sum(sum_318), .cout(c_318) );
 carry_save_3inputs #(W+8+3) cs_3in_a319(.a({ sum_188, c_188, sum_189}), .sum(sum_319), .cout(c_319) );
 carry_save_3inputs #(W+8+3) cs_3in_a320(.a({ sum_190, c_189, c_190  }), .sum(sum_320), .cout(c_320) );
 carry_save_3inputs #(W+8+3) cs_3in_a321(.a({ sum_191, c_191, sum_192}), .sum(sum_321), .cout(c_321) );
 carry_save_3inputs #(W+8+3) cs_3in_a322(.a({ sum_193, c_192, c_193  }), .sum(sum_322), .cout(c_322) );
 carry_save_3inputs #(W+8+3) cs_3in_a323(.a({ sum_194, c_194, sum_195}), .sum(sum_323), .cout(c_323) );
 carry_save_3inputs #(W+8+3) cs_3in_a324(.a({ sum_196, c_195, c_196  }), .sum(sum_324), .cout(c_324) );
 carry_save_3inputs #(W+8+3) cs_3in_a400(.a({ sum_197, c_197, sum_198}), .sum(sum_400), .cout(c_400) );
 carry_save_3inputs #(W+8+3) cs_3in_a401(.a({ sum_199, c_198, c_199  }), .sum(sum_401), .cout(c_401) );
 carry_save_3inputs #(W+8+3) cs_3in_a402(.a({ sum_1c0, c_1c0, sum_1c1}), .sum(sum_402), .cout(c_402) );
 carry_save_3inputs #(W+8+3) cs_3in_a403(.a({ sum_1c2, c_1c1, c_1c2  }), .sum(sum_403), .cout(c_403) );
 carry_save_3inputs #(W+8+3) cs_3in_a404(.a({ sum_1c3, c_1c3, sum_1c4}), .sum(sum_404), .cout(c_404) );
 carry_save_3inputs #(W+8+3) cs_3in_a405(.a({ sum_1c5, c_1c4, c_1c5  }), .sum(sum_405), .cout(c_405) );
 carry_save_3inputs #(W+8+3) cs_3in_a406(.a({ sum_1c6, c_1c6, sum_1c7}), .sum(sum_406), .cout(c_406) );
 carry_save_3inputs #(W+8+3) cs_3in_a407(.a({ sum_1c8, c_1c7, c_1c8  }), .sum(sum_407), .cout(c_407) );
 carry_save_3inputs #(W+8+3) cs_3in_a408(.a({ sum_1c9, c_1c9, sum_1d0}), .sum(sum_408), .cout(c_408) );
 carry_save_3inputs #(W+8+3) cs_3in_a409(.a({ sum_1d1, c_1d0, c_1d1  }), .sum(sum_409), .cout(c_409) );
 carry_save_3inputs #(W+8+3) cs_3in_a410(.a({ sum_1d2, c_1d2, sum_1d3}), .sum(sum_410), .cout(c_410) );
 carry_save_3inputs #(W+8+3) cs_3in_a411(.a({ sum_1d4, c_1d3, c_1d4  }), .sum(sum_411), .cout(c_411) );
 carry_save_3inputs #(W+8+3) cs_3in_a412(.a({ sum_1d5, c_1d5, sum_1d6}), .sum(sum_412), .cout(c_412) );
 carry_save_3inputs #(W+8+3) cs_3in_a413(.a({ sum_1d7, c_1d6, c_1d7  }), .sum(sum_413), .cout(c_413) );
 carry_save_3inputs #(W+8+3) cs_3in_a414(.a({ sum_1d8, c_1d8, sum_1d9}), .sum(sum_414), .cout(c_414) );
 carry_save_3inputs #(W+8+3) cs_3in_a415(.a({ sum_1e0, c_1d9, c_1e0  }), .sum(sum_415), .cout(c_415) );
 carry_save_3inputs #(W+8+3) cs_3in_a416(.a({ sum_1e1, c_1e1, sum_1e2}), .sum(sum_416), .cout(c_416) );
 carry_save_3inputs #(W+8+3) cs_3in_a417(.a({ sum_1e3, c_1e2, c_1e3  }), .sum(sum_417), .cout(c_417) );
 carry_save_3inputs #(W+8+3) cs_3in_a418(.a({ sum_1e4, c_1e4, sum_1e5}), .sum(sum_418), .cout(c_418) );
 carry_save_3inputs #(W+8+3) cs_3in_a419(.a({ sum_1e6, c_1e5, c_1e6  }), .sum(sum_419), .cout(c_419) );
 carry_save_3inputs #(W+8+3) cs_3in_a420(.a({ sum_1e7, c_1e7, sum_1e8}), .sum(sum_420), .cout(c_420) );
 carry_save_3inputs #(W+8+3) cs_3in_a421(.a({ sum_1e9, c_1e8, c_1e9  }), .sum(sum_421), .cout(c_421) );
 carry_save_3inputs #(W+8+3) cs_3in_a422(.a({ sum_1f0, c_1f0, sum_1f1}), .sum(sum_422), .cout(c_422) );
 carry_save_3inputs #(W+8+3) cs_3in_a423(.a({ sum_1f2, c_1f1, c_1f2  }), .sum(sum_423), .cout(c_423) );
 carry_save_3inputs #(W+8+3) cs_3in_a424(.a({ sum_1f3, c_1f3, sum_1f4}), .sum(sum_424), .cout(c_424) );
 carry_save_3inputs #(W+8+3) cs_3in_a425(.a({ sum_1f5, c_1f4, c_1f5  }), .sum(sum_425), .cout(c_425) );// sum_1f6, c_1f6 do not added
  

 carry_save_3inputs #(W+8+4) cs_3in_a331(.a({ sum_301, c_301, sum_302}),       .sum(sum_331), .cout(c_331) );
 carry_save_3inputs #(W+8+4) cs_3in_a332(.a({ c_302, sum_303, c_303  }),       .sum(sum_332), .cout(c_332) );
 carry_save_3inputs #(W+8+4) cs_3in_a333(.a({ sum_304, c_304, sum_305}),       .sum(sum_333), .cout(c_333) );
 carry_save_3inputs #(W+8+4) cs_3in_a334(.a({ c_305, sum_306, c_306  }),       .sum(sum_334), .cout(c_334) );
 carry_save_3inputs #(W+8+4) cs_3in_a335(.a({ sum_307, c_307, sum_308}),       .sum(sum_335), .cout(c_335) );
 carry_save_3inputs #(W+8+4) cs_3in_a336(.a({ c_308, sum_309, c_309  }),       .sum(sum_336), .cout(c_336) );
 carry_save_3inputs #(W+8+4) cs_3in_a337(.a({ sum_310, c_310, sum_311}),       .sum(sum_337), .cout(c_337) );
 carry_save_3inputs #(W+8+4) cs_3in_a338(.a({ c_311, sum_312, c_312  }),       .sum(sum_338), .cout(c_338) );
 carry_save_3inputs #(W+8+4) cs_3in_a339(.a({ sum_313, c_313, sum_314}),       .sum(sum_339), .cout(c_339) );
 carry_save_3inputs #(W+8+4) cs_3in_a340(.a({ c_314, sum_315, c_315  }),       .sum(sum_340), .cout(c_340) );
 carry_save_3inputs #(W+8+4) cs_3in_a341(.a({ sum_316, c_316, sum_317}),       .sum(sum_341), .cout(c_341) );
 carry_save_3inputs #(W+8+4) cs_3in_a342(.a({ c_317, sum_318, c_318  }),       .sum(sum_342), .cout(c_342) );
 carry_save_3inputs #(W+8+4) cs_3in_a343(.a({ sum_319, c_319, sum_320}),       .sum(sum_343), .cout(c_343) );
 carry_save_3inputs #(W+8+4) cs_3in_a344(.a({ c_320, sum_321, c_321  }),       .sum(sum_344), .cout(c_344) );
 carry_save_3inputs #(W+8+4) cs_3in_a345(.a({ sum_322, c_322, sum_323}),       .sum(sum_345), .cout(c_345) );
 carry_save_3inputs #(W+8+4) cs_3in_a346(.a({ c_323, sum_324, c_324  }),       .sum(sum_346), .cout(c_346) );
 carry_save_3inputs #(W+8+4) cs_3in_a347(.a({ sum_400, c_400, sum_401}),       .sum(sum_347), .cout(c_347) );
 carry_save_3inputs #(W+8+4) cs_3in_a430(.a({ c_401, sum_402, c_402  }),       .sum(sum_430), .cout(c_430) );
 carry_save_3inputs #(W+8+4) cs_3in_a431(.a({ sum_403, c_403, sum_404}),       .sum(sum_431), .cout(c_431) );
 carry_save_3inputs #(W+8+4) cs_3in_a432(.a({ c_404, sum_405, c_405  }),       .sum(sum_432), .cout(c_432) );
 carry_save_3inputs #(W+8+4) cs_3in_a433(.a({ sum_406, c_406, sum_407}),       .sum(sum_433), .cout(c_433) );
 carry_save_3inputs #(W+8+4) cs_3in_a434(.a({ c_407, sum_408, c_408  }),       .sum(sum_434), .cout(c_434) );
 carry_save_3inputs #(W+8+4) cs_3in_a435(.a({ sum_409, c_409, sum_410}),       .sum(sum_435), .cout(c_435) );
 carry_save_3inputs #(W+8+4) cs_3in_a436(.a({ c_410, sum_411, c_411  }),       .sum(sum_436), .cout(c_436) );
 carry_save_3inputs #(W+8+4) cs_3in_a437(.a({ sum_412, c_412, sum_413}),       .sum(sum_437), .cout(c_437) );
 carry_save_3inputs #(W+8+4) cs_3in_a438(.a({ c_413, sum_414, c_414  }),       .sum(sum_438), .cout(c_438) );
 carry_save_3inputs #(W+8+4) cs_3in_a439(.a({ sum_415, c_415, sum_416}),       .sum(sum_439), .cout(c_439) );
 carry_save_3inputs #(W+8+4) cs_3in_a440(.a({ c_416, sum_417, c_417  }),       .sum(sum_440), .cout(c_440) );
 carry_save_3inputs #(W+8+4) cs_3in_a441(.a({ sum_418, c_418, sum_419}),       .sum(sum_441), .cout(c_441) );
 carry_save_3inputs #(W+8+4) cs_3in_a442(.a({ c_419, sum_420, c_420  }),       .sum(sum_442), .cout(c_442) );
 carry_save_3inputs #(W+8+4) cs_3in_a443(.a({ sum_421, c_421, sum_422}),       .sum(sum_443), .cout(c_443) );
 carry_save_3inputs #(W+8+4) cs_3in_a444(.a({ c_422, sum_423, c_423  }),       .sum(sum_444), .cout(c_444) );
 carry_save_3inputs #(W+8+4) cs_3in_a445(.a({ sum_424, c_424, {sum_1f6[W+8+2],sum_1f6}}),.sum(sum_445), .cout(c_445) );
 carry_save_3inputs #(W+8+4) cs_3in_a446(.a({ sum_425, c_425, {c_1f6  [W+8+2],c_1f6} }), .sum(sum_446), .cout(c_446) );



 carry_save_3inputs #(W+8+5) cs_3in_a351(.a({ sum_331, c_331, sum_332}), .sum(sum_351), .cout(c_351) );
 carry_save_3inputs #(W+8+5) cs_3in_a352(.a({ c_332, c_333, sum_333  }), .sum(sum_352), .cout(c_352) );
 carry_save_3inputs #(W+8+5) cs_3in_a353(.a({ sum_334, c_334, sum_335}), .sum(sum_353), .cout(c_353) );
 carry_save_3inputs #(W+8+5) cs_3in_a354(.a({ c_335, c_336, sum_336  }), .sum(sum_354), .cout(c_354) );
 carry_save_3inputs #(W+8+5) cs_3in_a355(.a({ sum_337, c_337, sum_338}), .sum(sum_355), .cout(c_355) );
 carry_save_3inputs #(W+8+5) cs_3in_a356(.a({ c_338, c_339, sum_339  }), .sum(sum_356), .cout(c_356) );
 carry_save_3inputs #(W+8+5) cs_3in_a357(.a({ sum_340, c_340, sum_341}), .sum(sum_357), .cout(c_357) );
 carry_save_3inputs #(W+8+5) cs_3in_a358(.a({ c_341, c_342, sum_342  }), .sum(sum_358), .cout(c_358) );
 carry_save_3inputs #(W+8+5) cs_3in_a359(.a({ sum_343, c_343, sum_344}), .sum(sum_359), .cout(c_359) );
 carry_save_3inputs #(W+8+5) cs_3in_a360(.a({ c_344, c_345, sum_345  }), .sum(sum_360), .cout(c_360) );
 carry_save_3inputs #(W+8+5) cs_3in_a361(.a({ sum_346, c_346, sum_347}), .sum(sum_361), .cout(c_361) );
 carry_save_3inputs #(W+8+5) cs_3in_a450(.a({ c_347, c_430, sum_430  }), .sum(sum_450), .cout(c_450) );
 carry_save_3inputs #(W+8+5) cs_3in_a451(.a({ sum_431, c_431, sum_432}), .sum(sum_451), .cout(c_451) );
 carry_save_3inputs #(W+8+5) cs_3in_a452(.a({ c_432, c_433, sum_433  }), .sum(sum_452), .cout(c_452) );
 carry_save_3inputs #(W+8+5) cs_3in_a453(.a({ sum_434, c_434, sum_435}), .sum(sum_453), .cout(c_453) );
 carry_save_3inputs #(W+8+5) cs_3in_a454(.a({ c_435, c_436, sum_436  }), .sum(sum_454), .cout(c_454) );
 carry_save_3inputs #(W+8+5) cs_3in_a455(.a({ sum_437, c_437, sum_438}), .sum(sum_455), .cout(c_455) );
 carry_save_3inputs #(W+8+5) cs_3in_a456(.a({ c_438, c_439, sum_439  }), .sum(sum_456), .cout(c_456) );
 carry_save_3inputs #(W+8+5) cs_3in_a457(.a({ sum_440, c_440, sum_441}), .sum(sum_457), .cout(c_457) );
 carry_save_3inputs #(W+8+5) cs_3in_a458(.a({ c_441, c_442, sum_442  }), .sum(sum_458), .cout(c_458) );
 carry_save_3inputs #(W+8+5) cs_3in_a459(.a({ sum_443, c_443, sum_444}), .sum(sum_459), .cout(c_459) );
 carry_save_3inputs #(W+8+5) cs_3in_a45a(.a({ c_444, c_445, sum_445  }), .sum(sum_45a), .cout(c_45a) );// sum_446, c_446 do not added


 carry_save_3inputs #(W+8+6) cs_3in_a371(.a({ sum_351, c_351, sum_352            }), .sum(sum_371), .cout(c_371) ); 
 carry_save_3inputs #(W+8+6) cs_3in_a372(.a({ c_352, sum_353, c_353              }), .sum(sum_372), .cout(c_372) );
 carry_save_3inputs #(W+8+6) cs_3in_a373(.a({ sum_354, c_354, sum_355            }), .sum(sum_373), .cout(c_373) );
 carry_save_3inputs #(W+8+6) cs_3in_a374(.a({ c_355, sum_356, c_356              }), .sum(sum_374), .cout(c_374) );
 carry_save_3inputs #(W+8+6) cs_3in_a375(.a({ sum_357, c_357, sum_358            }), .sum(sum_375), .cout(c_375) );
 carry_save_3inputs #(W+8+6) cs_3in_a376(.a({ c_358, sum_359, c_359              }), .sum(sum_376), .cout(c_376) );
 carry_save_3inputs #(W+8+6) cs_3in_a377(.a({ sum_360, c_360, sum_361            }), .sum(sum_377), .cout(c_377) );
 carry_save_3inputs #(W+8+6) cs_3in_a460(.a({ c_361, sum_450, c_450              }), .sum(sum_460), .cout(c_460) );
 carry_save_3inputs #(W+8+6) cs_3in_a461(.a({ sum_451, c_451, sum_452            }), .sum(sum_461), .cout(c_461) );
 carry_save_3inputs #(W+8+6) cs_3in_a462(.a({ c_452, sum_453, c_453              }), .sum(sum_462), .cout(c_462) );
 carry_save_3inputs #(W+8+6) cs_3in_a463(.a({ sum_454, c_454, sum_455            }), .sum(sum_463), .cout(c_463) );
 carry_save_3inputs #(W+8+6) cs_3in_a464(.a({ c_455, sum_456, c_456              }), .sum(sum_464), .cout(c_464) );
 carry_save_3inputs #(W+8+6) cs_3in_a465(.a({ sum_457, c_457, sum_458            }), .sum(sum_465), .cout(c_465) );
 carry_save_3inputs #(W+8+6) cs_3in_a466(.a({ c_458, sum_459, c_459              }), .sum(sum_466), .cout(c_466) );
 carry_save_3inputs #(W+8+6) cs_3in_a467(.a({ sum_45a,{sum_446[W+8+4],sum_446},{c_446[W+8+4],c_446}}), .sum(sum_467), .cout(c_467) ); //c_45a  do not added


  
 carry_save_3inputs #(W+8+7) cs_3in_a381(.a({ sum_371, c_371, sum_372              }), .sum(sum_381), .cout(c_381) );
 carry_save_3inputs #(W+8+7) cs_3in_a382(.a({ c_372, sum_373, c_373                }), .sum(sum_382), .cout(c_382) );
 carry_save_3inputs #(W+8+7) cs_3in_a383(.a({ sum_374, c_374, sum_375              }), .sum(sum_383), .cout(c_383) );
 carry_save_3inputs #(W+8+7) cs_3in_a384(.a({ c_375, sum_376, c_376                }), .sum(sum_384), .cout(c_384) );
 carry_save_3inputs #(W+8+7) cs_3in_a385(.a({ sum_377, c_377, sum_460              }), .sum(sum_385), .cout(c_385) );
 carry_save_3inputs #(W+8+7) cs_3in_a470(.a({ c_460, sum_461, c_461                }), .sum(sum_470), .cout(c_470) );
 carry_save_3inputs #(W+8+7) cs_3in_a471(.a({ sum_462, c_462, sum_463              }), .sum(sum_471), .cout(c_471) );
 carry_save_3inputs #(W+8+7) cs_3in_a472(.a({ c_463, sum_464, c_464                }), .sum(sum_472), .cout(c_472) );
 carry_save_3inputs #(W+8+7) cs_3in_a473(.a({ sum_465, c_465, sum_466              }), .sum(sum_473), .cout(c_473) );
 carry_save_3inputs #(W+8+7) cs_3in_a474(.a({ sum_467, c_466, {c_45a[W+8+5],c_45a} }), .sum(sum_474), .cout(c_474) ); // c_467 do not added



 carry_save_3inputs #(W+8+8) cs_3in_a391(.a({ sum_381, c_381, sum_382              }), .sum(sum_391), .cout(c_391) );
 carry_save_3inputs #(W+8+8) cs_3in_a392(.a({ c_382, sum_383, c_383                }), .sum(sum_392), .cout(c_392) );
 carry_save_3inputs #(W+8+8) cs_3in_a393(.a({ sum_384, c_384, sum_385              }), .sum(sum_393), .cout(c_393) );
 carry_save_3inputs #(W+8+8) cs_3in_a480(.a({ c_385, sum_470, c_470                }), .sum(sum_480), .cout(c_480) );
 carry_save_3inputs #(W+8+8) cs_3in_a481(.a({ sum_471, c_471, sum_472              }), .sum(sum_481), .cout(c_481) );
 carry_save_3inputs #(W+8+8) cs_3in_a482(.a({ c_472, sum_473, c_473                }), .sum(sum_482), .cout(c_482) );
 carry_save_3inputs #(W+8+8) cs_3in_a483(.a({ sum_474, c_474, {c_467[W+8+6],c_467} }), .sum(sum_483), .cout(c_483) );


 carry_save_3inputs #(W+8+9) cs_3in_a490(.a({ sum_391, c_391, sum_392 }), .sum(sum_490), .cout(c_490) );
 carry_save_3inputs #(W+8+9) cs_3in_a491(.a({ c_392, sum_393, c_393   }), .sum(sum_491), .cout(c_491) );
 carry_save_3inputs #(W+8+9) cs_3in_a492(.a({ sum_480, c_480, sum_481 }), .sum(sum_492), .cout(c_492) );
 carry_save_3inputs #(W+8+9) cs_3in_a493(.a({ c_481, sum_482, c_482   }), .sum(sum_493), .cout(c_493) ); // sum_483, c_483 

carry_save_10inputs #(W+8+10) cs_8in (.a({ sum_490, sum_491, sum_492, sum_493, c_490, c_491, c_492, c_493, {sum_483[W+8+8],sum_483}, {c_483[W+8+8],c_483} }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+8  :0];
assign sum  = sum5 [W+8  :0];


endmodule

////////////////////////////////////
// Carry Save 1024 inputs 
////////////////////////////////////

module carry_save_1024inputs #(
    parameter W      = 4  //    input data width
)
(a, sum, cout);
input  [1024*W-1:0] a; //, b,c,d;
output [W+9  :0] sum;
output [W+9  :0] cout;

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
wire [W:0] sum255, c255, sum258, c258, sum261, c261, sum264, c264, sum267, c267, sum270, c270, sum273, c273, sum276, c276;  
wire [W:0] sum279, c279, sum282, c282, sum285, c285, sum288, c288, sum291, c291, sum294, c294, sum297, c297, sum300, c300;  
wire [W:0] sum303, c303, sum306, c306, sum309, c309, sum312, c312, sum315, c315, sum318, c318, sum321, c321, sum324, c324;  
wire [W:0] sum327, c327, sum330, c330, sum333, c333, sum336, c336, sum339, c339, sum342, c342, sum345, c345, sum348, c348;  
wire [W:0] sum351, c351, sum354, c354, sum357, c357, sum360, c360, sum363, c363, sum366, c366, sum369, c369, sum372, c372; 
wire [W:0] sum375, c375, sum378, c378, sum381, c381, sum384, c384, sum387, c387, sum390, c390, sum393, c393, sum396, c396;  
wire [W:0] sum399, c399, sum402, c402, sum405, c405, sum408, c408, sum411, c411, sum414, c414, sum417, c417, sum420, c420;  
wire [W:0] sum423, c423, sum426, c426, sum429, c429, sum432, c432, sum435, c435, sum438, c438, sum441, c441, sum444, c444;  
wire [W:0] sum447, c447, sum450, c450, sum453, c453, sum456, c456, sum459, c459, sum462, c462, sum465, c465, sum468, c468;  
wire [W:0] sum471, c471, sum474, c474, sum477, c477, sum480, c480, sum483, c483, sum486, c486, sum489, c489, sum492, c492;  
wire [W:0] sum495, c495, sum498, c498,  sum501, c501, sum504, c504, sum507, c507; 
wire [W:0] sum510, c510,sum513, c513,sum516, c516,sum519, c519,sum522, c522,sum525, c525,sum528, c528,sum531, c531,sum534, c534,sum537, c537,sum540, c540;
wire [W:0] sum543, c543,sum546, c546,sum549, c549,sum552, c552,sum555, c555,sum558, c558,sum561, c561,sum564, c564,sum567, c567,sum570, c570,sum573, c573;
wire [W:0] sum576, c576,sum579, c579,sum582, c582,sum585, c585,sum588, c588,sum591, c591,sum594, c594,sum597, c597,sum600, c600,sum603, c603,sum606, c606;
wire [W:0] sum609, c609,sum612, c612,sum615, c615,sum618, c618,sum621, c621,sum624, c624,sum627, c627,sum630, c630,sum633, c633,sum636, c636,sum639, c639;
wire [W:0] sum642, c642,sum645, c645,sum648, c648,sum651, c651,sum654, c654,sum657, c657,sum660, c660,sum663, c663,sum666, c666,sum669, c669,sum672, c672;
wire [W:0] sum675, c675,sum678, c678,sum681, c681,sum684, c684,sum687, c687,sum690, c690,sum693, c693,sum696, c696,sum699, c699,sum702, c702,sum705, c705;
wire [W:0] sum708, c708,sum711, c711,sum714, c714,sum717, c717,sum720, c720,sum723, c723,sum726, c726,sum729, c729,sum732, c732,sum735, c735,sum738, c738;
wire [W:0] sum741, c741,sum744, c744,sum747, c747,sum750, c750,sum753, c753,sum756, c756,sum759, c759,sum762, c762,sum765, c765,sum768, c768,sum771, c771;
wire [W:0] sum774, c774,sum777, c777,sum780, c780,sum783, c783,sum786, c786,sum789, c789,sum792, c792,sum795, c795,sum798, c798,sum801, c801,sum804, c804;
wire [W:0] sum807, c807,sum810, c810,sum813, c813,sum816, c816,sum819, c819,sum822, c822,sum825, c825,sum828, c828,sum831, c831,sum834, c834,sum837, c837;
wire [W:0] sum840, c840,sum843, c843,sum846, c846,sum849, c849,sum852, c852,sum855, c855,sum858, c858,sum861, c861,sum864, c864,sum867, c867,sum870, c870;
wire [W:0] sum873, c873,sum876, c876,sum879, c879,sum882, c882,sum885, c885,sum888, c888,sum891, c891,sum894, c894,sum897, c897,sum900, c900,sum903, c903;
wire [W:0] sum906, c906,sum909, c909,sum912, c912,sum915, c915,sum918, c918,sum921, c921,sum924, c924,sum927, c927,sum930, c930,sum933, c933,sum936, c936;
wire [W:0] sum939, c939,sum942, c942,sum945, c945,sum948, c948,sum951, c951,sum954, c954,sum957, c957,sum960, c960,sum963, c963,sum966, c966,sum969, c969;
wire [W:0] sum972, c972,sum975, c975,sum978, c978,sum981, c981,sum984, c984,sum987, c987,sum990, c990,sum993, c993,sum996, c996,sum999, c999,sum1002, c1002;
wire [W:0] sum1005, c1005,sum1008, c1008,sum1011, c1011,sum1014, c1014,sum1017, c1017,sum1020, c1020;


wire [W+1:0] sum_01, c_01, sum_02, c_02, sum_03, c_03, sum_04, c_04, sum_05, c_05, sum_06, c_06, sum_07, c_07, sum_08, c_08;
wire [W+1:0] sum_09, c_09, sum_10, c_10, sum_11, c_11, sum_12, c_12, sum_13, c_13, sum_14, c_14, sum_15, c_15, sum_16, c_16;
wire [W+1:0] sum_17, c_17, sum_18, c_18, sum_19, c_19, sum_20, c_20, sum_21, c_21, sum_22, c_22, sum_23, c_23, sum_24, c_24;
wire [W+1:0] sum_25, c_25, sum_26, c_26, sum_27, c_27, sum_28, c_28;
wire [W+1:0] sum_29, c_29, sum_30, c_30, sum_31, c_31, sum_32, c_32, sum_33, c_33, sum_34, c_34, sum_35, c_35, sum_36, c_36;
wire [W+1:0] sum_37, c_37, sum_38, c_38, sum_39, c_39, sum_40, c_40, sum_41, c_41, sum_42, c_42, sum_43, c_43, sum_44, c_44;
wire [W+1:0] sum_45, c_45, sum_46, c_46, sum_47, c_47, sum_48, c_48, sum_49, c_49, sum_50, c_50, sum_51, c_51, sum_52, c_52;
wire [W+1:0] sum_53, c_53, sum_54, c_54, sum_55, c_55, sum_56, c_56, sum_57, c_57;
wire [W+1:0] sum_58, c_58, sum_59, c_59, sum_60, c_60, sum_61, c_61, sum_62, c_62, sum_63, c_63, sum_64, c_64, sum_65, c_65;
wire [W+1:0] sum_66, c_66, sum_67, c_67, sum_68, c_68, sum_69, c_69, sum_70, c_70, sum_71, c_71, sum_72, c_72, sum_73, c_73;
wire [W+1:0] sum_74, c_74, sum_75, c_75, sum_76, c_76, sum_77, c_77, sum_78, c_78, sum_79, c_79, sum_80, c_80, sum_81, c_81;
wire [W+1:0] sum_82, c_82, sum_83, c_83, sum_84, c_84, sum_85, c_85, sum_86, c_86, sum_87, c_87, sum_88, c_88, sum_89, c_89;
wire [W+1:0] sum_90, c_90, sum_91, c_91, sum_92, c_92, sum_93, c_93, sum_94, c_94, sum_95, c_95, sum_96, c_96, sum_97, c_97;
wire [W+1:0] sum_98, c_98, sum_99, c_99, sum_a0, c_a0, sum_a1, c_a1, sum_a2, c_a2, sum_a3, c_a3, sum_a4, c_a4, sum_a5, c_a5;
wire [W+1:0] sum_a6, c_a6, sum_a7, c_a7, sum_a8, c_a8, sum_a9, c_a9, sum_b0, c_b0, sum_b1, c_b1, sum_b2, c_b2, sum_b3, c_b3, sum_b4, c_b4; 
wire [W+1:0] sum_b5, c_b5,sum_b6, c_b6,sum_b7, c_b7,sum_b8, c_b8,sum_b9, c_b9,sum_c0, c_c0,sum_c1, c_c1,sum_c2, c_c2,sum_c3, c_c3,sum_c4, c_c4,sum_c5, c_c5,sum_c6, c_c6;
wire [W+1:0] sum_c7, c_c7,sum_c8, c_c8,sum_c9, c_c9,sum_d0, c_d0,sum_d1, c_d1,sum_d2, c_d2,sum_d3, c_d3,sum_d4, c_d4,sum_d5, c_d5,sum_d6, c_d6,sum_d7, c_d7;
wire [W+1:0] sum_d8, c_d8,sum_d9, c_d9,sum_e0, c_e0,sum_e1, c_e1,sum_e2, c_e2,sum_e3, c_e3,sum_e4, c_e4,sum_e5, c_e5,sum_e6, c_e6,sum_e7, c_e7,sum_e8, c_e8;
wire [W+1:0] sum_e9, c_e9,sum_f0, c_f0,sum_f1, c_f1,sum_f2, c_f2,sum_f3, c_f3,sum_f4, c_f4,sum_f5, c_f5,sum_f6, c_f6,sum_f7, c_f7,sum_f8, c_f8,sum_f9, c_f9;
wire [W+1:0] sum_g0, c_g0,sum_g1, c_g1,sum_g2, c_g2,sum_g3, c_g3,sum_g4, c_g4,sum_g5, c_g5,sum_g6, c_g6,sum_g7, c_g7,sum_g8, c_g8,sum_g9, c_g9,sum_h0, c_h0;
wire [W+1:0] sum_h1, c_h1,sum_h2, c_h2,sum_h3, c_h3,sum_h4, c_h4,sum_h5, c_h5,sum_h6, c_h6,sum_h7, c_h7,sum_h8, c_h8,sum_h9, c_h9,sum_i0, c_i0,sum_i1, c_i1;
wire [W+1:0] sum_i2, c_i2,sum_i3, c_i3,sum_i4, c_i4,sum_i5, c_i5,sum_i6, c_i6,sum_i7, c_i7,sum_i8, c_i8,sum_i9, c_i9,sum_j0, c_j0,sum_j1, c_j1,sum_j2, c_j2;
wire [W+1:0] sum_j3, c_j3,sum_j4, c_j4,sum_j5, c_j5,sum_j6, c_j6,sum_j7, c_j7,sum_j8, c_j8,sum_j9, c_j9,sum_k0, c_k0,sum_k1, c_k1,sum_k2, c_k2,sum_k3, c_k3;
wire [W+1:0] sum_k4, c_k4,sum_k5, c_k5,sum_k6, c_k6,sum_k7, c_k7,sum_k8, c_k8,sum_k9, c_k9,sum_l0, c_l0,sum_l1, c_l1,sum_l2, c_l2,sum_l3, c_l3,sum_l4, c_l4;
wire [W+1:0] sum_l5, c_l5,sum_l6, c_l6,sum_l7, c_l7,sum_l8, c_l8,sum_l9, c_l9,sum_m0, c_m0,sum_m1, c_m1,sum_m2, c_m2,sum_m3, c_m3,sum_m4, c_m4,sum_m5, c_m5;
wire [W+1:0] sum_m6, c_m6,sum_m7, c_m7;

wire [W+2:0] sum_161, c_161, sum_162, c_162, sum_163, c_163, sum_164, c_164, sum_165, c_165, sum_166, c_166, sum_167, c_167, sum_168, c_168; 
wire [W+2:0] sum_169, c_169, sum_170, c_170, sum_171, c_171, sum_172, c_172, sum_173, c_173, sum_174, c_174, sum_175, c_175, sum_176, c_176; 
wire [W+2:0] sum_177, c_177, sum_178, c_178, sum_179, c_179, sum_180, c_180, sum_181, c_181, sum_182, c_182, sum_183, c_183, sum_184, c_184; 
wire [W+2:0] sum_185, c_185, sum_186, c_186, sum_187, c_187, sum_188, c_188, sum_189, c_189, sum_190, c_190, sum_191, c_191, sum_192, c_192; 
wire [W+2:0] sum_193, c_193, sum_194, c_194, sum_195, c_195, sum_196, c_196, sum_197, c_197, sum_198, c_198;
wire [W+2:0] sum_199, c_199, sum_1c0, c_1c0, sum_1c1, c_1c1, sum_1c2, c_1c2, sum_1c3, c_1c3, sum_1c4, c_1c4, sum_1c5, c_1c5, sum_1c6, c_1c6;
wire [W+2:0] sum_1c7, c_1c7, sum_1c8, c_1c8, sum_1c9, c_1c9, sum_1d0, c_1d0, sum_1d1, c_1d1, sum_1d2, c_1d2, sum_1d3, c_1d3, sum_1d4, c_1d4;
wire [W+2:0] sum_1d5, c_1d5, sum_1d6, c_1d6, sum_1d7, c_1d7, sum_1d8, c_1d8, sum_1d9, c_1d9, sum_1e0, c_1e0, sum_1e1, c_1e1, sum_1e2, c_1e2;
wire [W+2:0] sum_1e3, c_1e3, sum_1e4, c_1e4, sum_1e5, c_1e5, sum_1e6, c_1e6, sum_1e7, c_1e7, sum_1e8, c_1e8, sum_1e9, c_1e9, sum_1f0, c_1f0;
wire [W+2:0] sum_1f1, c_1f1, sum_1f2, c_1f2, sum_1f3, c_1f3, sum_1f4, c_1f4, sum_1f5, c_1f5, sum_1f6, c_1f6;
wire [W+2:0] sum_1f7, c_1f7, sum_1f8, c_1f8, sum_1f9, c_1f9, sum_1g0, c_1g0, sum_1g1, c_1g1, sum_1g2, c_1g2, sum_1g3, c_1g3, sum_1g4, c_1g4, sum_1g5, c_1g5, sum_1g6, c_1g6, sum_1g7, c_1g7;
wire [W+2:0] sum_1g8, c_1g8, sum_1g9, c_1g9, sum_1h0, c_1h0, sum_1h1, c_1h1, sum_1h2, c_1h2, sum_1h3, c_1h3, sum_1h4, c_1h4, sum_1h5, c_1h5, sum_1h6, c_1h6, sum_1h7, c_1h7, sum_1h8, c_1h8;
wire [W+2:0] sum_1h9, c_1h9, sum_1i0, c_1i0, sum_1i1, c_1i1, sum_1i2, c_1i2, sum_1i3, c_1i3, sum_1i4, c_1i4, sum_1i5, c_1i5, sum_1i6, c_1i6, sum_1i7, c_1i7, sum_1i8, c_1i8, sum_1i9, c_1i9;
wire [W+2:0] sum_1j0, c_1j0, sum_1j1, c_1j1, sum_1j2, c_1j2, sum_1j3, c_1j3, sum_1j4, c_1j4, sum_1j5, c_1j5, sum_1j6, c_1j6, sum_1j7, c_1j7, sum_1j8, c_1j8, sum_1j9, c_1j9, sum_1k0, c_1k0;
wire [W+2:0] sum_1k1, c_1k1, sum_1k2, c_1k2, sum_1k3, c_1k3, sum_1k4, c_1k4, sum_1k5, c_1k5, sum_1k6, c_1k6, sum_1k7, c_1k7, sum_1k8, c_1k8, sum_1k9, c_1k9, sum_1l0, c_1l0, sum_1l1, c_1l1;
wire [W+2:0] sum_1l2, c_1l2, sum_1l3, c_1l3, sum_1l4, c_1l4, sum_1l5, c_1l5, sum_1l6, c_1l6, sum_1l7, c_1l7, sum_1l8, c_1l8, sum_1l9, c_1l9, sum_1m0, c_1m0, sum_1m1, c_1m1, sum_1m2, c_1m2;
wire [W+2:0] sum_1m3, c_1m3, sum_1m4, c_1m4, sum_1m5, c_1m5, sum_1m6, c_1m6, sum_1m7, c_1m7, sum_1m8, c_1m8, sum_1m9, c_1m9, sum_1n0, c_1n0, sum_1n1, c_1n1, sum_1n2, c_1n2;

// sum_a426 c_a476
wire [W+3:0] sum_301, c_301, sum_302, c_302, sum_303, c_303, sum_304, c_304, sum_305, c_305, sum_306, c_306, sum_307, c_307, sum_308, c_308; 
wire [W+3:0] sum_309, c_309, sum_310, c_310, sum_311, c_311, sum_312, c_312, sum_313, c_313, sum_314, c_314, sum_315, c_315, sum_316, c_316;
wire [W+3:0] sum_317, c_317, sum_318, c_318, sum_319, c_319, sum_320, c_320, sum_321, c_321, sum_322, c_322, sum_323, c_323, sum_324, c_324;
wire [W+3:0] sum_400, c_400, sum_401, c_401, sum_402, c_402, sum_403, c_403, sum_404, c_404, sum_405, c_405, sum_406, c_406, sum_407, c_407; 
wire [W+3:0] sum_408, c_408, sum_409, c_409, sum_410, c_410, sum_411, c_411, sum_412, c_412, sum_413, c_413, sum_414, c_414, sum_415, c_415, sum_425, c_425;
wire [W+3:0] sum_416, c_416, sum_417, c_417, sum_418, c_418, sum_419, c_419, sum_420, c_420, sum_421, c_421, sum_422, c_422, sum_423, c_423, sum_424, c_424; 
wire [W+3:0] sum_a426, c_a426, sum_a427, c_a427, sum_a428, c_a428, sum_a429, c_a429, sum_a430, c_a430, sum_a431, c_a431, sum_a432, c_a432, sum_a433, c_a433, sum_a434, c_a434, sum_a435, c_a435, sum_a436, c_a436;
wire [W+3:0] sum_a437, c_a437, sum_a438, c_a438, sum_a439, c_a439, sum_a440, c_a440, sum_a441, c_a441, sum_a442, c_a442, sum_a443, c_a443, sum_a444, c_a444, sum_a445, c_a445, sum_a446, c_a446, sum_a447, c_a447;
wire [W+3:0] sum_a448, c_a448, sum_a449, c_a449, sum_a450, c_a450, sum_a451, c_a451, sum_a452, c_a452, sum_a453, c_a453, sum_a454, c_a454, sum_a455, c_a455, sum_a456, c_a456, sum_a457, c_a457, sum_a458, c_a458;
wire [W+3:0] sum_a459, c_a459, sum_a460, c_a460, sum_a461, c_a461, sum_a462, c_a462, sum_a463, c_a463, sum_a464, c_a464, sum_a465, c_a465, sum_a466, c_a466, sum_a467, c_a467, sum_a468, c_a468, sum_a469, c_a469;
wire [W+3:0] sum_a470, c_a470, sum_a471, c_a471, sum_a472, c_a472, sum_a473, c_a473, sum_a474, c_a474, sum_a475, c_a475, sum_a476, c_a476;

//sum_b457 c_b479
wire [W+4:0] sum_331, c_331, sum_332, c_332, sum_333, c_333, sum_334, c_334, sum_335, c_335, sum_336, c_336, sum_337, c_337, sum_338, c_338;
wire [W+4:0] sum_339, c_339, sum_340, c_340, sum_341, c_341, sum_342, c_342, sum_343, c_343, sum_344, c_344, sum_345, c_345, sum_346, c_346, sum_347, c_347; 
wire [W+4:0] sum_430, c_430, sum_431, c_431, sum_432, c_432, sum_433, c_433, sum_434, c_434, sum_435, c_435, sum_436, c_436, sum_437, c_437;
wire [W+4:0] sum_438, c_438, sum_439, c_439, sum_440, c_440, sum_441, c_441, sum_442, c_442, sum_443, c_443, sum_444, c_444, sum_445, c_445, sum_446, c_446;
wire [W+4:0] sum_b447, c_b447, sum_b448, c_b448, sum_b449, c_b449, sum_b450, c_b450, sum_b451, c_b451, sum_b452, c_b452, sum_b453, c_b453, sum_b454, c_b454, sum_b455, c_b455, sum_b456, c_b456;
wire [W+4:0] sum_b457, c_b457, sum_b458, c_b458, sum_b459, c_b459, sum_b460, c_b460, sum_b461, c_b461, sum_b462, c_b462, sum_b463, c_b463, sum_b464, c_b464, sum_b465, c_b465, sum_b466, c_b466, sum_b467, c_b467;
wire [W+4:0] sum_b468, c_b468, sum_b469, c_b469, sum_b470, c_b470, sum_b471, c_b471, sum_b472, c_b472, sum_b473, c_b473, sum_b474, c_b474, sum_b475, c_b475, sum_b476, c_b476, sum_b477, c_b477, sum_b478, c_b478;
wire [W+4:0] sum_b479, c_b479;

// sum_b460 c_b482 - c
wire [W+5:0] sum_351, c_351, sum_352, c_352, sum_353, c_353, sum_354, c_354, sum_355, c_355, sum_356, c_356, sum_357, c_357, sum_358, c_358;
wire [W+5:0] sum_359, c_359, sum_360, c_360, sum_361, c_361;
wire [W+5:0] sum_450, c_450, sum_451, c_451, sum_452, c_452, sum_453, c_453, sum_454, c_454, sum_455, c_455, sum_456, c_456, sum_457, c_457;
wire [W+5:0] sum_458, c_458, sum_459, c_459, sum_45a, c_45a;
wire [W+5:0] sum_c460, c_c460, sum_c461, c_c461, sum_c462, c_c462, sum_c463, c_c463, sum_c464, c_c464, sum_c465, c_c465, sum_c466, c_c466, sum_c467, c_c467, sum_c468, c_c468, sum_c469, c_c469, sum_c470, c_c470; 
wire [W+5:0] sum_c471, c_c471, sum_c472, c_c472, sum_c473, c_c473, sum_c474, c_c474, sum_c475, c_c475, sum_c476, c_c476, sum_c477, c_c477, sum_c478, c_c478, sum_c479, c_c479, sum_c480, c_c480, sum_c481, c_c481;
wire [W+5:0] sum_c482, c_c482; 

// sum_b478 c_b492 - d
wire [W+6:0] sum_371, c_371, sum_372, c_372, sum_373, c_373, sum_374, c_374, sum_375, c_375, sum_376, c_376, sum_377, c_377; 
wire [W+6:0] sum_460, c_460, sum_461, c_461, sum_462, c_462, sum_463, c_463, sum_464, c_464, sum_465, c_465, sum_466, c_466, sum_467, c_467;
wire [W+6:0] sum_d478, c_d478, sum_d479, c_d479, sum_d480, c_d480, sum_d481, c_d481, sum_d482, c_d482, sum_d483, c_d483, sum_d484, c_d484, sum_d485, c_d485, sum_d486, c_d486;
wire [W+6:0] sum_d487, c_d487, sum_d488, c_d488, sum_d489, c_d489, sum_d490, c_d490, sum_d491, c_d491, sum_d492, c_d492;

// sum_b475 c_b484 - e
wire [W+7:0] sum_381, c_381, sum_382, c_382, sum_383, c_383, sum_384, c_384, sum_385, c_385; 
wire [W+7:0] sum_470, c_470, sum_471, c_471, sum_472, c_472, sum_473, c_473, sum_474, c_474;
wire [W+7:0] sum_e475, c_e475, sum_e476, c_e476, sum_e477, c_e477, sum_e478, c_e478, sum_e479, c_e479;
wire [W+7:0] sum_e480, c_e480, sum_e481, c_e481, sum_e482, c_e482, sum_e483, c_e483, sum_e484, c_e484;

// sum_b484 c_b490
wire [W+8:0] sum_391, c_391, sum_392, c_392, sum_393, c_393; 
wire [W+8:0] sum_480, c_480, sum_481, c_481, sum_482, c_482, sum_483, c_483;
wire [W+8:0] sum_b484, c_b484,sum_b485, c_b485,sum_b486, c_b486,sum_b487, c_b487;
wire [W+8:0] sum_b488, c_b488,sum_b489, c_b489,sum_b490, c_b490;

// sum_b494 c_b498
wire [W+9:0] sum_490, c_490, sum_491, c_491, sum_492, c_492, sum_493, c_493;
wire [W+9:0] sum_b494, c_b494, sum_b495, c_b495, sum_b496, c_b496, sum_b497, c_b497, sum_b498, c_b498;

// sum_b450 - c_b455
wire [W+10:0] sum_b50, c_b50, sum_b51, c_b51, sum_b52, c_b52, sum_b53, c_b53, sum_b54, c_b54, sum_b55, c_b55;

// sum_b456 - c_b459
wire [W+11:0] sum_b56, c_b56, sum_b57, c_b57, sum_b58, c_b58, sum_b59, c_b59;   

wire [W+14:0] sum5, cout5;

wire [W+14:0]  test_in, test_1_stage, test_2_stage, test_3_stage, test_4_stage, test_5_stage, test_6_stage, test_7_stage, test_8_stage, test_9_stage, test_A_stage, test_B_stage, test_C_stage, test_preout, test_out;
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
                 a[250*W +: W] + a[251*W +: W] + a[252*W +: W] + a[253*W +: W] + a[254*W +: W] + a[255*W +: W] + a[256*W +: W] + a[257*W +: W] + a[258*W +: W] + a[259*W +: W] +
                 a[260*W +: W] + a[261*W +: W] + a[262*W +: W] + a[263*W +: W] + a[264*W +: W] + a[265*W +: W] + a[266*W +: W] + a[267*W +: W] + a[268*W +: W] + a[269*W +: W] +
                 a[270*W +: W] + a[271*W +: W] + a[272*W +: W] + a[273*W +: W] + a[274*W +: W] + a[275*W +: W] + a[276*W +: W] + a[277*W +: W] + a[278*W +: W] + a[279*W +: W] +
                 a[280*W +: W] + a[281*W +: W] + a[282*W +: W] + a[283*W +: W] + a[284*W +: W] + a[285*W +: W] + a[286*W +: W] + a[287*W +: W] + a[288*W +: W] + a[289*W +: W] +
                 a[290*W +: W] + a[291*W +: W] + a[292*W +: W] + a[293*W +: W] + a[294*W +: W] + a[295*W +: W] + a[296*W +: W] + a[297*W +: W] + a[298*W +: W] + a[299*W +: W] +
                 a[300*W +: W] + a[301*W +: W] + a[302*W +: W] + a[303*W +: W] + a[304*W +: W] + a[305*W +: W] + a[306*W +: W] + a[307*W +: W] + a[308*W +: W] + a[309*W +: W] +
                 a[310*W +: W] + a[311*W +: W] + a[312*W +: W] + a[313*W +: W] + a[314*W +: W] + a[315*W +: W] + a[316*W +: W] + a[317*W +: W] + a[318*W +: W] + a[319*W +: W] +
                 a[320*W +: W] + a[321*W +: W] + a[322*W +: W] + a[323*W +: W] + a[324*W +: W] + a[325*W +: W] + a[326*W +: W] + a[327*W +: W] + a[328*W +: W] + a[329*W +: W] +
                 a[330*W +: W] + a[331*W +: W] + a[332*W +: W] + a[333*W +: W] + a[334*W +: W] + a[335*W +: W] + a[336*W +: W] + a[337*W +: W] + a[338*W +: W] + a[339*W +: W] +
                 a[340*W +: W] + a[341*W +: W] + a[342*W +: W] + a[343*W +: W] + a[344*W +: W] + a[345*W +: W] + a[346*W +: W] + a[347*W +: W] + a[348*W +: W] + a[349*W +: W] +
                 a[350*W +: W] + a[351*W +: W] + a[352*W +: W] + a[353*W +: W] + a[354*W +: W] + a[355*W +: W] + a[356*W +: W] + a[357*W +: W] + a[358*W +: W] + a[359*W +: W] +
                 a[360*W +: W] + a[361*W +: W] + a[362*W +: W] + a[363*W +: W] + a[364*W +: W] + a[365*W +: W] + a[366*W +: W] + a[367*W +: W] + a[368*W +: W] + a[369*W +: W] +
                 a[370*W +: W] + a[371*W +: W] + a[372*W +: W] + a[373*W +: W] + a[374*W +: W] + a[375*W +: W] + a[376*W +: W] + a[377*W +: W] + a[378*W +: W] + a[379*W +: W] +
                 a[380*W +: W] + a[381*W +: W] + a[382*W +: W] + a[383*W +: W] + a[384*W +: W] + a[385*W +: W] + a[386*W +: W] + a[387*W +: W] + a[388*W +: W] + a[389*W +: W] +
                 a[390*W +: W] + a[391*W +: W] + a[392*W +: W] + a[393*W +: W] + a[394*W +: W] + a[395*W +: W] + a[396*W +: W] + a[397*W +: W] + a[398*W +: W] + a[399*W +: W] +
                 a[400*W +: W] + a[401*W +: W] + a[402*W +: W] + a[403*W +: W] + a[404*W +: W] + a[405*W +: W] + a[406*W +: W] + a[407*W +: W] + a[408*W +: W] + a[409*W +: W] +
                 a[410*W +: W] + a[411*W +: W] + a[412*W +: W] + a[413*W +: W] + a[414*W +: W] + a[415*W +: W] + a[416*W +: W] + a[417*W +: W] + a[418*W +: W] + a[419*W +: W] +
                 a[420*W +: W] + a[421*W +: W] + a[422*W +: W] + a[423*W +: W] + a[424*W +: W] + a[425*W +: W] + a[426*W +: W] + a[427*W +: W] + a[428*W +: W] + a[429*W +: W] +
                 a[430*W +: W] + a[431*W +: W] + a[432*W +: W] + a[433*W +: W] + a[434*W +: W] + a[435*W +: W] + a[436*W +: W] + a[437*W +: W] + a[438*W +: W] + a[439*W +: W] +
                 a[440*W +: W] + a[441*W +: W] + a[442*W +: W] + a[443*W +: W] + a[444*W +: W] + a[445*W +: W] + a[446*W +: W] + a[447*W +: W] + a[448*W +: W] + a[449*W +: W] +
                 a[450*W +: W] + a[451*W +: W] + a[452*W +: W] + a[453*W +: W] + a[454*W +: W] + a[455*W +: W] + a[456*W +: W] + a[457*W +: W] + a[458*W +: W] + a[459*W +: W] +
                 a[460*W +: W] + a[461*W +: W] + a[462*W +: W] + a[463*W +: W] + a[464*W +: W] + a[465*W +: W] + a[466*W +: W] + a[467*W +: W] + a[468*W +: W] + a[469*W +: W] +
                 a[470*W +: W] + a[471*W +: W] + a[472*W +: W] + a[473*W +: W] + a[474*W +: W] + a[475*W +: W] + a[476*W +: W] + a[477*W +: W] + a[478*W +: W] + a[479*W +: W] +
                 a[480*W +: W] + a[481*W +: W] + a[482*W +: W] + a[483*W +: W] + a[484*W +: W] + a[485*W +: W] + a[486*W +: W] + a[487*W +: W] + a[488*W +: W] + a[489*W +: W] +
                 a[490*W +: W] + a[491*W +: W] + a[492*W +: W] + a[493*W +: W] + a[494*W +: W] + a[495*W +: W] + a[496*W +: W] + a[497*W +: W] + a[498*W +: W] + a[499*W +: W] +
                 a[500*W +: W] + a[501*W +: W] + a[502*W +: W] + a[503*W +: W] + a[504*W +: W] + a[505*W +: W] + a[506*W +: W] + a[507*W +: W] + a[508*W +: W] + a[509*W +: W] +
                 a[510*W +: W] + a[511*W +: W] ;

assign test_1_stage = 
         sum000 + c000 + sum003 + c003 + sum006 + c006 + sum009 + c009 + sum012 + c012 + sum015 + c015 + sum018 + c018 + sum021 + c021 +                  a[1023*W +: W] +
         sum024 + c024 + sum027 + c027 + sum030 + c030 + sum033 + c033 + sum036 + c036 + sum039 + c039 + sum042 + c042 + sum045 + c045 + 
         sum048 + c048 + sum051 + c051 + sum054 + c054 + sum057 + c057 + sum060 + c060 + sum063 + c063 + sum066 + c066 + sum069 + c069 + 
         sum072 + c072 + sum075 + c075 + sum078 + c078 + sum081 + c081 + sum084 + c084 + sum087 + c087 + sum090 + c090 + sum093 + c093 + 
         sum096 + c096 + sum099 + c099 + sum102 + c102 + sum105 + c105 + sum108 + c108 + sum111 + c111 + sum114 + c114 + sum117 + c117 + sum120 + c120 + sum123 + c123+
         sum126 + c126 + sum129 + c129 + sum132 + c132 + sum135 + c135 + sum138 + c138 + sum141 + c141 + sum144 + c144 + sum147 + c147 +
         sum150 + c150 + sum153 + c153 + sum156 + c156 + sum159 + c159 + sum162 + c162 + sum165 + c165 + sum168 + c168 + sum171 + c171 +
         sum174 + c174 + sum177 + c177 + sum180 + c180 + sum183 + c183 + sum186 + c186 + sum189 + c189 + sum192 + c192 + sum195 + c195 +
         sum198 + c198 + sum201 + c201 + sum204 + c204 + sum207 + c207 + sum210 + c210 + sum213 + c213 + sum216 + c216 + sum219 + c219 +
         sum222 + c222 + sum225 + c225 + sum228 + c228 + sum231 + c231 + sum234 + c234 + sum237 + c237 + sum240 + c240 + sum243 + c243 + sum246 + c246 + sum249 + c249 + sum252 + c252 + 
         sum255 + c255 + sum258 + c258 + sum261 + c261 + sum264 + c264 + sum267 + c267 + sum270 + c270 + sum273 + c273 + sum276 + c276 +  
         sum279 + c279 + sum282 + c282 + sum285 + c285 + sum288 + c288 + sum291 + c291 + sum294 + c294 + sum297 + c297 + sum300 + c300 +  
         sum303 + c303 + sum306 + c306 + sum309 + c309 + sum312 + c312 + sum315 + c315 + sum318 + c318 + sum321 + c321 + sum324 + c324 +  
         sum327 + c327 + sum330 + c330 + sum333 + c333 + sum336 + c336 + sum339 + c339 + sum342 + c342 + sum345 + c345 + sum348 + c348 +  
         sum351 + c351 + sum354 + c354 + sum357 + c357 + sum360 + c360 + sum363 + c363 + sum366 + c366 + sum369 + c369 + sum372 + c372 + 
         sum375 + c375 + sum378 + c378 + sum381 + c381 + sum384 + c384 + sum387 + c387 + sum390 + c390 + sum393 + c393 + sum396 + c396 +  
         sum399 + c399 + sum402 + c402 + sum405 + c405 + sum408 + c408 + sum411 + c411 + sum414 + c414 + sum417 + c417 + sum420 + c420 +  
         sum423 + c423 + sum426 + c426 + sum429 + c429 + sum432 + c432 + sum435 + c435 + sum438 + c438 + sum441 + c441 + sum444 + c444 +  
         sum447 + c447 + sum450 + c450 + sum453 + c453 + sum456 + c456 + sum459 + c459 + sum462 + c462 + sum465 + c465 + sum468 + c468 +  
         sum471 + c471 + sum474 + c474 + sum477 + c477 + sum480 + c480 + sum483 + c483 + sum486 + c486 + sum489 + c489 + sum492 + c492 +  
         sum495 + c495 + sum498 + c498  + sum501 + c501 + sum504 + c504 + sum507 + c507 +
         sum510 + c510 + sum513 + c513 + sum516 + c516 + sum519 + c519 + sum522 + c522 + sum525 + c525 + sum528 + c528 + sum531 + c531 + sum534 + c534 + sum537 + c537 + sum540 + c540  +
         sum543 + c543 + sum546 + c546 + sum549 + c549 + sum552 + c552 + sum555 + c555 + sum558 + c558 + sum561 + c561 + sum564 + c564 + sum567 + c567 + sum570 + c570 + sum573 + c573  +
         sum576 + c576 + sum579 + c579 + sum582 + c582 + sum585 + c585 + sum588 + c588 + sum591 + c591 + sum594 + c594 + sum597 + c597 + sum600 + c600 + sum603 + c603 + sum606 + c606  +
         sum609 + c609 + sum612 + c612 + sum615 + c615 + sum618 + c618 + sum621 + c621 + sum624 + c624 + sum627 + c627 + sum630 + c630 + sum633 + c633 + sum636 + c636 + sum639 + c639  +
         sum642 + c642 + sum645 + c645 + sum648 + c648 + sum651 + c651 + sum654 + c654 + sum657 + c657 + sum660 + c660 + sum663 + c663 + sum666 + c666 + sum669 + c669 + sum672 + c672  +
         sum675 + c675 + sum678 + c678 + sum681 + c681 + sum684 + c684 + sum687 + c687 + sum690 + c690 + sum693 + c693 + sum696 + c696 + sum699 + c699 + sum702 + c702 + sum705 + c705  +
         sum708 + c708 + sum711 + c711 + sum714 + c714 + sum717 + c717 + sum720 + c720 + sum723 + c723 + sum726 + c726 + sum729 + c729 + sum732 + c732 + sum735 + c735 + sum738 + c738  +
         sum741 + c741 + sum744 + c744 + sum747 + c747 + sum750 + c750 + sum753 + c753 + sum756 + c756 + sum759 + c759 + sum762 + c762 + sum765 + c765 + sum768 + c768 + sum771 + c771  +
         sum774 + c774 + sum777 + c777 + sum780 + c780 + sum783 + c783 + sum786 + c786 + sum789 + c789 + sum792 + c792 + sum795 + c795 + sum798 + c798 + sum801 + c801 + sum804 + c804  +
         sum807 + c807 + sum810 + c810 + sum813 + c813 + sum816 + c816 + sum819 + c819 + sum822 + c822 + sum825 + c825 + sum828 + c828 + sum831 + c831 + sum834 + c834 + sum837 + c837  +
         sum840 + c840 + sum843 + c843 + sum846 + c846 + sum849 + c849 + sum852 + c852 + sum855 + c855 + sum858 + c858 + sum861 + c861 + sum864 + c864 + sum867 + c867 + sum870 + c870  +
         sum873 + c873 + sum876 + c876 + sum879 + c879 + sum882 + c882 + sum885 + c885 + sum888 + c888 + sum891 + c891 + sum894 + c894 + sum897 + c897 + sum900 + c900 + sum903 + c903  +
         sum906 + c906 + sum909 + c909 + sum912 + c912 + sum915 + c915 + sum918 + c918 + sum921 + c921 + sum924 + c924 + sum927 + c927 + sum930 + c930 + sum933 + c933 + sum936 + c936  +
         sum939 + c939 + sum942 + c942 + sum945 + c945 + sum948 + c948 + sum951 + c951 + sum954 + c954 + sum957 + c957 + sum960 + c960 + sum963 + c963 + sum966 + c966 + sum969 + c969  +
         sum972 + c972 + sum975 + c975 + sum978 + c978 + sum981 + c981 + sum984 + c984 + sum987 + c987 + sum990 + c990 + sum993 + c993 + sum996 + c996 + sum999 + c999 + sum1002+ c1002 +
         sum1005 + c1005 + sum1008 + c1008 + sum1011 + c1011 + sum1014 + c1014 + sum1017 + c1017 + sum1020 + c1020 ;

assign test_2_stage = 
         sum_01 + c_01 + sum_02 + c_02 + sum_03 + c_03 + sum_04 + c_04 + sum_05 + c_05 + sum_06 + c_06 + sum_07 + c_07 + sum_08 + c_08 +                 c1020 + a[1023*W +: W] +
         sum_09 + c_09 + sum_10 + c_10 + sum_11 + c_11 + sum_12 + c_12 + sum_13 + c_13 + sum_14 + c_14 + sum_15 + c_15 + sum_16 + c_16 +
         sum_17 + c_17 + sum_18 + c_18 + sum_19 + c_19 + sum_20 + c_20 + sum_21 + c_21 + sum_22 + c_22 + sum_23 + c_23 + sum_24 + c_24 +
         sum_25 + c_25 + sum_26 + c_26 + sum_27 + c_27 + sum_28 + c_28 +
         sum_29 + c_29 + sum_30 + c_30 + sum_31 + c_31 + sum_32 + c_32 + sum_33 + c_33 + sum_34 + c_34 + sum_35 + c_35 + sum_36 + c_36 + 
         sum_37 + c_37 + sum_38 + c_38 + sum_39 + c_39 + sum_40 + c_40 + sum_41 + c_41 + sum_42 + c_42 + sum_43 + c_43 + sum_44 + c_44 + 
         sum_45 + c_45 + sum_46 + c_46 + sum_47 + c_47 + sum_48 + c_48 + sum_49 + c_49 + sum_50 + c_50 + sum_51 + c_51 + sum_52 + c_52 + 
         sum_53 + c_53 + sum_54 + c_54 + sum_55 + c_55 + sum_56 + c_56 + sum_57 + c_57 +
         sum_58 + c_58 + sum_59 + c_59 + sum_60 + c_60 + sum_61 + c_61 + sum_62 + c_62 + sum_63 + c_63 + sum_64 + c_64 + sum_65 + c_65 + 
         sum_66 + c_66 + sum_67 + c_67 + sum_68 + c_68 + sum_69 + c_69 + sum_70 + c_70 + sum_71 + c_71 + sum_72 + c_72 + sum_73 + c_73 + 
         sum_74 + c_74 + sum_75 + c_75 + sum_76 + c_76 + sum_77 + c_77 + sum_78 + c_78 + sum_79 + c_79 + sum_80 + c_80 + sum_81 + c_81 + 
         sum_82 + c_82 + sum_83 + c_83 + sum_84 + c_84 + sum_85 + c_85 + sum_86 + c_86 + sum_87 + c_87 + sum_88 + c_88 + sum_89 + c_89 + 
         sum_90 + c_90 + sum_91 + c_91 + sum_92 + c_92 + sum_93 + c_93 + sum_94 + c_94 + sum_95 + c_95 + sum_96 + c_96 + sum_97 + c_97 + 
         sum_98 + c_98 + sum_99 + c_99 + sum_a0 + c_a0 + sum_a1 + c_a1 + sum_a2 + c_a2 + sum_a3 + c_a3 + sum_a4 + c_a4 + sum_a5 + c_a5 + 
         sum_a6 + c_a6 + sum_a7 + c_a7 + sum_a8 + c_a8 + sum_a9 + c_a9 + sum_b0 + c_b0 + sum_b1 + c_b1 + sum_b2 + c_b2 + sum_b3 + c_b3 + sum_b4 + c_b4 + 
         sum_b5 + c_b5 + sum_b6 + c_b6 + sum_b7 + c_b7 + sum_b8 + c_b8 + sum_b9 + c_b9 + sum_c0 + c_c0 + sum_c1 + c_c1 + sum_c2 + c_c2 + sum_c3 + c_c3 + sum_c4 + c_c4 + sum_c5 + c_c5 +sum_c6+ c_c6 +
         sum_c7 + c_c7 + sum_c8 + c_c8 + sum_c9 + c_c9 + sum_d0 + c_d0 + sum_d1 + c_d1 + sum_d2 + c_d2 + sum_d3 + c_d3 + sum_d4 + c_d4 + sum_d5 + c_d5 + sum_d6 + c_d6 + sum_d7 + c_d7 +
         sum_d8 + c_d8 + sum_d9 + c_d9 + sum_e0 + c_e0 + sum_e1 + c_e1 + sum_e2 + c_e2 + sum_e3 + c_e3 + sum_e4 + c_e4 + sum_e5 + c_e5 + sum_e6 + c_e6 + sum_e7 + c_e7 + sum_e8 + c_e8 +
         sum_e9 + c_e9 + sum_f0 + c_f0 + sum_f1 + c_f1 + sum_f2 + c_f2 + sum_f3 + c_f3 + sum_f4 + c_f4 + sum_f5 + c_f5 + sum_f6 + c_f6 + sum_f7 + c_f7 + sum_f8 + c_f8 + sum_f9 + c_f9 +
         sum_g0 + c_g0 + sum_g1 + c_g1 + sum_g2 + c_g2 + sum_g3 + c_g3 + sum_g4 + c_g4 + sum_g5 + c_g5 + sum_g6 + c_g6 + sum_g7 + c_g7 + sum_g8 + c_g8 + sum_g9 + c_g9 + sum_h0 + c_h0 +
         sum_h1 + c_h1 + sum_h2 + c_h2 + sum_h3 + c_h3 + sum_h4 + c_h4 + sum_h5 + c_h5 + sum_h6 + c_h6 + sum_h7 + c_h7 + sum_h8 + c_h8 + sum_h9 + c_h9 + sum_i0 + c_i0 + sum_i1 + c_i1 +
         sum_i2 + c_i2 + sum_i3 + c_i3 + sum_i4 + c_i4 + sum_i5 + c_i5 + sum_i6 + c_i6 + sum_i7 + c_i7 + sum_i8 + c_i8 + sum_i9 + c_i9 + sum_j0 + c_j0 + sum_j1 + c_j1 + sum_j2 + c_j2 +
         sum_j3 + c_j3 + sum_j4 + c_j4 + sum_j5 + c_j5 + sum_j6 + c_j6 + sum_j7 + c_j7 + sum_j8 + c_j8 + sum_j9 + c_j9 + sum_k0 + c_k0 + sum_k1 + c_k1 + sum_k2 + c_k2 + sum_k3 + c_k3 +
         sum_k4 + c_k4 + sum_k5 + c_k5 + sum_k6 + c_k6 + sum_k7 + c_k7 + sum_k8 + c_k8 + sum_k9 + c_k9 + sum_l0 + c_l0 + sum_l1 + c_l1 + sum_l2 + c_l2 + sum_l3 + c_l3 + sum_l4 + c_l4 +
         sum_l5 + c_l5 + sum_l6 + c_l6 + sum_l7 + c_l7 + sum_l8 + c_l8 + sum_l9 + c_l9 + sum_m0 + c_m0 + sum_m1 + c_m1 + sum_m2 + c_m2 + sum_m3 + c_m3 + sum_m4 + c_m4 + sum_m5 + c_m5 ; 

assign test_3_stage = 
        sum_161 + c_161 + sum_162 + c_162 + sum_163 + c_163 + sum_164 + c_164 + sum_165 + c_165 + sum_166 + c_166 + sum_167 + c_167 + sum_168 + c_168 + 
        sum_169 + c_169 + sum_170 + c_170 + sum_171 + c_171 + sum_172 + c_172 + sum_173 + c_173 + sum_174 + c_174 + sum_175 + c_175 + sum_176 + c_176 + 
        sum_177 + c_177 + sum_178 + c_178 + sum_179 + c_179 + sum_180 + c_180 + sum_181 + c_181 + sum_182 + c_182 + sum_183 + c_183 + sum_184 + c_184 + 
        sum_185 + c_185 + sum_186 + c_186 + sum_187 + c_187 + sum_188 + c_188 + sum_189 + c_189 + sum_190 + c_190 + sum_191 + c_191 + sum_192 + c_192 + 
        sum_193 + c_193 + sum_194 + c_194 + sum_195 + c_195 + sum_196 + c_196 + sum_197 + c_197 + sum_198 + c_198 +
        sum_199 + c_199 + sum_1c0 + c_1c0 + sum_1c1 + c_1c1 + sum_1c2 + c_1c2 + sum_1c3 + c_1c3 + sum_1c4 + c_1c4 + sum_1c5 + c_1c5 + sum_1c6 + c_1c6 + 
        sum_1c7 + c_1c7 + sum_1c8 + c_1c8 + sum_1c9 + c_1c9 + sum_1d0 + c_1d0 + sum_1d1 + c_1d1 + sum_1d2 + c_1d2 + sum_1d3 + c_1d3 + sum_1d4 + c_1d4 + 
        sum_1d5 + c_1d5 + sum_1d6 + c_1d6 + sum_1d7 + c_1d7 + sum_1d8 + c_1d8 + sum_1d9 + c_1d9 + sum_1e0 + c_1e0 + sum_1e1 + c_1e1 + sum_1e2 + c_1e2 + 
        sum_1e3 + c_1e3 + sum_1e4 + c_1e4 + sum_1e5 + c_1e5 + sum_1e6 + c_1e6 + sum_1e7 + c_1e7 + sum_1e8 + c_1e8 + sum_1e9 + c_1e9 + sum_1f0 + c_1f0 + 
        sum_1f1 + c_1f1 + sum_1f2 + c_1f2 + sum_1f3 + c_1f3 + sum_1f4 + c_1f4 + sum_1f5 + c_1f5 + sum_1f6 + c_1f6 +
        sum_1f7 + c_1f7 + sum_1f8 + c_1f8 + sum_1f9 + c_1f9 + sum_1g0 + c_1g0 + sum_1g1 + c_1g1 + sum_1g2 + c_1g2 + sum_1g3 + c_1g3 + sum_1g4 + c_1g4 + sum_1g5 + c_1g5 + sum_1g6 + c_1g6 + sum_1g7 + c_1g7 +
        sum_1g8 + c_1g8 + sum_1g9 + c_1g9 + sum_1h0 + c_1h0 + sum_1h1 + c_1h1 + sum_1h2 + c_1h2 + sum_1h3 + c_1h3 + sum_1h4 + c_1h4 + sum_1h5 + c_1h5 + sum_1h6 + c_1h6 + sum_1h7 + c_1h7 + sum_1h8 + c_1h8 +
        sum_1h9 + c_1h9 + sum_1i0 + c_1i0 + sum_1i1 + c_1i1 + sum_1i2 + c_1i2 + sum_1i3 + c_1i3 + sum_1i4 + c_1i4 + sum_1i5 + c_1i5 + sum_1i6 + c_1i6 + sum_1i7 + c_1i7 + sum_1i8 + c_1i8 + sum_1i9 + c_1i9 +
        sum_1j0 + c_1j0 + sum_1j1 + c_1j1 + sum_1j2 + c_1j2 + sum_1j3 + c_1j3 + sum_1j4 + c_1j4 + sum_1j5 + c_1j5 + sum_1j6 + c_1j6 + sum_1j7 + c_1j7 + sum_1j8 + c_1j8 + sum_1j9 + c_1j9 + sum_1k0 + c_1k0 +
        sum_1k1 + c_1k1 + sum_1k2 + c_1k2 + sum_1k3 + c_1k3 + sum_1k4 + c_1k4 + sum_1k5 + c_1k5 + sum_1k6 + c_1k6 + sum_1k7 + c_1k7 + sum_1k8 + c_1k8 + sum_1k9 + c_1k9 + sum_1l0 + c_1l0 + sum_1l1 + c_1l1 +
        sum_1l2 + c_1l2 + sum_1l3 + c_1l3 + sum_1l4 + c_1l4 + sum_1l5 + c_1l5 + sum_1l6 + c_1l6 + sum_1l7 + c_1l7 + sum_1l8 + c_1l8 + sum_1l9 + c_1l9 + sum_1m0 + c_1m0 + sum_1m1 + c_1m1 + sum_1m2 + c_1m2 +
        sum_1m3 + c_1m3 + sum_1m4 + c_1m4 + sum_1m5 + c_1m5 + sum_1m6 + c_1m6 + sum_1m7 + c_1m7 + sum_1m8 + c_1m8 + sum_1m9 + c_1m9 + sum_1n0 + c_1n0 + sum_1n1 + c_1n1 + sum_1n2 + c_1n2;

assign test_4_stage = 
       sum_301 + c_301 + sum_302 + c_302 + sum_303 + c_303 + sum_304 + c_304 + sum_305 + c_305 + sum_306 + c_306 + sum_307 + c_307 + sum_308 + c_308 +                c_1n2+
       sum_309 + c_309 + sum_310 + c_310 + sum_311 + c_311 + sum_312 + c_312 + sum_313 + c_313 + sum_314 + c_314 + sum_315 + c_315 + sum_316 + c_316 +
       sum_317 + c_317 + sum_318 + c_318 + sum_319 + c_319 + sum_320 + c_320 + sum_321 + c_321 + sum_322 + c_322 + sum_323 + c_323 + sum_324 + c_324 +
       sum_400 + c_400 + sum_401 + c_401 + sum_402 + c_402 + sum_403 + c_403 + sum_404 + c_404 + sum_405 + c_405 + sum_406 + c_406 + sum_407 + c_407 + 
       sum_408 + c_408 + sum_409 + c_409 + sum_410 + c_410 + sum_411 + c_411 + sum_412 + c_412 + sum_413 + c_413 + sum_414 + c_414 + sum_415 + c_415 + sum_425 + c_425+
       sum_416 + c_416 + sum_417 + c_417 + sum_418 + c_418 + sum_419 + c_419 + sum_420 + c_420 + sum_421 + c_421 + sum_422 + c_422 + sum_423 + c_423 + sum_424 + c_424+ 
       sum_a426 + c_a426 + sum_a427 + c_a427 + sum_a428 + c_a428 + sum_a429 + c_a429 + sum_a430 + c_a430 + sum_a431 + c_a431 + sum_a432 + c_a432 + sum_a433 + c_a433+ sum_a434+ c_a434+ sum_a435+ c_a435+ sum_a436+ c_a436+
       sum_a437 + c_a437 + sum_a438 + c_a438 + sum_a439 + c_a439 + sum_a440 + c_a440 + sum_a441 + c_a441 + sum_a442 + c_a442 + sum_a443 + c_a443 + sum_a444 + c_a444+ sum_a445+ c_a445+ sum_a446+ c_a446+ sum_a447+ c_a447+
       sum_a448 + c_a448 + sum_a449 + c_a449 + sum_a450 + c_a450 + sum_a451 + c_a451 + sum_a452 + c_a452 + sum_a453 + c_a453 + sum_a454 + c_a454 + sum_a455 + c_a455+ sum_a456+ c_a456+ sum_a457+ c_a457+ sum_a458+ c_a458+
       sum_a459 + c_a459 + sum_a460 + c_a460 + sum_a461 + c_a461 + sum_a462 + c_a462 + sum_a463 + c_a463 + sum_a464 + c_a464 + sum_a465 + c_a465 + sum_a466 + c_a466+ sum_a467+ c_a467+ sum_a468+ c_a468+ sum_a469+ c_a469+
       sum_a470 + c_a470 + sum_a471 + c_a471 + sum_a472 + c_a472 + sum_a473 + c_a473 + sum_a474 + c_a474 + sum_a475 + c_a475 + sum_a476 + c_a476;


assign test_5_stage = 
       sum_331 + c_331 + sum_332 + c_332 + sum_333 + c_333 + sum_334 + c_334 + sum_335 + c_335 + sum_336 + c_336 + sum_337 + c_337 + sum_338 + c_338 +
       sum_339 + c_339 + sum_340 + c_340 + sum_341 + c_341 + sum_342 + c_342 + sum_343 + c_343 + sum_344 + c_344 + sum_345 + c_345 + sum_346 + c_346 + sum_347 + c_347+
       sum_430 + c_430 + sum_431 + c_431 + sum_432 + c_432 + sum_433 + c_433 + sum_434 + c_434 + sum_435 + c_435 + sum_436 + c_436 + sum_437 + c_437 +
       sum_438 + c_438 + sum_439 + c_439 + sum_440 + c_440 + sum_441 + c_441 + sum_442 + c_442 + sum_443 + c_443 + sum_444 + c_444 + sum_445 + c_445 + sum_446 + c_446+
       sum_b447+ c_b447+ sum_b448+ c_b448+ sum_b449+ c_b449+ sum_b450+ c_b450+ sum_b451+ c_b451+ sum_b452+ c_b452+ sum_b453+ c_b453+ sum_b454+ c_b454+ sum_b455+ c_b455+ sum_b456+ c_b456+
       sum_b457+ c_b457+ sum_b458+ c_b458+ sum_b459+ c_b459+ sum_b460+ c_b460+ sum_b461+ c_b461+ sum_b462+ c_b462+ sum_b463+ c_b463+ sum_b464+ c_b464+ sum_b465+ c_b465+ sum_b466+ c_b466+ sum_b467+ c_b467+
       sum_b468+ c_b468+ sum_b469+ c_b469+ sum_b470+ c_b470+ sum_b471+ c_b471+ sum_b472+ c_b472+ sum_b473+ c_b473+ sum_b474+ c_b474+ sum_b475+ c_b475+ sum_b476+ c_b476+ sum_b477+ c_b477+ sum_b478+ c_b478+
       sum_b479+ c_b479;


assign test_6_stage = sum_359 + c_359 + sum_360 + c_360 + sum_361 + c_361 +   
                      sum_351 + c_351 + sum_352 + c_352 + sum_353 + c_353 + sum_354 + c_354 + sum_355 + c_355 + sum_356 + c_356 + sum_357 + c_357 + sum_358 + c_358 +
                      sum_450 + c_450 + sum_451 + c_451 + sum_452 + c_452 + sum_453 + c_453 + sum_454 + c_454 + sum_455 + c_455 + sum_456 + c_456 + sum_457 + c_457 +
                      sum_458 + c_458 + sum_459 + c_459 + sum_45a + c_45a +     
                      sum_c460+ c_c460+ sum_c461+ c_c461+ sum_c462+ c_c462+ sum_c463+ c_c463+ sum_c464+ c_c464+ sum_c465+ c_c465+ sum_c466+ c_c466+ sum_c467+ c_c467+ sum_c468+ c_c468+ sum_c469+ c_c469+ sum_c470+ c_c470+ 
                      sum_c471+ c_c471+ sum_c472+ c_c472+ sum_c473+ c_c473+ sum_c474+ c_c474+ sum_c475+ c_c475+ sum_c476+ c_c476+ sum_c477+ c_c477+ sum_c478+ c_c478+ sum_c479+ c_c479+ sum_c480+ c_c480+ sum_c481+ c_c481+
                      sum_c482+ c_c482; 

assign test_7_stage = sum_371 + c_371 + sum_372 + c_372 + sum_373 + c_373 + sum_374 + c_374 + sum_375 + c_375 + sum_376 + c_376 + sum_377 + c_377 +   c_45a +
                      sum_460 + c_460 + sum_461 + c_461 + sum_462 + c_462 + sum_463 + c_463 + sum_464 + c_464 + sum_465 + c_465 + sum_466 + c_466 + sum_467 + c_467+
                      sum_d478+ c_d478+ sum_d479+ c_d479+ sum_d480+ c_d480+ sum_d481+ c_d481+ sum_d482+ c_d482+ sum_d483+ c_d483+ sum_d484+ c_d484+ sum_d485+ c_d485+ sum_d486+ c_d486+
                      sum_d487+ c_d487+ sum_d488+ c_d488+ sum_d489+ c_d489+ sum_d490+ c_d490+ sum_d491+ c_d491+ sum_d492+ c_d492;

assign test_8_stage = sum_381 + c_381 + sum_382 + c_382 + sum_383 + c_383 + sum_384 + c_384 + sum_385 + c_385 +     c_467 +
                      sum_470 + c_470 + sum_471 + c_471 + sum_472 + c_472 + sum_473 + c_473 + sum_474 + c_474+
                      sum_e475+ c_e475+ sum_e476+ c_e476+ sum_e477+ c_e477+ sum_e478+ c_e478+ sum_e479+ c_e479+
                      sum_e480+ c_e480+ sum_e481+ c_e481+ sum_e482+ c_e482+ sum_e483+ c_e483+ sum_e484+ c_e484;

assign test_9_stage = sum_391 + c_391 + sum_392 + c_392 + sum_393 + c_393  +
                      sum_480 + c_480 + sum_481 + c_481 + sum_482 + c_482 + sum_483 + c_483 +
                      sum_b484+ c_b484+ sum_b485+ c_b485+ sum_b486+ c_b486+ sum_b487+ c_b487+
                      sum_b488+ c_b488+ sum_b489+ c_b489+ sum_b490+ c_b490;

assign test_A_stage = sum_490 + c_490 + sum_491 + c_491 + sum_492 + c_492 + sum_493 + c_493 +
                      sum_b494+ c_b494+ sum_b495+ c_b495+ sum_b496+ c_b496+ sum_b497+ c_b497+ sum_b498+ c_b498;

assign test_B_stage =  sum_b50+ c_b50+ sum_b51+ c_b51+ sum_b52+ c_b52+ sum_b53+ c_b53+ sum_b54+ c_b54+ sum_b55+ c_b55;

assign test_C_stage = sum_b56+ c_b56+ sum_b57+ c_b57+ sum_b58+ c_b58+ sum_b59+ c_b59;   

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
 carry_save_3inputs #(W) cs_3in_252 (.a(a[252*W +: 3*W ]), .sum(sum252), .cout(c252) );
 carry_save_3inputs #(W) cs_3in_255 (.a(a[255*W +: 3*W ]), .sum(sum255), .cout(c255) );
 carry_save_3inputs #(W) cs_3in_258 (.a(a[258*W +: 3*W ]), .sum(sum258), .cout(c258) );
 carry_save_3inputs #(W) cs_3in_261 (.a(a[261*W +: 3*W ]), .sum(sum261), .cout(c261) );
 carry_save_3inputs #(W) cs_3in_264 (.a(a[264*W +: 3*W ]), .sum(sum264), .cout(c264) );
 carry_save_3inputs #(W) cs_3in_267 (.a(a[267*W +: 3*W ]), .sum(sum267), .cout(c267) );
 carry_save_3inputs #(W) cs_3in_270 (.a(a[270*W +: 3*W ]), .sum(sum270), .cout(c270) );
 carry_save_3inputs #(W) cs_3in_273 (.a(a[273*W +: 3*W ]), .sum(sum273), .cout(c273) );
 carry_save_3inputs #(W) cs_3in_276 (.a(a[276*W +: 3*W ]), .sum(sum276), .cout(c276) );
 carry_save_3inputs #(W) cs_3in_279 (.a(a[279*W +: 3*W ]), .sum(sum279), .cout(c279) );
 carry_save_3inputs #(W) cs_3in_282 (.a(a[282*W +: 3*W ]), .sum(sum282), .cout(c282) );
 carry_save_3inputs #(W) cs_3in_285 (.a(a[285*W +: 3*W ]), .sum(sum285), .cout(c285) );
 carry_save_3inputs #(W) cs_3in_288 (.a(a[288*W +: 3*W ]), .sum(sum288), .cout(c288) );
 carry_save_3inputs #(W) cs_3in_291 (.a(a[291*W +: 3*W ]), .sum(sum291), .cout(c291) );
 carry_save_3inputs #(W) cs_3in_294 (.a(a[294*W +: 3*W ]), .sum(sum294), .cout(c294) );
 carry_save_3inputs #(W) cs_3in_297 (.a(a[297*W +: 3*W ]), .sum(sum297), .cout(c297) );
 carry_save_3inputs #(W) cs_3in_300 (.a(a[300*W +: 3*W ]), .sum(sum300), .cout(c300) );
 carry_save_3inputs #(W) cs_3in_303 (.a(a[303*W +: 3*W ]), .sum(sum303), .cout(c303) );
 carry_save_3inputs #(W) cs_3in_306 (.a(a[306*W +: 3*W ]), .sum(sum306), .cout(c306) );
 carry_save_3inputs #(W) cs_3in_309 (.a(a[309*W +: 3*W ]), .sum(sum309), .cout(c309) );
 carry_save_3inputs #(W) cs_3in_312 (.a(a[312*W +: 3*W ]), .sum(sum312), .cout(c312) );
 carry_save_3inputs #(W) cs_3in_315 (.a(a[315*W +: 3*W ]), .sum(sum315), .cout(c315) );
 carry_save_3inputs #(W) cs_3in_318 (.a(a[318*W +: 3*W ]), .sum(sum318), .cout(c318) );
 carry_save_3inputs #(W) cs_3in_321 (.a(a[321*W +: 3*W ]), .sum(sum321), .cout(c321) );
 carry_save_3inputs #(W) cs_3in_324 (.a(a[324*W +: 3*W ]), .sum(sum324), .cout(c324) );
 carry_save_3inputs #(W) cs_3in_327 (.a(a[327*W +: 3*W ]), .sum(sum327), .cout(c327) );
 carry_save_3inputs #(W) cs_3in_330 (.a(a[330*W +: 3*W ]), .sum(sum330), .cout(c330) );
 carry_save_3inputs #(W) cs_3in_333 (.a(a[333*W +: 3*W ]), .sum(sum333), .cout(c333) );
 carry_save_3inputs #(W) cs_3in_336 (.a(a[336*W +: 3*W ]), .sum(sum336), .cout(c336) );
 carry_save_3inputs #(W) cs_3in_339 (.a(a[339*W +: 3*W ]), .sum(sum339), .cout(c339) );
 carry_save_3inputs #(W) cs_3in_342 (.a(a[342*W +: 3*W ]), .sum(sum342), .cout(c342) );
 carry_save_3inputs #(W) cs_3in_345 (.a(a[345*W +: 3*W ]), .sum(sum345), .cout(c345) );
 carry_save_3inputs #(W) cs_3in_348 (.a(a[348*W +: 3*W ]), .sum(sum348), .cout(c348) );
 carry_save_3inputs #(W) cs_3in_351 (.a(a[351*W +: 3*W ]), .sum(sum351), .cout(c351) );
 carry_save_3inputs #(W) cs_3in_354 (.a(a[354*W +: 3*W ]), .sum(sum354), .cout(c354) );
 carry_save_3inputs #(W) cs_3in_357 (.a(a[357*W +: 3*W ]), .sum(sum357), .cout(c357) );
 carry_save_3inputs #(W) cs_3in_360 (.a(a[360*W +: 3*W ]), .sum(sum360), .cout(c360) );
 carry_save_3inputs #(W) cs_3in_363 (.a(a[363*W +: 3*W ]), .sum(sum363), .cout(c363) );
 carry_save_3inputs #(W) cs_3in_366 (.a(a[366*W +: 3*W ]), .sum(sum366), .cout(c366) );
 carry_save_3inputs #(W) cs_3in_369 (.a(a[369*W +: 3*W ]), .sum(sum369), .cout(c369) );
 carry_save_3inputs #(W) cs_3in_372 (.a(a[372*W +: 3*W ]), .sum(sum372), .cout(c372) );
 carry_save_3inputs #(W) cs_3in_375 (.a(a[375*W +: 3*W ]), .sum(sum375), .cout(c375) );
 carry_save_3inputs #(W) cs_3in_378 (.a(a[378*W +: 3*W ]), .sum(sum378), .cout(c378) );
 carry_save_3inputs #(W) cs_3in_381 (.a(a[381*W +: 3*W ]), .sum(sum381), .cout(c381) );
 carry_save_3inputs #(W) cs_3in_384 (.a(a[384*W +: 3*W ]), .sum(sum384), .cout(c384) );
 carry_save_3inputs #(W) cs_3in_387 (.a(a[387*W +: 3*W ]), .sum(sum387), .cout(c387) );
 carry_save_3inputs #(W) cs_3in_390 (.a(a[390*W +: 3*W ]), .sum(sum390), .cout(c390) ); 
 carry_save_3inputs #(W) cs_3in_393 (.a(a[393*W +: 3*W ]), .sum(sum393), .cout(c393) );
 carry_save_3inputs #(W) cs_3in_396 (.a(a[396*W +: 3*W ]), .sum(sum396), .cout(c396) );
 carry_save_3inputs #(W) cs_3in_399 (.a(a[399*W +: 3*W ]), .sum(sum399), .cout(c399) );
 carry_save_3inputs #(W) cs_3in_402 (.a(a[402*W +: 3*W ]), .sum(sum402), .cout(c402) );
 carry_save_3inputs #(W) cs_3in_405 (.a(a[405*W +: 3*W ]), .sum(sum405), .cout(c405) );
 carry_save_3inputs #(W) cs_3in_408 (.a(a[408*W +: 3*W ]), .sum(sum408), .cout(c408) );
 carry_save_3inputs #(W) cs_3in_411 (.a(a[411*W +: 3*W ]), .sum(sum411), .cout(c411) );
 carry_save_3inputs #(W) cs_3in_414 (.a(a[414*W +: 3*W ]), .sum(sum414), .cout(c414) );
 carry_save_3inputs #(W) cs_3in_417 (.a(a[417*W +: 3*W ]), .sum(sum417), .cout(c417) );
 carry_save_3inputs #(W) cs_3in_420 (.a(a[420*W +: 3*W ]), .sum(sum420), .cout(c420) );
 carry_save_3inputs #(W) cs_3in_423 (.a(a[423*W +: 3*W ]), .sum(sum423), .cout(c423) );
 carry_save_3inputs #(W) cs_3in_426 (.a(a[426*W +: 3*W ]), .sum(sum426), .cout(c426) );
 carry_save_3inputs #(W) cs_3in_429 (.a(a[429*W +: 3*W ]), .sum(sum429), .cout(c429) );
 carry_save_3inputs #(W) cs_3in_432 (.a(a[432*W +: 3*W ]), .sum(sum432), .cout(c432) );
 carry_save_3inputs #(W) cs_3in_435 (.a(a[435*W +: 3*W ]), .sum(sum435), .cout(c435) );
 carry_save_3inputs #(W) cs_3in_438 (.a(a[438*W +: 3*W ]), .sum(sum438), .cout(c438) );
 carry_save_3inputs #(W) cs_3in_441 (.a(a[441*W +: 3*W ]), .sum(sum441), .cout(c441) );
 carry_save_3inputs #(W) cs_3in_444 (.a(a[444*W +: 3*W ]), .sum(sum444), .cout(c444) );
 carry_save_3inputs #(W) cs_3in_447 (.a(a[447*W +: 3*W ]), .sum(sum447), .cout(c447) );
 carry_save_3inputs #(W) cs_3in_450 (.a(a[450*W +: 3*W ]), .sum(sum450), .cout(c450) );
 carry_save_3inputs #(W) cs_3in_453 (.a(a[453*W +: 3*W ]), .sum(sum453), .cout(c453) );
 carry_save_3inputs #(W) cs_3in_456 (.a(a[456*W +: 3*W ]), .sum(sum456), .cout(c456) );
 carry_save_3inputs #(W) cs_3in_459 (.a(a[459*W +: 3*W ]), .sum(sum459), .cout(c459) );
 carry_save_3inputs #(W) cs_3in_462 (.a(a[462*W +: 3*W ]), .sum(sum462), .cout(c462) );
 carry_save_3inputs #(W) cs_3in_465 (.a(a[465*W +: 3*W ]), .sum(sum465), .cout(c465) );
 carry_save_3inputs #(W) cs_3in_468 (.a(a[468*W +: 3*W ]), .sum(sum468), .cout(c468) );
 carry_save_3inputs #(W) cs_3in_471 (.a(a[471*W +: 3*W ]), .sum(sum471), .cout(c471) );
 carry_save_3inputs #(W) cs_3in_474 (.a(a[474*W +: 3*W ]), .sum(sum474), .cout(c474) );
 carry_save_3inputs #(W) cs_3in_477 (.a(a[477*W +: 3*W ]), .sum(sum477), .cout(c477) );
 carry_save_3inputs #(W) cs_3in_480 (.a(a[480*W +: 3*W ]), .sum(sum480), .cout(c480) );
 carry_save_3inputs #(W) cs_3in_483 (.a(a[483*W +: 3*W ]), .sum(sum483), .cout(c483) );
 carry_save_3inputs #(W) cs_3in_486 (.a(a[486*W +: 3*W ]), .sum(sum486), .cout(c486) );
 carry_save_3inputs #(W) cs_3in_489 (.a(a[489*W +: 3*W ]), .sum(sum489), .cout(c489) );
 carry_save_3inputs #(W) cs_3in_492 (.a(a[492*W +: 3*W ]), .sum(sum492), .cout(c492) );
 carry_save_3inputs #(W) cs_3in_495 (.a(a[495*W +: 3*W ]), .sum(sum495), .cout(c495) );
 carry_save_3inputs #(W) cs_3in_498 (.a(a[498*W +: 3*W ]), .sum(sum498), .cout(c498) );
 carry_save_3inputs #(W) cs_3in_501 (.a(a[501*W +: 3*W ]), .sum(sum501), .cout(c501) );
 carry_save_3inputs #(W) cs_3in_504 (.a(a[504*W +: 3*W ]), .sum(sum504), .cout(c504) );
 carry_save_3inputs #(W) cs_3in_507 (.a(a[507*W +: 3*W ]), .sum(sum507), .cout(c507) );

 carry_save_3inputs #(W) cs_3in_510 (.a(a[ 510*W +: 3*W ]), .sum(sum510 ), .cout(c510 ) );
 carry_save_3inputs #(W) cs_3in_513 (.a(a[ 513*W +: 3*W ]), .sum(sum513 ), .cout(c513 ) );
 carry_save_3inputs #(W) cs_3in_516 (.a(a[ 516*W +: 3*W ]), .sum(sum516 ), .cout(c516 ) );
 carry_save_3inputs #(W) cs_3in_519 (.a(a[ 519*W +: 3*W ]), .sum(sum519 ), .cout(c519 ) );
 carry_save_3inputs #(W) cs_3in_522 (.a(a[ 522*W +: 3*W ]), .sum(sum522 ), .cout(c522 ) );
 carry_save_3inputs #(W) cs_3in_525 (.a(a[ 525*W +: 3*W ]), .sum(sum525 ), .cout(c525 ) );
 carry_save_3inputs #(W) cs_3in_528 (.a(a[ 528*W +: 3*W ]), .sum(sum528 ), .cout(c528 ) );
 carry_save_3inputs #(W) cs_3in_531 (.a(a[ 531*W +: 3*W ]), .sum(sum531 ), .cout(c531 ) );
 carry_save_3inputs #(W) cs_3in_534 (.a(a[ 534*W +: 3*W ]), .sum(sum534 ), .cout(c534 ) );
 carry_save_3inputs #(W) cs_3in_537 (.a(a[ 537*W +: 3*W ]), .sum(sum537 ), .cout(c537 ) );
 carry_save_3inputs #(W) cs_3in_540 (.a(a[ 540*W +: 3*W ]), .sum(sum540 ), .cout(c540 ) );
 carry_save_3inputs #(W) cs_3in_543 (.a(a[ 543*W +: 3*W ]), .sum(sum543 ), .cout(c543 ) );
 carry_save_3inputs #(W) cs_3in_546 (.a(a[ 546*W +: 3*W ]), .sum(sum546 ), .cout(c546 ) );
 carry_save_3inputs #(W) cs_3in_549 (.a(a[ 549*W +: 3*W ]), .sum(sum549 ), .cout(c549 ) );
 carry_save_3inputs #(W) cs_3in_552 (.a(a[ 552*W +: 3*W ]), .sum(sum552 ), .cout(c552 ) );
 carry_save_3inputs #(W) cs_3in_555 (.a(a[ 555*W +: 3*W ]), .sum(sum555 ), .cout(c555 ) );
 carry_save_3inputs #(W) cs_3in_558 (.a(a[ 558*W +: 3*W ]), .sum(sum558 ), .cout(c558 ) );
 carry_save_3inputs #(W) cs_3in_561 (.a(a[ 561*W +: 3*W ]), .sum(sum561 ), .cout(c561 ) );
 carry_save_3inputs #(W) cs_3in_564 (.a(a[ 564*W +: 3*W ]), .sum(sum564 ), .cout(c564 ) );
 carry_save_3inputs #(W) cs_3in_567 (.a(a[ 567*W +: 3*W ]), .sum(sum567 ), .cout(c567 ) );
 carry_save_3inputs #(W) cs_3in_570 (.a(a[ 570*W +: 3*W ]), .sum(sum570 ), .cout(c570 ) );
 carry_save_3inputs #(W) cs_3in_573 (.a(a[ 573*W +: 3*W ]), .sum(sum573 ), .cout(c573 ) );
 carry_save_3inputs #(W) cs_3in_576 (.a(a[ 576*W +: 3*W ]), .sum(sum576 ), .cout(c576 ) );
 carry_save_3inputs #(W) cs_3in_579 (.a(a[ 579*W +: 3*W ]), .sum(sum579 ), .cout(c579 ) );
 carry_save_3inputs #(W) cs_3in_582 (.a(a[ 582*W +: 3*W ]), .sum(sum582 ), .cout(c582 ) );
 carry_save_3inputs #(W) cs_3in_585 (.a(a[ 585*W +: 3*W ]), .sum(sum585 ), .cout(c585 ) );
 carry_save_3inputs #(W) cs_3in_588 (.a(a[ 588*W +: 3*W ]), .sum(sum588 ), .cout(c588 ) );
 carry_save_3inputs #(W) cs_3in_591 (.a(a[ 591*W +: 3*W ]), .sum(sum591 ), .cout(c591 ) );
 carry_save_3inputs #(W) cs_3in_594 (.a(a[ 594*W +: 3*W ]), .sum(sum594 ), .cout(c594 ) );
 carry_save_3inputs #(W) cs_3in_597 (.a(a[ 597*W +: 3*W ]), .sum(sum597 ), .cout(c597 ) );
 carry_save_3inputs #(W) cs_3in_600 (.a(a[ 600*W +: 3*W ]), .sum(sum600 ), .cout(c600 ) );
 carry_save_3inputs #(W) cs_3in_603 (.a(a[ 603*W +: 3*W ]), .sum(sum603 ), .cout(c603 ) );
 carry_save_3inputs #(W) cs_3in_606 (.a(a[ 606*W +: 3*W ]), .sum(sum606 ), .cout(c606 ) );
 carry_save_3inputs #(W) cs_3in_609 (.a(a[ 609*W +: 3*W ]), .sum(sum609 ), .cout(c609 ) );
 carry_save_3inputs #(W) cs_3in_612 (.a(a[ 612*W +: 3*W ]), .sum(sum612 ), .cout(c612 ) );
 carry_save_3inputs #(W) cs_3in_615 (.a(a[ 615*W +: 3*W ]), .sum(sum615 ), .cout(c615 ) );
 carry_save_3inputs #(W) cs_3in_618 (.a(a[ 618*W +: 3*W ]), .sum(sum618 ), .cout(c618 ) );
 carry_save_3inputs #(W) cs_3in_621 (.a(a[ 621*W +: 3*W ]), .sum(sum621 ), .cout(c621 ) );
 carry_save_3inputs #(W) cs_3in_624 (.a(a[ 624*W +: 3*W ]), .sum(sum624 ), .cout(c624 ) );
 carry_save_3inputs #(W) cs_3in_627 (.a(a[ 627*W +: 3*W ]), .sum(sum627 ), .cout(c627 ) );
 carry_save_3inputs #(W) cs_3in_630 (.a(a[ 630*W +: 3*W ]), .sum(sum630 ), .cout(c630 ) );
 carry_save_3inputs #(W) cs_3in_633 (.a(a[ 633*W +: 3*W ]), .sum(sum633 ), .cout(c633 ) );
 carry_save_3inputs #(W) cs_3in_636 (.a(a[ 636*W +: 3*W ]), .sum(sum636 ), .cout(c636 ) ); 
 carry_save_3inputs #(W) cs_3in_639 (.a(a[ 639*W +: 3*W ]), .sum(sum639 ), .cout(c639 ) );
 carry_save_3inputs #(W) cs_3in_642 (.a(a[ 642*W +: 3*W ]), .sum(sum642 ), .cout(c642 ) );
 carry_save_3inputs #(W) cs_3in_645 (.a(a[ 645*W +: 3*W ]), .sum(sum645 ), .cout(c645 ) );
 carry_save_3inputs #(W) cs_3in_648 (.a(a[ 648*W +: 3*W ]), .sum(sum648 ), .cout(c648 ) );
 carry_save_3inputs #(W) cs_3in_651 (.a(a[ 651*W +: 3*W ]), .sum(sum651 ), .cout(c651 ) );
 carry_save_3inputs #(W) cs_3in_654 (.a(a[ 654*W +: 3*W ]), .sum(sum654 ), .cout(c654 ) );
 carry_save_3inputs #(W) cs_3in_657 (.a(a[ 657*W +: 3*W ]), .sum(sum657 ), .cout(c657 ) );
 carry_save_3inputs #(W) cs_3in_660 (.a(a[ 660*W +: 3*W ]), .sum(sum660 ), .cout(c660 ) );
 carry_save_3inputs #(W) cs_3in_663 (.a(a[ 663*W +: 3*W ]), .sum(sum663 ), .cout(c663 ) );
 carry_save_3inputs #(W) cs_3in_666 (.a(a[ 666*W +: 3*W ]), .sum(sum666 ), .cout(c666 ) );
 carry_save_3inputs #(W) cs_3in_669 (.a(a[ 669*W +: 3*W ]), .sum(sum669 ), .cout(c669 ) );
 carry_save_3inputs #(W) cs_3in_672 (.a(a[ 672*W +: 3*W ]), .sum(sum672 ), .cout(c672 ) );
 carry_save_3inputs #(W) cs_3in_675 (.a(a[ 675*W +: 3*W ]), .sum(sum675 ), .cout(c675 ) );
 carry_save_3inputs #(W) cs_3in_678 (.a(a[ 678*W +: 3*W ]), .sum(sum678 ), .cout(c678 ) );
 carry_save_3inputs #(W) cs_3in_681 (.a(a[ 681*W +: 3*W ]), .sum(sum681 ), .cout(c681 ) );
 carry_save_3inputs #(W) cs_3in_684 (.a(a[ 684*W +: 3*W ]), .sum(sum684 ), .cout(c684 ) );
 carry_save_3inputs #(W) cs_3in_687 (.a(a[ 687*W +: 3*W ]), .sum(sum687 ), .cout(c687 ) );
 carry_save_3inputs #(W) cs_3in_690 (.a(a[ 690*W +: 3*W ]), .sum(sum690 ), .cout(c690 ) );
 carry_save_3inputs #(W) cs_3in_693 (.a(a[ 693*W +: 3*W ]), .sum(sum693 ), .cout(c693 ) );
 carry_save_3inputs #(W) cs_3in_696 (.a(a[ 696*W +: 3*W ]), .sum(sum696 ), .cout(c696 ) );
 carry_save_3inputs #(W) cs_3in_699 (.a(a[ 699*W +: 3*W ]), .sum(sum699 ), .cout(c699 ) );
 carry_save_3inputs #(W) cs_3in_702 (.a(a[ 702*W +: 3*W ]), .sum(sum702 ), .cout(c702 ) );
 carry_save_3inputs #(W) cs_3in_705 (.a(a[ 705*W +: 3*W ]), .sum(sum705 ), .cout(c705 ) );
 carry_save_3inputs #(W) cs_3in_708 (.a(a[ 708*W +: 3*W ]), .sum(sum708 ), .cout(c708 ) );
 carry_save_3inputs #(W) cs_3in_711 (.a(a[ 711*W +: 3*W ]), .sum(sum711 ), .cout(c711 ) );
 carry_save_3inputs #(W) cs_3in_714 (.a(a[ 714*W +: 3*W ]), .sum(sum714 ), .cout(c714 ) );
 carry_save_3inputs #(W) cs_3in_717 (.a(a[ 717*W +: 3*W ]), .sum(sum717 ), .cout(c717 ) );
 carry_save_3inputs #(W) cs_3in_720 (.a(a[ 720*W +: 3*W ]), .sum(sum720 ), .cout(c720 ) );
 carry_save_3inputs #(W) cs_3in_723 (.a(a[ 723*W +: 3*W ]), .sum(sum723 ), .cout(c723 ) );
 carry_save_3inputs #(W) cs_3in_726 (.a(a[ 726*W +: 3*W ]), .sum(sum726 ), .cout(c726 ) );
 carry_save_3inputs #(W) cs_3in_729 (.a(a[ 729*W +: 3*W ]), .sum(sum729 ), .cout(c729 ) );
 carry_save_3inputs #(W) cs_3in_732 (.a(a[ 732*W +: 3*W ]), .sum(sum732 ), .cout(c732 ) );
 carry_save_3inputs #(W) cs_3in_735 (.a(a[ 735*W +: 3*W ]), .sum(sum735 ), .cout(c735 ) );
 carry_save_3inputs #(W) cs_3in_738 (.a(a[ 738*W +: 3*W ]), .sum(sum738 ), .cout(c738 ) );
 carry_save_3inputs #(W) cs_3in_741 (.a(a[ 741*W +: 3*W ]), .sum(sum741 ), .cout(c741 ) );
 carry_save_3inputs #(W) cs_3in_744 (.a(a[ 744*W +: 3*W ]), .sum(sum744 ), .cout(c744 ) );
 carry_save_3inputs #(W) cs_3in_747 (.a(a[ 747*W +: 3*W ]), .sum(sum747 ), .cout(c747 ) );
 carry_save_3inputs #(W) cs_3in_750 (.a(a[ 750*W +: 3*W ]), .sum(sum750 ), .cout(c750 ) );
 carry_save_3inputs #(W) cs_3in_753 (.a(a[ 753*W +: 3*W ]), .sum(sum753 ), .cout(c753 ) );
 carry_save_3inputs #(W) cs_3in_756 (.a(a[ 756*W +: 3*W ]), .sum(sum756 ), .cout(c756 ) );
 carry_save_3inputs #(W) cs_3in_759 (.a(a[ 759*W +: 3*W ]), .sum(sum759 ), .cout(c759 ) );
 carry_save_3inputs #(W) cs_3in_762 (.a(a[ 762*W +: 3*W ]), .sum(sum762 ), .cout(c762 ) );
 carry_save_3inputs #(W) cs_3in_765 (.a(a[ 765*W +: 3*W ]), .sum(sum765 ), .cout(c765 ) );
 carry_save_3inputs #(W) cs_3in_768 (.a(a[ 768*W +: 3*W ]), .sum(sum768 ), .cout(c768 ) );
 carry_save_3inputs #(W) cs_3in_771 (.a(a[ 771*W +: 3*W ]), .sum(sum771 ), .cout(c771 ) );
 carry_save_3inputs #(W) cs_3in_774 (.a(a[ 774*W +: 3*W ]), .sum(sum774 ), .cout(c774 ) );
 carry_save_3inputs #(W) cs_3in_777 (.a(a[ 777*W +: 3*W ]), .sum(sum777 ), .cout(c777 ) );
 carry_save_3inputs #(W) cs_3in_780 (.a(a[ 780*W +: 3*W ]), .sum(sum780 ), .cout(c780 ) );
 carry_save_3inputs #(W) cs_3in_783 (.a(a[ 783*W +: 3*W ]), .sum(sum783 ), .cout(c783 ) );
 carry_save_3inputs #(W) cs_3in_786 (.a(a[ 786*W +: 3*W ]), .sum(sum786 ), .cout(c786 ) );
 carry_save_3inputs #(W) cs_3in_789 (.a(a[ 789*W +: 3*W ]), .sum(sum789 ), .cout(c789 ) );
 carry_save_3inputs #(W) cs_3in_792 (.a(a[ 792*W +: 3*W ]), .sum(sum792 ), .cout(c792 ) );
 carry_save_3inputs #(W) cs_3in_795 (.a(a[ 795*W +: 3*W ]), .sum(sum795 ), .cout(c795 ) );
 carry_save_3inputs #(W) cs_3in_798 (.a(a[ 798*W +: 3*W ]), .sum(sum798 ), .cout(c798 ) );
 carry_save_3inputs #(W) cs_3in_801 (.a(a[ 801*W +: 3*W ]), .sum(sum801 ), .cout(c801 ) );
 carry_save_3inputs #(W) cs_3in_804 (.a(a[ 804*W +: 3*W ]), .sum(sum804 ), .cout(c804 ) );
 carry_save_3inputs #(W) cs_3in_807 (.a(a[ 807*W +: 3*W ]), .sum(sum807 ), .cout(c807 ) );
 carry_save_3inputs #(W) cs_3in_810 (.a(a[ 810*W +: 3*W ]), .sum(sum810 ), .cout(c810 ) );
 carry_save_3inputs #(W) cs_3in_813 (.a(a[ 813*W +: 3*W ]), .sum(sum813 ), .cout(c813 ) );
 carry_save_3inputs #(W) cs_3in_816 (.a(a[ 816*W +: 3*W ]), .sum(sum816 ), .cout(c816 ) );
 carry_save_3inputs #(W) cs_3in_819 (.a(a[ 819*W +: 3*W ]), .sum(sum819 ), .cout(c819 ) );
 carry_save_3inputs #(W) cs_3in_822 (.a(a[ 822*W +: 3*W ]), .sum(sum822 ), .cout(c822 ) );
 carry_save_3inputs #(W) cs_3in_825 (.a(a[ 825*W +: 3*W ]), .sum(sum825 ), .cout(c825 ) );
 carry_save_3inputs #(W) cs_3in_828 (.a(a[ 828*W +: 3*W ]), .sum(sum828 ), .cout(c828 ) );
 carry_save_3inputs #(W) cs_3in_831 (.a(a[ 831*W +: 3*W ]), .sum(sum831 ), .cout(c831 ) );
 carry_save_3inputs #(W) cs_3in_834 (.a(a[ 834*W +: 3*W ]), .sum(sum834 ), .cout(c834 ) );
 carry_save_3inputs #(W) cs_3in_837 (.a(a[ 837*W +: 3*W ]), .sum(sum837 ), .cout(c837 ) );
 carry_save_3inputs #(W) cs_3in_840 (.a(a[ 840*W +: 3*W ]), .sum(sum840 ), .cout(c840 ) );
 carry_save_3inputs #(W) cs_3in_843 (.a(a[ 843*W +: 3*W ]), .sum(sum843 ), .cout(c843 ) );
 carry_save_3inputs #(W) cs_3in_846 (.a(a[ 846*W +: 3*W ]), .sum(sum846 ), .cout(c846 ) );
 carry_save_3inputs #(W) cs_3in_849 (.a(a[ 849*W +: 3*W ]), .sum(sum849 ), .cout(c849 ) );
 carry_save_3inputs #(W) cs_3in_852 (.a(a[ 852*W +: 3*W ]), .sum(sum852 ), .cout(c852 ) );
 carry_save_3inputs #(W) cs_3in_855 (.a(a[ 855*W +: 3*W ]), .sum(sum855 ), .cout(c855 ) );
 carry_save_3inputs #(W) cs_3in_858 (.a(a[ 858*W +: 3*W ]), .sum(sum858 ), .cout(c858 ) );
 carry_save_3inputs #(W) cs_3in_861 (.a(a[ 861*W +: 3*W ]), .sum(sum861 ), .cout(c861 ) );
 carry_save_3inputs #(W) cs_3in_864 (.a(a[ 864*W +: 3*W ]), .sum(sum864 ), .cout(c864 ) );
 carry_save_3inputs #(W) cs_3in_867 (.a(a[ 867*W +: 3*W ]), .sum(sum867 ), .cout(c867 ) );
 carry_save_3inputs #(W) cs_3in_870 (.a(a[ 870*W +: 3*W ]), .sum(sum870 ), .cout(c870 ) );
 carry_save_3inputs #(W) cs_3in_873 (.a(a[ 873*W +: 3*W ]), .sum(sum873 ), .cout(c873 ) );
 carry_save_3inputs #(W) cs_3in_876 (.a(a[ 876*W +: 3*W ]), .sum(sum876 ), .cout(c876 ) );
 carry_save_3inputs #(W) cs_3in_879 (.a(a[ 879*W +: 3*W ]), .sum(sum879 ), .cout(c879 ) );
 carry_save_3inputs #(W) cs_3in_882 (.a(a[ 882*W +: 3*W ]), .sum(sum882 ), .cout(c882 ) );
 carry_save_3inputs #(W) cs_3in_885 (.a(a[ 885*W +: 3*W ]), .sum(sum885 ), .cout(c885 ) );
 carry_save_3inputs #(W) cs_3in_888 (.a(a[ 888*W +: 3*W ]), .sum(sum888 ), .cout(c888 ) );
 carry_save_3inputs #(W) cs_3in_891 (.a(a[ 891*W +: 3*W ]), .sum(sum891 ), .cout(c891 ) );
 carry_save_3inputs #(W) cs_3in_894 (.a(a[ 894*W +: 3*W ]), .sum(sum894 ), .cout(c894 ) );
 carry_save_3inputs #(W) cs_3in_897 (.a(a[ 897*W +: 3*W ]), .sum(sum897 ), .cout(c897 ) );
 carry_save_3inputs #(W) cs_3in_900 (.a(a[ 900*W +: 3*W ]), .sum(sum900 ), .cout(c900 ) );
 carry_save_3inputs #(W) cs_3in_903 (.a(a[ 903*W +: 3*W ]), .sum(sum903 ), .cout(c903 ) );
 carry_save_3inputs #(W) cs_3in_906 (.a(a[ 906*W +: 3*W ]), .sum(sum906 ), .cout(c906 ) );
 carry_save_3inputs #(W) cs_3in_909 (.a(a[ 909*W +: 3*W ]), .sum(sum909 ), .cout(c909 ) );
 carry_save_3inputs #(W) cs_3in_912 (.a(a[ 912*W +: 3*W ]), .sum(sum912 ), .cout(c912 ) ); 
 carry_save_3inputs #(W) cs_3in_915 (.a(a[ 915*W +: 3*W ]), .sum(sum915 ), .cout(c915 ) );
 carry_save_3inputs #(W) cs_3in_918 (.a(a[ 918*W +: 3*W ]), .sum(sum918 ), .cout(c918 ) );
 carry_save_3inputs #(W) cs_3in_921 (.a(a[ 921*W +: 3*W ]), .sum(sum921 ), .cout(c921 ) );
 carry_save_3inputs #(W) cs_3in_924 (.a(a[ 924*W +: 3*W ]), .sum(sum924 ), .cout(c924 ) );
 carry_save_3inputs #(W) cs_3in_927 (.a(a[ 927*W +: 3*W ]), .sum(sum927 ), .cout(c927 ) );
 carry_save_3inputs #(W) cs_3in_930 (.a(a[ 930*W +: 3*W ]), .sum(sum930 ), .cout(c930 ) );
 carry_save_3inputs #(W) cs_3in_933 (.a(a[ 933*W +: 3*W ]), .sum(sum933 ), .cout(c933 ) );
 carry_save_3inputs #(W) cs_3in_936 (.a(a[ 936*W +: 3*W ]), .sum(sum936 ), .cout(c936 ) );
 carry_save_3inputs #(W) cs_3in_939 (.a(a[ 939*W +: 3*W ]), .sum(sum939 ), .cout(c939 ) );
 carry_save_3inputs #(W) cs_3in_942 (.a(a[ 942*W +: 3*W ]), .sum(sum942 ), .cout(c942 ) );
 carry_save_3inputs #(W) cs_3in_945 (.a(a[ 945*W +: 3*W ]), .sum(sum945 ), .cout(c945 ) );
 carry_save_3inputs #(W) cs_3in_948 (.a(a[ 948*W +: 3*W ]), .sum(sum948 ), .cout(c948 ) );
 carry_save_3inputs #(W) cs_3in_951 (.a(a[ 951*W +: 3*W ]), .sum(sum951 ), .cout(c951 ) );
 carry_save_3inputs #(W) cs_3in_954 (.a(a[ 954*W +: 3*W ]), .sum(sum954 ), .cout(c954 ) );
 carry_save_3inputs #(W) cs_3in_957 (.a(a[ 957*W +: 3*W ]), .sum(sum957 ), .cout(c957 ) );
 carry_save_3inputs #(W) cs_3in_960 (.a(a[ 960*W +: 3*W ]), .sum(sum960 ), .cout(c960 ) );
 carry_save_3inputs #(W) cs_3in_963 (.a(a[ 963*W +: 3*W ]), .sum(sum963 ), .cout(c963 ) );
 carry_save_3inputs #(W) cs_3in_966 (.a(a[ 966*W +: 3*W ]), .sum(sum966 ), .cout(c966 ) );
 carry_save_3inputs #(W) cs_3in_969 (.a(a[ 969*W +: 3*W ]), .sum(sum969 ), .cout(c969 ) );
 carry_save_3inputs #(W) cs_3in_972 (.a(a[ 972*W +: 3*W ]), .sum(sum972 ), .cout(c972 ) );
 carry_save_3inputs #(W) cs_3in_975 (.a(a[ 975*W +: 3*W ]), .sum(sum975 ), .cout(c975 ) );
 carry_save_3inputs #(W) cs_3in_978 (.a(a[ 978*W +: 3*W ]), .sum(sum978 ), .cout(c978 ) );
 carry_save_3inputs #(W) cs_3in_981 (.a(a[ 981*W +: 3*W ]), .sum(sum981 ), .cout(c981 ) );
 carry_save_3inputs #(W) cs_3in_984 (.a(a[ 984*W +: 3*W ]), .sum(sum984 ), .cout(c984 ) );
 carry_save_3inputs #(W) cs_3in_987 (.a(a[ 987*W +: 3*W ]), .sum(sum987 ), .cout(c987 ) );
 carry_save_3inputs #(W) cs_3in_990 (.a(a[ 990*W +: 3*W ]), .sum(sum990 ), .cout(c990 ) );
 carry_save_3inputs #(W) cs_3in_993 (.a(a[ 993*W +: 3*W ]), .sum(sum993 ), .cout(c993 ) );
 carry_save_3inputs #(W) cs_3in_996 (.a(a[ 996*W +: 3*W ]), .sum(sum996 ), .cout(c996 ) );
 carry_save_3inputs #(W) cs_3in_999 (.a(a[ 999*W +: 3*W ]), .sum(sum999 ), .cout(c999 ) );
 carry_save_3inputs #(W) cs_3in_1002(.a(a[1002*W +: 3*W ]), .sum(sum1002), .cout(c1002) );
 carry_save_3inputs #(W) cs_3in_1005(.a(a[1005*W +: 3*W ]), .sum(sum1005), .cout(c1005) );
 carry_save_3inputs #(W) cs_3in_1008(.a(a[1008*W +: 3*W ]), .sum(sum1008), .cout(c1008) );
 carry_save_3inputs #(W) cs_3in_1011(.a(a[1011*W +: 3*W ]), .sum(sum1011), .cout(c1011) );
 carry_save_3inputs #(W) cs_3in_1014(.a(a[1014*W +: 3*W ]), .sum(sum1014), .cout(c1014) );
 carry_save_3inputs #(W) cs_3in_1017(.a(a[1017*W +: 3*W ]), .sum(sum1017), .cout(c1017) );
 carry_save_3inputs #(W) cs_3in_1020(.a(a[1020*W +: 3*W ]), .sum(sum1020), .cout(c1020) );// a(1023)

 carry_save_3inputs #(W+1) cs_3in_01(.a({ sum000, c000, sum003  }),               .sum(sum_01), .cout(c_01) );
 carry_save_3inputs #(W+1) cs_3in_02(.a({ c003, sum006,  c006   }),               .sum(sum_02), .cout(c_02) );
 carry_save_3inputs #(W+1) cs_3in_03(.a({ sum009, c009, sum012  }),               .sum(sum_03), .cout(c_03) );
 carry_save_3inputs #(W+1) cs_3in_04(.a({ c012, sum015,  c015   }),               .sum(sum_04), .cout(c_04) );
 carry_save_3inputs #(W+1) cs_3in_05(.a({ sum018, c018, sum021  }),               .sum(sum_05), .cout(c_05) );
 carry_save_3inputs #(W+1) cs_3in_06(.a({ c021, sum024,  c024   }),               .sum(sum_06), .cout(c_06) );
 carry_save_3inputs #(W+1) cs_3in_07(.a({ sum027, c027, sum030  }),               .sum(sum_07), .cout(c_07) );
 carry_save_3inputs #(W+1) cs_3in_08(.a({ c030, sum033,  c033   }),               .sum(sum_08), .cout(c_08) );
 carry_save_3inputs #(W+1) cs_3in_09(.a({ sum036, c036, sum039  }),               .sum(sum_09), .cout(c_09) );
 carry_save_3inputs #(W+1) cs_3in_10(.a({ c039, sum042,  c042   }),               .sum(sum_10), .cout(c_10) );
 carry_save_3inputs #(W+1) cs_3in_11(.a({ sum045, c045, sum048  }),               .sum(sum_11), .cout(c_11) );
 carry_save_3inputs #(W+1) cs_3in_12(.a({ c048, sum051,  c051   }),               .sum(sum_12), .cout(c_12) );
 carry_save_3inputs #(W+1) cs_3in_13(.a({ sum054, c054, sum057  }),               .sum(sum_13), .cout(c_13) );
 carry_save_3inputs #(W+1) cs_3in_14(.a({ c057, sum060,  c060   }),               .sum(sum_14), .cout(c_14) );
 carry_save_3inputs #(W+1) cs_3in_15(.a({ sum063, c063, sum066  }),               .sum(sum_15), .cout(c_15) );
 carry_save_3inputs #(W+1) cs_3in_16(.a({ c066, sum069,  c069   }),               .sum(sum_16), .cout(c_16) );
 carry_save_3inputs #(W+1) cs_3in_17(.a({ sum072, c072, sum075  }),               .sum(sum_17), .cout(c_17) );
 carry_save_3inputs #(W+1) cs_3in_18(.a({ c075, sum078,  c078   }),               .sum(sum_18), .cout(c_18) );
 carry_save_3inputs #(W+1) cs_3in_19(.a({ sum081, c081, sum084  }),               .sum(sum_19), .cout(c_19) );
 carry_save_3inputs #(W+1) cs_3in_20(.a({ c084, sum087,  c087   }),               .sum(sum_20), .cout(c_20) );
 carry_save_3inputs #(W+1) cs_3in_21(.a({ sum090, c090, sum093  }),               .sum(sum_21), .cout(c_21) );
 carry_save_3inputs #(W+1) cs_3in_22(.a({ c093, sum096,  c096   }),               .sum(sum_22), .cout(c_22) );
 carry_save_3inputs #(W+1) cs_3in_23(.a({ sum099, c099, sum102  }),               .sum(sum_23), .cout(c_23) );
 carry_save_3inputs #(W+1) cs_3in_24(.a({ c102, sum105,  c105   }),               .sum(sum_24), .cout(c_24) );
 carry_save_3inputs #(W+1) cs_3in_25(.a({ sum108, c108, sum111  }),               .sum(sum_25), .cout(c_25) );
 carry_save_3inputs #(W+1) cs_3in_26(.a({ c111, sum114,  c114   }),               .sum(sum_26), .cout(c_26) );
 carry_save_3inputs #(W+1) cs_3in_27(.a({ sum117, c117, sum120  }),               .sum(sum_27), .cout(c_27) );
 carry_save_3inputs #(W+1) cs_3in_28(.a({ c120, sum123,  c123   }),               .sum(sum_28), .cout(c_28) );
 carry_save_3inputs #(W+1) cs_3in_29(.a({ sum126, c126, sum129  }),               .sum(sum_29), .cout(c_29) );
 carry_save_3inputs #(W+1) cs_3in_30(.a({ c129, sum132,  c132   }),               .sum(sum_30), .cout(c_30) );
 carry_save_3inputs #(W+1) cs_3in_31(.a({ sum135, c135, sum138  }),               .sum(sum_31), .cout(c_31) );
 carry_save_3inputs #(W+1) cs_3in_32(.a({ c138, sum141,  c141   }),               .sum(sum_32), .cout(c_32) );
 carry_save_3inputs #(W+1) cs_3in_33(.a({ sum144, c144, sum147  }),               .sum(sum_33), .cout(c_33) );
 carry_save_3inputs #(W+1) cs_3in_34(.a({ c147, sum150,  c150   }),               .sum(sum_34), .cout(c_34) );
 carry_save_3inputs #(W+1) cs_3in_35(.a({ sum153, c153, sum156  }),               .sum(sum_35), .cout(c_35) );
 carry_save_3inputs #(W+1) cs_3in_36(.a({ c156, sum159,  c159   }),               .sum(sum_36), .cout(c_36) );
 carry_save_3inputs #(W+1) cs_3in_37(.a({ sum162, c162, sum165  }),               .sum(sum_37), .cout(c_37) );
 carry_save_3inputs #(W+1) cs_3in_38(.a({ c165, sum168,  c168   }),               .sum(sum_38), .cout(c_38) );
 carry_save_3inputs #(W+1) cs_3in_39(.a({ sum171, c171, sum174  }),               .sum(sum_39), .cout(c_39) );
 carry_save_3inputs #(W+1) cs_3in_40(.a({ c174, sum177,  c177   }),               .sum(sum_40), .cout(c_40) );
 carry_save_3inputs #(W+1) cs_3in_41(.a({ sum180, c180, sum183  }),               .sum(sum_41), .cout(c_41) );
 carry_save_3inputs #(W+1) cs_3in_42(.a({ c183, sum186,  c186   }),               .sum(sum_42), .cout(c_42) );
 carry_save_3inputs #(W+1) cs_3in_43(.a({ sum189, c189, sum192  }),               .sum(sum_43), .cout(c_43) );
 carry_save_3inputs #(W+1) cs_3in_44(.a({ c192, sum195,  c195   }),               .sum(sum_44), .cout(c_44) );
 carry_save_3inputs #(W+1) cs_3in_45(.a({ sum198, c198, sum201  }),               .sum(sum_45), .cout(c_45) );
 carry_save_3inputs #(W+1) cs_3in_46(.a({ c201, sum204,  c204   }),               .sum(sum_46), .cout(c_46) );
 carry_save_3inputs #(W+1) cs_3in_47(.a({ sum207, c207, sum210  }),               .sum(sum_47), .cout(c_47) );
 carry_save_3inputs #(W+1) cs_3in_48(.a({ c210, sum213,  c213   }),               .sum(sum_48), .cout(c_48) );
 carry_save_3inputs #(W+1) cs_3in_49(.a({ sum216, c216, sum219  }),               .sum(sum_49), .cout(c_49) );
 carry_save_3inputs #(W+1) cs_3in_50(.a({ c219, sum222,  c222   }),               .sum(sum_50), .cout(c_50) );
 carry_save_3inputs #(W+1) cs_3in_51(.a({ sum225, c225, sum228  }),               .sum(sum_51), .cout(c_51) );
 carry_save_3inputs #(W+1) cs_3in_52(.a({ c228, sum231,  c231   }),               .sum(sum_52), .cout(c_52) );
 carry_save_3inputs #(W+1) cs_3in_53(.a({ sum234, c234, sum237  }),               .sum(sum_53), .cout(c_53) );
 carry_save_3inputs #(W+1) cs_3in_54(.a({ c237, sum240,  c240   }),               .sum(sum_54), .cout(c_54) );
 carry_save_3inputs #(W+1) cs_3in_55(.a({ sum243, c243, sum246  }),               .sum(sum_55), .cout(c_55) );
 carry_save_3inputs #(W+1) cs_3in_56(.a({ c246, sum249,  c249   }),               .sum(sum_56), .cout(c_56) );
 carry_save_3inputs #(W+1) cs_3in_57(.a({ sum252, c252, sum255  }),               .sum(sum_57), .cout(c_57) );
 carry_save_3inputs #(W+1) cs_3in_58(.a({ c255, sum258,  c258   }),               .sum(sum_58), .cout(c_58) );
 carry_save_3inputs #(W+1) cs_3in_59(.a({ sum261, c261, sum264  }),               .sum(sum_59), .cout(c_59) );
 carry_save_3inputs #(W+1) cs_3in_60(.a({ c264, sum267,  c267   }),               .sum(sum_60), .cout(c_60) );
 carry_save_3inputs #(W+1) cs_3in_61(.a({ sum270, c270, sum273  }),               .sum(sum_61), .cout(c_61) );
 carry_save_3inputs #(W+1) cs_3in_62(.a({  c273, sum276,  c276  }),               .sum(sum_62), .cout(c_62) );
 carry_save_3inputs #(W+1) cs_3in_63(.a({ sum279, c279, sum282  }),               .sum(sum_63), .cout(c_63) );
 carry_save_3inputs #(W+1) cs_3in_64(.a({ c282, sum285,  c285   }),               .sum(sum_64), .cout(c_64) );
 carry_save_3inputs #(W+1) cs_3in_65(.a({ sum288, c288, sum291  }),               .sum(sum_65), .cout(c_65) );
 carry_save_3inputs #(W+1) cs_3in_66(.a({ c291, sum294,  c294   }),               .sum(sum_66), .cout(c_66) );
 carry_save_3inputs #(W+1) cs_3in_67(.a({ sum297, c297, sum300  }),               .sum(sum_67), .cout(c_67) );
 carry_save_3inputs #(W+1) cs_3in_68(.a({ c300, sum303,  c303   }),               .sum(sum_68), .cout(c_68) );
 carry_save_3inputs #(W+1) cs_3in_69(.a({ sum306, c306, sum309  }),               .sum(sum_69), .cout(c_69) );
 carry_save_3inputs #(W+1) cs_3in_70(.a({ c309, sum312,  c312   }),               .sum(sum_70), .cout(c_70) );
 carry_save_3inputs #(W+1) cs_3in_71(.a({ sum315, c315, sum318  }),               .sum(sum_71), .cout(c_71) );
 carry_save_3inputs #(W+1) cs_3in_72(.a({ c318, sum321,  c321   }),               .sum(sum_72), .cout(c_72) );
 carry_save_3inputs #(W+1) cs_3in_73(.a({ sum324, c324, sum327  }),               .sum(sum_73), .cout(c_73) );
 carry_save_3inputs #(W+1) cs_3in_74(.a({ c327, sum330,  c330   }),               .sum(sum_74), .cout(c_74) );
 carry_save_3inputs #(W+1) cs_3in_75(.a({ sum333, c333, sum336  }),               .sum(sum_75), .cout(c_75) );
 carry_save_3inputs #(W+1) cs_3in_76(.a({ c336, sum339,  c339   }),               .sum(sum_76), .cout(c_76) );
 carry_save_3inputs #(W+1) cs_3in_77(.a({ sum342, c342, sum345  }),               .sum(sum_77), .cout(c_77) );
 carry_save_3inputs #(W+1) cs_3in_78(.a({ c345, sum348,  c348   }),               .sum(sum_78), .cout(c_78) );
 carry_save_3inputs #(W+1) cs_3in_79(.a({ sum351, c351, sum354  }),               .sum(sum_79), .cout(c_79) );
 carry_save_3inputs #(W+1) cs_3in_80(.a({ c354, sum357,  c357   }),               .sum(sum_80), .cout(c_80) );
 carry_save_3inputs #(W+1) cs_3in_81(.a({ sum360, c360, sum363  }),               .sum(sum_81), .cout(c_81) );
 carry_save_3inputs #(W+1) cs_3in_82(.a({ c363, sum366,  c366   }),               .sum(sum_82), .cout(c_82) );
 carry_save_3inputs #(W+1) cs_3in_83(.a({ sum369, c369, sum372  }),               .sum(sum_83), .cout(c_83) );
 carry_save_3inputs #(W+1) cs_3in_84(.a({ c372, sum375,  c375   }),               .sum(sum_84), .cout(c_84) );
 carry_save_3inputs #(W+1) cs_3in_85(.a({ sum378, c378, sum381  }),               .sum(sum_85), .cout(c_85) );
 carry_save_3inputs #(W+1) cs_3in_86(.a({  c381, sum384,  c384  }),               .sum(sum_86), .cout(c_86) );
 carry_save_3inputs #(W+1) cs_3in_87(.a({ sum387, c387, sum390  }),               .sum(sum_87), .cout(c_87) );
 carry_save_3inputs #(W+1) cs_3in_88(.a({ c390, sum393,  c393   }),               .sum(sum_88), .cout(c_88) );
 carry_save_3inputs #(W+1) cs_3in_89(.a({ sum396, c396, sum399  }),               .sum(sum_89), .cout(c_89) );
 carry_save_3inputs #(W+1) cs_3in_90(.a({ c399, sum402,  c402   }),               .sum(sum_90), .cout(c_90) );
 carry_save_3inputs #(W+1) cs_3in_91(.a({ sum405, c405, sum408  }),               .sum(sum_91), .cout(c_91) );
 carry_save_3inputs #(W+1) cs_3in_92(.a({ c408, sum411,  c411   }),               .sum(sum_92), .cout(c_92) );
 carry_save_3inputs #(W+1) cs_3in_93(.a({ sum414, c414, sum417  }),               .sum(sum_93), .cout(c_93) );
 carry_save_3inputs #(W+1) cs_3in_94(.a({ c417, sum420,  c420   }),               .sum(sum_94), .cout(c_94) );
 carry_save_3inputs #(W+1) cs_3in_95(.a({ sum423, c423, sum426  }),               .sum(sum_95), .cout(c_95) );
 carry_save_3inputs #(W+1) cs_3in_96(.a({ c426, sum429,  c429   }),               .sum(sum_96), .cout(c_96) );
 carry_save_3inputs #(W+1) cs_3in_97(.a({ sum432, c432, sum435  }),               .sum(sum_97), .cout(c_97) );
 carry_save_3inputs #(W+1) cs_3in_98(.a({ c435, sum438,  c438   }),               .sum(sum_98), .cout(c_98) );
 carry_save_3inputs #(W+1) cs_3in_99(.a({ sum441, c441, sum444  }),               .sum(sum_99), .cout(c_99) );
 carry_save_3inputs #(W+1) cs_3in_a0(.a({ c444, sum447,  c447   }),               .sum(sum_a0), .cout(c_a0) );
 carry_save_3inputs #(W+1) cs_3in_a1(.a({ sum450, c450, sum453  }),               .sum(sum_a1), .cout(c_a1) );
 carry_save_3inputs #(W+1) cs_3in_a2(.a({ c453, sum456,  c456   }),               .sum(sum_a2), .cout(c_a2) );
 carry_save_3inputs #(W+1) cs_3in_a3(.a({ sum459, c459, sum462  }),               .sum(sum_a3), .cout(c_a3) );
 carry_save_3inputs #(W+1) cs_3in_a4(.a({ c462, sum465,  c465   }),               .sum(sum_a4), .cout(c_a4) );
 carry_save_3inputs #(W+1) cs_3in_a5(.a({ sum468, c468, sum471  }),               .sum(sum_a5), .cout(c_a5) );
 carry_save_3inputs #(W+1) cs_3in_a6(.a({ c471, sum474,  c474   }),               .sum(sum_a6), .cout(c_a6) );
 carry_save_3inputs #(W+1) cs_3in_a7(.a({ sum477, c477, sum480  }),               .sum(sum_a7), .cout(c_a7) );
 carry_save_3inputs #(W+1) cs_3in_a8(.a({ c480, sum483,  c483   }),               .sum(sum_a8), .cout(c_a8) );
 carry_save_3inputs #(W+1) cs_3in_a9(.a({ sum486, c486, sum489  }),               .sum(sum_a9), .cout(c_a9) );
 carry_save_3inputs #(W+1) cs_3in_b0(.a({ c489, sum492,  c492   }),               .sum(sum_b0), .cout(c_b0) );
 carry_save_3inputs #(W+1) cs_3in_b1(.a({ sum495, c495, sum498  }),               .sum(sum_b1), .cout(c_b1) );
 carry_save_3inputs #(W+1) cs_3in_b2(.a({  c498, sum501,  c501  }),               .sum(sum_b2), .cout(c_b2) );
 carry_save_3inputs #(W+1) cs_3in_b3(.a({ sum504, c504, sum507  }),               .sum(sum_b3), .cout(c_b3) );
 carry_save_3inputs #(W+1) cs_3in_b4(.a({  c507, sum510 , c510  }),               .sum(sum_b4), .cout(c_b4) ); 

 carry_save_3inputs #(W+1) cs_3in_b5(.a({sum513 , c513, sum516  }),               .sum(sum_b5), .cout(c_b5) );
 carry_save_3inputs #(W+1) cs_3in_b6(.a({  c516, sum519 , c519  }),               .sum(sum_b6), .cout(c_b6) );
 carry_save_3inputs #(W+1) cs_3in_b7(.a({sum522 , c522, sum525  }),               .sum(sum_b7), .cout(c_b7) );
 carry_save_3inputs #(W+1) cs_3in_b8(.a({  c525, sum528 , c528  }),               .sum(sum_b8), .cout(c_b8) );
 carry_save_3inputs #(W+1) cs_3in_b9(.a({sum531 , c531, sum534  }),               .sum(sum_b9), .cout(c_b9) );
 carry_save_3inputs #(W+1) cs_3in_c0(.a({  c534, sum537 , c537  }),               .sum(sum_c0), .cout(c_c0) );
 carry_save_3inputs #(W+1) cs_3in_c1(.a({sum540 , c540, sum543  }),               .sum(sum_c1), .cout(c_c1) );
 carry_save_3inputs #(W+1) cs_3in_c2(.a({  c543, sum546 , c546  }),               .sum(sum_c2), .cout(c_c2) );
 carry_save_3inputs #(W+1) cs_3in_c3(.a({sum549 , c549, sum552  }),               .sum(sum_c3), .cout(c_c3) );
 carry_save_3inputs #(W+1) cs_3in_c4(.a({  c552, sum555 , c555  }),               .sum(sum_c4), .cout(c_c4) );
 carry_save_3inputs #(W+1) cs_3in_c5(.a({sum558 , c558, sum561  }),               .sum(sum_c5), .cout(c_c5) );
 carry_save_3inputs #(W+1) cs_3in_c6(.a({  c561, sum564 , c564  }),               .sum(sum_c6), .cout(c_c6) );
 carry_save_3inputs #(W+1) cs_3in_c7(.a({sum567 , c567, sum570  }),               .sum(sum_c7), .cout(c_c7) );
 carry_save_3inputs #(W+1) cs_3in_c8(.a({  c570, sum573 , c573  }),               .sum(sum_c8), .cout(c_c8) );
 carry_save_3inputs #(W+1) cs_3in_c9(.a({sum576 , c576, sum579  }),               .sum(sum_c9), .cout(c_c9) );
 carry_save_3inputs #(W+1) cs_3in_d0(.a({  c579, sum582 , c582  }),               .sum(sum_d0), .cout(c_d0) );
 carry_save_3inputs #(W+1) cs_3in_d1(.a({sum585 , c585, sum588  }),               .sum(sum_d1), .cout(c_d1) );
 carry_save_3inputs #(W+1) cs_3in_d2(.a({  c588, sum591 , c591  }),               .sum(sum_d2), .cout(c_d2) );
 carry_save_3inputs #(W+1) cs_3in_d3(.a({sum594 , c594, sum597  }),               .sum(sum_d3), .cout(c_d3) );
 carry_save_3inputs #(W+1) cs_3in_d4(.a({  c597, sum600 , c600  }),               .sum(sum_d4), .cout(c_d4) );
 carry_save_3inputs #(W+1) cs_3in_d5(.a({sum603 , c603, sum606  }),               .sum(sum_d5), .cout(c_d5) );
 carry_save_3inputs #(W+1) cs_3in_d6(.a({  c606, sum609 , c609  }),               .sum(sum_d6), .cout(c_d6) );
 carry_save_3inputs #(W+1) cs_3in_d7(.a({sum612 , c612, sum615  }),               .sum(sum_d7), .cout(c_d7) );
 carry_save_3inputs #(W+1) cs_3in_d8(.a({  c615, sum618 , c618  }),               .sum(sum_d8), .cout(c_d8) );
 carry_save_3inputs #(W+1) cs_3in_d9(.a({sum621 , c621, sum624  }),               .sum(sum_d9), .cout(c_d9) );
 carry_save_3inputs #(W+1) cs_3in_e0(.a({  c624, sum627 , c627  }),               .sum(sum_e0), .cout(c_e0) );
 carry_save_3inputs #(W+1) cs_3in_e1(.a({sum630 , c630, sum633  }),               .sum(sum_e1), .cout(c_e1) );
 carry_save_3inputs #(W+1) cs_3in_e2(.a({  c633, sum636 , c636  }),               .sum(sum_e2), .cout(c_e2) );
 carry_save_3inputs #(W+1) cs_3in_e3(.a({sum639 , c639, sum642  }),               .sum(sum_e3), .cout(c_e3) );
 carry_save_3inputs #(W+1) cs_3in_e4(.a({  c642, sum645 , c645  }),               .sum(sum_e4), .cout(c_e4) );
 carry_save_3inputs #(W+1) cs_3in_e5(.a({sum648 , c648, sum651  }),               .sum(sum_e5), .cout(c_e5) );
 carry_save_3inputs #(W+1) cs_3in_e6(.a({  c651, sum654 , c654  }),               .sum(sum_e6), .cout(c_e6) );
 carry_save_3inputs #(W+1) cs_3in_e7(.a({sum657 , c657, sum660  }),               .sum(sum_e7), .cout(c_e7) );
 carry_save_3inputs #(W+1) cs_3in_e8(.a({  c660, sum663 , c663  }),               .sum(sum_e8), .cout(c_e8) );
 carry_save_3inputs #(W+1) cs_3in_e9(.a({sum666 , c666, sum669  }),               .sum(sum_e9), .cout(c_e9) );
 carry_save_3inputs #(W+1) cs_3in_f0(.a({  c669, sum672 , c672  }),               .sum(sum_f0), .cout(c_f0) );
 carry_save_3inputs #(W+1) cs_3in_f1(.a({sum675 , c675, sum678  }),               .sum(sum_f1), .cout(c_f1) );
 carry_save_3inputs #(W+1) cs_3in_f2(.a({  c678, sum681 , c681  }),               .sum(sum_f2), .cout(c_f2) );
 carry_save_3inputs #(W+1) cs_3in_f3(.a({sum684 , c684, sum687  }),               .sum(sum_f3), .cout(c_f3) );
 carry_save_3inputs #(W+1) cs_3in_f4(.a({  c687, sum690 , c690  }),               .sum(sum_f4), .cout(c_f4) );
 carry_save_3inputs #(W+1) cs_3in_f5(.a({sum693 , c693, sum696  }),               .sum(sum_f5), .cout(c_f5) );
 carry_save_3inputs #(W+1) cs_3in_f6(.a({  c696, sum699 , c699  }),               .sum(sum_f6), .cout(c_f6) );
 carry_save_3inputs #(W+1) cs_3in_f7(.a({sum702 , c702, sum705  }),               .sum(sum_f7), .cout(c_f7) );
 carry_save_3inputs #(W+1) cs_3in_f8(.a({  c705, sum708 , c708  }),               .sum(sum_f8), .cout(c_f8) );
 carry_save_3inputs #(W+1) cs_3in_f9(.a({sum711 , c711, sum714  }),               .sum(sum_f9), .cout(c_f9) );
 carry_save_3inputs #(W+1) cs_3in_g0(.a({  c714, sum717 , c717  }),               .sum(sum_g0), .cout(c_g0) );
 carry_save_3inputs #(W+1) cs_3in_g1(.a({sum720 , c720, sum723  }),               .sum(sum_g1), .cout(c_g1) );
 carry_save_3inputs #(W+1) cs_3in_g2(.a({  c723, sum726 , c726  }),               .sum(sum_g2), .cout(c_g2) );
 carry_save_3inputs #(W+1) cs_3in_g3(.a({sum729 , c729, sum732  }),               .sum(sum_g3), .cout(c_g3) );
 carry_save_3inputs #(W+1) cs_3in_g4(.a({  c732, sum735 , c735  }),               .sum(sum_g4), .cout(c_g4) );
 carry_save_3inputs #(W+1) cs_3in_g5(.a({sum738 , c738, sum741  }),               .sum(sum_g5), .cout(c_g5) );
 carry_save_3inputs #(W+1) cs_3in_g6(.a({  c741, sum744 , c744  }),               .sum(sum_g6), .cout(c_g6) );
 carry_save_3inputs #(W+1) cs_3in_g7(.a({sum747 , c747, sum750  }),               .sum(sum_g7), .cout(c_g7) );
 carry_save_3inputs #(W+1) cs_3in_g8(.a({  c750, sum753 , c753  }),               .sum(sum_g8), .cout(c_g8) );
 carry_save_3inputs #(W+1) cs_3in_g9(.a({sum756 , c756, sum759  }),               .sum(sum_g9), .cout(c_g9) );
 carry_save_3inputs #(W+1) cs_3in_h0(.a({  c759, sum762 , c762  }),               .sum(sum_h0), .cout(c_h0) );
 carry_save_3inputs #(W+1) cs_3in_h1(.a({sum765 , c765, sum768  }),               .sum(sum_h1), .cout(c_h1) );
 carry_save_3inputs #(W+1) cs_3in_h2(.a({  c768, sum771 , c771  }),               .sum(sum_h2), .cout(c_h2) );
 carry_save_3inputs #(W+1) cs_3in_h3(.a({sum774 , c774, sum777  }),               .sum(sum_h3), .cout(c_h3) );
 carry_save_3inputs #(W+1) cs_3in_h4(.a({  c777, sum780 , c780  }),               .sum(sum_h4), .cout(c_h4) );
 carry_save_3inputs #(W+1) cs_3in_h5(.a({sum783 , c783, sum786  }),               .sum(sum_h5), .cout(c_h5) );
 carry_save_3inputs #(W+1) cs_3in_h6(.a({  c786, sum789 , c789  }),               .sum(sum_h6), .cout(c_h6) );
 carry_save_3inputs #(W+1) cs_3in_h7(.a({sum792 , c792, sum795  }),               .sum(sum_h7), .cout(c_h7) );
 carry_save_3inputs #(W+1) cs_3in_h8(.a({  c795, sum798 , c798  }),               .sum(sum_h8), .cout(c_h8) );
 carry_save_3inputs #(W+1) cs_3in_h9(.a({sum801 , c801, sum804  }),               .sum(sum_h9), .cout(c_h9) );
 carry_save_3inputs #(W+1) cs_3in_i0(.a({  c804, sum807 , c807  }),               .sum(sum_i0), .cout(c_i0) );
 carry_save_3inputs #(W+1) cs_3in_i1(.a({sum810 , c810, sum813  }),               .sum(sum_i1), .cout(c_i1) );
 carry_save_3inputs #(W+1) cs_3in_i2(.a({  c813, sum816 , c816  }),               .sum(sum_i2), .cout(c_i2) );
 carry_save_3inputs #(W+1) cs_3in_i3(.a({sum819 , c819, sum822  }),               .sum(sum_i3), .cout(c_i3) );
 carry_save_3inputs #(W+1) cs_3in_i4(.a({  c822, sum825 , c825  }),               .sum(sum_i4), .cout(c_i4) );
 carry_save_3inputs #(W+1) cs_3in_i5(.a({sum828 , c828, sum831  }),               .sum(sum_i5), .cout(c_i5) );
 carry_save_3inputs #(W+1) cs_3in_i6(.a({  c831, sum834 , c834  }),               .sum(sum_i6), .cout(c_i6) );
 carry_save_3inputs #(W+1) cs_3in_i7(.a({sum837 , c837, sum840  }),               .sum(sum_i7), .cout(c_i7) );
 carry_save_3inputs #(W+1) cs_3in_i8(.a({  c840, sum843 , c843  }),               .sum(sum_i8), .cout(c_i8) );
 carry_save_3inputs #(W+1) cs_3in_i9(.a({sum846 , c846, sum849  }),               .sum(sum_i9), .cout(c_i9) );
 carry_save_3inputs #(W+1) cs_3in_j0(.a({  c849, sum852 , c852  }),               .sum(sum_j0), .cout(c_j0) );
 carry_save_3inputs #(W+1) cs_3in_j1(.a({sum855 , c855, sum858  }),               .sum(sum_j1), .cout(c_j1) );
 carry_save_3inputs #(W+1) cs_3in_j2(.a({  c858, sum861 , c861  }),               .sum(sum_j2), .cout(c_j2) );
 carry_save_3inputs #(W+1) cs_3in_j3(.a({sum864 , c864, sum867  }),               .sum(sum_j3), .cout(c_j3) );
 carry_save_3inputs #(W+1) cs_3in_j4(.a({  c867, sum870 , c870  }),               .sum(sum_j4), .cout(c_j4) );
 carry_save_3inputs #(W+1) cs_3in_j5(.a({sum873 , c873, sum876  }),               .sum(sum_j5), .cout(c_j5) );
 carry_save_3inputs #(W+1) cs_3in_j6(.a({  c876, sum879 , c879  }),               .sum(sum_j6), .cout(c_j6) );
 carry_save_3inputs #(W+1) cs_3in_j7(.a({sum882 , c882, sum885  }),               .sum(sum_j7), .cout(c_j7) );
 carry_save_3inputs #(W+1) cs_3in_j8(.a({  c885, sum888 , c888  }),               .sum(sum_j8), .cout(c_j8) );
 carry_save_3inputs #(W+1) cs_3in_j9(.a({sum891 , c891, sum894  }),               .sum(sum_j9), .cout(c_j9) );
 carry_save_3inputs #(W+1) cs_3in_k0(.a({  c894, sum897 , c897  }),               .sum(sum_k0), .cout(c_k0) );
 carry_save_3inputs #(W+1) cs_3in_k1(.a({sum900 , c900, sum903  }),               .sum(sum_k1), .cout(c_k1) );
 carry_save_3inputs #(W+1) cs_3in_k2(.a({  c903, sum906 , c906  }),               .sum(sum_k2), .cout(c_k2) );
 carry_save_3inputs #(W+1) cs_3in_k3(.a({sum909 , c909, sum912  }),               .sum(sum_k3), .cout(c_k3) );
 carry_save_3inputs #(W+1) cs_3in_k4(.a({  c912, sum915 , c915  }),               .sum(sum_k4), .cout(c_k4) );
 carry_save_3inputs #(W+1) cs_3in_k5(.a({sum918 , c918, sum921  }),               .sum(sum_k5), .cout(c_k5) );
 carry_save_3inputs #(W+1) cs_3in_k6(.a({  c921, sum924 , c924  }),               .sum(sum_k6), .cout(c_k6) );
 carry_save_3inputs #(W+1) cs_3in_k7(.a({sum927 , c927, sum930  }),               .sum(sum_k7), .cout(c_k7) );
 carry_save_3inputs #(W+1) cs_3in_k8(.a({  c930, sum933 , c933  }),               .sum(sum_k8), .cout(c_k8) );
 carry_save_3inputs #(W+1) cs_3in_k9(.a({sum936 , c936, sum939  }),               .sum(sum_k9), .cout(c_k9) );
 carry_save_3inputs #(W+1) cs_3in_l0(.a({  c939, sum942 , c942  }),               .sum(sum_l0), .cout(c_l0) );
 carry_save_3inputs #(W+1) cs_3in_l1(.a({sum945 , c945, sum948  }),               .sum(sum_l1), .cout(c_l1) );
 carry_save_3inputs #(W+1) cs_3in_l2(.a({  c948, sum951 , c951  }),               .sum(sum_l2), .cout(c_l2) );
 carry_save_3inputs #(W+1) cs_3in_l3(.a({sum954 , c954, sum957  }),               .sum(sum_l3), .cout(c_l3) );
 carry_save_3inputs #(W+1) cs_3in_l4(.a({  c957, sum960 , c960  }),               .sum(sum_l4), .cout(c_l4) );
 carry_save_3inputs #(W+1) cs_3in_l5(.a({sum963 , c963, sum966  }),               .sum(sum_l5), .cout(c_l5) );
 carry_save_3inputs #(W+1) cs_3in_l6(.a({  c966, sum969 , c969  }),               .sum(sum_l6), .cout(c_l6) );
 carry_save_3inputs #(W+1) cs_3in_l7(.a({sum972 , c972, sum975  }),               .sum(sum_l7), .cout(c_l7) );
 carry_save_3inputs #(W+1) cs_3in_l8(.a({  c975, sum978 , c978  }),               .sum(sum_l8), .cout(c_l8) );
 carry_save_3inputs #(W+1) cs_3in_l9(.a({sum981 , c981, sum984  }),               .sum(sum_l9), .cout(c_l9) );
 carry_save_3inputs #(W+1) cs_3in_m0(.a({  c984, sum987 , c987  }),               .sum(sum_m0), .cout(c_m0) );
 carry_save_3inputs #(W+1) cs_3in_m1(.a({sum990 , c990, sum993  }),               .sum(sum_m1), .cout(c_m1) );
 carry_save_3inputs #(W+1) cs_3in_m2(.a({  c993, sum996 , c996  }),               .sum(sum_m2), .cout(c_m2) );
 carry_save_3inputs #(W+1) cs_3in_m3(.a({sum999 , c999, sum1002 }),               .sum(sum_m3), .cout(c_m3) );
 carry_save_3inputs #(W+1) cs_3in_m4(.a({ c1002, sum1005, c1005  }),              .sum(sum_m4), .cout(c_m4) );
 carry_save_3inputs #(W+1) cs_3in_m5(.a({sum1008, c1008, sum1011 }),              .sum(sum_m5), .cout(c_m5) );
 carry_save_3inputs #(W+1) cs_3in_m6(.a({ c1011, sum1014, c1014  }),              .sum(sum_m6), .cout(c_m6) );
 carry_save_3inputs #(W+1) cs_3in_m7(.a({sum1017, c1017, sum1020 }),              .sum(sum_m7), .cout(c_m7) ); // a(1023) - 2, c1020 do not added
 


carry_save_3inputs #(W+2) cs_3in_a161(.a({ sum_01, c_01, sum_02 }), .sum(sum_161), .cout(c_161) );
carry_save_3inputs #(W+2) cs_3in_a162(.a({ c_02, sum_03, c_03   }), .sum(sum_162), .cout(c_162) );
carry_save_3inputs #(W+2) cs_3in_a163(.a({ sum_04, c_04, sum_05 }), .sum(sum_163), .cout(c_163) );
carry_save_3inputs #(W+2) cs_3in_a164(.a({ c_05, sum_06, c_06   }), .sum(sum_164), .cout(c_164) );
carry_save_3inputs #(W+2) cs_3in_a165(.a({ sum_07, c_07, sum_08 }), .sum(sum_165), .cout(c_165) );
carry_save_3inputs #(W+2) cs_3in_a166(.a({ c_08, sum_09, c_09   }), .sum(sum_166), .cout(c_166) );
carry_save_3inputs #(W+2) cs_3in_a167(.a({ sum_10, c_10, sum_11 }), .sum(sum_167), .cout(c_167) );
carry_save_3inputs #(W+2) cs_3in_a168(.a({ c_11, sum_12, c_12   }), .sum(sum_168), .cout(c_168) );
carry_save_3inputs #(W+2) cs_3in_a169(.a({ sum_13, c_13, sum_14 }), .sum(sum_169), .cout(c_169) );
carry_save_3inputs #(W+2) cs_3in_a170(.a({ c_14, sum_15, c_15   }), .sum(sum_170), .cout(c_170) );
carry_save_3inputs #(W+2) cs_3in_a171(.a({ sum_16, c_16, sum_17 }), .sum(sum_171), .cout(c_171) );
carry_save_3inputs #(W+2) cs_3in_a172(.a({ c_17, sum_18, c_18   }), .sum(sum_172), .cout(c_172) );
carry_save_3inputs #(W+2) cs_3in_a173(.a({ sum_19, c_19, sum_20 }), .sum(sum_173), .cout(c_173) );
carry_save_3inputs #(W+2) cs_3in_a174(.a({ c_20, sum_21, c_21   }), .sum(sum_174), .cout(c_174) );
carry_save_3inputs #(W+2) cs_3in_a175(.a({ sum_22, c_22, sum_23 }), .sum(sum_175), .cout(c_175) );
carry_save_3inputs #(W+2) cs_3in_a176(.a({ c_23, sum_24, c_24   }), .sum(sum_176), .cout(c_176) );
carry_save_3inputs #(W+2) cs_3in_a177(.a({ sum_25, c_25, sum_26 }), .sum(sum_177), .cout(c_177) );
carry_save_3inputs #(W+2) cs_3in_a178(.a({ c_26, sum_27, c_27   }), .sum(sum_178), .cout(c_178) );
carry_save_3inputs #(W+2) cs_3in_a179(.a({ sum_28, c_28, sum_29 }), .sum(sum_179), .cout(c_179) );
carry_save_3inputs #(W+2) cs_3in_a180(.a({ c_29, sum_30, c_30   }), .sum(sum_180), .cout(c_180) );
carry_save_3inputs #(W+2) cs_3in_a181(.a({ sum_31, c_31, sum_32 }), .sum(sum_181), .cout(c_181) );
carry_save_3inputs #(W+2) cs_3in_a182(.a({ c_32, sum_33, c_33   }), .sum(sum_182), .cout(c_182) );
carry_save_3inputs #(W+2) cs_3in_a183(.a({ sum_34, c_34, sum_35 }), .sum(sum_183), .cout(c_183) );
carry_save_3inputs #(W+2) cs_3in_a184(.a({ c_35, sum_36, c_36   }), .sum(sum_184), .cout(c_184) );
carry_save_3inputs #(W+2) cs_3in_a185(.a({ sum_37, c_37, sum_38 }), .sum(sum_185), .cout(c_185) );
carry_save_3inputs #(W+2) cs_3in_a186(.a({ c_38, sum_39, c_39   }), .sum(sum_186), .cout(c_186) );
carry_save_3inputs #(W+2) cs_3in_a187(.a({ sum_40, c_40, sum_41 }), .sum(sum_187), .cout(c_187) );
carry_save_3inputs #(W+2) cs_3in_a188(.a({ c_41, sum_42, c_42   }), .sum(sum_188), .cout(c_188) );
carry_save_3inputs #(W+2) cs_3in_a189(.a({ sum_43, c_43, sum_44 }), .sum(sum_189), .cout(c_189) );
carry_save_3inputs #(W+2) cs_3in_a190(.a({ c_44, sum_45, c_45   }), .sum(sum_190), .cout(c_190) );
carry_save_3inputs #(W+2) cs_3in_a191(.a({ sum_46, c_46, sum_47 }), .sum(sum_191), .cout(c_191) );
carry_save_3inputs #(W+2) cs_3in_a192(.a({ c_47, sum_48, c_48   }), .sum(sum_192), .cout(c_192) );
carry_save_3inputs #(W+2) cs_3in_a193(.a({ sum_49, c_49, sum_50 }), .sum(sum_193), .cout(c_193) );
carry_save_3inputs #(W+2) cs_3in_a194(.a({ c_50, sum_51, c_51   }), .sum(sum_194), .cout(c_194) );
carry_save_3inputs #(W+2) cs_3in_a195(.a({ sum_52, c_52, sum_53 }), .sum(sum_195), .cout(c_195) );
carry_save_3inputs #(W+2) cs_3in_a196(.a({ c_53, sum_54, c_54   }), .sum(sum_196), .cout(c_196) );
carry_save_3inputs #(W+2) cs_3in_a197(.a({ sum_55, c_55, sum_56 }), .sum(sum_197), .cout(c_197) );
carry_save_3inputs #(W+2) cs_3in_a198(.a({ c_56, sum_57, c_57   }), .sum(sum_198), .cout(c_198) );
carry_save_3inputs #(W+2) cs_3in_a199(.a({ sum_58, c_58, sum_59 }), .sum(sum_199), .cout(c_199) );
carry_save_3inputs #(W+2) cs_3in_a1c0(.a({ c_59, sum_60, c_60   }), .sum(sum_1c0), .cout(c_1c0) );
carry_save_3inputs #(W+2) cs_3in_a1c1(.a({ sum_61, c_61, sum_62 }), .sum(sum_1c1), .cout(c_1c1) );
carry_save_3inputs #(W+2) cs_3in_a1c2(.a({ c_62, sum_63, c_63   }), .sum(sum_1c2), .cout(c_1c2) );
carry_save_3inputs #(W+2) cs_3in_a1c3(.a({ sum_64, c_64, sum_65 }), .sum(sum_1c3), .cout(c_1c3) );
carry_save_3inputs #(W+2) cs_3in_a1c4(.a({ c_65, sum_66, c_66   }), .sum(sum_1c4), .cout(c_1c4) );
carry_save_3inputs #(W+2) cs_3in_a1c5(.a({ sum_67, c_67, sum_68 }), .sum(sum_1c5), .cout(c_1c5) );
carry_save_3inputs #(W+2) cs_3in_a1c6(.a({ c_68, sum_69, c_69   }), .sum(sum_1c6), .cout(c_1c6) );
carry_save_3inputs #(W+2) cs_3in_a1c7(.a({ sum_70, c_70, sum_71 }), .sum(sum_1c7), .cout(c_1c7) );
carry_save_3inputs #(W+2) cs_3in_a1c8(.a({ c_71, sum_72, c_72   }), .sum(sum_1c8), .cout(c_1c8) );
carry_save_3inputs #(W+2) cs_3in_a1c9(.a({ sum_73, c_73, sum_74 }), .sum(sum_1c9), .cout(c_1c9) );
carry_save_3inputs #(W+2) cs_3in_a1d0(.a({ c_74, sum_75, c_75   }), .sum(sum_1d0), .cout(c_1d0) );
carry_save_3inputs #(W+2) cs_3in_a1d1(.a({ sum_76, c_76, sum_77 }), .sum(sum_1d1), .cout(c_1d1) );
carry_save_3inputs #(W+2) cs_3in_a1d2(.a({ c_77, sum_78, c_78   }), .sum(sum_1d2), .cout(c_1d2) );
carry_save_3inputs #(W+2) cs_3in_a1d3(.a({ sum_79, c_79, sum_80 }), .sum(sum_1d3), .cout(c_1d3) );
carry_save_3inputs #(W+2) cs_3in_a1d4(.a({ c_80, sum_81, c_81   }), .sum(sum_1d4), .cout(c_1d4) );
carry_save_3inputs #(W+2) cs_3in_a1d5(.a({ sum_82, c_82, sum_83 }), .sum(sum_1d5), .cout(c_1d5) );
carry_save_3inputs #(W+2) cs_3in_a1d6(.a({ c_83, sum_84, c_84   }), .sum(sum_1d6), .cout(c_1d6) );
carry_save_3inputs #(W+2) cs_3in_a1d7(.a({ sum_85, c_85, sum_86 }), .sum(sum_1d7), .cout(c_1d7) );
carry_save_3inputs #(W+2) cs_3in_a1d8(.a({ c_86, sum_87, c_87   }), .sum(sum_1d8), .cout(c_1d8) );
carry_save_3inputs #(W+2) cs_3in_a1d9(.a({ sum_88, c_88, sum_89 }), .sum(sum_1d9), .cout(c_1d9) );
carry_save_3inputs #(W+2) cs_3in_a1e0(.a({ c_89, sum_90, c_90   }), .sum(sum_1e0), .cout(c_1e0) );
carry_save_3inputs #(W+2) cs_3in_a1e1(.a({ sum_91, c_91, sum_92 }), .sum(sum_1e1), .cout(c_1e1) );
carry_save_3inputs #(W+2) cs_3in_a1e2(.a({ c_92, sum_93, c_93   }), .sum(sum_1e2), .cout(c_1e2) );
carry_save_3inputs #(W+2) cs_3in_a1e3(.a({ sum_94, c_94, sum_95 }), .sum(sum_1e3), .cout(c_1e3) );
carry_save_3inputs #(W+2) cs_3in_a1e4(.a({ c_95, sum_96, c_96   }), .sum(sum_1e4), .cout(c_1e4) );
carry_save_3inputs #(W+2) cs_3in_a1e5(.a({ sum_97, c_97, sum_98 }), .sum(sum_1e5), .cout(c_1e5) );
carry_save_3inputs #(W+2) cs_3in_a1e6(.a({ c_98, sum_99, c_99   }), .sum(sum_1e6), .cout(c_1e6) );
carry_save_3inputs #(W+2) cs_3in_a1e7(.a({ sum_a0, c_a0, sum_a1 }), .sum(sum_1e7), .cout(c_1e7) );
carry_save_3inputs #(W+2) cs_3in_a1e8(.a({ c_a1, sum_a2, c_a2   }), .sum(sum_1e8), .cout(c_1e8) );
carry_save_3inputs #(W+2) cs_3in_a1e9(.a({ sum_a3, c_a3, sum_a4 }), .sum(sum_1e9), .cout(c_1e9) );
carry_save_3inputs #(W+2) cs_3in_a1f0(.a({ c_a4, sum_a5, c_a5   }), .sum(sum_1f0), .cout(c_1f0) );
carry_save_3inputs #(W+2) cs_3in_a1f1(.a({ sum_a6, c_a6, sum_a7 }), .sum(sum_1f1), .cout(c_1f1) );
carry_save_3inputs #(W+2) cs_3in_a1f2(.a({ c_a7, sum_a8, c_a8   }), .sum(sum_1f2), .cout(c_1f2) );
carry_save_3inputs #(W+2) cs_3in_a1f3(.a({ sum_a9, c_a9, sum_b0 }), .sum(sum_1f3), .cout(c_1f3) );
carry_save_3inputs #(W+2) cs_3in_a1f4(.a({ c_b0, sum_b1, c_b1   }), .sum(sum_1f4), .cout(c_1f4) );
carry_save_3inputs #(W+2) cs_3in_a1f5(.a({ sum_b2, c_b2, sum_b3 }), .sum(sum_1f5), .cout(c_1f5) );
carry_save_3inputs #(W+2) cs_3in_a1f6(.a({ c_b3, sum_b4, c_b4   }), .sum(sum_1f6), .cout(c_1f6) );
 
carry_save_3inputs #(W+2) cs_3in_a1f7(.a({ sum_b5, c_b5  , sum_b6 }),                           .sum(sum_1f7), .cout(c_1f7) );
carry_save_3inputs #(W+2) cs_3in_a1f8(.a({  c_b6  , sum_b7, c_b7  }),                           .sum(sum_1f8), .cout(c_1f8) );
carry_save_3inputs #(W+2) cs_3in_a1f9(.a({ sum_b8, c_b8  , sum_b9 }),                           .sum(sum_1f9), .cout(c_1f9) );
carry_save_3inputs #(W+2) cs_3in_a1g0(.a({  c_b9  , sum_c0, c_c0  }),                           .sum(sum_1g0), .cout(c_1g0) );
carry_save_3inputs #(W+2) cs_3in_a1g1(.a({ sum_c1, c_c1  , sum_c2 }),                           .sum(sum_1g1), .cout(c_1g1) );
carry_save_3inputs #(W+2) cs_3in_a1g2(.a({  c_c2  , sum_c3, c_c3  }),                           .sum(sum_1g2), .cout(c_1g2) );
carry_save_3inputs #(W+2) cs_3in_a1g3(.a({ sum_c4, c_c4  , sum_c5 }),                           .sum(sum_1g3), .cout(c_1g3) );
carry_save_3inputs #(W+2) cs_3in_a1g4(.a({  c_c5  , sum_c6, c_c6  }),                           .sum(sum_1g4), .cout(c_1g4) );
carry_save_3inputs #(W+2) cs_3in_a1g5(.a({ sum_c7, c_c7  , sum_c8 }),                           .sum(sum_1g5), .cout(c_1g5) );
carry_save_3inputs #(W+2) cs_3in_a1g6(.a({  c_c8  , sum_c9, c_c9  }),                           .sum(sum_1g6), .cout(c_1g6) );
carry_save_3inputs #(W+2) cs_3in_a1g7(.a({ sum_d0, c_d0  , sum_d1 }),                           .sum(sum_1g7), .cout(c_1g7) );
carry_save_3inputs #(W+2) cs_3in_a1g8(.a({  c_d1  , sum_d2, c_d2  }),                           .sum(sum_1g8), .cout(c_1g8) );
carry_save_3inputs #(W+2) cs_3in_a1g9(.a({ sum_d3, c_d3  , sum_d4 }),                           .sum(sum_1g9), .cout(c_1g9) );
carry_save_3inputs #(W+2) cs_3in_a1h0(.a({  c_d4  , sum_d5, c_d5  }),                           .sum(sum_1h0), .cout(c_1h0) );
carry_save_3inputs #(W+2) cs_3in_a1h1(.a({ sum_d6, c_d6  , sum_d7 }),                           .sum(sum_1h1), .cout(c_1h1) );
carry_save_3inputs #(W+2) cs_3in_a1h2(.a({  c_d7  , sum_d8, c_d8  }),                           .sum(sum_1h2), .cout(c_1h2) );
carry_save_3inputs #(W+2) cs_3in_a1h3(.a({ sum_d9, c_d9  , sum_e0 }),                           .sum(sum_1h3), .cout(c_1h3) );
carry_save_3inputs #(W+2) cs_3in_a1h4(.a({  c_e0  , sum_e1, c_e1  }),                           .sum(sum_1h4), .cout(c_1h4) );
carry_save_3inputs #(W+2) cs_3in_a1h5(.a({ sum_e2, c_e2  , sum_e3 }),                           .sum(sum_1h5), .cout(c_1h5) );
carry_save_3inputs #(W+2) cs_3in_a1h6(.a({  c_e3  , sum_e4, c_e4  }),                           .sum(sum_1h6), .cout(c_1h6) );
carry_save_3inputs #(W+2) cs_3in_a1h7(.a({ sum_e5, c_e5  , sum_e6 }),                           .sum(sum_1h7), .cout(c_1h7) );
carry_save_3inputs #(W+2) cs_3in_a1h8(.a({  c_e6  , sum_e7, c_e7  }),                           .sum(sum_1h8), .cout(c_1h8) );
carry_save_3inputs #(W+2) cs_3in_a1h9(.a({ sum_e8, c_e8  , sum_e9 }),                           .sum(sum_1h9), .cout(c_1h9) );
carry_save_3inputs #(W+2) cs_3in_a1i0(.a({  c_e9  , sum_f0, c_f0  }),                           .sum(sum_1i0), .cout(c_1i0) );
carry_save_3inputs #(W+2) cs_3in_a1i1(.a({ sum_f1, c_f1  , sum_f2 }),                           .sum(sum_1i1), .cout(c_1i1) );
carry_save_3inputs #(W+2) cs_3in_a1i2(.a({  c_f2  , sum_f3, c_f3  }),                           .sum(sum_1i2), .cout(c_1i2) );
carry_save_3inputs #(W+2) cs_3in_a1i3(.a({ sum_f4, c_f4  , sum_f5 }),                           .sum(sum_1i3), .cout(c_1i3) );
carry_save_3inputs #(W+2) cs_3in_a1i4(.a({  c_f5  , sum_f6, c_f6  }),                           .sum(sum_1i4), .cout(c_1i4) );
carry_save_3inputs #(W+2) cs_3in_a1i5(.a({ sum_f7, c_f7  , sum_f8 }),                           .sum(sum_1i5), .cout(c_1i5) );
carry_save_3inputs #(W+2) cs_3in_a1i6(.a({  c_f8  , sum_f9, c_f9  }),                           .sum(sum_1i6), .cout(c_1i6) );
carry_save_3inputs #(W+2) cs_3in_a1i7(.a({ sum_g0, c_g0  , sum_g1 }),                           .sum(sum_1i7), .cout(c_1i7) );
carry_save_3inputs #(W+2) cs_3in_a1i8(.a({  c_g1  , sum_g2, c_g2  }),                           .sum(sum_1i8), .cout(c_1i8) );
carry_save_3inputs #(W+2) cs_3in_a1i9(.a({ sum_g3, c_g3  , sum_g4 }),                           .sum(sum_1i9), .cout(c_1i9) );
carry_save_3inputs #(W+2) cs_3in_a1j0(.a({  c_g4  , sum_g5, c_g5  }),                           .sum(sum_1j0), .cout(c_1j0) );
carry_save_3inputs #(W+2) cs_3in_a1j1(.a({ sum_g6, c_g6  , sum_g7 }),                           .sum(sum_1j1), .cout(c_1j1) );
carry_save_3inputs #(W+2) cs_3in_a1j2(.a({  c_g7  , sum_g8, c_g8  }),                           .sum(sum_1j2), .cout(c_1j2) );
carry_save_3inputs #(W+2) cs_3in_a1j3(.a({ sum_g9, c_g9  , sum_h0 }),                           .sum(sum_1j3), .cout(c_1j3) );
carry_save_3inputs #(W+2) cs_3in_a1j4(.a({  c_h0  , sum_h1, c_h1  }),                           .sum(sum_1j4), .cout(c_1j4) );
carry_save_3inputs #(W+2) cs_3in_a1j5(.a({ sum_h2, c_h2  , sum_h3 }),                           .sum(sum_1j5), .cout(c_1j5) );
carry_save_3inputs #(W+2) cs_3in_a1j6(.a({  c_h3  , sum_h4, c_h4  }),                           .sum(sum_1j6), .cout(c_1j6) );
carry_save_3inputs #(W+2) cs_3in_a1j7(.a({ sum_h5, c_h5  , sum_h6 }),                           .sum(sum_1j7), .cout(c_1j7) );
carry_save_3inputs #(W+2) cs_3in_a1j8(.a({  c_h6  , sum_h7, c_h7  }),                           .sum(sum_1j8), .cout(c_1j8) );
carry_save_3inputs #(W+2) cs_3in_a1j9(.a({ sum_h8, c_h8  , sum_h9 }),                           .sum(sum_1j9), .cout(c_1j9) );
carry_save_3inputs #(W+2) cs_3in_a1k0(.a({  c_h9  , sum_i0, c_i0  }),                           .sum(sum_1k0), .cout(c_1k0) );
carry_save_3inputs #(W+2) cs_3in_a1k1(.a({ sum_i1, c_i1  , sum_i2 }),                           .sum(sum_1k1), .cout(c_1k1) );
carry_save_3inputs #(W+2) cs_3in_a1k2(.a({  c_i2  , sum_i3, c_i3  }),                           .sum(sum_1k2), .cout(c_1k2) );
carry_save_3inputs #(W+2) cs_3in_a1k3(.a({ sum_i4, c_i4  , sum_i5 }),                           .sum(sum_1k3), .cout(c_1k3) );
carry_save_3inputs #(W+2) cs_3in_a1k4(.a({  c_i5  , sum_i6, c_i6  }),                           .sum(sum_1k4), .cout(c_1k4) );
carry_save_3inputs #(W+2) cs_3in_a1k5(.a({ sum_i7, c_i7  , sum_i8 }),                           .sum(sum_1k5), .cout(c_1k5) );
carry_save_3inputs #(W+2) cs_3in_a1k6(.a({  c_i8  , sum_i9, c_i9  }),                           .sum(sum_1k6), .cout(c_1k6) );
carry_save_3inputs #(W+2) cs_3in_a1k7(.a({ sum_j0, c_j0  , sum_j1 }),                           .sum(sum_1k7), .cout(c_1k7) );
carry_save_3inputs #(W+2) cs_3in_a1k8(.a({  c_j1  , sum_j2, c_j2  }),                           .sum(sum_1k8), .cout(c_1k8) );
carry_save_3inputs #(W+2) cs_3in_a1k9(.a({ sum_j3, c_j3  , sum_j4 }),                           .sum(sum_1k9), .cout(c_1k9) );
carry_save_3inputs #(W+2) cs_3in_a1l0(.a({  c_j4  , sum_j5, c_j5  }),                           .sum(sum_1l0), .cout(c_1l0) );
carry_save_3inputs #(W+2) cs_3in_a1l1(.a({ sum_j6, c_j6  , sum_j7 }),                           .sum(sum_1l1), .cout(c_1l1) );
carry_save_3inputs #(W+2) cs_3in_a1l2(.a({  c_j7  , sum_j8, c_j8  }),                           .sum(sum_1l2), .cout(c_1l2) );
carry_save_3inputs #(W+2) cs_3in_a1l3(.a({ sum_j9, c_j9  , sum_k0 }),                           .sum(sum_1l3), .cout(c_1l3) );
carry_save_3inputs #(W+2) cs_3in_a1l4(.a({  c_k0  , sum_k1, c_k1  }),                           .sum(sum_1l4), .cout(c_1l4) );
carry_save_3inputs #(W+2) cs_3in_a1l5(.a({ sum_k2, c_k2  , sum_k3 }),                           .sum(sum_1l5), .cout(c_1l5) );
carry_save_3inputs #(W+2) cs_3in_a1l6(.a({  c_k3  , sum_k4, c_k4  }),                           .sum(sum_1l6), .cout(c_1l6) );
carry_save_3inputs #(W+2) cs_3in_a1l7(.a({ sum_k5, c_k5  , sum_k6 }),                           .sum(sum_1l7), .cout(c_1l7) );
carry_save_3inputs #(W+2) cs_3in_a1l8(.a({  c_k6  , sum_k7, c_k7  }),                           .sum(sum_1l8), .cout(c_1l8) );
carry_save_3inputs #(W+2) cs_3in_a1l9(.a({ sum_k8, c_k8  , sum_k9 }),                           .sum(sum_1l9), .cout(c_1l9) );
carry_save_3inputs #(W+2) cs_3in_a1m0(.a({  c_k9  , sum_l0, c_l0  }),                           .sum(sum_1m0), .cout(c_1m0) );
carry_save_3inputs #(W+2) cs_3in_a1m1(.a({ sum_l1, c_l1  , sum_l2 }),                           .sum(sum_1m1), .cout(c_1m1) );
carry_save_3inputs #(W+2) cs_3in_a1m2(.a({  c_l2  , sum_l3, c_l3  }),                           .sum(sum_1m2), .cout(c_1m2) );
carry_save_3inputs #(W+2) cs_3in_a1m3(.a({ sum_l4, c_l4  , sum_l5 }),                           .sum(sum_1m3), .cout(c_1m3) );
carry_save_3inputs #(W+2) cs_3in_a1m4(.a({  c_l5  , sum_l6, c_l6  }),                           .sum(sum_1m4), .cout(c_1m4) );
carry_save_3inputs #(W+2) cs_3in_a1m5(.a({ sum_l7, c_l7  , sum_l8 }),                           .sum(sum_1m5), .cout(c_1m5) );
carry_save_3inputs #(W+2) cs_3in_a1m6(.a({  c_l8  , sum_l9, c_l9  }),                           .sum(sum_1m6), .cout(c_1m6) );
carry_save_3inputs #(W+2) cs_3in_a1m7(.a({ sum_m0, c_m0  , sum_m1 }),                           .sum(sum_1m7), .cout(c_1m7) );
carry_save_3inputs #(W+2) cs_3in_a1m8(.a({  c_m1  , sum_m2, c_m2  }),                           .sum(sum_1m8), .cout(c_1m8) );
carry_save_3inputs #(W+2) cs_3in_a1m9(.a({ sum_m3, c_m3  , sum_m4 }),                           .sum(sum_1m9), .cout(c_1m9) );
carry_save_3inputs #(W+2) cs_3in_a1n0(.a({  c_m4  , sum_m5, c_m5  }),                           .sum(sum_1n0), .cout(c_1n0) );
carry_save_3inputs #(W+2) cs_3in_a1n1(.a({ sum_m6, c_m6  , sum_m7 }),                           .sum(sum_1n1), .cout(c_1n1) );
carry_save_3inputs #(W+2) cs_3in_a1n2(.a({ c_m7  , {2'b00, a[1023*W +: W ]} , {1'b0, c1020} }), .sum(sum_1n2), .cout(c_1n2) );
 
 carry_save_3inputs #(W+3) cs_3in_a301(.a({ sum_161, c_161, sum_162}), .sum(sum_301), .cout(c_301) );
 carry_save_3inputs #(W+3) cs_3in_a302(.a({ sum_163, c_162, c_163  }), .sum(sum_302), .cout(c_302) );
 carry_save_3inputs #(W+3) cs_3in_a303(.a({ sum_164, c_164, sum_165}), .sum(sum_303), .cout(c_303) );
 carry_save_3inputs #(W+3) cs_3in_a304(.a({ sum_166, c_165, c_166  }), .sum(sum_304), .cout(c_304) );
 carry_save_3inputs #(W+3) cs_3in_a305(.a({ sum_167, c_167, sum_168}), .sum(sum_305), .cout(c_305) );
 carry_save_3inputs #(W+3) cs_3in_a306(.a({ sum_169, c_168, c_169  }), .sum(sum_306), .cout(c_306) );
 carry_save_3inputs #(W+3) cs_3in_a307(.a({ sum_170, c_170, sum_171}), .sum(sum_307), .cout(c_307) );
 carry_save_3inputs #(W+3) cs_3in_a308(.a({ sum_172, c_171, c_172  }), .sum(sum_308), .cout(c_308) );
 carry_save_3inputs #(W+3) cs_3in_a309(.a({ sum_173, c_173, sum_174}), .sum(sum_309), .cout(c_309) );
 carry_save_3inputs #(W+3) cs_3in_a310(.a({ sum_175, c_174, c_175  }), .sum(sum_310), .cout(c_310) );
 carry_save_3inputs #(W+3) cs_3in_a311(.a({ sum_176, c_176, sum_177}), .sum(sum_311), .cout(c_311) );
 carry_save_3inputs #(W+3) cs_3in_a312(.a({ sum_178, c_177, c_178  }), .sum(sum_312), .cout(c_312) );
 carry_save_3inputs #(W+3) cs_3in_a313(.a({ sum_179, c_179, sum_180}), .sum(sum_313), .cout(c_313) );
 carry_save_3inputs #(W+3) cs_3in_a314(.a({ sum_181, c_180, c_181  }), .sum(sum_314), .cout(c_314) );
 carry_save_3inputs #(W+3) cs_3in_a315(.a({ sum_182, c_182, sum_183}), .sum(sum_315), .cout(c_315) );
 carry_save_3inputs #(W+3) cs_3in_a316(.a({ sum_184, c_183, c_184  }), .sum(sum_316), .cout(c_316) );
 carry_save_3inputs #(W+3) cs_3in_a317(.a({ sum_185, c_185, sum_186}), .sum(sum_317), .cout(c_317) );
 carry_save_3inputs #(W+3) cs_3in_a318(.a({ sum_187, c_186, c_187  }), .sum(sum_318), .cout(c_318) );
 carry_save_3inputs #(W+3) cs_3in_a319(.a({ sum_188, c_188, sum_189}), .sum(sum_319), .cout(c_319) );
 carry_save_3inputs #(W+3) cs_3in_a320(.a({ sum_190, c_189, c_190  }), .sum(sum_320), .cout(c_320) );
 carry_save_3inputs #(W+3) cs_3in_a321(.a({ sum_191, c_191, sum_192}), .sum(sum_321), .cout(c_321) );
 carry_save_3inputs #(W+3) cs_3in_a322(.a({ sum_193, c_192, c_193  }), .sum(sum_322), .cout(c_322) );
 carry_save_3inputs #(W+3) cs_3in_a323(.a({ sum_194, c_194, sum_195}), .sum(sum_323), .cout(c_323) );
 carry_save_3inputs #(W+3) cs_3in_a324(.a({ sum_196, c_195, c_196  }), .sum(sum_324), .cout(c_324) );
 carry_save_3inputs #(W+3) cs_3in_a400(.a({ sum_197, c_197, sum_198}), .sum(sum_400), .cout(c_400) );
 carry_save_3inputs #(W+3) cs_3in_a401(.a({ sum_199, c_198, c_199  }), .sum(sum_401), .cout(c_401) );
 carry_save_3inputs #(W+3) cs_3in_a402(.a({ sum_1c0, c_1c0, sum_1c1}), .sum(sum_402), .cout(c_402) );
 carry_save_3inputs #(W+3) cs_3in_a403(.a({ sum_1c2, c_1c1, c_1c2  }), .sum(sum_403), .cout(c_403) );
 carry_save_3inputs #(W+3) cs_3in_a404(.a({ sum_1c3, c_1c3, sum_1c4}), .sum(sum_404), .cout(c_404) );
 carry_save_3inputs #(W+3) cs_3in_a405(.a({ sum_1c5, c_1c4, c_1c5  }), .sum(sum_405), .cout(c_405) );
 carry_save_3inputs #(W+3) cs_3in_a406(.a({ sum_1c6, c_1c6, sum_1c7}), .sum(sum_406), .cout(c_406) );
 carry_save_3inputs #(W+3) cs_3in_a407(.a({ sum_1c8, c_1c7, c_1c8  }), .sum(sum_407), .cout(c_407) );
 carry_save_3inputs #(W+3) cs_3in_a408(.a({ sum_1c9, c_1c9, sum_1d0}), .sum(sum_408), .cout(c_408) );
 carry_save_3inputs #(W+3) cs_3in_a409(.a({ sum_1d1, c_1d0, c_1d1  }), .sum(sum_409), .cout(c_409) );
 carry_save_3inputs #(W+3) cs_3in_a410(.a({ sum_1d2, c_1d2, sum_1d3}), .sum(sum_410), .cout(c_410) );
 carry_save_3inputs #(W+3) cs_3in_a411(.a({ sum_1d4, c_1d3, c_1d4  }), .sum(sum_411), .cout(c_411) );
 carry_save_3inputs #(W+3) cs_3in_a412(.a({ sum_1d5, c_1d5, sum_1d6}), .sum(sum_412), .cout(c_412) );
 carry_save_3inputs #(W+3) cs_3in_a413(.a({ sum_1d7, c_1d6, c_1d7  }), .sum(sum_413), .cout(c_413) );
 carry_save_3inputs #(W+3) cs_3in_a414(.a({ sum_1d8, c_1d8, sum_1d9}), .sum(sum_414), .cout(c_414) );
 carry_save_3inputs #(W+3) cs_3in_a415(.a({ sum_1e0, c_1d9, c_1e0  }), .sum(sum_415), .cout(c_415) );
 carry_save_3inputs #(W+3) cs_3in_a416(.a({ sum_1e1, c_1e1, sum_1e2}), .sum(sum_416), .cout(c_416) );
 carry_save_3inputs #(W+3) cs_3in_a417(.a({ sum_1e3, c_1e2, c_1e3  }), .sum(sum_417), .cout(c_417) );
 carry_save_3inputs #(W+3) cs_3in_a418(.a({ sum_1e4, c_1e4, sum_1e5}), .sum(sum_418), .cout(c_418) );
 carry_save_3inputs #(W+3) cs_3in_a419(.a({ sum_1e6, c_1e5, c_1e6  }), .sum(sum_419), .cout(c_419) );
 carry_save_3inputs #(W+3) cs_3in_a420(.a({ sum_1e7, c_1e7, sum_1e8}), .sum(sum_420), .cout(c_420) );
 carry_save_3inputs #(W+3) cs_3in_a421(.a({ sum_1e9, c_1e8, c_1e9  }), .sum(sum_421), .cout(c_421) );
 carry_save_3inputs #(W+3) cs_3in_a422(.a({ sum_1f0, c_1f0, sum_1f1}), .sum(sum_422), .cout(c_422) );
 carry_save_3inputs #(W+3) cs_3in_a423(.a({ sum_1f2, c_1f1, c_1f2  }), .sum(sum_423), .cout(c_423) );
 carry_save_3inputs #(W+3) cs_3in_a424(.a({ sum_1f3, c_1f3, sum_1f4}), .sum(sum_424), .cout(c_424) );
 carry_save_3inputs #(W+3) cs_3in_a425(.a({ sum_1f5, c_1f4, c_1f5  }), .sum(sum_425), .cout(c_425) );
  
 carry_save_3inputs #(W+3) cs_3in_a426(.a({ sum_1f6, c_1f6  , sum_1f7 }), .sum(sum_a426), .cout(c_a426) );
 carry_save_3inputs #(W+3) cs_3in_a427(.a({  c_1f7  , sum_1f8, c_1f8  }), .sum(sum_a427), .cout(c_a427) );
 carry_save_3inputs #(W+3) cs_3in_a428(.a({ sum_1f9, c_1f9  , sum_1g0 }), .sum(sum_a428), .cout(c_a428) );
 carry_save_3inputs #(W+3) cs_3in_a429(.a({  c_1g0  , sum_1g1, c_1g1  }), .sum(sum_a429), .cout(c_a429) );
 carry_save_3inputs #(W+3) cs_3in_a430(.a({ sum_1g2, c_1g2  , sum_1g3 }), .sum(sum_a430), .cout(c_a430) );
 carry_save_3inputs #(W+3) cs_3in_a431(.a({  c_1g3  , sum_1g4, c_1g4  }), .sum(sum_a431), .cout(c_a431) );
 carry_save_3inputs #(W+3) cs_3in_a432(.a({ sum_1g5, c_1g5  , sum_1g6 }), .sum(sum_a432), .cout(c_a432) );
 carry_save_3inputs #(W+3) cs_3in_a433(.a({  c_1g6  , sum_1g7, c_1g7  }), .sum(sum_a433), .cout(c_a433) );
 carry_save_3inputs #(W+3) cs_3in_a434(.a({ sum_1g8, c_1g8  , sum_1g9 }), .sum(sum_a434), .cout(c_a434) );
 carry_save_3inputs #(W+3) cs_3in_a435(.a({  c_1g9  , sum_1h0, c_1h0  }), .sum(sum_a435), .cout(c_a435) );
 carry_save_3inputs #(W+3) cs_3in_a436(.a({ sum_1h1, c_1h1  , sum_1h2 }), .sum(sum_a436), .cout(c_a436) );
 carry_save_3inputs #(W+3) cs_3in_a437(.a({  c_1h2  , sum_1h3, c_1h3  }), .sum(sum_a437), .cout(c_a437) );
 carry_save_3inputs #(W+3) cs_3in_a438(.a({ sum_1h4, c_1h4  , sum_1h5 }), .sum(sum_a438), .cout(c_a438) );
 carry_save_3inputs #(W+3) cs_3in_a439(.a({  c_1h5  , sum_1h6, c_1h6  }), .sum(sum_a439), .cout(c_a439) );
 carry_save_3inputs #(W+3) cs_3in_a440(.a({ sum_1h7, c_1h7  , sum_1h8 }), .sum(sum_a440), .cout(c_a440) );
 carry_save_3inputs #(W+3) cs_3in_a441(.a({  c_1h8  , sum_1h9, c_1h9  }), .sum(sum_a441), .cout(c_a441) );
 carry_save_3inputs #(W+3) cs_3in_a442(.a({ sum_1i0, c_1i0  , sum_1i1 }), .sum(sum_a442), .cout(c_a442) );
 carry_save_3inputs #(W+3) cs_3in_a443(.a({  c_1i1  , sum_1i2, c_1i2  }), .sum(sum_a443), .cout(c_a443) );
 carry_save_3inputs #(W+3) cs_3in_a444(.a({ sum_1i3, c_1i3  , sum_1i4 }), .sum(sum_a444), .cout(c_a444) );
 carry_save_3inputs #(W+3) cs_3in_a445(.a({  c_1i4  , sum_1i5, c_1i5  }), .sum(sum_a445), .cout(c_a445) );
 carry_save_3inputs #(W+3) cs_3in_a446(.a({ sum_1i6, c_1i6  , sum_1i7 }), .sum(sum_a446), .cout(c_a446) );
 carry_save_3inputs #(W+3) cs_3in_a447(.a({  c_1i7  , sum_1i8, c_1i8  }), .sum(sum_a447), .cout(c_a447) );
 carry_save_3inputs #(W+3) cs_3in_a448(.a({ sum_1i9, c_1i9  , sum_1j0 }), .sum(sum_a448), .cout(c_a448) );
 carry_save_3inputs #(W+3) cs_3in_a449(.a({  c_1j0  , sum_1j1, c_1j1  }), .sum(sum_a449), .cout(c_a449) );
 carry_save_3inputs #(W+3) cs_3in_a450(.a({ sum_1j2, c_1j2  , sum_1j3 }), .sum(sum_a450), .cout(c_a450) );
 carry_save_3inputs #(W+3) cs_3in_a451(.a({  c_1j3  , sum_1j4, c_1j4  }), .sum(sum_a451), .cout(c_a451) );
 carry_save_3inputs #(W+3) cs_3in_a452(.a({ sum_1j5, c_1j5  , sum_1j6 }), .sum(sum_a452), .cout(c_a452) );
 carry_save_3inputs #(W+3) cs_3in_a453(.a({  c_1j6  , sum_1j7, c_1j7  }), .sum(sum_a453), .cout(c_a453) );
 carry_save_3inputs #(W+3) cs_3in_a454(.a({ sum_1j8, c_1j8  , sum_1j9 }), .sum(sum_a454), .cout(c_a454) );
 carry_save_3inputs #(W+3) cs_3in_a455(.a({  c_1j9  , sum_1k0, c_1k0  }), .sum(sum_a455), .cout(c_a455) );
 carry_save_3inputs #(W+3) cs_3in_a456(.a({ sum_1k1, c_1k1  , sum_1k2 }), .sum(sum_a456), .cout(c_a456) );
 carry_save_3inputs #(W+3) cs_3in_a457(.a({  c_1k2  , sum_1k3, c_1k3  }), .sum(sum_a457), .cout(c_a457) );
 carry_save_3inputs #(W+3) cs_3in_a458(.a({ sum_1k4, c_1k4  , sum_1k5 }), .sum(sum_a458), .cout(c_a458) );
 carry_save_3inputs #(W+3) cs_3in_a459(.a({  c_1k5  , sum_1k6, c_1k6  }), .sum(sum_a459), .cout(c_a459) );
 carry_save_3inputs #(W+3) cs_3in_a460(.a({ sum_1k7, c_1k7  , sum_1k8 }), .sum(sum_a460), .cout(c_a460) );
 carry_save_3inputs #(W+3) cs_3in_a461(.a({  c_1k8  , sum_1k9, c_1k9  }), .sum(sum_a461), .cout(c_a461) );
 carry_save_3inputs #(W+3) cs_3in_a462(.a({ sum_1l0, c_1l0  , sum_1l1 }), .sum(sum_a462), .cout(c_a462) );
 carry_save_3inputs #(W+3) cs_3in_a463(.a({  c_1l1  , sum_1l2, c_1l2  }), .sum(sum_a463), .cout(c_a463) );
 carry_save_3inputs #(W+3) cs_3in_a464(.a({ sum_1l3, c_1l3  , sum_1l4 }), .sum(sum_a464), .cout(c_a464) );
 carry_save_3inputs #(W+3) cs_3in_a465(.a({  c_1l4  , sum_1l5, c_1l5  }), .sum(sum_a465), .cout(c_a465) );
 carry_save_3inputs #(W+3) cs_3in_a466(.a({ sum_1l6, c_1l6  , sum_1l7 }), .sum(sum_a466), .cout(c_a466) );
 carry_save_3inputs #(W+3) cs_3in_a467(.a({  c_1l7  , sum_1l8, c_1l8  }), .sum(sum_a467), .cout(c_a467) );
 carry_save_3inputs #(W+3) cs_3in_a468(.a({ sum_1l9, c_1l9  , sum_1m0 }), .sum(sum_a468), .cout(c_a468) );
 carry_save_3inputs #(W+3) cs_3in_a469(.a({  c_1m0  , sum_1m1, c_1m1  }), .sum(sum_a469), .cout(c_a469) );
 carry_save_3inputs #(W+3) cs_3in_a470(.a({ sum_1m2, c_1m2  , sum_1m3 }), .sum(sum_a470), .cout(c_a470) );
 carry_save_3inputs #(W+3) cs_3in_a471(.a({  c_1m3  , sum_1m4, c_1m4  }), .sum(sum_a471), .cout(c_a471) );
 carry_save_3inputs #(W+3) cs_3in_a472(.a({ sum_1m5, c_1m5  , sum_1m6 }), .sum(sum_a472), .cout(c_a472) );
 carry_save_3inputs #(W+3) cs_3in_a473(.a({  c_1m6  , sum_1m7, c_1m7  }), .sum(sum_a473), .cout(c_a473) );
 carry_save_3inputs #(W+3) cs_3in_a474(.a({ sum_1m8, c_1m8  , sum_1m9 }), .sum(sum_a474), .cout(c_a474) );
 carry_save_3inputs #(W+3) cs_3in_a475(.a({  c_1m9  , sum_1n0, c_1n0  }), .sum(sum_a475), .cout(c_a475) );
 carry_save_3inputs #(W+3) cs_3in_a476(.a({ sum_1n1, c_1n1  , sum_1n2 }), .sum(sum_a476), .cout(c_a476) ); // c_1n2  do not added

 carry_save_3inputs #(W+4) cs_3in_aa331(.a({ sum_301, c_301, sum_302}),       .sum(sum_331), .cout(c_331) );
 carry_save_3inputs #(W+4) cs_3in_aa332(.a({ c_302, sum_303, c_303  }),       .sum(sum_332), .cout(c_332) );
 carry_save_3inputs #(W+4) cs_3in_aa333(.a({ sum_304, c_304, sum_305}),       .sum(sum_333), .cout(c_333) );
 carry_save_3inputs #(W+4) cs_3in_aa334(.a({ c_305, sum_306, c_306  }),       .sum(sum_334), .cout(c_334) );
 carry_save_3inputs #(W+4) cs_3in_aa335(.a({ sum_307, c_307, sum_308}),       .sum(sum_335), .cout(c_335) );
 carry_save_3inputs #(W+4) cs_3in_aa336(.a({ c_308, sum_309, c_309  }),       .sum(sum_336), .cout(c_336) );
 carry_save_3inputs #(W+4) cs_3in_aa337(.a({ sum_310, c_310, sum_311}),       .sum(sum_337), .cout(c_337) );
 carry_save_3inputs #(W+4) cs_3in_aa338(.a({ c_311, sum_312, c_312  }),       .sum(sum_338), .cout(c_338) );
 carry_save_3inputs #(W+4) cs_3in_aa339(.a({ sum_313, c_313, sum_314}),       .sum(sum_339), .cout(c_339) );
 carry_save_3inputs #(W+4) cs_3in_aa340(.a({ c_314, sum_315, c_315  }),       .sum(sum_340), .cout(c_340) );
 carry_save_3inputs #(W+4) cs_3in_aa341(.a({ sum_316, c_316, sum_317}),       .sum(sum_341), .cout(c_341) );
 carry_save_3inputs #(W+4) cs_3in_aa342(.a({ c_317, sum_318, c_318  }),       .sum(sum_342), .cout(c_342) );
 carry_save_3inputs #(W+4) cs_3in_aa343(.a({ sum_319, c_319, sum_320}),       .sum(sum_343), .cout(c_343) );
 carry_save_3inputs #(W+4) cs_3in_aa344(.a({ c_320, sum_321, c_321  }),       .sum(sum_344), .cout(c_344) );
 carry_save_3inputs #(W+4) cs_3in_aa345(.a({ sum_322, c_322, sum_323}),       .sum(sum_345), .cout(c_345) );
 carry_save_3inputs #(W+4) cs_3in_aa346(.a({ c_323, sum_324, c_324  }),       .sum(sum_346), .cout(c_346) );
 carry_save_3inputs #(W+4) cs_3in_aa347(.a({ sum_400, c_400, sum_401}),       .sum(sum_347), .cout(c_347) );
 carry_save_3inputs #(W+4) cs_3in_aa430(.a({ c_401, sum_402, c_402  }),       .sum(sum_430), .cout(c_430) );
 carry_save_3inputs #(W+4) cs_3in_aa431(.a({ sum_403, c_403, sum_404}),       .sum(sum_431), .cout(c_431) );
 carry_save_3inputs #(W+4) cs_3in_aa432(.a({ c_404, sum_405, c_405  }),       .sum(sum_432), .cout(c_432) );
 carry_save_3inputs #(W+4) cs_3in_aa433(.a({ sum_406, c_406, sum_407}),       .sum(sum_433), .cout(c_433) );
 carry_save_3inputs #(W+4) cs_3in_aa434(.a({ c_407, sum_408, c_408  }),       .sum(sum_434), .cout(c_434) );
 carry_save_3inputs #(W+4) cs_3in_aa435(.a({ sum_409, c_409, sum_410}),       .sum(sum_435), .cout(c_435) );
 carry_save_3inputs #(W+4) cs_3in_aa436(.a({ c_410, sum_411, c_411  }),       .sum(sum_436), .cout(c_436) );
 carry_save_3inputs #(W+4) cs_3in_aa437(.a({ sum_412, c_412, sum_413}),       .sum(sum_437), .cout(c_437) );
 carry_save_3inputs #(W+4) cs_3in_aa438(.a({ c_413, sum_414, c_414  }),       .sum(sum_438), .cout(c_438) );
 carry_save_3inputs #(W+4) cs_3in_aa439(.a({ sum_415, c_415, sum_416}),       .sum(sum_439), .cout(c_439) );
 carry_save_3inputs #(W+4) cs_3in_aa440(.a({ c_416, sum_417, c_417  }),       .sum(sum_440), .cout(c_440) );
 carry_save_3inputs #(W+4) cs_3in_aa441(.a({ sum_418, c_418, sum_419}),       .sum(sum_441), .cout(c_441) );
 carry_save_3inputs #(W+4) cs_3in_aa442(.a({ c_419, sum_420, c_420  }),       .sum(sum_442), .cout(c_442) );
 carry_save_3inputs #(W+4) cs_3in_aa443(.a({ sum_421, c_421, sum_422}),       .sum(sum_443), .cout(c_443) );
 carry_save_3inputs #(W+4) cs_3in_aa444(.a({ c_422, sum_423, c_423  }),       .sum(sum_444), .cout(c_444) );
 carry_save_3inputs #(W+4) cs_3in_aa445(.a({ sum_424, c_424, sum_425}),       .sum(sum_445), .cout(c_445) );

 carry_save_3inputs #(W+4) cs_3inaa432(.a({ c_425  , sum_a426, c_a426    }), .sum(sum_446 ), .cout(c_446) );
 carry_save_3inputs #(W+4) cs_3in_b447(.a({ sum_a427, c_a427  , sum_a428 }), .sum(sum_b447), .cout(c_b447) );
 carry_save_3inputs #(W+4) cs_3in_b448(.a({  c_a428  , sum_a429, c_a429  }), .sum(sum_b448), .cout(c_b448) );
 carry_save_3inputs #(W+4) cs_3in_b449(.a({ sum_a430, c_a430  , sum_a431 }), .sum(sum_b449), .cout(c_b449) );
 carry_save_3inputs #(W+4) cs_3in_b450(.a({  c_a431  , sum_a432, c_a432  }), .sum(sum_b450), .cout(c_b450) );
 carry_save_3inputs #(W+4) cs_3in_b451(.a({ sum_a433, c_a433  , sum_a434 }), .sum(sum_b451), .cout(c_b451) );
 carry_save_3inputs #(W+4) cs_3in_b452(.a({  c_a434  , sum_a435, c_a435  }), .sum(sum_b452), .cout(c_b452) );
 carry_save_3inputs #(W+4) cs_3in_b453(.a({ sum_a436, c_a436  , sum_a437 }), .sum(sum_b453), .cout(c_b453) );
 carry_save_3inputs #(W+4) cs_3in_b454(.a({  c_a437  , sum_a438, c_a438  }), .sum(sum_b454), .cout(c_b454) );
 carry_save_3inputs #(W+4) cs_3in_b455(.a({ sum_a439, c_a439  , sum_a440 }), .sum(sum_b455), .cout(c_b455) );
 carry_save_3inputs #(W+4) cs_3in_b456(.a({  c_a440  , sum_a441, c_a441  }), .sum(sum_b456), .cout(c_b456) );
 carry_save_3inputs #(W+4) cs_3in_b457(.a({ sum_a442, c_a442  , sum_a443 }), .sum(sum_b457), .cout(c_b457) );
 carry_save_3inputs #(W+4) cs_3in_b458(.a({  c_a443  , sum_a444, c_a444  }), .sum(sum_b458), .cout(c_b458) );
 carry_save_3inputs #(W+4) cs_3in_b459(.a({ sum_a445, c_a445  , sum_a446 }), .sum(sum_b459), .cout(c_b459) );
 carry_save_3inputs #(W+4) cs_3in_b460(.a({  c_a446  , sum_a447, c_a447  }), .sum(sum_b460), .cout(c_b460) );
 carry_save_3inputs #(W+4) cs_3in_b461(.a({ sum_a448, c_a448  , sum_a449 }), .sum(sum_b461), .cout(c_b461) );
 carry_save_3inputs #(W+4) cs_3in_b462(.a({  c_a449  , sum_a450, c_a450  }), .sum(sum_b462), .cout(c_b462) );
 carry_save_3inputs #(W+4) cs_3in_b463(.a({ sum_a451, c_a451  , sum_a452 }), .sum(sum_b463), .cout(c_b463) );
 carry_save_3inputs #(W+4) cs_3in_b464(.a({  c_a452  , sum_a453, c_a453  }), .sum(sum_b464), .cout(c_b464) );
 carry_save_3inputs #(W+4) cs_3in_b465(.a({ sum_a454, c_a454  , sum_a455 }), .sum(sum_b465), .cout(c_b465) );
 carry_save_3inputs #(W+4) cs_3in_b466(.a({  c_a455  , sum_a456, c_a456  }), .sum(sum_b466), .cout(c_b466) );
 carry_save_3inputs #(W+4) cs_3in_b467(.a({ sum_a457, c_a457  , sum_a458 }), .sum(sum_b467), .cout(c_b467) );
 carry_save_3inputs #(W+4) cs_3in_b468(.a({  c_a458  , sum_a459, c_a459  }), .sum(sum_b468), .cout(c_b468) );
 carry_save_3inputs #(W+4) cs_3in_b469(.a({ sum_a460, c_a460  , sum_a461 }), .sum(sum_b469), .cout(c_b469) );
 carry_save_3inputs #(W+4) cs_3in_b470(.a({  c_a461  , sum_a462, c_a462  }), .sum(sum_b470), .cout(c_b470) );
 carry_save_3inputs #(W+4) cs_3in_b471(.a({ sum_a463, c_a463  , sum_a464 }), .sum(sum_b471), .cout(c_b471) );
 carry_save_3inputs #(W+4) cs_3in_b472(.a({  c_a464  , sum_a465, c_a465  }), .sum(sum_b472), .cout(c_b472) );
 carry_save_3inputs #(W+4) cs_3in_b473(.a({ sum_a466, c_a466  , sum_a467 }), .sum(sum_b473), .cout(c_b473) );
 carry_save_3inputs #(W+4) cs_3in_b474(.a({  c_a467  , sum_a468, c_a468  }), .sum(sum_b474), .cout(c_b474) );
 carry_save_3inputs #(W+4) cs_3in_b475(.a({ sum_a469, c_a469  , sum_a470 }), .sum(sum_b475), .cout(c_b475) );
 carry_save_3inputs #(W+4) cs_3in_b476(.a({  c_a470  , sum_a471, c_a471  }), .sum(sum_b476), .cout(c_b476) );
 carry_save_3inputs #(W+4) cs_3in_b477(.a({ sum_a472, c_a472  , sum_a473 }), .sum(sum_b477), .cout(c_b477) );
 carry_save_3inputs #(W+4) cs_3in_b478(.a({  c_a473  , sum_a474, c_a474  }), .sum(sum_b478), .cout(c_b478) );
 carry_save_3inputs #(W+4) cs_3in_b479(.a({ sum_a475, c_a475  , sum_a476 }), .sum(sum_b479), .cout(c_b479) ); //   c_a476  , {1'b0,c_1n2}  do not added

 carry_save_3inputs #(W+5) cs_3in_aa351(.a({ sum_331, c_331, sum_332}), .sum(sum_351), .cout(c_351) );
 carry_save_3inputs #(W+5) cs_3in_aa352(.a({ c_332, c_333, sum_333  }), .sum(sum_352), .cout(c_352) );
 carry_save_3inputs #(W+5) cs_3in_aa353(.a({ sum_334, c_334, sum_335}), .sum(sum_353), .cout(c_353) );
 carry_save_3inputs #(W+5) cs_3in_aa354(.a({ c_335, c_336, sum_336  }), .sum(sum_354), .cout(c_354) );
 carry_save_3inputs #(W+5) cs_3in_aa355(.a({ sum_337, c_337, sum_338}), .sum(sum_355), .cout(c_355) );
 carry_save_3inputs #(W+5) cs_3in_aa356(.a({ c_338, c_339, sum_339  }), .sum(sum_356), .cout(c_356) );
 carry_save_3inputs #(W+5) cs_3in_aa357(.a({ sum_340, c_340, sum_341}), .sum(sum_357), .cout(c_357) );
 carry_save_3inputs #(W+5) cs_3in_aa358(.a({ c_341, c_342, sum_342  }), .sum(sum_358), .cout(c_358) );
 carry_save_3inputs #(W+5) cs_3in_aa359(.a({ sum_343, c_343, sum_344}), .sum(sum_359), .cout(c_359) );
 carry_save_3inputs #(W+5) cs_3in_aa360(.a({ c_344, c_345, sum_345  }), .sum(sum_360), .cout(c_360) );
 carry_save_3inputs #(W+5) cs_3in_aa361(.a({ sum_346, c_346, sum_347}), .sum(sum_361), .cout(c_361) );
 carry_save_3inputs #(W+5) cs_3in_aa450(.a({ c_347, c_430, sum_430  }), .sum(sum_450), .cout(c_450) );
 carry_save_3inputs #(W+5) cs_3in_aa451(.a({ sum_431, c_431, sum_432}), .sum(sum_451), .cout(c_451) );
 carry_save_3inputs #(W+5) cs_3in_aa452(.a({ c_432, c_433, sum_433  }), .sum(sum_452), .cout(c_452) );
 carry_save_3inputs #(W+5) cs_3in_aa453(.a({ sum_434, c_434, sum_435}), .sum(sum_453), .cout(c_453) );
 carry_save_3inputs #(W+5) cs_3in_aa454(.a({ c_435, c_436, sum_436  }), .sum(sum_454), .cout(c_454) );
 carry_save_3inputs #(W+5) cs_3in_aa455(.a({ sum_437, c_437, sum_438}), .sum(sum_455), .cout(c_455) );
 carry_save_3inputs #(W+5) cs_3in_aa456(.a({ c_438, c_439, sum_439  }), .sum(sum_456), .cout(c_456) );
 carry_save_3inputs #(W+5) cs_3in_aa457(.a({ sum_440, c_440, sum_441}), .sum(sum_457), .cout(c_457) );
 carry_save_3inputs #(W+5) cs_3in_aa458(.a({ c_441, c_442, sum_442  }), .sum(sum_458), .cout(c_458) );
 carry_save_3inputs #(W+5) cs_3in_aa459(.a({ sum_443, c_443, sum_444}), .sum(sum_459), .cout(c_459) );
 carry_save_3inputs #(W+5) cs_3in_aa45a(.a({ c_444, c_445, sum_445  }), .sum(sum_45a), .cout(c_45a) );

 carry_save_3inputs #(W+5) cs_3in_c460(.a({ c_445   , sum_446 , c_446   }), .sum(sum_c460), .cout(c_c460) );
 carry_save_3inputs #(W+5) cs_3in_c461(.a({ sum_b447, c_b447  ,sum_b448 }), .sum(sum_c461), .cout(c_c461) );
 carry_save_3inputs #(W+5) cs_3in_c462(.a({ c_b448  ,sum_b449, c_b449   }), .sum(sum_c462), .cout(c_c462) );
 carry_save_3inputs #(W+5) cs_3in_c463(.a({ sum_b450, c_b450  ,sum_b451 }), .sum(sum_c463), .cout(c_c463) );
 carry_save_3inputs #(W+5) cs_3in_c464(.a({ c_b451  ,sum_b452, c_b452   }), .sum(sum_c464), .cout(c_c464) );
 carry_save_3inputs #(W+5) cs_3in_c465(.a({ sum_b453, c_b453  ,sum_b454 }), .sum(sum_c465), .cout(c_c465) );
 carry_save_3inputs #(W+5) cs_3in_c466(.a({ c_b454  ,sum_b455, c_b455   }), .sum(sum_c466), .cout(c_c466) );
 carry_save_3inputs #(W+5) cs_3in_c467(.a({ sum_b456, c_b456  ,sum_b457 }), .sum(sum_c467), .cout(c_c467) );
 carry_save_3inputs #(W+5) cs_3in_c468(.a({ c_b457  ,sum_b458, c_b458   }), .sum(sum_c468), .cout(c_c468) );
 carry_save_3inputs #(W+5) cs_3in_c469(.a({ sum_b459, c_b459  ,sum_b460 }), .sum(sum_c469), .cout(c_c469) );
 carry_save_3inputs #(W+5) cs_3in_c470(.a({ c_b460  ,sum_b461, c_b461   }), .sum(sum_c470), .cout(c_c470) );
 carry_save_3inputs #(W+5) cs_3in_c471(.a({ sum_b462, c_b462  ,sum_b463 }), .sum(sum_c471), .cout(c_c471) );
 carry_save_3inputs #(W+5) cs_3in_c472(.a({ c_b463  ,sum_b464, c_b464   }), .sum(sum_c472), .cout(c_c472) );
 carry_save_3inputs #(W+5) cs_3in_c473(.a({ sum_b465, c_b465  ,sum_b466 }), .sum(sum_c473), .cout(c_c473) );
 carry_save_3inputs #(W+5) cs_3in_c474(.a({ c_b466  ,sum_b467, c_b467   }), .sum(sum_c474), .cout(c_c474) );
 carry_save_3inputs #(W+5) cs_3in_c475(.a({ sum_b468, c_b468  ,sum_b469 }), .sum(sum_c475), .cout(c_c475) );
 carry_save_3inputs #(W+5) cs_3in_c476(.a({ c_b469  ,sum_b470, c_b470   }), .sum(sum_c476), .cout(c_c476) );
 carry_save_3inputs #(W+5) cs_3in_c477(.a({ sum_b471, c_b471  ,sum_b472 }), .sum(sum_c477), .cout(c_c477) );
 carry_save_3inputs #(W+5) cs_3in_c478(.a({ c_b472  ,sum_b473, c_b473   }), .sum(sum_c478), .cout(c_c478) );
 carry_save_3inputs #(W+5) cs_3in_c479(.a({ sum_b474, c_b474  ,sum_b475 }), .sum(sum_c479), .cout(c_c479) );
 carry_save_3inputs #(W+5) cs_3in_c480(.a({ c_b475  ,sum_b476, c_b476   }), .sum(sum_c480), .cout(c_c480) );
 carry_save_3inputs #(W+5) cs_3in_c481(.a({ sum_b477, c_b477  ,sum_b478 }), .sum(sum_c481), .cout(c_c481) );
 carry_save_3inputs #(W+5) cs_3in_c482(.a({ c_b478  ,sum_b479, c_b479   }), .sum(sum_c482), .cout(c_c482) );//   {1'b0,c_a476}  , {2'b00,c_1n2}  do not added

 carry_save_3inputs #(W+6) cs_3in_aa371(.a({ sum_351, c_351, sum_352            }), .sum(sum_371), .cout(c_371) ); 
 carry_save_3inputs #(W+6) cs_3in_aa372(.a({ c_352, sum_353, c_353              }), .sum(sum_372), .cout(c_372) );
 carry_save_3inputs #(W+6) cs_3in_aa373(.a({ sum_354, c_354, sum_355            }), .sum(sum_373), .cout(c_373) );
 carry_save_3inputs #(W+6) cs_3in_aa374(.a({ c_355, sum_356, c_356              }), .sum(sum_374), .cout(c_374) );
 carry_save_3inputs #(W+6) cs_3in_aa375(.a({ sum_357, c_357, sum_358            }), .sum(sum_375), .cout(c_375) );
 carry_save_3inputs #(W+6) cs_3in_aa376(.a({ c_358, sum_359, c_359              }), .sum(sum_376), .cout(c_376) );
 carry_save_3inputs #(W+6) cs_3in_aa377(.a({ sum_360, c_360, sum_361            }), .sum(sum_377), .cout(c_377) );
 carry_save_3inputs #(W+6) cs_3in_aa460(.a({ c_361, sum_450, c_450              }), .sum(sum_460), .cout(c_460) );
 carry_save_3inputs #(W+6) cs_3in_aa461(.a({ sum_451, c_451, sum_452            }), .sum(sum_461), .cout(c_461) );
 carry_save_3inputs #(W+6) cs_3in_aa462(.a({ c_452, sum_453, c_453              }), .sum(sum_462), .cout(c_462) );
 carry_save_3inputs #(W+6) cs_3in_aa463(.a({ sum_454, c_454, sum_455            }), .sum(sum_463), .cout(c_463) );
 carry_save_3inputs #(W+6) cs_3in_aa464(.a({ c_455, sum_456, c_456              }), .sum(sum_464), .cout(c_464) );
 carry_save_3inputs #(W+6) cs_3in_aa465(.a({ sum_457, c_457, sum_458            }), .sum(sum_465), .cout(c_465) );
 carry_save_3inputs #(W+6) cs_3in_aa466(.a({ c_458, sum_459, c_459              }), .sum(sum_466), .cout(c_466) );
 carry_save_3inputs #(W+6) cs_3in_aa467(.a({ sum_45a,c_45a,sum_c460             }), .sum(sum_467), .cout(c_467) ); 

 carry_save_3inputs #(W+6) cs_3in_d478(.a({   c_c460, sum_c461,   c_c461       }), .sum(sum_d478), .cout(c_d478) ); 
 carry_save_3inputs #(W+6) cs_3in_d479(.a({ sum_c462,   c_c462, sum_c463       }), .sum(sum_d479), .cout(c_d479) );
 carry_save_3inputs #(W+6) cs_3in_d480(.a({   c_c463, sum_c464,   c_c464       }), .sum(sum_d480), .cout(c_d480) );
 carry_save_3inputs #(W+6) cs_3in_d481(.a({ sum_c465,   c_c465, sum_c466       }), .sum(sum_d481), .cout(c_d481) );
 carry_save_3inputs #(W+6) cs_3in_d482(.a({   c_c466, sum_c467,   c_c467       }), .sum(sum_d482), .cout(c_d482) );
 carry_save_3inputs #(W+6) cs_3in_d483(.a({ sum_c468,   c_c468, sum_c469       }), .sum(sum_d483), .cout(c_d483) );
 carry_save_3inputs #(W+6) cs_3in_d484(.a({   c_c469, sum_c470,   c_c470       }), .sum(sum_d484), .cout(c_d484) );
 carry_save_3inputs #(W+6) cs_3in_d485(.a({ sum_c471,   c_c471, sum_c472       }), .sum(sum_d485), .cout(c_d485) );
 carry_save_3inputs #(W+6) cs_3in_d486(.a({   c_c472, sum_c473,   c_c473       }), .sum(sum_d486), .cout(c_d486) );
 carry_save_3inputs #(W+6) cs_3in_d487(.a({ sum_c474,   c_c474, sum_c475       }), .sum(sum_d487), .cout(c_d487) );
 carry_save_3inputs #(W+6) cs_3in_d488(.a({   c_c475, sum_c476,   c_c476       }), .sum(sum_d488), .cout(c_d488) );
 carry_save_3inputs #(W+6) cs_3in_d489(.a({ sum_c477,   c_c477, sum_c478       }), .sum(sum_d489), .cout(c_d489) );
 carry_save_3inputs #(W+6) cs_3in_d490(.a({   c_c478, sum_c479,   c_c479       }), .sum(sum_d490), .cout(c_d490) );
 carry_save_3inputs #(W+6) cs_3in_d491(.a({ sum_c480,   c_c480, sum_c481       }), .sum(sum_d491), .cout(c_d491) );
 carry_save_3inputs #(W+6) cs_3in_d492(.a({   c_c481, sum_c482,   c_c482       }), .sum(sum_d492), .cout(c_d492) );//   {2'b00,c_a476}  , {3'b000,c_1n2}  do not added

  
 carry_save_3inputs #(W+7) cs_3in_aa381(.a({ sum_371, c_371, sum_372      }), .sum(sum_381), .cout(c_381) );
 carry_save_3inputs #(W+7) cs_3in_aa382(.a({ c_372, sum_373, c_373        }), .sum(sum_382), .cout(c_382) );
 carry_save_3inputs #(W+7) cs_3in_aa383(.a({ sum_374, c_374, sum_375      }), .sum(sum_383), .cout(c_383) );
 carry_save_3inputs #(W+7) cs_3in_aa384(.a({ c_375, sum_376, c_376        }), .sum(sum_384), .cout(c_384) );
 carry_save_3inputs #(W+7) cs_3in_aa385(.a({ sum_377, c_377, sum_460      }), .sum(sum_385), .cout(c_385) );
 carry_save_3inputs #(W+7) cs_3in_aa470(.a({ c_460, sum_461, c_461        }), .sum(sum_470), .cout(c_470) );
 carry_save_3inputs #(W+7) cs_3in_aa471(.a({ sum_462, c_462, sum_463      }), .sum(sum_471), .cout(c_471) );
 carry_save_3inputs #(W+7) cs_3in_aa472(.a({ c_463, sum_464, c_464        }), .sum(sum_472), .cout(c_472) );
 carry_save_3inputs #(W+7) cs_3in_aa473(.a({ sum_465, c_465, sum_466      }), .sum(sum_473), .cout(c_473) );
 carry_save_3inputs #(W+7) cs_3in_aa474(.a({ sum_467, c_466, c_467        }), .sum(sum_474), .cout(c_474) ); 

 carry_save_3inputs #(W+7) cs_3in_e475(.a({ sum_d478,   c_d478, sum_d479  }), .sum(sum_e475), .cout(c_e475) );
 carry_save_3inputs #(W+7) cs_3in_e476(.a({   c_d479, sum_d480,   c_d480  }), .sum(sum_e476), .cout(c_e476) ); 
 carry_save_3inputs #(W+7) cs_3in_e477(.a({ sum_d481,   c_d481, sum_d482  }), .sum(sum_e477), .cout(c_e477) ); 
 carry_save_3inputs #(W+7) cs_3in_e478(.a({   c_d482, sum_d483,   c_d483  }), .sum(sum_e478), .cout(c_e478) ); 
 carry_save_3inputs #(W+7) cs_3in_e479(.a({ sum_d484,   c_d484, sum_d485  }), .sum(sum_e479), .cout(c_e479) ); 
 carry_save_3inputs #(W+7) cs_3in_e480(.a({   c_d485, sum_d486,   c_d486  }), .sum(sum_e480), .cout(c_e480) ); 
 carry_save_3inputs #(W+7) cs_3in_e481(.a({ sum_d487,   c_d487, sum_d488  }), .sum(sum_e481), .cout(c_e481) ); 
 carry_save_3inputs #(W+7) cs_3in_e482(.a({   c_d488, sum_d489,   c_d489  }), .sum(sum_e482), .cout(c_e482) ); 
 carry_save_3inputs #(W+7) cs_3in_e483(.a({ sum_d490,   c_d490, sum_d491  }), .sum(sum_e483), .cout(c_e483) ); 
 carry_save_3inputs #(W+7) cs_3in_e484(.a({   c_d491, sum_d492,   c_d492  }), .sum(sum_e484), .cout(c_e484) ); //   {3'b000,c_a476}  , {4'b0000,c_1n2}  do not added



 carry_save_3inputs #(W+8) cs_3in_a391(.a({ sum_381, c_381, sum_382   }), .sum(sum_391), .cout(c_391) );
 carry_save_3inputs #(W+8) cs_3in_a392(.a({ c_382, sum_383, c_383     }), .sum(sum_392), .cout(c_392) );
 carry_save_3inputs #(W+8) cs_3in_a393(.a({ sum_384, c_384, sum_385   }), .sum(sum_393), .cout(c_393) );
 carry_save_3inputs #(W+8) cs_3in_a480(.a({ c_385, sum_470, c_470     }), .sum(sum_480), .cout(c_480) );
 carry_save_3inputs #(W+8) cs_3in_a481(.a({ sum_471, c_471, sum_472   }), .sum(sum_481), .cout(c_481) );
 carry_save_3inputs #(W+8) cs_3in_a482(.a({ c_472, sum_473, c_473     }), .sum(sum_482), .cout(c_482) );
 carry_save_3inputs #(W+8) cs_3in_a483(.a({ sum_474, c_474, sum_e475  }), .sum(sum_483), .cout(c_483) );

 carry_save_3inputs #(W+8) cs_3in_b484(.a({   c_e475, sum_e476,   c_e476                }), .sum(sum_b484), .cout(c_b484) ); 
 carry_save_3inputs #(W+8) cs_3in_b485(.a({ sum_e477,   c_e477, sum_e478                }), .sum(sum_b485), .cout(c_b485) );
 carry_save_3inputs #(W+8) cs_3in_b486(.a({   c_e478, sum_e479,   c_e479                }), .sum(sum_b486), .cout(c_b486) );
 carry_save_3inputs #(W+8) cs_3in_b487(.a({ sum_e480,   c_e480, sum_e481                }), .sum(sum_b487), .cout(c_b487) );
 carry_save_3inputs #(W+8) cs_3in_b488(.a({   c_e481, sum_e482,   c_e482                }), .sum(sum_b488), .cout(c_b488) );
 carry_save_3inputs #(W+8) cs_3in_b489(.a({ sum_e483,   c_e483, sum_e484                }), .sum(sum_b489), .cout(c_b489) );
 carry_save_3inputs #(W+8) cs_3in_b490(.a({   c_e484, {4'b0000,c_a476}, {5'b00000,c_1n2}}), .sum(sum_b490), .cout(c_b490) );


 carry_save_3inputs #(W+9) cs_3in_a490(.a({ sum_391, c_391, sum_392     }), .sum(sum_490), .cout(c_490) );
 carry_save_3inputs #(W+9) cs_3in_a491(.a({ c_392, sum_393, c_393       }), .sum(sum_491), .cout(c_491) );
 carry_save_3inputs #(W+9) cs_3in_a492(.a({ sum_480, c_480, sum_481     }), .sum(sum_492), .cout(c_492) );
 carry_save_3inputs #(W+9) cs_3in_a493(.a({ c_481, sum_482, c_482       }), .sum(sum_493), .cout(c_493) ); 

 carry_save_3inputs #(W+9) cs_3in_b494(.a({ sum_483 , c_483  , sum_b484 }), .sum(sum_b494), .cout(c_b494) );
 carry_save_3inputs #(W+9) cs_3in_b495(.a({  c_b484  ,sum_b485, c_b485  }), .sum(sum_b495), .cout(c_b495) );
 carry_save_3inputs #(W+9) cs_3in_b496(.a({ sum_b486, c_b486  ,sum_b487 }), .sum(sum_b496), .cout(c_b496) );
 carry_save_3inputs #(W+9) cs_3in_b497(.a({  c_b487  ,sum_b488, c_b488  }), .sum(sum_b497), .cout(c_b497) );
 carry_save_3inputs #(W+9) cs_3in_b498(.a({ sum_b489, c_b489  ,sum_b490 }), .sum(sum_b498), .cout(c_b498) ); //   c_b490  do not added

 carry_save_3inputs #(W+10) cs_3in_bb450(.a({ sum_490 , c_490   , sum_491  }), .sum(sum_b50), .cout(c_b50) );
 carry_save_3inputs #(W+10) cs_3in_bb451(.a({  c_491   , sum_492 , c_492   }), .sum(sum_b51), .cout(c_b51) );
 carry_save_3inputs #(W+10) cs_3in_bb452(.a({ sum_493 , c_493   , sum_b494 }), .sum(sum_b52), .cout(c_b52) );
 carry_save_3inputs #(W+10) cs_3in_bb453(.a({  c_b494  , sum_b495, c_b495  }), .sum(sum_b53), .cout(c_b53) );
 carry_save_3inputs #(W+10) cs_3in_bb454(.a({ sum_b496, c_b496  , sum_b497 }), .sum(sum_b54), .cout(c_b54) );
 carry_save_3inputs #(W+10) cs_3in_bb455(.a({  c_b497  , sum_b498, c_b498  }), .sum(sum_b55), .cout(c_b55) ); // {1'b0,c_b490}  do not added

 carry_save_3inputs #(W+11) cs_3in_bb456(.a({ sum_b50,   c_b50, sum_b51 }), .sum(sum_b56), .cout(c_b56) );
 carry_save_3inputs #(W+11) cs_3in_bb457(.a({   c_b51, sum_b52,   c_b52 }), .sum(sum_b57), .cout(c_b57) );
 carry_save_3inputs #(W+11) cs_3in_bb458(.a({ sum_b53,   c_b53, sum_b54 }), .sum(sum_b58), .cout(c_b58) );
 carry_save_3inputs #(W+11) cs_3in_bb459(.a({   c_b54, sum_b55,   c_b55 }), .sum(sum_b59), .cout(c_b59) ); // {2'b00,c_b490}  do not added


carry_save_9inputs #(W+14) cs_9in (.a({ sum_b56, c_b56, sum_b57, c_b57, sum_b58, c_b58, sum_b59, c_b59,  {3'b000,c_b490} }), .sum(sum5), .cout(cout5)  );
//carry_save_10inputs #(W+12) cs_9in (.a({ sum_490, sum_491, sum_492, sum_493, c_490, c_491, c_492, c_493, {1'b0,sum_483}, {1'b0,c_483} }), .sum(sum5), .cout(cout5)  );

assign cout = cout5[W+9  :0];
assign sum  = sum5 [W+9  :0];


endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////
////Generic Ripple Carry Adder
//////////////////////////////////////
// 
//module ripple_carry#(
//    parameter W      = 4  //    input data width
//)
//(a, b, cin, sum, cout);
//input  [W-1:0] a,b;
//input          cin;
//wire   [W  :0] c1;
//output [W-1:0] sum;
//output cout;
//
//genvar i;
//
//generate
//   for (i=0; i<=W-1; i=i+1) begin  :gen_rca
//      full_adder fa1 ( .a(a[i]), .b(b[i]),  .cin(c1[i]), .sum(sum[i]), .cout(c1[i+1])  );
//   end 
//endgenerate
//assign c1[0] = cin;
//assign cout  = c1[W];
//
//endmodule
//
//////////////////////////////////////////////
////1bit Full Adder
/////////////////////////////////////////////
//module full_adder(a,b,cin,sum, cout);
//input a,b,cin;
//output sum, cout;
//wire x,y,z;
//half_adder  h1(.a(a), .b(b), .sum(x), .cout(y));
//half_adder  h2(.a(x), .b(cin), .sum(sum), .cout(z));
//assign cout= y|z;
//endmodule
/////////////////////////////////////////////
//// 1 bit Half Adder
//////////////////////////////////////////////
//module half_adder( a,b, sum, cout );
//input a,b;
//output sum,  cout;
//assign sum= a^b;
//assign cout= a & b;
//endmodule
