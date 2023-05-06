module LSU (input logic [31:0] inst,output logic [3:0]mask);
	
	logic [3:0] func3;
	assign func3 = inst[14:12];
	
	always_comb
	begin
		case(func3)
			3'b000: mask = 4'b0000;		//Load Byte Signed
			3'b001: mask = 4'b0001;		//Load Half world signed
			3'b010: mask = 4'b1000; 	//Load World
			3'b100: mask = 4'b0010;		// Load Byte Unsigned
			3'b101: mask = 4'b0100;		//Load Half world unsigned
		endcase
	end
	
endmodule