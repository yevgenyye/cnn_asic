 module ConvLayer_calc    #(
    parameter MULT   = 1, // 1/0 -> Multiplier by FullAdders / * (default) 
    parameter useCLA = 0, // 0/1  -> use ripleCarry/CLA
    parameter KERNEL = 3, // 1/3/5/7 ^2  // 9; // 25; // 49; //  
    parameter E      = 3,                // 3; // 4;  // 5 ; // bit extention ( N=9 -> E=3, N=25 -> E=4)
    parameter N      = 4, // input data width
    parameter M      = 4  // input weight width

) (
    input wire                       clk       ,
    input wire                       rst       ,
    input wire [KERNEL*KERNEL*N-1:0] data2conv ,
    input wire                       en_in     ,
    input wire [KERNEL*KERNEL*M-1:0] w         ,

    output wire [N+M+E-1:0]            sum     ,
    output wire [N+M+E-1:0]            cout    ,
    output wire                        en_out    
);

 integer i;
 genvar  j;

 reg [7:0] out;
 reg  [KERNEL*KERNEL*(N + M) -1 : 0] prod     ;
 wire [KERNEL*KERNEL*(N + M) -1 : 0] prod_w   ;

 wire [N+M+E-1 :0] csa_sum;
 wire [N+M+E-1 :0] csa_cout;

 reg en_prod, en_sum, en_sum2, en_sum3;

 wire [KERNEL*KERNEL*(N + M) -1 : 0]  prod_tmp;

// initial begin
//    $display(" ConvLayer_calc output | width= %d ", D_MSB );
// end
 
// initial begin
//    $display(" ConvLayer_calc output d_out | width= %d ",N+M+E  ); 
//    $display(" ConvLayer_calc csa_d_out   | width= %d ",D_MSB+1  ); 
//    $display(" ConvLayer_calc D_MSB   | width= %d ",D_MSB  ); 
// end

 //-------------Code Starts Here-------
 generate
   if (MULT == 0)
      always @(posedge clk)
      begin
         for (i=0; i<KERNEL**2; i=i+1)
            prod[i*(N + M) +: (N + M) ] <= w[i*M +: M] * data2conv[i*N +: N];
      end
   else
      begin
         for (j=0; j<KERNEL**2; j=j+1) begin : gen_mult
            wallace_gen #(
               .N      (N     ), 
               .W      (M     ),
               .useCLA (useCLA)
            ) mult (
               .a   (data2conv[j*N +: N])    , 
               .b   (w        [j*M +: M])    , 
               .prod(prod_w [j*(N + M) +: (N + M - 1) ]) );
          end // for
            always @(data2conv,w)
               for (i=0; i<KERNEL**2; i=i+1) 
               begin
                  prod [i*(N + M) +: (N + M)] = {prod_w [i*(N + M) +: (N + M - 1) ] ,  prod_w [i*(N + M) +: (N + M - 1) ]};
               end
      end
endgenerate 

generate
   if (KERNEL != 1)
      begin : gen_cla
      carry_save_adder #(
                      .N (KERNEL*KERNEL) , 
                      .E (E) , 
                      .W (N+M)     
                   )   csa (
                      .a(prod), 
                      .sum (csa_sum ), 
                      .cout(csa_cout)  );
      end
endgenerate 


always @(posedge clk) // or rst)
 if (rst) begin
   en_prod <= 1'b0;
 end else begin
   en_prod <= en_in  ;
end // always

      assign en_out = en_prod;
      assign sum    = (KERNEL == 1) ?            prod : csa_sum ;
      assign cout   = (KERNEL == 1) ? {(N+M+E){1'b0}} : csa_cout;

 endmodule  
