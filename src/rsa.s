/******************************************************************************
 * RSA Algorithm implementation (124 bits key)
 * Tecnologico de Costa Rica
 * Arquitectura de computadores I
 * Author: Michael Gonzalez Rivera
 ******************************************************************************/

.arch armv8-a
.file	"test.c"

/*
          Data section
*/
.data
     .balign 8
     fname: .asciz "/home/mikepi/rsa/keys"
     after_fname:
     .set size_of_fname, after_fname - fname

     .balign 8
     p: .quad 0

/*
          Code section
*/
.text
     .align	2
     .global	main
     .type	main, %function

main:

     stp	x29, x30, [sp, -16]!
     add	x29, sp, 0

     //openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, fname_addr
     mov x2, 2
     mov x8, 56 //syscall #
     svc #0
     mov x10, x0

     ldr x1, p_addr
     mov x2, 8
     mov x8, 63
     svc #0

     ldr x1, [x1]
/*
     ldr x1, value_addr
     mov x2, 4
     mov x8, 64 //syscall #
     svc #0
*/

     mov x0, x10

     mov	w0, 0
     mov x8, 57 //syscall #
     svc #0

     ldp	x29, x30, [sp], 16
     ret

//refereces to variables in code section
fname_addr:
     .quad fname
p_addr:
     .quad p

.size	main, .-main
.ident	"GCC: (Ubuntu/Linaro 7.3.0-27ubuntu1~18.04) 7.3.0"
.section	.note.GNU-stack,"",@progbits
