 module Mult_3bits    
 (
    input             as , // sign of a
    input       [2:0] a  , //   signed
    input       [2:0] b  , // unsigned
    output wire [6:0] mul    
);


//  sum =  {1'b0,   1'b0,         1'b0,        1'b1 , a[1]&b[0], a[0]&b[0]} + 
//         {1'b0,   1'b0,         1'b0,   a[1]&b[1] , a[0]&b[1],     1'b0 } + 
//         {1'b0,   1'b1, ~{a[1]&b[2]}, ~{a[0]&b[2]},      1'b0,     1'b0 } ;
                    


wire [3:0] a_s;
wire a0b0, a1b0, a2b0, a0b1, a1b1, a2b1, a0b2, a1b2, a2b2, a3b0, a3b1, a3b2 ;
//wire ha1c;
//wire fa2c, fa2s, ha2c;
//wire fa3c, fa3s, ha3c,fa4c ; 

//wire st2_c, st2_p;
//wire [4:0] m_tst;

assign a_s   = {   as,a};
assign a0b0 =   a_s[0] && b[0]  ;
assign a0b1 =   a_s[0] && b[1]  ;
assign a0b2 =   a_s[0] && b[2]  ;

assign a1b0 =   a_s[1] && b[0]  ;
assign a1b1 =   a_s[1] && b[1]  ;
assign a1b2 =   a_s[1] && b[2]  ;

assign a2b0 =   a_s[2] && b[0]  ;
assign a2b1 =   a_s[2] && b[1]  ;
assign a2b2 =   a_s[2] && b[2]  ;

assign a3b0 = ~(a_s[3] && b[0]) ;
assign a3b1 = ~(a_s[3] && b[1]) ;
assign a3b2 = ~(a_s[3] && b[2]) ;

//// Based on RCA
assign mul[  0] =                            a0b0;
assign mul[6:1] = {1'b0,  1'b0,  1'b0,  1'b1,  a0b2,  a0b1 } + 
                  {1'b0,  1'b0,  1'b0,  a1b2,  a1b1,  a1b0 } + 
                  {1'b0,  1'b0,  a2b2,  a2b1,  a2b0,  1'b0 } +
                  {1'b1,  a3b2,  a3b1,  a3b0,  1'b0,  1'b0 } ;

////// Based on CSA 
//// st 0
//assign mul[  0] = a0b0;
//
//// st 1
//half_adder ha1 ( .a(a1b0), .b(a0b1) ,               .sum(mul[1]), .cout(ha1c) );
//
//// st 2
//assign mul[2] = ~(ha1c ^ a1b1 ^ a2b0);
//assign st2_c = ha1c && ~a1b1  || ~ha1c && a2b0 || a1b1 && ~a2b0;
//assign st2_p = ha1c && a1b1 && a2b0;
//
//// st 3 
//half_adder ha3 ( .a(a2b1), .b(st2_c) ,               .sum(mul[3]), .cout(ha2c) );
//
//// st 4
//assign mul[4] = ~(st2_p ^ ha2c);
//


endmodule