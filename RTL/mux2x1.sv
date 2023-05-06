module mux2x1(input logic [31:0]a,b,input logic s, output logic [31:0]y);
	
	assign y = s ? b:a;

endmodule