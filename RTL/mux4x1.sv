module mux4x1(input logic [31:0]a,b,c,d,input logic [1:0]s, output logic [31:0]y);
	
	always_comb
	begin
	
		if (s == 2'b00) y = a;
		else if (s == 2'b01) y = b;
		else if (s == 2'b10) y = c;
		else if (s == 2'b11) y = d;
	
	end

endmodule