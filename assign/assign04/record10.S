/* 11 vregs used */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .text
	.globl main
main:
	subq $232, %rsp
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	movq $0, 152(%rsp)          /* ldci vr1, $0 */
	movq 152(%rsp), %r11        /* sti (vr0), vr1 */
	movq 144(%rsp), %r10
	movq %r11, (%r10)
	jmp .L1                     /* jmp .L1 */
.L0:
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $0 */
	movq $0, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr5 */
	leaq 184(%rsp), %rsi
	call scanf
	movq 184(%rsp), %r11        /* sti (vr4), vr5 */
	movq 176(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $8 */
	movq $8, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr5 */
	leaq 184(%rsp), %rsi
	call scanf
	movq 184(%rsp), %r11        /* sti (vr4), vr5 */
	movq 176(%rsp), %r10
	movq %r11, (%r10)
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq $1, 160(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %r11        /* ldi vr3, (vr1) */
	movq (%r11), %r11
	movq %r11, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* sti (vr0), vr4 */
	movq 144(%rsp), %r10
	movq %r11, (%r10)
.L1:
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	movq $8, 152(%rsp)          /* ldci vr1, $8 */
	movq 144(%rsp), %r11        /* ldi vr2, (vr0) */
	movq (%r11), %r11
	movq %r11, 160(%rsp)
	movq 160(%rsp), %r10        /* cmpi vr2, vr1 */
	movq 152(%rsp), %r11
	cmpq %r11, %r10
	jl .L0                      /* jlt .L0 */
	leaq 128(%rsp), %r10        /* localaddr vr3, $128 */
	movq %r10, 168(%rsp)
	movq $0, 176(%rsp)          /* ldci vr4, $0 */
	movq 176(%rsp), %r11        /* sti (vr3), vr4 */
	movq 168(%rsp), %r10
	movq %r11, (%r10)
	jmp .L3                     /* jmp .L3 */
.L2:
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $0 */
	movq $0, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* ldi vr5, (vr4) */
	movq (%r11), %r11
	movq %r11, 184(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr5 */
	movq 184(%rsp), %rsi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $8 */
	movq $8, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* ldi vr5, (vr4) */
	movq (%r11), %r11
	movq %r11, 184(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr5 */
	movq 184(%rsp), %rsi
	call printf
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq $1, 160(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %r11        /* ldi vr3, (vr1) */
	movq (%r11), %r11
	movq %r11, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* sti (vr0), vr4 */
	movq 144(%rsp), %r10
	movq %r11, (%r10)
.L3:
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	movq $8, 152(%rsp)          /* ldci vr1, $8 */
	movq 144(%rsp), %r11        /* ldi vr2, (vr0) */
	movq (%r11), %r11
	movq %r11, 160(%rsp)
	movq 160(%rsp), %r10        /* cmpi vr2, vr1 */
	movq 152(%rsp), %r11
	cmpq %r11, %r10
	jl .L2                      /* jlt .L2 */
	leaq 128(%rsp), %r10        /* localaddr vr3, $128 */
	movq %r10, 168(%rsp)
	movq $0, 176(%rsp)          /* ldci vr4, $0 */
	movq 176(%rsp), %r11        /* sti (vr3), vr4 */
	movq 168(%rsp), %r10
	movq %r11, (%r10)
	jmp .L5                     /* jmp .L5 */
.L4:
	leaq 136(%rsp), %r10        /* localaddr vr0, $136 */
	movq %r10, 144(%rsp)
	leaq 0(%rsp), %r10          /* localaddr vr1, $0 */
	movq %r10, 152(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr2, $128 */
	movq %r10, 160(%rsp)
	movq 160(%rsp), %r11        /* muli vr3, (vr2), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 168(%rsp)
	movq 152(%rsp), %r11        /* addi vr4, vr1, vr3 */
	movq 168(%rsp), %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* addi vr5, vr4, $0 */
	movq $0, %r10
	addq %r11, %r10
	movq %r10, 184(%rsp)
	movq 184(%rsp), %r11        /* ldi vr6, (vr5) */
	movq (%r11), %r11
	movq %r11, 192(%rsp)
	movq 192(%rsp), %r11        /* sti (vr0), vr6 */
	movq 144(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $0 */
	movq $0, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	leaq 0(%rsp), %r10          /* localaddr vr5, $0 */
	movq %r10, 184(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr6, $128 */
	movq %r10, 192(%rsp)
	movq 192(%rsp), %r11        /* muli vr7, (vr6), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 200(%rsp)
	movq 184(%rsp), %r11        /* addi vr8, vr5, vr7 */
	movq 200(%rsp), %r10
	addq %r11, %r10
	movq %r10, 208(%rsp)
	movq 208(%rsp), %r11        /* addi vr9, vr8, $8 */
	movq $8, %r10
	addq %r11, %r10
	movq %r10, 216(%rsp)
	movq 216(%rsp), %r11        /* ldi vr10, (vr9) */
	movq (%r11), %r11
	movq %r11, 224(%rsp)
	movq 224(%rsp), %r11        /* sti (vr4), vr10 */
	movq 176(%rsp), %r10
	movq %r11, (%r10)
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $8 */
	movq $8, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	leaq 136(%rsp), %r10        /* localaddr vr5, $136 */
	movq %r10, 184(%rsp)
	movq 184(%rsp), %r11        /* ldi vr6, (vr5) */
	movq (%r11), %r11
	movq %r11, 192(%rsp)
	movq 192(%rsp), %r11        /* sti (vr4), vr6 */
	movq 176(%rsp), %r10
	movq %r11, (%r10)
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq $1, 160(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %r11        /* ldi vr3, (vr1) */
	movq (%r11), %r11
	movq %r11, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* sti (vr0), vr4 */
	movq 144(%rsp), %r10
	movq %r11, (%r10)
.L5:
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	movq $8, 152(%rsp)          /* ldci vr1, $8 */
	movq 144(%rsp), %r11        /* ldi vr2, (vr0) */
	movq (%r11), %r11
	movq %r11, 160(%rsp)
	movq 160(%rsp), %r10        /* cmpi vr2, vr1 */
	movq 152(%rsp), %r11
	cmpq %r11, %r10
	jl .L4                      /* jlt .L4 */
	leaq 128(%rsp), %r10        /* localaddr vr3, $128 */
	movq %r10, 168(%rsp)
	movq $0, 176(%rsp)          /* ldci vr4, $0 */
	movq 176(%rsp), %r11        /* sti (vr3), vr4 */
	movq 168(%rsp), %r10
	movq %r11, (%r10)
	jmp .L7                     /* jmp .L7 */
.L6:
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $0 */
	movq $0, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* ldi vr5, (vr4) */
	movq (%r11), %r11
	movq %r11, 184(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr5 */
	movq 184(%rsp), %rsi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr0, $0 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq 152(%rsp), %r11        /* muli vr2, (vr1), $16 */
	movq (%r11), %r11
	movq $16, %r10
	imulq %r11, %r10
	movq %r10, 160(%rsp)
	movq 144(%rsp), %r11        /* addi vr3, vr0, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, $8 */
	movq $8, %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* ldi vr5, (vr4) */
	movq (%r11), %r11
	movq %r11, 184(%rsp)
	movq $s_writeint_fmt, %rdi  /* writei vr5 */
	movq 184(%rsp), %rsi
	call printf
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	leaq 128(%rsp), %r10        /* localaddr vr1, $128 */
	movq %r10, 152(%rsp)
	movq $1, 160(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %r11        /* ldi vr3, (vr1) */
	movq (%r11), %r11
	movq %r11, 168(%rsp)
	movq 168(%rsp), %r11        /* addi vr4, vr3, vr2 */
	movq 160(%rsp), %r10
	addq %r11, %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %r11        /* sti (vr0), vr4 */
	movq 144(%rsp), %r10
	movq %r11, (%r10)
.L7:
	leaq 128(%rsp), %r10        /* localaddr vr0, $128 */
	movq %r10, 144(%rsp)
	movq $8, 152(%rsp)          /* ldci vr1, $8 */
	movq 144(%rsp), %r11        /* ldi vr2, (vr0) */
	movq (%r11), %r11
	movq %r11, 160(%rsp)
	movq 160(%rsp), %r10        /* cmpi vr2, vr1 */
	movq 152(%rsp), %r11
	cmpq %r11, %r10
	jl .L6                      /* jlt .L6 */
	addq $232, %rsp
	movl $0, %eax
	ret
