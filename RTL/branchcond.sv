module branchcond(input logic [31:0] rs1,rs2,opcode, input logic [2:0]br_type, output logic br_taken);
    
	logic [31:0]operand1,operand2;
	logic [32:0]out_put;
	
	assign operand1 = rs1;
	assign operand2 = rs2;
	
	logic not_zero,neg,overflow;
	
	assign out_put  = {1'b0,operand1} - {1'b0,operand2};
	assign not_zero =| out_put[31:0];
	assign neg      = out_put[31];
	assign overflow = (neg & ~operand1[31] & operand2[31]) | (~neg & operand1[31] & ~operand2[31]);

	always_comb
    begin
	
		if (opcode[6:0] == 7'b1100011) begin

			case(br_type)
				3'd000: br_taken = ~not_zero;        // BEQ
				3'd001: br_taken =  not_zero;        // BNE
				3'd010: br_taken = (neg ^ overflow); // BLT 
				3'd011: br_taken =~(neg ^ overflow); // BGE
				3'd100: br_taken = (out_put[32]);    // BLTU 
				3'd101: br_taken =~(out_put[32]);    // BGEU
		
				default: br_taken = 0;

			endcase

		end

		else if ((opcode[6:0] == 7'b1101111) | (opcode[6:0] == 7'b1100111)) br_taken = 1;

		else br_taken = 0;

	end

endmodule