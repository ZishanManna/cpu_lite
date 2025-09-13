class cpu_sequence extends uvm_sequence #(cpu_sequence_item);
	
	`uvm_object_utils(cpu_sequence)
	
	function new(string name = "cpu_sequence");
		super.new();
	endfunction

	task body();
		cpu_sequence_item item;
		repeat(5)begin
			item=cpu_sequence_item::type_id::create("item");
			start_item(item);
			if(!item.randomize())begin
				`uvm_error("CPU_SEQUENCE","RANDOMIZATION FAILED")
			end
			finish_item(item);
		end
	endtask
endclass
