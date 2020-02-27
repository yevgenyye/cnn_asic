
//*###############################################################################
//*#        Software       : TSMC MEMORY COMPILER 2012.02.00.d
//*#        Technology     : 28 nm CMOS LOGIC High Performance Compact HKMG Cu 1P10M 0.9V
//*#                         SVT logic, cell implant SRAM bit cell
//*#        Memory Type    : TSMC 28nm High Performance Compact Computation Dual Port SRAM
//*#
//*#        Library Name   : tsdn28hpca256x4m8fw
//*#        Library Version: 170a
//*#        Generated Time : 2020/02/20, 13:50:54
//*###############################################################################
//*#
//*# STATEMENT OF USE
//*#
//*# This information contains confidential and proprietary information of TSMC.
//*# No part of this information may be reproduced, transmitted, transcribed,
//*# stored in a retrieval system, or translated into any human or computer
//*# language, in any form or by any means, electronic, mechanical, magnetic,
//*# optical, chemical, manual, or otherwise, without the prior written permission
//*# of TSMC. This information was prepared for informational purpose and is for
//*# use by TSMC's customers only. TSMC reserves the right to make changes in the
//*# information at any time and without notice.
//*#
//*###############################################################################
///****************************************************************************** */
//*      Usage Limitation: PLEASE READ CAREFULLY FOR CORRECT USAGE               */
//* The model doesn't support the control enable, data, address signals transition*/
//* at positive clock edge.                                                      */
//* Please have some timing delays between control/data/address and clock signals*/
//* to ensure the correct behavior.                                              */
//*                                                                              */
//* Please be careful when using non 2^n  memory.                                */
//* In a non-fully decoded array, a write cycle to a nonexistent address location*/
//* does not change the memory array contents and output remains the same.       */
//* In a non-fully decoded array, a read cycle to a nonexistent address location */
//* does not change the memory array contents but output becomes unknown.        */
//*                                                                              */
//* In the verilog model, the behavior of unknown clock will corrupt the         */
//* memory data and make output unknown regardless of CEB signal.  But in the    */
//* silicon, the unknown clock at CEB high, the memory and output data will be   */
//* held. The verilog model behavior is more conservative in this condition.     */
//*                                                                              */
//* The model doesn't identify physical column and row address                   */
//*                                                                              */
//* The verilog model provides UNIT_DELAY mode for the fast function simulation. */
//* All timing values in the specification are not checked in the UNIT_DELAY mode*/
//* simulation.                                                                  */
//*                                                                              */
//* The critical contention timings, tcc, is not checked in the UNIT_DELAY mode  */
//* simulation.  If addresses of read and write operations are the same and the  */
//* real time of the positive edge of CLKA and CLKB are identical the same,      */
//* it will be treated as a read/write port contention.                          */ 
//*                                                                              */
//* Please use the verilog simulator version with $recrem timing check support.  */
//* Some earlier simulator versions might support $recovery only, not $recrem.   */
//*                                                                              */
//* Template Version : S_01_42301                                       */
//****************************************************************************** */
//*      Macro Usage       : (+define[MACRO] for Verilog compiliers)             */
//* +UNIT_DELAY : Enable fast function simulation.                               */
//* +no_warning : Disable all runtime warnings message from this model.          */
//* +TSMC_INITIALIZE_MEM : Initialize the memory data in verilog format.         */
//* +TSMC_INITIALIZE_FAULT : Initialize the memory fault data in verilog format. */
//* +TSMC_NO_TESTPINS_WARNING : Disable the wrong test pins connection error     */
//*                             message if necessary.                            */
//****************************************************************************** */

`resetall
`celldefine

`timescale 1ns/1ps
`delay_mode_path
`suppress_faults
`enable_portfaults

`define SRAM_DELAY 0.010

module TSDN28HPCA256X4M8FW
    (
           WTSEL,
           RTSEL,
           VG,
           VS,
    AA,
    DA,
    BWEBA,
    WEBA,CEBA,CLKA,
    AB,
    DB,
    BWEBB,
    WEBB,CEBB,CLKB,
    QA,
    QB
  );

// Parameter declarations
parameter  N = 4;
parameter  W = 256;
parameter  M = 8;

    wire SLP=1'b0;
    wire DSLP=1'b0;
    wire SD=1'b0;
    input [1:0] WTSEL;
    input [1:0] RTSEL;
    input VG;
    input VS;

// Input-Output declarations
    input [M-1:0] AA;
    input [N-1:0] DA;
    input [N-1:0] BWEBA;

    input WEBA;
    input CEBA;
    input CLKA;
    input [M-1:0] AB;
    input [N-1:0] DB;
    input [N-1:0] BWEBB;
    input WEBB;
    input CEBB;
    input CLKB;
    output [N-1:0] QA;
    output [N-1:0] QB;

`ifdef no_warning
parameter MES_ALL = "OFF";
`else
parameter MES_ALL = "ON";
`endif

`ifdef TSMC_INITIALIZE_MEM
parameter cdeFileInit  = "TSDN28HPCA256X4M8FW_initial.cde";
`endif
`ifdef TSMC_INITIALIZE_FAULT
parameter cdeFileFault = "TSDN28HPCA256X4M8FW_fault.cde";
`endif

// Registers
wire        bSLP;
wire        bSD;
wire        bDSLP;

reg [N-1:0] DAL;
reg [N-1:0] DBL;
 
reg [N-1:0] BWEBAL;
reg [N-1:0] BWEBBL;
 
reg [M-1:0] AAL;
reg [M-1:0] ABL;
 
reg WEBAL,CEBAL;
reg WEBBL,CEBBL;
 
wire [N-1:0] QAL;
wire [N-1:0] QBL;
 
reg valid_cka,valid_ckb,valid_ckm;
reg valid_cea, valid_ceb;
reg valid_wea, valid_web;
reg valid_aa;
reg valid_ab;
reg valid_pd;
reg valid_contentiona,valid_contentionb,valid_contentionc;
reg valid_da3, valid_da2, valid_da1, valid_da0;
reg valid_db3, valid_db2, valid_db1, valid_db0;
reg valid_bwa3, valid_bwa2, valid_bwa1, valid_bwa0;
reg valid_bwb3, valid_bwb2, valid_bwb1, valid_bwb0;
 
reg EN;
reg RDA, RDB;

reg RCLKA,RCLKB;

wire [1:0] bWTSEL;
wire [1:0] bRTSEL;
wire bVG;
wire bVS;

wire [N-1:0] bBWEBA;
wire [N-1:0] bBWEBB;
 
wire [N-1:0] bDA;
wire [N-1:0] bDB;
 
wire [M-1:0] bAA;
wire [M-1:0] bAB;
 
wire bWEBA,bWEBB;
wire bCEBA,bCEBB;
wire bCLKA,bCLKB;
 
reg [N-1:0] bQA;
reg [N-1:0] bQB;

wire bBIST;
wire WEA,WEB,CSA,CSB;

wire iCEBA = bCEBA;
wire iCEBB = bCEBB;
wire [N-1:0] iBWEBA = bBWEBA;
wire [N-1:0] iBWEBB = bBWEBB;

wire [N-1:0] bbQA;
wire [N-1:0] bbQB;
 
integer i;
integer clk_count;
integer sd_mode;
 
