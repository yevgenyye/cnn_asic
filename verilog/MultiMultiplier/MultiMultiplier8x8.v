module MultiMultiplier8x8
(
    input       [8-1:0] d  , // unsigned (data)
    input       [8-1:0] w1 , //   signed (weights)
    input       [8-1:0] w2 , //   signed (weights)
    input       [8-1:0] w3 , //   signed (weights)
    input       [8-1:0] w4 , //   signed (weights)
    input       [  1:0] convtypeD,
    input       [  1:0] convtypeW,
    output wire [ 63:0] mul    
);
localparam [15:0] ZERO16 = 16'h0000;
localparam [2:0] M8x8 = 3'b000;
localparam [2:0] M8x4 = 3'b001;
localparam [2:0] M8x2 = 3'b010;	
localparam [2:0] M4x4 = 3'b011;
localparam [2:0] M4x2 = 3'b100;
localparam [2:0] M2x2 = 3'b101;
localparam [1:0] CONV_2  = 2'b01;
localparam [1:0] CONV_4  = 2'b10;
localparam [1:0] CONV_8  = 2'b11;

wire [  3:0] Ws1, Ws2, Ws3, Ws4, WsW1, WsW2, WsW3, WsW4  ; // sign of b
wire [8-1:0] Wm1, Wm2, Wm3, Wm4, WmW1, WmW2, WmW3, WmW4  ; // magnitude of b
wire [  3:0] m11, m12, m13, m14, m21, m22, m23, m24; 
wire [  3:0] m31, m32, m33, m34, m41, m42, m43, m44; 
wire [ 63:0] mul2x2;
wire [ 16:0] mul4x2_col1_a1, mul4x2_col1_a2, mul4x2_col2_a1, mul4x2_col2_a2, mul4x2_col3_a1, mul4x2_col3_a2, mul4x2_col4_a1, mul4x2_col4_a2;
wire [ 16:0] mul4x4_col1_a1, mul4x4_col1_a2, mul4x4_col1_a3, mul4x4_col2_a1, mul4x4_col2_a2, mul4x4_col2_a3 ;
wire [ 16:0] mul8x2_col1_a1, mul8x2_col1_a2, mul8x2_col2_a1, mul8x2_col2_a2, mul8x2_col3_a1, mul8x2_col3_a2, mul8x2_col4_a1, mul8x2_col4_a2;
wire [ 16:0] mul8x4_col1_a1, mul8x4_col1_a2, mul8x4_col1_a3, mul8x4_col1_a4, mul8x4_col2_a1, mul8x4_col2_a2, mul8x4_col2_a3, mul8x4_col2_a4;
wire [ 16:0] mul8x8_a1 , mul8x8_a2, mul8x8_a3, mul8x8_a4, mul8x8_a5, mul8x8_a6, mul8x8_a7;
wire [ 16:0] addM_1, addM_2, addM_3, addM_4;
wire [ 16:0] addL_1, addL_2, addL_3, addL_4, addL_5, addL_6, addL_7;
wire [  2:0] convtype;
wire [16+2-1 :0] addMsum , addLsum;
wire [16+2-1 :0] addMcout, addLcout;
wire [16+2   :0] addL_res, addM_res

assign convtype = (convtypeD == CONV_8 && convtypeW == CONV_8) ? M8x8 :
                  (convtypeD == CONV_8 && convtypeW == CONV_4) ? M8x4 :
                  (convtypeD == CONV_8 && convtypeW == CONV_2) ? M8x2 :
                  (convtypeD == CONV_4 && convtypeW == CONV_4) ? M4x4 :
                  (convtypeD == CONV_4 && convtypeW == CONV_2) ? M4x2 :
                                                                 M2x2 ;

Signed2SMagnitude (w1, convtypeB, Ws1, Wm1);
Signed2SMagnitude (w2, convtypeB, Ws2, Wm2);
Signed2SMagnitude (w3, convtypeB, Ws3, Wm3);
Signed2SMagnitude (w4, convtypeB, Ws4, Wm4);

