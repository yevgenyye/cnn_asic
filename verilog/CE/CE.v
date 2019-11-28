 module CE    #(
    parameter CL_IN  = 8,  // 2...64, number of inputs features
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

    output wire [N-1:0]      d_out ,
    output wire              en_out   
);

    genvar          i;
wire [CL_IN*(N+M+6)-1:0]     d_calc;
//wire [CL_IN*N-1:0] d_calc;
wire  [CL_IN-1:0]      en_calc;

 generate 
    for (i = 0; i < CL_IN; i = i + 1) begin
       ConvLayer_calc #(
        .KERNEL(KERNEL), 
        .N     (N)     , 
        .M     (M)     
       ) 
       CALC
       (
        .clk       (clk       ), 
        .rst       (rst       ), 
        .data2conv (data2conv [i*KERNEL*KERNEL*N +: KERNEL*KERNEL*N]), 
        .en_in     (en_in     ), 
        .w         (w         [i*KERNEL*KERNEL*M +: KERNEL*KERNEL*M]), 
        .d_out     (d_calc [i*(N+M+6) +: N+M+6] ), 
        .en_out    (en_calc[i]) 
       );
    end
 endgenerate


// ConvLayer_calc #(
//  .KERNEL(KERNEL), 
//  .N     (N)     , 
//  .M     (M)     
// ) 
// CALC
// (
//  .clk       (clk       ), 
//  .rst       (rst       ), 
//  .data2conv (data2conv ), 
//  .en_in     (en_in     ), 
//  .w         (w         ), 
//  .d_out     (d_calc    ), 
//  .en_out    (en_calc   ) 
// );

 multi_adder #(
  .CL_IN (CL_IN ), 
  .RELU  (RELU  ),
  .N     (N+M+5 ), //(N    ), 
  .SR    (SR    )     
 ) 
 M_ADD
 (
  .clk   (clk     ), 
  .rst   (rst     ), 
  .d_in  (d_calc  ), 
  .en_in (en_calc[0]), 
  .d_out (d_out   ), 
  .en_out(en_out  ) 
 );

 endmodule  