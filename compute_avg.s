	.text
	.global _start
	.org 0x0000
#program to compute the average of a list

_start:
main:
    movi sp, 0x7FFC #going to call subroutines, so we need a stack pointer	
    movi r2, LIST   #move list pointer into r2
	ldw r3, 0(r2)   #load first element into r3
	ldw r4, N(r0)   #load num_elements into r4
	
	call calc_avg
	stw r2, average(r0) #store the return into location for average
	
	#prepare arguments for num_gte subroutine:
	movi r2, LIST #move list pointer back to r2
	ldw r5, average(r0) #load average into r5
	
	call num_gte
	stw r2, num_gt(r0)
	
	sub r2, r4, r2 #subtract the num_gte from len of list
	stw r2, num_lt(r0)
	
#========================
calc_avg:
    subi sp, sp, 12
	stw ra, 8(sp)
	stw r3, 4(sp)
	stw r4, 0(sp)
	
    mov r3, r2 #use local list pointer in r3
    movi r5, 0 #store the sum in r5
	
ca_loop:
    ldw r2, 0(r3) #load new list element
	add r5, r5, r2
	
	addi r3, r3, 4 #increment list pointer
	subi r4, r4, 1 #decrement loop counter
    bge r4, r4, ca_loop 
	
    ldw r4, 0(sp) #reload original count
	divu r2, r5, r4 # r2 = sum/len = avg
	
	#restore the variables
	ldw ra, 8(sp)
	ldw r3, 4(sp)
	ldw r4, 0(sp)
    addi sp, sp, 12
	ret
#=========================	
num_gte: #the number of less than avg will just be avg - num gte
    subi sp, sp, 12
	stw r3, 8(sp)
	stw r4, 4(sp)
	stw r5, 0(sp)
	
    mov r3, r2 #use local list pointer in r3
	movi r6, 0 #store the num_gte in r5
	
ng_loop:
    ldw r2, 0(r3) #load new list element
	
ng_if:
    blt r2, r5, ng_end_if
ng_then:
    addi r6, r6, 1 # increase the gte count
ng_end_if:
    addi r3, r3, 4 #increment list pointer
	subi r4, r4, 1 #decrement loop variable
	bge r4, r0, ng_loop
	
	#put the number of gte into r2
	mov r2, r6
	
	ldw r3, 8(sp)
	ldw r4, 4(sp)
	ldw r5, 0(sp)
    addi sp, sp, 12
    ret
#=========================
    .org 0x1000
LIST: .word 1, 2, 3, 4, 5
N: .word 5

average: .skip 4
num_gt: .skip 4
num_lt: .skip 4

    .end