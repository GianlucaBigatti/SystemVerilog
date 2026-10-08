# sim.do - ModelSim/Questa
# Uso (no diretório dos arquivos):  vsim -do sim.do
# ou, dentro do ModelSim:           do sim.do

quit -sim
if {[file exists work]} { vdel -lib work -all }
vlib work
vmap work work

# Compila (decoder e receiver antes do uart_tx; tb por último)
vlog -sv decode_ascii_abnt2.sv
vlog -sv receiver.sv
vlog -sv uart_tx.sv
vlog -sv tb.sv

# -onfinish stop evita o diálogo de saída quando o tb chama $finish
vsim -onfinish stop -voptargs=+acc work.tb

# Ondas
add wave -divider {PS/2}
add wave -label clk      /tb/clk
add wave -label rst      /tb/rst
add wave -label ps2_clk  /tb/ps2_clk
add wave -label ps2_data /tb/ps2_data

add wave -divider {receiver}
add wave -label state         /tb/dut/receiver/current_state
add wave -label receive_count -radix unsigned /tb/dut/receiver/receive_count
add wave -label send          /tb/dut/receiver/send
add wave -label scancode      -radix hexadecimal /tb/dut/receiver/scancode

add wave -divider {decoder / filtro}
add wave -label ascii      -radix hexadecimal /tb/dut/ascii
add wave -label flag_F0    /tb/dut/flag
add wave -label flag_E0    /tb/dut/ext_flag
add wave -label char_valid /tb/dut/char_valid
add wave -label ascii_out  -radix hexadecimal /tb/dut/ascii_out

add wave -divider {UART TX}
add wave -label busy    /tb/dut/busy
add wave -label bit_idx -radix unsigned /tb/dut/bit_idx
add wave -label tx_data /tb/tx_data
add wave -label tx_done /tb/tx_done

# O tb termina sozinho em ~25,7 ms
run -all
wave zoom full
