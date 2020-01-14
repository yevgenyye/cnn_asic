 `timescale 1 ns/10 ps 

 module ConvLayer_calc_tb (); 

    parameter MULT   = 1; // 1/0 -> Multiplier by FullAdders / * (default) 
    parameter useCLA = 0;  // 0/1  -> use ripleCarry/CLA
    parameter KERNEL = 3; // 1/3/5/7 ^2  // 9; // 25; // 49; //  
    parameter E      = 3;                // 3; // 4;  // 5 ; // bit extention ( N=9 -> E=3, N=25 -> E=4)
    parameter N      = 4; // input data width
    parameter M      = 4; // input weight width

    reg                        clk       ;
    reg                        rst       ;
    reg  [KERNEL*KERNEL*N-1:0] data2conv ;
    reg                        en_in     ;
    reg  [KERNEL*KERNEL*M-1:0] w         ;
    //wire [N+M+E:0]           d_out     ;
    wire [N+M+E-1:0]            sum      ;
    wire [N+M+E-1:0]            cout     ;
    wire                       en_out    ;

integer           i,j;
reg    [N-1:0] d_val; 
reg    [M-1:0] w_val; 

reg [3:0] tst_a, tst_b;
wire [7:0] tst_ab, tst_mult;


    localparam period = 20;

 ConvLayer_calc #(
.MULT  (MULT)  ,
.useCLA(useCLA),
.KERNEL(KERNEL), 
.E     (E)     , 
.N     (N)     , 
.M     (M)     
) 
 UUT
 (
.clk       (clk      ), 
.rst       (rst      ), 
.data2conv (data2conv), 
.en_in     (en_in    ), 
.w         (w        ), 
.sum       (sum      ), 
.cout      (cout     ), 
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
       // d_val <= { {(N-1){1'b1}}, 1'd0 };
       // w_val <= { {(M-1){1'b1}}, 1'd1 };
          d_val <= { 1'd0, {(N-1){1'b1}} };
          w_val <= { 1'd0, {(M-1){1'b0}} };
          #20;
          rst <= 1'b0; 
          #20;
          en_in <= 1'b1;

          //for(j=0; j<16; j=j+1) 
          //begin
          //   for(i=0; i<16; i=i+1)
          //   begin 
          //       tst_a <= i;
          //       tst_b <= j;
          //       #20;
          //   end
          //end

          for(j=0; j<10; j=j+1) 
          begin
             for(i=0; i<KERNEL**2; i=i+1) 
                data2conv[i*N +: N] <= d_val + i;
             for(i=0; i<KERNEL**2; i=i+1) 
                w        [i*M +: M] <= w_val + i + 1;
             d_val <= d_val + 1;
             w_val <= w_val + 1;
             #20;
          end

  
         //   #period;
        end
// assign  tst_mult = {{(4){tst_a[3]}},tst_a[3:0]}*{{(4){tst_b[3]}},tst_b[3:0]};
// assign  tst_ab = (tst_a[3] == tst_b[3]) ? tst_a*tst_b : ;
 //assign  tst_check = 
 endmodule  