vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Huffman_dec/Huffman_grp_detect.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Huffman_dec/Huffman_one_detect.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Huffman_dec/Huffman_dec.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Huffman_dec/Huffman_dec_tb.v
vsim work.Huffman_dec_tb
do wave.do
run 1000ns
