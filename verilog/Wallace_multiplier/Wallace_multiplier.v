module wallace_gen #(
    parameter N      =  10, // 1 N 4 input A data width N>= W
    parameter W      =   5  // 1 2 4 input B data width
)

(a, b, prod);
input  [  N-1 :0] a; 
input  [  W-1 :0] b;
output [N+W-2 :0] prod;

  generate
    //if (N == 4) begin : gen_N_4
    //   carry_save_4inputs #(W)   cs_4in (.a(a), .sum(sum), .cout(cout)  ); end
    //else
     if     ((N == 4) &  (W == 4) ) begin : gen_W
       wallace4x4      wall_m_4x4 (.a(a), .b(b), .prod(prod)  ); end
    else if ((W == 5)             ) begin : gen_W
       wallaceNx5 #(N) wall_m_Nx5 (.a(a), .b(b), .prod(prod)  ); end
    else if ((W == 4)             ) begin : gen_W
       wallaceNx4 #(N) wall_m_Nx4 (.a(a), .b(b), .prod(prod)  ); end
    else if ((W == 3)             ) begin : gen_W
       wallaceNx3 #(N) wall_m_Nx3 (.a(a), .b(b), .prod(prod)  ); end
    else if ((W == 2)             ) begin : gen_W
       wallaceNx2 #(N) wall_m_Nx2 (.a(a), .b(b), .prod(prod)  ); end
    else if (W == 1) begin : gen_N_1
       assign prod[N-1 :0] = a      &  {(N){b}};
       //assign prod[N]      = a[N-1] &       b  ;
     end

//          carry_lookahead_adder #(W+E) CLA ( .i_add1(cs_sum), .i_add2(cs_c), .o_result(cla_sum) );
//          assign sum   = cla_sum[W+E-1 :0];
//          assign cout  = cla_sum[W+E];

  endgenerate

endmodule


//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////    5    //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module wallaceNx5 #(
    parameter N = 4  //    input data width
    )
    (a,b,prod);
  
    //inputs and outputs
    input [N-1:0] a;
    input [5-1:0] b;
    output[N+3  :0] prod;
    //internal variables.
    wire [N+1 :0] cla_sum;
    wire [N-1 :0] p0 , p1 , p2 , p3 , p4; // partial products
    wire [N+2 :0] pe0, pe1, pe2, pe3, pe4; // partial products with extention

    wire [N+4 :0] cs_sum, cs_cout ; 

    wire [N+4 : 0] adder_sum;
    wire           not_connect;

    wire [N+4  :0] test_cs_in,  test_cs_out, test_adder_out ;

