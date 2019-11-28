 module ConvLayer_calc    #(
    parameter KERNEL = 3, // 1/3/5/7
    parameter N      = 8, // input data width
    parameter M      = 8  // input weight width

) (
    input wire                       clk       ,
    input wire                       rst       ,
    input wire [KERNEL*KERNEL*N-1:0] data2conv ,
    input wire                       en_in     ,
    input wire [KERNEL*KERNEL*M-1:0] w         ,

    output wire [N+M+5:0]            d_out     ,
    output wire                      en_out    
);
 ////----------Output Ports--------------
 //output [7:0] out;
 ////------------Input Ports-------------- 
 //input [7:0] data;
 //input load, enable, clk, reset;
 ////------------Internal Variables--------
 integer i = 0;
 reg [7:0] out;
 reg [KERNEL*KERNEL*(N + M) -1 : 0] prod     ;

parameter NMP1 = N + M + 1;
 reg [NMP1 : 0] f01;
 reg [NMP1 : 0] f02;
 reg [NMP1 : 0] f03;
 reg [NMP1 : 0] f04;
 reg [NMP1 : 0] f05;
 reg [NMP1 : 0] f06;
 reg [NMP1 : 0] f07;
 reg [NMP1 : 0] f08;
 reg [NMP1 : 0] f09;
 reg [NMP1 : 0] f10;
 reg [NMP1 : 0] f11;
 reg [NMP1 : 0] f12;
 reg [NMP1 : 0] f13;

parameter NMP3 = N + M + 3;
 reg [NMP3 : 0] f21;
 reg [NMP3 : 0] f22;
 reg [NMP3 : 0] f23;
 reg [NMP3 : 0] f24;


