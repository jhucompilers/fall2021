/* 41 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $6000328, %rsp
	movq $0, 6000040(%rsp)      /* ldci vr5, $0 */
	movq 6000040(%rsp), %r10    /* mov vr0, vr5 */
	movq %r10, 6000000(%rsp)
	jmp .L0                     /* jmp .L0 */
.L1:
	movq $0, 6000048(%rsp)      /* ldci vr6, $0 */
	movq 6000048(%rsp), %r10    /* mov vr1, vr6 */
	movq %r10, 6000008(%rsp)
	jmp .L2                     /* jmp .L2 */
.L3:
	leaq 0(%rsp), %r10          /* localaddr vr7, $0 */
	movq %r10, 6000056(%rsp)
	movq $500, 6000064(%rsp)    /* ldci vr8, $500 */
	movq 6000072(%rsp), %rax    /* muli vr9, vr0, vr8 */
	movq 6000000(%rsp), %rax
	imulq 6000064(%rsp), %rax
	movq %rax, 6000072(%rsp)
	movq 6000080(%rsp), %rax    /* addi vr10, vr9, vr1 */
	movq 6000072(%rsp), %rax
	addq 6000008(%rsp), %rax
	movq %rax, 6000080(%rsp)
	movq 6000088(%rsp), %rax    /* muli vr11, vr10, $8 */
	movq 6000080(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000088(%rsp)
	movq 6000096(%rsp), %rax    /* addi vr12, vr7, vr11 */
	movq 6000056(%rsp), %rax
	addq 6000088(%rsp), %rax
	movq %rax, 6000096(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr13 */
	leaq 6000104(%rsp), %rsi
	call scanf
	movq 6000096(%rsp), %r11    /* sti (vr12), vr13 */
	movq 6000104(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 6000040(%rsp)      /* ldci vr5, $1 */
	movq 6000048(%rsp), %rax    /* addi vr6, vr1, vr5 */
	movq 6000008(%rsp), %rax
	addq 6000040(%rsp), %rax
	movq %rax, 6000048(%rsp)
	movq 6000048(%rsp), %r10    /* mov vr1, vr6 */
	movq %r10, 6000008(%rsp)
.L2:
	movq $500, 6000056(%rsp)    /* ldci vr7, $500 */
	movq 6000008(%rsp), %r10    /* cmpi vr1, vr7 */
	cmpq 6000056(%rsp), %r10
	jl .L3                      /* jlt .L3 */
	movq $1, 6000064(%rsp)      /* ldci vr8, $1 */
	movq 6000072(%rsp), %rax    /* addi vr9, vr0, vr8 */
	movq 6000000(%rsp), %rax
	addq 6000064(%rsp), %rax
	movq %rax, 6000072(%rsp)
	movq 6000072(%rsp), %r10    /* mov vr0, vr9 */
	movq %r10, 6000000(%rsp)
.L0:
	movq $500, 6000080(%rsp)    /* ldci vr10, $500 */
	movq 6000000(%rsp), %r10    /* cmpi vr0, vr10 */
	cmpq 6000080(%rsp), %r10
	jl .L1                      /* jlt .L1 */
	movq $0, 6000088(%rsp)      /* ldci vr11, $0 */
	movq 6000088(%rsp), %r10    /* mov vr0, vr11 */
	movq %r10, 6000000(%rsp)
	jmp .L4                     /* jmp .L4 */
.L5:
	movq $0, 6000096(%rsp)      /* ldci vr12, $0 */
	movq 6000096(%rsp), %r10    /* mov vr1, vr12 */
	movq %r10, 6000008(%rsp)
	jmp .L6                     /* jmp .L6 */
.L7:
	leaq 2000000(%rsp), %r10    /* localaddr vr13, $2000000 */
	movq %r10, 6000104(%rsp)
	movq $500, 6000112(%rsp)    /* ldci vr14, $500 */
	movq 6000120(%rsp), %rax    /* muli vr15, vr0, vr14 */
	movq 6000000(%rsp), %rax
	imulq 6000112(%rsp), %rax
	movq %rax, 6000120(%rsp)
	movq 6000128(%rsp), %rax    /* addi vr16, vr15, vr1 */
	movq 6000120(%rsp), %rax
	addq 6000008(%rsp), %rax
	movq %rax, 6000128(%rsp)
	movq 6000136(%rsp), %rax    /* muli vr17, vr16, $8 */
	movq 6000128(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000136(%rsp)
	movq 6000144(%rsp), %rax    /* addi vr18, vr13, vr17 */
	movq 6000104(%rsp), %rax
	addq 6000136(%rsp), %rax
	movq %rax, 6000144(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr19 */
	leaq 6000152(%rsp), %rsi
	call scanf
	movq 6000144(%rsp), %r11    /* sti (vr18), vr19 */
	movq 6000152(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 6000040(%rsp)      /* ldci vr5, $1 */
	movq 6000048(%rsp), %rax    /* addi vr6, vr1, vr5 */
	movq 6000008(%rsp), %rax
	addq 6000040(%rsp), %rax
	movq %rax, 6000048(%rsp)
	movq 6000048(%rsp), %r10    /* mov vr1, vr6 */
	movq %r10, 6000008(%rsp)
.L6:
	movq $500, 6000056(%rsp)    /* ldci vr7, $500 */
	movq 6000008(%rsp), %r10    /* cmpi vr1, vr7 */
	cmpq 6000056(%rsp), %r10
	jl .L7                      /* jlt .L7 */
	movq $1, 6000064(%rsp)      /* ldci vr8, $1 */
	movq 6000072(%rsp), %rax    /* addi vr9, vr0, vr8 */
	movq 6000000(%rsp), %rax
	addq 6000064(%rsp), %rax
	movq %rax, 6000072(%rsp)
	movq 6000072(%rsp), %r10    /* mov vr0, vr9 */
	movq %r10, 6000000(%rsp)
.L4:
	movq $500, 6000080(%rsp)    /* ldci vr10, $500 */
	movq 6000000(%rsp), %r10    /* cmpi vr0, vr10 */
	cmpq 6000080(%rsp), %r10
	jl .L5                      /* jlt .L5 */
	movq $0, 6000088(%rsp)      /* ldci vr11, $0 */
	movq 6000088(%rsp), %r10    /* mov vr0, vr11 */
	movq %r10, 6000000(%rsp)
	jmp .L8                     /* jmp .L8 */
.L9:
	movq $0, 6000096(%rsp)      /* ldci vr12, $0 */
	movq 6000096(%rsp), %r10    /* mov vr1, vr12 */
	movq %r10, 6000008(%rsp)
	jmp .L10                    /* jmp .L10 */
.L11:
	leaq 4000000(%rsp), %r10    /* localaddr vr13, $4000000 */
	movq %r10, 6000104(%rsp)
	movq $500, 6000112(%rsp)    /* ldci vr14, $500 */
	movq 6000120(%rsp), %rax    /* muli vr15, vr0, vr14 */
	movq 6000000(%rsp), %rax
	imulq 6000112(%rsp), %rax
	movq %rax, 6000120(%rsp)
	movq 6000128(%rsp), %rax    /* addi vr16, vr15, vr1 */
	movq 6000120(%rsp), %rax
	addq 6000008(%rsp), %rax
	movq %rax, 6000128(%rsp)
	movq 6000136(%rsp), %rax    /* muli vr17, vr16, $8 */
	movq 6000128(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000136(%rsp)
	movq 6000144(%rsp), %rax    /* addi vr18, vr13, vr17 */
	movq 6000104(%rsp), %rax
	addq 6000136(%rsp), %rax
	movq %rax, 6000144(%rsp)
	movq $0, 6000152(%rsp)      /* ldci vr19, $0 */
	movq 6000144(%rsp), %r11    /* sti (vr18), vr19 */
	movq 6000152(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 6000040(%rsp)      /* ldci vr5, $1 */
	movq 6000048(%rsp), %rax    /* addi vr6, vr1, vr5 */
	movq 6000008(%rsp), %rax
	addq 6000040(%rsp), %rax
	movq %rax, 6000048(%rsp)
	movq 6000048(%rsp), %r10    /* mov vr1, vr6 */
	movq %r10, 6000008(%rsp)
.L10:
	movq $500, 6000056(%rsp)    /* ldci vr7, $500 */
	movq 6000008(%rsp), %r10    /* cmpi vr1, vr7 */
	cmpq 6000056(%rsp), %r10
	jl .L11                     /* jlt .L11 */
	movq $1, 6000064(%rsp)      /* ldci vr8, $1 */
	movq 6000072(%rsp), %rax    /* addi vr9, vr0, vr8 */
	movq 6000000(%rsp), %rax
	addq 6000064(%rsp), %rax
	movq %rax, 6000072(%rsp)
	movq 6000072(%rsp), %r10    /* mov vr0, vr9 */
	movq %r10, 6000000(%rsp)
.L8:
	movq $500, 6000080(%rsp)    /* ldci vr10, $500 */
	movq 6000000(%rsp), %r10    /* cmpi vr0, vr10 */
	cmpq 6000080(%rsp), %r10
	jl .L9                      /* jlt .L9 */
	movq $0, 6000088(%rsp)      /* ldci vr11, $0 */
	movq 6000088(%rsp), %r10    /* mov vr2, vr11 */
	movq %r10, 6000016(%rsp)
	jmp .L12                    /* jmp .L12 */
.L13:
	movq $0, 6000096(%rsp)      /* ldci vr12, $0 */
	movq 6000096(%rsp), %r10    /* mov vr0, vr12 */
	movq %r10, 6000000(%rsp)
	jmp .L14                    /* jmp .L14 */
.L15:
	leaq 0(%rsp), %r10          /* localaddr vr13, $0 */
	movq %r10, 6000104(%rsp)
	movq $500, 6000112(%rsp)    /* ldci vr14, $500 */
	movq 6000120(%rsp), %rax    /* muli vr15, vr0, vr14 */
	movq 6000000(%rsp), %rax
	imulq 6000112(%rsp), %rax
	movq %rax, 6000120(%rsp)
	movq 6000128(%rsp), %rax    /* addi vr16, vr15, vr2 */
	movq 6000120(%rsp), %rax
	addq 6000016(%rsp), %rax
	movq %rax, 6000128(%rsp)
	movq 6000136(%rsp), %rax    /* muli vr17, vr16, $8 */
	movq 6000128(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000136(%rsp)
	movq 6000144(%rsp), %rax    /* addi vr18, vr13, vr17 */
	movq 6000104(%rsp), %rax
	addq 6000136(%rsp), %rax
	movq %rax, 6000144(%rsp)
	movq 6000144(%rsp), %r10    /* ldi vr3, (vr18) */
	movq (%r10), %r10
	movq %r10, 6000024(%rsp)
	movq $0, 6000152(%rsp)      /* ldci vr19, $0 */
	movq 6000152(%rsp), %r10    /* mov vr1, vr19 */
	movq %r10, 6000008(%rsp)
	jmp .L16                    /* jmp .L16 */
.L17:
	leaq 4000000(%rsp), %r10    /* localaddr vr20, $4000000 */
	movq %r10, 6000160(%rsp)
	movq $500, 6000168(%rsp)    /* ldci vr21, $500 */
	movq 6000176(%rsp), %rax    /* muli vr22, vr0, vr21 */
	movq 6000000(%rsp), %rax
	imulq 6000168(%rsp), %rax
	movq %rax, 6000176(%rsp)
	movq 6000184(%rsp), %rax    /* addi vr23, vr22, vr1 */
	movq 6000176(%rsp), %rax
	addq 6000008(%rsp), %rax
	movq %rax, 6000184(%rsp)
	movq 6000192(%rsp), %rax    /* muli vr24, vr23, $8 */
	movq 6000184(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000192(%rsp)
	movq 6000200(%rsp), %rax    /* addi vr25, vr20, vr24 */
	movq 6000160(%rsp), %rax
	addq 6000192(%rsp), %rax
	movq %rax, 6000200(%rsp)
	movq 6000200(%rsp), %r10    /* ldi vr4, (vr25) */
	movq (%r10), %r10
	movq %r10, 6000032(%rsp)
	leaq 2000000(%rsp), %r10    /* localaddr vr26, $2000000 */
	movq %r10, 6000208(%rsp)
	movq $500, 6000216(%rsp)    /* ldci vr27, $500 */
	movq 6000224(%rsp), %rax    /* muli vr28, vr2, vr27 */
	movq 6000016(%rsp), %rax
	imulq 6000216(%rsp), %rax
	movq %rax, 6000224(%rsp)
	movq 6000232(%rsp), %rax    /* addi vr29, vr28, vr1 */
	movq 6000224(%rsp), %rax
	addq 6000008(%rsp), %rax
	movq %rax, 6000232(%rsp)
	movq 6000240(%rsp), %rax    /* muli vr30, vr29, $8 */
	movq 6000232(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000240(%rsp)
	movq 6000248(%rsp), %rax    /* addi vr31, vr26, vr30 */
	movq 6000208(%rsp), %rax
	addq 6000240(%rsp), %rax
	movq %rax, 6000248(%rsp)
	movq 6000248(%rsp), %r10    /* ldi vr32, (vr31) */
	movq (%r10), %r10
	movq %r10, 6000256(%rsp)
	movq 6000264(%rsp), %rax    /* muli vr33, vr3, vr32 */
	movq 6000024(%rsp), %rax
	imulq 6000256(%rsp), %rax
	movq %rax, 6000264(%rsp)
	movq 6000272(%rsp), %rax    /* addi vr34, vr4, vr33 */
	movq 6000032(%rsp), %rax
	addq 6000264(%rsp), %rax
	movq %rax, 6000272(%rsp)
	movq 6000272(%rsp), %r10    /* mov vr4, vr34 */
	movq %r10, 6000032(%rsp)
	leaq 4000000(%rsp), %r10    /* localaddr vr35, $4000000 */
	movq %r10, 6000280(%rsp)
	movq $500, 6000288(%rsp)    /* ldci vr36, $500 */
	movq 6000296(%rsp), %rax    /* muli vr37, vr0, vr36 */
	movq 6000000(%rsp), %rax
	imulq 6000288(%rsp), %rax
	movq %rax, 6000296(%rsp)
	movq 6000304(%rsp), %rax    /* addi vr38, vr37, vr1 */
	movq 6000296(%rsp), %rax
	addq 6000008(%rsp), %rax
	movq %rax, 6000304(%rsp)
	movq 6000312(%rsp), %rax    /* muli vr39, vr38, $8 */
	movq 6000304(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000312(%rsp)
	movq 6000320(%rsp), %rax    /* addi vr40, vr35, vr39 */
	movq 6000280(%rsp), %rax
	addq 6000312(%rsp), %rax
	movq %rax, 6000320(%rsp)
	movq 6000320(%rsp), %r11    /* sti (vr40), vr4 */
	movq 6000032(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 6000040(%rsp)      /* ldci vr5, $1 */
	movq 6000048(%rsp), %rax    /* addi vr6, vr1, vr5 */
	movq 6000008(%rsp), %rax
	addq 6000040(%rsp), %rax
	movq %rax, 6000048(%rsp)
	movq 6000048(%rsp), %r10    /* mov vr1, vr6 */
	movq %r10, 6000008(%rsp)
.L16:
	movq $500, 6000056(%rsp)    /* ldci vr7, $500 */
	movq 6000008(%rsp), %r10    /* cmpi vr1, vr7 */
	cmpq 6000056(%rsp), %r10
	jl .L17                     /* jlt .L17 */
	movq $1, 6000064(%rsp)      /* ldci vr8, $1 */
	movq 6000072(%rsp), %rax    /* addi vr9, vr0, vr8 */
	movq 6000000(%rsp), %rax
	addq 6000064(%rsp), %rax
	movq %rax, 6000072(%rsp)
	movq 6000072(%rsp), %r10    /* mov vr0, vr9 */
	movq %r10, 6000000(%rsp)
.L14:
	movq $500, 6000080(%rsp)    /* ldci vr10, $500 */
	movq 6000000(%rsp), %r10    /* cmpi vr0, vr10 */
	cmpq 6000080(%rsp), %r10
	jl .L15                     /* jlt .L15 */
	movq $1, 6000088(%rsp)      /* ldci vr11, $1 */
	movq 6000096(%rsp), %rax    /* addi vr12, vr2, vr11 */
	movq 6000016(%rsp), %rax
	addq 6000088(%rsp), %rax
	movq %rax, 6000096(%rsp)
	movq 6000096(%rsp), %r10    /* mov vr2, vr12 */
	movq %r10, 6000016(%rsp)
.L12:
	movq $500, 6000104(%rsp)    /* ldci vr13, $500 */
	movq 6000016(%rsp), %r10    /* cmpi vr2, vr13 */
	cmpq 6000104(%rsp), %r10
	jl .L13                     /* jlt .L13 */
	movq $0, 6000112(%rsp)      /* ldci vr14, $0 */
	movq 6000112(%rsp), %r10    /* mov vr0, vr14 */
	movq %r10, 6000000(%rsp)
	jmp .L18                    /* jmp .L18 */
.L19:
	movq $0, 6000120(%rsp)      /* ldci vr15, $0 */
	movq 6000120(%rsp), %r10    /* mov vr1, vr15 */
	movq %r10, 6000008(%rsp)
	jmp .L20                    /* jmp .L20 */
.L21:
	leaq 4000000(%rsp), %r10    /* localaddr vr16, $4000000 */
	movq %r10, 6000128(%rsp)
	movq $500, 6000136(%rsp)    /* ldci vr17, $500 */
	movq 6000144(%rsp), %rax    /* muli vr18, vr0, vr17 */
	movq 6000000(%rsp), %rax
	imulq 6000136(%rsp), %rax
	movq %rax, 6000144(%rsp)
	movq 6000152(%rsp), %rax    /* addi vr19, vr18, vr1 */
	movq 6000144(%rsp), %rax
	addq 6000008(%rsp), %rax
	movq %rax, 6000152(%rsp)
	movq 6000160(%rsp), %rax    /* muli vr20, vr19, $8 */
	movq 6000152(%rsp), %rax
	imulq $8, %rax
	movq %rax, 6000160(%rsp)
	movq 6000168(%rsp), %rax    /* addi vr21, vr16, vr20 */
	movq 6000128(%rsp), %rax
	addq 6000160(%rsp), %rax
	movq %rax, 6000168(%rsp)
	movq 6000168(%rsp), %r10    /* ldi vr22, (vr21) */
	movq (%r10), %r10
	movq %r10, 6000176(%rsp)
	movq 6000176(%rsp), %rsi    /* writei vr22 */
	movq $s_writeint_fmt, %rdi
	call printf
	movq $1, 6000040(%rsp)      /* ldci vr5, $1 */
	movq 6000048(%rsp), %rax    /* addi vr6, vr1, vr5 */
	movq 6000008(%rsp), %rax
	addq 6000040(%rsp), %rax
	movq %rax, 6000048(%rsp)
	movq 6000048(%rsp), %r10    /* mov vr1, vr6 */
	movq %r10, 6000008(%rsp)
.L20:
	movq $500, 6000056(%rsp)    /* ldci vr7, $500 */
	movq 6000008(%rsp), %r10    /* cmpi vr1, vr7 */
	cmpq 6000056(%rsp), %r10
	jl .L21                     /* jlt .L21 */
	movq $1, 6000064(%rsp)      /* ldci vr8, $1 */
	movq 6000072(%rsp), %rax    /* addi vr9, vr0, vr8 */
	movq 6000000(%rsp), %rax
	addq 6000064(%rsp), %rax
	movq %rax, 6000072(%rsp)
	movq 6000072(%rsp), %r10    /* mov vr0, vr9 */
	movq %r10, 6000000(%rsp)
.L18:
	movq $500, 6000080(%rsp)    /* ldci vr10, $500 */
	movq 6000000(%rsp), %r10    /* cmpi vr0, vr10 */
	cmpq 6000080(%rsp), %r10
	jl .L19                     /* jlt .L19 */
	addq $6000328, %rsp
	movl $0, %eax
	ret