// Address Inputs
buf sAA0 (bAA[0], AA[0]);
buf sAB0 (bAB[0], AB[0]);
buf sAA1 (bAA[1], AA[1]);
buf sAB1 (bAB[1], AB[1]);
buf sAA2 (bAA[2], AA[2]);
buf sAB2 (bAB[2], AB[2]);
buf sAA3 (bAA[3], AA[3]);
buf sAB3 (bAB[3], AB[3]);
buf sAA4 (bAA[4], AA[4]);
buf sAB4 (bAB[4], AB[4]);
buf sAA5 (bAA[5], AA[5]);
buf sAB5 (bAB[5], AB[5]);
buf sAA6 (bAA[6], AA[6]);
buf sAB6 (bAB[6], AB[6]);
buf sAA7 (bAA[7], AA[7]);
buf sAB7 (bAB[7], AB[7]);


// Bit Write/Data Inputs 
buf sDA0 (bDA[0], DA[0]);
buf sDB0 (bDB[0], DB[0]);
buf sDA1 (bDA[1], DA[1]);
buf sDB1 (bDB[1], DB[1]);
buf sDA2 (bDA[2], DA[2]);
buf sDB2 (bDB[2], DB[2]);
buf sDA3 (bDA[3], DA[3]);
buf sDB3 (bDB[3], DB[3]);


buf sBWEBA0 (bBWEBA[0], BWEBA[0]);
buf sBWEBB0 (bBWEBB[0], BWEBB[0]);
buf sBWEBA1 (bBWEBA[1], BWEBA[1]);
buf sBWEBB1 (bBWEBB[1], BWEBB[1]);
buf sBWEBA2 (bBWEBA[2], BWEBA[2]);
buf sBWEBB2 (bBWEBB[2], BWEBB[2]);
buf sBWEBA3 (bBWEBA[3], BWEBA[3]);
buf sBWEBB3 (bBWEBB[3], BWEBB[3]);


// Input Controls
buf sWEBA (bWEBA, WEBA);
buf sWEBB (bWEBB, WEBB);
buf sSLP (bSLP, SLP);
buf sDSLP (bDSLP, DSLP);
buf sSD (bSD, SD);
 
buf sCEBA (bCEBA, CEBA);
buf sCEBB (bCEBB, CEBB);
 
buf sCLKA (bCLKA, CLKA);
buf sCLKB (bCLKB, CLKB);
assign bBIST = 1'b0;

buf sWTSEL0 (bWTSEL[0], WTSEL[0]);
buf sWTSEL1 (bWTSEL[1], WTSEL[1]);
buf sRTSEL0 (bRTSEL[0], RTSEL[0]);
buf sRTSEL1 (bRTSEL[1], RTSEL[1]);
buf sVG (bVG, VG);
buf sVS (bVS, VS);

// Output Data
buf sQA0 (QA[0], bbQA[0]);
buf sQA1 (QA[1], bbQA[1]);
buf sQA2 (QA[2], bbQA[2]);
buf sQA3 (QA[3], bbQA[3]);

buf sQB0 (QB[0], bbQB[0]);
buf sQB1 (QB[1], bbQB[1]);
buf sQB2 (QB[2], bbQB[2]);
buf sQB3 (QB[3], bbQB[3]);

assign bbQA=bQA;
assign bbQB=bQB;

//and sWEA (WEA, !bWEBA, !bCEBA);
//and sWEB (WEB, !bWEBB, !bCEBB);
assign WEA = !bSLP & !bDSLP & !bSD & !bCEBA & !bWEBA;
assign WEB = !bSLP & !bDSLP & !bSD & !bCEBB & !bWEBB;

//buf sCSA (CSA, !bCEBA);
//buf sCSB (CSB, !bCEBB);
assign CSA = !bSLP & !bDSLP & !bSD & !bCEBA;
assign CSB = !bSLP & !bDSLP & !bSD & !bCEBB;


wire AeqB, BeqA;
wire AbeforeB, BbeforeA;

real CLKA_time, CLKB_time;

wire CLK_same;   
assign CLK_same = ((CLKA_time == CLKB_time)?1'b1:1'b0);
assign AeqB = (((bAA == bAB) && CLK_same) || ((AAL == bAB) && !CLK_same)) ? 1'b1:1'b0;
assign BeqA = (((bAB == bAA) && CLK_same) || ((ABL == bAA) && !CLK_same)) ? 1'b1:1'b0;

assign AbeforeB = ((((!bCEBA && !bCEBB && (!bWEBA || !bWEBB)) && CLK_same) || ((!CEBAL && !bCEBB) && (!WEBAL || !bWEBB) && !CLK_same)) && AeqB) ? 1'b1:1'b0;
assign BbeforeA = ((((!bCEBB && !bCEBA && (!bWEBB || !bWEBA)) && CLK_same) || ((!CEBBL && !bCEBA) && (!WEBBL || !bWEBA) && !CLK_same)) && BeqA) ? 1'b1:1'b0;


wire check_slp = !bSD;


`ifdef UNIT_DELAY
`else
specify

    specparam PATHPULSE$CLKA$QA = ( 0, 0.001 );
    specparam PATHPULSE$CLKB$QB = ( 0, 0.001 );

specparam
tckl = 0.2250188,
tckh = 0.2250188,
tcyc = 0.5625469,
tcc = 0.3329769,

tas = 0.0570281,
tah = 0.0629563,
tds = 0.0890725,
tdh = 0.0734125,
tcs = 0.0764191,
tch = 0.0296688,
tws = 0.0763400,
twh = 0.0629563,
tbws = 0.0647625,
tbwh = 0.0794563,

