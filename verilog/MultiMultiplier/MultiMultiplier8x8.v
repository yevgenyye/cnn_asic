module MultiMultiplier8x8
(    
    input wire          clk,
    input       [8-1:0] d  , // unsigned (data)
    input       [8-1:0] w1 , //   signed (weights) for data input - 8 4 2
    input       [8-1:0] w2 , //   signed (weights) for data input -   4 2
    input       [8-1:0] w3 , //   signed (weights) for data input -     2
    input       [8-1:0] w4 , //   signed (weights) for data input -     2
    input       [  1:0] convtypeD,
    input       [  1:0] convtypeW,
    output reg  [18    :0] mul1, 
    output reg  [ 8    :0] mul2,
    output reg  [ 6    :0] mul3,
    output reg  [ 6    :0] mul4  
);


localparam [15:0] ZERO16 = 16'h0000;
localparam [11:0] ZERO12 = 12'h000;
localparam [2:0] M8x8 = 3'b000;
localparam [2:0] M8x4 = 3'b001;
localparam [2:0] M8x2 = 3'b010;	
localparam [2:0] M4x4 = 3'b011;
localparam [2:0] M4x2 = 3'b100;
localparam [2:0] M2x2 = 3'b101;
localparam [1:0] CONV_2  = 2'b01;
localparam [1:0] CONV_4  = 2'b10;
localparam [1:0] CONV_8  = 2'b11;

wire [  3:0] dw; //sign of weight;

wire [8-1:0] Wm1, Wm2, Wm3, Wm4, WmW1, WmW2, WmW3, WmW4  ; // magnitude of weigts
wire [  4:1] Ws1, Ws2, Ws3, Ws4, WsW1, WsW2, WsW3, WsW4   ; // sign of weigts
wire [  4:0] m11, m12, m13, m14, m21, m22, m23, m24; // unsigned result of multiplication
wire [  4:0] m31, m32, m33, m34, m41, m42, m43, m44; // unsigned result of multiplication
wire [  5:0] m2122, m2324;

wire [  8:0] pre_1_1, pre_1_2, pre_1_3, pre_1_4, pre_2_1, pre_2_2, pre_2_3, pre_2_4;
wire [  8:0] pre_3_1, pre_3_2, pre_3_3, pre_3_4, pre_4_1, pre_4_2, pre_4_3, pre_4_4;

wire [8+2:0] st1_1_s,  st1_1_c, st1_2_s,  st1_2_c, st1_3_s,  st1_3_c, st1_4_s,  st1_4_c; 
wire [11 :0] st1_1_sum, st1_2_sum,st1_3_sum,st1_4_sum;

wire [ 17:0] shf_1_1, shf_1_2, shf_1_3, shf_1_4, shf_1_5, shf_1_6, shf_1_7, shf_1_8; // shift stage 1
wire [  8:0] shf_2_1, shf_2_2, shf_2_3, shf_2_4; // shift stage 1

wire [ 13-1:0] st2_2_s, st2_2_c;
wire [ 19:0] st2_1_s, st2_1_c;

  wire [20     :0] mul1a; 
  wire [9      :0] mul2a;
  wire [6      :0] mul3a;
  wire [6      :0] mul4a;


wire [  2:0] convtype;


assign convtype = (convtypeD == CONV_8 && convtypeW == CONV_8) ? M8x8 :
                  (convtypeD == CONV_8 && convtypeW == CONV_4) ? M8x4 :
                  (convtypeD == CONV_8 && convtypeW == CONV_2) ? M8x2 :
                  (convtypeD == CONV_4 && convtypeW == CONV_4) ? M4x4 :
                  (convtypeD == CONV_4 && convtypeW == CONV_2) ? M4x2 :
                                                                 M2x2 ;

//Signed2SMagnitude s2sm1 (w1, convtypeW, Ws1, Wm1);
//Signed2SMagnitude s2sm2 (w2, convtypeW, Ws2, Wm2);
//Signed2SMagnitude s2sm3 (w3, convtypeW, Ws3, Wm3);
//Signed2SMagnitude s2sm4 (w4, convtypeW, Ws4, Wm4);

// weight's magnitude for each 2x2 multiplier
//assign WmW1 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm1 :  Wm1 ; // CONV_2
//assign WmW2 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm1 :  Wm2 ; // CONV_2
//assign WmW3 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm2 :  Wm3 ; // CONV_2
//assign WmW4 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm2 :  Wm4 ; // CONV_2

assign WmW1 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w1 :  w1 ; // CONV_2
assign WmW2 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w1 :  w2 ; // CONV_2
assign WmW3 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w2 :  w3 ; // CONV_2
assign WmW4 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w2 :  w4 ; // CONV_2

