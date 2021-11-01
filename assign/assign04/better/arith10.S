/* 4 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $40, %rsp
	movq $s_readint_fmt, %rdi   /* readi vr3 */
	leaq 24(%rsp), %rsi
	call scanf
	movq 24(%rsp), %r10         /* mov vr0, vr3 */
	movq %r10, 0(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr3 */
	leaq 24(%rsp), %rsi
	call scanf
	movq 24(%rsp), %r10         /* mov vr1, vr3 */
	movq %r10, 8(%rsp)
	movq 0(%rsp), %rax          /* divi vr3, vr0, vr1 */
	cqto 
	idivq 8(%rsp)
	movq %rax, 24(%rsp)
	movq 24(%rsp), %r10         /* mov vr2, vr3 */
	movq %r10, 16(%rsp)
	movq 16(%rsp), %rsi         /* writei vr2 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $40, %rsp
	movl $0, %eax
	ret
