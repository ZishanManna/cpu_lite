class cpu_active_agent extends uvm_agent;
	`uvm_component_utils(cpu_active_agent)

	cpu_sequencer#(cpu_sequence_item) cpu_sequencer_h;
	cpu_driver cpu_driver_h;
	cpu_active_monitor cpu_active_monitor_h;


	function new(string name="cpu_active_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		cpu_active_monitor_h = cpu_active_monitor::type_id::create("cpu_active_monitor_h",this);

		if(get_is_active() == UVM_ACTIVE) begin
			cpu_sequencer_h=cpu_sequencer#(cpu_sequence_item)::type_id::create("cpu_sequencer_h",this);
			cpu_driver_h = cpu_driver::type_id::create("cpu_driver_h",this);
		end
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(get_is_active() == UVM_ACTIVE) begin
			cpu_driver_h.seq_item_port.connect(cpu_sequencer_h.seq_item_export);
		end
	endfunction


endclass
