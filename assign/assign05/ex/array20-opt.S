/* 26 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	pushq %r14
	pushq %r13
	pushq %r12
	pushq %rbx
	pushq %r15
	subq $6000208, %rsp
	movq $0, %r14               /* mov vr0, $0 */
	jmp .L0                     /* jmp .L0 */
.L3:
	leaq 0(%rsp), %rcx          /* localaddr vr7, $0 */
	movq %r14, %r8              /* muli vr9, vr0, $500 */
	imulq $500, %r8
	movq %r8, %r9               /* addi vr10, vr9, vr1 */
	addq %r13, %r9
	movq %r9, %rdi              /* muli vr11, vr10, $8 */
	imulq $8, %rdi
	movq %rcx, %rsi             /* addi vr12, vr7, vr11 */
	addq %rdi, %rsi
	pushq %rsi                  /* readi vr13 */
	subq $8, %rsp
	movq $s_readint_fmt, %rdi
	movq $s_readbuf, %rsi
	call scanf
	addq $8, %rsp
	popq %rsi
	movq s_readbuf, %r8
	movq %r8, (%rsi)            /* sti (vr12), vr13 */
	movq %r13, %r9              /* addi vr6, vr1, $1 */
	addq $1, %r9
	movq %r9, %r13              /* mov vr1, vr6 */
.L2:
	cmpq $500, %r13             /* cmpi vr1, $500 */
	jl .L3                      /* jlt .L3 */
	movq %r14, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r14             /* mov vr0, vr9 */
.L0:
	cmpq $500, %r14             /* cmpi vr0, $500 */
	jl .L1                      /* jlt .L1 */
	movq $0, %r14               /* mov vr0, $0 */
	jmp .L4                     /* jmp .L4 */
.L1:
	movq $0, %r13               /* mov vr1, $0 */
	jmp .L2                     /* jmp .L2 */
.L7:
	leaq 2000000(%rsp), %rcx    /* localaddr vr13, $2000000 */
	movq %r14, %r8              /* muli vr15, vr0, $500 */
	imulq $500, %r8
	movq %r8, %r9               /* addi vr16, vr15, vr1 */
	addq %r13, %r9
	movq %r9, %rdi              /* muli vr17, vr16, $8 */
	imulq $8, %rdi
	movq %rcx, %rsi             /* addi vr18, vr13, vr17 */
	addq %rdi, %rsi
	pushq %rsi                  /* readi vr19 */
	subq $8, %rsp
	movq $s_readint_fmt, %rdi
	movq $s_readbuf, %rsi
	call scanf
	addq $8, %rsp
	popq %rsi
	movq s_readbuf, %r8
	movq %r8, (%rsi)            /* sti (vr18), vr19 */
	movq %r13, %r9              /* addi vr6, vr1, $1 */
	addq $1, %r9
	movq %r9, %r13              /* mov vr1, vr6 */
.L6:
	cmpq $500, %r13             /* cmpi vr1, $500 */
	jl .L7                      /* jlt .L7 */
	movq %r14, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r14             /* mov vr0, vr9 */
.L4:
	cmpq $500, %r14             /* cmpi vr0, $500 */
	jl .L5                      /* jlt .L5 */
	movq $0, %r14               /* mov vr0, $0 */
	jmp .L8                     /* jmp .L8 */
.L5:
	movq $0, %r13               /* mov vr1, $0 */
	jmp .L6                     /* jmp .L6 */
.L11:
	leaq 4000000(%rsp), %rcx    /* localaddr vr13, $4000000 */
	movq %r14, %r8              /* muli vr15, vr0, $500 */
	imulq $500, %r8
	movq %r8, %r9               /* addi vr16, vr15, vr1 */
	addq %r13, %r9
	movq %r9, %rdi              /* muli vr17, vr16, $8 */
	imulq $8, %rdi
	movq %rcx, %rsi             /* addi vr18, vr13, vr17 */
	addq %rdi, %rsi
	movq $0, (%rsi)             /* sti (vr18), $0 */
	movq %r13, %r8              /* addi vr6, vr1, $1 */
	addq $1, %r8
	movq %r8, %r13              /* mov vr1, vr6 */
.L10:
	cmpq $500, %r13             /* cmpi vr1, $500 */
	jl .L11                     /* jlt .L11 */
	movq %r14, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r14             /* mov vr0, vr9 */
.L8:
	cmpq $500, %r14             /* cmpi vr0, $500 */
	jl .L9                      /* jlt .L9 */
	movq $0, %r12               /* mov vr2, $0 */
	jmp .L12                    /* jmp .L12 */
.L9:
	movq $0, %r13               /* mov vr1, $0 */
	jmp .L10                    /* jmp .L10 */
