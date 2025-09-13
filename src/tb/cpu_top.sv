`include "cpu_package.sv"
//`include "../rtl/pipelined_risc_v_cpu.v"
//`include "../rtl/cpu_rtl_package.v" 
module cpu_top;

	bit clk;
	bit rst;

	cpu_interface vif(clk,rst);

	pipelined_risc_v_cpu dut(
		.clk(clk),
		.rst(rst),
		.pmWrEn(vif.pmWrEn),
		.instructionIn(vif.instructionIn),
		.pm_addr(vif.pm_addr),
		.alu_result(vif.alu_result)
		);

	initial begin
		clk=0;
		forever #5 clk = ~clk;

	end
	
	initial begin
		rst=1;
		#20;
		rst=0;	
	end

	initial begin
		uvm_config_db#(virtual cpu_interface)::set(null,"*","vif",vif);
		run_test("cpu_test");
	end
endmodule

