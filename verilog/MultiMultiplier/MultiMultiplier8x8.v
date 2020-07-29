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
    output reg  [16+2   :0] addL_res_o, 
    output reg  [12+2   :0] addM_res_o,
    output wire [8-1:0] mul    
);
localparam [15:0] ZERO16 = 16'h0000;
localparam [11:0] ZERO12 = 12'h000;
localparam [2:0] M8x8 = 3'b000;
//localparam [2:0] M8x4 = 3'b001;
localparam [2:0] M8x2 = 3'b010;	
localparam [2:0] M4x4 = 3'b011;
//localparam [2:0] M4x2 = 3'b100;
localparam [2:0] M2x2 = 3'b101;
localparam [1:0] CONV_2  = 2'b01;
localparam [1:0] CONV_4  = 2'b10;
localparam [1:0] CONV_8  = 2'b11;

wire [  3:0] ds; //sign of data;
wire [  3:0] Ws1, Ws2, Ws3, Ws4, WsW1, WsW2, WsW3, WsW4  ; // sign of b
wire [8-1:0] Wm1, Wm2, Wm3, Wm4, WmW1, WmW2, WmW3, WmW4  ; // magnitude of b
wire [  4:0] m11, m12, m13, m14, m21, m22, m23, m24; // unsigned result of multiplication
wire [  4:0] m31, m32, m33, m34, m41, m42, m43, m44; // unsigned result of multiplication
//wire [  3:0] m11n, m12n, m13n, m14n, m21n, m22n, m23n, m24n; // negated result of multiplication
//wire [  3:0] m31n, m32n, m33n, m34n, m41n, m42n, m43n, m44n; // negated result of multiplication
wire [ 15:0] mul2x2_L_a1, mul2x2_L_a2, mul2x2_L_a3, mul2x2_L_a4, mul2x2_L_a5, mul2x2_L_a6, mul2x2_L_a7, mul2x2_L_a8;
wire [ 11:0] mul2x2_M_a1, mul2x2_M_a2, mul2x2_M_a3, mul2x2_M_a4, mul2x2_M_a5, mul2x2_M_a6, mul2x2_M_a7, mul2x2_M_a8;
wire [ 15:0] mul4x2_L_a1, mul4x2_L_a2, mul4x2_L_a3, mul4x2_L_a4, mul4x2_L_a5, mul4x2_L_a6, mul4x2_L_a7, mul4x2_L_a8;
wire [ 11:0] mul4x2_M_a1, mul4x2_M_a2, mul4x2_M_a3, mul4x2_M_a4, mul4x2_M_a5, mul4x2_M_a6, mul4x2_M_a7, mul4x2_M_a8;
wire [ 15:0] mul4x4_L_a1, mul4x4_L_a2, mul4x4_L_a3, mul4x4_L_a4, mul4x4_L_a5, mul4x4_L_a6;
wire [ 11:0] mul4x4_M_a1, mul4x4_M_a2, mul4x4_M_a3, mul4x4_M_a4, mul4x4_M_a5, mul4x4_M_a6;
wire [ 15:0] mul8x2_a1, mul8x2_a2, mul8x2_a3, mul8x2_a4, mul8x2_a5, mul8x2_a6, mul8x2_a7, mul8x2_a8;
wire [ 15:0] mul8x4_a1, mul8x4_a2, mul8x4_a3, mul8x4_a4, mul8x4_a5, mul8x4_a6, mul8x4_a7, mul8x4_a8;
wire [ 15:0] mul8x8_a1, mul8x8_a2, mul8x8_a3, mul8x8_a4, mul8x8_a5, mul8x8_a6, mul8x8_a7, mul8x8_a8;

wire [ 15:0] addL_1pos, addL_2pos, addL_3pos, addL_4pos, addL_5pos, addL_6pos, addL_7pos, addL_8pos;
wire [ 11:0] addM_1pos, addM_2pos, addM_3pos, addM_4pos, addM_5pos, addM_6pos, addM_7pos, addM_8pos;
wire [ 15:0] addL_1, addL_2, addL_3, addL_4, addL_5, addL_6, addL_7, addL_8;
wire [ 11:0] addM_1, addM_2, addM_3, addM_4, addM_5, addM_6, addM_7, addM_8;

wire [  2:0] convtype;
wire [16+3-1 :0] addLsum;
wire [16+3-1 :0] addLcout;
wire [12+3-1 :0] addMsum ;
wire [12+3-1 :0] addMcout;
wire [16+3   :0] addL_res;
wire [12+3   :0] addM_res;

