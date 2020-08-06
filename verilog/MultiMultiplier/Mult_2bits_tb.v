  `timescale 1 ns/10 ps 

 module Mult_2bits_tb ();
    parameter STRUCT = 0; // 0-structural, 1 - behavioral adder


    reg     clk      ;
    reg     rst      ;
    reg           as ;
    reg     [1:0] a  ; // unsigned
    reg     [1:0] b  ; // unsigned
    reg           cin;
    wire    [4:0] mul5;  

    wire   [18    :0] mul1; 
    wire   [8     :0] mul2, mul2_ref;
    wire   [6     :0] mul3;
    wire   [6     :0] mul4;


reg  [8-1:0] aa;
reg  [  1:0] convtype;
wire [8-1:0] d_out;
wire [  3:0] sign ;


reg  [8-1:0] d  ; // unsigned (data)
reg  [8-1:0] w1 ; //   signed (weights) for data input - 8 4 2
reg  [8-1:0] w2 ; //   signed (weights) for data input -   4 2
reg  [8-1:0] w3 ; //   signed (weights) for data input -     2
reg  [8-1:0] w4 ; //   signed (weights) for data input -     2
reg  [  1:0] convtypeD;
reg  [  1:0] convtypeW;
wire [16+2   :0] addL_res_o; 
wire [12+2   :0] addM_res_o;
wire [8-1:0] mul ;   
wire [16+2   :0] mulL_ref; 
wire [6      :0] mul3_ref, mul4_ref;

    localparam period = 20;
localparam [1:0] CONV_2  = 2'b01;
localparam [1:0] CONV_4  = 2'b10;
localparam [1:0] CONV_8  = 2'b11;

  integer  j, i, k, j2, j3, j4;
  reg      err, err1 ;
  reg err_m1, err_m2, err_m3, err_m4;

Mult_2bits  
   mul2b_UUT
   (
  .as  (as  ),
  .a   (a   ), 
  .b   (b   ), 
  .mul (mul5 )
   );


//Signed2SMagnitude  
//   UUT
//   (
//  .d_in     ( aa       ), 
//  .convtype ( convtype ), 
//  .sign     ( sign     ),
//  .d_out    ( d_out    )
//   );
//
MultiMultiplier8x8
MUL_DUT
(
    .clk       (clk       ),
    .d         (d         ), // unsigned (data)
    .w1        (w1        ), //   signed (weights) for data input - 8 4 2
    .w2        (w2        ), //   signed (weights) for data input -   4 2
    .w3        (w3        ), //   signed (weights) for data input -     2
    .w4        (w4        ), //   signed (weights) for data input -     2
    .convtypeD (convtypeD ),
    .convtypeW (convtypeW ),
    .mul1      (mul1      ),
    .mul2      (mul2      ),
    .mul3      (mul3      ),
    .mul4      (mul4      )
);

always 
begin
    clk = 1'b1; 
    #10; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #10; // low for 20 * timescale = 20 ns
end
assign mulL_ref = (convtypeD == CONV_8 && convtypeW == CONV_8) ? d*(w1[6:0]-2**7*w1[7]) :

                  (convtypeD == CONV_8 && convtypeW == CONV_4) ? d*(w1[6:4]-2**3*w1[7]) + 
                                                                 d*(w1[2:0]-2**3*w1[3]) :

                  (convtypeD == CONV_8 && convtypeW == CONV_2) ? d*(w1[6] - 2*w1[7]) + 
                                                                 d*(w1[4] - 2*w1[5]) + 
                                                                 d*(w1[2] - 2*w1[3]) + 
                                                                 d*(w1[0] - 2*w1[1]) :
                           
                  (convtypeD == CONV_4 && convtypeW == CONV_4) ? d[3:0]*(w1[6:4]-2**3*w1[7]) + 
                                                                 d[3:0]*(w1[2:0]-2**3*w1[3]) :   // N2
                                                         
                  (convtypeD == CONV_4 && convtypeW == CONV_2) ? d[3:0]*(w1[6] - 2*w1[7]) + 
                                                                 d[3:0]*(w1[4] - 2*w1[5]) + 
                                                                 d[3:0]*(w1[2] - 2*w1[3]) +
                                                                 d[3:0]*(w1[0] - 2*w1[1]) :   

                  (convtypeD == CONV_2 && convtypeW == CONV_2) ? d[1:0]*(w1[6] - 2*w1[7]) + 
                                                                 d[1:0]*(w1[4] - 2*w1[5]) + 
                                                                 d[1:0]*(w1[2] - 2*w1[3]) + 
                                                                 d[1:0]*(w1[0] - 2*w1[1]) : 0;   // N4

assign mul2_ref = (convtypeD == CONV_4 && convtypeW == CONV_4) ? d[7:4]*(w2[6:4]-2**3*w2[7]) + 
                                                                 d[7:4]*(w2[2:0]-2**3*w2[3]) :   
                                                         
                  (convtypeD == CONV_4 && convtypeW == CONV_2) ? d[7:4]*(w2[6] - 2*w2[7]) + 
                                                                 d[7:4]*(w2[4] - 2*w2[5]) +   
                                                                 d[7:4]*(w2[2] - 2*w2[3]) + 
                                                                 d[7:4]*(w2[0] - 2*w2[1]) :

                  (convtypeD == CONV_2 && convtypeW == CONV_2) ? d[3:2]*(w2[6] - 2*w2[7]) + 
                                                                 d[3:2]*(w2[4] - 2*w2[5]) + 
                                                                 d[3:2]*(w2[2] - 2*w2[3]) + 
                                                                 d[3:2]*(w2[0] - 2*w2[1]) : 0;

assign mul3_ref =                                                d[5:4]*(w3[6] - 2*w3[7]) + 
                                                                 d[5:4]*(w3[4] - 2*w3[5]) + 
                                                                 d[5:4]*(w3[2] - 2*w3[3]) + 
                                                                 d[5:4]*(w3[0] - 2*w3[1])    ;   // N4

assign mul4_ref =                                                d[7:6]*(w4[6] - 2*w4[7]) + 
                                                                 d[7:6]*(w4[4] - 2*w4[5]) + 
                                                                 d[7:6]*(w4[2] - 2*w4[3]) + 
                                                                 d[7:6]*(w4[0] - 2*w4[1])    ;   // N4


 
always @(negedge clk)
begin
  if          (convtypeD == CONV_8)   begin
    if ( mulL_ref != mul1 ) err <= 1; else err <= 0;
  end else if (convtypeD == CONV_4)   begin
    if ( mulL_ref != mul1 
      || mul2_ref != mul2 ) err <= 1; else err <= 0;
    if ( mulL_ref != mul1 ) err_m1 <= 1; 
    if ( mul2_ref != mul2 ) err_m2 <= 1;
  end else if (convtypeD == CONV_2 )   begin
    if ( mulL_ref != mul1 
      || mul2_ref != mul2 
      || mul3_ref != mul3 
      || mul4_ref != mul4 ) err <= 1; else err <= 0;
    if ( mulL_ref != mul1 ) err_m1 <= 1; 
    if ( mul2_ref != mul2 ) err_m2 <= 1;
    if ( mul3_ref != mul3 ) err_m3 <= 1; 
    if ( mul4_ref != mul4 ) err_m4 <= 1;
  end 

  if (err == 1) err1 <= 1;
end
 

initial // initial block executes only once
   begin

     #20;

     #20;
     // mult2
     /// 
     as = 1;
      for(j=0; j<4; j=j+1) 
        begin
          for(i=0; i<4; i=i+1) 
          begin
            a= i;
            b= j;
            #20;
          end
        end

    //d  = 8'hFF; // max positive
    //w1 = 8'h7F; // max positive

    d  = 1; 
    //d  = 8'haa; 
    //w1 = 1;
    w1 = 255;   //-1 
    //w1 = 8'h16;
    //w2 = 8'h73;
    //w1 = 8'b01010101;
    //w2 = 8'b01000101;
    convtypeD = CONV_8;
    convtypeW = CONV_8;
    // 8x8 d  = 1;            // max negative 
    // 8x8 w1 = 255;   //-1 
    // 8x8 #200;
    // 8x8 d  = 255;         // min negative
    // 8x8 w1 = 128;   //-1 
    // 8x8 #200;
    // 8x8 d  = 1;            // min positive 
    // 8x8 w1 = 1;    
    // 8x8 #200;
    // 8x8 d  = 255;            // max positive 
    // 8x8 w1 = 127; 
    //#20000;
       if (convtypeD == CONV_8)
         begin
           for(i=0; i<2**8; i=i+1) 
             begin
               for(j=0; j<2**8; j=j+1) 
               begin
                 d= i;
                 w1= j;
                 #20;
               end
             end
         end
       else if (convtypeD == CONV_4)
         begin
           for(i=0; i<2**8; i=i+1) 
             for(j=0; j<2**8; j=j+1) 
               for(j2=0; j2<2**8; j2=j2+1) 
               begin
                 d= i;
                 w1= j;
                 w2= j2;
                 #20;
               end
         end
       else if (convtypeD == CONV_2)
         begin
           d = 0;
           //w1= 0;
           w2= 50;
           w3= 23;
           w4= -7;
           for(i=0; i<2**8; i=i+1) 
             for(j=0; j<2**8; j=j+1) 
               begin
                 d= i;
                 w1= j;
                 w2= {w2[6:0], w2[7]};
                 w3= {w3[6:0], w3[7]};
                 w4= {w4[6:0], w4[7]};
                 #20;
               end
         end

    //   for(j=0; j<4; j=j+1) 
    //    begin
    //      for(i=0; i<4; i=i+1) 
    //      begin
    //        a= i;
    //        b= j;
    //        #20;
    //      end
    //    end


      //   #period;
   end



endmodule
