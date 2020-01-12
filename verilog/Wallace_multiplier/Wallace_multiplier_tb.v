module wallace_multiplier_tb;
    parameter N      =  8; // X X X X 4 input A data width N>= W
    parameter W      =  5; // 1 2 3 4 4 input B data width

reg [  N-1 :0] a; 
reg [  W-1 :0] b;
wire [N+W-2 :0] prod;


wire [N+W-1:0] prod_ref;
//reg [N+W-1:0] total_sum;
reg err;
integer   i,j;
reg err1;
reg err2;   
wire a_sign, b_sign, ref_sign;
wire [  N-1 :0] a_magn; 
wire [  W-1 :0] b_magn;
wire [N+W-1 :0] ref_magn;

wallace_gen 
 #(
    .N (N),
    .W (W)
)
uut
(
  .a    (a)   , 
  .b    (b)   , 
  .prod (prod)     
);


initial begin
$display($time, " << Starting the Simulation >>");

  a = 0;
  b = 0;
  err1 <= 0;
  #100;
  // $monitor("aa= %d",aa);
  //$display($time, "  aa= %d",aa);
  $display($time, " TB output sum | width= %d ",W+N  );

  //for(j=0; j<1000000; j=j+1) 
  for(j=0; j<((2**N) * (2**W)); j=j+1) 
  begin
    b = b + 1;
    if (b == 0)
      a = a + 1;

     //if (err)
     // err1 <= 1;
     #100;
  end

if (err1)
  $display(" << Fail >>");
else
  $display(" << Pass >>");

$display($time, " << ENd of the Simulation >>");
#1000;
//$stop;

end // initial

assign a_sign = a[N-1];
assign b_sign = b[W-1];
assign a_magn = (a_sign == 0) ? {1'b0 , a[N-2:0]} : (a=={1'b1, {(N-1){1'b0}} } ) ? a : {1'b0, (~a[N-2:0])} + 1 ;
assign b_magn = (b_sign == 0) ? {1'b0 , b[W-2:0]} : (b=={1'b1, {(W-1){1'b0}} } ) ? b : {1'b0, (~b[W-2:0])} + 1 ;

assign ref_magn = a_magn * b_magn;
assign ref_sign = (a_sign == b_sign) ? 0 : 1;
assign prod_ref = (ref_sign == 0) ? ref_magn : ~ref_magn + 1;
//assign err = (prod_ref == prod)  ? 0 : 1;
//assign err2 = (err == 1) ? 1 : err2;
always @(err, prod)
  begin
    if (prod_ref[N+W-2 :0] == prod)
      err = 0;
    else
      err = 1;

    if (err == 1)
      err1 = 1;

  end

//always @(a)
//  begin
//    ref_sum = 0;
//    for ( i=0; i<=N-1; i=i+1) 
//      
//    if (prod != ref_sum)
//      err = 1;
//    else
//      err = 0 ;
//  end

endmodule