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
    output reg  [17+3   :0] mul1, 
    output reg  [13+2   :0] mul2,
    output reg  [8+2+1  :0] mul3,
    output reg  [8+2+1  :0] mul4  
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

wire [  3:0] ds; //sign of data;

wire [8-1:0] Wm1, Wm2, Wm3, Wm4, WmW1, WmW2, WmW3, WmW4  ; // magnitude of b
wire [  4:0] m11, m12, m13, m14, m21, m22, m23, m24; // unsigned result of multiplication
wire [  4:0] m31, m32, m33, m34, m41, m42, m43, m44; // unsigned result of multiplication

wire [  8:0] pre_1_1, pre_1_2, pre_1_3, pre_1_4, pre_2_1, pre_2_2, pre_2_3, pre_2_4;
wire [  8:0] pre_3_1, pre_3_2, pre_3_3, pre_3_4, pre_4_1, pre_4_2, pre_4_3, pre_4_4;

wire [8+2:0] st1_1_s,  st1_1_c, st1_2_s,  st1_2_c, st1_3_s,  st1_3_c, st1_4_s,  st1_4_c; 
wire [ 16:0] shf_1_1, shf_1_2, shf_1_3, shf_1_4, shf_1_5, shf_1_6, shf_1_7, shf_1_8; // shift stage 1
wire [ 12:0] shf_2_1, shf_2_2, shf_2_3, shf_2_4; // shift stage 1

wire [ 13+2-1:0] st2_2_s, st2_2_c;
wire [ 17+3-1:0] st2_1_s, st2_1_c;

  wire [17+3   :0] mul1a; 
  wire [13+2   :0] mul2a;
  wire [8+2+1  :0] mul3a;
  wire [8+2+1  :0] mul4a;


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
assign WmW1 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w1 :  w1 ; // CONV_2
assign WmW2 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w1 :  w2 ; // CONV_2
assign WmW3 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w2 :  w3 ; // CONV_2
assign WmW4 = (convtypeD == CONV_8) ? w1 : (convtypeD == CONV_4) ? w2 :  w4 ; // CONV_2
//
////// weight's sign for each 2x2 multiplier
//assign WsW1 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws1 :  Ws1 ; // CONV_2  // Check it!!!
//assign WsW2 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws1 :  Ws2 ; // CONV_2  // Check it!!!
//assign WsW3 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws2 :  Ws3 ; // CONV_2  // Check it!!!
//assign WsW4 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws2 :  Ws4 ; // CONV_2  // Check it!!!

// Weight's MSBs (sign)
// 8 bits ->  WsW4[7] <= Ws1[7]
// 4 bits ->  WsW2[3] <= Ws1[3]
//            WsW4[3] <= Ws2[3]
// 2 bits ->  WsW2[1] <= Ws1[1]
//            WsW4[1] <= Ws2[1]
//            WsW4[1] <= Ws2[1]
//            WsW4[1] <= Ws2[1]

