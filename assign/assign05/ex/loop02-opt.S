/* 1 vregs with storage allocated */
	.section .rodata
s_readint_fmt: .string "%ld"
s_writeint_fmt: .string "%ld\n"
	.section .bss
	.align 8
s_readbuf: .space 8
	.section .text
	.globl main
main:
	pushq %r15
	subq $16, %rsp
	movq $0, %r15               /* mov vr0, $0 */
.L0:
	movq %r15, %rcx             /* addi vr3, vr0, $1 */
	addq $1, %rcx
	movq %rcx, %r15             /* mov vr0, vr3 */
	pushq %rcx                  /* writei vr3 */
	subq $8, %rsp
	movq %rcx, %rsi
	movq $s_writeint_fmt, %rdi
	call printf
	addq $8, %rsp
	popq %rcx
	cmpq $10, %rcx              /* cmpi vr3, $10 */
	jne .L0                     /* jne .L0 */
	addq $16, %rsp
	popq %r15
	movl $0, %eax
	ret
