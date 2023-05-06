module csr_register_file (input logic clk, reset, csr_write_enable, csr_read_enable, is_mret,input logic [11:0] csr_addr,
						  input logic [31:0] csr_write_data, pc, input logic [1:0] interrupt,
						  output logic [31:0] csr_read_data, exc_pc,output logic epc_taken);

    logic [31:0] mstatus, mie, mepc, mip, mtvec, mcause;

    always @(posedge clk) begin
		if (reset) begin
			mstatus	<= 0;
			mie		<= 0;
			mip		<= 32'h00000880;	//because we are enableing both timer and external interrupts
			mtvec	<= 0;
			mcause	<= 0;
		end
		else if (csr_write_enable) begin
			case (csr_addr)
				768: mstatus <= csr_write_data;
				772: mie	 <= csr_write_data;
				773: mtvec	 <= csr_write_data;
			endcase
        end
    end

    always_comb begin
		csr_read_data <= 0;
        if (csr_read_enable) begin
			case (csr_addr)
				768: csr_read_data = mstatus;
				772: csr_read_data = mie;
				773: csr_read_data = mtvec;
			endcase
        end
    end
    
	always_comb begin
		if (interrupt == 1) begin 
			epc_taken = 1;
			mepc = pc;
			exc_pc = mtvec >> 2;
		end
		else if (is_mret) begin
			epc_taken = 1;
			exc_pc = mepc;
		end
		else begin
			epc_taken = 0;
		end
	end
endmodule
