vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Huffman_enc/Huffman_grp_detect.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Huffman_enc/Huffman_enc.v
vlog -reportprogress 300 -work work /home/yyevgeny/hdd/asic/verilog/Huffman_enc/Huffman_enc_tb.v
vsim work.Huffman_enc_tb
do wave.do
run 300ns
