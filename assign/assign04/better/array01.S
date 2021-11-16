/* 5 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $120, %rsp
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $0, 88(%rsp)           /* ldci vr1, $0 */
	movq 88(%rsp), %rax         /* muli vr2, vr1, $8 */
	imulq $8, %rax
	movq %rax, 96(%rsp)
	movq 80(%rsp), %rax         /* addi vr3, vr0, vr2 */
	addq 96(%rsp), %rax
	movq %rax, 104(%rsp)
	movq $42, 112(%rsp)         /* ldci vr4, $42 */
	movq 104(%rsp), %r11        /* sti (vr3), vr4 */
	movq 112(%rsp), %r10
	movq %r10, (%r11)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $1, 88(%rsp)           /* ldci vr1, $1 */
	movq 88(%rsp), %rax         /* muli vr2, vr1, $8 */
	imulq $8, %rax
	movq %rax, 96(%rsp)
	movq 80(%rsp), %rax         /* addi vr3, vr0, vr2 */
	addq 96(%rsp), %rax
	movq %rax, 104(%rsp)
	movq $17, 112(%rsp)         /* ldci vr4, $17 */
	movq 104(%rsp), %r11        /* sti (vr3), vr4 */
	movq 112(%rsp), %r10
	movq %r10, (%r11)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $0, 88(%rsp)           /* ldci vr1, $0 */
	movq 88(%rsp), %rax         /* muli vr2, vr1, $8 */
	imulq $8, %rax
	movq %rax, 96(%rsp)
	movq 80(%rsp), %rax         /* addi vr3, vr0, vr2 */
	addq 96(%rsp), %rax
	movq %rax, 104(%rsp)
	movq 104(%rsp), %r10        /* ldi vr4, (vr3) */
	movq (%r10), %r10
	movq %r10, 112(%rsp)
	movq 112(%rsp), %rsi        /* writei vr4 */
	movq $s_writeint_fmt, %rdi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $1, 88(%rsp)           /* ldci vr1, $1 */
	movq 88(%rsp), %rax         /* muli vr2, vr1, $8 */
	imulq $8, %rax
	movq %rax, 96(%rsp)
	movq 80(%rsp), %rax         /* addi vr3, vr0, vr2 */
	addq 96(%rsp), %rax
	movq %rax, 104(%rsp)
	movq 104(%rsp), %r10        /* ldi vr4, (vr3) */
	movq (%r10), %r10
	movq %r10, 112(%rsp)
	movq 112(%rsp), %rsi        /* writei vr4 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $120, %rsp
	movl $0, %eax
	ret
