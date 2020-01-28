 module CE_net    #(
    parameter MULT   = 0, // 1/0 -> Multiplier by FullAdders / * (both 2's compliment) 
    parameter useCLA = 1, // 0/1  -> use ripleCarry/CLA
    parameter CL_IN  = 5,  // 1, 2...8, 16, 32, 64, 128, 256 (25, 49), number of input  features
    parameter CL_OUT = 4,  //                                          number of output features
    parameter KERNEL = 3,  // 1/3/5/7
    parameter RELU   = 1,  // 0 - no relu, 1 - relu, only positive output values
    parameter N      = 4,  // input data width
    parameter M      = 4,  // input weight width
    parameter SR     = 2   // data shift right before output

) (
    input wire                                    clk       ,
    input wire                                    rst       ,
    input wire [CL_IN*KERNEL*KERNEL*N-1:0]        data2conv ,
    input wire                                    en_in     ,
    input wire [CL_OUT*CL_IN*KERNEL*KERNEL*M-1:0] w         ,

    output wire [CL_OUT*(N+M+15)-1:0]             d_out     ,
    output wire                                   en_out   
);

    genvar          i;

wire  [CL_OUT-1  :0]  en_vec;


// initial begin
//    $display(" CE, outout d_out | width = %d", N+10-1);
//    $display(" CE, outout csa_d_out | width = %d", D_MSB+1);
//    $display(" CE, ConvLayer_calc output,d_calc | width= %d, step aa= %d",CL_IN*(D_CALC_1),D_CALC_1 );
// end

 generate 
    for (i = 0; i < CL_OUT; i = i + 1) begin : gen_calc
       CE #(
        .MULT  (MULT  ), 
        .useCLA(useCLA),
        .CL_IN (CL_IN ),
        .KERNEL(KERNEL), 
        .RELU  (RELU  ),
        .N     (N     ), 
        .M     (M     ),
        .SR    (SR    )
       ) 
       CALC
       (
        .clk       (clk       ), 
        .rst       (rst       ), 
        .data2conv (data2conv ), 
        .en_in     (en_in     ), 
        .w         (w [i*(CL_IN*KERNEL*KERNEL*M) +: CL_IN*KERNEL*KERNEL*M] ), 

        .d_out     (d_out [i*(N+M+15) +: (N+M+15)] ),
        .en_out    (en_vec[i]) 
       );
    end
 endgenerate

assign en_out = en_vec[0];

 endmodule  
