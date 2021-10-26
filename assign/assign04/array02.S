/* 5 vregs used */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .text
	.globl main
main:
	subq $136, %rsp
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 88(%rsp)
	movq $0, 96(%rsp)           /* ldci vr1, $0 */
	movq 96(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 104(%rsp)
	movq 88(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 104(%rsp), %r10
	addq %r11, %r10
	movq %r10, 112(%rsp)
	movq $42, 120(%rsp)         /* ldci vr4, $42 */
	movq 120(%rsp), %r11        /* sti (vr3), vr4 */
	movq 112(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 88(%rsp)
	movq $1, 96(%rsp)           /* ldci vr1, $1 */
	movq 96(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 104(%rsp)
	movq 88(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 104(%rsp), %r10
	addq %r11, %r10
	movq %r10, 112(%rsp)
	movq $17, 120(%rsp)         /* ldci vr4, $17 */
	movq 120(%rsp), %r11        /* sti (vr3), vr4 */
	movq 112(%rsp), %r10
	movq %r11, (%r10)
	leaq 80(%rsp), %r10         /* localaddr vr0, $80 */
	movq %r10, 88(%rsp)
	movq $7, 96(%rsp)           /* ldci vr1, $7 */
	movq 96(%rsp), %r11         /* sti (vr0), vr1 */
	movq 88(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 88(%rsp)
	leaq 80(%rsp), %r10         /* localaddr vr1, $80 */
	movq %r10, 96(%rsp)
	movq 96(%rsp), %r11         /* muli vr2, (vr1), $8 */
	movq (%r11), %r11
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 104(%rsp)
	movq 88(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 104(%rsp), %r10
	addq %r11, %r10
	movq %r10, 112(%rsp)
	movq $99, 120(%rsp)         /* ldci vr4, $99 */
	movq 120(%rsp), %r11        /* sti (vr3), vr4 */
	movq 112(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 88(%rsp)
	movq $0, 96(%rsp)           /* ldci vr1, $0 */
	movq 96(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 104(%rsp)
	movq 88(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 104(%rsp), %r10
	addq %r11, %r10
	movq %r10, 112(%rsp)
	movq 112(%rsp), %r11        /* ldi vr4, (vr3) */
	movq (%r11), %r11
	movq %r11, 120(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr4 */
	movq 120(%rsp), %rsi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 88(%rsp)
	movq $1, 96(%rsp)           /* ldci vr1, $1 */
	movq 96(%rsp), %r11         /* muli vr2, vr1, $8 */
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 104(%rsp)
	movq 88(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 104(%rsp), %r10
	addq %r11, %r10
	movq %r10, 112(%rsp)
	movq 112(%rsp), %r11        /* ldi vr4, (vr3) */
	movq (%r11), %r11
	movq %r11, 120(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr4 */
	movq 120(%rsp), %rsi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 88(%rsp)
	leaq 80(%rsp), %r10         /* localaddr vr1, $80 */
	movq %r10, 96(%rsp)
	movq 96(%rsp), %r11         /* muli vr2, (vr1), $8 */
	movq (%r11), %r11
	movq $8, %r10
	imulq %r11, %r10
	movq %r10, 104(%rsp)
	movq 88(%rsp), %r11         /* addi vr3, vr0, vr2 */
	movq 104(%rsp), %r10
	addq %r11, %r10
	movq %r10, 112(%rsp)
	movq 112(%rsp), %r11        /* ldi vr4, (vr3) */
	movq (%r11), %r11
	movq %r11, 120(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr4 */
	movq 120(%rsp), %rsi
	call printf
	addq $136, %rsp
	movl $0, %eax
	ret
