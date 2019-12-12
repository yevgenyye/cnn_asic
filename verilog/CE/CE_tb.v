 `timescale 1 ns/10 ps 

 module CE_tb (); 

    parameter CL_IN  = 4;  // 3...64, number of inputs features
    parameter KERNEL = 3;  // 1/3/5/7
    parameter RELU   = 1;  // 0 - no relu, 1 - relu, only positive output values
    parameter N      = 4;  // input data width
    parameter M      = 4;  // input weight width
    parameter SR     = 2;  // data shift right before output

    parameter  E = (KERNEL == 3) ? 3 :
                   (KERNEL == 5) ? 4 :
                   (KERNEL == 7) ? 5 :
                                   1 ;

    reg                              clk       ;
    reg                              rst       ;
    reg  [CL_IN*KERNEL*KERNEL*N-1:0] data2conv ;
    reg                              en_in     ;
    reg  [CL_IN*KERNEL*KERNEL*M-1:0] w         ;
    wire [N+M+E+3-1:0]                 d_out     ;
    wire                             en_out    ;

integer           i,j;
reg    [N-1:0] d_val; 
reg    [M-1:0] w_val; 

    localparam period = 20;

 initial begin
    $display($time, " TB, d_out port size | width= %d", N+M+E+3-1 );
 end

CE  #(
  .CL_IN (CL_IN) ,
  .KERNEL(KERNEL), 
  .RELU  (RELU)  ,
  .N     (N)     , 
  .M     (M)     ,
  .SR    (SR)
) 
UUT
(
  .clk       (clk      ), 
  .rst       (rst      ), 
  .data2conv (data2conv), 
  .en_in     (en_in    ), 
  .w         (w        ), 
  .d_out     (d_out    ), 
  .en_out    (en_out   ) 
);

always 
begin
    clk = 1'b1; 
    #10; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #10; // low for 20 * timescale = 20 ns
end

     initial // initial block executes only once
        begin
          rst   <= 1'b1; 
          en_in <= 1'b0;
          d_val <= { {(N-1){1'b0}}, 1'd1 };
          w_val <= { {(M-1){1'b0}}, 1'd1 };
          data2conv <= { (CL_IN*KERNEL*KERNEL*N){1'd1} };
          w         <= { (CL_IN*KERNEL*KERNEL*N){1'd1} }; 
          #20;
          rst <= 1'b0; 
          #20;
          en_in <= 1'b1;

          for(j=0; j<10; j=j+1) 
          begin
   //          for(i=0; i<CL_IN*KERNEL**2; i=i+1) 
   //             data2conv[i*N +: N] <= d_val + i;
   //          for(i=0; i<CL_IN*KERNEL**2; i=i+1) 
   //             w        [i*M +: M] <= w_val + i + 1;
   //          d_val <= d_val + 1;
   //          w_val <= w_val + 1;
             #20;
          end

  
         //   #period;
        end
 endmodule  