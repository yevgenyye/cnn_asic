vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/DPSRAM/DPSRAM.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/DPSRAM/DPSRAM_8.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/PE/Fifo_ctrl.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/PE/Saved_lines.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/PE/Saved_lines_tb.v
vsim work.Saved_lines_tb
do wave_saved.do
run 1000ns
