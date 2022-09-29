	.text
	.global _start
	.org 0x0000
	
_start:
main:
    movi sp, 0x7FFC #set up stack pointer (far enough away from the instructions and directives)
	movi r2, LIST   #load the list into r2:
	ldw r3, 0(r2)   #load first element into r3
    ldw r4, N(r0)   #length of list 
	
	call count_zeros
	stw r2, z_count(r0) #count zeros should return a value to r2
	break
#==========================
count_zeros:
	#calling a subroutine, so preserve the variables from before
	subi sp, sp, 16
	stw ra, 12(sp)
	stw r3, 8(sp)
	stw r4, 4(sp)
	stw r5, 0(sp)
	
	mov r3, r2  #make local pointer at r3 
	mov r5, r0 #initialize the count at zero
	
count_loop:
    ldw r2, 0(r3)  #load new list element into r2
    call check_zero #sends true or false to r2
count_if:
    beq r2, r0, count_end_if #if false (0), then skip the then
count_then:
    addi r5, r5, 1
count_end_if:
    #deal with remaining loop stuff:
	addi r3, r3, 1  #increment list pointer
	subi r4, r4, 1#decrement loop variable
	bge r4, r0, count_loop
	mov r2, r5 #return value into r2
	
	ldw ra, 12(sp)
	ldw r3, 8(sp)
	ldw r4, 4(sp)
	ldw r5, 0(sp)
	addi sp, sp, 16
    ret
#==========================
check_zero:
    #r2 has current list element
cz_if:
    bne r2, r0, cz_else #if not zero, return false
cz_then:
    movi r2, 1
	br cz_end_if
cz_else:
    movi r2, 0
cz_end_if:
    
    ret
#=====================
    .org 0x1000
N: .word 5
LIST: .word 0, 89, 0, 2, 0
z_count: .skip 4
    .end