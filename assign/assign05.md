---
layout: default
title: "Assignment 5: Better code generation"
---

**Due**: Monday, Dec 6th by 11pm (you may submit as late as Friday, Dec 10th for full credit)

Points: This assignment is worth 150 points

# Overview

In this assignment, you will implement optimizations to improve the target code quality
compared to the code generator you implemented in [Assignment 4](assign04.html).

## Grading criteria

* Optimizations implemented: 40%
* Report:
    * General discussion of optimizations implemented: 25%
    * Analysis and experimental evaluation: 25%
* Design and coding style: 10%

# Getting started

Start with the code you wrote for [Assignment 4](assign04.html).  (I would recommend making a copy rather than directly modifying your original code, but it's up to you.)

The following source files are provided to implement a control flow graph representation for high level and target code:

* [cfg.h](assign05/cfg.h), [cfg.cpp](assign05/cfg.cpp): expanded to provide `BasicBlock`, `Edge`, `ControlFlowGraph`, `ControlFlowGraphBuilder`, and `ControlFlowGraphPrinter` types
* [highlevel.h](assign05/highlevel.h), [highlevel.cpp](assign05/highlevel.cpp): expanded to provide concrete `HighLevelControlFlowGraphBuilder` and `HighLevelControlFlowGraphPrinter` types
* [x86\_64.h](assign05/x86_64.h), [x86\_64.cpp](assign05/x86_64.cpp): expanded to provide `X86_64ControlFlowGraphBuilder` and `X86_64ControlFlowGraphPrinter` types

# Your task

## Adding an optimization flag

Your compiler should support a `-o` command line option.  When present, it indicates that the compiler should perform code optimization before emitting target assembly language.

For example, the invocation

```
./compiler -o input/array20.in
```

would generate optimized code for the source program `input/array20.in`, while the invocation

```
./compiler input/array20.in
```

would generate unoptimized code.

## Implementing optimizations

The primary metric you should be optimizing for is the run-time efficiency of the generated assembly code.

Optimizing for (smaller) code size is also valid, but should be considered a secondary concern.

Two benchmark programs are provided (in the [assign05/input](https://github.com/jhucompilers/fall2021-tests/tree/master/assign05/input) subdirectory of the [test repository](https://github.com/jhucompilers/fall2021-tests)):

* [array20.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/array20.in) multiplies 500x500 matrices represented as 250,000 element 1-D arrays
* [multidim20.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/multidim20.in) multiplies 500x500 matrices represented as 500x500 2-D arrays (only if you have implemented multidimensional arrays)

You can benchmark your compiler as follows (user input in bold):

<div class="highlighter-rouge"><pre>
$ <b>./build.rb array20</b>
Generated code successfully assembled, output exe is out/array20
$ <b>time ./out/array20 &lt; data/array20.in &gt; actual&#95;output/array20.out </b>

real	0m3.076s
user	0m3.060s
sys	0m0.016s
$ <b>diff expected_output/array20.out actual_output/array20.out</b>
</pre></div>

Your can substitute other test program names in place of `array20`.

If the `diff` command does not produce any output, then the program's output matched the expected output.

The `build.rb` puts the generated assembly language code in the `out` directory, so in the above test case, the assembly code would be in `out/array20.S`.

The **user** time in the output of the `time` command represents the amount of time the test program spent using the CPU to execute code, and so is a good measure of how long it took the compiled program to do its computation.  Your code optimizations should aim to reduce user time for the benchmark programs.

## Analysis and experiments

As you work on your optimizations, do experiments to see how effective they are at improving the efficiency of the generated code.

You can use any test programs as a basis for these experiments.  One approach is to start with some very simple test programs, and then work your way up to the benchmark programs (which are relatively complex.)

## Report

One of the most important deliverables of this assignment is a written report that describes what optimizations you implemented and how effective they were.

For each optimization technique you implemented, your report should document

* how the quality of the generated code was improved (include representative snippets of code before and after the optimization, for relevant test programs)
* how the efficiency of the generated code improved (i.e., how much did performance of the benchmark programs improve)

Your report should also discuss what inefficiencies remain in the generated code, and what optimization techniques might be helpful for addressing them.

# Hints and suggestions

In addition to the hints and suggestions included below, there is a [detailed advice document](assign05-advice.html) which has some fairly detailed suggestions for how to approach this assignment.

## Ideas for optmizations to implement

Some ideas for code optimizations:

* Use machine registers for (at least some) local variables, especially loop variables
* Allocate machine registers for virtual registers
* Peephole optimization of the high-level code to eliminate redundancies and reduce the number of virtual registers needed
* Peephole optimization of the generated x86-64 assembly code to eliminate redundancies

The recommended way to approach the implementation of optimizations is to look at the high-level and low-level code generated by your compiler, and look for specific inefficiencies that you can eliminate.

We *highly* recommend that you keep notes about your work, so that you have a written record you can refer to in preparing your report.

## Intermediate representations

You can implement your optimization passes as transformations of `InstructionSequence` (linear IR) or `ControlFlowGraph` (control flow graph IR).  We recommend that you implement transformations constructively: for example, if transforming a `ControlFlowGraph`, the result of the transformation should be a different `ControlFlowGraph`, rather than an in-place modification of the original `ControlFlowGraph`.

If you do transformations of an `InstructionSequence`, you will need to take control flow into account.  Any instruction that either

* is a branch, or
* has an immediate successor that is a labeled control-flow target

should be considered the end of a basic block.

If you decide to use the `ControlFlowGraph` intermediate representation, you can create it from an `InstructionSequence` as follows.  For high-level code:

```cpp
InstructionSequence iseq = /* InstructionSequence containing high-level code... */
HighLevelControlFlowGraphBuilder cfg_builder(iseq);
ControlFlowGraph *cfg = cfg_builder.build();    
```

For low-level (x86-64) code:

```cpp
InstructionSequence *ll_iseq = /* InstructionSequence containing low-level code... */
X86_64ControlFlowGraphBuilder xcfg_builder(ll_iseq);
ControlFlowGraph *xcfg = xcfg_builder.build();
```

To convert a `ControlFlowGraph` back to an `InstructionSequence`:

```cpp
ControlFlowGraph *cfg = /* a ControlFlowGraph */
InstructionSequence *result_iseq = cfg->create_instruction_sequence();
```

Note that the `create_instruction_sequence()` method is not guaranteed to work if the structure of the `ControlFlowGraph` was modified.  I.e., we do not recommend implementing optimizations which change control flow.  Local optimizations (within single basic blocks) are recommended.

## Framework for optimizations

The [cfg\_transform.h](assign05/cfg_transform.h) and [cfg\_transform.cpp](assign05/cfg_transform.cpp) source files demonstrate how to transform a `ControlFlowGraph` by transforming each basic block.  The idea is to override the `transform_basic_block` member function.  In general, this class should be useful for implementing any local (basic block level) optimization.

## Live variables analysis

The [live\_vregs.h](assign05/live_vregs.h) and [live\_vregs.cpp](assign05/live_vregs.cpp) source files implement [global live variables analysis](../lectures/Global_Optimization_Live_Analysis.pdf) for virtual registers.  You may find this useful for determining which instructions are safe to eliminate after local optimizations are applied.  Note that you will need to add the following member functions to the `InstructionSequence` class:

```
const_reverse_iterator crbegin() const { return m_instr_seq.crbegin(); }
const_reverse_iterator crend() const { return m_instr_seq.crend(); }
```

This code also assumes the existence of `HighLevel::is_def` and `HighLevel::is_use` functions, which determine (respectively)

* whether an instruction is a def (assignment to a virtual register), and
* whether an operand of an instruction is a use of a virtual register

If you would like to be able to print a control flow graph annotated with live virtual registers (after each instruction), you can use the following "improved" versions:

* [live\_vregs.h](assign05/r/live_vregs.h)
* [live\_vregs.cpp](assign05/r/live_vregs.cpp)

The `LiveVregsControlFlowGraphPrinter` class is a version of `PrintHighLevelControlFlowGraph` that prints the live virtual register sets.

Note that `LiveVregsControlFlowGraphPrinter` assumes that

* `HighLevelControlFlowGraphBuilder` has a virtual `format_instruction` member function which can be overridden, and that its `print_basic_block` member function calls `format_instruction`

You will likely need to make some code changes to allow `LiveVregsControlFlowGraphPrinter` to work.  Here are possible implementations of `print_basic_block` and `format_instruction` for the `HighLevelControlFlowGraphBuilder` class:

```cpp
void HighLevelControlFlowGraphPrinter::print_basic_block(BasicBlock *bb) {
  for (auto i = bb->cbegin(); i != bb->cend(); i++) {
    Instruction *ins = *i;
    std::string s = format_instruction(bb, ins);
    printf("\t%s\n", s.c_str());
  }
}

std::string HighLevelControlFlowGraphPrinter::format_instruction(BasicBlock *bb,
                                                                 Instruction *ins) {
  PrintHighLevelInstructionSequence p;
  return p.format_instruction(ins);
}
```

## Generated code examples

Here are some examples of generated code after optimizations are applied.  The optimized code is better than the unoptimized, but many opportunities for improvements remain.

Source | Unopt high-level | Unopt x86-64 | Opt high-level | Opt x86-64
------ | ---------------- | ------------ | -------------- | ----------
[loop01.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/loop01.in) | [loop01-unopt.txt](assign05/ex/loop01-unopt.txt) | [loop01-unopt.S](assign05/ex/loop01-unopt.S) | [loop01-opt.txt](assign05/ex/loop01-opt.txt) | [loop01-opt.S](assign05/ex/loop01-opt.S)
[loop02.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/loop02.in) | [loop02-unopt.txt](assign05/ex/loop02-unopt.txt) | [loop02-unopt.S](assign05/ex/loop02-unopt.S) | [loop02-opt.txt](assign05/ex/loop02-opt.txt) | [loop02-opt.S](assign05/ex/loop02-opt.S)
[loop03.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/loop03.in) | [loop03-unopt.txt](assign05/ex/loop03-unopt.txt) | [loop03-unopt.S](assign05/ex/loop03-unopt.S) | [loop03-opt.txt](assign05/ex/loop03-opt.txt) | [loop03-opt.S](assign05/ex/loop03-opt.S)
[loop04.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/loop04.in) | [loop04-unopt.txt](assign05/ex/loop04-unopt.txt) | [loop04-unopt.S](assign05/ex/loop04-unopt.S) | [loop04-opt.txt](assign05/ex/loop04-opt.txt) | [loop04-opt.S](assign05/ex/loop04-opt.S)
[array10.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/array10.in) | [array10-unopt.txt](assign05/ex/array10-unopt.txt) | [array10-unopt.S](assign05/ex/array10-unopt.S) | [array10-opt.txt](assign05/ex/array10-opt.txt) | [array10-opt.S](assign05/ex/array10-opt.S)
[array20.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/array20.in) | [array20-unopt.txt](assign05/ex/array20-unopt.txt) | [array20-unopt.S](assign05/ex/array20-unopt.S) | [array20-opt.txt](assign05/ex/array20-opt.txt) | [array20-opt.S](assign05/ex/array20-opt.S)
[multidim10.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/multidim10.in) | [multidim10-unopt.txt](assign05/ex/multidim10-unopt.txt) | [multidim10-unopt.S](assign05/ex/multidim10-unopt.S) | [multidim10-opt.txt](assign05/ex/multidim10-opt.txt) | [multidim10-opt.S](assign05/ex/multidim10-opt.S)
[multidim20.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/multidim20.in) | [multidim20-unopt.txt](assign05/ex/multidim20-unopt.txt) | [multidim20-unopt.S](assign05/ex/multidim20-unopt.S) | [multidim20-opt.txt](assign05/ex/multidim20-opt.txt) | [multidim20-opt.S](assign05/ex/multidim20-opt.S)

Here is one data point comparing the performance of the optimized code compared to unoptimized, for the [array20.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign05/input/array20.in) test program, reporting the `user` time on the average of 3 test runs:

Unoptimized time | Optimized time | Optimized time (no reg alloc)
:--------------: | :------------: | :---------------------------:
1.657s           | 0.313s         | 0.894s

Times are on Linux, using a Core i7-4771 processor.

This is a nice speedup, but it's worth noting that the quality of the unoptimized code is not great.

Interestingly, there is a reasonably substantial speedup from just removing redundant operations, without doing general-purpose register allocation for virtual registers. (The optimization to place scalar loop variables in callee-saved registers *is* applied.)

# Submitting

To submit, create a zipfile containing

* all of the files needed to compile your program, and
* a PDF of your report in a file called `report.pdf`

Suggested commands:

```bash
make clean
zip -9r solution.zip Makefile *.h *.c *.y *.l *.cpp *.rb report.pdf
```

The suggested command would create a zipfile called `solution.zip`.  Note that if your solution uses C exclusively, you can omit `*.cpp` from the filename patterns.  If you used the `scan_grammar_symbols.rb` script, then make sure you include the `*.rb` pattern as shown above.

Make sure that your report is a PDF file called `report.pdf`.

Upload your submission to [Gradescope](https://www.gradescope.com) as **Assignment 5**.
