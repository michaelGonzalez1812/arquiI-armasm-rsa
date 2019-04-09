     .arch armv8-a
     .file	"helloworld.c"
     .text
     .align	2
     .global	main
     .type	main, %function
main:
     sub	sp, sp, #16
     mov	x0, 5
     mov	x1, 0
     stp	x0, x1, [sp]
     mov	w0, 0
     add	sp, sp, 16
     ret
     .size	main, .-main
     .ident	"GCC: (Ubuntu/Linaro 7.3.0-27ubuntu1~18.04) 7.3.0"
     .section	.note.GNU-stack,"",@progbits
