module writeback_stage #(parameter WIDTH = 8) (clk, reg_wen, wr_reg, alu_result, reg_wen_out, wr_reg_out, alu_result_out);
//this module implements the execute/write back pipeline stage
  input clk;
  input reg_wen;
  input [4:0] wr_reg;
  input [WIDTH-1:0] alu_result;
  output reg reg_wen_out;
  output reg [4:0] wr_reg_out;
  output reg [WIDTH-1:0] alu_result_out;

  always@(posedge clk) begin
    reg_wen_out <= reg_wen;
	wr_reg_out <= wr_reg;
    alu_result_out <= alu_result;
  end

endmodule