assign convtype = (convtypeD == CONV_8 && convtypeW == CONV_8) ? M8x8 :
                  //(convtypeD == CONV_8 && convtypeW == CONV_4) ? M8x4 :
                  (convtypeD == CONV_8 && convtypeW == CONV_2) ? M8x2 :
                  (convtypeD == CONV_4 && convtypeW == CONV_4) ? M4x4 :
                  //(convtypeD == CONV_4 && convtypeW == CONV_2) ? M4x2 :
                                                                 M2x2 ;

//Signed2SMagnitude s2sm1 (w1, convtypeW, Ws1, Wm1);
//Signed2SMagnitude s2sm2 (w2, convtypeW, Ws2, Wm2);
//Signed2SMagnitude s2sm3 (w3, convtypeW, Ws3, Wm3);
//Signed2SMagnitude s2sm4 (w4, convtypeW, Ws4, Wm4);

// weight's magnitude for each 2x2 multiplier
assign WmW1 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm1 :  Wm1 ; // CONV_2
assign WmW2 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm1 :  Wm2 ; // CONV_2
assign WmW3 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm2 :  Wm3 ; // CONV_2
assign WmW4 = (convtypeD == CONV_8) ? Wm1 : (convtypeD == CONV_4) ? Wm2 :  Wm4 ; // CONV_2
//
//// weight's sign for each 2x2 multiplier
assign WsW1 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws1 :  Ws1 ; // CONV_2  // Check it!!!
assign WsW2 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws1 :  Ws2 ; // CONV_2  // Check it!!!
assign WsW3 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws2 :  Ws3 ; // CONV_2  // Check it!!!
assign WsW4 = (convtypeD == CONV_8) ? Ws1 : (convtypeD == CONV_4) ? Ws2 :  Ws4 ; // CONV_2  // Check it!!!

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

//assign m11n = ~m11; assign m12n = ~m12; assign m13n = ~m13; assign m14n = ~m14; 
//assign m21n = ~m21; assign m22n = ~m22; assign m23n = ~m23; assign m24n = ~m24; 
//assign m31n = ~m31; assign m32n = ~m32; assign m33n = ~m33; assign m34n = ~m34; 
//assign m41n = ~m41; assign m42n = ~m42; assign m43n = ~m43; assign m44n = ~m44; 

// Inputs to the two adders:
// adderMSB 12 bits and LSB 16 bits

