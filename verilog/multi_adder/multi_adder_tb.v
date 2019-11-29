  `timescale 1 ns/10 ps 

 module multi_adder_tb ();
    parameter CL_IN = 8;  // number of inputs features
    parameter RELU  = 0;
    parameter N     = 4;  // input/output data width
    parameter SR    = 1;  // data shift right before output


    reg               clk   ;
    reg               rst   ;
    reg [CL_IN*N-1:0] d_in  ;
    reg               en_in ;
    wire [N-1:0]      d_out ;
    wire              en_out;   

    localparam period = 20;

    integer          j,i;
    reg    [N-1:0] d_val; 


multi_adder #(
  .CL_IN (CL_IN), 
  .RELU  (RELU ),
  .N     (N    ), 
  .SR    (SR   )     
   ) 
   UUT
   (
  .clk   (clk   ), 
  .rst   (rst   ), 
  .d_in  (d_in  ), 
  .en_in (en_in ), 
  .d_out (d_out ), 
  .en_out(en_out) 
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
     d_val <= 8'b1; //{ {(N-1){1'b0}}, 1'd1 };
     d_in  <= {(N){1'b0}};
     #20;
     rst <= 1'b0; 
     #20;
     en_in <= 1'b1;
     for(j=0; j<100; j=j+1) 
     begin
        for(i=0; i<CL_IN; i=i+1) 
           d_in[i*N +: N] <= d_val + i;
        d_val <= d_val + 1;
        #20;
     end
     en_in <= 1'b0;
      //   #period;
   end



endmodule