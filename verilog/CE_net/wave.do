onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /CE_net_tb/data2conv
add wave -noupdate -radix unsigned /CE_net_tb/en_in
add wave -noupdate -radix hexadecimal /CE_net_tb/w
add wave -noupdate -radix hexadecimal /CE_net_tb/d_out
add wave -noupdate -radix unsigned /CE_net_tb/en_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47980 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 175
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1050 ns}