//assign mul2x2_L_a1 = (Ws2[0] == 1'b0 && Ws1[0] == 1'b0) ? {4'h0, 2'b00,   m21, 2'b00,   m11} : (Ws2[0] == 1'b1 && Ws1[0] == 1'b0) ? {4'hF, 2'b11,  m21n, 2'b00,   m11} : (Ws2[0] == 1'b0 && Ws1[0] == 1'b1) ? {4'h0, 2'b00,   m21, 2'b11,  m11n} : {4'hf, 2'b11,  m21n, 2'b11,  m11n} ;
//assign mul2x2_L_a2 = (Ws2[1] == 1'b0 && Ws1[1] == 1'b0) ? {4'h0, 2'b00,   m22, 2'b00,   m12} : (Ws2[1] == 1'b1 && Ws1[1] == 1'b0) ? {4'hF, 2'b11,  m22n, 2'b00,   m12} : (Ws2[1] == 1'b0 && Ws1[1] == 1'b1) ? {4'h0, 2'b00,   m22, 2'b11,  m12n} : {4'hf, 2'b11,  m22n, 2'b11,  m12n} ;
//assign mul2x2_L_a3 = (Ws2[2] == 1'b0 && Ws1[2] == 1'b0) ? {4'h0, 2'b00,   m23, 2'b00,   m13} : (Ws2[2] == 1'b1 && Ws1[2] == 1'b0) ? {4'hF, 2'b11,  m23n, 2'b00,   m13} : (Ws2[2] == 1'b0 && Ws1[2] == 1'b1) ? {4'h0, 2'b00,   m23, 2'b11,  m13n} : {4'hf, 2'b11,  m23n, 2'b11,  m13n} ;
//assign mul2x2_L_a4 = (Ws2[3] == 1'b0 && Ws1[3] == 1'b0) ? {4'h0, 2'b00,   m24, 2'b00,   m14} : (Ws2[3] == 1'b1 && Ws1[3] == 1'b0) ? {4'hF, 2'b11,  m24n, 2'b00,   m14} : (Ws2[3] == 1'b0 && Ws1[3] == 1'b1) ? {4'h0, 2'b00,   m24, 2'b11,  m14n} : {4'hf, 2'b11,  m24n, 2'b11,  m14n} ;
//assign mul2x2_L_a5 = (Ws2[0] == 1'b0 && Ws1[0] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00} : (Ws2[0] == 1'b1 && Ws1[0] == 1'b0) ? {4'hF, 2'b11, 2'b11, 2'b00, 2'b00} : (Ws2[0] == 1'b0 && Ws1[0] == 1'b1) ? {4'h0, 2'b00, 2'b00, 2'b11, 2'b11} : {4'hf, 2'b11, 2'b11, 2'b11, 2'b11} ;
//assign mul2x2_L_a6 = (Ws2[1] == 1'b0 && Ws1[1] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00} : (Ws2[1] == 1'b1 && Ws1[1] == 1'b0) ? {4'hF, 2'b11, 2'b11, 2'b00, 2'b00} : (Ws2[1] == 1'b0 && Ws1[1] == 1'b1) ? {4'h0, 2'b00, 2'b00, 2'b11, 2'b11} : {4'hf, 2'b11, 2'b11, 2'b11, 2'b11} ;
//assign mul2x2_L_a7 = (Ws2[2] == 1'b0 && Ws1[2] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00} : (Ws2[2] == 1'b1 && Ws1[2] == 1'b0) ? {4'hF, 2'b11, 2'b11, 2'b00, 2'b00} : (Ws2[2] == 1'b0 && Ws1[2] == 1'b1) ? {4'h0, 2'b00, 2'b00, 2'b11, 2'b11} : {4'hf, 2'b11, 2'b11, 2'b11, 2'b11} ;
//assign mul2x2_L_a8 = (Ws2[3] == 1'b0 && Ws1[3] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00} : (Ws2[3] == 1'b1 && Ws1[3] == 1'b0) ? {4'hF, 2'b11, 2'b11, 2'b00, 2'b00} : (Ws2[3] == 1'b0 && Ws1[3] == 1'b1) ? {4'h0, 2'b00, 2'b00, 2'b11, 2'b11} : {4'hf, 2'b11, 2'b11, 2'b11, 2'b11} ;

//assign mul2x2_M_a1 = (Ws4[0] == 1'b0 && Ws3[0] == 1'b0) ? {      2'b00,   m41, 2'b00,   m31} : (Ws4[0] == 1'b1 && Ws3[0] == 1'b0) ? {      2'b11,  m41n, 2'b00,   m31} : (Ws4[0] == 1'b0 && Ws3[0] == 1'b1) ? {      2'b00,   m41, 2'b11,  m31n} : {      2'b11,  m41n, 2'b11,  m31n} ;
//assign mul2x2_M_a2 = (Ws4[1] == 1'b0 && Ws3[1] == 1'b0) ? {      2'b00,   m42, 2'b00,   m32} : (Ws4[1] == 1'b1 && Ws3[1] == 1'b0) ? {      2'b11,  m42n, 2'b00,   m32} : (Ws4[1] == 1'b0 && Ws3[1] == 1'b1) ? {      2'b00,   m42, 2'b11,  m32n} : {      2'b11,  m42n, 2'b11,  m32n} ;
//assign mul2x2_M_a3 = (Ws4[2] == 1'b0 && Ws3[2] == 1'b0) ? {      2'b00,   m43, 2'b00,   m33} : (Ws4[2] == 1'b1 && Ws3[2] == 1'b0) ? {      2'b11,  m43n, 2'b00,   m33} : (Ws4[2] == 1'b0 && Ws3[2] == 1'b1) ? {      2'b00,   m43, 2'b11,  m33n} : {      2'b11,  m43n, 2'b11,  m33n} ;
//assign mul2x2_M_a4 = (Ws4[3] == 1'b0 && Ws3[3] == 1'b0) ? {      2'b00,   m44, 2'b00,   m34} : (Ws4[3] == 1'b1 && Ws3[3] == 1'b0) ? {      2'b11,  m44n, 2'b00,   m34} : (Ws4[3] == 1'b0 && Ws3[3] == 1'b1) ? {      2'b00,   m44, 2'b11,  m34n} : {      2'b11,  m44n, 2'b11,  m34n} ;
//assign mul2x2_M_a5 = (Ws4[0] == 1'b0 && Ws3[0] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00} : (Ws4[0] == 1'b1 && Ws3[0] == 1'b0) ? {      2'b11, 2'b11, 2'b00, 2'b00} : (Ws4[0] == 1'b0 && Ws3[0] == 1'b1) ? {      2'b00, 2'b00, 2'b11, 2'b11} : {      2'b11, 2'b11, 2'b11, 2'b11} ;
//assign mul2x2_M_a6 = (Ws4[1] == 1'b0 && Ws3[1] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00} : (Ws4[1] == 1'b1 && Ws3[1] == 1'b0) ? {      2'b11, 2'b11, 2'b00, 2'b00} : (Ws4[1] == 1'b0 && Ws3[1] == 1'b1) ? {      2'b00, 2'b00, 2'b11, 2'b11} : {      2'b11, 2'b11, 2'b11, 2'b11} ;
//assign mul2x2_M_a7 = (Ws4[2] == 1'b0 && Ws3[2] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00} : (Ws4[2] == 1'b1 && Ws3[2] == 1'b0) ? {      2'b11, 2'b11, 2'b00, 2'b00} : (Ws4[2] == 1'b0 && Ws3[2] == 1'b1) ? {      2'b00, 2'b00, 2'b11, 2'b11} : {      2'b11, 2'b11, 2'b11, 2'b11} ;
//assign mul2x2_M_a8 = (Ws4[3] == 1'b0 && Ws3[3] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00} : (Ws4[3] == 1'b1 && Ws3[3] == 1'b0) ? {      2'b11, 2'b11, 2'b00, 2'b00} : (Ws4[3] == 1'b0 && Ws3[3] == 1'b1) ? {      2'b00, 2'b00, 2'b11, 2'b11} : {      2'b11, 2'b11, 2'b11, 2'b11} ;

