vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/DPSRAM/DPSRAM.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/ha_fa/ha_fa_ripple.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/CLA/carry_lookahead_adder.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/CSA/carry_save_adder.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Wallace_multiplier/Wallace_multiplier.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/ConvLayer_calc/ConvLayer_calc.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/CE/CE.v

##vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/multi_adder/multi_adder.v

vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/PE/Saved_lines.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/PE/PE.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/PE/PE_tb.v
vsim work.PE_tb
do wave.do
run 1000ns
