/* 7 vregs with storage allocated */
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
	pushq %r14
	pushq %r15
	subq $64, %rsp
	movq $1, %r14               /* mov vr1, $1 */
	movq $0, %r15               /* mov vr2, $0 */
	jmp .L9                     /* jmp .L9 */
.L1:
	movq $s_readint_fmt, %rdi   /* readi vr5 */
	movq $s_readbuf, %rsi
	call scanf
	movq s_readbuf, %rcx
	movq %rcx, %r13             /* mov vr0, vr5 */
	cmpq $0, %rcx               /* cmpi vr5, $0 */
	jge .L2                     /* jgte .L2 */
	movq $0, %r14               /* mov vr1, $0 */
	jmp .L9                     /* jmp .L9 */
.L2:
	cmpq $50, %r13              /* cmpi vr0, $50 */
	jl .L4                      /* jlt .L4 */
	movq %r13, %rax             /* modi vr7, vr0, $2 */
	cqto 
	movq $2, %r10
	idivq %r10
	movq %rdx, %rcx
	cmpq $0, %rcx               /* cmpi vr7, $0 */
	jne .L6                     /* jne .L6 */
	movq %r15, %rcx             /* addi vr10, vr2, $1 */
	addq $1, %rcx
	movq %rcx, %r15             /* mov vr2, vr10 */
	jmp .L7                     /* jmp .L7 */
.L4:
	movq %r13, %rax             /* modi vr14, vr0, $2 */
	cqto 
	movq $2, %r10
	idivq %r10
	movq %rdx, %rcx
	cmpq $0, %rcx               /* cmpi vr14, $0 */
	jne .L8                     /* jne .L8 */
	movq %r15, %rcx             /* addi vr17, vr2, $10000 */
	addq $10000, %rcx
	movq %rcx, %r15             /* mov vr2, vr17 */
	jmp .L9                     /* jmp .L9 */
.L6:
	movq %r15, %rcx             /* addi vr12, vr2, $100 */
	addq $100, %rcx
	movq %rcx, %r15             /* mov vr2, vr12 */
.L7:
	jmp .L9                     /* jmp .L9 */
.L8:
	movq %r15, %rcx             /* addi vr19, vr2, $1000000 */
	addq $1000000, %rcx
	movq %rcx, %r15             /* mov vr2, vr19 */
.L9:
	cmpq $0, %r14               /* cmpi vr1, $0 */
	jne .L1                     /* jne .L1 */
	movq %r15, %rsi             /* writei vr2 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $64, %rsp
	popq %r15
	popq %r14
	popq %r13
	movl $0, %eax
	ret
