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
		if(!uvm_config_db#(virtual cpu_interface)::get(this,"","vif",vif))
			`uvm_fatal("PASSIVE_MONITOR",VIF not set in passive monitor)	
	endfunction

	virtual task run_phase(uvm_phase phase);
		cpu_sequence_item item;
		
		forever begin
			repeat(3) @(posedge vif.clk);
			item=cpu_sequence_item::type_id::create("item");
			item.alu_result = vif.alu_result;
			out2scr.write_out(item);
			out2cov.write_out(item)
		end
	endtask

endclass
