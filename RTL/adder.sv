module adder(input logic [31:0]pc_in , output logic [31:0]adder_out);
	
	assign adder_out = pc_in + 32'd4;

endmodule