module data_forward #(parameter ADDR_WIDTH = 5) ( r_reg1, r_reg2, w_reg, op1_select, op2_select); //This module generates control signal for data forward
  input [ADDR_WIDTH-1:0] r_reg1;
  input [ADDR_WIDTH-1:0] r_reg2;
  input [ADDR_WIDTH-1:0] w_reg;
  output reg op1_select;
  output reg op2_select;

  always @(r_reg1, w_reg) begin
    if(r_reg1 == w_reg)
      op1_select = 1'b1;
    else
      op1_select = 1'b0;
  end

  always @(r_reg2, w_reg) begin
    if(r_reg2 == w_reg)
      op2_select = 1'b1;
    else
      op2_select = 1'b0;
  end

endmodule
