class cpu_passive_agent extends uvm_agent;
		
	`uvm_component_utils(cpu_passive_agent)
	
	cpu_passive_monitor cpu_passive_monitor_h;

	function new(string name = "cpu_passive_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cpu_passive_monitor_h=cpu_passive_monitor::type_id::create("cpu_passive_agent_h",this);
	endfunction
endclass