parameter NMP5 = N + M + 5;
 reg [NMP5 : 0] f31;

 reg en_prod, en_sum, en_sum2, en_sum3;
 //-------------Code Starts Here-------
 always @(posedge clk)
 begin
    for (i=0; i<KERNEL**2; i=i+1)
    // prod[(i+1)*(N + M) -1 : i*(N + M)] <= w[(i+1)*M-1 : i*M] * data2conv[(i+1)*N-1 : i*N];
       prod[i*(N + M) +: (N + M) ] <= w[i*M +: M] * data2conv[i*N +: N];

    //   prod[ 0*(N + M) +: (N + M) ] <= w[ 0*M +: M] * data2conv[ 0*N +: N];
    //   prod[ 1*(N + M) +: (N + M) ] <= w[ 1*M +: M] * data2conv[ 1*N +: N];
    //   prod[ 2*(N + M) +: (N + M) ] <= w[ 2*M +: M] * data2conv[ 2*N +: N];
    //   prod[ 3*(N + M) +: (N + M) ] <= w[ 3*M +: M] * data2conv[ 3*N +: N];
    //   prod[ 4*(N + M) +: (N + M) ] <= w[ 4*M +: M] * data2conv[ 4*N +: N];
    //   prod[ 5*(N + M) +: (N + M) ] <= w[ 5*M +: M] * data2conv[ 5*N +: N];
    //   prod[ 6*(N + M) +: (N + M) ] <= w[ 6*M +: M] * data2conv[ 6*N +: N];
    //   prod[ 7*(N + M) +: (N + M) ] <= w[ 7*M +: M] * data2conv[ 7*N +: N];
    //   prod[ 8*(N + M) +: (N + M) ] <= w[ 8*M +: M] * data2conv[ 8*N +: N];
    //   prod[ 9*(N + M) +: (N + M) ] <= w[ 9*M +: M] * data2conv[ 9*N +: N];
    //   prod[10*(N + M) +: (N + M) ] <= w[10*M +: M] * data2conv[10*N +: N];
    //   prod[11*(N + M) +: (N + M) ] <= w[11*M +: M] * data2conv[11*N +: N];
    //   prod[12*(N + M) +: (N + M) ] <= w[12*M +: M] * data2conv[12*N +: N];
    //   prod[13*(N + M) +: (N + M) ] <= w[13*M +: M] * data2conv[13*N +: N];
    //   prod[14*(N + M) +: (N + M) ] <= w[14*M +: M] * data2conv[14*N +: N];
    //   prod[15*(N + M) +: (N + M) ] <= w[15*M +: M] * data2conv[15*N +: N];


 end
 
 always @(posedge clk)
 begin

      if (KERNEL == 3) 
      begin
      f01 <= { prod[( 0+1)*(N + M) -1] , prod[( 0+1)*(N + M) -1] , prod[( 0+1)*(N + M) -1 : 0*(N + M)] } +
             { prod[( 1+1)*(N + M) -1] , prod[( 1+1)*(N + M) -1] , prod[( 1+1)*(N + M) -1 : 1*(N + M)] } +
             { prod[( 2+1)*(N + M) -1] , prod[( 2+1)*(N + M) -1] , prod[( 2+1)*(N + M) -1 : 2*(N + M)] } ;

      f02 <= { prod[( 3+1)*(N + M) -1] , prod[( 3+1)*(N + M) -1] , prod[( 3+1)*(N + M) -1 : 3*(N + M)] } +
             { prod[( 4+1)*(N + M) -1] , prod[( 4+1)*(N + M) -1] , prod[( 4+1)*(N + M) -1 : 4*(N + M)] } +
             { prod[( 5+1)*(N + M) -1] , prod[( 5+1)*(N + M) -1] , prod[( 5+1)*(N + M) -1 : 5*(N + M)] } ;
      f03 <= { prod[( 6+1)*(N + M) -1] , prod[( 6+1)*(N + M) -1] , prod[( 6+1)*(N + M) -1 : 6*(N + M)] } +
             { prod[( 7+1)*(N + M) -1] , prod[( 7+1)*(N + M) -1] , prod[( 7+1)*(N + M) -1 : 7*(N + M)] } +
             { prod[( 8+1)*(N + M) -1] , prod[( 8+1)*(N + M) -1] , prod[( 8+1)*(N + M) -1 : 8*(N + M)] } ;


      f21 <= { f01[NMP1] , f01[NMP1] , f01 } +
             { f02[NMP1] , f02[NMP1] , f02 } + 
             { f03[NMP1] , f03[NMP1] , f03 } ; 

      //f21 <= { 2'b00 , f01 } +
      //       { 2'b00 , f02 } + 
      //       { 2'b00 , f03 } ; 
      end

      if (KERNEL == 5)
      begin
        f01 <= { prod[( 0+1)*(N + M) -1] , prod[( 0+1)*(N + M) -1] , prod[( 0+1)*(N + M) -1 :  0*(N + M)] } +
               { prod[( 1+1)*(N + M) -1] , prod[( 1+1)*(N + M) -1] , prod[( 1+1)*(N + M) -1 :  1*(N + M)] } +
               { prod[( 2+1)*(N + M) -1] , prod[( 2+1)*(N + M) -1] , prod[( 2+1)*(N + M) -1 :  2*(N + M)] } +
               { prod[( 3+1)*(N + M) -1] , prod[( 3+1)*(N + M) -1] , prod[( 3+1)*(N + M) -1 :  3*(N + M)] } ;
        f02 <= { prod[( 4+1)*(N + M) -1] , prod[( 4+1)*(N + M) -1] , prod[( 4+1)*(N + M) -1 :  4*(N + M)] } +
               { prod[( 5+1)*(N + M) -1] , prod[( 5+1)*(N + M) -1] , prod[( 5+1)*(N + M) -1 :  5*(N + M)] } +
               { prod[( 6+1)*(N + M) -1] , prod[( 6+1)*(N + M) -1] , prod[( 6+1)*(N + M) -1 :  6*(N + M)] } +
               { prod[( 7+1)*(N + M) -1] , prod[( 7+1)*(N + M) -1] , prod[( 7+1)*(N + M) -1 :  7*(N + M)] } ;
        f03 <= { prod[( 8+1)*(N + M) -1] , prod[( 8+1)*(N + M) -1] , prod[( 8+1)*(N + M) -1 :  8*(N + M)] } +
               { prod[( 9+1)*(N + M) -1] , prod[( 9+1)*(N + M) -1] , prod[( 9+1)*(N + M) -1 :  9*(N + M)] } +
               { prod[(10+1)*(N + M) -1] , prod[(10+1)*(N + M) -1] , prod[(10+1)*(N + M) -1 : 10*(N + M)] } +
               { prod[(11+1)*(N + M) -1] , prod[(11+1)*(N + M) -1] , prod[(11+1)*(N + M) -1 : 11*(N + M)] } ;
        f04 <= { prod[(12+1)*(N + M) -1] , prod[(12+1)*(N + M) -1] , prod[(12+1)*(N + M) -1 : 12*(N + M)] } +
               { prod[(13+1)*(N + M) -1] , prod[(13+1)*(N + M) -1] , prod[(13+1)*(N + M) -1 : 13*(N + M)] } +
               { prod[(14+1)*(N + M) -1] , prod[(14+1)*(N + M) -1] , prod[(14+1)*(N + M) -1 : 14*(N + M)] } +
               { prod[(15+1)*(N + M) -1] , prod[(15+1)*(N + M) -1] , prod[(15+1)*(N + M) -1 : 15*(N + M)] } ;

        f21 <= { f01[NMP1] , f01[NMP1] , f01 } +
               { f02[NMP1] , f02[NMP1] , f02 } + 
               { f03[NMP1] , f03[NMP1] , f03 } + 
               { f04[NMP1] , f04[NMP1] , f04 } ;

      end

      if (KERNEL == 7)
      begin
        f01 <= { prod[( 0+1)*(N + M) -1] , prod[( 0+1)*(N + M) -1] , prod[( 0+1)*(N + M) -1 :  0*(N + M)] } +
               { prod[( 1+1)*(N + M) -1] , prod[( 1+1)*(N + M) -1] , prod[( 1+1)*(N + M) -1 :  1*(N + M)] } +
               { prod[( 2+1)*(N + M) -1] , prod[( 2+1)*(N + M) -1] , prod[( 2+1)*(N + M) -1 :  2*(N + M)] } +
               { prod[( 3+1)*(N + M) -1] , prod[( 3+1)*(N + M) -1] , prod[( 3+1)*(N + M) -1 :  3*(N + M)] } ;
        f02 <= { prod[( 4+1)*(N + M) -1] , prod[( 4+1)*(N + M) -1] , prod[( 4+1)*(N + M) -1 :  4*(N + M)] } +
               { prod[( 5+1)*(N + M) -1] , prod[( 5+1)*(N + M) -1] , prod[( 5+1)*(N + M) -1 :  5*(N + M)] } +
               { prod[( 6+1)*(N + M) -1] , prod[( 6+1)*(N + M) -1] , prod[( 6+1)*(N + M) -1 :  6*(N + M)] } +
               { prod[( 7+1)*(N + M) -1] , prod[( 7+1)*(N + M) -1] , prod[( 7+1)*(N + M) -1 :  7*(N + M)] } ;
        f03 <= { prod[( 8+1)*(N + M) -1] , prod[( 8+1)*(N + M) -1] , prod[( 8+1)*(N + M) -1 :  8*(N + M)] } +
               { prod[( 9+1)*(N + M) -1] , prod[( 9+1)*(N + M) -1] , prod[( 9+1)*(N + M) -1 :  9*(N + M)] } +
               { prod[(10+1)*(N + M) -1] , prod[(10+1)*(N + M) -1] , prod[(10+1)*(N + M) -1 : 10*(N + M)] } +
               { prod[(11+1)*(N + M) -1] , prod[(11+1)*(N + M) -1] , prod[(11+1)*(N + M) -1 : 11*(N + M)] } ;
        f04 <= { prod[(12+1)*(N + M) -1] , prod[(12+1)*(N + M) -1] , prod[(12+1)*(N + M) -1 : 12*(N + M)] } +
               { prod[(13+1)*(N + M) -1] , prod[(13+1)*(N + M) -1] , prod[(13+1)*(N + M) -1 : 13*(N + M)] } +
               { prod[(14+1)*(N + M) -1] , prod[(14+1)*(N + M) -1] , prod[(14+1)*(N + M) -1 : 14*(N + M)] } +
               { prod[(15+1)*(N + M) -1] , prod[(15+1)*(N + M) -1] , prod[(15+1)*(N + M) -1 : 15*(N + M)] } ;
        f05 <= { prod[(16+1)*(N + M) -1] , prod[(16+1)*(N + M) -1] , prod[(16+1)*(N + M) -1 : 16*(N + M)] } +
               { prod[(17+1)*(N + M) -1] , prod[(17+1)*(N + M) -1] , prod[(17+1)*(N + M) -1 : 17*(N + M)] } +
               { prod[(18+1)*(N + M) -1] , prod[(18+1)*(N + M) -1] , prod[(18+1)*(N + M) -1 : 18*(N + M)] } +
               { prod[(19+1)*(N + M) -1] , prod[(19+1)*(N + M) -1] , prod[(19+1)*(N + M) -1 : 19*(N + M)] } ;
        f06 <= { prod[(20+1)*(N + M) -1] , prod[(20+1)*(N + M) -1] , prod[(20+1)*(N + M) -1 : 20*(N + M)] } +
               { prod[(21+1)*(N + M) -1] , prod[(21+1)*(N + M) -1] , prod[(21+1)*(N + M) -1 : 21*(N + M)] } +
               { prod[(22+1)*(N + M) -1] , prod[(22+1)*(N + M) -1] , prod[(22+1)*(N + M) -1 : 22*(N + M)] } +
               { prod[(23+1)*(N + M) -1] , prod[(23+1)*(N + M) -1] , prod[(23+1)*(N + M) -1 : 23*(N + M)] } ;
        f07 <= { prod[(24+1)*(N + M) -1] , prod[(24+1)*(N + M) -1] , prod[(24+1)*(N + M) -1 : 24*(N + M)] } +
               { prod[(25+1)*(N + M) -1] , prod[(25+1)*(N + M) -1] , prod[(25+1)*(N + M) -1 : 25*(N + M)] } +
               { prod[(26+1)*(N + M) -1] , prod[(26+1)*(N + M) -1] , prod[(26+1)*(N + M) -1 : 26*(N + M)] } +
               { prod[(27+1)*(N + M) -1] , prod[(27+1)*(N + M) -1] , prod[(27+1)*(N + M) -1 : 27*(N + M)] } ;
       f08  <= { prod[(28+1)*(N + M) -1] , prod[(28+1)*(N + M) -1] , prod[(28+1)*(N + M) -1 : 28*(N + M)] } +
               { prod[(29+1)*(N + M) -1] , prod[(29+1)*(N + M) -1] , prod[(29+1)*(N + M) -1 : 29*(N + M)] } +
               { prod[(30+1)*(N + M) -1] , prod[(30+1)*(N + M) -1] , prod[(30+1)*(N + M) -1 : 30*(N + M)] } +
               { prod[(31+1)*(N + M) -1] , prod[(31+1)*(N + M) -1] , prod[(31+1)*(N + M) -1 : 31*(N + M)] } ;
       f09  <= { prod[(32+1)*(N + M) -1] , prod[(32+1)*(N + M) -1] , prod[(32+1)*(N + M) -1 : 32*(N + M)] } +
               { prod[(33+1)*(N + M) -1] , prod[(33+1)*(N + M) -1] , prod[(33+1)*(N + M) -1 : 33*(N + M)] } +
               { prod[(34+1)*(N + M) -1] , prod[(34+1)*(N + M) -1] , prod[(34+1)*(N + M) -1 : 34*(N + M)] } +
               { prod[(35+1)*(N + M) -1] , prod[(35+1)*(N + M) -1] , prod[(35+1)*(N + M) -1 : 35*(N + M)] } ;
       f10  <= { prod[(36+1)*(N + M) -1] , prod[(36+1)*(N + M) -1] , prod[(36+1)*(N + M) -1 : 36*(N + M)] } +
               { prod[(37+1)*(N + M) -1] , prod[(37+1)*(N + M) -1] , prod[(37+1)*(N + M) -1 : 37*(N + M)] } +
               { prod[(38+1)*(N + M) -1] , prod[(38+1)*(N + M) -1] , prod[(38+1)*(N + M) -1 : 38*(N + M)] } +
               { prod[(39+1)*(N + M) -1] , prod[(39+1)*(N + M) -1] , prod[(39+1)*(N + M) -1 : 39*(N + M)] } ;
       f11  <= { prod[(40+1)*(N + M) -1] , prod[(40+1)*(N + M) -1] , prod[(40+1)*(N + M) -1 : 40*(N + M)] } +
               { prod[(41+1)*(N + M) -1] , prod[(41+1)*(N + M) -1] , prod[(41+1)*(N + M) -1 : 41*(N + M)] } +
               { prod[(42+1)*(N + M) -1] , prod[(42+1)*(N + M) -1] , prod[(42+1)*(N + M) -1 : 42*(N + M)] } +
               { prod[(43+1)*(N + M) -1] , prod[(43+1)*(N + M) -1] , prod[(43+1)*(N + M) -1 : 43*(N + M)] } ;
       f12  <= { prod[(44+1)*(N + M) -1] , prod[(44+1)*(N + M) -1] , prod[(44+1)*(N + M) -1 : 44*(N + M)] } +
               { prod[(45+1)*(N + M) -1] , prod[(45+1)*(N + M) -1] , prod[(45+1)*(N + M) -1 : 45*(N + M)] } +
               { prod[(46+1)*(N + M) -1] , prod[(46+1)*(N + M) -1] , prod[(46+1)*(N + M) -1 : 46*(N + M)] } +
               { prod[(47+1)*(N + M) -1] , prod[(47+1)*(N + M) -1] , prod[(47+1)*(N + M) -1 : 47*(N + M)] } ;
       f13 <=  { prod[(48+1)*(N + M) -1] , prod[(48+1)*(N + M) -1] , prod[(48+1)*(N + M) -1 : 48*(N + M)] } ;


       f21 <={ f01[NMP1] , f01[NMP1] , f01} +
             { f02[NMP1] , f02[NMP1] , f02} +
             { f03[NMP1] , f03[NMP1] , f03} +
             { f04[NMP1] , f04[NMP1] , f04} ;
       f22 <={ f05[NMP1] , f05[NMP1] , f05} +
             { f06[NMP1] , f06[NMP1] , f06} +
             { f07[NMP1] , f07[NMP1] , f07} +
             { f08[NMP1] , f08[NMP1] , f08} ;
       f23 <={ f09[NMP1] , f09[NMP1] , f09} +
             { f10[NMP1] , f10[NMP1] , f10} +
             { f11[NMP1] , f11[NMP1] , f11} +
             { f12[NMP1] , f12[NMP1] , f12} ;
       f24 <={ f13[NMP1] , f13[NMP1] , f13} ;

      end

    end //always

 always @(posedge clk)
 begin
    if      (KERNEL == 7) 
       f31 <= { f21[NMP3] , f21[NMP3] , f21 } +
              { f22[NMP3] , f22[NMP3] , f22 } +
              { f23[NMP3] , f23[NMP3] , f23 } +
              { f24[NMP3] , f24[NMP3] , f24 } ;
  end // always


always @(posedge clk) // or rst)
 if (rst) begin
   en_prod <= 1'b0;
   en_sum  <= 1'b0;
   en_sum2 <= 1'b0;
 end else begin
   en_prod <= en_in  ;
   en_sum  <= en_prod;
   en_sum2 <= en_sum ;
   en_sum3  <= en_sum2;
end // always

assign d_out = (KERNEL == 1) ? {prod[N+M-1], prod[N+M-1], prod[N+M-1], prod[N+M-1], prod} :
               (KERNEL == 3) ? { f21[NMP3] , f21[NMP3] , f21 } :
               (KERNEL == 5) ? { f21[NMP3] , f21[NMP3] , f21 } :
                                 f31;  //(KERNEL == 7) 
assign en_out= (KERNEL == 1) ? en_prod :
               (KERNEL == 3) ? en_sum2 :
               (KERNEL == 5) ? en_sum2 :
                               en_sum3;  //(KERNEL == 7) 
 endmodule  