/* 6 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $136, %rsp
	leaq 0(%rsp), %r10          /* localaddr vr1, $0 */
	movq %r10, 88(%rsp)
	movq $0, 96(%rsp)           /* ldci vr2, $0 */
	movq 104(%rsp), %rax        /* muli vr3, vr2, $8 */
	movq 96(%rsp), %rax
	imulq $8, %rax
	movq %rax, 104(%rsp)
	movq 112(%rsp), %rax        /* addi vr4, vr1, vr3 */
	movq 88(%rsp), %rax
	addq 104(%rsp), %rax
	movq %rax, 112(%rsp)
	movq $42, 120(%rsp)         /* ldci vr5, $42 */
	movq 112(%rsp), %r11        /* sti (vr4), vr5 */
	movq 120(%rsp), %r10
	movq %r10, (%r11)
	leaq 0(%rsp), %r10          /* localaddr vr1, $0 */
	movq %r10, 88(%rsp)
	movq $1, 96(%rsp)           /* ldci vr2, $1 */
	movq 104(%rsp), %rax        /* muli vr3, vr2, $8 */
	movq 96(%rsp), %rax
	imulq $8, %rax
	movq %rax, 104(%rsp)
	movq 112(%rsp), %rax        /* addi vr4, vr1, vr3 */
	movq 88(%rsp), %rax
	addq 104(%rsp), %rax
	movq %rax, 112(%rsp)
	movq $17, 120(%rsp)         /* ldci vr5, $17 */
	movq 112(%rsp), %r11        /* sti (vr4), vr5 */
	movq 120(%rsp), %r10
	movq %r10, (%r11)
	movq $7, 88(%rsp)           /* ldci vr1, $7 */
	movq 88(%rsp), %r10         /* mov vr0, vr1 */
	movq %r10, 80(%rsp)
	leaq 0(%rsp), %r10          /* localaddr vr2, $0 */
	movq %r10, 96(%rsp)
	movq 104(%rsp), %rax        /* muli vr3, vr0, $8 */
	movq 80(%rsp), %rax
	imulq $8, %rax
	movq %rax, 104(%rsp)
	movq 112(%rsp), %rax        /* addi vr4, vr2, vr3 */
	movq 96(%rsp), %rax
	addq 104(%rsp), %rax
	movq %rax, 112(%rsp)
	movq $99, 120(%rsp)         /* ldci vr5, $99 */
	movq 112(%rsp), %r11        /* sti (vr4), vr5 */
	movq 120(%rsp), %r10
	movq %r10, (%r11)
	leaq 0(%rsp), %r10          /* localaddr vr1, $0 */
	movq %r10, 88(%rsp)
	movq $0, 96(%rsp)           /* ldci vr2, $0 */
	movq 104(%rsp), %rax        /* muli vr3, vr2, $8 */
	movq 96(%rsp), %rax
	imulq $8, %rax
	movq %rax, 104(%rsp)
	movq 112(%rsp), %rax        /* addi vr4, vr1, vr3 */
	movq 88(%rsp), %rax
	addq 104(%rsp), %rax
	movq %rax, 112(%rsp)
	movq 112(%rsp), %r10        /* ldi vr5, (vr4) */
	movq (%r10), %r10
	movq %r10, 120(%rsp)
	movq 120(%rsp), %rsi        /* writei vr5 */
	movq $s_writeint_fmt, %rdi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr1, $0 */
	movq %r10, 88(%rsp)
	movq $1, 96(%rsp)           /* ldci vr2, $1 */
	movq 104(%rsp), %rax        /* muli vr3, vr2, $8 */
	movq 96(%rsp), %rax
	imulq $8, %rax
	movq %rax, 104(%rsp)
	movq 112(%rsp), %rax        /* addi vr4, vr1, vr3 */
	movq 88(%rsp), %rax
	addq 104(%rsp), %rax
	movq %rax, 112(%rsp)
	movq 112(%rsp), %r10        /* ldi vr5, (vr4) */
	movq (%r10), %r10
	movq %r10, 120(%rsp)
	movq 120(%rsp), %rsi        /* writei vr5 */
	movq $s_writeint_fmt, %rdi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr1, $0 */
	movq %r10, 88(%rsp)
	movq 96(%rsp), %rax         /* muli vr2, vr0, $8 */
	movq 80(%rsp), %rax
	imulq $8, %rax
	movq %rax, 96(%rsp)
	movq 104(%rsp), %rax        /* addi vr3, vr1, vr2 */
	movq 88(%rsp), %rax
	addq 96(%rsp), %rax
	movq %rax, 104(%rsp)
	movq 104(%rsp), %r10        /* ldi vr4, (vr3) */
	movq (%r10), %r10
	movq %r10, 112(%rsp)
	movq 112(%rsp), %rsi        /* writei vr4 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $136, %rsp
	movl $0, %eax
	ret