assign ds = (convtypeD == CONV_8) ? { d[7], 1'b0, 1'b0, 1'b0 } :
            (convtypeD == CONV_4) ? { d[7], 1'b0, d[7], 1'b0 } :
                                    { d[7], d[7], d[7], d[7] } ;

// Group of multipliers 
// 1-st column
Mult_2bits mu11 ( ds[0], d[1:0], WmW1[1:0], m11);
Mult_2bits mu12 ( ds[0], d[1:0], WmW1[3:2], m12);
Mult_2bits mu13 ( ds[0], d[1:0], WmW1[5:4], m13);
Mult_2bits mu14 ( ds[0], d[1:0], WmW1[7:6], m14);
// 2-nd column
Mult_2bits mu21 ( ds[1], d[3:2], WmW2[1:0], m21);
Mult_2bits mu22 ( ds[1], d[3:2], WmW2[3:2], m22);
Mult_2bits mu23 ( ds[1], d[3:2], WmW2[5:4], m23);
Mult_2bits mu24 ( ds[1], d[3:2], WmW2[7:6], m24);
// 3-rd column
Mult_2bits mu31 ( ds[2], d[5:4], WmW3[1:0], m31);
Mult_2bits mu32 ( ds[2], d[5:4], WmW3[3:2], m32);
Mult_2bits mu33 ( ds[2], d[5:4], WmW3[5:4], m33);
Mult_2bits mu34 ( ds[2], d[5:4], WmW3[7:6], m34);
// 4-th column
Mult_2bits mu41 ( ds[3], d[7:6], WmW4[1:0], m41);
Mult_2bits mu42 ( ds[3], d[7:6], WmW4[3:2], m42);
Mult_2bits mu43 ( ds[3], d[7:6], WmW4[5:4], m43);
Mult_2bits mu44 ( ds[3], d[7:6], WmW4[7:6], m44);

///////////////////////////// Config: 2x2 + 4x2 + 4x4

// Stage 1. Prepare basic patterns for 2x2, 4x2 and 4x4 multiplication

assign pre_1_1 =                                             {4'h0, m11}                                               ;
assign pre_1_2 = (convtype == M2x2 || convtypeW == CONV_2) ? {4'h0, m12} :                         {2'b00, m12, 2'b00} ;
assign pre_2_1 = (convtype == M2x2)                        ? {4'h0, m21} :                         {2'b00, m21, 2'b00} ;
assign pre_2_2 = (convtype == M2x2)                        ? {4'h0, m22} : (convtypeW == CONV_2) ? {2'b00, m22, 2'b00} : {m22 ,4'b0000};


assign pre_1_3 =                                             {4'h0, m13}                                               ;
assign pre_1_4 = (convtype == M2x2 || convtypeW == CONV_2) ? {4'h0, m14} :                         {2'b00, m14, 2'b00} ;
assign pre_2_3 = (convtype == M2x2)                        ? {4'h0, m23} :                         {2'b00, m23, 2'b00} ;
assign pre_2_4 = (convtype == M2x2)                        ? {4'h0, m24} : (convtypeW == CONV_2) ? {2'b00, m24, 2'b00} : {m24 ,4'b0000};

assign pre_3_1 =                                             {4'h0, m31}                                               ;
assign pre_3_2 = (convtype == M2x2 || convtypeW == CONV_2) ? {4'h0, m32} :                         {2'b00, m32, 2'b00} ;
assign pre_4_1 = (convtype == M2x2)                        ? {4'h0, m41} :                         {2'b00, m41, 2'b00} ;
assign pre_4_2 = (convtype == M2x2)                        ? {4'h0, m42} : (convtypeW == CONV_2) ? {2'b00, m42, 2'b00} : {m42 ,4'b0000};

assign pre_3_3 =                                             {4'h0, m33}                                               ;
assign pre_3_4 = (convtype == M2x2 || convtypeW == CONV_2) ? {4'h0, m34} :                         {2'b00, m34, 2'b00} ;
assign pre_4_3 = (convtype == M2x2)                        ? {4'h0, m43} :                         {2'b00, m43, 2'b00} ;
assign pre_4_4 = (convtype == M2x2)                        ? {4'h0, m44} : (convtypeW == CONV_2) ? {2'b00, m44, 2'b00} : {m44 ,4'b0000};

carry_save_adder #(
  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(9)  //    input data width
)
st1_1
(
  .a   ( {pre_1_1, pre_1_2, pre_1_3, pre_1_4} ), 
  .sum ( st1_1_s  ), 
  .cout( st1_1_c )
);

carry_save_adder #(
  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(9)  //    input data width
)
st1_2
(
  .a   ( {pre_2_1, pre_2_2, pre_2_3, pre_2_4} ), 
  .sum ( st1_2_s  ), 
  .cout( st1_2_c )
);
carry_save_adder #(
  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(9)  //    input data width
)
csa_st1_3
(
  .a   ( {pre_3_1, pre_3_2, pre_3_3, pre_3_4} ), 
  .sum ( st1_3_s  ), 
  .cout( st1_3_c )
);
carry_save_adder #(
  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(9)  //    input data width
)
csa_st1_4
(
  .a   ( {pre_4_1, pre_4_2, pre_4_3, pre_4_4} ), 
  .sum ( st1_4_s  ), 
  .cout( st1_4_c )
);

/// Stage 2. Shift prev stage sum and carry.

// 13 bits
assign shf_2_1 = (convtype == M2x2) ? { 8'h00, st1_2_s } : { 2'b00, st1_3_s } ; // 8x2,4,8
assign shf_2_2 = (convtype == M2x2) ? { 8'h00, st1_2_c } : { 2'b00, st1_3_c } ; // 8x2,4,8
assign shf_2_3 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : { 2'b00, st1_4_s } ; // 8x2,4,8
assign shf_2_4 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : { 2'b00, st1_4_c } ; // 8x2,4,8

//assign shf_2_1 = (convtype == M2x2) ? { 8'h00, st1_2_s } : (convtypeD == CONV_4) ? { 2'b00, st1_3_s } : { 2'b00, {(9){1'b0}} } ; // 8x2,4,8
//assign shf_2_2 = (convtype == M2x2) ? { 8'h00, st1_2_c } : (convtypeD == CONV_4) ? { 2'b00, st1_3_c } : { 2'b00, {(9){1'b0}} } ; // 8x2,4,8
//assign shf_2_3 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : (convtypeD == CONV_4) ? { 2'b00, st1_4_s } : { 2'b00, {(9){1'b0}} } ; // 8x2,4,8
//assign shf_2_4 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : (convtypeD == CONV_4) ? { 2'b00, st1_4_c } : { 2'b00, {(9){1'b0}} } ; // 8x2,4,8

// 17 bits
assign shf_1_1 = (convtype == M2x2) ? { 8'h00, st1_1_s } : (convtypeD == CONV_4) ? { 8'h00, st1_1_s } : (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , 4'h0   , st1_1_s } : { 4'h0   , 4'h0   , st1_1_s }; // 8x8
assign shf_1_2 = (convtype == M2x2) ? { 8'h00, st1_1_c } : (convtypeD == CONV_4) ? { 8'h00, st1_1_c } : (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , 4'h0   , st1_1_c } : { 4'h0   , 4'h0   , st1_1_c }; // 8x8
assign shf_1_3 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : (convtypeD == CONV_4) ? { 8'h00, st1_2_s } : (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , 4'h0   , st1_2_s } : { 4'h0   , st1_2_s, 4'h0    }; // 8x8
assign shf_1_4 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : (convtypeD == CONV_4) ? { 8'h00, st1_2_c } : (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , 4'h0   , st1_2_c } : { 4'h0   , st1_2_c, 4'h0    }; // 8x8
assign shf_1_5 =                                                                                        (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , st1_3_s, 4'h0    } : { 4'h0   , st1_3_s, 4'h0    }; // 8x8
assign shf_1_6 =                                                                                        (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , st1_3_c, 4'h0    } : { 4'h0   , st1_3_c, 4'h0    }; // 8x8
assign shf_1_7 =                                                                                        (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , st1_4_s, 4'h0    } : { st1_4_s, 4'h0   , 4'h0    }; // 8x8
assign shf_1_8 =                                                                                        (convtype == M8x2 || convtype == M8x4) ? { 4'h0 , st1_4_c, 4'h0    } : { st1_4_c, 4'h0   , 4'h0    }; // 8x8
   

carry_save_adder #(
  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(13)  //    input data width
)
csa_st2_2
(
  .a   ( {shf_2_1, shf_2_2, shf_2_3, shf_2_4} ), 
  .sum ( st2_2_s ), 
  .cout( st2_2_c )
);

carry_save_adder #(
  .N(8),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(3),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(17)  //    input data width
)
csa_st2_1
(
  .a   ( {shf_1_1, shf_1_2, shf_1_3, shf_1_4, shf_1_5, shf_1_6, shf_1_7, shf_1_8} ), 
  .sum ( st2_1_s ), 
  .cout( st2_1_c )
);


//    2x2 configuration outputs
carry_lookahead_adder #(
            .W (8+2+1)      
         )   cla_4 (
            .i_add1  ( st1_4_s ), 
            .i_add2  ( st1_4_c ), 
            .c_in    ( 1'b0    ),
            .o_result( mul4a   ) );

carry_lookahead_adder #(
            .W (8+2+1)      
         )   cla_3 (
            .i_add1  ( st1_3_s ), 
            .i_add2  ( st1_3_c ), 
            .c_in    ( 1'b0    ),
            .o_result( mul3a   ) );

//st2_2_s_mux 
//st2_2_c_mux
//st2_1_s_mux 
//st2_1_c_mux

// 2x2, 4x2, 4x4 outs
carry_lookahead_adder #(
            .W (13+2)      
         )   cla_2 (
            .i_add1  ( st2_2_s ), 
            .i_add2  ( st2_2_c ), 
            .c_in    ( 1'b0    ),
            .o_result( mul2a   ) );
// all outs

carry_lookahead_adder #(
            .W (17+3)      
         )   cla_1 (
            .i_add1  ( st2_1_s ), 
            .i_add2  ( st2_1_c ), 
            .c_in    ( 1'b0    ),
            .o_result( mul1a   ) );

///////////////////////////// Config: 2x2 + partial 4x4
// 
// // Stage 1. Prepare basic patterns for 2x2 and 4x4 multiplication
// 
// assign pre_1_1 =                         {4'h0, m11}                      ;
// assign pre_1_2 = (convtypeW == CONV_2) ? {4'h0, m12} : {2'b00, m12, 2'b00};
// assign pre_1_3 =                         {4'h0, m13}                      ;
// assign pre_1_4 = (convtypeW == CONV_2) ? {4'h0, m14} : {2'b00, m14, 2'b00};
// assign pre_2_1 = (convtypeW == CONV_2) ? {4'h0, m21} : {2'b00, m21, 2'b00};
// assign pre_2_2 = (convtypeW == CONV_2) ? {4'h0, m22} : {     m22 ,4'b0000};
// assign pre_2_3 = (convtypeW == CONV_2) ? {4'h0, m23} : {2'b00, m23, 2'b00};
// assign pre_2_4 = (convtypeW == CONV_2) ? {4'h0, m24} : {     m24 ,4'b0000};
// assign pre_3_1 =                         {4'h0, m31}                      ;
// assign pre_3_2 = (convtypeW == CONV_2) ? {4'h0, m32} : {2'b00, m32, 2'b00};
// assign pre_3_3 =                         {4'h0, m33}                      ;
// assign pre_3_4 = (convtypeW == CONV_2) ? {4'h0, m34} : {2'b00, m34, 2'b00};
// assign pre_4_1 = (convtypeW == CONV_2) ? {4'h0, m41} : {2'b00, m41, 2'b00};
// assign pre_4_2 = (convtypeW == CONV_2) ? {4'h0, m42} : {     m42 ,4'b0000};
// assign pre_4_3 = (convtypeW == CONV_2) ? {4'h0, m43} : {2'b00, m43, 2'b00};
// assign pre_4_4 = (convtypeW == CONV_2) ? {4'h0, m44} : {     m44 ,4'b0000};
// 
// carry_save_adder #(
//   .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//   .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//   .W(9)  //    input data width
// )
// st1_1
// (
//   .a   ( {pre_1_1, pre_1_2, pre_1_3, pre_1_4} ), 
//   .sum ( st1_1_s  ), 
//   .cout( st1_1_c )
// );
// 
// carry_save_adder #(
//   .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//   .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//   .W(9)  //    input data width
// )
// st1_2
// (
//   .a   ( {pre_2_1, pre_2_2, pre_2_3, pre_2_4} ), 
//   .sum ( st1_2_s  ), 
//   .cout( st1_2_c )
// );
// carry_save_adder #(
//   .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//   .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//   .W(9)  //    input data width
// )
// csa_st1_3
// (
//   .a   ( {pre_3_1, pre_3_2, pre_3_3, pre_3_4} ), 
//   .sum ( st1_3_s  ), 
//   .cout( st1_3_c )
// );
// carry_save_adder #(
//   .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//   .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//   .W(9)  //    input data width
// )
// csa_st1_4
// (
//   .a   ( {pre_4_1, pre_4_2, pre_4_3, pre_4_4} ), 
//   .sum ( st1_4_s  ), 
//   .cout( st1_4_c )
// );
// 
// /// Stage 2. Shift prev stage sum and carry.
// 
// // 13 bits
// assign shf_2_1 = (convtype == M2x2) ? { 8'h00, st1_2_s } :                     { 2'b00, st1_3_s };
// assign shf_2_2 = (convtype == M2x2) ? { 8'h00, st1_2_c } :                     { 2'b00, st1_3_c };
// assign shf_2_3 = (convtype == M2x2) ? { 16'h0000, 1'b0 } :(convtype == M4x2) ? { st1_4_s, 2'b00 } : { 2'b00, st1_4_s }; // M4x4
// assign shf_2_4 = (convtype == M2x2) ? { 16'h0000, 1'b0 } :(convtype == M4x2) ? { st1_4_c, 2'b00 } : { 2'b00, st1_4_c }; // M4x4
// 
// // 17 bits
// assign shf_1_1 = (convtype == M2x2) ? { 8'h00, st1_1_s } : (convtype == M4x2) ? { 8'h00    ,        st1_1_s } : (convtype == M4x4) ? { 8'h00, st1_1_s } : (convtype == M8x2) ? { 4'h0 , 4'h0  , st1_1_s     } : (convtype == M8x4) ? { 4'h0 , 4'h0   , st1_1_s } : { 4'h0   , 4'h0   , st1_1_s }; 
// assign shf_1_2 = (convtype == M2x2) ? { 8'h00, st1_1_c } : (convtype == M4x2) ? { 8'h00    ,        st1_1_c } : (convtype == M4x4) ? { 8'h00, st1_1_c } : (convtype == M8x2) ? { 6'b000000 , st1_1_c, 2'b00 } : (convtype == M8x4) ? { 4'h0 , 4'h0   , st1_1_c } : { 4'h0   , st1_1_c, 4'h0    }; 
// assign shf_1_3 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : (convtype == M4x2) ? { 6'b000000, st1_2_s, 2'b00 } : (convtype == M4x4) ? { 8'h00, st1_2_s } : (convtype == M8x2) ? { 4'b0000, st1_2_s, 4'b0000  } : (convtype == M8x4) ? { 4'h0 , st1_2_s, 4'h0    } : { 4'h0   , st1_2_s, 4'h0    }; 
// assign shf_1_4 = (convtype == M2x2) ? { 16'h0000, 1'b0 } : (convtype == M4x2) ? { 6'b000000, st1_2_c, 2'b00 } : (convtype == M4x4) ? { 8'h00, st1_2_c } : (convtype == M8x2) ? { 2'b00, st1_2_c, 6'b000000  } : (convtype == M8x4) ? { 4'h0 , st1_2_c, 4'h0    } : { st1_2_c, 4'h0   , 4'h0    }; 
//    
// 
// carry_save_adder #(
//   .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//   .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//   .W(13)  //    input data width
// )
// csa_st2_2
// (
//   .a   ( {shf_2_1, shf_2_2, shf_2_3, shf_2_4} ), 
//   .sum ( st2_2_s ), 
//   .cout( st2_2_c )
// );
// 
// carry_save_adder #(
//   .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//   .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//   .W(17)  //    input data width
// )
// csa_st2_1
// (
//   .a   ( {shf_1_1, shf_1_2, shf_1_3, shf_1_4} ), 
//   .sum ( st2_1_s ), 
//   .cout( st2_1_c )
// );
// 
// //    2x2 configuration outputs
// carry_lookahead_adder #(
//             .W (8+2+1)      
//          )   cla_4 (
//             .i_add1  ( st1_4_s ), 
//             .i_add2  ( st1_4_c ), 
//             .c_in    ( 1'b0    ),
//             .o_result( mul4a   ) );
// 
// carry_lookahead_adder #(
//             .W (8+2+1)      
//          )   cla_3 (
//             .i_add1  ( st1_3_s ), 
//             .i_add2  ( st1_3_c ), 
//             .c_in    ( 1'b0    ),
//             .o_result( mul3a   ) );
// 
// // 2x2, 4x2, 4x4 outs
// carry_lookahead_adder #(
//             .W (13+2)      
//          )   cla_2 (
//             .i_add1  ( st2_2_s ), 
//             .i_add2  ( st2_2_c ), 
//             .c_in    ( 1'b0    ),
//             .o_result( mul2a   ) );
// // all outs
// 
// carry_lookahead_adder #(
//             .W (17+2)      
//          )   cla_1 (
//             .i_add1  ( st2_1_s ), 
//             .i_add2  ( st2_1_c ), 
//             .c_in    ( 1'b0    ),
//             .o_result( mul1a   ) );
// 



always @(posedge clk)
 begin
   mul4 = mul4a;
   mul3 = mul3a;
   mul2 = mul2a;
   mul1 = mul1a;
 end

endmodule