//initialize the p's.
    assign  p0 = a & {N{b[0]}};
    assign  p1 = a & {N{b[1]}};
    assign  p2 = a & {N{b[2]}};
    assign  p3 = a & {N{b[3]}};
    assign  p4 = a & {N{b[4]}}; // BW

    assign  pe0 = {  {4{p0[N-1]}}, p0[N-1:1]           };
    assign  pe1 = {  {3{p1[N-1]}}, p1[N-1:0]           };
    assign  pe2 = {  {2{p2[N-1]}}, p2[N-1:0], {1'b0}   };
    assign  pe3 = {  {  p3[N-1]} , p3[N-1:0], {2'b00}  };
    assign  pe4 = {             { ~p4 }     , {3'b000} };

  assign test_cs_in[N+4 :1] = {{2{pe0[N]}},pe0} + {{2{pe1[N]}},pe1} + {{2{pe2[N]}},pe2} + {{2{pe3[N]}},pe3} + {{2{pe4[N]}},pe4} + {4'b1000};
  assign test_cs_in[0]      = p0[0];

carry_save_6inputs #(
    .W(N+3)
    ) csa (
    .a   ({{(N-1){1'b0}},4'b1000,pe4,pe3,pe2,pe1,pe0}),
    .sum (cs_sum ),
    .cout(cs_cout)
    );

  assign test_cs_out[N+3 :1] = cs_sum + cs_cout;
  assign test_cs_out[0]      = p0[0];

w_adder #(
    .useCLA(1'b1),
    .W     (N+5)
    ) adder (
    .a   (cs_sum [N+4 :0]  ), // MSB of  cs_sum is not in use
    .b   (cs_cout[N+4 :0]  ), // MSB of  cs_cout is not in use
    .cin ({1'b0}           ), 
    .sum (adder_sum[N+4:0] ), 
    .cout(not_connect      ) ); // always 0

    assign prod[0]   = p0[0];
    assign prod[N+3:1] = adder_sum[N+3:0];


endmodule

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////    4    //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module wallaceNx4 #(
    parameter N = 4  //    input data width
    )
    (a,b,prod);
localparam BW  = 4; // width of B input   
localparam CSE = 2; // carry save bit extention
    //inputs and outputs
    input [N-1:0] a;
    input [BW-1:0] b;
    output[N+2  :0] prod;
    //internal variables.
    wire [N+1 :0] cla_sum;
    wire [N-1       :0] p0 , p1 , p2 , p3 ; // partial products
    wire [N+(BW-1)-1:0] pe0, pe1, pe2, pe3; // partial products with extention

    wire [N+4 :0] cs_sum, cs_cout ; 

    wire [N+4 : 0] adder_sum;


    wire [N+2  :0] test_cs_in,  test_cs_out, test_adder_out ;

//initialize the p's.
    assign  p0 = a & {N{b[0]}};
    assign  p1 = a & {N{b[1]}};
    assign  p2 = a & {N{b[2]}};
    assign  p3 = a & {N{b[3]}}; // BW

    assign  pe0 = {  {3{p0[N-1]}}, p0[N-1:1]          };
    assign  pe1 = {  {2{p1[N-1]}}, p1[N-1:0]          };
    assign  pe2 = {  {  p2[N-1]} , p2[N-1:0], {1'b0}  };
    assign  pe3 = {             { ~p3 }     , {2'b00} };

  assign test_cs_in[N+2 :1] = {{2{pe0[N]}},pe0} + {{2{pe1[N]}},pe1} + {{2{pe2[N]}},pe2} + {{2{pe3[N]}},pe3} + {3'b100};
  assign test_cs_in[0]      = p0[0];

carry_save_5inputs #(
    .W(N+(BW-1))
    ) csa (
    .a   ({{(N){1'b0}},3'b100,pe3,pe2,pe1,pe0}),
    .sum (cs_sum ),
    .cout(cs_cout)
    );

  assign test_cs_out[N+2 :1] = cs_sum + cs_cout;
  assign test_cs_out[0]      = p0[0];

w_adder #(
    .useCLA(1'b1),
    .W     (N+4)
    ) adder (
    .a   (cs_sum [N+3 :0]  ), // MSB of  cs_sum is not in use
    .b   (cs_cout[N+3 :0]  ), // MSB of  cs_cout is not in use
    .cin ({1'b0}           ), 
    .sum (adder_sum[N+3:0] ), 
    .cout(adder_sum[N+4  ] ) ); // always 0

    assign prod[0]   = p0[0];
    assign prod[N+2:1] = adder_sum[N+2:0];


endmodule

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////    3    //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module wallaceNx3 #(
    parameter N = 4  //    input data width
    )
    (a,b,prod);
    
    //inputs and outputs
    input [N-1:0] a;
    input [  2:0] b;
    output[N+1  :0] prod;
    //internal variables.
    wire [N+1 :0] cla_sum;
    wire [N-1:0]    p0,p1,p2;   // partial products
    wire [N  :0] pe0,pe1,pe2; // partial products with extention

    wire [N +2 :0] cs_sum, cs_cout ; 

    wire [N +2 + 1: 0] adder_sum;


    wire [N+2  :0] test_cs_in,  test_cs_out, test_adder_out ;

//initialize the p's.
    assign  p0 = a & {N{b[0]}};
    assign  p1 = a & {N{b[1]}};
    assign  p2 = a & {N{b[2]}};

    assign  pe0 = {  {2{p0[N-1]}}, p0[N-1:1]  };
    assign  pe1 = {  {p1[N-1]},    p1[N-1:0]  };
    assign  pe2 = {  {~p2},           {1'b0}  };
  assign test_cs_in[N+2 :1] = {pe0[N],pe0} + {pe1[N],pe1} + {pe2[N],pe2} +  {2'b10};
  assign test_cs_in[0]      = p0[0];

carry_save_4inputs #(
    .W(N+1)
    ) csa (
    .a   ({{(N-1){1'b0}},2'b10,pe2,pe1,pe0}),
    .sum (cs_sum ),
    .cout(cs_cout)
    );

  assign test_cs_out[N+2 :1] = cs_sum + cs_cout;
  assign test_cs_out[0]      = p0[0];

//    assign  pe0 = {  2'b01, p0[N-1] , p0[N-2:1]  };
//    assign  pe1 = {  {~p1[N-1]},    p1[N-1:0]  };
//    assign  pe2 = {  p2[N-1], {~p2[N-2:0]},     {1'b0}  };  // 
//    assign prod[N+1:1] = pe0 + pe1 + pe2 ;

/// //final product assignments    


w_adder #(
    .useCLA(1'b1),
    .W     (N+1 +2)
    ) adder (
    .a   (cs_sum     ), 
    .b   (cs_cout    ), 
    .cin ({1'b0}     ), 
    .sum (adder_sum[N +2:0] ), 
    .cout(adder_sum[N +2+1]     ) );

    assign prod[0]   = p0[0];
    assign prod[N+1:1] = adder_sum[N:0];

endmodule

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////    2    //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module wallaceNx2 #(
    parameter N = 4  //    input data width
    )
    (a,b,prod);
    
    //inputs and outputs
    input [N-1:0] a;
    input [  1:0] b;
    output[N  :0] prod;
    //internal variables.
    wire [N  :0] cla_sum;
    wire [N-1:0] p0,p1; 

//initialize the p's.
    assign  p0 = a & {N{b[0]}};
    assign  p1 = a & {N{b[1]}};

//final product assignments    
    assign prod[0]     = p0[0];
    assign prod[N:1] = cla_sum[N-1:0];

//assign cla_sum =  {p0[N-1],p0[N-1:1]} - p1;

w_adder #(
    .useCLA(1'b1),
    .W     (N)
    ) adder (
    .a   ({p0[N-1],p0[N-1:1]}), 
    .b   (~p1                ), 
    .cin ({1'b1}             ), 
    .sum (cla_sum[N-1:0]     ), 
    .cout(cla_sum[N]         ) );

//ripple_carry #(
//    .W (N)
//  ) RCA (
//    .a   ({p0[N-1],p0[N-1:1]}) , 
//    .b   (~p1                ) , 
//    .cin (             {1'b1}) , 
//    .sum (cla_sum[N-1:0]     ) , 
//    .cout(cla_sum[N]         )  );

// carry_lookahead_adder #(
//             .W (N)      
//              )   cla (
//             .i_add1  ({p0[N-1],p0[N-1:1]}) , 
//             .i_add2  (~p1                ) , 
//             .c_in    ({1'b1}             ) ,
//             .o_result(cla_sum            ) );

endmodule

module wallace4x4(a,b,prod);
    
    //inputs and outputs
    input [3:0] a,b;
    output [7:0] prod;
    //internal variables.
    wire s11,s12,s13,s14,s15,s22,s23,s24,s25,s26,s32,s33,s34,s35,s36,s37;
    wire c11,c12,c13,c14,c15,c22,c23,c24,c25,c26,c32,c33,c34,c35,c36,c37;
    wire [6:0] p0,p1,p2,p3;

//initialize the p's.
    assign  p0 = a & {4{b[0]}};
    assign  p1 = a & {4{b[1]}};
    assign  p2 = a & {4{b[2]}};
    assign  p3 = a & {4{b[3]}};

//final product assignments    
    assign prod[0] = p0[0];
    assign prod[1] = s11;
    assign prod[2] = s22;
    assign prod[3] = s32;
    assign prod[4] = s34;
    assign prod[5] = s35;
    assign prod[6] = s36;
    assign prod[7] = s37;

//first stage
    half_adder ha11 (p0[1],p1[0],s11,c11);
    full_adder fa12(p0[2],p1[1],p2[0],s12,c12);
    full_adder fa13(p0[3],p1[2],p2[1],s13,c13);
    full_adder fa14(p1[3],p2[2],p3[1],s14,c14);
    half_adder ha15(p2[3],p3[2],s15,c15);

//second stage
    half_adder ha22 (c11,s12,s22,c22);
    full_adder fa23 (p3[0],c12,s13,s23,c23);
    full_adder fa24 (c13,c32,s14,s24,c24);
    full_adder fa25 (c14,c24,s15,s25,c25);
    full_adder fa26 (c15,c25,p3[3],s26,c26);

//third stage
    half_adder ha32(c22,s23,s32,c32);
    half_adder ha34(c23,s24,s34,c34);
    half_adder ha35(c34,s25,s35,c35);
    half_adder ha36(c35,s26,s36,c36);
    half_adder ha37(c36,c26,s37,c37);

endmodule

module w_adder #(
    parameter useCLA = 1,
    parameter W      = 4  //    input data width
)
(a, b, cin, sum, cout);
input  [W-1:0] a,b;
input          cin;
wire   [W  :0] c1;
output [W-1:0] sum;
output         cout;

wire   [W  :0] o_result;

generate
  if   (useCLA ==1 )  begin : g_CLA
    carry_lookahead_adder #(
             .W (W)      
              )   cla (
             .i_add1  (a       ) , 
             .i_add2  (b       ) , 
             .c_in    (cin     ) ,
             .o_result(o_result) );

    assign sum  = o_result[W-1:0];
    assign cout = o_result[W]    ;
    end
  else begin : g_RCA
    ripple_carry #(
    .W (W)
   ) RCA (
    .a   (a   ) , 
    .b   (b   ) , 
    .cin (cin ) , 
    .sum (sum ) , 
    .cout(cout)  );
   
   end
endgenerate

endmodule