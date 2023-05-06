# RISCV Pipelined with CSR's!

* In this repository, you will find a 3 stage pipelined implementation of a RISCV processor along with six of the CSR registers. The code has been updated to include support for all RISCV instructions.
*Remember only {CSRRW} instruction is implemented. 

* To run the processor, please consult the provided {code.s} file, which contains the code for testing the interrupt handling. In my case, I'm providing external interrupt but you can also configure a timer in {RISCV.sv} in order to give a timer interrupt.

* Please note that while the pipelined architecture offers improved performance over the single cycle implementation, it may also introduce additional complexity and potential hazards, such as data hazards and control hazards. It is recommended to carefully test and debug your programs to ensure correct operation of the processor.

*Note: This code only handles two interrupts: one external and one timer interrupt.

If you have any questions or concerns, please feel free to open an issue or reach out to the repository owner for assistance.