assign WmW1 = (convtypeW == CONV_8) ? Wm1 : (convtypeW == CONV_4) ? Wm1 :  Wm1 ; // CONV_2
assign WmW2 = (convtypeW == CONV_8) ? Wm1 : (convtypeW == CONV_4) ? Wm1 :  Wm2 ; // CONV_2
assign WmW3 = (convtypeW == CONV_8) ? Wm1 : (convtypeW == CONV_4) ? Wm2 :  Wm3 ; // CONV_2
assign WmW4 = (convtypeW == CONV_8) ? Wm1 : (convtypeW == CONV_4) ? Wm2 :  Wm4 ; // CONV_2

//assign WsW1 = (convtypeW == CONV_8) ? Ws1 : (convtypeW == CONV_4) ? Ws1 :  Ws1 ; // CONV_2  // Check it!!!
//assign WsW2 = (convtypeW == CONV_8) ? Ws1 : (convtypeW == CONV_4) ? Ws1 :  Ws2 ; // CONV_2  // Check it!!!
//assign WsW3 = (convtypeW == CONV_8) ? Ws1 : (convtypeW == CONV_4) ? Ws2 :  Ws3 ; // CONV_2  // Check it!!!
//assign WsW4 = (convtypeW == CONV_8) ? Ws1 : (convtypeW == CONV_4) ? Ws2 :  Ws4 ; // CONV_2  // Check it!!!


// 1-st column
Mult_2bits ( d[1:0], WmW1[1:0], m11);
Mult_2bits ( d[1:0], WmW1[3:2], m12);
Mult_2bits ( d[1:0], WmW1[5:4], m13);
Mult_2bits ( d[1:0], WmW1[7:6], m14);
// 2-nd column
Mult_2bits ( d[3:2], WmW2[1:0], m21);
Mult_2bits ( d[3:2], WmW2[3:2], m22);
Mult_2bits ( d[3:2], WmW2[5:4], m23);
Mult_2bits ( d[3:2], WmW2[7:6], m24);
// 3-rd column
Mult_2bits ( d[5:4], WmW3[1:0], m31);
Mult_2bits ( d[5:4], WmW3[3:2], m32);
Mult_2bits ( d[5:4], WmW3[5:4], m33);
Mult_2bits ( d[5:4], WmW3[7:6], m34);
// 4-th column
Mult_2bits ( d[7:6], WmW4[1:0], m41);
Mult_2bits ( d[7:6], WmW4[3:2], m42);
Mult_2bits ( d[7:6], WmW4[5:4], m43);
Mult_2bits ( d[7:6], WmW4[7:6], m44);

