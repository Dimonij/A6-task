vlib work

vlog -sv A6_task.sv
vlog -sv A6_task_tb.sv

vsim -novopt A6_task_tb

add log -r /*
add wave -r *

run -all