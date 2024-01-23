module mux4x1 (
	input  logic [31:0] a,
	input  logic [31:0] b,
	input  logic [31:0] c,
	input  logic [31:0] d,
	input  logic [1:0]  s, 
	
	output logic [31:0] y
);
	
	always_comb
	begin	
		if (s == 2'b00) 
		begin
			y = a;
		end
		else if (s == 2'b01) 
		begin
			y = b;
		end
		else if (s == 2'b10) 
		begin
			y = c;
		end
		else if (s == 2'b11) 
		begin
			y = d;
		end
	end
	
endmodule: mux4x1