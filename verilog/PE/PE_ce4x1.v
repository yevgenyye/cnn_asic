 module PE    #(
    parameter LINES  = 16, // line size of input frame
    parameter MULT   = 0, // 1/0 -> Multiplier by FullAdders / * (both 2's compliment) 
    parameter useCLA = 1, // 0/1  -> use ripleCarry/CLA
    parameter CL_IN  = 4,  // number of in/out-puts feature
    parameter CL1    = 2,  // bus width of bp_src_in/out
 //   parameter KERNEL = 3,  // 1/3/5/7
    parameter RELU   = 1,  // 0 - no relu, 1 - relu, only positive output values
    parameter N      = 4,  // input data width
    parameter M      = 4,  // input weight width
    parameter SR     = 2   // data shift right before output

) (
    input wire                clk      ,
    input wire                rst      ,
    input wire  [CL_IN*N-1:0] d_in     ,
    input  wire [CL_IN-1:0]   d_ch_in    , // data input enable channel
    input wire  [CL_IN*M-1:0] w_in     ,
// data output
    output wire [CL_IN*N-1:0] d_out    ,
    output wire               en_out   ,
// configuration signals
    input  wire               w_conf    , // w_in configuration enable ( 9 clocks)
    output wire [CL_IN*M-1:0] w_out     ,

    input  wire               cntl_conf  , // control configuration enable ( 1 clock )
    input  wire [CL_IN-1:0]   bp_ch_in   , // bypass output channel
    input  wire [CL1  -1:0]   bp_src_in  , // bypass source channel
    output reg  [CL_IN-1:0]   d_ch_out   , // enable channel
    output reg  [CL_IN-1:0]   bp_ch_out  , // bypass channel
    output reg  [CL1  -1:0]   bp_src_out   // bypass source channel

);
localparam USE_MEM = 0; // no memory

 wire [CL_IN*9*N-1:0] d_grp ;
 wire [CL_IN*9*M-1:0] w_grp ; 

 wire                 en_ce;
 wire [N+M+15-1:0]    ce_d_out;           
 wire                 ce_en_out;

    genvar          i;

wire [(N+M+15)-1 : 0]  d_ce_out;  

reg  [CL_IN*M -1 : 0]  w       ;
reg  [CL_IN   -1 : 0]  bp_ch   ;
reg  [CL_IN   -1 : 0]  d_ch    ;
reg  [CL1     -1 : 0]  bp_src  ;


generate 
   for (i = 0; i < CL_IN; i = i + 1) begin : saved_en
      Saved_lines #(
         .LINES  (LINES), 
         .N      (N),
         .M      (M),
         .USE_MEM(USE_MEM)       
      )   d_w_fifo1   (
         .clk    (clk                  )   ,
         .d_in   (d_in   [i*N   +:   N])   ,
         .en_in  (d_ch   [i]           )   ,
         .w_in   (w_in   [i*M   +:   M])   ,
         .w_conf (w_conf               )   ,
         .w_out  (w_out  [i*M   +:   M])   ,
         .d_grp  (d_grp  [i*9*N +: 9*N])   ,
         .w_grp  (w_grp  [i*9*M +: 9*M]) 
      );
    end // for
endgenerate

assign en_ce = (d_ch == 4'b0000) ? 1'b0 : 1'b1;

      CE #(
         .MULT  (MULT  ),    
         .useCLA(useCLA), 
         .CL_IN (CL_IN ), 
         .KERNEL(3     ), 
         .RELU  (RELU  ), 
         .N     (N     ), 
         .M     (M     ), 
         .SR    (SR    ) 
      )  CE4 (
         .clk      (clk       ) ,
         .rst      (rst       ) ,
         .data2conv(d_grp     ) ,
         .en_in    (en_ce     ) ,
         .w        (w_grp     ) ,
         .d_out    (ce_d_out  ) ,
         .en_out   (ce_en_out )  
      ) ;


    
always @(posedge clk)
   if (cntl_conf) begin
      bp_ch      <= bp_ch_in ;
      d_ch       <= d_ch_in  ;
      bp_src     <= bp_src_in;
      bp_ch_out  <= bp_ch_in ;
      d_ch_out   <= d_ch_in  ;
      bp_src_out <= bp_src_in;
   end 

generate 
   for (i = 0; i < CL_IN; i = i + 1) begin : gen_en
     // assign data            = (d_ch[i]    == 1'b1 ) ? d_in[i*N    +: N] : { (N){1'b0} } ;
      assign d_out[i*N +: N] = (bp_ch[i]   == 1'b0 ) ? ce_d_out  [SR +: N] :
                               (bp_src_out == 2'b00) ? d_in[0*N    +: N] :
                               (bp_src_out == 2'b01) ? d_in[1*N    +: N] :
                               (bp_src_out == 2'b10) ? d_in[2*N    +: N] :
                                                       d_in[3*N    +: N] ;
    end
 endgenerate


 endmodule  
