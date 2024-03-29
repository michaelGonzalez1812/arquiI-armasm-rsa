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

     pfname:   .asciz "/home/mikepi/rsa/iofiles/pfile"
     qfname:   .asciz "/home/mikepi/rsa/iofiles/qfile"
	nfname:   .asciz "/home/mikepi/rsa/iofiles/nfile"
     msgfname: .asciz "/home/mikepi/rsa/iofiles/msgfile"
	msgEncryptedfname: .asciz "/home/mikepi/rsa/iofiles/msgEncryptedfile"
	msgDecryptedfname: .asciz "/home/mikepi/rsa/iofiles/msgDecryptedfile"
	privateKfname: .asciz "/home/mikepi/rsa/iofiles/privateKfile"
	publicKfname: .asciz "/home/mikepi/rsa/iofiles/publicKfile"

     .balign 16
     p: .octa 0 //variable p

     .balign 16
     q: .octa 0 //variable q

     .balign 16
     n: .octa 0 //variable n

     .balign 16
     phi: .octa 0 //variable phi

	.balign 16
     private_key: .octa 0

	.balign 16
     public_key: .octa 0

	.balign 16
     msg: .octa 0

	.balign 16
     encrypted_msg: .octa 0

	.balign 16
     decrypted_msg: .octa 0
/******************************
 *        Code section        *
 ******************************/
.text

/*-------------------------------
     Multiplication method
     128 bits arguments
     -soruce1 x0 x2
     -soruce2 x3 x4
     return x0 x1 128bits number
---------------------------------*/
     .align	2
     .global	mul
     .type	mul, %function
mul:
     mul	 x7, x2, x0
	umulh x4, x2, x0
	madd	 x4, x3, x0, x4 //Multiply-add.
	madd	 x4, x2, x1, x4
	mov	 x0, x7
	mov	 x1, x4
     ret
	.size	mul, .-mul

/*-------------------------------
     phi computation method
     128 bits arguments
     -p x0 x1
     -q x0 x1
     return x0 x1 128bits number
---------------------------------*/
     .align	2
	.global	phi_method
	.type	phi_method, %function
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
     .align	2
	.global	mcd
	.type	mcd, %function
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
	bne	mcd_do //not equal

	ldr	x1, [x29, 64]
	ldr	x0, [x29, 48]
	cmp	x1, x0
	bls	mcd_do //less than or equal to

swap:
	ldp	x0, x1, [x29, 48]
	stp	x0, x1, [x29, 112]
	ldp	x0, x1, [x29, 64]
	stp	x0, x1, [x29, 48]
	ldp	x0, x1, [x29, 112]
	stp	x0, x1, [x29, 64]

mcd_do:
	ldp	x0, x1, [x29, 64] //load num1
	ldp	x2, x3, [x29, 96] //load divisor
	bl	division
	mov  x0, x2
	mov  x1, x3

	orr	x0, x0, x1
	cmp	x0, 0
	bne	plusdivisor

	ldp	x0, x1, [x29, 48] //load num2
	ldp	x2, x3, [x29, 96] //load divisor
	bl	division
	mov  x0, x2
	mov  x1, x3

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
	bl	division
	stp	x0, x1, [x29, 64] //store num1
	
	ldp	x2, x3, [x29, 96] //load divisor
	ldp	x0, x1, [x29, 48] //load num2
	bl	division
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
	bne	mcd_do //not equal
	ldr	x1, [x29, 96] //load LSB divisor
	ldr	x0, [x29, 64] //load LSB num1
	cmp	x1, x0
	bhi	return_mcd
	b	mcd_do

return_mcd:
	ldp	x0, x1, [x29, 80] //ld result
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 128
	ret
	.size	mcd, .-mcd

/*-------------------------------
	publickey method

	Description: Find the first public key

	128 bits arguments
	-phi x0 x1
	return x0 x1 128bits number
---------------------------------*/
     .align	2
	.global	publickey
	.type	publickey, %function
publickey:
	stp	x29, x30, [sp, -80]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x0, x1, [x29, 32] //Store phi
	mov	x0, 1
	mov	x1, 0
	stp	x0, x1, [x29, 48] //Store key
publickey_do:
	ldp	x2, x3, [x29, 48]
	mov	x0, 1
	mov	x1, 0
	adds	x4, x2, x0
	adc	x0, x3, x1
	stp	x4, x0, [x29, 48] //store key

	ldp	x2, x3, [x29, 32] //Load phi
	ldp	x0, x1, [x29, 48] //Load key
	bl	mcd
	stp	x0, x1, [x29, 64] //store mcd_result
	cmp	x0, 1
	bne	key_cmp_phi
	ldr	x0, [x29, 72]
	cmp	x0, 0
	beq	return_publickey
