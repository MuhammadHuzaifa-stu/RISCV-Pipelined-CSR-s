module regfile(input logic [4:0] raddr1,raddr2,waddr, input logic [31:0] wdata, input logic RegWrite, Clk, 
			   output logic [31:0] rdata1, rdata2);

	logic [31:0] Reg [0:31];
	integer k;
	
	initial
	begin
		for (k=0;k<32;k=k+1) Reg[k] = 32'h00000000;
	end
		
	always @(negedge Clk)
	begin
		if (RegWrite & waddr != 5'd0) 	Reg[waddr] <= wdata;
	end
	
	assign rdata1 = Reg[raddr1];
	assign rdata2 = Reg[raddr2];

endmodule