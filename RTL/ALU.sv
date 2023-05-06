module ALU(input logic [31:0] a,b,input logic [3:0] alu,output logic [31:0] result);
	
	always_comb
	begin 
	
		case(alu)

			4'b0000: result = $signed(a) + $signed(b); // ADD
			4'b0001: result = $signed(a) - $signed(b); // SUB
			4'b0010: result = a << b[4:0]; 			   // SLL
			4'b0011: begin 
						if ($signed(a) < $signed(b)) result = 32'd1; // SLT
						else result = 32'd0;
					end
			4'b0100: begin 
						if (a < b) result = 32'd1;     // SLTU
						else result = 32'd0;
					end 
			4'b0101: result = a ^ b;                   // XOR 
			4'b0110: result = a >> b[4:0];             // SRL
			4'b0111: result = a >>> b;                 // SRA
			4'b1000: result = a | b;                   // OR
			4'b1001: result = a & b;                   // AND
			4'b1010: result = b;                       // Copy B

			default:result = a + b; 

		endcase
	
	end

endmodule