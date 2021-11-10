/* 25 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	pushq %r13
	pushq %r15
	pushq %r12
	pushq %rbx
	pushq %r14
	subq $2608, %rsp
	movq $0, %r13               /* mov vr0, $0 */
	jmp .L0                     /* jmp .L0 */
.L3:
	leaq 0(%rsp), %rcx          /* localaddr vr7, $0 */
	movq %r13, %r8              /* muli vr8, vr0, $80 */
	imulq $80, %r8
	movq %rcx, %r9              /* addi vr9, vr7, vr8 */
	addq %r8, %r9
	movq %r15, %rdi             /* muli vr10, vr1, $8 */
	imulq $8, %rdi
	movq %r9, %rsi              /* addi vr11, vr9, vr10 */
	addq %rdi, %rsi
	pushq %rsi                  /* readi vr12 */
	subq $8, %rsp
	movq $s_readint_fmt, %rdi
	movq $s_readbuf, %rsi
	call scanf
	addq $8, %rsp
	popq %rsi
	movq s_readbuf, %rcx
	movq %rcx, (%rsi)           /* sti (vr11), vr12 */
	movq %r15, %r8              /* addi vr6, vr1, $1 */
	addq $1, %r8
	movq %r8, %r15              /* mov vr1, vr6 */
.L2:
	cmpq $10, %r15              /* cmpi vr1, $10 */
	jl .L3                      /* jlt .L3 */
	movq %r13, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r13             /* mov vr0, vr9 */
.L0:
	cmpq $10, %r13              /* cmpi vr0, $10 */
	jl .L1                      /* jlt .L1 */
	movq $0, %r13               /* mov vr0, $0 */
	jmp .L4                     /* jmp .L4 */
.L1:
	movq $0, %r15               /* mov vr1, $0 */
	jmp .L2                     /* jmp .L2 */
.L7:
	leaq 800(%rsp), %rcx        /* localaddr vr13, $800 */
	movq %r13, %r8              /* muli vr14, vr0, $80 */
	imulq $80, %r8
	movq %rcx, %r9              /* addi vr15, vr13, vr14 */
	addq %r8, %r9
	movq %r15, %rdi             /* muli vr16, vr1, $8 */
	imulq $8, %rdi
	movq %r9, %rsi              /* addi vr17, vr15, vr16 */
	addq %rdi, %rsi
	pushq %rsi                  /* readi vr18 */
	subq $8, %rsp
	movq $s_readint_fmt, %rdi
	movq $s_readbuf, %rsi
	call scanf
	addq $8, %rsp
	popq %rsi
	movq s_readbuf, %rcx
	movq %rcx, (%rsi)           /* sti (vr17), vr18 */
	movq %r15, %r8              /* addi vr6, vr1, $1 */
	addq $1, %r8
	movq %r8, %r15              /* mov vr1, vr6 */
.L6:
	cmpq $10, %r15              /* cmpi vr1, $10 */
	jl .L7                      /* jlt .L7 */
	movq %r13, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r13             /* mov vr0, vr9 */
.L4:
	cmpq $10, %r13              /* cmpi vr0, $10 */
	jl .L5                      /* jlt .L5 */
	movq $0, %r13               /* mov vr0, $0 */
	jmp .L8                     /* jmp .L8 */
.L5:
	movq $0, %r15               /* mov vr1, $0 */
	jmp .L6                     /* jmp .L6 */
.L11:
	leaq 1600(%rsp), %rcx       /* localaddr vr13, $1600 */
	movq %r13, %r8              /* muli vr14, vr0, $80 */
	imulq $80, %r8
	movq %rcx, %r9              /* addi vr15, vr13, vr14 */
	addq %r8, %r9
	movq %r15, %rdi             /* muli vr16, vr1, $8 */
	imulq $8, %rdi
	movq %r9, %rsi              /* addi vr17, vr15, vr16 */
	addq %rdi, %rsi
	movq $0, (%rsi)             /* sti (vr17), $0 */
	movq %r15, %rcx             /* addi vr6, vr1, $1 */
	addq $1, %rcx
	movq %rcx, %r15             /* mov vr1, vr6 */
.L10:
	cmpq $10, %r15              /* cmpi vr1, $10 */
	jl .L11                     /* jlt .L11 */
	movq %r13, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r13             /* mov vr0, vr9 */
.L8:
	cmpq $10, %r13              /* cmpi vr0, $10 */
	jl .L9                      /* jlt .L9 */
	movq $0, %r12               /* mov vr2, $0 */
	jmp .L12                    /* jmp .L12 */
.L9:
	movq $0, %r15               /* mov vr1, $0 */
	jmp .L10                    /* jmp .L10 */
