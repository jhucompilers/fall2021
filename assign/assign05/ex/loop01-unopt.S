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
	movq $s_readint_fmt, %rdi   /* readi vr3 */
	leaq 24(%rsp), %rsi
	call scanf
	movq 24(%rsp), %r10         /* mov vr2, vr3 */
	movq %r10, 16(%rsp)
	movq $1, 24(%rsp)           /* ldci vr3, $1 */
	movq 24(%rsp), %r10         /* mov vr0, vr3 */
	movq %r10, 0(%rsp)
	movq $0, 32(%rsp)           /* ldci vr4, $0 */
	movq 32(%rsp), %r10         /* mov vr1, vr4 */
	movq %r10, 8(%rsp)
	jmp .L0                     /* jmp .L0 */
.L1:
	movq 40(%rsp), %rax         /* addi vr5, vr1, vr0 */
	movq 8(%rsp), %rax
	addq 0(%rsp), %rax
	movq %rax, 40(%rsp)
	movq 40(%rsp), %r10         /* mov vr1, vr5 */
	movq %r10, 8(%rsp)
	movq $1, 48(%rsp)           /* ldci vr6, $1 */
	movq 56(%rsp), %rax         /* addi vr7, vr0, vr6 */
	movq 0(%rsp), %rax
	addq 48(%rsp), %rax
	movq %rax, 56(%rsp)
	movq 56(%rsp), %r10         /* mov vr0, vr7 */
	movq %r10, 0(%rsp)
.L0:
	movq 0(%rsp), %r10          /* cmpi vr0, vr2 */
	cmpq 16(%rsp), %r10
	jle .L1                     /* jlte .L1 */
	movq 8(%rsp), %rsi          /* writei vr1 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $72, %rsp
	movl $0, %eax
	ret
