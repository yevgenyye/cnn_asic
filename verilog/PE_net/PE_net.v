 module PE_net  #(
    parameter LIN_SIZE = 4, // PE array size
    parameter ROW_SIZE = 4, // PE array size
    parameter LINES  = 16, // line size of input frame
    parameter MULT   = 0, // 1/0 -> Multiplier by FullAdders / * (both 2's compliment) 
    parameter useCLA = 1, // 0/1  -> use ripleCarry/CLA
    parameter CL_IN  = 4,  // number of in/out-puts feature
    parameter CL1    = 2,  // bus width of bp_src_in/out
 //   parameter KERNEL = 3,  // 1/3/5/7
    parameter RELU   = 1,  // 0 - no relu, 1 - relu, only positive output values
    parameter N      = 4,  // input data width
    parameter M      = 2,  // input weight width
    parameter SR     = 2   // data shift right before output

) (
    input wire                         clk     ,
    input wire                         rst     ,
    input wire  [ROW_SIZE*N      -1:0] d_in    ,
    input wire  [ROW_SIZE        -1:0] en_in   ,
    input  wire [ROW_SIZE*CL_IN  -1:0] d_ch_in , // data input enable channel
    input wire  [ROW_SIZE*M      -1:0] w_in    ,
// data output
    output wire [ROW_SIZE*N-1:0] d_out    ,
    output wire [ROW_SIZE  -1:0] en_out   ,
// configuration signals
    input  wire               w_conf    , // w_in configuration enable ( 9 clocks)
    //output wire [ROW_SIZE*CL_IN*M-1:0] w_out     ,

    input  wire               cntl_conf  , // control configuration enable ( 1 clock )
    input  wire [ROW_SIZE*CL_IN-1:0]   bp_ch_in   , // bypass output channel
    input  wire [ROW_SIZE*CL1  -1:0]   bp_src_in    // bypass source channel
    //output reg  [ROW_SIZE*CL_IN-1:0]   d_ch_out   , // enable channel
    //output reg  [ROW_SIZE*CL_IN-1:0]   bp_ch_out  , // bypass channel
    //output reg  [ROW_SIZE*CL1  -1:0]   bp_src_out   // bypass source channel

);


//localparam USE_MEM = 0; // no memory
genvar          i,j;

wire  [(ROW_SIZE+1)*(LIN_SIZE+1)*N -1:0] d0, d1, d2, d3; 

wire  [(ROW_SIZE+1)*(LIN_SIZE+1)*CL_IN*N -1:0] d_int; 
wire  [(ROW_SIZE+1)*(LIN_SIZE+1)*CL_IN   -1:0] en_int;
wire  [(ROW_SIZE+1)*(LIN_SIZE+1)      *M -1:0] w_int;
wire  [(ROW_SIZE+1)*(LIN_SIZE+1)*CL_IN   -1:0] d_ch_int;
wire  [(ROW_SIZE+1)*(LIN_SIZE+1)*CL_IN   -1:0] bp_ch_int; 
wire  [(ROW_SIZE+1)*(LIN_SIZE+1)*CL1     -1:0] bp_src_int;


