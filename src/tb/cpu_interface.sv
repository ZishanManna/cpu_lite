interface cpu_interface(input logic clk,input logic rst);
	logic pmWrEn;
	logic [7:0] instructionIn;
	logic [ADD_WIDTH-1:0]pm_addr;
	logic [7:0]alu_result;


	clocking dr_cb @(posedge clk);
		default input #1step output #1step;
		output pmWrEn;
		output instructionIn;
		output pm_addr;
		input alu_result;	
	endclocking

	clocking mon_cb @(posedge clk);
		default input #1step output #1step;
		input pmWrEn;
		input instructionIn;
		input pm_addr;
		input alu_result;
	endclocking
	
	modport DRV(clocking dr_cb,input clk,rst);
	modport MON(clocking mon_cb,input clk,rst);

endclass
