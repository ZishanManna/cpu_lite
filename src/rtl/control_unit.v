module control_unit #(parameter OP_WIDTH = 7) (
  input  [2:0] func3,
  input  [OP_WIDTH-1:0] func7,
  input  [OP_WIDTH-1:0] opcode,
  output reg  reg_wen,
  output reg  data_imm_sel,
  output reg  [3:0] alu_op
);

  always @(func3, func7, opcode) begin
  case(opcode)
    7'b0110011 :  begin
      case(func7)
        7'b0000000 : begin
          case(func3)
            3'b000 :  begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 4'b0001;
            end
            3'b010 :  begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 4'b0111;
            end
            3'b100 : begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 4'b0101;
            end
            3'b110 : begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 4'b0011;
            end
            3'b111 : begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 4'b0100;
            end
            default : begin
              reg_wen = 1'b0;
              data_imm_sel = 1'b0;
              alu_op = 4'b0000;
            end
          endcase
        end
        7'b0100000: begin
          case(func3)
            3'b000 :  begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 4'b0010;
            end
            3'b111 : begin
              reg_wen = 1'b1;
              data_imm_sel = 1'b0;
              alu_op = 4'b0110;
            end
            default : begin
              reg_wen = 1'b0;
              data_imm_sel = 1'b0;
              alu_op = 4'b0000;
            end
          endcase
        end
        default: begin
          reg_wen = 1'b0;
          data_imm_sel = 1'b0;
          alu_op = 4'b0000;
        end
      endcase
    end
    
    7'b0010011 : begin
        reg_wen = 1'b1;
        data_imm_sel = 1'b1;
        alu_op = 4'b0001;
      end      
      7'b110_0011 : begin
        reg_wen = 1'b1;
        data_imm_sel = 1'b0;
        alu_op = 4'b1000;
      end
      default: begin
        reg_wen = 1'b0;
        data_imm_sel = 1'b0;
        alu_op = 4'b0000;
      end
    endcase
  end

endmodule           
