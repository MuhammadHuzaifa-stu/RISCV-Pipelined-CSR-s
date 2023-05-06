module imme_gen(input logic [31:0]in, output logic [31:0]out);
	
	always_comb 
	begin
	
		// Load + I 
		if ((in[6:0] == 7'b0000011) | (in[6:0] == 7'b0010011)) begin
			out[11:0] = in[31:20];
			out[31:12]= in[31] ? 20'hfffff : 20'h00000;	
		end
		
		// Store
		else if (in[6:0] == 7'b0100011) begin
			out[4:0] = in[11:7]; out[11:5] = in[31:25];
			out[31:12]= in[31] ? 20'hfffff : 20'h00000;
		end

		// U type
		else if (in[6:0] == 7'b0110111 | in[6:0] == 7'b0010111) begin
			out[11:0] = 12'd0; out[31:12]= in[31:12];
		end

		// Branch 
		else if (in[6:0] == 7'b1100011) begin
			out[0] = 1'b0; out[4:1] = in[11:8]; out[10:5] = in[30:25]; out[11] = in[7]; out[12] = in[31];
			out[31:13]= in[31] ? 19'b1111111111111111111 : 19'b0000000000000000000;
		end
		
		// JAL
		else if (in[6:0] == 7'b1101111) begin
			out[0] = 1'b0; out[10:1] = in[30:21]; out[11] = in[20]; out[19:12] = in[19:12]; out[20] = in[31];
			out[31:21]= in[31] ? 11'b11111111111 : 11'b00000000000;
		end
		
		// JALR
		else if (in[6:0] == 7'b1100111) begin
		out[11:0] = in[31:20];
		out[31:12]= in[31] ? 20'hfffff : 20'h00000;
		end

		// CSR
		else if (in[6:0] == 7'b1110011) begin
		out[11:0] = in[31:20];
		out[31:12]= in[31] ? 20'hfffff : 20'h00000;	
		end
	end
	
endmodule