key_cmp_phi:
	ldr	x1, [x29, 40] //load MSB phi
	ldr	x0, [x29, 56] //load MSB key
	cmp	x1, x0
	bgt	publickey_do

	cmp	x1, x0
	bne	return_publickey
	ldr	x1, [x29, 32] //load LSB phi
	ldr	x0, [x29, 48] //load MSB phi
	cmp	x1, x0
	bhi	publickey_do
return_publickey:
	ldp	x0, x1, [x29, 48]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 80
	ret
	.size	publickey, .-publickey

/*-------------------------------
	privatekey method

	Description: Find the first private key

	128 bits arguments
	-phi x0 x1
	-public_key x2 x3
	return x0 x1 128bits number
---------------------------------*/
	.align	2
	.global	privatekey
	.type	privatekey, %function
privatekey:
	stp	x29, x30, [sp, -112]!
	add	x29, sp, 0
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x0, x1, [x29, 64] //store phi
	stp	x2, x3, [x29, 48] //store public_key
	stp	xzr, xzr, [x29, 80] //store key
	stp	xzr, xzr, [x29, 96] //store mod
privatekey_do:
	ldp	x2, x3, [x29, 80] //load key
	mov	x0, 1
	mov	x1, 0
	//key + 1
	adds	x4, x2, x0
	adc	x0, x3, x1
	stp	x4, x0, [x29, 80] //store key
	ldp	x2, x3, [x29, 80] //load key
	ldp	x0, x1, [x29, 48] //load public_key
	mul	x5, x2, x0
	umulh	x4, x2, x0
	madd	x4, x3, x0, x4
	madd	x4, x2, x1, x4
	ldp	x2, x3, [x29, 64] //load phi
	mov	x0, x5
	mov	x1, x4
	bl	division
	mov  x0, x2
	mov  x1, x3
	stp	x0, x1, [x29, 96] //store mod
	ldr	x0, [x29, 96] //load LSB mod
	cmp	x0, 1
	bne	privatekey_do //not equal
	ldr	x0, [x29, 104] //load MSB mod
	cmp	x0, 0
	bne	privatekey_do
	ldp	x0, x1, [x29, 80] //load key
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 112
	ret
	.size	privatekey, .-privatekey


/*-------------------------------
	exponent method

	Description: Compute the exponent

	128 bits arguments
	-base x0 x1
	-exponent x2 x3
	return x0 x1 128bits number
---------------------------------*/
	.align	2
	.global	exponent
	.type	exponent, %function
exponent:
	sub	sp, sp, #64
	stp	x0, x1, [sp, 16] //store base
	stp	x2, x3, [sp] //store exponent
	/*ldp	x0, x1, [sp, 16]*/
	stp	x0, x1, [sp, 32] //store result
	mov	x0, 1
	mov	x1, 0
	stp	x0, x1, [sp, 48] //store i
	b	exponent_for_condition
exponent_for_body:
	ldp	x2, x3, [sp, 32] //load result
	ldp	x0, x1, [sp, 16] //load base
	mul	x9, x2, x0
	umulh	x4, x2, x0
	madd	x4, x3, x0, x4
	madd	x4, x2, x1, x4
	stp	x9, x4, [sp, 32] //store result
	ldp	x2, x3, [sp, 48] //load i
	mov	x0, 1
	mov	x1, 0
	adds	x4, x2, x0
	adc	x0, x3, x1
	mov	x7, x4
	mov	x8, x0
	stp	x7, x8, [sp, 48] //store i
exponent_for_condition:
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 56]
	cmp	x1, x0
	bgt	exponent_for_body //greater than
	cmp	x1, x0
	bne	return_exponent
	ldr	x1, [sp]
	ldr	x0, [sp, 48]
	cmp	x1, x0
	bhi	exponent_for_body
return_exponent:
	ldp	x0, x1, [sp, 32]
	add	sp, sp, 64
	ret
	.size	exponent, .-exponent


/*-------------------------------
	encrypt method

	Description: encrypt a msg

	128 bits arguments
	-msg x0 x1
	-public_key x2 x3
	-n x4 x5
	return x0 x1 128bits number
---------------------------------*/
	.align	2
	.global	encrypt
	.type	encrypt, %function
encrypt:
	stp	x29, x30, [sp, -64]!
	add	x29, sp, 0
	stp	x0, x1, [x29, 48] //store msg
	stp	x2, x3, [x29, 32] //store public_key
	stp	x4, x5, [x29, 16] //store n
	ldp	x2, x3, [x29, 32]
	ldp	x0, x1, [x29, 48]
	bl	exponent
	ldp	x2, x3, [x29, 16]
	bl	division
	mov  x0, x2
	mov  x1, x3
	ldp	x29, x30, [sp], 64
	ret
	.size	encrypt, .-encrypt


