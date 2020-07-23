 module Mult_2bits    
 (
    input      [1:0] a  , // unsigned
    input      [1:0] b  , // unsigned
    output wire [3:0] mul    
);



wire a0b0, a1b0, a1b1, a0b1;
wire ha1c;

assign a0b0 = a[0] && b[0] ;
assign a1b0 = a[1] && b[0] ;
assign a1b1 = a[1] && b[1] ;
assign a0b1 = a[0] && b[1] ;

assign mul[0] = a0b0;

  half_adder ha1(.a(a1b0), .b(a0b1) , .sum(mul[1]), .cout(ha1c) );
  half_adder ha2(.a(a1b1), .b(ha1c) , .sum(mul[2]), .cout(mul[3]) );

endmodule