generate 

   for (j = 1; j <= ROW_SIZE; j = j + 1) begin : gen_row0
  //    for (i = 1; i <= LIN_SIZE; i = i + 1) begin : gen_line
         PE #(
            .LINES (LINES ), 
            .MULT  (MULT  ),
            .useCLA(useCLA),
            .CL_IN (CL_IN ),
            .CL1   (CL1   ),
            .RELU  (RELU  ),
            .N     (N     ),
            .M     (M     ),
            .SR    (SR    ) 
         )   PEnet   (
            .clk        (clk                  )   ,
            .rst        (rst                  ),
            .d_in       ({ d_int    [ (j+1)*LIN_SIZE*CL_IN*N     +  1   *CL_IN    *N + 0*N  +: N ]  ,
                           d_int    [  j   *LIN_SIZE*CL_IN*N     + (1+1)*CL_IN    *N + 1*N  +: N ]  ,
                           d_int    [ (j-1)*LIN_SIZE*CL_IN*N     +  1   *CL_IN    *N + 2*N  +: N ]  ,
                           d_in      [(j-1)*N  +:N]  } ) , //d_int    [  j   *LIN_SIZE*CL_IN*N     + (1-1)*CL_IN    *N + 3*N  +: N ]  } ) , 
            .en_in      ({ en_int   [ (j+1)*LIN_SIZE*CL_IN       +  1   *CL_IN       + 0         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       + (1+1)*CL_IN       + 1         ]  ,
                           en_int   [ (j-1)*LIN_SIZE*CL_IN       +  1   *CL_IN       + 2         ]  ,
                           en_in    [ (j-1)   ]                                         } ) , //en_int   [  j   *LIN_SIZE*CL_IN       + (1-1)*CL_IN       + 3         ]  } ) , 
            .d_ch_in    (d_ch_in    [ (j-1)             *CL_IN   +: CL_IN  ]                                    ),//(d_ch_int   [  j   *(LIN_SIZE+1)*CL_IN   + (1-1)*CL_IN       +:  CL_IN   ] ), 
            .d_ch_out   (d_ch_int   [  j   *LIN_SIZE*CL_IN       +  1   *CL_IN       +:  CL_IN   ] ),
            .d_out      (d_int      [  j   *LIN_SIZE*CL_IN*N     +  1   *CL_IN*N     +:  CL_IN*N ] ),  
            .en_out     ({ en_int   [  j   *LIN_SIZE*CL_IN       +  1   *CL_IN       + 0         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       +  1   *CL_IN       + 1         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       +  1   *CL_IN       + 2         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       +  1   *CL_IN       + 3         ]  }),
            .w_conf     (w_conf                                                                    ),
            .w_in       (w_in       [ (j-1)                   *M        +:  M]), //(w_int      [  j   *(LIN_SIZE+1)*CL_IN*M + (1-1)*CL_IN*M     +:  CL_IN*M ] ), 
            .w_out      (w_int      [  j   *LIN_SIZE          *M + 1* M +:  M ] ), 
            .cntl_conf  (cntl_conf                                                                 ),
            .bp_ch_in   (bp_ch_in   [(j-1) *CL_IN +: CL_IN]  ), //(bp_ch_int  [ j    *(LIN_SIZE+1)*CL_IN   + (1-1)*CL_IN       +:  CL_IN   ] ),  
            .bp_ch_out  (bp_ch_int  [ j    *LIN_SIZE*CL_IN   +  1   *CL_IN       +:  CL_IN   ] ),
            .bp_src_in  (bp_src_in  [(j-1) * CL1 +: CL1] ), //(bp_src_int [ j    *(LIN_SIZE+1)*CL1     + (1-1)*CL1         +:  CL1     ] ),  
            .bp_src_out (bp_src_int [ j    *LIN_SIZE*CL1     +  1   *CL1         +:  CL1     ] )
         );
  //    end // for
   end // for


   for (j = 1; j <= ROW_SIZE; j = j + 1) begin : gen_row
      for (i = 2; i <= LIN_SIZE; i = i + 1) begin : gen_line
         PE #(
            .LINES (LINES ), 
            .MULT  (MULT  ),
            .useCLA(useCLA),
            .CL_IN (CL_IN ),
            .CL1   (CL1   ),
            .RELU  (RELU  ),
            .N     (N     ),
            .M     (M     ),
            .SR    (SR    ) 
         )   PEnet   (
            .clk        (clk                  )   ,
            .rst        (rst                  ),
            .d_in       ({ d_int    [ (j+1)*LIN_SIZE*CL_IN*N     +  i   *CL_IN    *N + 0*N  +: N ]  ,
                           d_int    [  j   *LIN_SIZE*CL_IN*N     + (i+1)*CL_IN    *N + 1*N  +: N ]  ,
                           d_int    [ (j-1)*LIN_SIZE*CL_IN*N     +  i   *CL_IN    *N + 2*N  +: N ]  ,
                           d_int    [  j   *LIN_SIZE*CL_IN*N     + (i-1)*CL_IN    *N + 3*N  +: N ]  } ) , 
            .en_in      ({ en_int   [ (j+1)*LIN_SIZE*CL_IN       +  i   *CL_IN       + 0         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       + (i+1)*CL_IN       + 1         ]  ,
                           en_int   [ (j-1)*LIN_SIZE*CL_IN       +  i   *CL_IN       + 2         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       + (i-1)*CL_IN       + 3         ]  } ) , 
            .d_ch_in    (d_ch_int   [  j   *LIN_SIZE*CL_IN       + (i-1)*CL_IN       +:  CL_IN   ] ), 
            .d_ch_out   (d_ch_int   [  j   *LIN_SIZE*CL_IN       +  i   *CL_IN       +:  CL_IN   ] ),
            .d_out      (d_int      [  j   *LIN_SIZE*CL_IN*N     +  i   *CL_IN*N     +:  CL_IN*N ] ),  
            .en_out     ({ en_int   [  j   *LIN_SIZE*CL_IN       +  i   *CL_IN       + 0         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       +  i   *CL_IN       + 1         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       +  i   *CL_IN       + 2         ]  ,
                           en_int   [  j   *LIN_SIZE*CL_IN       +  i   *CL_IN       + 3         ]  }),
            .w_conf     (w_conf                                                                    ),
            .w_in       (w_int      [  j   *LIN_SIZE*M           + (i-1)*M           +:        M ] ), 
            .w_out      (w_int      [  j   *LIN_SIZE*M           +  i   *M           +:        M ] ), 
            .cntl_conf  (cntl_conf                                                                 ),
            .bp_ch_in   (bp_ch_int  [ j    *LIN_SIZE*CL_IN       + (i-1)*CL_IN       +:  CL_IN   ] ),  
            .bp_ch_out  (bp_ch_int  [ j    *LIN_SIZE*CL_IN       +  i   *CL_IN       +:  CL_IN   ] ),
            .bp_src_in  (bp_src_int [ j    *LIN_SIZE*CL1         + (i-1)*CL1         +:  CL1     ] ),  
            .bp_src_out (bp_src_int [ j    *LIN_SIZE*CL1         +  i   *CL1         +:  CL1     ] )
         );
      end // for