assign mul2x2_L_a1 =  {4'h0, m21[4],   m21, m11[4],   m11};
assign mul2x2_L_a2 =  {4'h0, m22[4],   m22, m12[4],   m12};
assign mul2x2_L_a3 =  {4'h0, m23[4],   m23, m13[4],   m13};
assign mul2x2_L_a4 =  {4'h0, m24[4],   m24, m14[4],   m14};
assign mul2x2_L_a5 =  {4'h0,  2'b00, 2'b00,  2'b00, 2'b00};
assign mul2x2_L_a6 =  {4'h0,  2'b00, 2'b00,  2'b00, 2'b00};
assign mul2x2_L_a7 =  {4'h0,  2'b00, 2'b00,  2'b00, 2'b00};
assign mul2x2_L_a8 =  {4'h0,  2'b00, 2'b00,  2'b00, 2'b00};

assign mul2x2_M_a1 =  {      m41[4],   m41, m31[4],   m31};
assign mul2x2_M_a2 =  {      m42[4],   m42, m32[4],   m32};
assign mul2x2_M_a3 =  {      m43[4],   m43, m33[4],   m33};
assign mul2x2_M_a4 =  {      m44[4],   m44, m34[4],   m34};
assign mul2x2_M_a5 =  {       2'b00, 2'b00,  2'b00, 2'b00};
assign mul2x2_M_a6 =  {       2'b00, 2'b00,  2'b00, 2'b00};
assign mul2x2_M_a7 =  {       2'b00, 2'b00,  2'b00, 2'b00};
assign mul2x2_M_a8 =  {       2'b00, 2'b00,  2'b00, 2'b00};
          
//assign mul4x2_L_a1 = (Ws1[0] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00,   m11} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11, 2'b11,  ~m11};
//assign mul4x2_L_a2 = (Ws1[1] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00,   m12} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11, 2'b11,  ~m12};
//assign mul4x2_L_a3 = (Ws1[2] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00,   m13} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11, 2'b11,  ~m13};
//assign mul4x2_L_a4 = (Ws1[3] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00, 2'b00,   m14} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11, 2'b11,  ~m14};
//assign mul4x2_L_a5 = (Ws1[0] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,   m21, 2'b00} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11,  ~m21, 2'b01}; // +1 in conv to 2's compl
//assign mul4x2_L_a6 = (Ws1[1] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,   m22, 2'b00} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11,  ~m22, 2'b01}; // +1 in conv to 2's compl
//assign mul4x2_L_a7 = (Ws1[2] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,   m23, 2'b00} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11,  ~m23, 2'b01}; // +1 in conv to 2's compl
//assign mul4x2_L_a8 = (Ws1[3] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,   m24, 2'b00} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11,  ~m24, 2'b01}; // +1 in conv to 2's compl
//
//assign mul4x2_M_a1 = (Ws2[0] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00,   m31} : 
//                                        {      2'b11, 2'b11, 2'b11, 2'b11,  ~m31};
//assign mul4x2_M_a2 = (Ws2[1] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00,   m32} : 
//                                        {      2'b11, 2'b11, 2'b11, 2'b11,  ~m32};
//assign mul4x2_M_a3 = (Ws2[2] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00,   m33} : 
//                                        {      2'b11, 2'b11, 2'b11, 2'b11,  ~m33};
//assign mul4x2_M_a4 = (Ws2[3] == 1'b0) ? {      2'b00, 2'b00, 2'b00, 2'b00,   m34} : 
//                                        {      2'b11, 2'b11, 2'b11, 2'b11,  ~m34};
//assign mul4x2_M_a5 = (Ws2[0] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m41, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  ~m41, 2'b01}; // +1 in conv to 2's compl
//assign mul4x2_M_a6 = (Ws2[1] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m42, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  ~m42, 2'b01}; // +1 in conv to 2's compl
//assign mul4x2_M_a7 = (Ws2[2] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m43, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  ~m43, 2'b01}; // +1 in conv to 2's compl
//assign mul4x2_M_a8 = (Ws2[3] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m44, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  ~m44, 2'b01}; // +1 in conv to 2's compl

//assign mul4x4_L_a1 = (Ws1[1] == 1'b0) ? {4'h0, 2'b00, 2'b00,     m22,    m11    } : 
//                                        {4'hF, 2'b11, 2'b11,    m22n,   m11n    };
//assign mul4x4_L_a2 = (Ws1[1] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,  m21, 2'b00 } : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11, m21n, 2'b00 };
//assign mul4x4_L_a3 = (Ws1[1] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,  m12, 2'b00 } : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11, m12n, 2'b00 };
//assign mul4x4_L_a4 = (Ws1[3] == 1'b0) ? {4'h0, 2'b00, 2'b00,     m24,    m13    } : 
//                                        {4'hF, 2'b11, 2'b11,    m24n,   m13n    };
//assign mul4x4_L_a5 = (Ws1[3] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,   m14, 2'b00} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11,  m14n, 2'b00};
//assign mul4x4_L_a6 = (Ws1[3] == 1'b0) ? {4'h0, 2'b00, 2'b00, 2'b00,   m23, 2'b00} : 
//                                        {4'hF, 2'b11, 2'b11, 2'b11,  m23n, 2'b01};  // +1 in conv to 2's compl
//assign mul4x4_M_a1 = (Ws2[1] == 1'b0) ? {      2'b00, 2'b00,     m42,    m31    } : 
//                                        {      2'b11, 2'b11,    m42n,   m31n    };
//assign mul4x4_M_a2 = (Ws2[1] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m41, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  m41n, 2'b00};
//assign mul4x4_M_a3 = (Ws2[1] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m32, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  m32n, 2'b00};
//assign mul4x4_M_a4 = (Ws2[3] == 1'b0) ? {      2'b00, 2'b00,     m44,    m33    } : 
//                                        {      2'b11, 2'b11,    m44n,   m33n    };
//assign mul4x4_M_a5 = (Ws2[3] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m43, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  m43n, 2'b00};
//assign mul4x4_M_a6 = (Ws2[3] == 1'b0) ? {      2'b00, 2'b00, 2'b00,   m43, 2'b00} : 
//                                        {      2'b11, 2'b11, 2'b11,  m43n, 2'b01};// +1 in conv to 2's compl

assign mul4x4_L_a1 = { {(11){m11[4]}},  m11          } ;
assign mul4x4_L_a2 = { {( 9){m21[4]}},  m21, 2'b00   } ;
assign mul4x4_L_a3 = { {( 9){m12[4]}},  m12, 2'b00   } ;
assign mul4x4_L_a4 = { {( 7){m22[4]}},  m22, 4'b0000 } ;
assign mul4x4_L_a5 = { {(11){m13[4]}},  m13          } ;
assign mul4x4_L_a6 = { {( 9){m14[4]}},  m14, 2'b00   } ;  
assign mul4x4_L_a7 = { {( 9){m23[4]}},  m23, 2'b00   } ;
assign mul4x4_L_a8 = { {( 7){m24[4]}},  m24, 4'b0000 } ;

assign mul4x4_M_a1 = { {(7){m31[4]}}, m31          } ;
assign mul4x4_M_a2 = { {(5){m41[4]}}, m41, 2'b00   } ;
assign mul4x4_M_a3 = { {(5){m32[4]}}, m32, 2'b00   } ;
assign mul4x4_M_a4 = { {(3){m42[4]}}, m42, 4'b0000 } ;
assign mul4x4_M_a5 = { {(7){m33[4]}}, m33          } ;
assign mul4x4_M_a6 = { {(5){m43[4]}}, m43, 2'b00   } ;
assign mul4x4_M_a7 = { {(5){m34[4]}}, m34, 2'b00   } ;
assign mul4x4_M_a8 = { {(3){m44[4]}}, m44, 4'b0000 } ;

//assign mul8x2_a1 = (Ws1[0] == 1'b0) ? { {(6){1'b0}}, 2'b00,  m13,   m11    } : 
//                                      { {(6){1'b1}}, 2'b11, m13n,  m11n    } ;
//assign mul8x2_a2 = (Ws1[0] == 1'b0) ? { {(6){1'b0}},     m14,  m12, 2'b00  } : 
//                                      { {(6){1'b1}},    m14n, m12n, 2'b01  } ;// +1 in conv to 2's compl
//assign mul8x2_a3 = (Ws1[1] == 1'b0) ? { {(6){1'b0}}, 2'b00,  m23,   m21    } : 
//                                      { {(6){1'b1}}, 2'b11, m23n,  m21n    } ;
//assign mul8x2_a4 = (Ws1[1] == 1'b0) ? { {(6){1'b0}},      m24 ,  m22, 2'b00} : 
//                                      { {(6){1'b1}},     m24n , m22n, 2'b01} ;// +1 in conv to 2's compl
//assign mul8x2_a5 = (Ws1[2] == 1'b0) ? { {(6){1'b0}}, 2'b00,  m33,   m31    } : 
//                                      { {(6){1'b1}}, 2'b11, m33n,  m31n    } ;
//assign mul8x2_a6 = (Ws1[2] == 1'b0) ? { {(6){1'b0}},     m34 ,  m32, 2'b00 } : 
//                                      { {(6){1'b1}},    m34n , m32n, 2'b01 } ;// +1 in conv to 2's compl
//assign mul8x2_a7 = (Ws1[3] == 1'b0) ? { {(6){1'b0}}, 2'b00,  m43,   m41    } : 
//                                      { {(6){1'b1}}, 2'b11, m43n,  m41n    } ;
//assign mul8x2_a8 = (Ws1[3] == 1'b0) ? { {(6){1'b0}},      m44,  m42, 2'b00 } : 
//                                      { {(6){1'b1}},     m44n, m42n, 2'b01 } ;// +1 in conv to 2's compl

assign mul8x2_a1 = 0 ; //{ {(6){1'b0}}, 2'b00,  m13,   m11    } ;
assign mul8x2_a2 = 0 ; //{ {(6){1'b0}},     m14,  m12, 2'b00  } ;// +1 in conv to 2's compl
assign mul8x2_a3 = 0 ; //{ {(6){1'b0}}, 2'b00,  m23,   m21    } ;
assign mul8x2_a4 = 0 ; //{ {(6){1'b0}},      m24 ,  m22, 2'b00} ;// +1 in conv to 2's compl
assign mul8x2_a5 = 0 ; //{ {(6){1'b0}}, 2'b00,  m33,   m31    } ;
assign mul8x2_a6 = 0 ; //{ {(6){1'b0}},     m34 ,  m32, 2'b00 } ;// +1 in conv to 2's compl
assign mul8x2_a7 = 0 ; //{ {(6){1'b0}}, 2'b00,  m43,   m41    } ;
assign mul8x2_a8 = 0 ; //{ {(6){1'b0}},      m44,  m42, 2'b00 } ;// +1 in conv to 2's compl


//assign mul8x4_a1 = (Ws1[1] == 1'b0) ? { {(4){1'b0}}, 2'b00, 2'b00,  m13  ,   m11       } :
//                                      { {(4){1'b1}}, 2'b11, 2'b11, ~m13  ,  ~m11       } ;
//assign mul8x4_a2 = (Ws1[1] == 1'b0) ? { {(4){1'b0}}, 2'b00,     m14 ,  m12  ,    2'b00 } :
//                                      { {(4){1'b1}}, 2'b11,    ~m14 , ~m12  ,    2'b00 } ;
//assign mul8x4_a3 = (Ws1[1] == 1'b0) ? { {(4){1'b0}}, 2'b00,     m23 ,  m21  ,    2'b00 } :
//                                      { {(4){1'b1}}, 2'b11,    ~m23 , ~m21  ,    2'b00 } ;
//assign mul8x4_a4 = (Ws1[1] == 1'b0) ? { {(4){1'b0}},        m24 ,  m22 , 2'b00,  2'b00 } :
//                                      { {(4){1'b1}},       ~m24 , ~m22 , 2'b00,  2'b01 } ;// +1 in conv to 2's compl
//assign mul8x4_a5 = (Ws1[3] == 1'b0) ? { {(4){1'b0}}, 2'b00, 2'b00,  m33  ,   m31       } :
//                                      { {(4){1'b1}}, 2'b11, 2'b11, ~m33  ,  ~m31       } ;
//assign mul8x4_a6 = (Ws1[3] == 1'b0) ? { {(4){1'b0}}, 2'b00,     m34 , m32  ,     2'b00 } :
//                                      { {(4){1'b1}}, 2'b11,    ~m34 ,~m32  ,     2'b00 } ;
//assign mul8x4_a7 = (Ws1[3] == 1'b0) ? { {(4){1'b0}}, 2'b00,     m43 ,  m41  ,    2'b00 } :
//                                      { {(4){1'b1}}, 2'b11,    ~m43 , ~m41  ,    2'b00 } ;
//assign mul8x4_a8 = (Ws1[3] == 1'b0) ? { {(4){1'b0}},        m44 ,  m42 , 2'b00,  2'b00 } :
//                                      { {(4){1'b1}},       ~m44 , ~m42 , 2'b00,  2'b01 } ;// +1 in conv to 2's compl

assign mul8x8_a1 = mul4x4_L_a1 ;
assign mul8x8_a2 = mul4x4_L_a2 ;
assign mul8x8_a3 = mul4x4_L_a3 ;
assign mul8x8_a4 = mul4x4_L_a4 ;
assign mul8x8_a5 = { {(2) {mul4x4_L_a1[11]}} , mul4x4_M_a1, 4'b00};
assign mul8x8_a6 = { {(2) {mul4x4_M_a2[11]}} , mul4x4_M_a2, 4'b00};
assign mul8x8_a7 = {                           mul4x4_M_a2, 6'b00};
assign mul8x8_a8 = {                           mul4x4_M_a2, 6'b00};


// Inputs to MSB and LSB adders (positive values)
assign addL_1 = (convtype == M8x8) ? mul8x8_a1   :
                //(convtype == M8x4) ? mul8x4_a1   :
                (convtype == M8x2) ? mul8x2_a1   :
                (convtype == M4x4) ? mul4x4_L_a1 :
                //(convtype == M4x2) ? mul4x2_L_a1 :
                                     mul2x2_L_a1 ; // M2x2

assign addL_2 = (convtype == M8x8) ? mul8x8_a2   :
                //(convtype == M8x4) ? mul8x4_a2   :
                (convtype == M8x2) ? mul8x2_a2   :
                (convtype == M4x4) ? mul4x4_L_a2 :
                //(convtype == M4x2) ? mul4x2_L_a2 :
                                     mul2x2_L_a2 ; // M2x2

assign addL_3 = (convtype == M8x8) ? mul8x8_a3   :
                //(convtype == M8x4) ? mul8x4_a3   :
                (convtype == M8x2) ? mul8x2_a3   :
                (convtype == M4x4) ? mul4x4_L_a3 :
                //(convtype == M4x2) ? mul4x2_L_a3 :
                                     mul2x2_L_a3 ; // M2x2
 
assign addL_4 = (convtype == M8x8) ? mul8x8_a4   :
                //(convtype == M8x4) ? mul8x4_a4   :
                (convtype == M8x2) ? mul8x2_a4   :
                (convtype == M4x4) ? mul4x4_L_a4 :
                //(convtype == M4x2) ? mul4x2_L_a4 :
                                     mul2x2_L_a4 ; // M2x2

assign addL_5 = (convtype == M8x8) ? mul8x8_a5   :
                //(convtype == M8x4) ? mul8x4_a5   :
                (convtype == M8x2) ? mul8x2_a5   :
                (convtype == M4x4) ? mul4x4_L_a5 :
                //(convtype == M4x2) ? mul4x2_L_a5 :
                                     mul2x2_L_a5 ; // M2x2
                
assign addL_6 = (convtype == M8x8) ? mul8x8_a6   :
                //(convtype == M8x4) ? mul8x4_a6   :
                (convtype == M8x2) ? mul8x2_a6   :
                (convtype == M4x4) ? mul4x4_L_a6 :
                //(convtype == M4x2) ? mul4x2_L_a6 :
                                     mul2x2_L_a6 ; // M2x2
                
assign addL_7 = (convtype == M8x8) ? mul8x8_a7   :
                //(convtype == M8x4) ? mul8x4_a7   :
                (convtype == M8x2) ? mul8x2_a7   :
                //(convtype == M4x2) ? mul4x2_L_a7 :
                                     mul2x2_L_a7 ; // M2x2

assign addL_8 = (convtype == M8x8) ? mul8x8_a8   :
                //(convtype == M8x4) ? mul8x4_a8   :
                (convtype == M8x2) ? mul8x2_a8   :
                //(convtype == M4x2) ? mul4x2_L_a8 :
                                     mul2x2_L_a8 ; // M2x2
                
/// MSB inputs

assign addM_1 = (convtype == M4x4) ? mul4x4_M_a1 :
                //(convtype == M4x2) ? mul4x2_M_a1 :
                (convtype == M2x2) ? mul2x2_M_a1 :
                                          ZERO12 ; // 8x8, 8x4, 8x2

assign addM_2 = (convtype == M4x4) ? mul4x4_M_a2 :
                //(convtype == M4x2) ? mul4x2_M_a2 :
                (convtype == M2x2) ? mul2x2_M_a2 :
                                          ZERO12 ; // 8x8, 8x4, 8x2

assign addM_3 = (convtype == M4x4) ? mul4x4_M_a3 :
                //(convtype == M4x2) ? mul4x2_M_a3 :
                (convtype == M2x2) ? mul2x2_M_a3 :
                                          ZERO12 ; // 8x8, 8x4, 8x2
 
assign addM_4 = (convtype == M4x4) ? mul4x4_M_a4 :
                //(convtype == M4x2) ? mul4x2_M_a4 :
                (convtype == M2x2) ? mul2x2_M_a4 :
                                          ZERO12 ; // 8x8, 8x4, 8x2

assign addM_5 = (convtype == M4x4) ? mul4x4_M_a5 :
                //(convtype == M4x2) ? mul4x2_M_a5 :
                (convtype == M2x2) ? mul2x2_M_a5 :
                                          ZERO12 ; // 8x8, 8x4, 8x2
                
assign addM_6 = (convtype == M4x4) ? mul4x4_M_a6 :
                //(convtype == M4x2) ? mul4x2_M_a6 :
                (convtype == M2x2) ? mul2x2_M_a6 :
                                          ZERO12 ;
                
assign addM_7 = //(convtype == M4x2) ? mul4x2_M_a7 :
                (convtype == M2x2) ? mul2x2_M_a7 :
                                          ZERO12 ;

assign addM_8 = //(convtype == M4x2) ? mul4x2_M_a8 :
                (convtype == M2x2) ? mul2x2_M_a8 :
                                          ZERO12 ;

////

carry_save_adder #(
  .N(8),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(3),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(16)  //    input data width
)
CSA_LSB
(
  .a   ( {addL_1, addL_2, addL_3, addL_4, addL_5, addL_6, addL_7, addL_8} ), 
  .sum ( addLsum  ), 
  .cout( addLcout )
);

carry_save_adder #(
  .N(8),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(3),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(12)  //    input data width
)
CSA_MSB
(
  .a   ( {addM_1, addM_2, addM_3, addM_4, addM_5, addM_6, addM_7, addM_8} ), 
  .sum ( addMsum  ), 
  .cout( addMcout )
);

carry_lookahead_adder #(
            .W (16+3)      
         )   cla_L (
            .i_add1  ( addLsum  ), 
            .i_add2  ( addLcout ), 
            .c_in    ( 1'b0     ) ,
            .o_result( addL_res ) );

carry_lookahead_adder #(
            .W (12+3)      
         )   cla_M (
            .i_add1  ( addMsum  ), 
            .i_add2  ( addMcout ), 
            .c_in    ( 1'b0     ) ,
            .o_result( addM_res ) );

always @(posedge clk)
 begin
   addL_res_o = addL_res;
   addM_res_o = addM_res;
 end

endmodule
