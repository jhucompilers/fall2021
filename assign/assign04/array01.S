/* 5 vregs used */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .text
	.globl main
main:
	subq $120, %rsp
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $0, 88(%rsp)           /* ldci vr1, $0 */
	movq 88(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 96(%rsp)
	movq 80(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 96(%rsp), %r10
	addq %r11, %r10
	movq %r10, 104(%rsp)
	movq $42, 112(%rsp)         /* ldci vr4, $42 */
	movq 112(%rsp), %r11        /* sti (vr3), vr4 */
	movq 104(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $1, 88(%rsp)           /* ldci vr1, $1 */
	movq 88(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 96(%rsp)
	movq 80(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 96(%rsp), %r10
	addq %r11, %r10
	movq %r10, 104(%rsp)
	movq $17, 112(%rsp)         /* ldci vr4, $17 */
	movq 112(%rsp), %r11        /* sti (vr3), vr4 */
	movq 104(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $0, 88(%rsp)           /* ldci vr1, $0 */
	movq 88(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 96(%rsp)
	movq 80(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 96(%rsp), %r10
	addq %r11, %r10
	movq %r10, 104(%rsp)
	movq 104(%rsp), %r11        /* ldi vr4, (vr3) */
	movq (%r11), %r11
	movq %r11, 112(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr4 */
	movq 112(%rsp), %rsi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 80(%rsp)
	movq $1, 88(%rsp)           /* ldci vr1, $1 */
	movq 88(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 96(%rsp)
	movq 80(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 96(%rsp), %r10
	addq %r11, %r10
	movq %r10, 104(%rsp)
	movq 104(%rsp), %r11        /* ldi vr4, (vr3) */
	movq (%r11), %r11
	movq %r11, 112(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr4 */
	movq 112(%rsp), %rsi
	call printf
	addq $120, %rsp
	movl $0, %eax
	ret
