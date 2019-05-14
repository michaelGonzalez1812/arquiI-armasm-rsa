/******************************************************************************
 * RSA Algorithm implementation (124 bits key)
 * Tecnologico de Costa Rica
 * Arquitectura de computadores I
 * Author: Michael Gonzalez Rivera
 ******************************************************************************/

.arch armv8-a
.file	"test.c"

/******************************
 *        Data section        *
 ******************************/
.data

     pfname: .asciz "/home/mikepi/rsa/pfile"
     qfname: .asciz "/home/mikepi/rsa/qfile"

     .balign 16
     p: .octa 0 //variable p

     .balign 16
     q: .octa 0 //variable q

     .balign 16
     n: .octa 0 //variable n

     .balign 16
     phi: .octa 0 //variable phi


/******************************
 *        Code section        *
 ******************************/
.text
     .align	2
     .global	main
     .type	main, %function

/*-------------------------------
     Multiplication method
     128 bits arguments
     -soruce1 x0 x2
     -soruce2 x3 x4
     return x0 x1 128bits number
---------------------------------*/
mul:
     mul	 x7, x2, x0
	umulh x4, x2, x0
	madd	 x4, x3, x0, x4 //Multiply-add.
	madd	 x4, x2, x1, x4
	mov	 x0, x7
	mov	 x1, x4
     ret

	.size	mul, .-mul
	.align	2
	.global	main
	.type	main, %function

/*-------------------------------
     phi computation method
     128 bits arguments
     -p x0 x1
     -q x0 x1
     return x0 x1 128bits number
---------------------------------*/
phi_method:
     sub	sp, sp, #32
	stp	x0, x1, [sp, 16]
	stp	x2, x3, [sp]
	ldp	x2, x3, [sp, 16]
     // p - 1
	mov	x0, -1
	mov	x1, -1
	adds	x10, x2, x0
	adc	x0, x3, x1
	mov	x6, x10
	mov	x7, x0
	ldp	x2, x3, [sp]
     //q - 1
	mov	x0, -1
	mov	x1, -1
	adds	x10, x2, x0
	adc	x0, x3, x1
	mov	x4, x10
	mov	x5, x0
     //multiplication
	mul	x1, x6, x4
	umulh	x0, x6, x4
	madd	x0, x7, x4, x0
	madd	x0, x6, x5, x0
	mov	x8, x1
	mov	x9, x0
	mov	x0, x8
	mov	x1, x9
	add	sp, sp, 32
	ret
	.size	phi_method, .-phi_method

	
	.align	2
	.global	mcd
	.type	mcd, %function


/*-------------------------------
	mcd method

	Description: Compute the maximum
	     common divisor between two numbers

     note: Need less cycles if num1 is less
          than num2

	128 bits arguments
	-num1 x0 x1
	-num2 x2 x3
	return x0 x1 128bits number
---------------------------------*/
mcd:
	stp	x29, x30, [sp, -128]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]

	stp	x0, x1, [x29, 64] //num1
	stp	x2, x3, [x29, 48] //num2
	
	//result = 1
	mov	x0, 1
	mov	x1, 0
	stp	x0, x1, [x29, 80] //result
	//divisor = 2
	mov	x0, 2
	mov	x1, 0
	stp	x0, x1, [x29, 96] //divisor

	ldr	x1, [x29, 72] //MSB num1
	ldr	x0, [x29, 56] //MSB num2
	cmp	x1, x0
	bgt	swap //greater than

	cmp	x1, x0
	bne	do //not equal

	ldr	x1, [x29, 64]
	ldr	x0, [x29, 48]
	cmp	x1, x0
	bls	do //less than or equal to

swap:
	ldp	x0, x1, [x29, 48]
	stp	x0, x1, [x29, 112]
	ldp	x0, x1, [x29, 64]
	stp	x0, x1, [x29, 48]
	ldp	x0, x1, [x29, 112]
	stp	x0, x1, [x29, 64]

do:
	ldp	x0, x1, [x29, 64] //load num1
	ldp	x2, x3, [x29, 96] //load divisor
	bl	__modti3

	orr	x0, x0, x1
	cmp	x0, 0
	bne	plusdivisor

	ldp	x0, x1, [x29, 48] //load num2
	ldp	x2, x3, [x29, 96] //load divisor
	bl	__modti3

	orr	x0, x0, x1
	cmp	x0, 0
	bne	plusdivisor

	ldp	x2, x3, [x29, 80] //load result
	ldp	x0, x1, [x29, 96] //load divior
	mul	x5, x2, x0
	umulh	x4, x2, x0
	madd	x4, x3, x0, x4
	madd	x4, x2, x1, x4
	
	stp	x5, x4, [x29, 80] //store result

	ldp	x2, x3, [x29, 96] //load divisor
	ldp	x0, x1, [x29, 64] //load num1
	bl	__divti3
	stp	x0, x1, [x29, 64] //store num1
	
	ldp	x2, x3, [x29, 96] //load divisor
	ldp	x0, x1, [x29, 48] //load num2
	bl	__divti3
	stp	x0, x1, [x29, 48] //store num2

	mov	x0, 2
	mov	x1, 0
	stp	x0, x1, [x29, 96] //reset divisor
	b	while

plusdivisor:
	ldp	x2, x3, [x29, 96] //load divisor
	mov	x0, 1
	mov	x1, 0
	adds	x4, x2, x0
	adc	x0, x3, x1
	stp	x4, x0, [x29, 96]

while:
	ldr	x1, [x29, 104] //load MSB divisor
	ldr	x0, [x29, 72]  //load MSB num1
	cmp	x1, x0
	bgt	return_mcd //greather than
	cmp	x1, x0
	bne	do //not equal
	ldr	x1, [x29, 96] //load LSB divisor
	ldr	x0, [x29, 64] //load LSB num1
	cmp	x1, x0
	bhi	return_mcd
	b	do

return_mcd:
	ldp	x0, x1, [x29, 80] //ld result
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 128
	ret
	.size	mcd, .-mcd


	.align	2
	.global	main
	.type	main, %function
main:
     stp	x29, x30, [sp, -16]!
     add	x29, sp, 0

     //openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, pfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0

     ldr x1, p_addr
     mov x2, 16
     mov x8, 63 //syscall __NR_read
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

     //openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, qfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0

     ldr x1, q_addr
     mov x2, 16
     mov x8, 63 //__NR_read
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

     //compute and store n
     ldr x8, p_addr
     ldr x9, q_addr
     ldp	x2, x3, [x8]
	ldp	x0, x1, [x9]
     bl mul
     ldr x8, n_addr
	stp	x0, x1, [x8]

     //compute and store phi
     ldr x8, p_addr
     ldr x9, q_addr
     ldp	x2, x3, [x8]
	ldp	x0, x1, [x9]
     bl phi_method
     ldr x8, phi_addr
	stp	x0, x1, [x8]

     
     
     mov	w0, 0
     ldp	x29, x30, [sp], 16
     ret

/********************************************
 * refereces to variables in code section   *
 ********************************************/
pfname_addr:
     .quad pfname
qfname_addr:
     .quad qfname
p_addr:
     .quad p
q_addr:
     .quad q
n_addr:
     .quad n
phi_addr:
     .quad phi

.size	main, .-main
.ident	"GCC: (Ubuntu/Linaro 7.3.0-27ubuntu1~18.04) 7.3.0"
.section	.note.GNU-stack,"",@progbits
