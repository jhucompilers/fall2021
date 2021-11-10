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
	movq $0, 8(%rsp)            /* ldci vr1, $0 */
	movq 8(%rsp), %r10          /* mov vr0, vr1 */
	movq %r10, 0(%rsp)
.L0:
	movq $1, 16(%rsp)           /* ldci vr2, $1 */
	movq 24(%rsp), %rax         /* addi vr3, vr0, vr2 */
	movq 0(%rsp), %rax
	addq 16(%rsp), %rax
	movq %rax, 24(%rsp)
	movq 24(%rsp), %r10         /* mov vr0, vr3 */
	movq %r10, 0(%rsp)
	movq 0(%rsp), %rsi          /* writei vr0 */
	movq $s_writeint_fmt, %rdi
	call printf
	movq $10, 8(%rsp)           /* ldci vr1, $10 */
	movq 0(%rsp), %r10          /* cmpi vr0, vr1 */
	cmpq 8(%rsp), %r10
	jne .L0                     /* jne .L0 */
	addq $40, %rsp
	movl $0, %eax
	ret
