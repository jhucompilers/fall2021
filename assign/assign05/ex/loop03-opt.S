/* 3 vregs with storage allocated */
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
	pushq %r15
	subq $24, %rsp
	movq $s_readint_fmt, %rdi   /* readi vr2 */
	movq $s_readbuf, %rsi
	call scanf
	movq s_readbuf, %rcx
	movq %rcx, %r14             /* mov vr0, vr2 */
	movq $0, %r15               /* mov vr1, $0 */
	jmp .L0                     /* jmp .L0 */
.L1:
	movq %r14, %rax             /* divi vr4, vr0, $2 */
	cqto 
	movq $2, %r10
	idivq %r10
	movq %rax, %rcx
	movq %rcx, %r14             /* mov vr0, vr4 */
	movq %r15, %r8              /* addi vr6, vr1, $1 */
	addq $1, %r8
	movq %r8, %r15              /* mov vr1, vr6 */
.L0:
	cmpq $1, %r14               /* cmpi vr0, $1 */
	jg .L1                      /* jgt .L1 */
	movq %r15, %rsi             /* writei vr1 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $24, %rsp
	popq %r15
	popq %r14
	movl $0, %eax
	ret
