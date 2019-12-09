 module CE    #(
    parameter CL_IN  = 9,  // 2...64, number of inputs features
    parameter KERNEL = 3,  // 1/3/5/7
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

    output wire [N+10-1:0]      d_out ,
    output wire              en_out   
);

    genvar          i;

 localparam  E1 = (KERNEL == 3) ? 4 : //3 :
                  (KERNEL == 5) ? 4 :
                  (KERNEL == 7) ? 5 :
                                 1 ;

 localparam  E2 = (CL_IN ==  3 || CL_IN == 4) ? 1 :
                  (CL_IN ==  5 || CL_IN == 6 || CL_IN == 7 ) ? 2 :
                  (CL_IN ==  9) ? 3 :
                  (CL_IN == 25) ? 4 :
                  (CL_IN == 49) ? 5 :
                                  0 ;
 
 localparam D_MSB = N+M+E1-1;
 wire [D_MSB:0]      csa_d_out; 


wire [CL_IN*(N+M+E1-1)-1:0]     d_calc;
//wire [CL_IN*N-1:0] d_calc;
wire  [CL_IN-1:0]      en_calc;

 generate 
    for (i = 0; i < CL_IN; i = i + 1) begin
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
        .d_out     (d_calc [i*(N+M+E1-1) +: N+M+E1-1] ), 
        .en_out    (en_calc[i]) 
       );
    end
 endgenerate


// multi_adder #(
//  .CL_IN (CL_IN ), 
//  .RELU  (RELU  ),
//  .N     (N+M+5 ), //(N    ), 
//  .SR    (SR    )     
// ) 
// M_ADD
// (
//  .clk   (clk     ), 
//  .rst   (rst     ), 
//  .d_in  (d_calc  ), 
//  .en_in (en_calc[0]), 
//  .d_out (d_out   ), 
//  .en_out(en_out  ) 
// );

carry_save_adder #(
                  .N (CL_IN   ) , 
                  .E (E2      ) , 
                  .W (N+M+E1-1)     
               )   csa (
                  .a   (d_calc               ), 
                  .sum (csa_d_out [D_MSB-1:0]), 
                  .cout(csa_d_out [D_MSB    ])  );

assign d_out = csa_d_out;

 endmodule  