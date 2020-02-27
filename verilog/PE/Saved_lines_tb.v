 `timescale 1 ns/10 ps 

 module Saved_lines_tb (); 

    parameter LINES  = 16; // line size of input frame
    parameter N      = 6 ; // input data width
    parameter M      = 4 ; // input weight width
    parameter USE_MEM= 1 ; // 1/0  

    reg            clk     ;
    reg            rst     ;
    reg  [  N-1:0] d_in    ;
    reg            en_in   ;
    reg  [  M-1:0] w_in    ;
    reg            w_conf  ; // w_in configuration enable ( 9 clocks)
    wire [  M-1:0] w_out   ;
    wire [9*N-1:0] d_grp   ;
    wire [9*M-1:0] w_grp   ;



integer           i,j,k;
reg    [N-1:0] d_val; 
reg    [M-1:0] w_val; 
reg     err;

    localparam period = 20;
    localparam KERNEL = 3;
    localparam CL_IN  = 4;

 initial begin
   // $display($time, " TB, d_out port size | width= %d", N+M+E2);
 end


Saved_lines  #(
  .LINES  (LINES  ) , 
  .N      (N      ) , 
  .M      (M      ) ,
  .USE_MEM(USE_MEM)
) 
UUT
(
  .clk     (clk    ), 
  .rst     (rst    ), 
  .d_in    (d_in   ), 
  .en_in   (en_in  ),
  .w_in    (w_in   ),  
  .w_conf  (w_conf ),
  .w_out   (w_out  ),
  .d_grp   (d_grp  ),
  .w_grp   (w_grp  )
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
          w_conf <=   1'b0;

          en_in     <= 1'b0;
          #20;
          rst <= 1'b0; 
          #20;
          for(i=0; i< KERNEL**2; i=i+1) 
            begin
            w_conf <=   1'b1;
            for(j=0; j< CL_IN; j=j+1) 
               w_in [j*M +: M] <= w_in [j*M +: M] + 1; // + 10;
               //w_in      <= {1'b0,{(M-1){1'b1}}}; //max value 
            #20;
            end
          w_conf <=   1'b0;
          #20;
          #20;
          //en_in <= 1'b1;

          for(j=0; j<3000; j=j+1) 
          begin
             en_in     <= 1'b1;
             for(i=0; i< CL_IN-1; i=i+1) 
              d_in [i*N +: N] <= d_val + i;
             // d_in [i*N +: N] <= {1'b0,{(N-1){1'b1}}};  // maximum positive valie
             //   d_in [i*N +: N] <= {1'b1,{(N-1){1'b0}}};  // minim negative valie
             //   d_in [i*N +: N] <= {1'b1,{(N-1){1'b1}}};  // maximum negative valie (-1)

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