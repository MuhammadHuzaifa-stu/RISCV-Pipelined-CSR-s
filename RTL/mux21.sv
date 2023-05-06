module mux21(input logic [31:0]a,b,input logic s, output logic [31:0]y);
	
	assign y = s ? b:a;

endmodule