// assign dw   = (convtypeD == CONV_8) ? { WmW4[7] , WmW4[7] ,WmW4[7] ,WmW4[7] } 
////// weight's sign for each 2x2 multiplier
assign WsW1 = (convtypeW == CONV_8) ? { WmW1[7], 3'b000  } : (convtypeW == CONV_4) ? { WmW1[7], 1'b0, WmW1[3], 1'b0 } :  { WmW1[7], WmW1[5], WmW1[3], WmW1[1] } ; // CONV_2  
assign WsW2 = (convtypeW == CONV_8) ? { WmW2[7], 3'b000  } : (convtypeW == CONV_4) ? { WmW2[7], 1'b0, WmW2[3], 1'b0 } :  { WmW2[7], WmW2[5], WmW2[3], WmW2[1] } ; // CONV_2  
assign WsW3 = (convtypeW == CONV_8) ? { WmW3[7], 3'b000  } : (convtypeW == CONV_4) ? { WmW3[7], 1'b0, WmW3[3], 1'b0 } :  { WmW3[7], WmW3[5], WmW3[3], WmW3[1] } ; // CONV_2  
assign WsW4 = (convtypeW == CONV_8) ? { WmW4[7], 3'b000  } : (convtypeW == CONV_4) ? { WmW4[7], 1'b0, WmW4[3], 1'b0 } :  { WmW4[7], WmW4[5], WmW4[3], WmW4[1] } ; // CONV_2  


// 1-st column
Mult_2bits mu11 ( WsW1[1], WmW1[1:0], d[1:0], m11);
Mult_2bits mu12 ( WsW1[2], WmW1[3:2], d[1:0], m12);
Mult_2bits mu13 ( WsW1[3], WmW1[5:4], d[1:0], m13);
Mult_2bits mu14 ( WsW1[4], WmW1[7:6], d[1:0], m14);
// 2-nd column
Mult_2bits mu21 ( WsW2[1], WmW2[1:0], d[3:2], m21);
Mult_2bits mu22 ( WsW2[2], WmW2[3:2], d[3:2], m22);
Mult_2bits mu23 ( WsW2[3], WmW2[5:4], d[3:2], m23);
Mult_2bits mu24 ( WsW2[4], WmW2[7:6], d[3:2], m24);
// 3-rd column
Mult_2bits mu31 ( WsW3[1], WmW3[1:0], d[5:4], m31);
Mult_2bits mu32 ( WsW3[2], WmW3[3:2], d[5:4], m32);
Mult_2bits mu33 ( WsW3[3], WmW3[5:4], d[5:4], m33);
Mult_2bits mu34 ( WsW3[4], WmW3[7:6], d[5:4], m34);
// 4-th column
Mult_2bits mu41 ( WsW4[1], WmW4[1:0], d[7:6], m41);
Mult_2bits mu42 ( WsW4[2], WmW4[3:2], d[7:6], m42);
Mult_2bits mu43 ( WsW4[3], WmW4[5:4], d[7:6], m43);
Mult_2bits mu44 ( WsW4[4], WmW4[7:6], d[7:6], m44);
///////////////////////////// Config: 2x2 + 4x2 + 4x4

// Stage 1. Prepare basic patterns for 2x2, 4x2 and 4x4 multiplication

assign pre_1_1 =                         { {(4) {m11[4]}}, m11}                                      ;
assign pre_1_2 = (convtypeW == CONV_2) ? { {(4) {m12[4]}}, m12} :       {{(4) {m12[4]}}, m12, 2'b00} ;
assign pre_2_1 =                         { {(4) {m21[4]}}, m21, 2'b00} ;
assign pre_2_2 = (convtypeW == CONV_2) ? { {(4) {m22[4]}}, m22, 2'b00} : {m22 ,4'b0000};

assign pre_1_3 =                         { {(4) {m13[4]}}, m13}                                        ;
assign pre_1_4 = (convtypeW == CONV_2) ? { {(4) {m14[4]}}, m14} :       { {(4) {m14[4]}} , m14, 2'b00} ;
assign pre_2_3 =                         { {(4) {m23[4]}}, m23, 2'b00} ;
assign pre_2_4 = (convtypeW == CONV_2) ? { {(4) {m24[4]}}, m24, 2'b00} : {m24 ,4'b0000};

assign pre_3_1 =                         { {(4) {m31[4]}}, m31}                                        ;
assign pre_3_2 = (convtypeW == CONV_2) ? { {(4) {m32[4]}}, m32} :       { {(4) {m32[4]}} , m32, 2'b00} ;
assign pre_4_1 =                         { {(4) {m41[4]}}, m41, 2'b00} ;
assign pre_4_2 = (convtypeW == CONV_2) ? { {(4) {m42[4]}}, m42, 2'b00} : {m42 ,4'b0000};

assign pre_3_3 =                         { {(4) {m33[4]}}, m33}                                        ;
assign pre_3_4 = (convtypeW == CONV_2) ? { {(4) {m34[4]}}, m34} :       { {(4) {m34[4]}} , m34, 2'b00} ;
assign pre_4_3 =                         { {(4) {m43[4]}}, m43, 2'b00} ;
assign pre_4_4 = (convtypeW == CONV_2) ? { {(4) {m44[4]}}, m44, 2'b00} : {m44 ,4'b0000};

//carry_save_adder #(
//  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//  .W(9)  //    input data width
//)
//st1_1
//(
////  .a   ( {pre_1_1, pre_1_2, pre_1_3, pre_1_4} ), 
//  .a   ( {pre_1_1, pre_1_2, pre_2_1, pre_2_2} ), 
//  .sum ( st1_1_s  ), 
//  .cout( st1_1_c )
//);
//
//
//carry_save_adder #(
//  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//  .W(9)  //    input data width
//)
//st1_2
//(
////  .a   ( {pre_2_1, pre_2_2, pre_2_3, pre_2_4} ), 
//  .a   ( {pre_1_3, pre_1_4, pre_2_3, pre_2_4} ), 
//  .sum ( st1_2_s  ), 
//  .cout( st1_2_c )
//);
//carry_save_adder #(
//  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//  .W(9)  //    input data width
//)
//csa_st1_3
//(
////  .a   ( {pre_3_1, pre_3_2, pre_3_3, pre_3_4} ), 
//  .a   ( {pre_3_1, pre_3_2, pre_4_1, pre_4_2} ), 
//  .sum ( st1_3_s  ), 
//  .cout( st1_3_c )
//);
//carry_save_adder #(
//  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//  .W(9)  //    input data width
//)
//csa_st1_4
//(
////  .a   ( {pre_4_1, pre_4_2, pre_4_3, pre_4_4} ), 
//  .a   ( {pre_3_3, pre_3_4, pre_4_3, pre_4_4} ), 
//  .sum ( st1_4_s  ), 
//  .cout( st1_4_c )
//);
//
//
//ripple_carry# ( .W(8+2+1) ) st1_rca1 (.a(st1_1_s), .b(st1_1_c), .cin(1'b0), .sum(st1_1_sum[10:0]), .cout(st1_1_sum[11]) );
//ripple_carry# ( .W(8+2+1) ) st1_rca2 (.a(st1_2_s), .b(st1_2_c), .cin(1'b0), .sum(st1_2_sum[10:0]), .cout(st1_2_sum[11]) );
//ripple_carry# ( .W(8+2+1) ) st1_rca3 (.a(st1_3_s), .b(st1_3_c), .cin(1'b0), .sum(st1_3_sum[10:0]), .cout(st1_3_sum[11]) );
//ripple_carry# ( .W(8+2+1) ) st1_rca4 (.a(st1_4_s), .b(st1_4_c), .cin(1'b0), .sum(st1_4_sum[10:0]), .cout(st1_4_sum[11]) );

assign st1_1_sum[9:0] = {pre_1_1[8], pre_1_1[8:0]} + {pre_1_2[8], pre_1_2[8:0]} + {pre_2_1[8], pre_2_1[8:0]} + {pre_2_2[8], pre_2_2[8:0]};
assign st1_2_sum[9:0] = {pre_1_3[8], pre_1_3[8:0]} + {pre_1_4[8], pre_1_4[8:0]} + {pre_2_3[8], pre_2_3[8:0]} + {pre_2_4[8], pre_2_4[8:0]};
assign st1_3_sum[9:0] = {pre_3_1[8], pre_3_1[8:0]} + {pre_3_2[8], pre_3_2[8:0]} + {pre_4_1[8], pre_4_1[8:0]} + {pre_4_2[8], pre_4_2[8:0]};
assign st1_4_sum[9:0] = {pre_3_3[8], pre_3_3[8:0]} + {pre_3_4[8], pre_3_4[8:0]} + {pre_4_3[8], pre_4_3[8:0]} + {pre_4_4[8], pre_4_4[8:0]};

/// Stage 2. Shift prev stage sum and carry.

// 13 bits
assign m2122 = {m21[4], m21} + {m22[4], m22};
assign m2324 = {m23[4], m23} + {m24[4], m24};
assign shf_2_1 = (convtype == M2x2) ? { {(8) {m2122[5]}} , m2122[5:0] } : { st1_3_sum[9], st1_3_sum[9:0] } ; // 8x2,4,8
assign shf_2_2 = (convtype == M2x2) ? { {(8) {m2324[5]}} , m2324[5:0] } : { st1_4_sum[9], st1_4_sum[9:0] } ; // 8x2,4,8

// 17 bi0
assign shf_1_1 = (convtype == M2x2) ? { {(13) {m11[4]}}, m11[4:0] } :                         { {(8) {st1_1_sum[9]}}, st1_1_sum[9:0]       } ; // all exept 2x2
assign shf_1_2 = (convtype == M2x2) ? { {(13) {m12[4]}}, m12[4:0] } : (convtype  == M8x8)   ? { {(4) {st1_2_sum[9]}}, st1_2_sum[9:0], 4'h0 } : { {(8) {st1_2_sum[9]}}, st1_2_sum[9:0] } ; // all exept 2x2 and 8x8
assign shf_1_3 = (convtype == M2x2) ? { {(13) {m13[4]}}, m13[4:0] } : (convtypeD == CONV_4) ? { 20'h00000                                  } : { {(4) {st1_3_sum[9]}}, st1_3_sum[9:0], 4'h0 }; // 8x8
assign shf_1_4 = (convtype == M2x2) ? { {(13) {m14[4]}}, m14[4:0] } : (convtypeD == CONV_4) ? { 20'h00000                                  } : (convtype == M8x2 || convtype == M8x4) ? { {(4) {st1_4_sum[9]}}, st1_4_sum[9:0], 4'h0} : { st1_4_sum[9:0],              4'h0,    4'h0 }; // 8x8

// // 17 bi0
// assign shf_1_1 = (convtype == M2x2) ? { {(13) {m11[4]}}, m11[4:0] } : (convtypeD == CONV_4) ? { {(8) {st1_1_sum[9]}}, st1_1_sum[9:0] } : (convtype == M8x2 || convtype == M8x4) ? { {(8) {st1_1_sum[9]}},      st1_1_sum[9:0] } : { {(8) {st1_1_sum[9]}},       st1_1_sum[9:0] }; // 8x8
// assign shf_1_2 = (convtype == M2x2) ? { {(13) {m12[4]}}, m12[4:0] } : (convtypeD == CONV_4) ? { {(8) {st1_2_sum[9]}}, st1_2_sum[9:0] } : (convtype == M8x2 || convtype == M8x4) ? { {(8) {st1_2_sum[9]}},      st1_2_sum[9:0] } : { {(4) {st1_2_sum[9]}}, st1_2_sum[9:0], 4'h0 }; // 8x8
// assign shf_1_3 = (convtype == M2x2) ? { {(13) {m13[4]}}, m13[4:0] } : (convtypeD == CONV_4) ? { 20'h00000                            } : (convtype == M8x2 || convtype == M8x4) ? { {(4) {st1_3_sum[9]}}, st1_3_sum[9:0], 4'h0} : { {(4) {st1_3_sum[9]}}, st1_3_sum[9:0], 4'h0 }; // 8x8
// assign shf_1_4 = (convtype == M2x2) ? { {(13) {m14[4]}}, m14[4:0] } : (convtypeD == CONV_4) ? { 20'h00000                            } : (convtype == M8x2 || convtype == M8x4) ? { {(4) {st1_4_sum[9]}}, st1_4_sum[9:0], 4'h0} : { st1_4_sum[9:0],              4'h0,    4'h0 }; // 8x8




//    2x2 configuration outputs

assign mul3a = {m31[4] ,m31[4], m31} + 
               {m32[4], m32[4], m32} + 
               {m33[4], m33[4], m33} + 
               {m34[4], m34[4], m34};//st1_3_sum;
assign mul4a = {m41[4] ,m41[4], m41} + 
               {m42[4], m42[4], m42} + 
               {m43[4], m43[4], m43} + 
               {m44[4], m44[4], m44};//st1_4_sum;


// 2x2, 4x2, 4x4 outs

//ripple_carry# ( .W(9) ) st2_rca2 (.a(shf_2_1), .b(shf_2_2), .cin(1'b0), .sum(mul2a[8:0]), .cout(mul2a[9]));
assign mul2a[8:0] = shf_2_1  + shf_2_2;



//carry_save_adder #(
//  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//  .W(18)  //    input data width
//)
//csa_st2_1
//(
//  .a   ( {shf_1_1, shf_1_2, shf_1_3, shf_1_4} ), 
//  .sum ( st2_1_s ), 
//  .cout( st2_1_c )
//);
//ripple_carry# ( .W(20) ) st2_rca1 (.a(st2_1_s), .b(st2_1_c), .cin(1'b0), .sum(mul1a[19:0]), .cout(mul1a[20]));

assign mul1a[18:0] = {shf_1_1[17], shf_1_1[17:0]} + {shf_1_2[17], shf_1_2[17:0]} + {shf_1_3[17], shf_1_3[17:0]} + {shf_1_4[17], shf_1_4[17:0]} ;



always @(posedge clk)
 begin
   mul4 = mul4a;
   mul3 = mul3a;
   mul2 = mul2a;
   mul1 = mul1a[18    :0];
 end

endmodule
