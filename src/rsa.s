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
     greeting: .asciz "Hello world\n"
     after_greeting:
     .set size_of_greeting, after_greeting - greeting

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

     //syscall's arguments
     mov x0, #1
     ldr x1, addr_of_greeting
     mov x2, #size_of_greeting

     mov x8, #64 //syscall #
     svc #0

     mov	w0, 0
     ldp	x29, x30, [sp], 16
     ret

//refereces to variables in code section
addr_of_greeting : .quad greeting

.size	main, .-main
.ident	"GCC: (Ubuntu/Linaro 7.3.0-27ubuntu1~18.04) 7.3.0"
.section	.note.GNU-stack,"",@progbits
