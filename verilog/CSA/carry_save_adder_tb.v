module carry_save_adder_tb;
parameter N = 32;  // 3; // 4; // 5; // 6; // 7; // 9; // 12; // 14; // 25; // 49; //  3+ number of busses 
parameter E =  5;  // 1; // 2; // 2; // 2; // 2; // 3; //  3; //  3; // 4;  // 5 ; //  bit extention ( N=9 -> E=3, N=25 -> E=4)
parameter W = 4;  //    input data width


wire [W+E-1:0] sum;//output
wire cout;//output
reg  [W-1:0] a,b,c,d;//input
wire  [W+E:0] ref_sum;
//wire [W+E:0] acc;
wire [W+E:0] total_sum;
wire err;
reg  [W*N-1:0] aa;
wire [W+E :0] cla_sum; 
wire  axor; 
integer           i,j;
reg err1;

carry_save_adder #(
.N (N) , 
.E (E) , 
.W (W)     
) 
uut
(
.a(aa),
.sum(sum),
.cout(cout)//,
//.cla_sum(cla_sum)
);


initial begin
$display($time, " << Starting the Simulation >>");
  //     a=0;      b=0;     c=0;     d=0;
  //#100 a= 4'd10; b=4'd0;  c=4'd0;  d=4'd0;
  //#100 a= 4'd10; b=4'd10; c=4'd0;  d=4'd0;
  //#100 a= 4'd4;  b=4'd6;  c=4'd12; d=4'd0;
  //#100 a= 4'd11; b=4'd2;  c=4'd4;  d=4'd7;
  //#100 a= 4'd20; b=4'd0;  c=4'd20; d=4'd0;
  //#100 a= 4'd12; b=4'd5;  c=4'd10; d=4'd10;
  //#100 a= 4'd7;  b=4'd6;  c=4'd12; d=4'd8;
  //#100 a= 4'd15; b=4'd15; c=4'd15; d=4'd15;
 
  //aa[W*N-1:0] <= 100'd5677990231;
  //aa[W*N-1:0] <= 100'hfffffffffff;
  aa[W*N-1:0] <= 100'hfffffffffffffffffffffffff;
  //aa[W*N-1:0] <= 100'd5677990543656541214231;
  //aa[W*N-1:0] <= 200'hfffffffffffffffffffffffffffffffffffffffffffffffff;
  err1 <= 0;
  #100;
  // $monitor("aa= %d",aa);
  //$display($time, "  aa= %d",aa);
  $display($time, " TB output sum | width= %d ",W+E  );

  for(j=0; j<100000; j=j+1) 
  begin
     aa <= { aa[W*N-2:0], (aa[W*N-1] ^ aa[W*N-2] ) };
     //acc <= 0;
     //for (int i=0; i<N-1; i=i+1) 
     //  ref_sum <= ref_sum + aa[ 0*W +: W];
     if (err)
      err1 <= 1;
     #100;
  end

//assign  axor = aa[W*N-1] ^ aa[W*N-2] ;
if (err1)
  $display(" << Fail >>");
else
  $display(" << Pass >>");

$display($time, " << ENd of the Simulation >>");
end
//assign aa = {a,b,c,d};
//assign total_sum = {cout,sum };
assign total_sum [W+E-1:0] = sum;
assign total_sum [W+E]     = cout;

assign ref_sum = (N == 49)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W] + 
                              aa[10*W +: W] + aa[11*W +: W] + aa[12*W +: W] + aa[13*W +: W] + aa[14*W +: W] + 
                              aa[15*W +: W] + aa[16*W +: W] + aa[17*W +: W] + aa[18*W +: W] + aa[19*W +: W] + 
                              aa[20*W +: W] + aa[21*W +: W] + aa[22*W +: W] + aa[23*W +: W] + aa[24*W +: W] + 
                              aa[25*W +: W] + aa[26*W +: W] + aa[27*W +: W] + aa[28*W +: W] + aa[29*W +: W] + 
                              aa[30*W +: W] + aa[31*W +: W] + aa[32*W +: W] + aa[33*W +: W] + aa[34*W +: W] + 
                              aa[35*W +: W] + aa[36*W +: W] + aa[37*W +: W] + aa[38*W +: W] + aa[39*W +: W] + 
                              aa[40*W +: W] + aa[41*W +: W] + aa[42*W +: W] + aa[43*W +: W] + aa[44*W +: W] + 
                              aa[45*W +: W] + aa[46*W +: W] + aa[47*W +: W] + aa[48*W +: W]                                 :
                 (N == 25)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W] + 
                              aa[10*W +: W] + aa[11*W +: W] + aa[12*W +: W] + aa[13*W +: W] + aa[14*W +: W] + 
                              aa[15*W +: W] + aa[16*W +: W] + aa[17*W +: W] + aa[18*W +: W] + aa[19*W +: W] + 
                              aa[20*W +: W] + aa[21*W +: W] + aa[22*W +: W] + aa[23*W +: W] + aa[24*W +: W]                 :
                 (N == 15)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W] + 
                              aa[10*W +: W] + aa[11*W +: W] + aa[12*W +: W] + aa[13*W +: W] + aa[14*W +: W]                 : 
                 (N == 14)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W] + 
                              aa[10*W +: W] + aa[11*W +: W] + aa[12*W +: W] + aa[13*W +: W]                                 : 
                 (N == 13)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W] + 
                              aa[10*W +: W] + aa[11*W +: W] + aa[12*W +: W]                                                 :
                 (N == 12)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W] + 
                              aa[10*W +: W] + aa[11*W +: W]                                                                 : 

                 (N == 11)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W] + 
                              aa[10*W +: W]                                                                                 : 

                 (N == 10)  ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W] + aa[ 9*W +: W]                 :  

                 (N == 9)   ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W] + aa[ 7*W +: W] + aa[ 8*W +: W]                                 :
                 (N == 7)   ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + 
                              aa[ 5*W +: W] + aa[ 6*W +: W]                                                                 :
                 (N == 6)   ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W] + aa[ 5*W +: W] :
                 (N == 5)   ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W] + aa[ 4*W +: W]                 :
                 (N == 4)   ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W] + aa[ 3*W +: W]                                 :
                 (N == 3)   ? aa[ 0*W +: W] + aa[ 1*W +: W] + aa[ 2*W +: W]                                                 :
                              0 ;


//assign err = (total_sum == ref_sum) ? 0 : 1;
assign err = (total_sum != ref_sum) ? 1 :
           //  (  cla_sum != ref_sum) ? 1 :
                                      0 ;

//initial
//  $monitor("A=%d, B=%d, C=%d,D=%d, || Sum= %d, Cout=%d, | Total= %d | Ref= %d || Err= %d",a,b,c,d,sum,cout,total_sum,ref_sum,err);
endmodule