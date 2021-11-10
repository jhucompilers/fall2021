/* 8 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $72, %rsp
	movq $s_readint_fmt, %rdi   /* readi vr2 */
	leaq 16(%rsp), %rsi
	call scanf
	movq 16(%rsp), %r10         /* mov vr0, vr2 */
	movq %r10, 0(%rsp)
	movq $0, 16(%rsp)           /* ldci vr2, $0 */
	movq 16(%rsp), %r10         /* mov vr1, vr2 */
	movq %r10, 8(%rsp)
	jmp .L0                     /* jmp .L0 */
.L1:
	movq $2, 24(%rsp)           /* ldci vr3, $2 */
	movq 0(%rsp), %rax          /* divi vr4, vr0, vr3 */
	cqto 
	idivq 24(%rsp)
	movq %rax, 32(%rsp)
	movq 32(%rsp), %r10         /* mov vr0, vr4 */
	movq %r10, 0(%rsp)
	movq $1, 40(%rsp)           /* ldci vr5, $1 */
	movq 48(%rsp), %rax         /* addi vr6, vr1, vr5 */
	movq 8(%rsp), %rax
	addq 40(%rsp), %rax
	movq %rax, 48(%rsp)
	movq 48(%rsp), %r10         /* mov vr1, vr6 */
	movq %r10, 8(%rsp)
.L0:
	movq $1, 56(%rsp)           /* ldci vr7, $1 */
	movq 0(%rsp), %r10          /* cmpi vr0, vr7 */
	cmpq 56(%rsp), %r10
	jg .L1                      /* jgt .L1 */
	movq 8(%rsp), %rsi          /* writei vr1 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $72, %rsp
	movl $0, %eax
	ret
