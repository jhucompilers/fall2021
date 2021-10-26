/* 6 vregs used */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .text
	.globl main
main:
	subq $72, %rsp
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 24(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr1 */
	leaq 32(%rsp), %rsi
	call scanf
	movq 32(%rsp), %r11         /* sti (vr0), vr1 */
	movq 24(%rsp), %r10
	movq %r11, (%r10)
	leaq 8(%rsp), %r10          /* localaddr vr0, $8 */
	movq %r10, 24(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr1 */
	leaq 32(%rsp), %rsi
	call scanf
	movq 32(%rsp), %r11         /* sti (vr0), vr1 */
	movq 24(%rsp), %r10
	movq %r11, (%r10)
	leaq 16(%rsp), %r10         /* localaddr vr0, $16 */
	movq %r10, 24(%rsp)
	leaq 0(%rsp), %r10          /* localaddr vr1, $0 */
	movq %r10, 32(%rsp)
	leaq 8(%rsp), %r10          /* localaddr vr2, $8 */
	movq %r10, 40(%rsp)
	movq 32(%rsp), %r11         /* ldi vr3, (vr1) */
	movq (%r11), %r11
	movq %r11, 48(%rsp)
	movq 40(%rsp), %r11         /* ldi vr4, (vr2) */
	movq (%r11), %r11
	movq %r11, 56(%rsp)
	movq 48(%rsp), %rax         /* divi vr5, vr3, vr4 */
	cqto 
	movq 56(%rsp), %r10
	idivq %r10
	movq %rax, 64(%rsp)
	movq 64(%rsp), %r11         /* sti (vr0), vr5 */
	movq 24(%rsp), %r10
	movq %r11, (%r10)
	leaq 16(%rsp), %r10         /* localaddr vr0, $16 */
	movq %r10, 24(%rsp)
	movq 24(%rsp), %r11         /* ldi vr1, (vr0) */
	movq (%r11), %r11
	movq %r11, 32(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr1 */
	movq 32(%rsp), %rsi
	call printf
	addq $72, %rsp
	movl $0, %eax
	ret