/*-------------------------------
	division method

	128 bits arguments
	-numerator x0 x1
	-denominator x2 x3
	return 
		-x0 x1 quotient
		-x2 x3 remainder
---------------------------------*/
	.align	2
	.global	division
	.type	division, %function
division:
	sub	sp, sp, #48
	stp	x0, x1, [sp, 16] //store numerator
	stp	x2, x3, [sp] //store denominator
	stp	xzr, xzr, [sp, 32] //store quotient
	b	while_cond_division
division_cycle_body:
	ldp	x2, x3, [sp, 16] //load numerator
	ldp	x0, x1, [sp] //load denominator
	subs	x8, x2, x0
	sbc	x0, x3, x1
	stp	x8, x0, [sp, 16] //store numerator
	ldp	x2, x3, [sp, 32] //load quotient
	mov	x0, 1
	mov	x1, 0
	adds	x8, x2, x0
	adc	x0, x3, x1
	stp	x8, x0, [sp, 32] // store quotient
while_cond_division:
	ldr	x1, [sp, 8] //load MSB denominator
	ldr	x0, [sp, 24] //load MSB numerator
	cmp	x1, x0
	bgt	division_return
	cmp	x1, x0
	bne	division_cycle_body
	ldr	x1, [sp]
	ldr	x0, [sp, 16]
	cmp	x1, x0
	bls	division_cycle_body
division_return:
	ldp	x0, x1, [sp, 32]
	ldp	x2, x3, [sp, 16]
	add	sp, sp, 48
	ret
	.size	division, .-division


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
     mov x8, 56 //syscall x1__NR_openat
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

	//openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, msgfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0

     ldr x1, msg_addr
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

     bl publickey
	ldr x8, public_key_addr
	stp	x0, x1, [x8]
     mov x2, x0
	mov x3, x1
	ldr x8, phi_addr
	ldp	x0, x1, [x8]
	
	bl privatekey
	ldr x8, private_key_addr
	stp x0, x1, [x8]

	ldr x8, msg_addr
	ldp x0, x1, [x8]
	ldr x8, public_key_addr
	ldp x2, x3, [x8]
	ldr x8, n_addr
	ldp x4, x5, [x8]
	bl encrypt
	ldr x8, encrypted_msg_addr
	stp x0, x1, [x8]

	ldr x8, private_key_addr
	ldp x2, x3, [x8]
	ldr x8, n_addr
	ldp x4, x5, [x8]
	bl encrypt
	ldr x8, decrypted_msg_addr
	stp x0, x1, [x8]

	//openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, publicKfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0
	mov x3, x0

	ldr x1, public_key_addr
     mov x2, 16
     mov x8, 64 //__NR_write
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

	//openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, privateKfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0
	mov x3, x0

	ldr x1, private_key_addr
     mov x2, 16
     mov x8, 64 //__NR_write
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

	//openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, nfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0
	mov x3, x0

	ldr x1, n_addr
     mov x2, 16
     mov x8, 64 //__NR_write
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

	//openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, msgEncryptedfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0
	mov x3, x0

	ldr x1, encrypted_msg_addr
     mov x2, 16
     mov x8, 64 //__NR_write
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

	//openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, msgDecryptedfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0
	mov x3, x0

	ldr x1, decrypted_msg_addr
     mov x2, 16
     mov x8, 64 //__NR_write
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

	//openat call
     //syscall's arguments
     mov x0, -100
     ldr x1, nfname_addr
     mov x2, 2
     mov x8, 56 //syscall __NR_openat
     svc #0
     mov x10, x0
	mov x3, x0

	ldr x1, n_addr
     mov x2, 16
     mov x8, 64 //__NR_write
     svc #0

     mov x0, x10
     mov x8, 57 //syscall __NR_close
     svc #0

     mov	w0, 0
     ldp	x29, x30, [sp], 16
     ret


/********************************************
 * references to variables in code section   *
 ********************************************/
pfname_addr:
     .quad pfname
qfname_addr:
     .quad qfname
nfname_addr:
     .quad nfname
msgfname_addr:
     .quad msgfname
msgEncryptedfname_addr:
     .quad msgEncryptedfname
msgDecryptedfname_addr:
     .quad msgDecryptedfname
privateKfname_addr:
     .quad privateKfname
publicKfname_addr:
     .quad publicKfname
p_addr:
     .quad p
q_addr:
     .quad q
n_addr:
     .quad n
phi_addr:
     .quad phi
public_key_addr:
     .quad public_key
private_key_addr:
     .quad private_key
msg_addr:
     .quad msg
encrypted_msg_addr:
     .quad encrypted_msg
decrypted_msg_addr:
     .quad decrypted_msg

.size	main, .-main
.ident	"GCC: (Ubuntu/Linaro 7.3.0-27ubuntu1~18.04) 7.3.0"
.section	.note.GNU-stack,"",@progbits
