.global code
code:
j main
j interrupt_handler

main:
	li x11, 0x880
    li x12, 0x8
    li x13, 0x10
    csrrw x0, mie, x11
    csrrw x0, mstatus, x12
    csrrw x0, mtvec, x13
    
loop:
	addi x14,x14,1
    j loop
    
interrupt_handler:
	csrrw x0, mie, x0
    li x2, 0xFFFFFFFF
    xor x3, x3, x2
    csrrw x0, mie, x11
    mret