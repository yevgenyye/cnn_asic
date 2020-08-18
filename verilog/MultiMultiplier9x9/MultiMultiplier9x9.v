module MultiMultiplier9x9
(    
    input wire          clk,
    input       [9-1:0] d  , // unsigned (data)
    input       [9-1:0] w1 , //   signed (weights) for configurations - 9x9 6x6 3x3
    input       [9-1:0] w2 , //   signed (weights) for configurations - 9x9 6x6 3x3
    input       [9-1:0] w3 , //   signed (weights) for configurations -     6x6 3x3
    input       [  1:0] convtype,  // 01 - 3x3, 10 - 6x3, 00 - 9x9
    output reg  [15 :0] mul 
);


localparam [1:0] M3x3 = 2'b01;
//localparam [1:0] M6x6 = 2'b11;
localparam [1:0] M9x3 = 2'b10;	
localparam [1:0] M9x9 = 2'b00;

wire [  3:0] dw; //sign of weight;

wire [9-1:0] WmW1, WmW2, WmW3 ; // magnitude of weigts
wire [  3:1] WsW1, WsW2, WsW3  ; // sign of weigts
wire [  6:0] m11, m12, m13, m21, m22, m23, m31, m32, m33; // unsigned result of multiplication

wire [ 18:0] pre_11, pre_12,  pre_13;
wire [ 18:0] pre_21, pre_22,  pre_23;
wire [ 18:0] pre_31, pre_32,  pre_33;

wire [ 18+3:0] csa_s,  csa_c;
wire [ 18+3:0] mul1;


               // 6x6, 6x3
assign WmW1 = (convtype == M3x3) ? w1 : w1 ;
assign WmW2 = (convtype == M3x3) ? w2 : w1 ;
assign WmW3 = (convtype == M3x3) ? w3 : w1 ;


////// weight's sign for each 2x2 multiplier
assign WsW1 = (convtype == M9x9) ? { WmW1[8], 1'b0 , 1'b0 } : { WmW1[8], WmW1[5], WmW1[2] } ; 
assign WsW2 = (convtype == M9x9) ? { WmW2[8], 1'b0 , 1'b0 } : { WmW2[8], WmW2[5], WmW2[2] } ; 
assign WsW3 = (convtype == M9x9) ? { WmW3[8], 1'b0 , 1'b0 } : { WmW3[8], WmW3[5], WmW3[2] } ; 
 
// Group of multipliers 

// 1-st column
Mult_3bits mu11 ( WsW1[1], WmW1[ 2: 0], d[2:0], m11);
Mult_3bits mu12 ( WsW1[2], WmW1[ 5: 3], d[2:0], m12);
Mult_3bits mu13 ( WsW1[3], WmW1[ 8: 6], d[2:0], m13);

// 2-nd column
Mult_3bits mu21 ( WsW2[1], WmW2[ 2: 0], d[5:3], m21);
Mult_3bits mu22 ( WsW2[2], WmW2[ 5: 3], d[5:3], m22);
Mult_3bits mu23 ( WsW2[3], WmW2[ 8: 6], d[5:3], m23);
// 3-nd column
Mult_3bits mu31 ( WsW3[1], WmW3[ 2: 0], d[8:6], m31);
Mult_3bits mu32 ( WsW3[2], WmW3[ 5: 3], d[8:6], m32);
Mult_3bits mu33 ( WsW3[3], WmW3[ 8: 6], d[8:6], m33);

// 9x9 9x3 3x3
//assign pre_11 =                                                                     { {(12) {m11[6]}},         m11    } ;
//assign pre_12 = (convtype == M3x3 || convtype == M9x3)                            ? { {(12) {m12[6]}},         m12    } : { {( 9) {m12[6]}},       m12, 3'b000};
//assign pre_13 = (convtype == M3x3) ? { {(12) {m13[6]}}, m13} : (convtype == M9x3) ? { {(12) {m13[6]}},         m13    } : { {( 6) {m13[6]}},    m13, 6'b000000};
//assign pre_21 = (convtype == M3x3) ? { {(12) {m21[6]}}, m21} :                      { {( 9) {m21[6]}},    m21, 3'b000 } ;
//assign pre_22 = (convtype == M3x3) ? { {(12) {m22[6]}}, m22} : (convtype == M9x3) ? { {( 9) {m22[6]}},    m22, 3'b000 } : { {( 6) {m22[6]}},    m22, 6'b000000};
//assign pre_23 = (convtype == M3x3) ? { {(12) {m23[6]}}, m23} : (convtype == M9x3) ? { {( 9) {m23[6]}},    m23, 3'b000 } : { {( 3) {m23[6]}}, m23, 9'b000000000};
//assign pre_31 = (convtype == M3x3) ? { {(12) {m31[6]}}, m31} :                      { {( 6) {m31[6]}}, m31, 6'b000000 } ;
//assign pre_32 = (convtype == M3x3) ? { {(12) {m32[6]}}, m32} : (convtype == M9x3) ? { {( 6) {m32[6]}}, m32, 6'b000000 } : { {( 3) {m32[6]}}, m32, 9'b000000000}; 
//assign pre_33 = (convtype == M3x3) ? { {(12) {m33[6]}}, m33} : (convtype == M9x3) ? { {( 6) {m33[6]}}, m33, 6'b000000 } : {              m33, 12'b000000000000};

// 9x9 3x3
assign pre_11 =                                                { {(12) {m11[6]}},           m11     };
assign pre_12 = (convtype == M3x3) ? { {(12) {m12[6]}}, m12} : { {( 9) {m12[6]}},       m12, 3'b000 };
assign pre_13 = (convtype == M3x3) ? { {(12) {m13[6]}}, m13} : { {( 6) {m13[6]}},    m13, 6'b000000 };
assign pre_21 = (convtype == M3x3) ? { {(12) {m21[6]}}, m21} : { {( 9) {m21[6]}},       m21, 3'b000 };
assign pre_22 = (convtype == M3x3) ? { {(12) {m22[6]}}, m22} : { {( 6) {m22[6]}},    m22, 6'b000000 };
assign pre_23 = (convtype == M3x3) ? { {(12) {m23[6]}}, m23} : { {( 3) {m23[6]}}, m23, 9'b000000000 };
assign pre_31 = (convtype == M3x3) ? { {(12) {m31[6]}}, m31} : { {( 6) {m31[6]}},    m31, 6'b000000 };
assign pre_32 = (convtype == M3x3) ? { {(12) {m32[6]}}, m32} : { {( 3) {m32[6]}}, m32, 9'b000000000 }; 
assign pre_33 = (convtype == M3x3) ? { {(12) {m33[6]}}, m33} : {              m33, 12'b000000000000 };


//carry_save_adder #(
//  .N(9),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
//  .E(3),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
//  .W(19)  //    input data width
//)
//csa_1
//(
//  .a   ( {pre_11, pre_12, pre_13, pre_21, pre_22, pre_23, pre_31, pre_32, pre_33 } ), 
//  .sum ( csa_s ), 
//  .cout( csa_c )
//);

//assign mul1 = csa_s + csa_c;

assign mul1[15:0] = pre_11[15:0] + 
                    pre_12[15:0] + 
                    pre_13[15:0] + 
                    pre_21[15:0] + 
                    pre_22[15:0] + 
                    pre_23[15:0] + 
                    pre_31[15:0] + 
                    pre_32[15:0] + 
                    pre_33[15:0] ;

always @(posedge clk)
 begin
   mul = mul1[15 :0];
 end

endmodule
