class cpu_sequence_item extends uvm_sequence_item;

	rand bit pmWrEn;
	rand bit [7:0]instructionIn;
	rand bit [ADD_WIDTH-1:0]pm_addr;
	bit [7:0] alu_result;
	
	`uvm_object_utils_begin(cpu_sequence_item)
		`uvm_field_int(pmWrEn,		UVM_ALL_ON)
		`uvm_field_int(instructionIn,	UVM_ALL_ON)
		`uvm_field_int(pm_addr,		UVM_ALL_ON)
		`uvm_field_int(alu_result,	UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="cpu_sequence_item");
		super.new(name);
	endfunction

	constraint c1 {
		if(pmWrEn == 0) instructionIn == 0;
	}

	constraint c2 {
		pm_addr inside {[0:127]};
	}

	constraint c3 {
		if(pmWrEn == 1) { instructionIn inside {
				8'h03,8'h23,8'h33,8'h63,8'h13,8'h7F };
				}
	}
endclass
	
