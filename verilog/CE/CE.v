 module CE    #(
    parameter CL_IN  = 4,  // 1...9, 25, 49, number of inputs features
    parameter KERNEL = 7,  // 1/3/5/7
    parameter RELU   = 1,  // 0 - no relu, 1 - relu, only positive output values
    parameter N      = 4,  // input data width
    parameter M      = 4,  // input weight width
    parameter SR     = 2   // data shift right before output

) (
    input wire                             clk       ,
    input wire                             rst       ,
    input wire [CL_IN*KERNEL*KERNEL*N-1:0] data2conv ,
    input wire                             en_in     ,
    input wire [CL_IN*KERNEL*KERNEL*M-1:0] w         ,

    output wire [N+M+15-1:0]      d_out ,
    output wire                   en_out   
);

    genvar          i;

 localparam  E1 = (KERNEL == 1) ? 0 :
                  (KERNEL == 3) ? 3 :
                  (KERNEL == 5) ? 5 :
                  (KERNEL == 7) ? 6 :
                                  0 ;

 localparam  E2 = (CL_IN ==  2 ) ? 0 :
                  (CL_IN ==  3 ) ? 1 :
                  (CL_IN ==  4 || CL_IN ==  5 || CL_IN ==  6 || CL_IN ==  7 ) ? 2 :
                  (CL_IN ==  8 || CL_IN ==  9 || CL_IN == 10 || CL_IN == 11 ||
                   CL_IN == 12 || CL_IN == 13 || CL_IN == 14 || CL_IN == 15 ) ? 3 :
                  (CL_IN == 16 ) ? 4 :
                  (CL_IN == 25 ) ? 5 :
                  (CL_IN == 49 ) ? 6 :
                                  0 ;
 localparam EXT = 15;

//localparam D_CALC_1 = N+M+E1+1;
localparam D_CALC_1 = N+M+E1;
wire [CL_IN*(D_CALC_1)-1:0]     d_calc;

//localparam D_MSB = N+M+E1-1;
localparam D_MSB = D_CALC_1 + E2;
wire [D_MSB:0]      csa_d_out; 

//wire [CL_IN*N-1:0] d_calc;
wire  [CL_IN-1:0]      en_calc;

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
        .d_out     (d_calc [i*D_CALC_1 +: D_CALC_1] ), 
        .en_out    (en_calc[i]) 
       );
    end
 endgenerate

 if (CL_IN == 1) 
    begin : gen_N_1
      assign d_out[D_CALC_1-1:0] = d_calc;
      assign d_out[N+M+EXT-1 : D_CALC_1] = { (N + M + EXT - D_CALC_1) {1'b0} };
    end
 else if (N != 1)
    begin
      carry_save_adder #(
                        .N (CL_IN   ) , 
                        .E (E2      ) , 
                        .W (D_CALC_1)     
                     )   csa (
                        .a   (d_calc               ), 
                        .sum (csa_d_out [D_MSB-1:0]), 
                        .cout(csa_d_out [D_MSB    ])  );
      assign d_out[   D_MSB :       0] = csa_d_out;
      assign d_out[N+M+EXT-1 : D_MSB+1] = { (N+M+EXT-D_MSB+1) {1'b0} };
    end

assign en_out = en_calc[0];

 endmodule  
