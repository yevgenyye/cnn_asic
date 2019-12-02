module carry_save_adder #(
	parameter N      = 4, // 3+ number of busses 
    parameter W      = 4  //    input data width
)
//(a,b,c,d, sum,cout);
(a, sum, cout);
input  [N*W-1:0] a; //, b,c,d;
output [W  :0] sum;
output cout;
 
wire [W-1:0] s0,s1;
wire [W-1:0] c0, c1;
genvar i,j;


//1st Statge
generate
    for (i=0; i<=W-1; i=i+1) begin
    full_adder fa1 ( .a(a[0*W+i]), .b(a[1*W+i]),  .cin(a[2*W+i]), .sum(s0[i]), .cout(c0[i])  );
end 
endgenerate
//full_adder fa0( .a(a[0]), .b(b[0]), .cin(c[0]), .sum(s0[0]), .cout(c0[0]));
//full_adder fa1( .a(a[1]), .b(b[1]), .cin(c[1]), .sum(s0[1]), .cout(c0[1]));
//full_adder fa2( .a(a[2]), .b(b[2]), .cin(c[2]), .sum(s0[2]), .cout(c0[2]));
//full_adder fa3( .a(a[3]), .b(b[3]), .cin(c[3]), .sum(s0[3]), .cout(c0[3]));

generate
	for (j=4; j<=N; j=j+1) begin
	   full_adder fa_2 ( .a(a[3*W+0]), .b(s0[0]), .cin(1'b0), .sum(sum[0]), .cout(c1[0])  );
       for (i=1; i<=W-1; i=i+1) begin
          full_adder fa2 ( .a(a[3*W+i]), .b(s0[i]), .cin(c0[i-1]), .sum(s1[i-1]), .cout(c1[i])  );
       end
    end 
endgenerate
//2nd Stage
//full_adder fa4( .a(d[0]), .b(s0[0]), .cin(1'b0), .sum(sum[0]), .cout(c1[0]));
//full_adder fa5( .a(d[1]), .b(s0[1]), .cin(c0[0]), .sum(s1[0]), .cout(c1[1]));
//full_adder fa6( .a(d[2]), .b(s0[2]), .cin(c0[1]), .sum(s1[1]), .cout(c1[2]));
//full_adder fa7( .a(d[3]), .b(s0[3]), .cin(c0[2]), .sum(s1[2]), .cout(c1[3]));

assign s1[3] = 1'b0;

 ripple_carry_4_bit rca1 (.a(c1[3:0]),.b({c0[3],s1[2:0]}), .cin(1'b0),.sum(sum[4:1]), .cout(cout));

endmodule

////////////////////////////////////
//4-bit Ripple Carry Adder
////////////////////////////////////
 
module ripple_carry_4_bit(a, b, cin, sum, cout);
input [3:0] a,b;
input cin;
wire c1,c2,c3;
output [3:0] sum;
output cout;


full_adder fa0(.a(a[0]), .b(b[0]),.cin(cin), .sum(sum[0]),.cout(c1));
full_adder fa1(.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]),.cout(c2));
full_adder fa2(.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]),.cout(c3));
full_adder fa3(.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]),.cout(cout));
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