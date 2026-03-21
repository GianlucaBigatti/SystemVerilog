if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

set TOP_ENTITY {work.tb_ledBar}

vlog -work work led.sv
vlog -work work ledBar.sv
vlog -work work tb_ledBar.sv

vsim -voptargs=+acc ${TOP_ENTITY}

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 500ns