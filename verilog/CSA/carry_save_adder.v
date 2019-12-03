module carry_save_adder #(
	parameter N      = 4, // 3+ number of busses 
    parameter W      = 4  //    input data width
)
//(a,b,c,d, sum,cout);
(a, sum, cout);
input  [N*W-1:0] a; //, b,c,d;
output [W  :0] sum;
output cout;

// inputs 1-4
wire [W-1:0] s0, s1;
wire [W-1:0] c0, c1;


///////
wire [W:0] sum1, sum2, sum3;
wire [W:0] ca1 , ca2 , ca3 ;


wire [W+1:0] sum4, sum5;
wire [W+1:0] ca4 , ca5 ;

wire [W+1:0] sum6, sum7;
wire [W+1:0] ca6 , ca7 ;


wire [W+4:0] test1, test2, test3, test4;
//// inputs 4-8
//wire [W:0] s2, s3, s4, s5;
//wire [W:0] c2, c3, c4, c5;
//
//// inputs 9-15
//wire [W:0] s6, s7, s8, s9, s10, s11, s12, s13;
//wire [W:0] c6, c7, c8, c9, c10, c11, c12, c13;

genvar i,j;
////////////////////////
// inputs 1-4
////////////////////////
//1st Statge

carry_save_3inputs #(W) cs_3in_1 (.a(a[0*W +: 3*W ]), .sum(sum1), .cout(ca1)  );
carry_save_3inputs #(W) cs_3in_2 (.a(a[3*W +: 3*W ]), .sum(sum2), .cout(ca2)  );
carry_save_3inputs #(W) cs_3in_3 (.a(a[6*W +: 3*W ]), .sum(sum3), .cout(ca3)  );

assign test1 = sum1 + ca1 + sum2 + ca2 + sum3 + ca3;

carry_save_3inputs #(W+1) cs_3in_11 (.a({sum1,sum2,sum3}), .sum(sum4), .cout(ca4)  );
carry_save_3inputs #(W+1) cs_3in_12 (.a({ca1 ,ca2 ,ca3 }), .sum(sum5), .cout(ca5)  );

assign test2 = sum4 + ca4 + sum5 + ca5;

carry_save_3inputs #(W+2) cs_3in_21 (.a({sum4 ,sum5 ,ca4 }), .sum(sum6), .cout(ca6)  );

assign test3 = sum6 + ca6 + ca5;

//carry_save_3inputs #(W+2) cs_3in_22 (.a({{(W+2){1'b0}} ,sum6 ,ca6 }), .sum(sum7), .cout(ca7)  );
carry_save_3inputs #(W+2) cs_3in_22 (.a({ca5,sum6 ,ca6 }), .sum(sum7), .cout(ca7)  );

assign test4 = sum7 + ca7;

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
	//for (j=0; j<=N-4; j=j+1) begin
	 full_adder fa_2 ( .a(a[3*W+0]), .b(s0[0]), .cin(1'b0), .sum(sum[0]), .cout(c1[0])  );
   //full_adder fa_2 ( .a(a[3*W+0]), .b(s0[0]), .cin(1'b0), .sum(s1[0]), .cout(c1[0])  );
       for (i=1; i<=W-1; i=i+1) begin
        full_adder fa2 ( .a(a[3*W+i]), .b(s0[i]), .cin(c0[i-1]), .sum(s1[i-1]), .cout(c1[i])  );
        //  full_adder fa2 ( .a(a[3*W+i]), .b(s0[i]), .cin(c0[i-1]), .sum(s1[i]), .cout(c1[i])  );
       end
    //end 
endgenerate
//2nd Stage
//full_adder fa4( .a(d[0]), .b(s0[0]), .cin(1'b0), .sum(sum[0]), .cout(c1[0]));
//full_adder fa5( .a(d[1]), .b(s0[1]), .cin(c0[0]), .sum(s1[0]), .cout(c1[1]));
//full_adder fa6( .a(d[2]), .b(s0[2]), .cin(c0[1]), .sum(s1[1]), .cout(c1[2]));
//full_adder fa7( .a(d[3]), .b(s0[3]), .cin(c0[2]), .sum(s1[2]), .cout(c1[3]));

////////////////////////
// inputs 5-8
////////////////////////
//3rd Stage
///generate
///	//for (j=0; j<=N-4; j=j+1) begin
///	   full_adder    fa_3( .a(a[4*W+0]), .b(s1[0]), .cin(1'b0), .sum(sum[0]), .cout(c2[0])  );
///       for (i=1; i<=W-1; i=i+1) begin
///          full_adder fa3 ( .a(a[4*W+i]), .b(s0[i]), .cin(c0[i-1]), .sum(s2[i-1]), .cout(c2[i])  );
///       end
///    //end 
///endgenerate


assign s1[3] = 1'b0;
//assign s2[3] = 1'b0;

//  ripple_carry_4_bit rca1 (.a(c1[3:0]),.b({c0[3],s1[2:0]}), .cin(1'b0),.sum(sum[4:1]), .cout(cout));
ripple_carry_4_bit #(W+2) rca1 (.a(sum7),.b(ca7), .cin(1'b0),.sum(sum[4:1]), .cout(cout));

endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////
// Carry Save 3 inputs (one stage)
////////////////////////////////////

module carry_save_3inputs #(
    parameter W      = 4  //    input data width
)
//(a,b,c,d, sum,cout);
(a, sum, cout);
input  [3*W-1:0] a; //, b,c,d;
output [W  :0] sum;
output [W  :0] cout;

genvar i;

//1st Statge
generate
   for (i=0; i<=W-1; i=i+1) begin
      full_adder fa1 ( .a(a[0*W+i]), .b(a[1*W+i]),  .cin(a[2*W+i]), .sum(sum[i]), .cout(cout[i+1])  );
   end 
endgenerate

assign cout[0] = 1'b0;
assign sum [W] = 1'b0;

//full_adder fa0( .a(a[0]), .b(b[0]), .cin(c[0]), .sum(s0[0]), .cout(c0[0]));
//full_adder fa1( .a(a[1]), .b(b[1]), .cin(c[1]), .sum(s0[1]), .cout(c0[1]));
//full_adder fa2( .a(a[2]), .b(b[2]), .cin(c[2]), .sum(s0[2]), .cout(c0[2]));
//full_adder fa3( .a(a[3]), .b(b[3]), .cin(c[3]), .sum(s0[3]), .cout(c0[3]));

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