.L17:
	leaq 4000000(%rsp), %rcx    /* localaddr vr20, $4000000 */
	movq %r14, %r8              /* muli vr22, vr0, $500 */
	imulq $500, %r8
	movq %r8, %r9               /* addi vr23, vr22, vr1 */
	addq %r13, %r9
	movq %r9, %rdi              /* muli vr24, vr23, $8 */
	imulq $8, %rdi
	movq %rcx, %rsi             /* addi vr25, vr20, vr24 */
	addq %rdi, %rsi
	movq (%rsi), %r10           /* ldi vr4, (vr25) */
	movq %r10, %r15
	leaq 2000000(%rsp), %r8     /* localaddr vr26, $2000000 */
	movq %r12, %r9              /* muli vr28, vr2, $500 */
	imulq $500, %r9
	movq %r9, %rcx              /* addi vr29, vr28, vr1 */
	addq %r13, %rcx
	movq %rcx, %rdi             /* muli vr30, vr29, $8 */
	imulq $8, %rdi
	movq %r8, %r9               /* addi vr31, vr26, vr30 */
	addq %rdi, %r9
	movq (%r9), %r10            /* ldi vr32, (vr31) */
	movq %r10, %rcx
	movq %rbx, %r8              /* muli vr33, vr3, vr32 */
	imulq %rcx, %r8
	movq %r15, %rdi             /* addi vr34, vr4, vr33 */
	addq %r8, %rdi
	movq %rdi, (%rsi)           /* sti (vr25), vr34 */
	movq %r13, %r9              /* addi vr6, vr1, $1 */
	addq $1, %r9
	movq %r9, %r13              /* mov vr1, vr6 */
.L16:
	cmpq $500, %r13             /* cmpi vr1, $500 */
	jl .L17                     /* jlt .L17 */
	movq %r14, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r14             /* mov vr0, vr9 */
.L14:
	cmpq $500, %r14             /* cmpi vr0, $500 */
	jl .L15                     /* jlt .L15 */
	movq %r12, %rcx             /* addi vr12, vr2, $1 */
	addq $1, %rcx
	movq %rcx, %r12             /* mov vr2, vr12 */
.L12:
	cmpq $500, %r12             /* cmpi vr2, $500 */
	jl .L13                     /* jlt .L13 */
	movq $0, %r14               /* mov vr0, $0 */
	jmp .L18                    /* jmp .L18 */
.L15:
	leaq 0(%rsp), %rcx          /* localaddr vr13, $0 */
	movq %r14, %r8              /* muli vr15, vr0, $500 */
	imulq $500, %r8
	movq %r8, %r9               /* addi vr16, vr15, vr2 */
	addq %r12, %r9
	movq %r9, %rdi              /* muli vr17, vr16, $8 */
	imulq $8, %rdi
	movq %rcx, %rsi             /* addi vr18, vr13, vr17 */
	addq %rdi, %rsi
	movq (%rsi), %r10           /* ldi vr3, (vr18) */
	movq %r10, %rbx
	movq $0, %r13               /* mov vr1, $0 */
	jmp .L16                    /* jmp .L16 */
.L13:
	movq $0, %r14               /* mov vr0, $0 */
	jmp .L14                    /* jmp .L14 */
.L19:
	movq $0, %r13               /* mov vr1, $0 */
	jmp .L20                    /* jmp .L20 */
.L21:
	leaq 4000000(%rsp), %rcx    /* localaddr vr16, $4000000 */
	movq %r14, %r8              /* muli vr18, vr0, $500 */
	imulq $500, %r8
	movq %r8, %r9               /* addi vr19, vr18, vr1 */
	addq %r13, %r9
	movq %r9, %rdi              /* muli vr20, vr19, $8 */
	imulq $8, %rdi
	movq %rcx, %rsi             /* addi vr21, vr16, vr20 */
	addq %rdi, %rsi
	movq (%rsi), %r10           /* ldi vr22, (vr21) */
	movq %r10, %r8
	pushq %r8                   /* writei vr22 */
	subq $8, %rsp
	movq %r8, %rsi
	movq $s_writeint_fmt, %rdi
	call printf
	addq $8, %rsp
	popq %r8
	movq %r13, %r9              /* addi vr6, vr1, $1 */
	addq $1, %r9
	movq %r9, %r13              /* mov vr1, vr6 */
.L20:
	cmpq $500, %r13             /* cmpi vr1, $500 */
	jl .L21                     /* jlt .L21 */
	movq %r14, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r14             /* mov vr0, vr9 */
.L18:
	cmpq $500, %r14             /* cmpi vr0, $500 */
	jl .L19                     /* jlt .L19 */
	addq $6000208, %rsp
	popq %r15
	popq %rbx
	popq %r12
	popq %r13
	popq %r14
	movl $0, %eax
	ret
