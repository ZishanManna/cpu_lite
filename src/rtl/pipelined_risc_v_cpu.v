//`include "cpu_rtl_package.v"

module pipelined_risc_v_cpu  #(
	parameter 	DATA_WIDTH = 32,
				ADD_WIDTH=7,
				WIDTH = 8
	)(
	input clk,rst,
	input pmWrEn,//write enable signal for program memory 
	input [7:0]instructionIn,
	input [ADD_WIDTH-1:0]pm_addr,
	output [7:0]alu_result);
	
	wire [ADD_WIDTH-1:0]pointer;	

  //program memory
	wire [31:0] instruction;
  //fetch stage
	wire [31:0] next_ins_w;
  //control unit
  wire reg_wen_w;
  wire data_imm_sel_w;
  wire [3:0] alu_op_w;
  //register bank
  wire [WIDTH-1:0] read_data1_w;
  wire [WIDTH-1:0] read_data2_w;
	
	
	//decode stage

	wire [2:0] func3_out;
	wire [4:0] r_reg1_out;
	wire [4:0] r_reg2_out;
	wire [4:0] wr_reg_dec_w;
	wire [6:0] func7_out;
	wire [6:0] opcode_out;
	wire [6:0] opcode_out_reg;
	wire [WIDTH-1:0] immediate_data_dec_w;
  
    wire [7:0] alu_result_w;
	//writeback stage
	wire reg_wen_wb_w;
	
	//wire data_wb_sel_wb_w;
	wire [4:0] wr_reg_wb_w;
	
	//wire [WIDTH-1:0] immediate_data_wb_w;
	wire [7:0] alu_result_wb_w;
	
	//immediate data select mux
	wire [WIDTH-1:0] mux_out_w;
	
	//data forward
	wire op1_select;
	wire op2_select;
	
	//data forward mux
	wire [WIDTH-1:0] mux_out_op1;
	wire [WIDTH-1:0] mux_out_op2;
	
	wire [WIDTH-1:0] output_data;
	wire [WIDTH-1:0] alu_reset_output;
	
	// jump instruction
	//wire [6:0] jump_add_wire;
	
	program_memory #(.DATA_WIDTH(8), .ADD_WIDTH(7))
	program_memory_inst1(.clk(clk),
						 .wrEn(pmWrEn),
						 .readAdd(pointer),
						 .writeAdd(pm_addr),
						 .writeData(instructionIn),
						 .instruction(instruction));
	
	program_counter #(.WIDTH(ADD_WIDTH))
	program_counter_inst2(.clk(clk),
						  .rst(rst),
						  .condition(|alu_result_w),
						  .pc_scr(instruction[6:0]),
						  .function_3(instruction[14:12]),
						  .jump_add(instruction[31:25]),
						  .current_ins_add(pointer));
	
	fetch_stage #(.WIDTH(32)) 
	fetch_stage_inst3(.clk(clk), 
					  .current_ins(instruction),
					  .next_ins(next_ins_w));
		
	decode_stage #(.WIDTH(8)) 
	decode_stage_inst(.clk(clk),
					  .r_reg1(next_ins_w[19:15]), 
					  .r_reg2(next_ins_w[24:20]), 
					  .wr_reg(next_ins_w[11:7]), 
					  .func3(next_ins_w[14:12]), 
					  .func7(next_ins_w[31:25]), 
					  .opcode(next_ins_w[6:0]), 
					  .immediate_data(instruction[31:24]), 
					  .r_reg1_out(r_reg1_out), 
					  .r_reg2_out(r_reg2_out), 
					  .wr_reg_out(wr_reg_dec_w), 
					  .immediate_data_out(immediate_data_dec_w), 
					  .func3_out(func3_out), 
					  .func7_out(func7_out), 
					  .opcode_out(opcode_out));
         
	d_ff #(.WIDTH(7)) 
	dff (.clk(clk),
         .rst(rst),
         .d(opcode_out),
         .q(opcode_out_reg));
		
	control_unit #(.OP_WIDTH(7)) 
	control_unit_inst(.func3(func3_out), 
					  .func7(func7_out),
					  .opcode(opcode_out),
					  .reg_wen(reg_wen_w),
					  .data_imm_sel(data_imm_sel_w),
					  .alu_op(alu_op_w));

	register_bank #(.DEPTH(32), .WIDTH(8), .ADD_WIDTH(5)) 
	reg_bank_inst(.clk(clk), 
				  .w_en(reg_wen_wb_w),
				  .r_reg1(r_reg1_out),
				  .r_reg2(r_reg2_out),
				  .w_reg(wr_reg_wb_w),
				  .w_data(alu_result_wb_w[7:0]),
				  .read_data1(read_data1_w),
				  .read_data2(read_data2_w),
				  .output_data(output_data));
				  
	data_forward #(.ADDR_WIDTH(5)) 
	data_forward_inst(.r_reg1(r_reg1_out), 
					  .r_reg2(r_reg2_out), 
					  .w_reg(wr_reg_wb_w), 
					  .op1_select(op1_select), 
					  .op2_select(op2_select));
		
	mux_2_1 #(.WIDTH(8)) 
	op1_select_inst(.i0(read_data1_w), 
					.i1(alu_result_wb_w),
					.sel(op1_select), 
					.mux_out(mux_out_op1));
	 
	mux_2_1 #(.WIDTH(8)) 
	op2_select_inst (.i0(read_data2_w), 
					 .i1(alu_result_wb_w),
					 .sel(op2_select),
					 .mux_out(mux_out_op2));
	 
	mux_2_1 #(.WIDTH(8)) 
	data_store_sel_mux(.i0(mux_out_op2),
					   .i1(immediate_data_dec_w),
					   .sel(data_imm_sel_w),
					   .mux_out(mux_out_w));			  

	mux_2_1 #(.WIDTH(8)) 
	alu_output_sel_mux(.i0(alu_result_wb_w),
					   .i1(output_data),
					   .sel(&opcode_out_reg),
					   .mux_out(alu_reset_output));
				  
	alu #(.WIDTH(8), .OP_WIDTH(4)) 
	alu_inst(.alu_op(alu_op_w),
			 .op1(mux_out_op1),
			 .op2(mux_out_w),
			 .out(alu_result_w));
			   
	writeback_stage #(.WIDTH(8)) 
	writeback_stage_inst(.clk(clk),
						 .reg_wen(reg_wen_w),
						 .wr_reg(wr_reg_dec_w),
						 .alu_result(alu_result_w),
						 .reg_wen_out(reg_wen_wb_w),
						 .wr_reg_out(wr_reg_wb_w),
						 .alu_result_out(alu_result_wb_w));
						 
						 
	assign alu_result = alu_reset_output;


endmodule
