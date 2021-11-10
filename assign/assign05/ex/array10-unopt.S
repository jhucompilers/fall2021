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
	subq $2728, %rsp
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
	movq $10, 2464(%rsp)        /* ldci vr8, $10 */
	movq 2472(%rsp), %rax       /* muli vr9, vr0, vr8 */
	movq 2400(%rsp), %rax
	imulq 2464(%rsp), %rax
	movq %rax, 2472(%rsp)
	movq 2480(%rsp), %rax       /* addi vr10, vr9, vr1 */
	movq 2472(%rsp), %rax
	addq 2408(%rsp), %rax
	movq %rax, 2480(%rsp)
	movq 2488(%rsp), %rax       /* muli vr11, vr10, $8 */
	movq 2480(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2488(%rsp)
	movq 2496(%rsp), %rax       /* addi vr12, vr7, vr11 */
	movq 2456(%rsp), %rax
	addq 2488(%rsp), %rax
	movq %rax, 2496(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr13 */
	leaq 2504(%rsp), %rsi
	call scanf
	movq 2496(%rsp), %r11       /* sti (vr12), vr13 */
	movq 2504(%rsp), %r10
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
	movq $10, 2512(%rsp)        /* ldci vr14, $10 */
	movq 2520(%rsp), %rax       /* muli vr15, vr0, vr14 */
	movq 2400(%rsp), %rax
	imulq 2512(%rsp), %rax
	movq %rax, 2520(%rsp)
	movq 2528(%rsp), %rax       /* addi vr16, vr15, vr1 */
	movq 2520(%rsp), %rax
	addq 2408(%rsp), %rax
	movq %rax, 2528(%rsp)
	movq 2536(%rsp), %rax       /* muli vr17, vr16, $8 */
	movq 2528(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2536(%rsp)
	movq 2544(%rsp), %rax       /* addi vr18, vr13, vr17 */
	movq 2504(%rsp), %rax
	addq 2536(%rsp), %rax
	movq %rax, 2544(%rsp)
	movq $s_readint_fmt, %rdi   /* readi vr19 */
	leaq 2552(%rsp), %rsi
	call scanf
	movq 2544(%rsp), %r11       /* sti (vr18), vr19 */
	movq 2552(%rsp), %r10
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
	movq $10, 2512(%rsp)        /* ldci vr14, $10 */
	movq 2520(%rsp), %rax       /* muli vr15, vr0, vr14 */
	movq 2400(%rsp), %rax
	imulq 2512(%rsp), %rax
	movq %rax, 2520(%rsp)
	movq 2528(%rsp), %rax       /* addi vr16, vr15, vr1 */
	movq 2520(%rsp), %rax
	addq 2408(%rsp), %rax
	movq %rax, 2528(%rsp)
	movq 2536(%rsp), %rax       /* muli vr17, vr16, $8 */
	movq 2528(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2536(%rsp)
	movq 2544(%rsp), %rax       /* addi vr18, vr13, vr17 */
	movq 2504(%rsp), %rax
	addq 2536(%rsp), %rax
	movq %rax, 2544(%rsp)
	movq $0, 2552(%rsp)         /* ldci vr19, $0 */
	movq 2544(%rsp), %r11       /* sti (vr18), vr19 */
	movq 2552(%rsp), %r10
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
	movq $10, 2512(%rsp)        /* ldci vr14, $10 */
	movq 2520(%rsp), %rax       /* muli vr15, vr0, vr14 */
	movq 2400(%rsp), %rax
	imulq 2512(%rsp), %rax
	movq %rax, 2520(%rsp)
	movq 2528(%rsp), %rax       /* addi vr16, vr15, vr2 */
	movq 2520(%rsp), %rax
	addq 2416(%rsp), %rax
	movq %rax, 2528(%rsp)
	movq 2536(%rsp), %rax       /* muli vr17, vr16, $8 */
	movq 2528(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2536(%rsp)
	movq 2544(%rsp), %rax       /* addi vr18, vr13, vr17 */
	movq 2504(%rsp), %rax
	addq 2536(%rsp), %rax
	movq %rax, 2544(%rsp)
	movq 2544(%rsp), %r10       /* ldi vr3, (vr18) */
	movq (%r10), %r10
	movq %r10, 2424(%rsp)
	movq $0, 2552(%rsp)         /* ldci vr19, $0 */
	movq 2552(%rsp), %r10       /* mov vr1, vr19 */
	movq %r10, 2408(%rsp)
	jmp .L16                    /* jmp .L16 */
.L17:
	leaq 1600(%rsp), %r10       /* localaddr vr20, $1600 */
	movq %r10, 2560(%rsp)
	movq $10, 2568(%rsp)        /* ldci vr21, $10 */
	movq 2576(%rsp), %rax       /* muli vr22, vr0, vr21 */
	movq 2400(%rsp), %rax
	imulq 2568(%rsp), %rax
	movq %rax, 2576(%rsp)
	movq 2584(%rsp), %rax       /* addi vr23, vr22, vr1 */
	movq 2576(%rsp), %rax
	addq 2408(%rsp), %rax
	movq %rax, 2584(%rsp)
	movq 2592(%rsp), %rax       /* muli vr24, vr23, $8 */
	movq 2584(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2592(%rsp)
	movq 2600(%rsp), %rax       /* addi vr25, vr20, vr24 */
	movq 2560(%rsp), %rax
	addq 2592(%rsp), %rax
	movq %rax, 2600(%rsp)
	movq 2600(%rsp), %r10       /* ldi vr4, (vr25) */
	movq (%r10), %r10
	movq %r10, 2432(%rsp)
	leaq 800(%rsp), %r10        /* localaddr vr26, $800 */
	movq %r10, 2608(%rsp)
	movq $10, 2616(%rsp)        /* ldci vr27, $10 */
	movq 2624(%rsp), %rax       /* muli vr28, vr2, vr27 */
	movq 2416(%rsp), %rax
	imulq 2616(%rsp), %rax
	movq %rax, 2624(%rsp)
	movq 2632(%rsp), %rax       /* addi vr29, vr28, vr1 */
	movq 2624(%rsp), %rax
	addq 2408(%rsp), %rax
	movq %rax, 2632(%rsp)
	movq 2640(%rsp), %rax       /* muli vr30, vr29, $8 */
	movq 2632(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2640(%rsp)
	movq 2648(%rsp), %rax       /* addi vr31, vr26, vr30 */
	movq 2608(%rsp), %rax
	addq 2640(%rsp), %rax
	movq %rax, 2648(%rsp)
	movq 2648(%rsp), %r10       /* ldi vr32, (vr31) */
	movq (%r10), %r10
	movq %r10, 2656(%rsp)
	movq 2664(%rsp), %rax       /* muli vr33, vr3, vr32 */
	movq 2424(%rsp), %rax
	imulq 2656(%rsp), %rax
	movq %rax, 2664(%rsp)
	movq 2672(%rsp), %rax       /* addi vr34, vr4, vr33 */
	movq 2432(%rsp), %rax
	addq 2664(%rsp), %rax
	movq %rax, 2672(%rsp)
	movq 2672(%rsp), %r10       /* mov vr4, vr34 */
	movq %r10, 2432(%rsp)
	leaq 1600(%rsp), %r10       /* localaddr vr35, $1600 */
	movq %r10, 2680(%rsp)
	movq $10, 2688(%rsp)        /* ldci vr36, $10 */
	movq 2696(%rsp), %rax       /* muli vr37, vr0, vr36 */
	movq 2400(%rsp), %rax
	imulq 2688(%rsp), %rax
	movq %rax, 2696(%rsp)
	movq 2704(%rsp), %rax       /* addi vr38, vr37, vr1 */
	movq 2696(%rsp), %rax
	addq 2408(%rsp), %rax
	movq %rax, 2704(%rsp)
	movq 2712(%rsp), %rax       /* muli vr39, vr38, $8 */
	movq 2704(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2712(%rsp)
	movq 2720(%rsp), %rax       /* addi vr40, vr35, vr39 */
	movq 2680(%rsp), %rax
	addq 2712(%rsp), %rax
	movq %rax, 2720(%rsp)
	movq 2720(%rsp), %r11       /* sti (vr40), vr4 */
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
	movq $10, 2536(%rsp)        /* ldci vr17, $10 */
	movq 2544(%rsp), %rax       /* muli vr18, vr0, vr17 */
	movq 2400(%rsp), %rax
	imulq 2536(%rsp), %rax
	movq %rax, 2544(%rsp)
	movq 2552(%rsp), %rax       /* addi vr19, vr18, vr1 */
	movq 2544(%rsp), %rax
	addq 2408(%rsp), %rax
	movq %rax, 2552(%rsp)
	movq 2560(%rsp), %rax       /* muli vr20, vr19, $8 */
	movq 2552(%rsp), %rax
	imulq $8, %rax
	movq %rax, 2560(%rsp)
	movq 2568(%rsp), %rax       /* addi vr21, vr16, vr20 */
	movq 2528(%rsp), %rax
	addq 2560(%rsp), %rax
	movq %rax, 2568(%rsp)
	movq 2568(%rsp), %r10       /* ldi vr22, (vr21) */
	movq (%r10), %r10
	movq %r10, 2576(%rsp)
	movq 2576(%rsp), %rsi       /* writei vr22 */
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
	addq $2728, %rsp
	movl $0, %eax
	ret
