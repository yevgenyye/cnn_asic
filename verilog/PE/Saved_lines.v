 `timescale 1 ns/10 ps 

 module Saved_lines    #(
    parameter LINES  = 16, // line size of input frame
    parameter N      = 4,  // input data width
    parameter M      = 4,  // input weight width
    parameter USE_MEM= 0   // 1/0  
) (
    input wire            clk      ,
    input wire            rst      ,
    input wire  [  N-1:0] d_in     ,
    input wire            en_in    ,

    input wire  [  M-1:0] w_in     ,
    input  wire           w_conf   , // w_in configuration enable ( 9 clocks)
    output reg  [  M-1:0] w_out    ,

    output wire [9*N-1:0] d_grp    ,
    output wire [9*M-1:0] w_grp     
);

 

//FIFOs
//reg [7:0]  buf1, buf2 [LINES -2 : 0];
reg [      N -1 : 0]   d_1_1,  d_1_2,  d_1_3;
reg [      N -1 : 0]   d_2_1,  d_2_2,  d_2_3;
reg [      N -1 : 0]   d_3_1,  d_3_2,  d_3_3;
reg                   en_1_1, en_1_2, en_1_3;
reg                   en_2_1, en_2_2, en_2_3;
reg                   en_3_1, en_3_2, en_3_3;
reg [      M -1 : 0]   w_1_1,  w_1_2,  w_1_3;
reg [      M -1 : 0]   w_2_1,  w_2_2,  w_2_3;
reg [      M -1 : 0]   w_3_1,  w_3_2,  w_3_3;

//localparam N1  = 4;
localparam N1  = (N <=4 ) ? 4 : 8;
localparam M1  = 8;
localparam W1  = 256;
localparam LINSIZE = W1 -2;
localparam DELAY  = 1;

    wire  [1:0] WTSEL;
    wire  [1:0] RTSEL;
    wire  VG, VS;
    wire  CEBA, WEBB, CEBB;
    wire  [N1 -1:0] BWEBA, BWEBB;
//    reg   [W1-1:0] in_count;
//    reg   in1_flag, out1_flag;
    wire   [M1-1:0] AA1, AA2;
    wire   [M1-1:0] AB1, AB2 ;
    wire         WEBA1, WEBA2;
    reg   [N1-1:0] DA1, DA2;
    reg   [N1-1:0] DB1, DB2;
    wire  [N1-1:0] QA1, QA2;
    wire  [N1-1:0] QB1, QB2;
    wire           rd_smp1, rd_smp2;
/////////////////////////////
//         WTSEL <= 2'b01 ;
//          RTSEL <= 2'b01 ;
//          VG <= 1'b1;
//          VS <= 1'b1;
//
//// Input-Output declarations
//        AA    <= { {(M-1){1'b0}}, 1'd1 };
//        AB    <= { {(M-1){1'b0}}, 1'd1 };
//        DA    <=   {(N){1'b0}};
//        DB    <=   {(N){1'b0}};
//        BWEBA <=   {(N){1'b0}};
//        WEBA  <= 1'b1;  // active low signal
//        CEBA  <= 1'b0; // enable must be 0
//        AB    <= { {(M-1){1'b0}}, 1'd1 };
//        DB    <=   {(N){1'b0}};
//        BWEBB <=   {(N){1'b0}};
//        WEBB  <= 1'b1;  // active low signal
//        CEBB  <= 1'b0; // enable must be 0
/////////////////////////////
    assign  WTSEL = 2'b01 ;
    assign  RTSEL = 2'b01 ;
    assign  VG    = 1'b1;
    assign  VS    = 1'b1;
    //assign  WEBA  = 1'b1; // active low signal
    assign  CEBA  = 1'b0; // enable must be 0
    assign  WEBB  = 1'b1; // active low signal
    assign  CEBB  = 1'b0; // enable must be 0
    assign  BWEBA = {(N1){1'b0}};
    assign  BWEBB = {(N1){1'b0}};
    //assign  AB    = {(M1){1'b0}};

generate
   if (N1 == 4)
      begin : gen_l
      TSDN28HPCA256X4M8FW   
      lin_4b_1
         (
          .WTSEL(WTSEL),
          .RTSEL(RTSEL),
          .VG   (VG   ),
          .VS   (VS   ),
          .AA   (AA1  ), // addr portA
          .DA   (DA1  ), // data portA 
          .BWEBA(BWEBA),
          .WEBA (WEBA1),
          .CEBA (CEBA ),
          .CLKA (clk  ),
          .AB   (AB1  ),
          .DB   (DB1  ),
          .BWEBB(BWEBB),
          .WEBB (WEBB ),
          .CEBB (CEBB ),
          .CLKB (clk  ),
          .QA   (QA1  ),
          .QB   (QB1  )
        );
      
      TSDN28HPCA256X4M8FW   
      lin_4b_2
         (
          .WTSEL(WTSEL),
          .RTSEL(RTSEL),
          .VG   (VG   ),
          .VS   (VS   ),
          .AA   (AA2  ),
          .DA   (DA2  ),
          .BWEBA(BWEBA),
          .WEBA (WEBA2),
          .CEBA (CEBA ),
          .CLKA (clk  ),
          .AB   (AB2  ),
          .DB   (DB2  ),
          .BWEBB(BWEBB),
          .WEBB (WEBB ),
          .CEBB (CEBB ),
          .CLKB (clk  ),
          .QA   (QA2  ),
          .QB   (QB2  )
        );
   end
   else
   begin
      TSDN28HPCA256X8M8FW   
      lin_8b_1
         (
          .WTSEL(WTSEL),
          .RTSEL(RTSEL),
          .VG   (VG   ),
          .VS   (VS   ),
          .AA   (AA1  ), // addr portA
          .DA   (DA1  ), // data portA 
          .BWEBA(BWEBA),
          .WEBA (WEBA1),
          .CEBA (CEBA ),
          .CLKA (clk  ),
          .AB   (AB1  ),
          .DB   (DB1  ),
          .BWEBB(BWEBB),
          .WEBB (WEBB ),
          .CEBB (CEBB ),
          .CLKB (clk  ),
          .QA   (QA1  ),
          .QB   (QB1  )
        );
      
      TSDN28HPCA256X8M8FW   
      lin_8b_2
         (
          .WTSEL(WTSEL),
          .RTSEL(RTSEL),
          .VG   (VG   ),
          .VS   (VS   ),
          .AA   (AA2  ),
          .DA   (DA2  ),
          .BWEBA(BWEBA),
          .WEBA (WEBA2),
          .CEBA (CEBA ),
          .CLKA (clk  ),
          .AB   (AB2  ),
          .DB   (DB2  ),
          .BWEBB(BWEBB),
          .WEBB (WEBB ),
          .CEBB (CEBB ),
          .CLKB (clk  ),
          .QA   (QA2  ),
          .QB   (QB2  )
        );
   end
endgenerate 

Fifo_ctrl  #(
  .DELAY   (DELAY  ),
  .LINSIZE (LINSIZE),
  .N       (M1     )
) 
Fctrl1
(
  .clk     (clk    ), 
  .rst     (rst    ), 
  .en_in   (en_1_2 ),
  .AA      (AA1    ),
  .AB      (AB1    ),
  .WEBA    (WEBA1  ),
  .rd_smp  (rd_smp1)
);

Fifo_ctrl  #(
  .DELAY   (DELAY  ),
  .LINSIZE (LINSIZE),
  .N       (M1     )
) 
Fctrl2
(
  .clk     (clk    ), 
  .rst     (rst    ), 
  .en_in   (en_2_2 ),
  .AA      (AA2    ),
  .AB      (AB2    ),
  .WEBA    (WEBA2  ),
  .rd_smp  (rd_smp2)
);
// FIFO organisation
always @(posedge clk)
   if (en_in) begin
      d_1_1      <= d_in     ;
      d_1_2      <= d_1_1    ;
      d_1_3      <= d_1_2    ;
      if (USE_MEM == 1)
        begin
        DA1      <= #DELAY d_1_3;
        d_2_1    <= QB1  ;
        end
      else
        d_2_1         <= d_1_3;
      d_2_2      <= d_2_1    ;
      d_2_3      <= d_2_2    ;
      if (USE_MEM == 1)
        begin
        DA2      <= #DELAY d_2_3;
        d_3_1    <= QB2  ;
        end
      else
        d_3_1          <= d_2_3;
      d_3_2      <= d_3_1    ;
      d_3_3      <= d_3_2    ;
   end 

always @(posedge clk, rst) // or rst)
   if (rst) begin
      en_1_1 <= 1'b0;
      en_1_2 <= 1'b0;
      en_1_3 <= 1'b0;
      en_2_1 <= 1'b0;
      en_2_2 <= 1'b0;
      en_2_3 <= 1'b0;
      en_3_1 <= 1'b0;
      en_3_2 <= 1'b0;
      en_3_3 <= 1'b0;
   end else begin
      en_1_1 <= en_in     ;
      en_1_2 <= en_1_1    ;
      en_1_3 <= en_1_2    ;

      if (USE_MEM == 1)
        en_2_1    <= rd_smp1 ;
      else
        en_2_1    <= en_1_3;
      en_2_2 <= en_2_1    ;
      en_2_3 <= en_2_2    ;


      if (USE_MEM == 1)
        en_3_1    <= rd_smp2 ;
      else
        en_3_1    <= en_3_3;
      en_3_2 <= en_3_1    ;
      en_3_3 <= en_3_2    ;
end // always if

//always @(posedge clk, rst) // or rst)
// if (rst) begin
//   AA1       <= {(M1){1'b0}};
//   AB1       <= {(M1){1'b0}};
//   AA2       <= {(M1){1'b0}};
//   WEBA1     <= 1'b1;
//   WEBA2     <= 1'b1;
//   in_count  <= 1'b0;
//   //en_flag   <= 1'b1;
//   in1_flag  <= 1'b1;
//   out1_flag <= 1'b1;
// end else begin
//   if (en_in) begin
//      if (in_count == 2)
//        in1_flag  <= 1'b0;
//      if (in1_flag  == 1'b0)
//      begin
//        AA1   <= #DELAY  AA1 +1;
//        WEBA1 <= #DELAY  1'b0;
//      end
//      if (out1_flag == 1'b1)
//         if (in_count == LINSIZE)
//            out1_flag <= #DELAY 1'b0;
//         else
//            in_count <= in_count + 1;
//      else
//        AB1 <= #DELAY AB1 +1;
//   end
//   else
//      WEBA1 <= #DELAY 1'b1;
//end // always

always @(posedge clk)
   if (w_conf) begin
      w_1_1      <= w_in     ;
      w_1_2      <= w_1_1    ;
      w_1_3      <= w_1_2    ;
      w_2_1      <= w_1_3    ;
      w_2_2      <= w_2_1    ;
      w_2_3      <= w_2_2    ;
      w_3_1      <= w_2_3    ;
      w_3_2      <= w_3_1    ;
      w_3_3      <= w_3_2    ;
      w_out      <= w_3_3    ;
   end 

assign d_grp = {d_1_1, d_1_2, d_1_3, d_2_1, d_2_2, d_2_3, d_3_1, d_3_2, d_3_3 };
assign w_grp = {w_1_1, w_1_2, w_1_3, w_2_1, w_2_2, w_2_3, w_3_1, w_3_2, w_3_3 };


endmodule  