assign d_out [(j-1)*N +:N] =  d_int      [ j *LIN_SIZE*CL_IN*N +  (LIN_SIZE+1)   *CL_IN*N + 1 +: N ];
assign en_out[ j-1       ] =  en_int     [ j *LIN_SIZE*CL_IN   +  (LIN_SIZE+1)   *CL_IN   + 1      ];
   end // for

//    for (j = 1; j <= ROW_SIZE; j = j + 1) begin : gen_rowlast
//   //   for (i = 2; i <= LIN_SIZE; i = i + 1) begin : gen_line
//         PE #(
//            .LINES (LINES ), 
//            .MULT  (MULT  ),
//            .useCLA(useCLA),
//            .CL_IN (CL_IN ),
//            .CL1   (CL1   ),
//            .RELU  (RELU  ),
//            .N     (N     ),
//            .M     (M     ),
//            .SR    (SR    ) 
//         )   PEnet   (
//            .clk        (clk                  )   ,
//            .rst        (rst                  ),
//            .d_in       ({ d_int    [ (j+1)*LIN_SIZE*CL_IN*N     +  LIN_SIZE   *CL_IN    *N + 0*N  +: N ]  ,
//                           d_int    [  j   *LIN_SIZE*CL_IN*N     + (LIN_SIZE+1)*CL_IN    *N + 1*N  +: N ]  ,
//                           d_int    [ (j-1)*LIN_SIZE*CL_IN*N     +  LIN_SIZE   *CL_IN    *N + 2*N  +: N ]  ,
//                           d_int    [  j   *LIN_SIZE*CL_IN*N     + (LIN_SIZE-1)*CL_IN    *N + 3*N  +: N ]  } ) , 
//            .en_in      ({ en_int   [ (j+1)*LIN_SIZE*CL_IN       +  LIN_SIZE   *CL_IN       + 0         ]  ,
//                           en_int   [  j   *LIN_SIZE*CL_IN       + (LIN_SIZE+1)*CL_IN       + 1         ]  ,
//                           en_int   [ (j-1)*LIN_SIZE*CL_IN       +  LIN_SIZE   *CL_IN       + 2         ]  ,
//                           en_int   [  j   *LIN_SIZE*CL_IN       + (LIN_SIZE-1)*CL_IN       + 3         ]  } ) , 
//            .d_ch_in    (d_ch_int   [  j   *(LIN_SIZE+1)*CL_IN   + (LIN_SIZE-1)*CL_IN       +:  CL_IN   ] ), 
//            .d_ch_out   (d_ch_int   [  j   *(LIN_SIZE+1)*CL_IN   +  LIN_SIZE   *CL_IN       +:  CL_IN   ] ),
//            .d_out      (d_int      [  j   *(LIN_SIZE+1)*CL_IN*N +  LIN_SIZE   *CL_IN*N     +:  CL_IN*N ] ),  
//            .en_out     ({ en_int   [  j   *LIN_SIZE*CL_IN       +  LIN_SIZE   *CL_IN       + 0         ]  ,
//                           en_int   [  j   *LIN_SIZE*CL_IN       +  LIN_SIZE   *CL_IN       + 1         ]  ,
//                           en_out , //en_int   [  j   *LIN_SIZE*CL_IN       +  LIN_SIZE   *CL_IN       + 2         ]  ,
//                           en_int   [  j   *LIN_SIZE*CL_IN       +  LIN_SIZE   *CL_IN       + 3         ]  }),
//            .w_conf     (w_conf                                                                   ),
//            .w_in       (w_int      [  j   *(LIN_SIZE+1)*CL_IN*M + (LIN_SIZE-1)*CL_IN*M     +:  CL_IN*M ] ), 
//            .w_out      (w_int      [  j   *(LIN_SIZE+1)*CL_IN*M +  LIN_SIZE   *CL_IN*M     +:  CL_IN*M ] ), 
//            .cntl_conf  (cntl_conf                                                                ),
//            .bp_ch_in   (bp_ch_int  [ j    *(LIN_SIZE+1)*CL_IN   + (LIN_SIZE-1)*CL_IN       +:  CL_IN   ] ),  
//            .bp_ch_out  (bp_ch_int  [ j    *(LIN_SIZE+1)*CL_IN   +  LIN_SIZE   *CL_IN       +:  CL_IN   ] ),
//            .bp_src_in  (bp_src_int [ j    *(LIN_SIZE+1)*CL1     + (LIN_SIZE-1)*CL1         +:  CL1     ] ),  
//            .bp_src_out (bp_src_int [ j    *(LIN_SIZE+1)*CL1     +  LIN_SIZE   *CL1         +:  CL1     ] )
//         );
//    //  end // for
//   end // for
//
//for (j = 1; j <= ROW_SIZE; j = j + 1) begin : gen_row_init
//  assign d_int      [(j-1)    *LIN_SIZE*CL_IN*N +  0   *CL_IN*N  +: CL_IN*N ] = d_in [(j-1)*N  +:N]      ; //[ROW_SIZE*N      -1:0]
//  assign en_int     [(j-1) *(LIN_SIZE+1)*CL_IN   +  0                        ] = en_in [j-1]; //[(ROW_SIZE+1)*(LIN_SIZE+2)*CL_IN*N -1:0]
//  assign w_int      [  j   *(LIN_SIZE+1)*CL_IN*M +  0   *CL_IN*M  +: CL_IN*M ] = w_in     ;
//  assign d_ch_int   [  j   *(LIN_SIZE+1)*CL_IN   +  0   *CL_IN    +: CL_IN   ] = d_ch_in  ;
//  assign bp_ch_int  [ j    *(LIN_SIZE+1)*CL_IN   +  0   *CL_IN    +: CL_IN   ] = bp_ch_in ; 
//  assign bp_src_int [ j    *(LIN_SIZE+1)*CL1     +  0   *CL1      +: CL1     ] = bp_src_in;
// end // for

                   //[(ROW_SIZE+1)*(LIN_SIZE+2)*CL_IN*N -1:0]
//assign en_int     [1   *(LIN_SIZE+2)*CL_IN   +  0                        ] = en_in [0];
//assign en_int     [2   *(LIN_SIZE+2)*CL_IN   +  0                        ] = en_in [0];
//assign en_int     [0   *(LIN_SIZE+2)*CL_IN   +  0                        ] = en_in [0];
endgenerate

//assign en_out = en_int[1];

 endmodule  
