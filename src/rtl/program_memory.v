module program_memory
	#(parameter DATA_WIDTH=8,
				ADD_WIDTH=7)
	(input clk,
	 input wrEn,
	 input [ADD_WIDTH-1:0]readAdd,writeAdd,
	 input [DATA_WIDTH-1:0]writeData,
	 output [31:0]instruction);

	reg [DATA_WIDTH-1:0]memory[0:(2**ADD_WIDTH)-1]; //2**7 = 128 DEPTH of program memoryry with 32 bit width 

	always@(posedge clk)begin
		if(wrEn)begin //perform writ eoperation when writ enable is high 
			memory[writeAdd]<=writeData;
		end
		else begin
			memory[writeAdd]<=memory[writeAdd];
		end
	end
    assign instruction={memory[readAdd+'d3],memory[readAdd+'d2],memory[readAdd+'d1],memory[readAdd]}; // give the output to control unit from the address which is pointed by program counter
	
endmodule
