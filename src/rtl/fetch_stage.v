module fetch_stage #(parameter WIDTH = 32) (clk, current_ins, next_ins);//This module implements the fetch/decode pipeline stage
  input clk;
  input [WIDTH-1:0] current_ins;
  output reg [WIDTH-1:0] next_ins;

  always@(posedge clk)begin
    next_ins <= current_ins;
  end
endmodule
