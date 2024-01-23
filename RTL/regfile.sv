module regfile (
	input  logic        Clk, 
	input  logic        RegWrite, 
	input  logic [4:0]  raddr1,
	input  logic [4:0]  raddr2,
	input  logic [4:0]  waddr, 
	input  logic [31:0] wdata, 
	
	output logic [31:0] rdata1, 
	output logic [31:0] rdata2
);

	logic [31:0] Reg [0:31];
	
	integer k;

	assign rdata1 = Reg[raddr1];
	assign rdata2 = Reg[raddr2];

	initial
	begin
		for ( k = 0 ; k < 32 ; k = k + 1 ) 
		begin
			Reg[k] = 32'h00000000;
		end
	end
		
	always @(negedge Clk)
	begin
		if (RegWrite & waddr != 5'd0) 	
		begin
			Reg[waddr] <= wdata;
		end
	end
	
endmodule: regfile