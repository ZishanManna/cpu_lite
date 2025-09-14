class cpu_driver extends uvm_driver #(cpu_sequence_item);
	
	`uvm_component_utils(cpu_driver)

	virtual cpu_interface vif;
	
	function new(string name = "cpu_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual cpu_interface)::get(this,"*","vif",vif))
		`uvm_fatal("DRIVER","VIF Is not found ")
	endfunction

	virtual task run_phase(uvm_phase phase);
		cpu_sequence_item item;

		forever begin
			seq_item_port.get_next_item(item);

			if(item.pmWrEn) begin
				for(int i=0; i<4; i++) begin

					vif.dr_cb.pmWrEn 	<= 1;
					vif.dr_cb.pm_addr	<= item.pm_addr+i;
					vif.dr_cb.instructionIn <=item.instructionIn[8*i +:8];
				
					@(posedge vif.clk);
				`uvm_info("---DRIVER---",$sformatf("Driving Transaction: pmWrEn=%0b, pm_addr=%0h, instructionIn=%0h",item.pmWrEn,item.pm_addr,item.instructionIn),UVM_MEDIUM)
				end
				vif.dr_cb.pmWrEn <=0;
				@(posedge vif.clk);
			end

			else begin
				vif.dr_cb.pmWrEn	<= 0;
				vif.dr_cb.pm_addr	<= 0;
				vif.dr_cb.instructionIn	<= 0;
				@(posedge vif.clk);
				`uvm_info("---DRIVER---",$sformatf("Driving NOP (no pmWrEn)"),UVM_LOW)

			end
			seq_item_port.item_done();
		end
	endtask
endclass