tcd = 0.4646744,
thold = 0.3618900;

   $recrem (posedge CLKA, posedge CLKB &&& AbeforeB, tcc, 0, valid_contentiona);
   $recrem (posedge CLKB, posedge CLKA &&& BbeforeA, tcc, 0, valid_contentionb);








    $setuphold (posedge CLKA &&& CSA, posedge AA[0], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[0], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[0], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[0], tas, tah, valid_ab);
    $setuphold (posedge CLKA &&& CSA, posedge AA[1], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[1], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[1], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[1], tas, tah, valid_ab);
    $setuphold (posedge CLKA &&& CSA, posedge AA[2], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[2], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[2], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[2], tas, tah, valid_ab);
    $setuphold (posedge CLKA &&& CSA, posedge AA[3], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[3], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[3], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[3], tas, tah, valid_ab);
    $setuphold (posedge CLKA &&& CSA, posedge AA[4], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[4], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[4], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[4], tas, tah, valid_ab);
    $setuphold (posedge CLKA &&& CSA, posedge AA[5], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[5], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[5], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[5], tas, tah, valid_ab);
    $setuphold (posedge CLKA &&& CSA, posedge AA[6], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[6], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[6], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[6], tas, tah, valid_ab);
    $setuphold (posedge CLKA &&& CSA, posedge AA[7], tas, tah, valid_aa);
    $setuphold (posedge CLKA &&& CSA, negedge AA[7], tas, tah, valid_aa);
    $setuphold (posedge CLKB &&& CSB, posedge AB[7], tas, tah, valid_ab);
    $setuphold (posedge CLKB &&& CSB, negedge AB[7], tas, tah, valid_ab);

    $setuphold (posedge CLKA &&& WEA, posedge DA[0], tds, tdh, valid_da0);
    $setuphold (posedge CLKA &&& WEA, negedge DA[0], tds, tdh, valid_da0);
    $setuphold (posedge CLKB &&& WEB, posedge DB[0], tds, tdh, valid_db0);
    $setuphold (posedge CLKB &&& WEB, negedge DB[0], tds, tdh, valid_db0);
 
    $setuphold (posedge CLKA &&& WEA, posedge BWEBA[0], tbws, tbwh, valid_bwa0);
    $setuphold (posedge CLKA &&& WEA, negedge BWEBA[0], tbws, tbwh, valid_bwa0);
    $setuphold (posedge CLKB &&& WEB, posedge BWEBB[0], tbws, tbwh, valid_bwb0);
    $setuphold (posedge CLKB &&& WEB, negedge BWEBB[0], tbws, tbwh, valid_bwb0);
    $setuphold (posedge CLKA &&& WEA, posedge DA[1], tds, tdh, valid_da1);
    $setuphold (posedge CLKA &&& WEA, negedge DA[1], tds, tdh, valid_da1);
    $setuphold (posedge CLKB &&& WEB, posedge DB[1], tds, tdh, valid_db1);
    $setuphold (posedge CLKB &&& WEB, negedge DB[1], tds, tdh, valid_db1);
 
    $setuphold (posedge CLKA &&& WEA, posedge BWEBA[1], tbws, tbwh, valid_bwa1);
    $setuphold (posedge CLKA &&& WEA, negedge BWEBA[1], tbws, tbwh, valid_bwa1);
    $setuphold (posedge CLKB &&& WEB, posedge BWEBB[1], tbws, tbwh, valid_bwb1);
    $setuphold (posedge CLKB &&& WEB, negedge BWEBB[1], tbws, tbwh, valid_bwb1);
    $setuphold (posedge CLKA &&& WEA, posedge DA[2], tds, tdh, valid_da2);
    $setuphold (posedge CLKA &&& WEA, negedge DA[2], tds, tdh, valid_da2);
    $setuphold (posedge CLKB &&& WEB, posedge DB[2], tds, tdh, valid_db2);
    $setuphold (posedge CLKB &&& WEB, negedge DB[2], tds, tdh, valid_db2);
 
    $setuphold (posedge CLKA &&& WEA, posedge BWEBA[2], tbws, tbwh, valid_bwa2);
    $setuphold (posedge CLKA &&& WEA, negedge BWEBA[2], tbws, tbwh, valid_bwa2);
    $setuphold (posedge CLKB &&& WEB, posedge BWEBB[2], tbws, tbwh, valid_bwb2);
    $setuphold (posedge CLKB &&& WEB, negedge BWEBB[2], tbws, tbwh, valid_bwb2);
    $setuphold (posedge CLKA &&& WEA, posedge DA[3], tds, tdh, valid_da3);
    $setuphold (posedge CLKA &&& WEA, negedge DA[3], tds, tdh, valid_da3);
    $setuphold (posedge CLKB &&& WEB, posedge DB[3], tds, tdh, valid_db3);
    $setuphold (posedge CLKB &&& WEB, negedge DB[3], tds, tdh, valid_db3);
 
    $setuphold (posedge CLKA &&& WEA, posedge BWEBA[3], tbws, tbwh, valid_bwa3);
    $setuphold (posedge CLKA &&& WEA, negedge BWEBA[3], tbws, tbwh, valid_bwa3);
    $setuphold (posedge CLKB &&& WEB, posedge BWEBB[3], tbws, tbwh, valid_bwb3);
    $setuphold (posedge CLKB &&& WEB, negedge BWEBB[3], tbws, tbwh, valid_bwb3);
    $setuphold (posedge CLKA &&& CSA, posedge WEBA, tws, twh, valid_wea);
    $setuphold (posedge CLKA &&& CSA, negedge WEBA, tws, twh, valid_wea);
    $setuphold (posedge CLKB &&& CSB, posedge WEBB, tws, twh, valid_web);
    $setuphold (posedge CLKB &&& CSB, negedge WEBB, tws, twh, valid_web);

    $setuphold (posedge CLKA, posedge CEBA, tcs, tch, valid_cea);
    $setuphold (posedge CLKA, negedge CEBA, tcs, tch, valid_cea);
    $setuphold (posedge CLKB, posedge CEBB, tcs, tch, valid_ceb);
    $setuphold (posedge CLKB, negedge CEBB, tcs, tch, valid_ceb);

    $width (negedge CLKA, tckl, 0, valid_cka);
    $width (posedge CLKA, tckh, 0, valid_cka);
    $width (negedge CLKB, tckl, 0, valid_ckb);
    $width (posedge CLKB, tckh, 0, valid_ckb);
    $period (posedge CLKA, tcyc, valid_cka);
    $period (negedge CLKA, tcyc, valid_cka);
    $period (posedge CLKB, tcyc, valid_ckb);
    $period (negedge CLKB, tcyc, valid_ckb);

