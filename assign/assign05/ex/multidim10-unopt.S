/* 37 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	subq $2696, %rsp
	movq $0, 2440(%rsp)         /* ldci vr5, $0 */
	movq 2440(%rsp), %r10       /* mov vr0, vr5 */
	movq %r10, 2400(%rsp)
	jmp .L0                     /* jmp .L0 */
.L1:
	movq $0, 2448(%rsp)         /* ldci vr6, $0 */
	movq 2448(%rsp), %r10       /* mov vr1, vr6 */
	movq %r10, 2408(%rsp)
	jmp .L2                     /* jmp .L2 */
.L3:
	leaq 0(%rsp), %r10          /* localaddr vr7, $0 */
	movq %r10, 2456(%rsp)
	movq 2464(%rsp), %rax       /* muli vr8, vr0, $80 */
	movq 2400(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2464(%rsp)
	movq 2472(%rsp), %rax       /* addi vr9, vr7, vr8 */
	movq 2456(%rsp), %rax
	addq 2464(%rsp), %rax
	movq %rax, 2472(%rsp)
	movq 2480(%rsp), %rax       /* muli vr10, vr1, $8 */
	movq 2408(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2480(%rsp)
	movq 2488(%rsp), %rax       /* addi vr11, vr9, vr10 */
	movq 2472(%rsp), %rax
	addq 2480(%rsp), %rax
	movq %rax, 2488(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr12 */
	leaq 2496(%rsp), %rsi
	call scanf
	movq 2488(%rsp), %r11       /* sti (vr11), vr12 */
	movq 2496(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 2440(%rsp)         /* ldci vr5, $1 */
	movq 2448(%rsp), %rax       /* addi vr6, vr1, vr5 */
	movq 2408(%rsp), %rax
	addq 2440(%rsp), %rax
	movq %rax, 2448(%rsp)
	movq 2448(%rsp), %r10       /* mov vr1, vr6 */
	movq %r10, 2408(%rsp)
.L2:
	movq $10, 2456(%rsp)        /* ldci vr7, $10 */
	movq 2408(%rsp), %r10       /* cmpi vr1, vr7 */
	cmpq 2456(%rsp), %r10
	jl .L3                      /* jlt .L3 */
	movq $1, 2464(%rsp)         /* ldci vr8, $1 */
	movq 2472(%rsp), %rax       /* addi vr9, vr0, vr8 */
	movq 2400(%rsp), %rax
	addq 2464(%rsp), %rax
	movq %rax, 2472(%rsp)
	movq 2472(%rsp), %r10       /* mov vr0, vr9 */
	movq %r10, 2400(%rsp)
.L0:
	movq $10, 2480(%rsp)        /* ldci vr10, $10 */
	movq 2400(%rsp), %r10       /* cmpi vr0, vr10 */
	cmpq 2480(%rsp), %r10
	jl .L1                      /* jlt .L1 */
	movq $0, 2488(%rsp)         /* ldci vr11, $0 */
	movq 2488(%rsp), %r10       /* mov vr0, vr11 */
	movq %r10, 2400(%rsp)
	jmp .L4                     /* jmp .L4 */
.L5:
	movq $0, 2496(%rsp)         /* ldci vr12, $0 */
	movq 2496(%rsp), %r10       /* mov vr1, vr12 */
	movq %r10, 2408(%rsp)
	jmp .L6                     /* jmp .L6 */
.L7:
	leaq 800(%rsp), %r10        /* localaddr vr13, $800 */
	movq %r10, 2504(%rsp)
	movq 2512(%rsp), %rax       /* muli vr14, vr0, $80 */
	movq 2400(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2512(%rsp)
	movq 2520(%rsp), %rax       /* addi vr15, vr13, vr14 */
	movq 2504(%rsp), %rax
	addq 2512(%rsp), %rax
	movq %rax, 2520(%rsp)
	movq 2528(%rsp), %rax       /* muli vr16, vr1, $8 */
	movq 2408(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2528(%rsp)
	movq 2536(%rsp), %rax       /* addi vr17, vr15, vr16 */
	movq 2520(%rsp), %rax
	addq 2528(%rsp), %rax
	movq %rax, 2536(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr18 */
	leaq 2544(%rsp), %rsi
	call scanf
	movq 2536(%rsp), %r11       /* sti (vr17), vr18 */
	movq 2544(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 2440(%rsp)         /* ldci vr5, $1 */
	movq 2448(%rsp), %rax       /* addi vr6, vr1, vr5 */
	movq 2408(%rsp), %rax
	addq 2440(%rsp), %rax
	movq %rax, 2448(%rsp)
	movq 2448(%rsp), %r10       /* mov vr1, vr6 */
	movq %r10, 2408(%rsp)
.L6:
	movq $10, 2456(%rsp)        /* ldci vr7, $10 */
	movq 2408(%rsp), %r10       /* cmpi vr1, vr7 */
	cmpq 2456(%rsp), %r10
	jl .L7                      /* jlt .L7 */
	movq $1, 2464(%rsp)         /* ldci vr8, $1 */
	movq 2472(%rsp), %rax       /* addi vr9, vr0, vr8 */
	movq 2400(%rsp), %rax
	addq 2464(%rsp), %rax
	movq %rax, 2472(%rsp)
	movq 2472(%rsp), %r10       /* mov vr0, vr9 */
	movq %r10, 2400(%rsp)
.L4:
	movq $10, 2480(%rsp)        /* ldci vr10, $10 */
	movq 2400(%rsp), %r10       /* cmpi vr0, vr10 */
	cmpq 2480(%rsp), %r10
	jl .L5                      /* jlt .L5 */
	movq $0, 2488(%rsp)         /* ldci vr11, $0 */
	movq 2488(%rsp), %r10       /* mov vr0, vr11 */
	movq %r10, 2400(%rsp)
	jmp .L8                     /* jmp .L8 */
.L9:
	movq $0, 2496(%rsp)         /* ldci vr12, $0 */
	movq 2496(%rsp), %r10       /* mov vr1, vr12 */
	movq %r10, 2408(%rsp)
	jmp .L10                    /* jmp .L10 */
.L11:
	leaq 1600(%rsp), %r10       /* localaddr vr13, $1600 */
	movq %r10, 2504(%rsp)
	movq 2512(%rsp), %rax       /* muli vr14, vr0, $80 */
	movq 2400(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2512(%rsp)
	movq 2520(%rsp), %rax       /* addi vr15, vr13, vr14 */
	movq 2504(%rsp), %rax
	addq 2512(%rsp), %rax
	movq %rax, 2520(%rsp)
	movq 2528(%rsp), %rax       /* muli vr16, vr1, $8 */
	movq 2408(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2528(%rsp)
	movq 2536(%rsp), %rax       /* addi vr17, vr15, vr16 */
	movq 2520(%rsp), %rax
	addq 2528(%rsp), %rax
	movq %rax, 2536(%rsp)
	movq $0, 2544(%rsp)         /* ldci vr18, $0 */
	movq 2536(%rsp), %r11       /* sti (vr17), vr18 */
	movq 2544(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 2440(%rsp)         /* ldci vr5, $1 */
	movq 2448(%rsp), %rax       /* addi vr6, vr1, vr5 */
	movq 2408(%rsp), %rax
	addq 2440(%rsp), %rax
	movq %rax, 2448(%rsp)
	movq 2448(%rsp), %r10       /* mov vr1, vr6 */
	movq %r10, 2408(%rsp)
.L10:
	movq $10, 2456(%rsp)        /* ldci vr7, $10 */
	movq 2408(%rsp), %r10       /* cmpi vr1, vr7 */
	cmpq 2456(%rsp), %r10
	jl .L11                     /* jlt .L11 */
	movq $1, 2464(%rsp)         /* ldci vr8, $1 */
	movq 2472(%rsp), %rax       /* addi vr9, vr0, vr8 */
	movq 2400(%rsp), %rax
	addq 2464(%rsp), %rax
	movq %rax, 2472(%rsp)
	movq 2472(%rsp), %r10       /* mov vr0, vr9 */
	movq %r10, 2400(%rsp)
.L8:
	movq $10, 2480(%rsp)        /* ldci vr10, $10 */
	movq 2400(%rsp), %r10       /* cmpi vr0, vr10 */
	cmpq 2480(%rsp), %r10
	jl .L9                      /* jlt .L9 */
	movq $0, 2488(%rsp)         /* ldci vr11, $0 */
	movq 2488(%rsp), %r10       /* mov vr2, vr11 */
	movq %r10, 2416(%rsp)
	jmp .L12                    /* jmp .L12 */
.L13:
	movq $0, 2496(%rsp)         /* ldci vr12, $0 */
	movq 2496(%rsp), %r10       /* mov vr0, vr12 */
	movq %r10, 2400(%rsp)
	jmp .L14                    /* jmp .L14 */
.L15:
	leaq 0(%rsp), %r10          /* localaddr vr13, $0 */
	movq %r10, 2504(%rsp)
	movq 2512(%rsp), %rax       /* muli vr14, vr0, $80 */
	movq 2400(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2512(%rsp)
	movq 2520(%rsp), %rax       /* addi vr15, vr13, vr14 */
	movq 2504(%rsp), %rax
	addq 2512(%rsp), %rax
	movq %rax, 2520(%rsp)
	movq 2528(%rsp), %rax       /* muli vr16, vr2, $8 */
	movq 2416(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2528(%rsp)
	movq 2536(%rsp), %rax       /* addi vr17, vr15, vr16 */
	movq 2520(%rsp), %rax
	addq 2528(%rsp), %rax
	movq %rax, 2536(%rsp)
	movq 2536(%rsp), %r10       /* ldi vr3, (vr17) */
	movq (%r10), %r10
	movq %r10, 2424(%rsp)
	movq $0, 2544(%rsp)         /* ldci vr18, $0 */
	movq 2544(%rsp), %r10       /* mov vr1, vr18 */
	movq %r10, 2408(%rsp)
	jmp .L16                    /* jmp .L16 */
.L17:
	leaq 1600(%rsp), %r10       /* localaddr vr19, $1600 */
	movq %r10, 2552(%rsp)
	movq 2560(%rsp), %rax       /* muli vr20, vr0, $80 */
	movq 2400(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2560(%rsp)
	movq 2568(%rsp), %rax       /* addi vr21, vr19, vr20 */
	movq 2552(%rsp), %rax
	addq 2560(%rsp), %rax
	movq %rax, 2568(%rsp)
	movq 2576(%rsp), %rax       /* muli vr22, vr1, $8 */
	movq 2408(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2576(%rsp)
	movq 2584(%rsp), %rax       /* addi vr23, vr21, vr22 */
	movq 2568(%rsp), %rax
	addq 2576(%rsp), %rax
	movq %rax, 2584(%rsp)
	movq 2584(%rsp), %r10       /* ldi vr4, (vr23) */
	movq (%r10), %r10
	movq %r10, 2432(%rsp)
	leaq 800(%rsp), %r10        /* localaddr vr24, $800 */
	movq %r10, 2592(%rsp)
	movq 2600(%rsp), %rax       /* muli vr25, vr2, $80 */
	movq 2416(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2600(%rsp)
	movq 2608(%rsp), %rax       /* addi vr26, vr24, vr25 */
	movq 2592(%rsp), %rax
	addq 2600(%rsp), %rax
	movq %rax, 2608(%rsp)
	movq 2616(%rsp), %rax       /* muli vr27, vr1, $8 */
	movq 2408(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2616(%rsp)
	movq 2624(%rsp), %rax       /* addi vr28, vr26, vr27 */
	movq 2608(%rsp), %rax
	addq 2616(%rsp), %rax
	movq %rax, 2624(%rsp)
	movq 2624(%rsp), %r10       /* ldi vr29, (vr28) */
	movq (%r10), %r10
	movq %r10, 2632(%rsp)
	movq 2640(%rsp), %rax       /* muli vr30, vr3, vr29 */
	movq 2424(%rsp), %rax
	imulq 2632(%rsp), %rax
	movq %rax, 2640(%rsp)
	movq 2648(%rsp), %rax       /* addi vr31, vr4, vr30 */
	movq 2432(%rsp), %rax
	addq 2640(%rsp), %rax
	movq %rax, 2648(%rsp)
	movq 2648(%rsp), %r10       /* mov vr4, vr31 */
	movq %r10, 2432(%rsp)
	leaq 1600(%rsp), %r10       /* localaddr vr32, $1600 */
	movq %r10, 2656(%rsp)
	movq 2664(%rsp), %rax       /* muli vr33, vr0, $80 */
	movq 2400(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2664(%rsp)
	movq 2672(%rsp), %rax       /* addi vr34, vr32, vr33 */
	movq 2656(%rsp), %rax
	addq 2664(%rsp), %rax
	movq %rax, 2672(%rsp)
	movq 2680(%rsp), %rax       /* muli vr35, vr1, $8 */
	movq 2408(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2680(%rsp)
	movq 2688(%rsp), %rax       /* addi vr36, vr34, vr35 */
	movq 2672(%rsp), %rax
	addq 2680(%rsp), %rax
	movq %rax, 2688(%rsp)
	movq 2688(%rsp), %r11       /* sti (vr36), vr4 */
	movq 2432(%rsp), %r10
	movq %r10, (%r11)
	movq $1, 2440(%rsp)         /* ldci vr5, $1 */
	movq 2448(%rsp), %rax       /* addi vr6, vr1, vr5 */
	movq 2408(%rsp), %rax
	addq 2440(%rsp), %rax
	movq %rax, 2448(%rsp)
	movq 2448(%rsp), %r10       /* mov vr1, vr6 */
	movq %r10, 2408(%rsp)
.L16:
	movq $10, 2456(%rsp)        /* ldci vr7, $10 */
	movq 2408(%rsp), %r10       /* cmpi vr1, vr7 */
	cmpq 2456(%rsp), %r10
	jl .L17                     /* jlt .L17 */
	movq $1, 2464(%rsp)         /* ldci vr8, $1 */
	movq 2472(%rsp), %rax       /* addi vr9, vr0, vr8 */
	movq 2400(%rsp), %rax
	addq 2464(%rsp), %rax
	movq %rax, 2472(%rsp)
	movq 2472(%rsp), %r10       /* mov vr0, vr9 */
	movq %r10, 2400(%rsp)
.L14:
	movq $10, 2480(%rsp)        /* ldci vr10, $10 */
	movq 2400(%rsp), %r10       /* cmpi vr0, vr10 */
	cmpq 2480(%rsp), %r10
	jl .L15                     /* jlt .L15 */
	movq $1, 2488(%rsp)         /* ldci vr11, $1 */
	movq 2496(%rsp), %rax       /* addi vr12, vr2, vr11 */
	movq 2416(%rsp), %rax
	addq 2488(%rsp), %rax
	movq %rax, 2496(%rsp)
	movq 2496(%rsp), %r10       /* mov vr2, vr12 */
	movq %r10, 2416(%rsp)
.L12:
	movq $10, 2504(%rsp)        /* ldci vr13, $10 */
	movq 2416(%rsp), %r10       /* cmpi vr2, vr13 */
	cmpq 2504(%rsp), %r10
	jl .L13                     /* jlt .L13 */
	movq $0, 2512(%rsp)         /* ldci vr14, $0 */
	movq 2512(%rsp), %r10       /* mov vr0, vr14 */
	movq %r10, 2400(%rsp)
	jmp .L18                    /* jmp .L18 */
.L19:
	movq $0, 2520(%rsp)         /* ldci vr15, $0 */
	movq 2520(%rsp), %r10       /* mov vr1, vr15 */
	movq %r10, 2408(%rsp)
	jmp .L20                    /* jmp .L20 */
.L21:
	leaq 1600(%rsp), %r10       /* localaddr vr16, $1600 */
	movq %r10, 2528(%rsp)
	movq 2536(%rsp), %rax       /* muli vr17, vr0, $80 */
	movq 2400(%rsp), %rax
	imulq $80, %rax
	movq %rax, 2536(%rsp)
	movq 2544(%rsp), %rax       /* addi vr18, vr16, vr17 */
	movq 2528(%rsp), %rax
	addq 2536(%rsp), %rax
	movq %rax, 2544(%rsp)
	movq 2552(%rsp), %rax       /* muli vr19, vr1, $8 */
	movq 2408(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2552(%rsp)
	movq 2560(%rsp), %rax       /* addi vr20, vr18, vr19 */
	movq 2544(%rsp), %rax
	addq 2552(%rsp), %rax
	movq %rax, 2560(%rsp)
	movq 2560(%rsp), %r10       /* ldi vr21, (vr20) */
	movq (%r10), %r10
	movq %r10, 2568(%rsp)
	movq 2568(%rsp), %rsi       /* writei vr21 */
	movq $s_writeint_fmt, %rdi
	call printf
	movq $1, 2440(%rsp)         /* ldci vr5, $1 */
	movq 2448(%rsp), %rax       /* addi vr6, vr1, vr5 */
	movq 2408(%rsp), %rax
	addq 2440(%rsp), %rax
	movq %rax, 2448(%rsp)
	movq 2448(%rsp), %r10       /* mov vr1, vr6 */
	movq %r10, 2408(%rsp)
.L20:
	movq $10, 2456(%rsp)        /* ldci vr7, $10 */
	movq 2408(%rsp), %r10       /* cmpi vr1, vr7 */
	cmpq 2456(%rsp), %r10
	jl .L21                     /* jlt .L21 */
	movq $1, 2464(%rsp)         /* ldci vr8, $1 */
	movq 2472(%rsp), %rax       /* addi vr9, vr0, vr8 */
	movq 2400(%rsp), %rax
	addq 2464(%rsp), %rax
	movq %rax, 2472(%rsp)
	movq 2472(%rsp), %r10       /* mov vr0, vr9 */
	movq %r10, 2400(%rsp)
.L18:
	movq $10, 2480(%rsp)        /* ldci vr10, $10 */
	movq 2400(%rsp), %r10       /* cmpi vr0, vr10 */
	cmpq 2480(%rsp), %r10
	jl .L19                     /* jlt .L19 */
	addq $2696, %rsp
	movl $0, %eax
	ret
