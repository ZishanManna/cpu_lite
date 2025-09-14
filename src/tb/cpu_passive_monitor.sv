class cpu_passive_monitor extends uvm_monitor;
	
	`uvm_component_utils(cpu_passive_monitor)

	virtual cpu_interface vif;
	
	uvm_analysis_port#(cpu_sequence_item)out2scr;
	uvm_analysis_port#(cpu_sequence_item)out2cov;

	function new(string name="cpu_passive_monitor",uvm_component parent);
		super.new(name,parent);
		out2scr=new("out2scr",this);
		out2cov=new("out2cov",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual cpu_interface)::get(this,"*","vif",vif))
			`uvm_fatal("PASSIVE_MONITOR","VIF not set in passive monitor")	
	endfunction

	virtual task run_phase(uvm_phase phase);
		cpu_sequence_item item;
		
		forever begin
			repeat(1) @(posedge vif.clk);

			item=cpu_sequence_item::type_id::create("item",this);
			//item.pmWrEn		= vif.pmWrEn;
			//item.instructionIn	= vif.instructionIn;
			//item.pm_addr		= vif.pm_addr;
			item.alu_result 	= vif.mon_cb.alu_result;

			out2scr.write(item);
			out2cov.write(item);

		       // `uvm_info("---PASSIVE_MONITOR---", $sformatf("Observed transaction: pmWrEn = %0b,pm_addr =%0h,InstructionIn = 0x%08h, alu_result=0x%0h",item.pmWrEn,item.pm_addr,item.instructionIn,item.alu_result), UVM_MEDIUM)

 			   `uvm_info("---PASSIVE_MONITOR---", $sformatf("Observed transaction:  alu_result=0x%0h",item.alu_result), UVM_MEDIUM)

		end
	endtask

endclass
