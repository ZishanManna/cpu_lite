all:
	make clear;make compile;make simulate
  
compile:
	vcs -sverilog -timescale=1ns/1ns +vcs+dumpvars+dump.vcd -ntb_opts uvm-1.1 cpu_top.sv
  
simulate:
	./simv
clear:
	clear
wave:
	dve &
