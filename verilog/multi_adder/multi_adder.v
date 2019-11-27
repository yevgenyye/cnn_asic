 module multi_adder    #(
    parameter CL_IN = 3,  // number of inputs features
    parameter N     = 8,  // input/output data width
    parameter SR    = 2   // data shift right before output

) (
    input wire               clk  ,
    input wire               rst  ,
    input wire [CL_IN*N-1:0] d_in ,
    input wire               en_in,

    output reg [N-1:0]      d_out ,
    output reg              en_out    
);

 integer i = 0;
 parameter E  = 4; // Number of extention bits (6 for 64 inputs, 8 for 256 inputs ,..)
 //parameter NMP1 = N + M + 1;
 //reg [256*(N+E)-1:0] d_256;
 reg [64*(N+E)-1:0] d_64;
 reg [16*(N+E)-1:0] d_16;
 reg [ 4*(N+E)-1:0] d_4;
 reg [ 1*(N+E)-1:0] d_1;

 reg  en_64;
 reg  en_16;
 reg  en_4;

generate
   if ((CL_IN <= 64) && (CL_IN > 16))
      always @( d_in or en_in) 
      begin
         // sign extention to each data word
         // d_in, X words     _____[XN-1 .. (X-1)N] ..     _____[3N-1 .. 2N]   _____[2N-1 .. N]    _____[N-1 .. 0]
         //                  /    / |    ..      |        /    / |   .. |     /    / |    .. |    /    / |   .. |
         // d_N            [E bits][XN-1 .. (X-1)N] .. [E bits][3N-1 .. 2N] [E bits][2N-1 .. N] [E bits][N-1 .. 0]

                               // E bits  sign extention                   N bits copy from input                           assign zero value 
         if (CL_IN > 63) begin d_64[64*(N+E)-E +: E] <= {(E){d_in[64*N-1]}}; d_64[63*(N+E) +: N] <= { d_in[63*N +: N] }; end else d_64[63*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 62) begin d_64[63*(N+E)-E +: E] <= {(E){d_in[63*N-1]}}; d_64[62*(N+E) +: N] <= { d_in[62*N +: N] }; end else d_64[62*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 61) begin d_64[62*(N+E)-E +: E] <= {(E){d_in[62*N-1]}}; d_64[61*(N+E) +: N] <= { d_in[61*N +: N] }; end else d_64[61*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 60) begin d_64[61*(N+E)-E +: E] <= {(E){d_in[61*N-1]}}; d_64[60*(N+E) +: N] <= { d_in[60*N +: N] }; end else d_64[60*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 59) begin d_64[60*(N+E)-E +: E] <= {(E){d_in[60*N-1]}}; d_64[59*(N+E) +: N] <= { d_in[59*N +: N] }; end else d_64[59*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 58) begin d_64[59*(N+E)-E +: E] <= {(E){d_in[59*N-1]}}; d_64[58*(N+E) +: N] <= { d_in[58*N +: N] }; end else d_64[58*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 57) begin d_64[58*(N+E)-E +: E] <= {(E){d_in[58*N-1]}}; d_64[57*(N+E) +: N] <= { d_in[57*N +: N] }; end else d_64[57*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 56) begin d_64[57*(N+E)-E +: E] <= {(E){d_in[57*N-1]}}; d_64[56*(N+E) +: N] <= { d_in[56*N +: N] }; end else d_64[56*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 55) begin d_64[56*(N+E)-E +: E] <= {(E){d_in[56*N-1]}}; d_64[55*(N+E) +: N] <= { d_in[55*N +: N] }; end else d_64[55*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 54) begin d_64[55*(N+E)-E +: E] <= {(E){d_in[55*N-1]}}; d_64[54*(N+E) +: N] <= { d_in[54*N +: N] }; end else d_64[54*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 53) begin d_64[54*(N+E)-E +: E] <= {(E){d_in[54*N-1]}}; d_64[53*(N+E) +: N] <= { d_in[53*N +: N] }; end else d_64[53*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 52) begin d_64[53*(N+E)-E +: E] <= {(E){d_in[53*N-1]}}; d_64[52*(N+E) +: N] <= { d_in[52*N +: N] }; end else d_64[52*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 51) begin d_64[52*(N+E)-E +: E] <= {(E){d_in[52*N-1]}}; d_64[51*(N+E) +: N] <= { d_in[51*N +: N] }; end else d_64[51*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 50) begin d_64[51*(N+E)-E +: E] <= {(E){d_in[51*N-1]}}; d_64[50*(N+E) +: N] <= { d_in[50*N +: N] }; end else d_64[50*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 49) begin d_64[50*(N+E)-E +: E] <= {(E){d_in[50*N-1]}}; d_64[49*(N+E) +: N] <= { d_in[49*N +: N] }; end else d_64[49*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 48) begin d_64[49*(N+E)-E +: E] <= {(E){d_in[49*N-1]}}; d_64[48*(N+E) +: N] <= { d_in[48*N +: N] }; end else d_64[48*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 47) begin d_64[48*(N+E)-E +: E] <= {(E){d_in[48*N-1]}}; d_64[47*(N+E) +: N] <= { d_in[47*N +: N] }; end else d_64[47*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 46) begin d_64[47*(N+E)-E +: E] <= {(E){d_in[47*N-1]}}; d_64[46*(N+E) +: N] <= { d_in[46*N +: N] }; end else d_64[46*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 45) begin d_64[46*(N+E)-E +: E] <= {(E){d_in[46*N-1]}}; d_64[45*(N+E) +: N] <= { d_in[45*N +: N] }; end else d_64[45*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 44) begin d_64[45*(N+E)-E +: E] <= {(E){d_in[45*N-1]}}; d_64[44*(N+E) +: N] <= { d_in[44*N +: N] }; end else d_64[44*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 43) begin d_64[44*(N+E)-E +: E] <= {(E){d_in[44*N-1]}}; d_64[43*(N+E) +: N] <= { d_in[43*N +: N] }; end else d_64[43*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 42) begin d_64[43*(N+E)-E +: E] <= {(E){d_in[43*N-1]}}; d_64[42*(N+E) +: N] <= { d_in[42*N +: N] }; end else d_64[42*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 41) begin d_64[42*(N+E)-E +: E] <= {(E){d_in[42*N-1]}}; d_64[41*(N+E) +: N] <= { d_in[41*N +: N] }; end else d_64[41*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 40) begin d_64[41*(N+E)-E +: E] <= {(E){d_in[41*N-1]}}; d_64[40*(N+E) +: N] <= { d_in[40*N +: N] }; end else d_64[40*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 39) begin d_64[40*(N+E)-E +: E] <= {(E){d_in[40*N-1]}}; d_64[39*(N+E) +: N] <= { d_in[39*N +: N] }; end else d_64[39*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 38) begin d_64[39*(N+E)-E +: E] <= {(E){d_in[39*N-1]}}; d_64[38*(N+E) +: N] <= { d_in[38*N +: N] }; end else d_64[38*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 37) begin d_64[38*(N+E)-E +: E] <= {(E){d_in[38*N-1]}}; d_64[37*(N+E) +: N] <= { d_in[37*N +: N] }; end else d_64[37*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 36) begin d_64[37*(N+E)-E +: E] <= {(E){d_in[37*N-1]}}; d_64[36*(N+E) +: N] <= { d_in[36*N +: N] }; end else d_64[36*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 35) begin d_64[36*(N+E)-E +: E] <= {(E){d_in[36*N-1]}}; d_64[35*(N+E) +: N] <= { d_in[35*N +: N] }; end else d_64[35*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 34) begin d_64[35*(N+E)-E +: E] <= {(E){d_in[35*N-1]}}; d_64[34*(N+E) +: N] <= { d_in[34*N +: N] }; end else d_64[34*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 33) begin d_64[34*(N+E)-E +: E] <= {(E){d_in[34*N-1]}}; d_64[33*(N+E) +: N] <= { d_in[33*N +: N] }; end else d_64[33*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 32) begin d_64[33*(N+E)-E +: E] <= {(E){d_in[33*N-1]}}; d_64[32*(N+E) +: N] <= { d_in[32*N +: N] }; end else d_64[32*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 31) begin d_64[32*(N+E)-E +: E] <= {(E){d_in[32*N-1]}}; d_64[31*(N+E) +: N] <= { d_in[31*N +: N] }; end else d_64[31*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 30) begin d_64[31*(N+E)-E +: E] <= {(E){d_in[31*N-1]}}; d_64[30*(N+E) +: N] <= { d_in[30*N +: N] }; end else d_64[30*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 29) begin d_64[30*(N+E)-E +: E] <= {(E){d_in[30*N-1]}}; d_64[29*(N+E) +: N] <= { d_in[29*N +: N] }; end else d_64[29*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 28) begin d_64[29*(N+E)-E +: E] <= {(E){d_in[29*N-1]}}; d_64[28*(N+E) +: N] <= { d_in[28*N +: N] }; end else d_64[28*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 27) begin d_64[28*(N+E)-E +: E] <= {(E){d_in[28*N-1]}}; d_64[27*(N+E) +: N] <= { d_in[27*N +: N] }; end else d_64[27*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 26) begin d_64[27*(N+E)-E +: E] <= {(E){d_in[27*N-1]}}; d_64[26*(N+E) +: N] <= { d_in[26*N +: N] }; end else d_64[26*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 25) begin d_64[26*(N+E)-E +: E] <= {(E){d_in[26*N-1]}}; d_64[25*(N+E) +: N] <= { d_in[25*N +: N] }; end else d_64[25*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 24) begin d_64[25*(N+E)-E +: E] <= {(E){d_in[25*N-1]}}; d_64[24*(N+E) +: N] <= { d_in[24*N +: N] }; end else d_64[24*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 23) begin d_64[24*(N+E)-E +: E] <= {(E){d_in[24*N-1]}}; d_64[23*(N+E) +: N] <= { d_in[23*N +: N] }; end else d_64[23*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 22) begin d_64[23*(N+E)-E +: E] <= {(E){d_in[23*N-1]}}; d_64[22*(N+E) +: N] <= { d_in[22*N +: N] }; end else d_64[22*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 21) begin d_64[22*(N+E)-E +: E] <= {(E){d_in[22*N-1]}}; d_64[21*(N+E) +: N] <= { d_in[21*N +: N] }; end else d_64[21*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 20) begin d_64[21*(N+E)-E +: E] <= {(E){d_in[21*N-1]}}; d_64[20*(N+E) +: N] <= { d_in[20*N +: N] }; end else d_64[20*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 19) begin d_64[20*(N+E)-E +: E] <= {(E){d_in[20*N-1]}}; d_64[19*(N+E) +: N] <= { d_in[19*N +: N] }; end else d_64[19*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 18) begin d_64[19*(N+E)-E +: E] <= {(E){d_in[19*N-1]}}; d_64[18*(N+E) +: N] <= { d_in[18*N +: N] }; end else d_64[18*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 17) begin d_64[18*(N+E)-E +: E] <= {(E){d_in[18*N-1]}}; d_64[17*(N+E) +: N] <= { d_in[17*N +: N] }; end else d_64[17*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 16) begin d_64[17*(N+E)-E +: E] <= {(E){d_in[17*N-1]}}; d_64[16*(N+E) +: N] <= { d_in[16*N +: N] }; end else d_64[16*(N+E) +: (N+E)] <= {(N+E){1'b0}};
                               d_64[16*(N+E)-E +: E] <= {(E){d_in[16*N-1]}}; d_64[15*(N+E) +: N] <= { d_in[15*N +: N] };
                               d_64[15*(N+E)-E +: E] <= {(E){d_in[15*N-1]}}; d_64[14*(N+E) +: N] <= { d_in[14*N +: N] };
                               d_64[14*(N+E)-E +: E] <= {(E){d_in[14*N-1]}}; d_64[13*(N+E) +: N] <= { d_in[13*N +: N] };
                               d_64[13*(N+E)-E +: E] <= {(E){d_in[13*N-1]}}; d_64[12*(N+E) +: N] <= { d_in[12*N +: N] };
                               d_64[12*(N+E)-E +: E] <= {(E){d_in[12*N-1]}}; d_64[11*(N+E) +: N] <= { d_in[11*N +: N] };
                               d_64[11*(N+E)-E +: E] <= {(E){d_in[11*N-1]}}; d_64[10*(N+E) +: N] <= { d_in[10*N +: N] };
                               d_64[10*(N+E)-E +: E] <= {(E){d_in[10*N-1]}}; d_64[ 9*(N+E) +: N] <= { d_in[ 9*N +: N] };
                               d_64[ 9*(N+E)-E +: E] <= {(E){d_in[ 9*N-1]}}; d_64[ 8*(N+E) +: N] <= { d_in[ 8*N +: N] };
                               d_64[ 8*(N+E)-E +: E] <= {(E){d_in[ 8*N-1]}}; d_64[ 7*(N+E) +: N] <= { d_in[ 7*N +: N] };
                               d_64[ 7*(N+E)-E +: E] <= {(E){d_in[ 7*N-1]}}; d_64[ 6*(N+E) +: N] <= { d_in[ 6*N +: N] };
                               d_64[ 6*(N+E)-E +: E] <= {(E){d_in[ 6*N-1]}}; d_64[ 5*(N+E) +: N] <= { d_in[ 5*N +: N] };
                               d_64[ 5*(N+E)-E +: E] <= {(E){d_in[ 5*N-1]}}; d_64[ 4*(N+E) +: N] <= { d_in[ 4*N +: N] };
                               d_64[ 4*(N+E)-E +: E] <= {(E){d_in[ 4*N-1]}}; d_64[ 3*(N+E) +: N] <= { d_in[ 3*N +: N] };
                               d_64[ 3*(N+E)-E +: E] <= {(E){d_in[ 3*N-1]}}; d_64[ 2*(N+E) +: N] <= { d_in[ 2*N +: N] };
                               d_64[ 2*(N+E)-E +: E] <= {(E){d_in[ 2*N-1]}}; d_64[ 1*(N+E) +: N] <= { d_in[ 1*N +: N] };
                               d_64[ 1*(N+E)-E +: E] <= {(E){d_in[ 1*N-1]}}; d_64[ 0*(N+E) +: N] <= { d_in[ 0*N +: N] };
                               en_64 <= en_in;
      end
endgenerate

generate
   if ((CL_IN <= 16) && (CL_IN > 4))
      always @( d_in or en_in) 
      begin
         // sign extention to each data word
         // d_in, X words     _____[XN-1 .. (X-1)N] ..     _____[3N-1 .. 2N]   _____[2N-1 .. N]    _____[N-1 .. 0]
         //                  /    / |    ..      |        /    / |   .. |     /    / |    .. |    /    / |   .. |
         // d_N            [E bits][XN-1 .. (X-1)N] .. [E bits][3N-1 .. 2N] [E bits][2N-1 .. N] [E bits][N-1 .. 0]

                               // E bits  sign extention                   N bits copy from input                           assign zero value 
         if (CL_IN > 15) begin d_16[16*(N+E)-E +: E] <= {(E){d_in[16*N-1]}}; d_16[15*(N+E) +: N] <= { d_in[15*N +: N] }; end else d_16[15*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 14) begin d_16[15*(N+E)-E +: E] <= {(E){d_in[15*N-1]}}; d_16[14*(N+E) +: N] <= { d_in[14*N +: N] }; end else d_16[14*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 13) begin d_16[14*(N+E)-E +: E] <= {(E){d_in[14*N-1]}}; d_16[13*(N+E) +: N] <= { d_in[13*N +: N] }; end else d_16[13*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 12) begin d_16[13*(N+E)-E +: E] <= {(E){d_in[13*N-1]}}; d_16[12*(N+E) +: N] <= { d_in[12*N +: N] }; end else d_16[12*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 11) begin d_16[12*(N+E)-E +: E] <= {(E){d_in[12*N-1]}}; d_16[11*(N+E) +: N] <= { d_in[11*N +: N] }; end else d_16[11*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 10) begin d_16[11*(N+E)-E +: E] <= {(E){d_in[11*N-1]}}; d_16[10*(N+E) +: N] <= { d_in[10*N +: N] }; end else d_16[10*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN >  9) begin d_16[10*(N+E)-E +: E] <= {(E){d_in[10*N-1]}}; d_16[ 9*(N+E) +: N] <= { d_in[ 9*N +: N] }; end else d_16[ 9*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN >  8) begin d_16[ 9*(N+E)-E +: E] <= {(E){d_in[ 9*N-1]}}; d_16[ 8*(N+E) +: N] <= { d_in[ 8*N +: N] }; end else d_16[ 8*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN >  7) begin d_16[ 8*(N+E)-E +: E] <= {(E){d_in[ 8*N-1]}}; d_16[ 7*(N+E) +: N] <= { d_in[ 7*N +: N] }; end else d_16[ 7*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN >  6) begin d_16[ 7*(N+E)-E +: E] <= {(E){d_in[ 7*N-1]}}; d_16[ 6*(N+E) +: N] <= { d_in[ 6*N +: N] }; end else d_16[ 6*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN >  5) begin d_16[ 6*(N+E)-E +: E] <= {(E){d_in[ 6*N-1]}}; d_16[ 5*(N+E) +: N] <= { d_in[ 5*N +: N] }; end else d_16[ 5*(N+E) +: (N+E)] <= {(N+E){1'b0}};
                               d_16[ 5*(N+E)-E +: E] <= {(E){d_in[ 5*N-1]}}; d_16[ 4*(N+E) +: N] <= { d_in[ 4*N +: N] };
                               d_16[ 4*(N+E)-E +: E] <= {(E){d_in[ 4*N-1]}}; d_16[ 3*(N+E) +: N] <= { d_in[ 3*N +: N] };
                               d_16[ 3*(N+E)-E +: E] <= {(E){d_in[ 3*N-1]}}; d_16[ 2*(N+E) +: N] <= { d_in[ 2*N +: N] };
                               d_16[ 2*(N+E)-E +: E] <= {(E){d_in[ 2*N-1]}}; d_16[ 1*(N+E) +: N] <= { d_in[ 1*N +: N] };
                               d_16[ 1*(N+E)-E +: E] <= {(E){d_in[ 1*N-1]}}; d_16[ 0*(N+E) +: N] <= { d_in[ 0*N +: N] };
                               en_16 <= en_in;
      end
   else
      begin
         always @(posedge clk) begin
             d_16[15*(N+E) +: N+E] <= d_64[63*(N+E) +: N+E] +
                                      d_64[62*(N+E) +: N+E] +
                                      d_64[61*(N+E) +: N+E] +
                                      d_64[60*(N+E) +: N+E] ;
             d_16[14*(N+E) +: N+E] <= d_64[59*(N+E) +: N+E] +
                                      d_64[58*(N+E) +: N+E] +
                                      d_64[57*(N+E) +: N+E] +
                                      d_64[56*(N+E) +: N+E] ;
             d_16[13*(N+E) +: N+E] <= d_64[55*(N+E) +: N+E] +
                                      d_64[54*(N+E) +: N+E] +
                                      d_64[53*(N+E) +: N+E] +
                                      d_64[52*(N+E) +: N+E] ;
             d_16[12*(N+E) +: N+E] <= d_64[51*(N+E) +: N+E] +
                                      d_64[50*(N+E) +: N+E] +
                                      d_64[49*(N+E) +: N+E] +
                                      d_64[48*(N+E) +: N+E] ;
             d_16[11*(N+E) +: N+E] <= d_64[47*(N+E) +: N+E] +
                                      d_64[46*(N+E) +: N+E] +
                                      d_64[45*(N+E) +: N+E] +
                                      d_64[44*(N+E) +: N+E] ;
             d_16[10*(N+E) +: N+E] <= d_64[43*(N+E) +: N+E] +
                                      d_64[42*(N+E) +: N+E] +
                                      d_64[41*(N+E) +: N+E] +
                                      d_64[40*(N+E) +: N+E] ;
             d_16[ 9*(N+E) +: N+E] <= d_64[39*(N+E) +: N+E] +
                                      d_64[38*(N+E) +: N+E] +
                                      d_64[37*(N+E) +: N+E] +
                                      d_64[36*(N+E) +: N+E] ;
             d_16[ 8*(N+E) +: N+E] <= d_64[35*(N+E) +: N+E] +
                                      d_64[34*(N+E) +: N+E] +
                                      d_64[33*(N+E) +: N+E] +
                                      d_64[32*(N+E) +: N+E] ;
             d_16[ 7*(N+E) +: N+E] <= d_64[31*(N+E) +: N+E] +
                                      d_64[30*(N+E) +: N+E] +
                                      d_64[29*(N+E) +: N+E] +
                                      d_64[28*(N+E) +: N+E] ;
             d_16[ 6*(N+E) +: N+E] <= d_64[27*(N+E) +: N+E] +
                                      d_64[26*(N+E) +: N+E] +
                                      d_64[25*(N+E) +: N+E] +
                                      d_64[24*(N+E) +: N+E] ;
             d_16[ 5*(N+E) +: N+E] <= d_64[23*(N+E) +: N+E] +
                                      d_64[22*(N+E) +: N+E] +
                                      d_64[21*(N+E) +: N+E] +
                                      d_64[20*(N+E) +: N+E] ;
             d_16[ 4*(N+E) +: N+E] <= d_64[19*(N+E) +: N+E] +
                                      d_64[18*(N+E) +: N+E] +
                                      d_64[17*(N+E) +: N+E] +
                                      d_64[16*(N+E) +: N+E] ;
             d_16[ 3*(N+E) +: N+E] <= d_64[15*(N+E) +: N+E] +
                                      d_64[14*(N+E) +: N+E] +
                                      d_64[13*(N+E) +: N+E] +
                                      d_64[12*(N+E) +: N+E] ;
             d_16[ 2*(N+E) +: N+E] <= d_64[11*(N+E) +: N+E] +
                                      d_64[10*(N+E) +: N+E] +
                                      d_64[ 9*(N+E) +: N+E] +
                                      d_64[ 8*(N+E) +: N+E] ;
             d_16[ 1*(N+E) +: N+E] <= d_64[ 7*(N+E) +: N+E] +
                                      d_64[ 6*(N+E) +: N+E] +
                                      d_64[ 5*(N+E) +: N+E] +
                                      d_64[ 4*(N+E) +: N+E] ;
             d_16[ 0*(N+E) +: N+E] <= d_64[ 3*(N+E) +: N+E] +
                                      d_64[ 2*(N+E) +: N+E] +
                                      d_64[ 1*(N+E) +: N+E] +
                                      d_64[ 0*(N+E) +: N+E] ;
         end
         always @(posedge clk or rst)
            if (rst) en_16 <= 1'b0;
            else     en_16 <= en_64;
      end
endgenerate

generate
   if (CL_IN <= 4)
      always @( d_in or en_in) 
      begin
         // sign extention to each data word
         // d_in, X words     _____[XN-1 .. (X-1)N] ..     _____[3N-1 .. 2N]   _____[2N-1 .. N]    _____[N-1 .. 0]
         //                  /    / |    ..      |        /    / |   .. |     /    / |    .. |    /    / |   .. |
         // d_N            [E bits][XN-1 .. (X-1)N] .. [E bits][3N-1 .. 2N] [E bits][2N-1 .. N] [E bits][N-1 .. 0]

                               // E bits  sign extention                   N bits copy from input                           assign zero value 
         if (CL_IN > 3) begin d_4[4*(N+E)-E +: E] <= {(E){d_in[4*N-1]}}; d_4[3*(N+E) +: N] <= { d_in[3*N +: N] }; end else d_4[3*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 2) begin d_4[3*(N+E)-E +: E] <= {(E){d_in[3*N-1]}}; d_4[2*(N+E) +: N] <= { d_in[2*N +: N] }; end else d_4[2*(N+E) +: (N+E)] <= {(N+E){1'b0}};
         if (CL_IN > 1) begin d_4[2*(N+E)-E +: E] <= {(E){d_in[2*N-1]}}; d_4[1*(N+E) +: N] <= { d_in[1*N +: N] }; end else d_4[1*(N+E) +: (N+E)] <= {(N+E){1'b0}};
                              d_4[1*(N+E)-E +: E] <= {(E){d_in[1*N-1]}}; d_4[0*(N+E) +: N] <= { d_in[0*N +: N] }; 
                              en_4 <= en_in;
      end
   else
      begin
         always @(posedge clk) begin
            d_4[3*(N+E) +: N+E] <= d_16[15*(N+E) +: N+E] + 
                                   d_16[14*(N+E) +: N+E] + 
                                   d_16[13*(N+E) +: N+E] + 
                                   d_16[12*(N+E) +: N+E] ;
            d_4[2*(N+E) +: N+E] <= d_16[11*(N+E) +: N+E] + 
                                   d_16[10*(N+E) +: N+E] + 
                                   d_16[ 9*(N+E) +: N+E] + 
                                   d_16[ 8*(N+E) +: N+E] ;
            d_4[1*(N+E) +: N+E] <= d_16[ 7*(N+E) +: N+E] + 
                                   d_16[ 6*(N+E) +: N+E] + 
                                   d_16[ 5*(N+E) +: N+E] + 
                                   d_16[ 4*(N+E) +: N+E] ;
            d_4[0*(N+E) +: N+E] <= d_16[ 3*(N+E) +: N+E] + 
                                   d_16[ 2*(N+E) +: N+E] + 
                                   d_16[ 1*(N+E) +: N+E] + 
                                   d_16[ 0*(N+E) +: N+E] ;
         end
         
         always @(posedge clk or rst)
            if (rst) en_4 <= 1'b0;
            else     en_4 <= en_16;
      end
endgenerate

always @(posedge clk) begin
   d_1 <= d_4[3*(N+E) +: N+E] + 
          d_4[2*(N+E) +: N+E] + 
          d_4[1*(N+E) +: N+E] + 
          d_4[0*(N+E) +: N+E] ;
end

always @(posedge clk or rst)
   if (rst) en_out <= 1'b0;
   else     en_out <= en_4;

always @(d_1) d_out <= d_1[SR +: N];


endmodule