add wave -divider "INPUTS"
add wave sim:/tb_ledBar/clk
add wave sim:/tb_ledBar/rst_n
add wave sim:/tb_ledBar/level

add wave -divider "OUTPUTS"
add wave sim:/tb_ledBar/leds

run 500ns