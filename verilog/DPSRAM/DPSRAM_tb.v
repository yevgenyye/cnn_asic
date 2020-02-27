 `timescale 1 ns/1 ps 

 module DPSRAM_tb (); 

parameter  N = 4;
parameter  W = 256;
parameter  M = 8;
    reg                 clk        ;
    reg                 rst        ;

    wire SLP=1'b0;
    wire DSLP=1'b0;
    wire SD=1'b0;
    reg  [1:0] WTSEL;
    reg  [1:0] RTSEL;
    reg  VG;
    reg  VS;

// Input-Output declarations
    reg  [M-1:0] AA;
    reg  [N-1:0] DA;
    reg  [N-1:0] BWEBA;

    reg  WEBA;
    reg  CEBA;
    wire  CLKA;
    reg  [M-1:0] AB;
    reg  [N-1:0] DB;
    reg  [N-1:0] BWEBB;
    reg  WEBB;
    reg  CEBB;
    wire  CLKB;
    wire [N-1:0] QA;
    wire [N-1:0] QB;


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


TSDN28HPCA256X4M8FW   
UUT
   (
    .WTSEL(WTSEL),
    .RTSEL(RTSEL),
    .VG   (VG   ),
    .VS   (VS   ),
    .AA   (AA   ),
    .DA   (DA   ),
    .BWEBA(BWEBA),
    .WEBA (WEBA ),
    .CEBA (CEBA ),
    .CLKA (CLKA ),
    .AB   (AB   ),
    .DB   (DB   ),
    .BWEBB(BWEBB),
    .WEBB (WEBB ),
    .CEBB (CEBB ),
    .CLKB (CLKB ),
    .QA   (QA   ),
    .QB   (QB   )
  );

assign CLKA =  clk;
assign CLKB =  clk;

always 
begin
    clk = 1'b1; 
    #10; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #10; // low for 20 * timescale = 20 ns
end

     initial // initial block executes only once
        begin
          WTSEL <= 2'b01 ;
          RTSEL <= 2'b01 ;
          VG <= 1'b1;
          VS <= 1'b1;

// Input-Output declarations
        AA    <= { {(M-1){1'b0}}, 1'd1 };
        AB    <= { {(M-1){1'b0}}, 1'd1 };
        DA    <=   {(N){1'b0}};
        DB    <=   {(N){1'b0}};
        BWEBA <=   {(N){1'b0}};
        WEBA  <= 1'b1;  // active low signal
        CEBA  <= 1'b0; // enable must be 0
        AB    <= { {(M-1){1'b0}}, 1'd1 };
        DB    <=   {(N){1'b0}};
        BWEBB <=   {(N){1'b0}};
        WEBB  <= 1'b1;  // active low signal
        CEBB  <= 1'b0; // enable must be 0
        
        rst   <= 1'b1; 
        #30;
        WEBA  <= 1'b0;
        for(j=0; j< 5; j=j+1) 
        begin
           AA <= AA + 1; 
           DA <= DA + 1;
           #20;
        end
        WEBA  <= 1'b1;
        AA    <= 0;
        #20;
        for(j=0; j< 5; j=j+1) 
        begin
           AA <= AA + 1; 
           DA <= DA + 1;
           #20;
        end
        AA    <=   {(N){1'b0}};
        for(j=0; j< 10; j=j+1) 
        begin
           AA <= AA + 1; 
           #20;
        end
        #20;
        for(j=0; j< 10; j=j+1) 
        begin
           AB <= AB + 1; 
           #20;
        end


  
         //   #period;
        end







//  if (rst) begin
//    en_out <= 1'b0;
//  end else begin
//    en_out <= en_calc_d;
//  end 

 endmodule  