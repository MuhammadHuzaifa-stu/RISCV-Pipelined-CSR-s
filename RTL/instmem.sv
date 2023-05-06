module Instmem(input logic [31:0] Address,output logic [31:0] Instruction); 
    logic [31:0] mem[0:30];
	
	initial
	begin
		$readmemh("D:/6th_Semester/CA_Lab/RISCV_CSR's/code/code.txt",mem);
	end
	
	assign Instruction = mem[Address>>2];	

endmodule

