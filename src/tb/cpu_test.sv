class cpu_test extends uvm_test;

	`uvm_component_utils(cpu_test)

	cpu_environment cpu_environment_h;
	cpu_sequence cpu_sequence_h;	

	function new(string name="cpu_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cpu_environment_h=cpu_environment::type_id::create("cpu_environment_h",this);
		cpu_sequence_h=cpu_sequence::type_id::create("cpu_sequence_h",this);
	endfunction
	
	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("TEST",this.sprint(),UVM_LOW)
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		cpu_sequence_h.start(cpu_environment_h.cpu_active_agent_h.cpu_sequencer_h);
	//	#1000;
		phase.drop_objection(this);
	endtask	
endclass