if(!CEBA & WEBA) (posedge CLKA => (QA[0] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if(!CEBB & WEBB) (posedge CLKB => (QB[0] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);




if(!CEBA & WEBA) (posedge CLKA => (QA[1] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if(!CEBB & WEBB) (posedge CLKB => (QB[1] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);




if(!CEBA & WEBA) (posedge CLKA => (QA[2] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if(!CEBB & WEBB) (posedge CLKB => (QB[2] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);




if(!CEBA & WEBA) (posedge CLKA => (QA[3] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);
if(!CEBB & WEBB) (posedge CLKB => (QB[3] : 1'bx)) = (tcd,tcd,thold,tcd,thold,tcd);




endspecify
`endif

initial begin
    assign EN = 1;
    RDA = 1;
    RDB = 1;
    ABL = 1'b1;
    AAL = {M{1'b0}};
    BWEBAL = {N{1'b1}};
    BWEBBL = {N{1'b1}};
    clk_count = 0;
    sd_mode = 0;
end

`ifdef TSMC_INITIALIZE_MEM
initial 
begin 
    #0.01  $readmemh(cdeFileInit, MX.mem, 0, W-1);
end
`endif//  `ifdef TSMC_INITIALIZE_MEM
   
`ifdef TSMC_INITIALIZE_FAULT
initial 
begin
    $readmemh(cdeFileFault, MX.mem_fault, 0, W-1);
end
`endif//  `ifdef TSMC_INITIALIZE_FAULT

`ifdef TSMC_NO_TESTPINS_WARNING
`else
always @(bCLKA or bCLKB or bWTSEL) 
begin
    if((bWTSEL !== 2'b01) && ($realtime > 0) ) 
    begin
        $display("\tError %m : input WTSEL should be set to 2'b01 at simulation time %.1f\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the WTSEL setting in the different segment and mux configuration\n");
        bQA <= #(`SRAM_DELAY) {N{1'bx}};
        bQB <= #(`SRAM_DELAY) {N{1'bx}};
        AAL <= {M{1'bx}};
        BWEBAL <= {N{1'b0}};
    end
end

always @(bCLKA or bCLKB or bRTSEL) 
begin
    if((bRTSEL !== 2'b01) && ($realtime > 0) ) 
    begin
        $display("\tError %m : input RTSEL should be set to 2'b01 at simulation time %.1f\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the RTSEL setting in the different segment and mux configuration\n");
        bQA <= #(`SRAM_DELAY) {N{1'bx}};
        bQB <= #(`SRAM_DELAY) {N{1'bx}};
        AAL <= {M{1'bx}};
        BWEBAL <= {N{1'b0}};
    end
end

always @(bCLKA or bCLKB or bVG) 
begin
    if((bVG !== 1'b1) && ($realtime > 0) ) 
    begin
        $display("\tError %m : input VG should be set to 1'b1 at simulation time %.1f\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the VG setting in the different segment and mux configuration\n");
        bQA <= #(`SRAM_DELAY) {N{1'bx}};
        bQB <= #(`SRAM_DELAY) {N{1'bx}};
        AAL <= {M{1'bx}};
        BWEBAL <= {N{1'b0}};
    end
end

always @(bCLKA or bCLKB or bVS) 
begin
    if((bVS !== 1'b1) && ($realtime > 0) ) 
    begin
        $display("\tError %m : input VS should be set to 1'b1 at simulation time %.1f\n", $realtime);
        $display("\tError %m : Please refer the datasheet for the VS setting in the different segment and mux configuration\n");
        bQA <= #(`SRAM_DELAY) {N{1'bx}};
        bQB <= #(`SRAM_DELAY) {N{1'bx}};
        AAL <= {M{1'bx}};
        BWEBAL <= {N{1'b0}};
    end
end

`endif


always @(posedge bCLKA)
begin
    CLKA_time = $realtime;
end
always @(posedge bCLKB)
begin
    CLKB_time = $realtime;
end

always @(bCLKA) 
begin : CLKAOP
    if(bCLKA === 1'bx ) 
    begin
        if( MES_ALL=="ON" && $realtime != 0)
        begin
            $display("\nWarning %m : CLKA unknown at %t. >>", $realtime);
        end
        #0;
        AAL <= {M{1'bx}};
        BWEBAL <= {N{1'b0}};
        bQA <= #(`SRAM_DELAY) {N{1'bx}}; 
    end
    else if(bCLKA === 1'b1 && RCLKA === 1'b0) 
    begin
        if(bCEBA === 1'bx ) 
        begin
            if( MES_ALL=="ON" && $realtime != 0)
            begin
                $display("\nWarning %m CEBA unknown at %t. >>", $realtime);
            end
            #0;
            AAL <= {M{1'bx}};
            BWEBAL <= {N{1'b0}};
            bQA <= #(`SRAM_DELAY) {N{1'bx}};
        end
    else if(bCEBA === 1'bx ) 
    begin
        if( MES_ALL=="ON" && $realtime != 0)
        begin
            $display("\nWarning %m CEBA unknown at %t. >>", $realtime);
        end
        #0;
        AAL <= {M{1'bx}};
        BWEBAL <= {N{1'b0}};
    end
        else if(bWEBA === 1'bx && bCEBA === 1'b0 ) 
        begin
            if( MES_ALL=="ON" && $realtime != 0)
            begin
                $display("\nWarning %m WEBA unknown at %t. >>", $realtime);
            end
            #0;
            AAL <= {M{1'bx}};
            BWEBAL <= {N{1'b0}};
            bQA <= #(`SRAM_DELAY) {N{1'bx}};
`ifdef UNIT_DELAY
            bQB <= #(`SRAM_DELAY + 0.001) {N{1'bx}};
`else
            bQB <= #(`SRAM_DELAY) {N{1'bx}};
`endif
        end
        else 
        begin                                
            WEBAL = bWEBA;
            CEBAL = bCEBA;
            if(^bAA === 1'bx && bWEBA === 1'b0 && bCEBA === 1'b0 ) 
            begin
                if( MES_ALL=="ON" && $realtime != 0)
                begin
                    $display("\nWarning %m WRITE AA unknown at %t. >>", $realtime);
                end
                #0;
                AAL <= {M{1'bx}};
                BWEBAL <= {N{1'b0}};
            end
            else if(^bAA === 1'bx && bWEBA === 1'b1 && bCEBA === 1'b0 ) 
            begin
                if( MES_ALL=="ON" && $realtime != 0)
                begin
                    $display("\nWarning %m READ AA unknown at %t. >>", $realtime);
                end
                #0;
                AAL <= {M{1'bx}};
                BWEBAL <= {N{1'b0}};
                bQA <= #(`SRAM_DELAY) {N{1'bx}};
            end
            else 
            begin
                if(!bCEBA) 
                begin    // begin if(bCEBA)
                    AAL = bAA;
                    DAL = bDA;
                    if(bWEBA === 1'b1  && clk_count == 0)
                    begin
                        RDA = #0 ~RDA;
                    end
                    if(bWEBA === 1'b0 && bSLP === 1'b0 && bDSLP === 1'b0 && bSD === 1'b0) 
                    begin
                        for (i = 0; i < N; i = i + 1) 
                        begin    // begin for...
                            if(!bBWEBA[i] && !bWEBA) 
                            begin
                                BWEBAL[i] = 1'b0;
                            end    // end if(((...
                            if(((bBWEBA[i] || bBWEBA[i]===1'bx) && bWEBA===1'bx) || (!bWEBA && bBWEBA[i] ===1'bx)) 
                            begin    // if(((...
                                BWEBAL[i] = 1'b0;
                                DAL[i] = 1'bx;
                            end    // end if(((...
                        end    // end for (
                        if(^bBWEBA === 1'bx) 
                        begin
                            if( MES_ALL=="ON" && $realtime != 0)
                            begin
                                $display("\nWarning %m BWEBA unknown at %t. >>", $realtime);
                            end
                        end
                    end
`ifdef UNIT_DELAY
                    #0;
                    if((bAA == bAB) && (WEA && WEB) && CLK_same) 
                    begin    // A-write and B-write ,same-addr
                        if( MES_ALL=="ON" && $realtime != 0)
                        begin
                            $display("\nWarning %m WRITE/WRITE contention. If BWEB enables, Write data set to unknown at %t. >>", $realtime);
                        end
                        for (i=0; i<N; i=i+1) 
                        begin
                            if(!bBWEBA[i] && !bBWEBB[i])
                            begin
                                DAL[i] = 1'bx;
                            end
                        end
                    end
`endif
                end
            end
        end                                
    end// end always @(posedge bCLKA)
    RCLKA = bCLKA;
end

always @(bCLKB) 
begin : CLKBOP
    if(bCLKB === 1'bx ) 
    begin
        if( MES_ALL=="ON" && $realtime != 0)
        begin
            $display("\nWarning %m CLKB unknown at %t. >>", $realtime);
        end
        #0;
        ABL <= {M{1'bx}};
        BWEBBL <= {N{1'b0}};
        bQB <= #(`SRAM_DELAY) {N{1'bx}}; 
    end
    else if(bCLKB === 1'b1 && RCLKB === 1'b0) 
    begin
        if(bCEBB === 1'bx ) 
        begin
            if( MES_ALL=="ON" && $realtime != 0)
            begin
                $display("\nWarning %m CEBB unknown at %t. >>", $realtime);
            end
            #0;
            ABL <= {M{1'bx}};
            BWEBBL <= {N{1'b0}};
            bQB <= #(`SRAM_DELAY) {N{1'bx}};
        end
        else if(bCEBB === 1'bx ) 
        begin
            if( MES_ALL=="ON" && $realtime != 0)
            begin
                $display("\nWarning %m CEBB unknown at %t. >>", $realtime);
            end
            #0;
            ABL <= {M{1'bx}};
            BWEBBL <= {N{1'b0}};
        end
        else if(bWEBB === 1'bx && bCEBB === 1'b0 ) 
        begin
            if( MES_ALL=="ON" && $realtime != 0)
            begin
                $display("\nWarning %m WEBB unknown at %t. >>", $realtime);
            end
            #0;
            ABL <= {M{1'bx}};
            BWEBBL <= {N{1'b0}};
`ifdef UNIT_DELAY
            bQA <= #(`SRAM_DELAY + 0.001) {N{1'bx}};
`else
            bQA <= #(`SRAM_DELAY) {N{1'bx}};
`endif
            bQB <= #(`SRAM_DELAY) {N{1'bx}};
        end
        else 
        begin                               
            WEBBL = bWEBB;
            CEBBL = bCEBB;
            if(^bAB === 1'bx && bWEBB === 1'b0 && bCEBB === 1'b0 ) 
            begin
                if( MES_ALL=="ON" && $realtime != 0)
                begin
                    $display("\nWarning %m WRITE AB unknown at %t. >>", $realtime);
                end
                #0;
                ABL <= {M{1'bx}};
                BWEBBL <= {N{1'b0}};
            end
            else if(^bAB === 1'bx && bWEBB === 1'b1 && bCEBB === 1'b0 ) 
            begin
                if( MES_ALL=="ON" && $realtime != 0)
                begin
                    $display("\nWarning %m READ AB unknown at %t. >>", $realtime);
                end
                #0;
                ABL <= {M{1'bx}};
                BWEBBL <= {N{1'b0}};
                bQB <= #(`SRAM_DELAY) {N{1'bx}};
            end
            else 
            begin
                if(!bCEBB) 
                begin    // begin if(bCEBB)
                    ABL = bAB;
                    DBL = bDB;
                    if(bWEBB === 1'b1  && clk_count == 0)
                    begin
                        RDB = #0 ~RDB;
                    end
                    if(bWEBB !== 1'b1 && bSLP === 1'b0 && bDSLP === 1'b0 && bSD === 1'b0) 
                    begin
                        for (i = 0; i < N; i = i + 1) 
                        begin    // begin for...
                            if(!bBWEBB[i] && !bWEBB) 
                            begin
                                BWEBBL[i] = 1'b0;
                            end
                            if(((bBWEBB[i] || bBWEBB[i]===1'bx) && bWEBB===1'bx) || (!bWEBB && bBWEBB[i] ===1'bx)) 
                            begin    // if(((...
                                BWEBBL[i] = 1'b0;
                                DBL[i] = 1'bx;
                            end    // end if(((...
                        end    // end for (
                        if(^bBWEBB === 1'bx) 
                        begin
                            if( MES_ALL=="ON" && $realtime != 0)
                            begin
                                $display("\nWarning %m BWEBB unknown at %t. >>", $realtime);
                            end
                        end
                    end
`ifdef UNIT_DELAY
                    #0;
                    if((bAB == bAA) && (WEA && WEB) && CLK_same) 
                    begin    // A-write and B-write ,same-addr
                        if( MES_ALL=="ON" && $realtime != 0)
                        begin
                            $display("\nWarning %m WRITE/WRITE contention. If BWEB enables, Write data set to unknown at %t. >>", $realtime);
                        end
                        for (i=0; i<N; i=i+1) 
                        begin
                            if(!bBWEBA[i] && !bBWEBB[i])
                            begin
                                DBL[i] = 1'bx;
                            end
                        end
                    end
`endif
                end
            end
        end                       
    end
    RCLKB = bCLKB;
end

always @(RDA or QAL) 
begin
    if(!CEBAL && WEBAL  && clk_count == 0) 
    begin
        if((bAA == bAB) && ((!bCEBA&&bWEBA) && WEB) && CLK_same) 
        begin    // A-read and B-write ,same-addr
            if( MES_ALL=="ON" && $realtime != 0)
            begin
                $display("\nWarning %m READ/WRITE contention. If BWEB enables, Port A outputs set to unknown at %t. >>", $realtime);
            end
`ifdef UNIT_DELAY
            #(`SRAM_DELAY);
`else
            bQA = {N{1'bx}};
            #0.01;
`endif
            for (i=0; i<N; i=i+1) 
            begin
                if(!iBWEBB[i] || iBWEBB[i] === 1'bx) 
                begin
                    bQA[i] <= 1'bx;
                end
                else 
                begin
                    bQA[i] <= QAL[i];
                end
            end
        end
        else 
        begin
`ifdef UNIT_DELAY
            #(`SRAM_DELAY);
`else
            bQA = {N{1'bx}};
            #0.01;
`endif
            bQA <= QAL;
        end
    end // if(!CEBAL && WEBAL  && clk_count == 0)
end // always @ (RDA or QAL)

always @(RDB or QBL) 
begin
    if(!CEBBL && WEBBL  && clk_count == 0) 
    begin
        if((bAA == bAB) && (WEA && (!CEBB&&WEBB)) && CLK_same) 
        begin    // A-write and B-read ,same-addr
            if( MES_ALL=="ON" && $realtime != 0)
            begin
                $display("\nWarning %m READ/WRITE contention. If BWEB enables, Port B outputs set to unknown at %t. >>", $realtime);
            end
`ifdef UNIT_DELAY
            #(`SRAM_DELAY);
`else
            bQB = {N{1'bx}};
            #0.01;
`endif
            for (i=0; i<N; i=i+1) 
            begin
                if(!iBWEBA[i] || iBWEBA[i] === 1'bx) 
                begin
                    bQB[i] <= 1'bx;
                end
                else 
                begin
                    bQB[i] <= QBL[i];
                end
            end
        end
        else 
        begin
`ifdef UNIT_DELAY
            #(`SRAM_DELAY);
`else
            bQB = {N{1'bx}};
            #0.01;
`endif
            bQB <= QBL;
        end
    end // if(!bAWT && !CEBBL && WEBBL  && clk_count == 0)
end // always @ (RDB or QBL)



always @(BWEBAL) 
begin
    BWEBAL = #0.01 {N{1'b1}};
end

always @(BWEBBL) 
begin
    BWEBBL = #0.01 {N{1'b1}};
end
 
`ifdef UNIT_DELAY
`else
always @(valid_contentiona) 
begin
    if((CEBAL == 1'b0 && WEBAL == 1'b0 && bCEBB == 1'b0 && bWEBB == 1'b1 && !bBIST && CLK_same) || (CEBAL == 1'b0 && WEBAL == 1'b0 && bCEBB == 1'b0 && bWEBB == 1'b1 && !bBIST && !CLK_same)) 
    begin
        #0.011;        
        disable CLKBOP;
        for (i=0; i<N; i=i+1) 
        begin
            if((bBWEBA[i] ===1'bx) || (BWEBAL[i]===1'bx)) 
            begin
                BWEBAL[i] = 1'b0;
                //DAL[i] = 1'bx;
                bQB[i] =  1'bx;
            end
        end
        for (i=0; i<N; i=i+1) 
        begin
            if((!bBWEBA[i]) || (!BWEBAL[i] ))
            begin
                bQB[i] =  1'bx;
            end
        end
    end  

    if((CEBAL == 1'b0 && WEBAL == 1'b1 && bCEBB == 1'b0 && bWEBB == 1'b0 && !bBIST && CLK_same) || (CEBAL == 1'b0 && WEBAL == 1'b1 && bCEBB == 1'b0 && bWEBB == 1'b0 && !bBIST && !CLK_same)) 
    begin
        #0.011;        
        disable CLKAOP;
        for (i=0; i<N; i=i+1) 
        begin
            if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx)) 
            begin
                BWEBBL[i] = 1'b0;
                //DBL[i] = 1'bx;
                bQA[i] =  1'bx;
            end
        end
        for (i=0; i<N; i=i+1) 
        begin
            if((!bBWEBB[i]) || (!BWEBBL[i] ))
            begin
                bQA[i] =  1'bx;
            end
        end   
    end  

    if((CEBAL == 1'b0 && WEBAL == 1'b0 && bCEBB == 1'b0 && bWEBB == 1'b0 && !bBIST && CLK_same) || (CEBAL == 1'b0 && WEBAL == 1'b0 && bCEBB == 1'b0 && bWEBB == 1'b0 && !bBIST && !CLK_same)) 
    begin
        disable CLKAOP;
        disable CLKBOP;
        for (i=0; i<N; i=i+1) 
        begin
            if((bBWEBA[i] ===1'bx)||(BWEBAL[i]===1'bx)) 
            begin
                BWEBAL[i] = 1'b0;
                DAL[i] = 1'bx;
            end
            if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx)) 
            begin
                BWEBBL[i] = 1'b0;
                DBL[i] = 1'bx;
            end
        end

        for (i=0; i<N; i=i+1) 
        begin
            if((!bBWEBB[i]) || (!BWEBBL[i] ))
                DAL[i] = 1'bx;
            if((!bBWEBA[i]) || (!BWEBAL[i] ))
                DBL[i] = 1'bx;
        end 
    end
end
 
always @(valid_contentionb) 
begin
    if((bCEBA == 1'b0 && bWEBA == 1'b1 && CEBBL == 1'b0 && WEBBL == 1'b0 && !bBIST && CLK_same) || (bCEBA == 1'b0 && bWEBA == 1'b1 && CEBBL == 1'b0 && WEBBL == 1'b0 && !bBIST && !CLK_same)) 
    begin
        #0.011;        
        disable CLKAOP;
        for (i=0; i<N; i=i+1) 
        begin
            if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx)) 
            begin
                BWEBBL[i] = 1'b0;
                //DBL[i] = 1'bx;
                bQA[i] =  1'bx;
            end
        end
        for (i=0; i<N; i=i+1) 
        begin
            if((!bBWEBB[i]) || (!BWEBBL[i] ))
            begin
                bQA[i] =  1'bx;
            end
        end
    end 

    if((bCEBA == 1'b0 && bWEBA == 1'b0 && CEBBL == 1'b0 && WEBBL == 1'b1 && !bBIST && CLK_same) || (bCEBA == 1'b0 && bWEBA == 1'b0 && CEBBL == 1'b0 && WEBBL == 1'b1 && !bBIST && !CLK_same)) 
    begin
        #0.011;        
        disable CLKBOP;
        for (i=0; i<N; i=i+1) 
        begin
            if((bBWEBA[i] ===1'bx)||(BWEBAL[i]===1'bx)) 
            begin
                BWEBAL[i] = 1'b0;
                //DAL[i] = 1'bx;
                bQB[i] =  1'bx;
            end
        end
        for (i=0; i<N; i=i+1) 
        begin
            if((!bBWEBA[i]) || (!BWEBAL[i] ))
            begin
                bQB[i] =  1'bx;
            end
        end   
    end  

    if((bCEBA == 1'b0 && bWEBA == 1'b0 && CEBBL == 1'b0 && WEBBL == 1'b0 && !bBIST && CLK_same) || (bCEBA == 1'b0 && bWEBA == 1'b0 && CEBBL == 1'b0 && WEBBL == 1'b0 && !bBIST && !CLK_same)) 
    begin
        disable CLKAOP;
        disable CLKBOP;
        for (i=0; i<N; i=i+1) 
        begin
            if((bBWEBA[i] ===1'bx)||(BWEBAL[i]===1'bx)) 
            begin
                BWEBAL[i] = 1'b0;
                DAL[i] = 1'bx;
            end
            if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx)) 
            begin
                BWEBBL[i] = 1'b0;
                DBL[i] = 1'bx;
            end
        end

        for (i=0; i<N; i=i+1) 
        begin
            if((!bBWEBB[i]) || (!BWEBBL[i] ))
            begin
                DAL[i] = 1'bx;
            end
            if((!bBWEBA[i]) || (!BWEBAL[i] ))
            begin
                DBL[i] = 1'bx;
            end
        end 
    end
end

 
always @(valid_cka) 
begin
    #0;
    AAL = {M{1'bx}};
    BWEBAL = {N{1'b0}};
    bQA = #(`SRAM_DELAY) {N{1'bx}};
end
 
always @(valid_ckb) 
begin
    #0;
    ABL = {M{1'bx}};
    BWEBBL = {N{1'b0}};
    bQB = #(`SRAM_DELAY) {N{1'bx}};
end


always @(valid_aa) 
begin
    #0;
    if(!WEBAL) 
    begin
        BWEBAL = {N{1'b0}};
        AAL = {M{1'bx}};
    end
    else 
    begin
        BWEBAL = {N{1'b0}};
        AAL = {M{1'bx}};
        bQA = #(`SRAM_DELAY) {N{1'bx}};
    end
end

always @(valid_ab) 
begin
    #0;
    if(!WEBBL) 
    begin
        BWEBBL = {N{1'b0}};
        ABL = {M{1'bx}};
    end
    else 
    begin
        BWEBBL = {N{1'b0}};
        ABL = {M{1'bx}};
        bQB = #(`SRAM_DELAY) {N{1'bx}};
    end
end

always @(valid_da0) 
begin
    #0;
    DAL[0] = 1'bx;
    BWEBAL[0] = 1'b0;
end

always @(valid_db0) 
begin
    #0;
    DBL[0] = 1'bx;
    BWEBBL[0] = 1'b0;
end

always @(valid_bwa0) 
begin
    #0;
    DAL[0] = 1'bx;
    BWEBAL[0] = 1'b0;
end

always @(valid_bwb0) 
begin
    #0;
    DBL[0] = 1'bx;
    BWEBBL[0] = 1'b0;
end
always @(valid_da1) 
begin
    #0;
    DAL[1] = 1'bx;
    BWEBAL[1] = 1'b0;
end

always @(valid_db1) 
begin
    #0;
    DBL[1] = 1'bx;
    BWEBBL[1] = 1'b0;
end

always @(valid_bwa1) 
begin
    #0;
    DAL[1] = 1'bx;
    BWEBAL[1] = 1'b0;
end

always @(valid_bwb1) 
begin
    #0;
    DBL[1] = 1'bx;
    BWEBBL[1] = 1'b0;
end
always @(valid_da2) 
begin
    #0;
    DAL[2] = 1'bx;
    BWEBAL[2] = 1'b0;
end

always @(valid_db2) 
begin
    #0;
    DBL[2] = 1'bx;
    BWEBBL[2] = 1'b0;
end

always @(valid_bwa2) 
begin
    #0;
    DAL[2] = 1'bx;
    BWEBAL[2] = 1'b0;
end

always @(valid_bwb2) 
begin
    #0;
    DBL[2] = 1'bx;
    BWEBBL[2] = 1'b0;
end
always @(valid_da3) 
begin
    #0;
    DAL[3] = 1'bx;
    BWEBAL[3] = 1'b0;
end

always @(valid_db3) 
begin
    #0;
    DBL[3] = 1'bx;
    BWEBBL[3] = 1'b0;
end

always @(valid_bwa3) 
begin
    #0;
    DAL[3] = 1'bx;
    BWEBAL[3] = 1'b0;
end

always @(valid_bwb3) 
begin
    #0;
    DBL[3] = 1'bx;
    BWEBBL[3] = 1'b0;
end

always @(valid_cea) 
begin
    #0;
    BWEBAL = {N{1'b0}};
    AAL = {M{1'bx}};
    bQA = #(`SRAM_DELAY) {N{1'bx}};
end

always @(valid_ceb) 
begin
    #0;
    BWEBBL = {N{1'b0}};
    ABL = {M{1'bx}};
    bQB = #(`SRAM_DELAY) {N{1'bx}};
end

always @(valid_wea) 
begin
    #0;
    BWEBAL = {N{1'b0}};
    AAL = {M{1'bx}};
    bQA = #(`SRAM_DELAY) {N{1'bx}};
    bQB = #(`SRAM_DELAY) {N{1'bx}};
end
 
always @(valid_web) 
begin
    #0;
    BWEBBL = {N{1'b0}};
    ABL = {M{1'bx}};
    bQA = #(`SRAM_DELAY) {N{1'bx}};
    bQB = #(`SRAM_DELAY) {N{1'bx}};
end

always @(valid_pd) 
begin
    #0;
    bQA = #(`SRAM_DELAY) {N{1'bx}};
    bQB = #(`SRAM_DELAY) {N{1'bx}};
end
`endif

// Task for printing the memory between specified addresses..
task printMemoryFromTo;     
    input [M - 1:0] from;   // memory content are printed, start from this address.
    input [M - 1:0] to;     // memory content are printed, end at this address.
    begin 
        MX.printMemoryFromTo(from, to);
    end 
endtask

// Task for printing entire memory, including normal array and redundancy array.
task printMemory;   
    begin
        MX.printMemory;
    end
endtask

task xMemoryAll;   
    begin
       MX.xMemoryAll;  
    end
endtask

task zeroMemoryAll;   
    begin
       MX.zeroMemoryAll;   
    end
endtask

// Task for Loading a perdefined set of data from an external file.
task preloadData;   
    input [256*8:1] infile;  // Max 256 character File Name
    begin
        MX.preloadData(infile);  
    end
endtask

TSDN28HPCA256X4M8FW_Int_Array #(2,2,W,N,M,MES_ALL) MX (.D({DAL,DBL}),.BW({BWEBAL,BWEBBL}),
         .AW({AAL,ABL}),.EN(EN),.AAR(AAL),.ABR(ABL),.RDA(RDA),.RDB(RDB),.QA(QAL),.QB(QBL));
 
endmodule

`disable_portfaults
`nosuppress_faults
`endcelldefine

/*
   The module ports are parameterizable vectors.
*/

module TSDN28HPCA256X4M8FW_Int_Array (D, BW, AW, EN, AAR, ABR, RDA, RDB, QA, QB);
parameter Nread = 2;   // Number of Read Ports
parameter Nwrite = 2;  // Number of Write Ports
parameter Nword = 2;   // Number of Words
parameter Ndata = 1;   // Number of Data Bits / Word
parameter Naddr = 1;   // Number of Address Bits / Word
parameter MES_ALL = "ON";
parameter dly = 0.000;
// Cannot define inputs/outputs as memories
input  [Ndata*Nwrite-1:0] D;  // Data Word(s)
input  [Ndata*Nwrite-1:0] BW; // Negative Bit Write Enable
input  [Naddr*Nwrite-1:0] AW; // Write Address(es)
input  EN;                    // Positive Write Enable
input  RDA;                    // Positive Write Enable
input  RDB;                    // Positive Write Enable
input  [Naddr-1:0] AAR;  // Read Address(es)
input  [Naddr-1:0] ABR;  // Read Address(es)
output [Ndata-1:0] QA;   // Output Data Word(s)
output [Ndata-1:0] QB;   // Output Data Word(s)
reg    [Ndata-1:0] QA;
reg    [Ndata-1:0] QB;
reg [Ndata-1:0] mem [Nword-1:0];
reg [Ndata-1:0] mem_fault [Nword-1:0];
reg chgmem;            // Toggled when write to mem
reg [Nwrite-1:0] wwe;  // Positive Word Write Enable for each Port
reg we;                // Positive Write Enable for all Ports
integer waddr[Nwrite-1:0]; // Write Address for each Enabled Port
integer address;       // Current address
reg [Naddr-1:0] abuf;  // Address of current port
reg [Ndata-1:0] dbuf;  // Data for current port
reg [Ndata-1:0] bwbuf; // Bit Write enable for current port
reg dup;               // Is the address a duplicate?
integer log;           // Log file descriptor
integer ip, ip2, ib, iw, iwb; // Vector indices


initial 
begin
    $timeformat (-9, 3, " ns", 9);
    if(log[0] === 1'bx)
        log = 1;
    chgmem = 1'b0;
end


always @(D or BW or AW or EN) 
begin: WRITE //{
    if(EN !== 1'b0) 
    begin //{ Possible write
        we = 1'b0;
        // Mark any write enabled ports & get write addresses
        for (ip = 0 ; ip < Nwrite ; ip = ip + 1) 
        begin //{
            ib = ip * Ndata;
            iw = ib + Ndata;
            while (ib < iw && BW[ib] === 1'b1)
            begin
                ib = ib + 1;
            end
            if(ib == iw)
            begin
                wwe[ip] = 1'b0;
            end
            else 
            begin //{ ip write enabled
                iw = ip * Naddr;
                for (ib = 0 ; ib < Naddr ; ib = ib + 1) 
                begin //{
                    abuf[ib] = AW[iw+ib];
                    if(abuf[ib] !== 1'b0 && abuf[ib] !== 1'b1)
                    begin
                        ib = Naddr;
                    end
                end //}
                if(ib == Naddr) 
                begin //{
                    if(abuf < Nword) 
                    begin //{ Valid address
                        waddr[ip] = abuf;
                        wwe[ip] = 1'b1;
                        if(we == 1'b0) 
                        begin
                            chgmem = ~chgmem;
                            we = EN;
                        end
                    end //}
                    else 
                    begin //{ Out of range address
                         wwe[ip] = 1'b0;
                         if( MES_ALL=="ON" && $realtime != 0)
                              $fdisplay (log,
                                         "\nWarning! Int_Array instance, %m:",
                                         "\n\t Port %0d", ip,
                                         " write address x'%0h'", abuf,
                                         " out of range at time %t.", $realtime,
                                         "\n\t Port %0d data not written to memory.", ip);
                    end //}
                end //}
                else 
                begin //{ unknown write address
                    if( MES_ALL=="ON" && $realtime != 0)
                        $fdisplay (log,
                                   "\nWarning! Int_Array instance, %m:",
                                   "\n\t Port %0d", ip,
                                   " write address unknown at time %t.", $realtime,
                                   "\n\t Entire memory set to unknown.");
                    for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                    begin
                        dbuf[ib] = 1'bx;
                    end
                    for (iw = 0 ; iw < Nword ; iw = iw + 1)
                    begin
                        mem[iw] = dbuf;
                    end
                    chgmem = ~chgmem;
                    disable WRITE;
                end //}
            end //} ip write enabled
        end //} for ip
        if(we === 1'b1) 
        begin //{ active write enable
            for (ip = 0 ; ip < Nwrite ; ip = ip + 1) 
            begin //{
                if(wwe[ip]) 
                begin //{ write enabled bits of write port ip
                    address = waddr[ip];
                    dbuf = mem[address];
                    iw = ip * Ndata;
                    for (ib = 0 ; ib < Ndata ; ib = ib + 1) 
                    begin //{
                        iwb = iw + ib;
                        if(BW[iwb] === 1'b0)
                        begin
                            dbuf[ib] = D[iwb];
                        end
                        else
                        if(BW[iwb] !== 1'b1)
                        begin
                            dbuf[ib] = 1'bx;
                        end
                    end //}
                    // Check other ports for same address &
                    // common write enable bits active
                    dup = 0;
                    for (ip2 = ip + 1 ; ip2 < Nwrite ; ip2 = ip2 + 1) 
                    begin //{
                        if(wwe[ip2] && address == waddr[ip2]) 
                        begin //{
                            // initialize bwbuf if first dup
                            if(!dup) 
                            begin
                                for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                                begin
                                    bwbuf[ib] = BW[iw+ib];
                                end
                                dup = 1;
                            end
                            iw = ip2 * Ndata;
                            for (ib = 0 ; ib < Ndata ; ib = ib + 1) 
                            begin //{
                                iwb = iw + ib;
                                // New: Always set X if BW X
                                if(BW[iwb] === 1'b0) 
                                begin //{
                                    if(bwbuf[ib] !== 1'b1) 
                                    begin
                                        if(D[iwb] !== dbuf[ib])
                                        begin
                                            dbuf[ib] = 1'bx;
                                        end
                                    end
                                    else 
                                    begin
                                        dbuf[ib] = D[iwb];
                                        bwbuf[ib] = 1'b0;
                                    end
                                end //}
                                else if(BW[iwb] !== 1'b1) 
                                begin
                                    dbuf[ib] = 1'bx;
                                    bwbuf[ib] = 1'bx;
                                end
                            end //} for each bit
                            wwe[ip2] = 1'b0;
                        end //} Port ip2 address matches port ip
                    end //} for each port beyond ip (ip2=ip+1)
                    // Write dbuf to memory
                    mem[address] = dbuf;
                end //} wwe[ip] - write port ip enabled
            end //} for each write port ip
        end //} active write enable
        else if(we !== 1'b0) 
        begin //{ unknown write enable
            for (ip = 0 ; ip < Nwrite ; ip = ip + 1) 
            begin //{
                if(wwe[ip]) 
                begin //{ write X to enabled bits of write port ip
                    address = waddr[ip];
                    dbuf = mem[address];
                    iw = ip * Ndata;
                    for (ib = 0 ; ib < Ndata ; ib = ib + 1) 
                    begin //{ 
                        if(BW[iw+ib] !== 1'b1)
                        begin
                            dbuf[ib] = 1'bx;
                        end
                    end //} 
                    mem[address] = dbuf;
                    if( MES_ALL=="ON" && $realtime != 0)
                        $fdisplay (log,
                                   "\nWarning! Int_Array instance, %m:",
                                   "\n\t Enable pin unknown at time %t.", $realtime,
                                   "\n\t Enabled bits at port %0d", ip,
                                   " write address x'%0h' set unknown.", address);
                end //} wwe[ip] - write port ip enabled
            end //} for each write port ip
        end //} unknown write enable
    end //} possible write (EN != 0)
end //} always @(D or BW or AW or EN)


// Read memory
always @(AAR or RDA) 
begin //{
    for (ib = 0 ; ib < Naddr ; ib = ib + 1) 
    begin
        abuf[ib] = AAR[ib];
        if(abuf[ib] !== 0 && abuf[ib] !== 1)
        begin
            ib = Naddr;
        end
    end
    if(ib == Naddr && abuf < Nword) 
    begin //{ Read valid address
`ifdef TSMC_INITIALIZE_FAULT
        dbuf = mem[abuf] ^ mem_fault[abuf];
`else
        dbuf = mem[abuf];
`endif
        for (ib = 0 ; ib < Ndata ; ib = ib + 1) 
        begin
            if(QA[ib] == dbuf[ib])
            begin
                QA[ib] <= #(dly) dbuf[ib];
            end
            else 
            begin
                QA[ib] <= #(dly) dbuf[ib];
            end // else
        end // for
    end //} valid address
    else 
    begin //{ Invalid address
        if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, "\nWarning! Int_Array instance, %m:",
                     "\n\t Port A read address");
        if(ib > Naddr) 
        begin
            if( MES_ALL=="ON" && $realtime != 0)
                $fwrite (log, " unknown");
        end   
        else 
        begin
            if( MES_ALL=="ON" && $realtime != 0)
                $fwrite (log, " x'%0h' out of range", abuf);
        end   
        if( MES_ALL=="ON" && $realtime != 0)
            $fdisplay (log,
                       " at time %t.", $realtime,
                       "\n\t Port A outputs set to unknown.");
        for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            QA[ib] <= #(dly) 1'bx;
    end //} invalid address
end //} always @(chgmem or AR)

// Read memory
always @(ABR or RDB) 
begin //{
    for (ib = 0 ; ib < Naddr ; ib = ib + 1) 
    begin
        abuf[ib] = ABR[ib];
        if(abuf[ib] !== 0 && abuf[ib] !== 1)
            ib = Naddr;
    end
    if(ib == Naddr && abuf < Nword) 
    begin //{ Read valid address
`ifdef TSMC_INITIALIZE_FAULT
        dbuf = mem[abuf] ^ mem_fault[abuf];
`else
        dbuf = mem[abuf];
`endif
        for (ib = 0 ; ib < Ndata ; ib = ib + 1) 
        begin
            if(QB[ib] == dbuf[ib])
            begin
                QB[ib] <= #(dly) dbuf[ib];
            end
            else 
            begin
                QB[ib] <= #(dly) dbuf[ib];
            end // else
        end // for
    end //} valid address
    else 
    begin //{ Invalid address
        if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, "\nWarning! Int_Array instance, %m:",
                     "\n\t Port B read address");
        if(ib > Naddr) begin
            if( MES_ALL=="ON" && $realtime != 0)
                $fwrite (log, " unknown");
        end   
        else begin
            if( MES_ALL=="ON" && $realtime != 0)
                $fwrite (log, " x'%0h' out of range", abuf);
        end   
        if( MES_ALL=="ON" && $realtime != 0)
            $fdisplay (log,
                       " at time %t.", $realtime,
                       "\n\t Port B outputs set to unknown.");
        for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            QB[ib] <= #(dly) 1'bx;
    end //} invalid address
end //} always @(chgmem or AR)


// Task for loading contents of a memory
task preloadData;   
    input [256*8:1] infile;  // Max 256 character File Name
    begin
        $display ("%m: Reading file, %0s, into the register file", infile);
`ifdef TSMC_INITIALIZE_FORMAT_BINARY
        $readmemb (infile, mem, 0, Nword-1);
`else
        $readmemh (infile, mem, 0, Nword-1);
`endif
    end
endtask

// Task for displaying contents of a memory
task printMemoryFromTo;   
    input [Naddr - 1:0] from;   // memory content are printed, start from this address.
    input [Naddr - 1:0] to;     // memory content are printed, end at this address.
    integer i;
begin //{
    $display ("\n%m: Memory content dump");
    if(from < 0 || from > to || to >= Nword)
    begin
        $display ("Error! Invalid address range (%0d, %0d).", from, to,
                  "\nUsage: %m (from, to);",
                  "\n       where from >= 0 and to <= %0d.", Nword-1);
    end
    else 
    begin
        $display ("\n    Address\tValue");
        for (i = from ; i <= to ; i = i + 1)
            $display ("%d\t%b", i, mem[i]);
    end
end //}
endtask //}

// Task for printing entire memory, including normal array and redundancy array.
task printMemory;   
    integer i;
    begin
        $display ("Dumping register file...");
        $display("@    Address, content-----");
        for (i = 0; i < Nword; i = i + 1) begin
            $display("@%d, %b", i, mem[i]);
        end 
    end
endtask

task xMemoryAll;   
    begin
       for (ib = 0 ; ib < Ndata ; ib = ib + 1)
          dbuf[ib] = 1'bx;
       for (iw = 0 ; iw < Nword ; iw = iw + 1)
          mem[iw] = dbuf; 
    end
endtask

task zeroMemoryAll;   
    begin
       for (ib = 0 ; ib < Ndata ; ib = ib + 1)
          dbuf[ib] = 1'b0;
       for (iw = 0 ; iw < Nword ; iw = iw + 1)
          mem[iw] = dbuf; 
    end
endtask

endmodule

