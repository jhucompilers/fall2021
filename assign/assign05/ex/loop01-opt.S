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
	pushq %r15
	pushq %r13
	pushq %r14
	subq $32, %rsp
	movq $s_readint_fmt, %rdi   /* readi vr3 */
	movq $s_readbuf, %rsi
	call scanf
	movq s_readbuf, %rcx
	movq %rcx, %r14             /* mov vr2, vr3 */
	movq $1, %r15               /* mov vr0, $1 */
	movq $0, %r13               /* mov vr1, $0 */
	jmp .L0                     /* jmp .L0 */
.L1:
	movq %r13, %rcx             /* addi vr5, vr1, vr0 */
	addq %r15, %rcx
	movq %rcx, %r13             /* mov vr1, vr5 */
	movq %r15, %r8              /* addi vr7, vr0, $1 */
	addq $1, %r8
	movq %r8, %r15              /* mov vr0, vr7 */
.L0:
	cmpq %r14, %r15             /* cmpi vr0, vr2 */
	jle .L1                     /* jlte .L1 */
	movq %r13, %rsi             /* writei vr1 */
	movq $s_writeint_fmt, %rdi
	call printf
	addq $32, %rsp
	popq %r14
	popq %r13
	popq %r15
	movl $0, %eax
	ret
