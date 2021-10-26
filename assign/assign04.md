---
layout: default
title: "Assignment 4: Basic code generation"
---

**Due**: Friday, Nov 12th by 11pm

Points: This assignment is worth 200 points

# Overview

In this assignment, you will implement x86-64 assembly code generation
for the source language you wrote a front-end for in [Assignment
3](assign03.html).

The purpose of this assignment is not to generate *good* code.  The goal
is to generate *working* code, and create intermediate representations
that can be used as the basis of optimizations to improve the code
quality.

## Grading criteria

The grading criteria are as follows:

* Packaging: 5%
* Design and coding style: 10% (see expectations for [design, coding style, and efficiency](design.html))
* Functional requirements: 85%

For the part of the grade allocated to functional requirements, the
grading will be substantially weighted towards correct compilation of
programs involving only `INTEGER` variables and values (no arrays or
records.)  You should get this working correctly, including control flow
(`IF`, `ELSE`, `WHILE`, `REPEAT`) before tackling arrays and records.

Functional requirements:

* INTEGER variables, expressions, and scalar assignments, READ and WRITE: 40%
* Control flow (IF, IF/ELSE, WHILE, REPEAT): 15%
* One-dimensional arrays of INTEGER elements: 10%
* Record types with INTEGER fields: 10%
* Arrays of record elements: 5%
* Records with array fields: 5%

Semantics for CHAR variables are values are specified, but you are not
officially required to implement them.

# Getting started

