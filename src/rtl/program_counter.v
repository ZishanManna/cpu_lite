module program_counter #(parameter WIDTH = 32)(clk, rst, condition, pc_scr, function_3, jump_add,current_ins_add);//this module compute next instruction address
  input clk;
  input rst;
  input condition;
  input [2:0] function_3;
  input [6:0] pc_scr;
  input [6:0] jump_add;
  output reg [WIDTH-1:0] current_ins_add = {WIDTH{1'b0}};
  
  wire [WIDTH-1:0] next_ins_add;

  always @(posedge clk) begin //Here negedge reset is used 
    if(!rst) begin
	    current_ins_add <= {WIDTH{1'b0}};
    end
    else if(pc_scr == 7'b1111111)begin       //to implement halt
        current_ins_add <= current_ins_add;      //next instruction address is assigned to current instruction address
    end
    else if(pc_scr == 7'b110_1111) begin
        current_ins_add <= jump_add;
     end
     else if(pc_scr == 7'b110_0011) begin
        if(function_3 == 3'b000) begin
            if(condition)
                current_ins_add <= jump_add;
            else
                current_ins_add <= next_ins_add;
        end
        else if (function_3 == 3'b001) begin
            if(condition != 0)
                current_ins_add <= jump_add;
            else
                current_ins_add <= next_ins_add;
        end 
        else 
            current_ins_add <= next_ins_add;
     end
	 else begin
		current_ins_add <= next_ins_add;
	 end
  end

	assign next_ins_add = current_ins_add[WIDTH-1:0] + 3'b100; //increments the pc value by one or used to compute the next instruction

endmodule
