module decode_stage #(parameter WIDTH = 8) (clk, r_reg1, r_reg2, wr_reg, func3, func7, opcode, immediate_data, r_reg1_out, r_reg2_out, wr_reg_out, immediate_data_out, func3_out, func7_out, opcode_out);//This module implements the decode/execute pipeline stage
  input clk;
  input [2:0] func3;
  input [4:0] r_reg1;
  input [4:0] r_reg2;
  input [4:0] wr_reg;
  input [6:0] func7;
  input [6:0] opcode;
  input [WIDTH-1:0] immediate_data;
  output reg [2:0] func3_out;
  output reg [4:0] r_reg1_out;
  output reg [4:0] r_reg2_out;
  output reg [4:0] wr_reg_out;
  output reg [6:0] func7_out;
  output reg [6:0] opcode_out;
  output reg [WIDTH-1:0] immediate_data_out;

  reg [WIDTH-1:0] immediate_temp;

  always@(posedge clk) begin
    func3_out <= func3;
	r_reg1_out <= r_reg1;
	r_reg2_out <= r_reg2;
	func7_out <= func7;
	opcode_out <= opcode;
	wr_reg_out <= wr_reg;
	immediate_temp <= immediate_data;
    immediate_data_out <= immediate_temp;
  end

endmodule
