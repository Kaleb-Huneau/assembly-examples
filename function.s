.text
.global _start
.org   0x0030

_start:	
	#Start with J: J = B+1
	ldw    r2, B(r0)
	addi    r2, r2, 1
	stw	r2, J(r0)
	
	# Now, H = (W*J)-K
	ldw r3, W(r0)
	ldw r4, J(r0)
	mul r3, r3, r4
	#reuse r4 to store k
	ldw r4, K(r0)
	sub r3, r3, r4
	
	
	#Now, F = H-W+x ie, r3 - W + X
	ldw r4, W(r0)
	sub r4, r3, r4
	ldw r5, X(r0)
	add r4, r4, r5 

    #now r2=J, r3=H, r4=F
	
	stw r3, H(r0)
	stw r4, F(r0)
	
_end:

	br	_end

#----------------------------------
.org   0x2000
X: .word 5
W: .word 4
K: .word 3
B: .word 2


J: .skip 4
H: .skip 4
F: .skip 4


