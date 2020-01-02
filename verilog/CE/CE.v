 module CE    #(
    parameter CL_IN  = 4,  // 1, 2...8, 16, 32, 64, 128 (25, 49), number of inputs features
    parameter KERNEL = 7,  // 1/3/5/7
    parameter RELU   = 1,  // 0 - no relu, 1 - relu, only positive output values
    parameter N      = 2,  // input data width
    parameter M      = 2,  // input weight width
    parameter SR     = 2   // data shift right before output

) (
    input wire                             clk       ,
    input wire                             rst       ,
    input wire [CL_IN*KERNEL*KERNEL*N-1:0] data2conv ,
    input wire                             en_in     ,
    input wire [CL_IN*KERNEL*KERNEL*M-1:0] w         ,

    output reg [N+M+15-1:0]      d_out ,
    output reg                   en_out   
);

    genvar          i;

 localparam  E1 = (KERNEL == 1) ? 0 :
                  (KERNEL == 3) ? 3 :
                  (KERNEL == 5) ? 4 :
                  (KERNEL == 7) ? 5 :
                                  0 ;

 parameter CL_IN_DBL  = 2 * CL_IN;

 localparam  E2 = (CL_IN_DBL ==  2 ) ? 0 :
                  (CL_IN_DBL ==  4 || CL_IN_DBL ==  6 ) ? 2 :
                  (CL_IN_DBL ==  8 || CL_IN_DBL == 10 || CL_IN_DBL == 12 || CL_IN_DBL == 14  ) ? 3 :
                  (CL_IN_DBL == 16 ) ? 4 :
                  (CL_IN_DBL == 32 ) ? 5 :
                  (CL_IN_DBL == 64 ) ? 6 :
                  (CL_IN_DBL ==128 ) ? 7 :
                  (CL_IN_DBL ==256 ) ? 8 :
                                       0;

// localparam  E2 = (CL_IN ==  2 ) ? 0 :
//                  (CL_IN ==  3 ) ? 1 :
//                  (CL_IN ==  4 || CL_IN ==  5 || CL_IN ==  6 || CL_IN ==  7 ) ? 2 :
//                  (CL_IN ==  8 || CL_IN ==  9 || CL_IN == 10 || CL_IN == 12 ) ? 3 :
//                  (CL_IN == 11 || CL_IN == 13 || CL_IN == 14 || CL_IN == 15 ) ? 3 :
//                  (CL_IN == 16 ) ? 4 :
//                  (CL_IN == 25 ) ? 4 :
//                  (CL_IN == 32 ) ? 5 :
//                  (CL_IN == 49 ) ? 5 :
//                                  0 ;
 localparam EXT = 15;

localparam D_CALC_1 = N+M+E1;
wire [CL_IN*(D_CALC_1)-1:0]     d_calc;
wire [CL_IN*(D_CALC_1)-1:0]     c_calc;
reg  [CL_IN*(D_CALC_1)-1:0]     d_calc_d;
reg  [CL_IN*(D_CALC_1)-1:0]     c_calc_d;

localparam D_MSB = D_CALC_1 + E2 - 1;
wire [D_MSB  :0]      csa_s_sum ; 
wire [D_MSB  :0]      csa_s_cout; 
wire [D_MSB  :0]      csa_c_sum ; 
wire [D_MSB  :0]      csa_c_cout; 
wire [D_MSB+1:0]      csa_s_res; 

//wire [CL_IN*N-1:0] d_calc;
wire  [CL_IN-1:0]      en_calc;
reg                   en_calc_d;

 initial begin
    $display(" CE, outout d_out | width = %d", N+10-1);
    $display(" CE, outout csa_d_out | width = %d", D_MSB+1);
    $display(" CE, ConvLayer_calc output,d_calc | width= %d, step aa= %d",CL_IN*(D_CALC_1),D_CALC_1 );
 end

 generate 
    for (i = 0; i < CL_IN; i = i + 1) begin : gen_calc
       ConvLayer_calc #(
        .KERNEL(KERNEL), 
        .E     (E1    ),
        .N     (N     ), 
        .M     (M     )     
       ) 
       CALC
       (
        .clk       (clk       ), 
        .rst       (rst       ), 
        .data2conv (data2conv [i*KERNEL*KERNEL*N +: KERNEL*KERNEL*N]), 
        .en_in     (en_in     ), 
        .w         (w         [i*KERNEL*KERNEL*M +: KERNEL*KERNEL*M]), 
        //.d_out     (d_calc [i*D_CALC_1 +: D_CALC_1] ), 
        .sum       (d_calc [i*D_CALC_1 +: D_CALC_1] ), 
        .cout      (c_calc [i*D_CALC_1 +: D_CALC_1] ), 
        .en_out    (en_calc[i]) 
       );
    end
 endgenerate

always @(posedge clk)
 if (rst) begin
   en_calc_d <= 1'b0;
 end else begin
   en_calc_d <= en_calc[0];
 end 

always @(posedge clk)
  begin
    d_calc_d  <= d_calc;
    c_calc_d  <= c_calc;
  end

 if (CL_IN == 1) 
    begin : gen_N_1
       always @(d_calc_d)
         begin
          d_out[D_CALC_1-1:0] <= d_calc_d;
          d_out[N+M+EXT-1 : D_CALC_1] <= { (N + M + EXT - D_CALC_1) {1'b0} };
         end
       always @(en_calc_d)
          en_out <= en_calc_d;
    end
 else //if (CL_IN != 1)
    begin
      carry_save_adder #(
                  .N (CL_IN_DBL) , 
                  .E (E2       ) , 
                  .W (D_CALC_1 )     
               )   csa_sum (
                  .a   ({ d_calc_d,c_calc_d }), 
                  .sum (  csa_s_sum          ), 
                  .cout(  csa_s_cout         ) );


      carry_lookahead_adder #(
                  .W (D_MSB+1)      
               )   cla (
                  .i_add1  ( csa_s_sum  ), 
                  .i_add2  ( csa_s_cout ), 
                  .o_result( csa_s_res  ) );

    //  carry_save_adder #(
    //              .N (CL_IN   ) , 
    //              .E (E2      ) , 
    //              .W (D_CALC_1)     
    //            )  csa_cout (
    //              .a   (c_calc_d  ) , 
    //              .sum (csa_c_sum ) , 
    //              .cout(csa_c_cout) );



      //assign d_out[   D_MSB :       0] = csa_d_out;
      //assign d_out[N+M+EXT-1 : D_MSB+1] = { (N+M+EXT-D_MSB+1) {1'b0} };
      //assign en_out = en_calc_d;
      always @(posedge clk)
       if (rst) begin
         en_out <= 1'b0;
       end else begin
         en_out <= en_calc_d;
       end 
      
      always @(posedge clk)
       begin
         d_out[D_MSB +1  :       0]  <= csa_s_res;
         d_out[N+M+EXT-1 : D_MSB+2] <= { (N+M+EXT-D_MSB+1) {1'b0} };
       end
    end


 endmodule  
