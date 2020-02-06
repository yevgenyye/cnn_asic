 `timescale 1 ns/10 ps 

 module PE_tb (); 

    parameter LINES  = 16; // line size of input frame
    parameter MULT   =  0; // 1/0 -> Multiplier by FullAdders / * (both 2's compliment) 
    parameter useCLA =  1; // 0/1  -> use ripleCarry/CLA
    parameter CL_IN  =  4;  // number of in/out-puts feature
    parameter CL1    =  2;  // bus width of bp_src_in
    parameter KERNEL =  3;  // 1/3/5/7
    parameter RELU   =  1;  // 0 - no relu, 1 - relu, only positive output values
    parameter N      =  2;  // input data width
    parameter M      =  4;  // input weight width
    parameter SR     =  2;  // data shift right before output

    reg                 clk        ;
    reg                 rst        ;
    reg   [CL_IN*N-1:0] d_in       ;
    reg   [CL_IN-1:0]   d_ch_in    ; // data input enable channel
//  reg   [CL_IN*M-1:0] w_in       ;
    reg   [      M-1:0] w_in       ;
    wire  [CL_IN*N-1:0] d_out      ;
    wire                en_out     ;
    reg                 w_conf     ; // w_in configuration enable ( 9 clocks)
    wire  [      M-1:0] w_out      ;
    reg                 cntl_conf  ; // control configuration enable ( 1 clock )
    reg   [CL_IN-1:0]   bp_ch_in   ; // bypass output channel
    reg   [CL1  -1:0]   bp_src_in  ; // bypass source channel
    wire  [CL_IN-1:0]   d_ch_out   ; // enable channel
    wire  [CL_IN-1:0]   bp_ch_out  ; // bypass channel
    wire  [CL1  -1:0]   bp_src_out ; // bypass source channel



//    reg  [CL_IN*(N+M+E)-1:0]         mult_sum,mult_sum_d ;
//    reg  [CL_IN*(N+M+E)-1:0]         mult_sum0,mult_sum1,mult_sum2,mult_sum3,mult_sum4,mult_sum5,mult_sum6,mult_sum7,mult_sum8 ;
//
//    reg  [CL_IN*(  N +E)-1:0]              mult_sum0d,mult_sum1d,mult_sum2d,mult_sum3d,mult_sum4d,mult_sum5d,mult_sum6d,mult_sum7d,mult_sum8d ;
//    reg  [CL_IN*(  M +E)-1:0]              mult_sum0w,mult_sum1w,mult_sum2w,mult_sum3w,mult_sum4w,mult_sum5w,mult_sum6w,mult_sum7w,mult_sum8w ;
//    reg  [CL_IN*(N+M +E)-1:0]              mult_sum0m,mult_sum1m,mult_sum2m,mult_sum3m,mult_sum4m,mult_sum5m,mult_sum6m,mult_sum7m,mult_sum8m ;

integer           i,j,k;
reg    [N-1:0] d_val; 
reg    [M-1:0] w_val; 
reg     err;

    localparam period = 20;

 initial begin
   // $display($time, " TB, d_out port size | width= %d", N+M+E2);
 end


PE  #(
  .LINES  (LINES),
  .MULT   (MULT)  , 
  .useCLA (useCLA),
  .CL_IN  (CL_IN) ,
  .CL1    (CL1)   ,
//  .KERNEL (KERNEL), 
  .RELU   (RELU)  ,
  .N      (N)     , 
  .M      (M)     ,
  .SR     (SR)
) 
UUT
(
  .clk       (clk       ), 
  .rst       (rst       ), 
  .d_in      (d_in      ), 
  .d_ch_in   (d_ch_in   ), 
  .w_in      (w_in      ), 
  .d_out     (d_out     ), 
  .en_out    (en_out    ), 
  .w_conf    (w_conf    ),
  .w_out     (w_out     ),
  .cntl_conf (cntl_conf ),
  .bp_ch_in  (bp_ch_in  ),
  .bp_src_in (bp_src_in ),
  .d_ch_out  (d_ch_out  ),
  .bp_ch_out (bp_ch_out ),
  .bp_src_out(bp_src_out)
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
          //en_in <= 1'b0;
          d_val <= { {(N-1){1'b0}}, 1'd0 };
          w_val <= { {(M-1){1'b0}}, 1'd0 };
          d_in      <= 16'h1234; //{ (CL_IN*KERNEL*KERNEL*N){1'd0} };
          w_in      <= 16'h1234; //{ (CL_IN*KERNEL*KERNEL*N){1'd0} }; 
          //w_in      <= 4'hf; //max value 
          cntl_conf   <= 1'b0;
          w_conf <=   1'b0;
          d_ch_in   <= 4'b1111;
          bp_ch_in  <= 4'b0100;
          bp_src_in <= 2'b00;
          #20;
          rst <= 1'b0; 
          #20;
          for(i=0; i< KERNEL**2; i=i+1) 
            begin
            w_conf <=   1'b1;
            for(j=0; j< CL_IN; j=j+1) 
               //w_in [j*M +: M] <= w_in [j*M +: M] + 1; // + 10;
               w_in      <= {1'b0,{(M-1){1'b1}}}; //max value 
            #20;
            end
          w_conf <=   1'b0;
          cntl_conf <= 1'b1;
          bp_ch_in  <= 4'b1001;
          bp_src_in <= 2'b01;
          #20;
          cntl_conf   <= 1'b0;
          #20;
          //en_in <= 1'b1;

          for(j=0; j<10; j=j+1) 
          begin
             for(i=0; i< 100; i=i+1) 
             // d_in [i*N +: N] <= d_val + i;
             // d_in [i*N +: N] <= {1'b0,{(N-1){1'b1}}};  // maximum positive valie
             //   d_in [i*N +: N] <= {1'b1,{(N-1){1'b0}}};  // minim negative valie
                d_in [i*N +: N] <= {1'b1,{(N-1){1'b1}}};  // maximum negative valie (-1)

             d_val <= d_val + 1;
             w_val <= w_val + 1;
             #20;
          end

  
         //   #period;
        end


//  always @(posedge clk)
//  //always @(data2conv,w)
//  begin
//     i=0;
//     mult_sum=0;
//   // for (i = 0; i < CL_IN; i = i + 1) //begin  
//       for (k = 0; k < K2-1; k = k + 1) //begin  
//        mult_sum[i +: M+N+E] <= mult_sum[i +: M+N+E] +
//                    {  {(M+E){data2conv [i*K2*N + k*N + N-1]}}, data2conv[i*K2*N + k*N +: N]  } *
//                    {  {(N+E){w         [i*K2*M + k*M + M-1]}}, w        [i*K2*M + k*M +: M]  } ;
//
//        mult_sum0 = {  {(M+E){data2conv [i*K2*N + 0*N + N-1]}}, data2conv[i*K2*N + 0*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 0*M + M-1]}}, w        [i*K2*M + 0*M +: M]  } ;
//        mult_sum1 = {  {(M+E){data2conv [i*K2*N + 1*N + N-1]}}, data2conv[i*K2*N + 1*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 1*M + M-1]}}, w        [i*K2*M + 1*M +: M]  } ;
//        mult_sum2 = {  {(M+E){data2conv [i*K2*N + 2*N + N-1]}}, data2conv[i*K2*N + 2*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 2*M + M-1]}}, w        [i*K2*M + 2*M +: M]  } ;
//        mult_sum3 = {  {(M+E){data2conv [i*K2*N + 3*N + N-1]}}, data2conv[i*K2*N + 3*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 3*M + M-1]}}, w        [i*K2*M + 3*M +: M]  } ;
//        mult_sum4 = {  {(M+E){data2conv [i*K2*N + 4*N + N-1]}}, data2conv[i*K2*N + 4*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 4*M + M-1]}}, w        [i*K2*M + 4*M +: M]  } ;
//        mult_sum5 = {  {(M+E){data2conv [i*K2*N + 5*N + N-1]}}, data2conv[i*K2*N + 5*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 5*M + M-1]}}, w        [i*K2*M + 5*M +: M]  } ;
//        mult_sum6 = {  {(M+E){data2conv [i*K2*N + 6*N + N-1]}}, data2conv[i*K2*N + 6*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 6*M + M-1]}}, w        [i*K2*M + 6*M +: M]  } ;
//        mult_sum7 = {  {(M+E){data2conv [i*K2*N + 7*N + N-1]}}, data2conv[i*K2*N + 7*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 7*M + M-1]}}, w        [i*K2*M + 7*M +: M]  } ;
//        mult_sum8 = {  {(M+E){data2conv [i*K2*N + 8*N + N-1]}}, data2conv[i*K2*N + 8*N +: N]  } * 
//                    {  {(N+E){w         [i*K2*M + 8*M + M-1]}}, w        [i*K2*M + 8*M +: M]  } ;
//
//        mult_sum0d = { {(M+E){data2conv [i*K2*N + 0*N + N-1]}}, data2conv[i*K2*N + 0*N +: N]  } ;
//        mult_sum1d = { {(M+E){data2conv [i*K2*N + 1*N + N-1]}}, data2conv[i*K2*N + 1*N +: N]  } ;
//        mult_sum2d = { {(M+E){data2conv [i*K2*N + 2*N + N-1]}}, data2conv[i*K2*N + 2*N +: N]  } ;
//        mult_sum3d = { {(M+E){data2conv [i*K2*N + 3*N + N-1]}}, data2conv[i*K2*N + 3*N +: N]  } ;
//        mult_sum4d = { {(M+E){data2conv [i*K2*N + 4*N + N-1]}}, data2conv[i*K2*N + 4*N +: N]  } ;
//        mult_sum5d = { {(M+E){data2conv [i*K2*N + 5*N + N-1]}}, data2conv[i*K2*N + 5*N +: N]  } ;
//        mult_sum6d = { {(M+E){data2conv [i*K2*N + 6*N + N-1]}}, data2conv[i*K2*N + 6*N +: N]  } ;
//        mult_sum7d = { {(M+E){data2conv [i*K2*N + 7*N + N-1]}}, data2conv[i*K2*N + 7*N +: N]  } ;
//        mult_sum8d = { {(M+E){data2conv [i*9*N + 8*N + N]}}, data2conv[i*9*N + 8*N +: N]  } ;
//
//        mult_sum0w = { {(N+E){w         [i*K2*M + 0*M + M-1]}}, w        [i*K2*M + 0*M +: M]  } ;
//        mult_sum1w = { {(N+E){w         [i*K2*M + 1*M + M-1]}}, w        [i*K2*M + 1*M +: M]  } ;
//        mult_sum2w = { {(N+E){w         [i*K2*M + 2*M + M-1]}}, w        [i*K2*M + 2*M +: M]  } ;
//        mult_sum3w = { {(N+E){w         [i*K2*M + 3*M + M-1]}}, w        [i*K2*M + 3*M +: M]  } ;
//        mult_sum4w = { {(N+E){w         [i*K2*M + 4*M + M-1]}}, w        [i*K2*M + 4*M +: M]  } ;
//        mult_sum5w = { {(N+E){w         [i*K2*M + 5*M + M-1]}}, w        [i*K2*M + 5*M +: M]  } ;
//        mult_sum6w = { {(N+E){w         [i*K2*M + 6*M + M-1]}}, w        [i*K2*M + 6*M +: M]  } ;
//        mult_sum7w = { {(N+E){w         [i*K2*M + 7*M + M-1]}}, w        [i*K2*M + 7*M +: M]  } ;
//        mult_sum8w = { {(N+E){w         [i*9*M + 8*M + M]}}, w        [i*9*M + 8*M +: M]  } ;
//  end

  always @(posedge clk)
  //always @(data2conv,w)
  begin  
  //    mult_sum_d <=  mult_sum;
  //    //if (mult_sum_d ==  UUT.csa_s_res)
  //    if (mult_sum_d ==  UUT.d_calc_d)  // CL_IN = 1
  //      err = 0;
  //    else
  //      err = 1;
  end


//  if (rst) begin
//    en_out <= 1'b0;
//  end else begin
//    en_out <= en_calc_d;
//  end 

 endmodule  