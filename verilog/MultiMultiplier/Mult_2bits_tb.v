  `timescale 1 ns/10 ps 

 module Mult_2bits_tb ();
    parameter STRUCT = 0; // 0-structural, 1 - behavioral adder


    reg     clk      ;
    reg     rst      ;
//    reg     [1:0] a  ; // unsigned
//    reg     [1:0] b  ; // unsigned
//    reg           cin;
//    wire    [3:0] mul;  


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

    localparam period = 20;
localparam [1:0] CONV_2  = 2'b01;
localparam [1:0] CONV_4  = 2'b10;
localparam [1:0] CONV_8  = 2'b11;

    integer          j,i,k;


//Mult_2bits  
//   UUT
//   (
//  .a   (a   ), 
//  .b   (b   ), 
//  .mul (mul )
//   );

Signed2SMagnitude  
   UUT
   (
  .d_in     ( aa       ), 
  .convtype ( convtype ), 
  .sign     ( sign     ),
  .d_out    ( d_out    )
   );

MultiMultiplier8x8
MUL_DUT
(
    .d         (d         ), // unsigned (data)
    .w1        (w1        ), //   signed (weights) for data input - 8 4 2
    .w2        (w2        ), //   signed (weights) for data input -   4 2
    .w3        (w3        ), //   signed (weights) for data input -     2
    .w4        (w4        ), //   signed (weights) for data input -     2
    .convtypeD (convtypeD ),
    .convtypeW (convtypeW ),
    .addL_res_o(addL_res_o), 
    .addM_res_o(addM_res_o),
    .mul       (mul       )
);

always 
begin
    clk = 1'b1; 
    #10; // high for 20 * timescale = 20 ns

    clk = 1'b0;
    #10; // low for 20 * timescale = 20 ns
end

assign mulL_ref = d*w1;
initial // initial block executes only once
   begin

     #20;

     #20;
    d  = 8'hFF;
    w1 = 8'h7F;
    convtypeD = CONV_8;
    convtypeW = CONV_8;


     #20000;
       for(j=1; j<4; j=j+1) 
        begin
          for(i=0; i<2**8; i=i+1) 
          begin
            aa= i;
            convtype= j;
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
