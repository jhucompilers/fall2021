---
layout: default
title: "Assignment 5: Detailed advice"
---

# Detailed code optimization advice

This document has some detailed advice for implementing code optimization
in your compiler.

## General advice, testing

Keep a log of your work!  Not only will this be helpful for writing your
report, it will also be a good way to document and understand how different
analysis and optimization techniques interact with each other.

Add a -o compiler option that will enable optimization.  So, the invocation

    ./compiler input/loop10.in

should generate unoptimized assembly code, and the invocation

    ./compiler -o input/loop10.in

should generate optimized code. (This is actually a requirement of the
assignment, but it's something you should implement right away, since it will
help you keep your code optimization implementation cleanly separated from
your basic code generation implementation.)

Test frequently.  The run\_test.rb and run\_all.rb scripts in the assign05
directory of the test repo can take an option argument, which will in turn
be passed to the compiler executable's main function.  So, you can use

    ./run_all.rb -o

to test that your compiler produces correct code for all of the tests, and
use

    ./run_all.rb

to test that generating unoptimized code still works correctly.

Structure your development progress into units of progress that are as
small as possible.

## IR, storage allocation

Delay storage allocation until as late as possible.

Represent scalar local variables symbolically.  For example, just use
virtual registers to represent them in the high-level IR.
(Hopefully you did this in [Assignment 4](assign04.html)!)

If the initial version of your code generator allocates memory for
virtual registers, this is great.  This provides a fall back for
virtual registers that cannot be assigned a machine register.

Assume that arrays and records are stored in memory.  It is a good idea
to compute storage requirements (offsets and sizes) for these relatively
early, and to emit address computations in the initial high level code.
Only scalar variables should be candidates for register allocation.

A pass over the AST can identify scalar loop variables.  These are
candidates for being allocated/assigned to callee-saved registers
(%rbx, %r12, %r13, etc.)  You can implement a mechanism to tell the
x86-64 assembly code generator that the virtual register for the
selected loop variables should be generated directly as the appropriate
machine register operand.  Note that the generated code uses any
callee-saved regsiters, they will need to be saved and restored as part
of your prologue and epilogue code.  (Use pushq and popq to save and
restore each one.)  Note that each register that is pushed decreases
%rsp by 8, and thus affects stack alignment.

## High-level peephole optimization

Have an easy to use and robust API for determining which virtual registers
(if any are) defined and/or used by each instruction.

Do transformations constructively rather than destructively.  For example,
a peephole analysis transforms an InstructionSequence (i.e., a BasicBlock)
into a computed InstructionSequence.  A new ControlFlowGraph is constructed
as the result of applying one or more block-level transformations on
the blocks of the original ControlFlowGraph.

Transformations which remove redundancies can result in definitions of
virtual registers which are immediately dead.  For example:

* a constant was assigned to a virtual register
* a constant propagation phase copied the constant into the instruction
  where the virtual register was used
* if there were no other uses of the virtual register, it is now
  dead, and the instruction that loaded the constant into it is
  now redundant

Instructions which are defs of virtual registers that are immediately dead
can simply be eliminated.

A global "live virtual registers" analysis can be very useful in knowing when
it is safe to remove such instructions.

NOTE: It is very likely that virtual registers allocated dynamically in
generating code for expressions and index computations will *never*
be live at the end of any basic block.  (If you use the idea of representing
scalar local variables as virtual registers, then these typically
*will* be alive at the end of at least some basic blocks, forming an
important exception to this observation.)  You could *potentially* use this
assumption (if it is true!) to simplify the peephole transformations.
However, a true global live virtual registers analysis is fairly
straightforward to implement, and is far more robust.  As a general policy,
it's best for the compiler to use robust analysis techniques and make
conservative assumptions, rather than making use of "fragile" knowledge that
could be invalidated by changes to how code is generated.

## Target code generation

The target (x86-64) code generator should work for both unoptimized and
optimized code generation.  I.e., don't create two separate target code
generators.  You may need to relax assumptions that you originally made when
implementing your "naive" code generation strategy, but you should find that
you will need only a small number of changes to emit more optimized code.
For example, the target code generator could be updated with additional
logic to handle the case where a callee-saved register has been assigned
as the storage for a local variable.

## Register allocation

Do local register allocation, i.e., within the scope of single basic blocks.
Do the register allocation on the high-level code, perhaps by marking
(in each instruction) which virtual registers should have a machine
register allocated, and which machine register was assigned.

You will need to modify the high-level IR to explicitly represent spill
and restore operations.

The register allocator will need to interact with the allocation of memory
storage, to ensure that space is available to store spilled registers.
For each basic block, compute the amount of spill storage needed, and
the maximum over all basic blocks is the overall amount needed.

As with high-level peephole optimization, the live virtual registers
analysis will be useful in order to know which virtual registers are live
at the end of the basic block.  If a virtual register has been allocated
to a machine register, and it is live at the end of the basic block,
then its value may need to be stored to memory so that it can be loaded
at the beginning of other blocks where it is used.  One simplification
that might be useful is to simply avoid allocating a machine register
to any virtual register that is live at the end of the basic block.

## Low-level peephole optimization

It is very likely that there will be opportunities for eliminating redundancies
in the generated target code.  Additional peephole optimization passes on the
target code could be very useful.
