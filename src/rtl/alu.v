module alu #(parameter WIDTH = 8,OP_WIDTH = 4) (alu_op, op1, op2, out);
  input [OP_WIDTH - 1:0] alu_op;      // 4-bit opcode that determines the operation
  input [WIDTH - 1:0] op1;            // First operand
  input [WIDTH - 1:0] op2;            // Second operand
  output reg [WIDTH-1:0] out = {8{1'b0}};       // Output result

  always @(alu_op, op1, op2) begin
    case(alu_op)
      4'b0001: out = op1 + op2;               // Addition of op1 and op2
      4'b0010: out = op1 - op2;               // Subtraction of op2 from op1
      4'b0011: out = op1 | op2;               //bitwise AND of op1 and op2
      4'b0100: out = op1 & op2;               // Bitwise OR of op1 and op2
      4'b0101: out = op1 ^ op2;               // Bitwise NOT of op1
      4'b0110: out = ~(op1);                  // Bitwise XOR of op1 and op2
      4'b0111: out = op1 > op2;               // Bitwise XOR of op1 and op2
      4'b1000: out = (op1 == op2);            // Bitwise XOR of op1 and op2
      default: out = {8{1'b0}};               // Default case: if no opcode matches, set out to 0
    endcase
  end

endmodule
