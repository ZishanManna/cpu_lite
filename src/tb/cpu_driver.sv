class cpu_driver extends uvm_driver #(cpu_sequence_item);
	
	`uvm_component_utils(cpu_driver)

	virtual cpu_interface vif;
	
	function new(string name = "cpu_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db cpu_interface ::get(this,"*","vif",vif))
		`uvm_fatal("DRIVER","VIF Is not found ")
	endfunction

	virtual task run_phase(uvm_phase phase);
		cpu_sequence_item item;

		forever begin
			seq_item_port.get_next_item(item);
			vif.cb.pmWrEn <= item.pmWrEn;
			vif.cb.pm_addr<= item.pm_addr;
			vif.cb.instructionIn<=item.instructionIn;
			@(vif.cb);
			seq_item_port.item_done();
		end

	endtask
endclass

