/* 19 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $280, %rsp
	movq $0, 144(%rsp)          /* ldci vr2, $0 */
	movq 144(%rsp), %r10        /* mov vr0, vr2 */
	movq %r10, 128(%rsp)
	jmp .L0                     /* jmp .L0 */
.L1:
	leaq 0(%rsp), %r10          /* localaddr vr3, $0 */
	movq %r10, 152(%rsp)
	movq 160(%rsp), %rax        /* muli vr4, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 160(%rsp)
	movq 168(%rsp), %rax        /* addi vr5, vr3, vr4 */
	movq 152(%rsp), %rax
	addq 160(%rsp), %rax
	movq %rax, 168(%rsp)
	movq 176(%rsp), %rax        /* addi vr6, vr5, $0 */
	movq 168(%rsp), %rax
	addq $0, %rax
	movq %rax, 176(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr7 */
	leaq 184(%rsp), %rsi
	call scanf
	movq 176(%rsp), %r11        /* sti (vr6), vr7 */
	movq 184(%rsp), %r10
	movq %r10, (%r11)
	leaq 0(%rsp), %r10          /* localaddr vr2, $0 */
	movq %r10, 144(%rsp)
	movq 152(%rsp), %rax        /* muli vr3, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 152(%rsp)
	movq 160(%rsp), %rax        /* addi vr4, vr2, vr3 */
	movq 144(%rsp), %rax
	addq 152(%rsp), %rax
	movq %rax, 160(%rsp)
	movq 168(%rsp), %rax        /* addi vr5, vr4, $8 */
	movq 160(%rsp), %rax
	addq $8, %rax
	movq %rax, 168(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr6 */
	leaq 176(%rsp), %rsi
	call scanf
	movq 168(%rsp), %r11        /* sti (vr5), vr6 */
	movq 176(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 144(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %rax        /* addi vr3, vr0, vr2 */
	movq 128(%rsp), %rax
	addq 144(%rsp), %rax
	movq %rax, 152(%rsp)
	movq 152(%rsp), %r10        /* mov vr0, vr3 */
	movq %r10, 128(%rsp)
.L0:
	movq $8, 160(%rsp)          /* ldci vr4, $8 */
	movq 128(%rsp), %r10        /* cmpi vr0, vr4 */
	cmpq 160(%rsp), %r10
	jl .L1                      /* jlt .L1 */
	movq $0, 168(%rsp)          /* ldci vr5, $0 */
	movq 168(%rsp), %r10        /* mov vr0, vr5 */
	movq %r10, 128(%rsp)
	jmp .L2                     /* jmp .L2 */
.L3:
	leaq 0(%rsp), %r10          /* localaddr vr6, $0 */
	movq %r10, 176(%rsp)
	movq 184(%rsp), %rax        /* muli vr7, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 184(%rsp)
	movq 192(%rsp), %rax        /* addi vr8, vr6, vr7 */
	movq 176(%rsp), %rax
	addq 184(%rsp), %rax
	movq %rax, 192(%rsp)
	movq 200(%rsp), %rax        /* addi vr9, vr8, $0 */
	movq 192(%rsp), %rax
	addq $0, %rax
	movq %rax, 200(%rsp)
	movq 200(%rsp), %r10        /* ldi vr10, (vr9) */
	movq (%r10), %r10
	movq %r10, 208(%rsp)
	movq 208(%rsp), %rsi        /* writei vr10 */
	movq $s_writeint_fmt, %rdi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr2, $0 */
	movq %r10, 144(%rsp)
	movq 152(%rsp), %rax        /* muli vr3, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 152(%rsp)
	movq 160(%rsp), %rax        /* addi vr4, vr2, vr3 */
	movq 144(%rsp), %rax
	addq 152(%rsp), %rax
	movq %rax, 160(%rsp)
	movq 168(%rsp), %rax        /* addi vr5, vr4, $8 */
	movq 160(%rsp), %rax
	addq $8, %rax
	movq %rax, 168(%rsp)
	movq 168(%rsp), %r10        /* ldi vr6, (vr5) */
	movq (%r10), %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %rsi        /* writei vr6 */
	movq $s_writeint_fmt, %rdi
	call printf
	movq $1, 144(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %rax        /* addi vr3, vr0, vr2 */
	movq 128(%rsp), %rax
	addq 144(%rsp), %rax
	movq %rax, 152(%rsp)
	movq 152(%rsp), %r10        /* mov vr0, vr3 */
	movq %r10, 128(%rsp)
.L2:
	movq $8, 160(%rsp)          /* ldci vr4, $8 */
	movq 128(%rsp), %r10        /* cmpi vr0, vr4 */
	cmpq 160(%rsp), %r10
	jl .L3                      /* jlt .L3 */
	movq $0, 168(%rsp)          /* ldci vr5, $0 */
	movq 168(%rsp), %r10        /* mov vr0, vr5 */
	movq %r10, 128(%rsp)
	jmp .L4                     /* jmp .L4 */
.L5:
	leaq 0(%rsp), %r10          /* localaddr vr6, $0 */
	movq %r10, 176(%rsp)
	movq 184(%rsp), %rax        /* muli vr7, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 184(%rsp)
	movq 192(%rsp), %rax        /* addi vr8, vr6, vr7 */
	movq 176(%rsp), %rax
	addq 184(%rsp), %rax
	movq %rax, 192(%rsp)
	movq 200(%rsp), %rax        /* addi vr9, vr8, $0 */
	movq 192(%rsp), %rax
	addq $0, %rax
	movq %rax, 200(%rsp)
	movq 200(%rsp), %r10        /* ldi vr1, (vr9) */
	movq (%r10), %r10
	movq %r10, 136(%rsp)
	leaq 0(%rsp), %r10          /* localaddr vr10, $0 */
	movq %r10, 208(%rsp)
	movq 216(%rsp), %rax        /* muli vr11, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 216(%rsp)
	movq 224(%rsp), %rax        /* addi vr12, vr10, vr11 */
	movq 208(%rsp), %rax
	addq 216(%rsp), %rax
	movq %rax, 224(%rsp)
	movq 232(%rsp), %rax        /* addi vr13, vr12, $0 */
	movq 224(%rsp), %rax
	addq $0, %rax
	movq %rax, 232(%rsp)
	leaq 0(%rsp), %r10          /* localaddr vr14, $0 */
	movq %r10, 240(%rsp)
	movq 248(%rsp), %rax        /* muli vr15, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 248(%rsp)
	movq 256(%rsp), %rax        /* addi vr16, vr14, vr15 */
	movq 240(%rsp), %rax
	addq 248(%rsp), %rax
	movq %rax, 256(%rsp)
	movq 264(%rsp), %rax        /* addi vr17, vr16, $8 */
	movq 256(%rsp), %rax
	addq $8, %rax
	movq %rax, 264(%rsp)
	movq 264(%rsp), %r10        /* ldi vr18, (vr17) */
	movq (%r10), %r10
	movq %r10, 272(%rsp)
	movq 232(%rsp), %r11        /* sti (vr13), vr18 */
	movq 272(%rsp), %r10
	movq %r10, (%r11)
	leaq 0(%rsp), %r10          /* localaddr vr2, $0 */
	movq %r10, 144(%rsp)
	movq 152(%rsp), %rax        /* muli vr3, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 152(%rsp)
	movq 160(%rsp), %rax        /* addi vr4, vr2, vr3 */
	movq 144(%rsp), %rax
	addq 152(%rsp), %rax
	movq %rax, 160(%rsp)
	movq 168(%rsp), %rax        /* addi vr5, vr4, $8 */
	movq 160(%rsp), %rax
	addq $8, %rax
	movq %rax, 168(%rsp)
	movq 168(%rsp), %r11        /* sti (vr5), vr1 */
	movq 136(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 144(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %rax        /* addi vr3, vr0, vr2 */
	movq 128(%rsp), %rax
	addq 144(%rsp), %rax
	movq %rax, 152(%rsp)
	movq 152(%rsp), %r10        /* mov vr0, vr3 */
	movq %r10, 128(%rsp)
.L4:
	movq $8, 160(%rsp)          /* ldci vr4, $8 */
	movq 128(%rsp), %r10        /* cmpi vr0, vr4 */
	cmpq 160(%rsp), %r10
	jl .L5                      /* jlt .L5 */
	movq $0, 168(%rsp)          /* ldci vr5, $0 */
	movq 168(%rsp), %r10        /* mov vr0, vr5 */
	movq %r10, 128(%rsp)
	jmp .L6                     /* jmp .L6 */
.L7:
	leaq 0(%rsp), %r10          /* localaddr vr6, $0 */
	movq %r10, 176(%rsp)
	movq 184(%rsp), %rax        /* muli vr7, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 184(%rsp)
	movq 192(%rsp), %rax        /* addi vr8, vr6, vr7 */
	movq 176(%rsp), %rax
	addq 184(%rsp), %rax
	movq %rax, 192(%rsp)
	movq 200(%rsp), %rax        /* addi vr9, vr8, $0 */
	movq 192(%rsp), %rax
	addq $0, %rax
	movq %rax, 200(%rsp)
	movq 200(%rsp), %r10        /* ldi vr10, (vr9) */
	movq (%r10), %r10
	movq %r10, 208(%rsp)
	movq 208(%rsp), %rsi        /* writei vr10 */
	movq $s_writeint_fmt, %rdi
	call printf
	leaq 0(%rsp), %r10          /* localaddr vr2, $0 */
	movq %r10, 144(%rsp)
	movq 152(%rsp), %rax        /* muli vr3, vr0, $16 */
	movq 128(%rsp), %rax
	imulq $16, %rax
	movq %rax, 152(%rsp)
	movq 160(%rsp), %rax        /* addi vr4, vr2, vr3 */
	movq 144(%rsp), %rax
	addq 152(%rsp), %rax
	movq %rax, 160(%rsp)
	movq 168(%rsp), %rax        /* addi vr5, vr4, $8 */
	movq 160(%rsp), %rax
	addq $8, %rax
	movq %rax, 168(%rsp)
	movq 168(%rsp), %r10        /* ldi vr6, (vr5) */
	movq (%r10), %r10
	movq %r10, 176(%rsp)
	movq 176(%rsp), %rsi        /* writei vr6 */
	movq $s_writeint_fmt, %rdi
	call printf
	movq $1, 144(%rsp)          /* ldci vr2, $1 */
	movq 152(%rsp), %rax        /* addi vr3, vr0, vr2 */
	movq 128(%rsp), %rax
	addq 144(%rsp), %rax
	movq %rax, 152(%rsp)
	movq 152(%rsp), %r10        /* mov vr0, vr3 */
	movq %r10, 128(%rsp)
.L6:
	movq $8, 160(%rsp)          /* ldci vr4, $8 */
	movq 128(%rsp), %r10        /* cmpi vr0, vr4 */
	cmpq 160(%rsp), %r10
	jl .L7                      /* jlt .L7 */
	addq $280, %rsp
	movl $0, %eax
	ret
