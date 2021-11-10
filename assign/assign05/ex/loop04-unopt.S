/* 21 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $168, %rsp
	movq $1, 24(%rsp)           /* ldci vr3, $1 */
	movq 24(%rsp), %r10         /* mov vr1, vr3 */
	movq %r10, 8(%rsp)
	movq $0, 32(%rsp)           /* ldci vr4, $0 */
	movq 32(%rsp), %r10         /* mov vr2, vr4 */
	movq %r10, 16(%rsp)
	jmp .L9                     /* jmp .L9 */
.L1:
	movq $s_readint_fmt, %rdi   /* readi vr5 */
	leaq 40(%rsp), %rsi
	call scanf
	movq 40(%rsp), %r10         /* mov vr0, vr5 */
	movq %r10, 0(%rsp)
	movq $0, 24(%rsp)           /* ldci vr3, $0 */
	movq 0(%rsp), %r10          /* cmpi vr0, vr3 */
	cmpq 24(%rsp), %r10
	jge .L2                     /* jgte .L2 */
	movq $0, 32(%rsp)           /* ldci vr4, $0 */
	movq 32(%rsp), %r10         /* mov vr1, vr4 */
	movq %r10, 8(%rsp)
	jmp .L9                     /* jmp .L9 */
.L2:
	movq $50, 40(%rsp)          /* ldci vr5, $50 */
	movq 0(%rsp), %r10          /* cmpi vr0, vr5 */
	cmpq 40(%rsp), %r10
	jl .L4                      /* jlt .L4 */
	movq $2, 48(%rsp)           /* ldci vr6, $2 */
	movq 0(%rsp), %rax          /* modi vr7, vr0, vr6 */
	cqto 
	idivq 48(%rsp)
	movq %rdx, 56(%rsp)
	movq $0, 64(%rsp)           /* ldci vr8, $0 */
	movq 56(%rsp), %r10         /* cmpi vr7, vr8 */
	cmpq 64(%rsp), %r10
	jne .L6                     /* jne .L6 */
	movq $1, 72(%rsp)           /* ldci vr9, $1 */
	movq 80(%rsp), %rax         /* addi vr10, vr2, vr9 */
	movq 16(%rsp), %rax
	addq 72(%rsp), %rax
	movq %rax, 80(%rsp)
	movq 80(%rsp), %r10         /* mov vr2, vr10 */
	movq %r10, 16(%rsp)
	jmp .L7                     /* jmp .L7 */
.L6:
	movq $100, 88(%rsp)         /* ldci vr11, $100 */
	movq 96(%rsp), %rax         /* addi vr12, vr2, vr11 */
	movq 16(%rsp), %rax
	addq 88(%rsp), %rax
	movq %rax, 96(%rsp)
	movq 96(%rsp), %r10         /* mov vr2, vr12 */
	movq %r10, 16(%rsp)
.L7:
	jmp .L9                     /* jmp .L9 */
.L4:
	movq $2, 104(%rsp)          /* ldci vr13, $2 */
	movq 0(%rsp), %rax          /* modi vr14, vr0, vr13 */
	cqto 
	idivq 104(%rsp)
	movq %rdx, 112(%rsp)
	movq $0, 120(%rsp)          /* ldci vr15, $0 */
	movq 112(%rsp), %r10        /* cmpi vr14, vr15 */
	cmpq 120(%rsp), %r10
	jne .L8                     /* jne .L8 */
	movq $10000, 128(%rsp)      /* ldci vr16, $10000 */
	movq 136(%rsp), %rax        /* addi vr17, vr2, vr16 */
	movq 16(%rsp), %rax
	addq 128(%rsp), %rax
	movq %rax, 136(%rsp)
	movq 136(%rsp), %r10        /* mov vr2, vr17 */
	movq %r10, 16(%rsp)
	jmp .L9                     /* jmp .L9 */
.L8:
	movq $1000000, 144(%rsp)    /* ldci vr18, $1000000 */
	movq 152(%rsp), %rax        /* addi vr19, vr2, vr18 */
	movq 16(%rsp), %rax
	addq 144(%rsp), %rax
	movq %rax, 152(%rsp)
	movq 152(%rsp), %r10        /* mov vr2, vr19 */
	movq %r10, 16(%rsp)
.L9:
	movq $0, 160(%rsp)          /* ldci vr20, $0 */
	movq 8(%rsp), %r10          /* cmpi vr1, vr20 */
	cmpq 160(%rsp), %r10
	jne .L1                     /* jne .L1 */
	movq 16(%rsp), %rsi         /* writei vr2 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $168, %rsp
	movl $0, %eax
	ret
