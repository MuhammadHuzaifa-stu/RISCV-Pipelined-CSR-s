module RISCV(input logic clk, reset, input logic [1:0] interrupt);

	// Declared all the necessary variables	
	logic [31:0] inst,inst_out_1,rdata1,rdata2,ALU_out,ALU_out2,wdata2,csr_write_data,csr_read_data,exc_pc;
	logic [31:0] imme_out,inst_out_2,rdata1_or_ALU_out2,rdata2_or_ALU_out2,next_mux;
	logic [31:0] rs2_or_imme,read_data_out,rdata2_out,rs1_or_pc,adder_out,pc_out,pc_out2,pc_out3,pc_input,jump;
	logic reg_write,reg_write_MW,sel_B,sel_A,rd_en,rd_enMW,wr_en,wr_enMW,cs,is_mret,is_mretMW;
	logic cs_out,br_taken,br_tak,For_A,For_B,flush,csr_write_enable,csr_read_enable,epc_taken, csr_reg_write, csr_reg_read;
	logic [31:0] csr_addr;
	logic [3:0] aluop;
	logic [3:0]mask;
	logic [2:0]br_type;
	logic [1:0]wb_sel,wb_selMW;
	
	// adder
	adder add1 (.pc_in(pc_out) , .adder_out(adder_out));
	
	//mux for adder/ALU out
	mux2x1 m0 (.a(adder_out),.b(ALU_out2),.s(br_taken),.y(next_mux));
	
	//mux for exc_pc/next_mux
	mux2x1 m1 (.a(next_mux),.b(exc_pc),.s(epc_taken),.y(pc_input));
	
	//PC
	pc_reg pcreg (.clk(clk),.reset(reset),.in(pc_input) ,.pc_out(pc_out));
	
	//Intruction memory
	Instmem Inst_mem (.Address(pc_out), .Instruction(inst));
	
	//REGISTER Separating Fetch and Decode phase
	reg_IR Reg_IR (.a(inst) ,.clk(clk) ,.flush(flush) ,.rst(reset) ,.b(inst_out_1));
	register Reg_PC_1 (.a(pc_out) ,.clk(clk) ,.rst(reset) ,.b(pc_out2));
	
	//register file
	regfile r1 (.raddr1(inst_out_1[19:15]),.raddr2(inst_out_1[24:20]),.waddr(inst_out_2[11:7]), 
				.wdata(wdata2),.RegWrite(reg_write_MW),.Clk(clk),.rdata1(rdata1),.rdata2(rdata2));
	
	//CSR Register File
	csr_register_file csr1 (.clk(clk),.reset(reset),.csr_write_enable(csr_write_enable),.is_mret(is_mretMW),
							.csr_read_enable(csr_read_enable),.csr_addr(csr_addr[11:0]),
							.csr_write_data(csr_write_data),.pc(pc_out3),.interrupt(interrupt),
							.csr_read_data(csr_read_data),.exc_pc(exc_pc),.epc_taken(epc_taken));

	//Registers for CSR Register File
	register CSR_wdata (.a(rdata1_or_ALU_out2) ,.clk(clk) ,.rst(reset) ,.b(csr_write_data));
	register CSR_address (.a(imme_out) ,.clk(clk) ,.rst(reset) ,.b(csr_addr));

	//Immediate generator
	imme_gen im1 (.in(inst_out_1),.out(imme_out));
	
	//mus for forwarding rs1 or ALU_out
	mux21 m2 (.a(rdata1),.b(ALU_out2),.s(For_A),.y(rdata1_or_ALU_out2));

	//mux for rs1 and pc
	mux21 m3 (.a(rdata1_or_ALU_out2),.b(pc_out2),.s(sel_A),.y(rs1_or_pc));
	
	//mus for forwarding rs2 or ALU_out
	mux21 m4 (.a(rdata2),.b(ALU_out2),.s(For_B),.y(rdata2_or_ALU_out2));

	//mux for rs2 and immediate 12'
	mux21 m5 (.a(rdata2_or_ALU_out2),.b(imme_out),.s(sel_B),.y(rs2_or_imme));
	
	//ALU
	ALU A1 (.a(rs1_or_pc),.b(rs2_or_imme),.alu(aluop),.result(ALU_out));
	
	// Branch Condition
	branchcond br1 (.rs1(rdata1_or_ALU_out2),.rs2(rdata2_or_ALU_out2),.opcode(inst_out_1),
					.br_type(br_type),.br_taken(br_tak));
	
	// REGISTER for Branch
	register_1bit Reg_BR_1 (.a(br_tak) ,.flush(flush) ,.clk(clk) ,.rst(reset),.b(br_taken));
	
	// REGISTER for LSU and wdata_addr of register file
	reg_IR Reg_IR_1 (.a(inst_out_1) ,.clk(clk) ,.flush(flush) ,.rst(reset) ,.b(inst_out_2));
	
	//Forwarding unit
	forwardingunit For1 (.in1(inst_out_1),.in2(inst_out_2),.reg_write(reg_write_MW),.br_taken(br_taken),
	                     .out1(For_A),.out2(For_B),.flush(flush),.interrupt(interrupt),.is_mretMW(is_mretMW));

	// LSU
	LSU L1 (.inst(inst_out_2),.mask(mask));

	// Separating Decode and Execute phase from DM and WB
	register Reg_PC_2 (.a(pc_out2) ,.clk(clk) ,.rst(reset) ,.b(pc_out3));
	register Reg_ALU_1 (.a(ALU_out) ,.clk(clk) ,.rst(reset) ,.b(ALU_out2));
	register Reg_WD (.a(rdata2_or_ALU_out2) ,.clk(clk) ,.rst(reset) ,.b(rdata2_out));
	
	// data memory
	data_memory dm1 (.addr(ALU_out2),.write_data(rdata2_out),.mask(mask),.clk(clk),.reset(reset),
					 .rd_en(rd_enMW),.wr_en(wr_enMW),.cs(cs_out),.read_data(read_data_out));
	
	// adder for jump
	adder add2 (.pc_in(pc_out3) , .adder_out(jump));

	// mux for ALU and Data_memory and jump 32'
	mux4x1 m6 (.a(ALU_out2),.b(read_data_out),.c(jump),.d(csr_read_data),.s(wb_selMW),.y(wdata2));
	
	// controller
	controller controller_1 (.func7(inst_out_1[31:25]),.func3(inst_out_1[14:12]),.opcode(inst_out_1[6:0]),
					.alu_control(aluop),.regwrite_control(reg_write),.sel_B(sel_B),.rd_en(rd_en),
					.wr_en(wr_en),.wb_sel(wb_sel),.cs(cs),.sel_A(sel_A),.br_type(br_type), 
					.CSR_reg_wr(csr_reg_write), .CSR_reg_rd(csr_reg_read), .is_mret(is_mret));
					
	// REGISTER for controller
	controll controll_1 (.clk(clk), .reset(reset), .reg_wr(reg_write), .wr_en(wr_en), .rd_en(rd_en), .cs(cs), 
					.CSR_reg_wr(csr_reg_write), .CSR_reg_rd(csr_reg_read), .wb_sel(wb_sel), .reg_wrMW(reg_write_MW), 
					.wr_enMW(wr_enMW), .rd_enMW(rd_enMW), .csMW(cs_out), .CSR_reg_wrMW(csr_write_enable), 
					.CSR_reg_rdMW(csr_read_enable), .wb_selMW(wb_selMW), .is_mret(is_mret), .is_mretMW(is_mretMW));
	


endmodule

