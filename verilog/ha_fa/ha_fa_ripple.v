///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////
//Generic Ripple Carry Adder
////////////////////////////////////
 
module ripple_carry#(
    parameter W      = 4  //    input data width
)
(a, b, cin, sum, cout);
input  [W-1:0] a,b;
input          cin;
wire   [W  :0] c1;
output [W-1:0] sum;
output cout;

genvar i;

generate
   for (i=0; i<=W-1; i=i+1) begin  :gen_rca
      full_adder fa1 ( .a(a[i]), .b(b[i]),  .cin(c1[i]), .sum(sum[i]), .cout(c1[i+1])  );
   end 
endgenerate
assign c1[0] = cin;
assign cout  = c1[W];

endmodule

////////////////////////////////////////////
//1bit Full Adder
///////////////////////////////////////////
module full_adder(a,b,cin,sum, cout);
input a,b,cin;
output sum, cout;
wire x,y,z;
half_adder  h1(.a(a), .b(b), .sum(x), .cout(y));
half_adder  h2(.a(x), .b(cin), .sum(sum), .cout(z));
assign cout= y|z;
endmodule
///////////////////////////////////////////
// 1 bit Half Adder
////////////////////////////////////////////
module half_adder( a,b, sum, cout );
input a,b;
output sum,  cout;
assign sum= a^b;
assign cout= a & b;
endmodule