assign mul2x2 = {m44, m43, m42, m41, m34, m33, m32, m31, m24, m23, m22, m21, m14, m13, m12, m11 };
assign mul4x2_col1_a1 = {6'b000000, m13, 4'b0000, m11 };
assign mul4x2_col1_a2 = {4'b0000, m14, 4'b0000, m12, 2'b00 };
assign mul4x2_col2_a1 = {6'b000000, m23, 4'b0000, m21 };
assign mul4x2_col2_a2 = {4'b0000, m24, 4'b0000, m22, 2'b00 };
assign mul4x2_col3_a1 = {6'b000000, m33, 4'b0000, m31 };
assign mul4x2_col3_a2 = {4'b0000, m34, 4'b0000, m32, 2'b00 };
assign mul4x2_col4_a1 = {6'b000000, m43, 4'b0000, m41 };
assign mul4x2_col4_a2 = {4'b0000, m44, 4'b0000, m42, 2'b00 };

//assign mul4x4_col1_a1 = { {(8){1'b0}}, m22,   m11 };
//assign mul4x4_col1_a2 = { {(6){1'b0}}, m21, 2'b00 };
//assign mul4x4_col1_a3 = { {(6){1'b0}}, m12, 2'b00 };
//assign mul4x4_col2_a1 = { {(8){1'b0}}, m24,   m13 };
//assign mul4x4_col2_a2 = { {(6){1'b0}}, m14, 2'b00 };
//assign mul4x4_col2_a3 = { {(6){1'b0}}, m23, 2'b00 };
//assign mul4x4_col3_a1 = { {(8){1'b0}}, m42,   m31 };
//assign mul4x4_col3_a2 = { {(6){1'b0}}, m32, 2'b00 };
//assign mul4x4_col3_a3 = { {(6){1'b0}}, m41, 2'b00 };
//assign mul4x4_col4_a1 = { {(8){1'b0}}, m44,   m33 };
//assign mul4x4_col4_a2 = { {(6){1'b0}}, m34, 2'b00 };
//assign mul4x4_col4_a3 = { {(6){1'b0}}, m43, 2'b00 };
assign mul4x4_col1_a1 = {     m24,    m13,      m22,    m11     };
assign mul4x4_col1_a2 = { 2'b00,  m14, 2'b00, 2'b00, m21, 2'b00 };
assign mul4x4_col1_a3 = { 2'b00,  m23, 2'b00, 2'b00, m12, 2'b00 };
assign mul4x4_col2_a1 = {     m44,    m33,      m42,    m31     };
assign mul4x4_col2_a2 = { 2'b00,  m34, 2'b00, 2'b00, m32, 2'b00 };
assign mul4x4_col2_a3 = { 2'b00,  m43, 2'b00, 2'b00, m41, 2'b00 };

assign mul8x2_col1_a1 = { {(6){1'b0}}, 2'b00, m13,   m11 };
assign mul8x2_col1_a2 = { {(6){1'b0}},  m14 , m12, 2'b00 };
assign mul8x2_col2_a1 = { {(6){1'b0}}, 2'b00, m23,   m21 };
assign mul8x2_col2_a2 = { {(6){1'b0}},  m24 , m22, 2'b00 };
assign mul8x2_col3_a1 = { {(6){1'b0}}, 2'b00, m33,   m31 };
assign mul8x2_col3_a2 = { {(6){1'b0}},  m34 , m32, 2'b00 };
assign mul8x2_col4_a1 = { {(6){1'b0}}, 2'b00, m43,   m41 };
assign mul8x2_col4_a2 = { {(6){1'b0}},  m44 , m42, 2'b00 };

assign mul8x4_col1_a1 = { {(4){1'b0}}, 2'b00, 2'b00, m22  ,   m11 };
assign mul8x4_col1_a2 = { {(4){1'b0}}, 2'b00,  m23 , m21  , 2'b00 };
assign mul8x4_col1_a3 = { {(4){1'b0}}, 2'b00,  m14 , m12  , 2'b00 };
assign mul8x4_col1_a4 = { {(4){1'b0}},  m24 ,  m13 , 2'b00, 2'b00 };
assign mul8x4_col2_a1 = { {(4){1'b0}}, 2'b00, 2'b00, m42  ,   m31 };
assign mul8x4_col2_a2 = { {(4){1'b0}}, 2'b00,  m43 , m41  , 2'b00 };
assign mul8x4_col2_a3 = { {(4){1'b0}}, 2'b00,  m34 , m32  , 2'b00 };
assign mul8x4_col2_a4 = { {(4){1'b0}},  m44 ,  m33 , 2'b00, 2'b00 };

assign mul8x8_a1 = { 2'b00, 2'b00,      m24    ,  m22 ,  m11 };
assign mul8x8_a2 = { 2'b00, 2'b00, 2'b00,  m23 ,  m21 , 2'b00 };
assign mul8x8_a3 = { 2'b00, 2'b00, 2'b00,  m14 ,  m12 , 2'b00 };
assign mul8x8_a4 = { 2'b00, 2'b00,  m42 ,  m13 , 2'b00, 2'b00 };
assign mul8x8_a5 = {     m44     ,  m33 ,  m31 , 2'b00, 2'b00 };
assign mul8x8_a6 = { 2'b00,  m34 ,  m32 , 2'b00, 2'b00, 2'b00 };
assign mul8x8_a7 = { 2'b00,  m43 ,  m41 , 2'b00, 2'b00, 2'b00 };


assign mul8x8_a1 = { 2'b00, 2'b00,      m24    ,  m22 ,  m11 };
assign mul8x8_a2 = { 2'b00, 2'b00, 2'b00,  m23 ,  m21 , 2'b00 };
assign mul8x8_a3 = { 2'b00, 2'b00, 2'b00,  m14 ,  m12 , 2'b00 };
assign mul8x8_a4 = { 2'b00, 2'b00,  m42 ,  m13 , 2'b00, 2'b00 };
assign mul8x8_a5 = {     m44     ,  m33 ,  m31 , 2'b00, 2'b00 };
assign mul8x8_a6 = { 2'b00,  m34 ,  m32 , 2'b00, 2'b00, 2'b00 };
assign mul8x8_a7 = { 2'b00,  m43 ,  m41 , 2'b00, 2'b00, 2'b00 };

////
COnv M+Sign to 2's complement !!! BY position
////

assign addL_1 = (convtype == M8x8) ? mul8x8_a1      :
                (convtype == M8x4) ? mul8x4_col1_a1 :
                (convtype == M8x2) ? mul8x2_col1_a1 :
                (convtype == M4x4) ? mul4x4_col1_a1 :
                (convtype == M4x2) ? mul4x2_col1_a1 :
                                             ZERO16 ;

assign addL_2 = (convtype == M8x8) ? mul8x8_a2      :
                (convtype == M8x4) ? mul8x4_col1_a2 :
                (convtype == M8x2) ? mul8x2_col1_a2 :
                (convtype == M4x4) ? mul4x4_col1_a2 :
                (convtype == M4x2) ? mul4x2_col1_a2 :
                                             ZERO16 ;

assign addL_3 = (convtype == M8x8) ? mul8x8_a3      :
                (convtype == M8x4) ? mul8x4_col1_a3 :
                (convtype == M8x2) ? mul8x2_col2_a1 :
                (convtype == M4x4) ? mul4x4_col1_a3 :
                (convtype == M4x2) ? mul4x2_col2_a1 :
                                             ZERO16 ;
 
assign addL_4 = (convtype == M8x8) ? mul8x8_a4      :
                (convtype == M8x4) ? mul8x4_col1_a4 :
                (convtype == M8x2) ? mul8x2_col2_a2 :
                (convtype == M4x4) ? ZERO16         :
                (convtype == M4x2) ? mul4x2_col2_a2 :
                                             ZERO16 ;

assign addL_5 = (convtype == M8x8) ? mul8x8_a5      :
                                             ZERO16 ;
                
assign addL_6 = (convtype == M8x8) ? mul8x8_a6      :
                                             ZERO16 ;
                
assign addL_7 = (convtype == M8x8) ? mul8x8_a7      :
                                             ZERO16 ;
                


assign addM_1 = (convtype == M8x4) ? mul8x4_col2_a1 :
                (convtype == M8x2) ? mul8x2_col3_a1 :
                (convtype == M4x4) ? mul4x4_col2_a1 :
                (convtype == M4x2) ? mul4x2_col3_a1 :
                                             ZERO16 ;

assign addM_2 = (convtype == M8x4) ? mul8x4_col2_a2 :
                (convtype == M8x2) ? mul8x2_col3_a2 :
                (convtype == M4x4) ? mul4x4_col2_a2 :
                (convtype == M4x2) ? mul4x2_col3_a2 :
                                             ZERO16 ;

assign addM_3 = (convtype == M8x4) ? mul8x4_col2_a3 :
                (convtype == M8x2) ? mul8x2_col4_a1 :
                (convtype == M4x4) ? mul4x4_col2_a3 :
                (convtype == M4x2) ? mul4x2_col4_a1 :
                                             ZERO16 ;
 
assign addM_4 = (convtype == M8x4) ? mul8x4_col2_a4 :
                (convtype == M8x2) ? mul8x2_col4_a2 :
                (convtype == M4x4) ? ZERO16         :
                (convtype == M4x2) ? mul4x2_col4_a2 :
                                             ZERO16 ;


carry_save_adder #(
  .N(7),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(16)   //    input data width
)
CSA_LSB
(
  .a   (addL_1, addL_2, addL_3, addL_4, addL_5, addL_6, addL_7   ), 
  .sum (addLsum ), 
  .cout(addLcout)
);

carry_save_adder #(
  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(16)   //    input data width
)
CSA_MSB
(
  .a   (addM_1, addM_2, addM_3, addM_4  ), 
  .sum (addMsum ), 
  .cout(addMcout)
);

carry_lookahead_adder #(
            .W (7+2)      
         )   cla (
            .i_add1  ( addLsum  ), 
            .i_add2  ( addLcout ), 
            .c_in    ( 1'b0     ) ,
            .o_result( addL_res ) );

carry_lookahead_adder #(
            .W (7+2)      
         )   cla (
            .i_add1  ( addMsum  ), 
            .i_add2  ( addMcout ), 
            .c_in    ( 1'b0     ) ,
            .o_result( addM_res ) );
endmodule
