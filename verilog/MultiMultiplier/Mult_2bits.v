 module Mult_2bits    
 (
    input             as , // sign of a
    input       [1:0] a  , //   signed
    input       [1:0] b  , // unsigned
    output wire [4:0] mul    
);


//  sum =  {1'b0,   1'b0,         1'b0,        1'b1 , a[1]&b[0], a[0]&b[0]} + 
//         {1'b0,   1'b0,         1'b1,   a[1]&b[1] , a[0]&b[1],     1'b0 } + 
//         {1'b0,   1'b1, ~{a[1]&b[2]}, ~{a[0]&b[2]},      1'b0,     1'b0 } ;

wire [2:0] a_s;
wire a0b0, a1b0, a1b1, a0b1;
wire ha1c;
wire fa2c, fa2s, ha2c;
wire fa3c, fa3s, ha3c,fa4c ; 
//wire st2_c_1, st2_c_2; // stage #2 carry and carry2 
//wire st3_c           ; // stage #3 carry

assign a_s   = {   as,a};
assign a0b0 =   a_s[0] && b[0]  ;
assign a0b1 =   a_s[0] && b[1]  ;
assign a1b0 =   a_s[1] && b[0]  ;
assign a1b1 =   a_s[1] && b[1]  ;
assign a2b0 = ~(a_s[2] && b[0]) ;
assign a2b1 = ~(a_s[2] && b[1]) ;

assign mul[  0] = a0b0;
assign mul[4:1] = {1'b0,  1'b0, 1'b1,  a0b1 } + 
                  {1'b0,  1'b0, a1b1,  a1b0 } + 
                  {1'b1,  a2b1, a2b0,  1'b0 } ;

//assign mul[0] = a0b0;
//half_adder ha1 ( .a(a1b0), .b(a0b1) ,               .sum(mul[1]), .cout(ha1c) );
//
//full_adder fa2 ( .a(a1b1), .b(a2b0) , .cin(ha1c) ,  .sum( fa2s ), .cout(fa2c)  );
//half_adder ha2 ( .a(fa2s), .b(1'b1) ,               .sum(mul[2]), .cout(ha2c)  );
//
//full_adder fa3 ( .a(a2b1), .b(fa2c) , .cin(ha2c)  , .sum (fa3s ), .cout(fa3c)  );
//half_adder ha3 ( .a(fa3s), .b(1'b1) ,               .sum(mul[3]), .cout(ha3c)  );
//
//full_adder fa4 ( .a(fa3c), .b(ha3c) , .cin(1'b1)  , .sum (mul[4]), .cout(fa4c) );

//assign as = {bs,a};
//
//assign a0b0 =   b[0] && as[0]  ;
//assign a1b0 =   b[1] && as[0]  ;
//assign a0b1 =   b[0] && as[1]  ;
//assign a1b1 =   b[1] && as[1]  ;
//assign a0b2 = ~(b[0] && as[2]) ;
//assign a1b2 = ~(b[1] && as[2]) ;
//
//assign mul[0] = a0b0;
//
//  half_adder ha1(.a(a1b0), .b(a0b1) , .sum(mul[1]), .cout(ha1c) );
//
//assign mul[2]   = ~(a1b1  ^ a0b2  ^ ha1c);
//assign st2_c_1  = ~(a1b1 && a0b2 && ha1c || ~a1b0 && ~a0b1 && ~ha1c);
//assign st2_c_2  =   a1b1 && a0b2 && ha1c;
//
//assign mul[3]   = ~(st2_c_1  ^ a1b2);
//assign st3_c    = ~(st2_c_1 && a1b2);
//
//assign mul[4] = ~st3_c;

endmodule