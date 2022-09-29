        .text
	.global _start
	
	.equ JTAG_UART_BASE,  0x10001000
	.equ DATA_OFFSET,   0
	.equ STATUS_OFFSET,  4
	.equ WSPACE_MASK,  0xFFFF
	
_start:
main:
    movi sp, 0x7FFC
    #load string pointer
	movia r2, TEXT1
	call PrintString
    #load arguments
	movia r2, LIST
	ldw r3, N(r0)
	call TrendBetweenItems
    break
#subroutines:
PrintChar:
    subi sp, sp, 8
    stw r3, 4(sp)
    stw r4, 0(sp)
	movia r3, JTAG_UART_BASE
	
pc_loop:
    ldwio r4, STATUS_OFFSET(r3)
	andhi r4, r4, WSPACE_MASK
	beq r4, r0, pc_loop
	stwio r2, DATA_OFFSET(r3)
	
	ldw r3, 4(sp)
	ldw r4, 0(sp)
	addi sp, sp, 8
	ret
	
PrintString:
    
	#store arguments into the stack
	subi sp, sp, 12
	stw ra, 8(sp)
	stw r3, 4(sp)
	stw r2, 0(sp)
    mov r3, r2
	
ps_loop:
    ldb r2, 0(r3)
    
ps_if:
    #if ch is zero
    beq r2, r0, ps_else 
ps_then:
    call PrintChar
	#increment pointer
	addi r3, r3, 1
	br ps_loop
	
ps_else: #end loop

    #restore stack arguments
	ldw ra, 8(sp)
	ldw r3, 4(sp)
	ldw r2, 0(sp)
	addi sp, sp, 12
    
	ret
	
TrendBetweenItems:
    subi sp, sp, 12
	stw ra, 8(sp)
	stw r3, 4(sp)
	stw r2, 0(sp)
	
	mov r4, r2
	
	movia r2, TEXT2
	call PrintString

	#load last_item
	movi	r5, 0
	
	#subtract one from n to run n-1 times
	#subi r3, r3, 1
	
tbi_loop:
    movia r2, TEXT3
    call PrintString
	
	ldw r6, 0(r4)
	sub r6, r6, r5
	
tbi_if:
    bge r6, r0, tbi_else_if
tbi_then:
    #movia r2, TEXT4
	movi r2, '\\'
	call PrintChar
	br tbi_end_if
tbi_else_if:
    ble r6, r0, tbi_else
tbi_else_if_then:
    movia r2, TEXT5 # movi	r2, '/'
	call PrintString
	br tbi_end_if
tbi_else:
    movia r2, TEXT6
	call PrintString
tbi_end_if:
    ldw r5, 0(r4)
	addi	r4, r4, 4
    #increment loop
	subi r3, r3, 1
	bgt r3, r0, tbi_loop
	
	movia r2, TEXT7
	call PrintString

	stw ra, 8(sp)
	stw r3, 4(sp)
	stw r2, 0(sp)
    addi sp, sp, 12
	ret
	
	
#==========================
N: .word 6
LIST: .word -1, 8, 3, 3, 5, 7

TEXT1: .asciz  "L3 for Kaleb, Emily, and Anya\n"
TEXT2: .asciz "trend between items"
TEXT3: .asciz "..."
TEXT4: .asciz "\\"
TEXT5: .asciz "/"
TEXT6: .asciz "-"
TEXT7: .asciz "\n"
