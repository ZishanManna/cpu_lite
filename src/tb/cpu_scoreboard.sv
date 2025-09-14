`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)


class cpu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(cpu_scoreboard)

  uvm_analysis_imp_in #(cpu_sequence_item, cpu_scoreboard) scr2in;
  uvm_analysis_imp_out #(cpu_sequence_item, cpu_scoreboard) scr2out;

  cpu_sequence_item exp_item_q[$];

  logic [31:0] regfile [0:31];
  logic [31:0] pc;

  function new(string name="cpu_scoreboard", uvm_component parent);
    super.new(name, parent);
    scr2in  = new("scr2in", this);
    scr2out = new("scr2out", this);

    foreach (regfile[i]) regfile[i] = 0;
    pc = 0;
  endfunction

  function void write_in(cpu_sequence_item item);
	cpu_sequence_item exp;
	logic [31:0] result;

	exp = cpu_sequence_item::type_id::create("exp", this);

	exp.instructionIn = item.instructionIn;
    	exp.pm_addr       = item.pm_addr;
    	exp.pmWrEn        = item.pmWrEn;

    	result		  = ref_model(item.instructionIn);
	exp.alu_result    = result[7:0];

    	exp_item_q.push_back(exp);

    	`uvm_info("---SCOREBOARD---",
              $sformatf("Pushed expected result = %0h for instr = %0h",
                        exp.alu_result, exp.instructionIn), UVM_LOW)
  endfunction

  function void write_out(cpu_sequence_item item);
    cpu_sequence_item exp;

    if (exp_item_q.size() == 0) begin
      `uvm_error("---SCOREBOARD---", "NO Expected Transaction available")
      return;
    end

    exp = exp_item_q.pop_front();

    if (item.alu_result !== exp.alu_result) begin
      `uvm_error("---SCOREBOARD---",
                 $sformatf("MISMATCH! DUT = %0h, EXPECTED = %0h",
                           item.alu_result, exp.alu_result))
    end
    else begin
      `uvm_info("---SCOREBOARD---",
                $sformatf("MATCH! ALU RESULT = %0h", item.alu_result),
                UVM_MEDIUM)
    end
  endfunction

  function logic [31:0] ref_model(logic [31:0] instr);
    logic [6:0] opcode;
    logic [4:0] rd, rs1, rs2;
    logic [2:0] func3;
    logic [6:0] func7;
    logic [31:0] imm;
    logic [31:0] result;

    opcode = instr[6:0];
    rd     = instr[11:7];
    func3  = instr[14:12];
    rs1    = instr[19:15];
    rs2    = instr[24:20];
    func7  = instr[31:25];

    result = 0;

    case (opcode)

      7'b0110011: begin
        case ({func7, func3})
          {7'b0000000,3'b000}: result = regfile[rs1] + regfile[rs2]; // ADD
          {7'b0100000,3'b000}: result = regfile[rs1] - regfile[rs2]; // SUB
          {7'b0000000,3'b100}: result = regfile[rs1] ^ regfile[rs2]; // XOR
          {7'b0000000,3'b110}: result = regfile[rs1] | regfile[rs2]; // OR
          {7'b0000000,3'b111}: result = regfile[rs1] & regfile[rs2]; // AND
          {7'b0000000,3'b010}: result = (regfile[rs1] < regfile[rs2]); // SLT
          default: result = 0;
        endcase
        if (rd != 0) regfile[rd] = result;
        pc += 4;
      end

      7'b0010011: begin
        imm = {{20{instr[31]}}, instr[31:20]};
        case (func3)
          3'b000: result = regfile[rs1] + imm; // ADDI
          default: result = 0;
        endcase
        if (rd != 0) regfile[rd] = result;
        pc += 4;
      end

      7'b1100011: begin
        imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        case (func3)
          3'b000: pc = (regfile[rs1] == regfile[rs2]) ? pc + imm : pc + 4; // BEQ
          3'b001: pc = (regfile[rs1] != regfile[rs2]) ? pc + imm : pc + 4; // BNE
          default: pc += 4;
        endcase
        result = 0; // branch doesn’t write back
      end

      7'b1101111: begin
        imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        result = pc + 4; 
        if (rd != 0) regfile[rd] = result;
        pc = pc + imm;
      end

      7'b1111111: begin
        result = 0;
        pc = pc; 
      end

      default: begin
        result = 0;
        pc += 4;
      end
    endcase

    return result;
  endfunction

endclass

