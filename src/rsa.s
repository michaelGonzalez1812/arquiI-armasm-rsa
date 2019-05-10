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
     return x0 x1 128bits number
---------------------------------*/

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

     ldr x8, p_addr
     ldr x9, q_addr
     ldp	x2, x3, [x8]
	ldp	x0, x1, [x9]
	
     bl mul
     
     //Store n
     ldr x8, n_addr
	stp	x0, x1, [x8]

     mov	w0, 0
     ldp	x29, x30, [sp], 16
     ret

//refereces to variables in code section
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

.size	main, .-main
.ident	"GCC: (Ubuntu/Linaro 7.3.0-27ubuntu1~18.04) 7.3.0"
.section	.note.GNU-stack,"",@progbits
