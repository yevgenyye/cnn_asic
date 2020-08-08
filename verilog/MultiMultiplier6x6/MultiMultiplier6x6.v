module MultiMultiplier6x6
(    
    input wire          clk,
    input       [6-1:0] d  , // unsigned (data)
    input       [6-1:0] w1 , //   signed (weights) for configurations - 6x6, 6x3, 3x3
    input       [6-1:0] w2 , //   signed (weights) for configurations -           3x3
    input       [  1:0] convtype,  // 01 - 3x3, 10 - 6x3, 11 - 6x6
    output reg  [13 :0] mul //, 
 //   output reg  [ 8    :0] mul2 
);


localparam [1:0] M3x3 = 2'b01;
localparam [1:0] M6x3 = 2'b10;
localparam [1:0] M6x6 = 2'b11;	

wire [  3:0] dw; //sign of weight;

wire [6-1:0] Wm1, Wm2, WmW1, WmW2 ; // magnitude of weigts
wire [  1:0] Ws1, Ws2, WsW1, WsW2  ; // sign of weigts
wire [  6:0] m11, m12, m21, m22; // unsigned result of multiplication

wire [ 12:0] pre_1_1, pre_1_2,  pre_2_1, pre_2_2;

wire [ 14:0] csa_s,  csa_c;
wire [ 15:0] mul1;


               // 6x6, 6x3
assign WmW1 = (convtype[1] == 1'b1) ? w1 : w1  ;
assign WmW2 = (convtype[1] == 1'b1) ? w1 : w2  ;

////// weight's sign for each 2x2 multiplier
assign WsW1 = (convtype == M6x6) ? { WmW1[5], 1'b0  } : { WmW1[5], WmW1[2]} ; // CONV_2  
assign WsW2 = (convtype == M6x6) ? { WmW2[5], 1'b0  } : { WmW2[5], WmW2[2]} ; // CONV_2  

// Group of multipliers 

// 1-st column
Mult_3bits mu11 ( WsW1[0], WmW1[2:0], d[2:0], m11);
Mult_3bits mu12 ( WsW1[1], WmW1[5:3], d[2:0], m12);
// 2-nd column
Mult_3bits mu21 ( WsW2[0], WmW2[2:0], d[5:3], m21);
Mult_3bits mu22 ( WsW2[1], WmW2[5:3], d[5:3], m22);

///////////////////////////// Config: 2x2 + 4x2 + 4x4

// Stage 1. Prepare basic patterns for 2x2, 4x2 and 4x4 multiplication

assign pre_1_1 =                                          { {(6) {m11[6]}}, m11} ;
assign pre_1_2 = (convtype == M3x3 || convtype == M6x3) ? { {(6) {m12[6]}}, m12} :                     { {(3) {m12[6]}}, m12, 3'b000} ;
assign pre_2_1 = (convtype == M3x3)                     ? { {(6) {m21[6]}}, m21} :                     { {(3) {m21[6]}}, m21, 3'b000} ;
assign pre_2_2 = (convtype == M3x3)                     ? { {(6) {m22[6]}}, m22} :(convtype == M6x3) ? { {(3) {m22[6]}}, m22, 3'b000} : {m22 ,6'b000000};

carry_save_adder #(
  .N(4),  // 2; // 3; // 4; // 5; // 6; // 7; // 8; 9 ... 15; // 16 17 25; // 49; //64; //128; //256;  3+ number of busses 
  .E(2),  // 0; // 1; // 2; // 2; // 2; // 2; // 3; 3 ...  3; // 4; 4  4;  // 6 ; // 6; //  7; //  8; bit extention ( N=9 -> E=3, N=25 -> E=4)
  .W(13)  //    input data width
)
csa_1
(
  .a   ( {pre_1_1, pre_1_2, pre_2_1, pre_2_2} ), 
  .sum ( csa_s ), 
  .cout( csa_c )
);

assign mul1 = {csa_s[14],csa_s} + {csa_c[14],csa_c};

always @(posedge clk)
 begin
   mul = mul1[13 :0];
 end

endmodule
