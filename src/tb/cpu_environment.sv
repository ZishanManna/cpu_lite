class cpu_environment extends uvm_env;

	`uvm_component_utils(cpu_environment)
	
	cpu_active_agent cpu_active_agent_h;
	cpu_passive_agent cpu_passive_agent_h;
	cpu_scoreboard cpu_scoreboard_h;
	
	function new(string name="cpu_environment",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cpu_active_agent_h = cpu_active_agent::type_id::create("cpu_active_agent_h",this);
		cpu_passive_agent_h = cpu_passive_agent::type_id::create("cpu_passive_agent_h",this);
		cpu_scoreboard_h = cpu_scoreboard::type_id::create("cpu_scoreboard",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		cpu_active_agent_h.cpu_active_monitor_h.in2scr.connect(cpu_scoreboard_h.scr2in);
		//cpu_active_agent_h.cpu_active_monitor_h.in2cov.connect(cpu_scoreboard_h.cov2in);
		cpu_passive_agent_h.cpu_passive_monitor_h.out2scr.connect(cpu_scoreboard_h.scr2out);
		//cpu_passive_agent_h.cpu_passive_monitor_h.out2cov.connect(cpu_scoreboard_h.cov2out);
	endfunction

endclass