.L17:
	leaq 1600(%rsp), %rcx       /* localaddr vr19, $1600 */
	movq %r13, %r8              /* muli vr20, vr0, $80 */
	imulq $80, %r8
	movq %rcx, %r9              /* addi vr21, vr19, vr20 */
	addq %r8, %r9
	movq %r15, %rdi             /* muli vr22, vr1, $8 */
	imulq $8, %rdi
	movq %r9, %rsi              /* addi vr23, vr21, vr22 */
	addq %rdi, %rsi
	movq (%rsi), %r10           /* ldi vr4, (vr23) */
	movq %r10, %r14
	leaq 800(%rsp), %rcx        /* localaddr vr24, $800 */
	movq %r12, %r8              /* muli vr25, vr2, $80 */
	imulq $80, %r8
	movq %rcx, %r9              /* addi vr26, vr24, vr25 */
	addq %r8, %r9
	movq %r9, %rcx              /* addi vr28, vr26, vr22 */
	addq %rdi, %rcx
	movq (%rcx), %r10           /* ldi vr29, (vr28) */
	movq %r10, %r8
	movq %rbx, %rdi             /* muli vr30, vr3, vr29 */
	imulq %r8, %rdi
	movq %r14, %r9              /* addi vr31, vr4, vr30 */
	addq %rdi, %r9
	movq %r9, (%rsi)            /* sti (vr23), vr31 */
	movq %r15, %rcx             /* addi vr6, vr1, $1 */
	addq $1, %rcx
	movq %rcx, %r15             /* mov vr1, vr6 */
.L16:
	cmpq $10, %r15              /* cmpi vr1, $10 */
	jl .L17                     /* jlt .L17 */
	movq %r13, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r13             /* mov vr0, vr9 */
.L14:
	cmpq $10, %r13              /* cmpi vr0, $10 */
	jl .L15                     /* jlt .L15 */
	movq %r12, %rcx             /* addi vr12, vr2, $1 */
	addq $1, %rcx
	movq %rcx, %r12             /* mov vr2, vr12 */
.L12:
	cmpq $10, %r12              /* cmpi vr2, $10 */
	jl .L13                     /* jlt .L13 */
	movq $0, %r13               /* mov vr0, $0 */
	jmp .L18                    /* jmp .L18 */
.L15:
	leaq 0(%rsp), %rcx          /* localaddr vr13, $0 */
	movq %r13, %r8              /* muli vr14, vr0, $80 */
	imulq $80, %r8
	movq %rcx, %r9              /* addi vr15, vr13, vr14 */
	addq %r8, %r9
	movq %r12, %rdi             /* muli vr16, vr2, $8 */
	imulq $8, %rdi
	movq %r9, %rsi              /* addi vr17, vr15, vr16 */
	addq %rdi, %rsi
	movq (%rsi), %r10           /* ldi vr3, (vr17) */
	movq %r10, %rbx
	movq $0, %r15               /* mov vr1, $0 */
	jmp .L16                    /* jmp .L16 */
.L13:
	movq $0, %r13               /* mov vr0, $0 */
	jmp .L14                    /* jmp .L14 */
.L19:
	movq $0, %r15               /* mov vr1, $0 */
	jmp .L20                    /* jmp .L20 */
.L21:
	leaq 1600(%rsp), %rcx       /* localaddr vr16, $1600 */
	movq %r13, %r8              /* muli vr17, vr0, $80 */
	imulq $80, %r8
	movq %rcx, %r9              /* addi vr18, vr16, vr17 */
	addq %r8, %r9
	movq %r15, %rdi             /* muli vr19, vr1, $8 */
	imulq $8, %rdi
	movq %r9, %rsi              /* addi vr20, vr18, vr19 */
	addq %rdi, %rsi
	movq (%rsi), %r10           /* ldi vr21, (vr20) */
	movq %r10, %rcx
	pushq %rcx                  /* writei vr21 */
	subq $8, %rsp
	movq %rcx, %rsi
	movq $s_writeint_fmt, %rdi
	call printf
	addq $8, %rsp
	popq %rcx
	movq %r15, %r8              /* addi vr6, vr1, $1 */
	addq $1, %r8
	movq %r8, %r15              /* mov vr1, vr6 */
.L20:
	cmpq $10, %r15              /* cmpi vr1, $10 */
	jl .L21                     /* jlt .L21 */
	movq %r13, %rcx             /* addi vr9, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r13             /* mov vr0, vr9 */
.L18:
	cmpq $10, %r13              /* cmpi vr0, $10 */
	jl .L19                     /* jlt .L19 */
	addq $2608, %rsp
	popq %r14
	popq %rbx
	popq %r12
	popq %r15
	popq %r13
	movl $0, %eax
	ret
