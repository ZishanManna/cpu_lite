class cpu_driver extends uvm_driver #(cpu_sequence_item);
	
	`uvm_component_utils(cpu_driver)

	virtual cpu_interface vif;
	
	function new(string name = "cpu_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual cpu_interface) ::get(this,"*","vif",vif))
		`uvm_fatal("DRIVER","VIF Is not found ")
	endfunction

	virtual task run_phase(uvm_phase phase);
		cpu_sequence_item item;

		forever begin
			seq_item_port.get_next_item(item);
			vif.dr_cb.pmWrEn 	<= item.pmWrEn;
			vif.dr_cb.pm_addr	<= item.pm_addr;
			vif.dr_cb.instructionIn <=item.instructionIn;
			@(vif.dr_cb);
			`uvm_info("---DRIVER---",$sformatf("Driving Transaction: pmWrEn=%0b, pm_addr=%0h, instructionIn=%0h",item.pmWrEn,item.pm_addr,item.instructionIn),UVM_MEDIUM)
			seq_item_port.item_done();
		end

	endtask
endclass