Start with the code you wrote for [Assignment 3](assign03.html).
(I would recommend making a copy rather than directly modifying your
original code, but it's up to you.)

The following source files are provided as a reference for a "code-like"
intermediate representation:

* [cfg.h](assign04/cfg.h), [cfg.cpp](assign04/cfg.cpp) provide the
  `Operand`, `Instruction`, and `InstructionSequence` and classes, which
  implement a generic "code-like" intermediate representation
* [highlevel.h](assign04/highlevel.h),
  [highlevel.cpp](assign04/highlevel.cpp): these are an example of
  "high-level" opcodes that you might use as an initial translation target
* [x86\_64.h](assign04/x86_64.h), [x86\_64.cpp](assign04/x86_64.cpp):
  these implement x86-64 opcodes and machine registers

Note that the `PrintInstructionSequence` class in `cfg.h` and `cfg.cpp`
is able to print x86-64 assembly code in the formated expected
by the GNU assembler.  (Specifically, this is implemented by the
`PrintX86_64InstructionSequence` class.)

You are not required to use any of the above code, but you are welcome to use it.

# Language semantics

This section clarifies some of the runtime semantics that weren't
specified explicitly in [Assignment 3](assign03.html).  As with previous
assignments, the most important specification of expected behavior is the
[public test suite](#testing).

The `INTEGER` data type must be a signed integer type with at least 32
bits of precision.  For simplicity, we recommend that you make `INTEGER`
a 64 bit type.

A `READ` statement should work as follows:

* For reading into an `INTEGER` variable (or array element, or field),
  the compiled program should make a call to the `scanf` function to read
  a single integer value
* For reading into a `CHAR` variable (or array element, or field),
  the compiled program should make a call equivalent to
    ```c
    char ch;
    scanf(" %c", &ch);
    ```
  where `ch` will contain the single, non-space character read by `scanf`
* For reading into an array of `CHAR` elements, the compiled program
  should make a call equivalent to
    ```c
    scanf("%s", arr);
    ```
  where `arr` is the array into which the input is being read

A `WRITE` statement should work as follows:

* For writing an `INTEGER` value, the compiled program should print its
  decimal representation, followed by a single newline (`\n`) character;
  you should use `printf` to generate the output
* For writing a single `CHAR` value, the compiled program should make a call equivalent to
    ```c
    printf("%c\n", ch);
    ```
  where `ch` contains the character value to be printed
* For writing an array of `CHAR` values, the compiled program should make a call equivalent to
    ```c
    printf("%s\n", arr);
    ```
  where `arr` is the array being printed

Note that the behaviors for reading and writing `CHAR` arrays imply
that they operand on NUL-terminated character strings, i.e., the same
representation that C uses.

Array subscript references do not need to be bounds-checked.

# Recommendations and advice

This is a big task!  You will want to start early and make steady
incremental progress.  Try to get compilation of simple programs working
first, then move on to more complicated ones.

## Approach

We recommend that you follow the high-level compilation model suggested
by the textbook, which is to generate "high-level" (machine independent)
code from your source AST, and then translate this high-level code into
machine-specific target code (in our case, x86-64 assembly language.)

The high-level instruction types in `highlevel.h` and `highlevel.cpp`
are provided as an example, but you may want to define your own form of
high-level code.

## Storage model

By far the most important thing you will need to think about carefully
is how to allocate storage for variables, including arrays and records.

"Temporary" values, such as the result of evaluating an expression,
should be placed in a (freshly allocated) virtual register.

We recommend that you use the following approach for storage allocation
for variables:

* Local variables are assigned a virtual register as their storage location
* Array and record variables will need to be allocated storage in memory

Since you aren't required to implement a register allocator for this assignments,
you will probably use memory as storage for all virtual registers.  However,
the mapping of virtual registers to storage locations is a detail you can
leave to the low-level (x86-64) code generator.

Because accesses to array elements and record fields will require an address computation,
you will need to determine the storage requirements for each array and record
variable before high-level code generation.  We recommend the following approach:

1. Each array requires a number of bytes equal to the number of elements times the
   size required to store one element.
2. Each record variable requires a number of bytes equal to the sum of the
   sizes required to store each field.
3. For each record type, you should compute the offset of each field from the
   beginning of the record. For example, the first field will be at offset 0,
   the second field should have an offset equal to the size of the first field,
   and so forth.

Your high-level code generator should generate explicit high-level instructions to
do address computations for array elements and record fields.

In your code generator, it is a good idea to annotate AST nodes with a
representation of where their storage can be found.  One good way to
do this is to add a field of type `Operand` to the `Node` data type.
If an AST node represents a value in a virtual register, then the node's
`Operand` indicates which virtual register it is.  If an AST node
represents an assignable location (array element, or field
ref — the grammar refers to these as "designators"), the `Operand`
should be a memory reference.

You will probably want to add a feature to your semantic analyzer so that
it pre-computes storage sizes and offsets for all record and array variables
before the high-level code generator runs.

## Emitting instructions

Your code generators (both high level and low level) should build an `InstructionSequence` by adding `Instruction` objects to it.

For example, here is a possible implementation of a `visit_int_literal` method in an AST visitor to do high-level code generation:

```cpp
void HighLevelCodeGen::visit_int_literal(struct Node *ast) {
  long vreg = next_vreg();
  Operand destreg(OPERAND_VREG, vreg);
  Operand immval(OPERAND_INT_LITERAL, ast->get_ival());
  Instruction *ins = new Instruction(HINS_LOAD_ICONST, destreg, immval);
  m_iseq->add_instruction(ins);
  ast->set_operand(destreg);
}
```

## Control flow

The `InstructionSequence` class allows labels to be defined.  `Operand`
values can be be labels.  Control flow instructions, such as unconditional
and conditional jumps, should have a single `Operand` with the target
label.

As an example of how control flow can be implemented using labels,
here is an example of high-level code generation for an `IF` statement
(again, as part of an AST visitor class):

```cpp
void HighLevelCodeGen::visit_if(struct Node *ast) {
  std::string out_label = next_label();

  Node *cond = ast->get_kid(0);
  Node *iftrue = ast->get_kid(1);

  cond->set_inverted(true);
  cond->set_operand(Operand(out_label));

  visit(cond);
  visit(iftrue);
  m_iseq->define_label(out_label);
}
```

In the code above, the `next_label()` method generates a new control
flow label.  The statement consists of a condition (`cond`) and an "if
true" block (`iftrue`).  Only a single label is needed to mark the code
that follows the `IF` statement.  Note that the condition is compiled
using an "inverted" comparison, because we want a conditional jump to
transfer control to the `out_label` if the condition evaluates as false.

In general, the `define_label` method defines a label that marks the
next instruction that will be appended to the `InstructionSequence`
(using the `add_instruction` method.)

## Emitting low-level instructions

Each high-level instruction should generate one or more low-level (x86-64) instructions.


Assume that `hlins` is a reference to an `Instruction` object in the
high-level code. The translation of a `HINS_LOAD_ICONST` high-level
instruction might look like this:

```cpp
emit(new Instruction(MINS_MOVQ, hlins[1], vreg_ref(hlins[0])));
```

The assumption is that the high-level instruction has two operands,
`hlins[0]`, which is the destination virtual register, and `hlins[1]`,
which is the literal (immediate) value being stored in the destination
virtual register.

The `vreg_ref` method translates an `Operand` referring to a virtual
register ("vreg") into a low-level (x86-64) memory reference operand.
The low-level operand would take into account where the storage for
virtual registers is allocated in memory, as well as the offset of
the specific virtual register in the block of memory allocated for all
virtual registers.

`MINS_MOVQ` is a low-level opcode specifying the x86-64 `movq` instruction.

Here is a demo program which generates a complete x86-64 assembly language
program: [genhello.cpp](assign04/genhello.cpp)

The demo program needs to be linked against `cfg.o`, `x86_64.o`, and `cpputil.o`:

```
g++ -g -Wall -c genhello.cpp
g++ -g -Wall -c cfg.cpp
g++ -g -Wall -c x86_64.cpp
g++ -g -Wall -c cpputil.cpp
g++ -o genhello genhello.o cfg.o x86_64.o cpputil.o
```

You can assemble and run the generated program as follows:

```
./genhello > hello.S
gcc -g -no-pie -o hello hello.S
./hello
```

Comparing the code in `genhello.cpp` with the output in `hello.S` should
help give you a sense of how the data structure representation of x86-64
(using `Operand`, `Instruction`, and `InstructionSequence`) corresponds
to the generated assembly language code.

## Some example translations

Here are some translations of test programs:

Test program | High-level code | Generated x86-64 code
------------ | --------------- | ---------------------
[arith10](https://github.com/jhucompilers/fall2021-tests/blob/master/assign04/input/arith10.in) | [arith10.txt](assign04/arith10.txt) | [arith10.S](assign04/arith10.S)
[loop01](https://github.com/jhucompilers/fall2021-tests/blob/master/assign04/input/loop01.in) | [loop01.txt](assign04/loop01.txt) | [loop01.S](assign04/loop01.S)
[array01](https://github.com/jhucompilers/fall2021-tests/blob/master/assign04/input/array01.in) | [array01.txt](assign04/array01.txt) | [array01.S](assign04/array01.S)
[array02](https://github.com/jhucompilers/fall2021-tests/blob/master/assign04/input/array02.in) | [array02.txt](assign04/array02.txt) | [array02.S](assign04/array02.S)
[record10](https://github.com/jhucompilers/fall2021-tests/blob/master/assign04/input/record10.in) | [record10.txt](assign04/record10.txt) | [record10.S](assign04/record10.S)

Note that these translations are by no means the only possible
translations, or even "good" translations.  In fact, the generated
x86-64 code is pretty awful!  This is due to the simplistic storage model
being used.  In [Assignment 5](assign/assign05.html) we'll use techniques
such as register allocation and peephole optimization to generate better
assembly code.

## Testing

Tests can be found in the following repository:
<https://github.com/jhucompilers/fall2021-tests>, in the `assign04`
subdirectory.

Set the `ASSIGN04_DIR` environment variable to the name of the directory
containing your project.  For example, if your project is in the
`git/assign04` subdirectory of your home directory, use the command

```bash
export ASSIGN04_DIR=$HOME/git/assign04
```

To simply compile and assemble a program, use the `build.rb` script:

<div class="highlighter-rouge"><pre>
./build.rb <i>testname</i>
</pre></div>

For example, if you used `loop01` as *testname*, and compilation and
assembly were successful, the `out` directory will contain the files
`out/loop01.S` and `out/loop01`.  The latter is an executable which you
can test interactively, including running it in `gdb`.

To run a test:

<div class="highlighter-rouge"><pre>
./run&#95;test.rb <i>testname</i>
</pre></div>

where <i>testname</i> is one of the tests, e.g., <code>arith01.in</code>.

To run all of the tests:

<div class="highlighter-rouge"><pre>
./run&#95;all.rb
</pre></div>

As with previous assignments, we encourage you to contribute your
own tests to the repository.  See the [Testing section of Assignment
2](assign02.html#testing) for details regarding how to contribute
additional tests.

# Extra credit

For up to one point of extra credit, you can implement support for
multidimensional arrays.

# Submitting

To submit, create a zipfile containing all of the files needed to compile
your program.  Suggested commands:

```bash
make clean
zip -9r solution.zip Makefile *.h *.c *.y *.l *.cpp *.rb
```

The suggested command would create a zipfile called `solution.zip`.
Note that if your solution uses C exclusively, you can omit `*.cpp`
from the filename patterns.  If you used the `scan_grammar_symbols.rb`
script, them make sure you include the `*.rb` pattern as shown above.

Upload your submission to [Gradescope](https://www.gradescope.com)
as **Assignment 4**.
