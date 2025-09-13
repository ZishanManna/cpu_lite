class cpu_active_monitor extends uvm_monitor;

	`uvm_component_utils(cpu_active_monitor)
	
	virtual cpu_interface vif;

	uvm_analysis_port#(cpu_sequence_item)in2scr;
	uvm_analysis_port#(cpu_sequence_item)in2cov;

	bit [31:0] byte_shift_reg;
	int byte_count;

	function new(string name = "cpu_active_monitor",uvm_component parent);
		super.new(name,parent);
		in2scr=new("in2scr",this);
		in2cov=new("in2cov",this);
		byte_shift_reg = 0;
		byte_count = 0;
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual cpu_interface)::get(this,"","vif",vif))
			`uvm_fatal("ACTIVE MONITOR","VIF not set in active monitor")
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		cpu_sequence_item item;

		forever begin
			@(posedge vif.clk);
			if(vif.pmWrEn) begin
				byte_shift_reg[8*byte_count+:8] = vif.instructionIn;
				byte_count++;
				
				if(byte_count == 4) begin

					item=cpu_sequence_item::type_id::create("item");
	
					item.pmWrEn       = vif.pmWrEn;
					item.pm_addr      = vif.pm_addr-3;
					item.instructionIn= byte_shift_reg;
					in2scr.write(item);
					in2cov.write(item);
					`uvm_info("---ACTIVE_MONITOR---", $sformatf("Sampled transaction: pmWrEn=%0b, pm_addr=%0h, instruction=%0h",item.pmWrEn, item.pm_addr, item.instructionIn),UVM_MEDIUM)
				byte_shift_reg = 0;
				byte_count     = 0;
		
				end
			end
		end

	endtask
endclass
