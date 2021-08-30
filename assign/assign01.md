---
layout: default
title: "Assignment 1: Mini Calculator"
---

<div style="text-align: center; font-style: italic; font-size: 120%;">
  Note: this assignment description is not 100% final at this point,
  changes are possible
</div>

Due: **Wednesday, Sept 15th** by 11pm

Points: This assignment is worth 100 points

# Overview

In this assignment you will implement a mini calculator program which can evaluate infix
expressions using 64 bit signed integer values.  The main purpose of the assignment is
provide an opportunity implement a lexer, parser, and runtime support for a simple but
nontrivial language.

## Grading criteria

The grading criteria are as follows:

* Packaging: 5%
* Design and coding style: 10% (see expectations for [design, coding style, and efficiency](design.html))
* Functional requirements: 85%

# Getting started

Start by downloading the assignment skeleton: [assign01.zip](assign01.zip)

Starter code is provided, including:

* the `main` function
* skeleton implementations for the `struct Lexer` and `struct Parser` data types
* a complete implementation of the `struct Node` data type, which can be used for representation of lexical tokens and tree nodes (parse tree and/or AST)
* the `treeprint` module for printing trees built from `struct Node` instances
* the `util` module, which includes functions for memory allocation, string duplication, and reporting of fatal errors
* the `cpputil` module, which includes a function (`cpputil::format`) for creating a C++ `std::string` value using printf-style formatting
* the `error` module, which has functions for formatting error messages based on `struct SourceInfo` information (filename, line and column numbers)

You may use the provided code in whatever way you see fit, including making changes, or not using it at all.

Note that as provided, all of the struct data types (`struct Node`, `struct Lexer`, etc.) are *opaque data types*. This means that the header file defines the type only as a forward declaration, and all access to data (other than in the type's implementation module) must be done using accessor functions.  The implementation of the data type and its accessor functions is in a separate module, which you can implement using either C or C++.  The assignment skeleton assumes you will use C++.  For example, the source module `lexer.cpp` contains the definition of the `struct Lexer` data type and its accessor functions.

# Language specification

This section describes the lexical structure, syntax, and semantics of the calculator language.

## Lexical structure

The tokens (lexical units) of the calculator language are as follows.

An *identifier* is a letter followed by 0 or more letters or digits.  (Letters can be either upper or lower case. Case is significant, so `foo` and `Foo` are different identifiers.)

An *integer literal* is a sequence of 1 or more digits.

The operators of the language are `+`, `-`, `*`, `/`, `^`, and `=`.

The other single-character tokens are `(`, `)`, and `;`.

Whitespace characters are not significant, and can be used to separate tokens.  For example, the character sequence `abc123` is a single identifier token, but the sequence `abc 123` is two tokens, an identifier (`abc`) followed by an integer literal `123`.

## Syntax

A *unit* consists of a series of one or more *expressions*, with a single semicolon (`;`) token terminating each expression.

There are several kinds of expressions.  A single identifier or integer literal is an expression.  The `+`, `-`, `*`, `^`, and `=` tokens are binary infix operators that combine left and right subexpressions.  The binary operators have the following precedence and associativity:

Operator(s) | Precedence  | Associativity
----------- | ----------- | -------------
`=`         | 1 (lowest)  | right
`+`, `-`    | 2           | left
`*`, `/`    | 3           | left
`^`         | 4 (highest) | right

Expressions can be parenthesized to force the order of evaluation.  For example, in the expression

> `a + b * 3`

the multiplication (`*`) will happen before the addition (`+`) because it is a higher-precedence operator.  However, in the expression

> `(a + b) * 3`

the addition will happen before the multiplication.

Note that we are deliberately *not* giving you an exact grammar for this language.  Part of your job is to formalize this language's grammatical structure: for example by defining it as a context-free grammar.  You will need to think about what parsing techniques are appropriate for this language.

## Semantics

Each expression computes a 64 bit signed integer value.  You should represent values using the `long` data type in the C or C++ program implementing the calculator.

An integer literal is, as the name suggests, a literal integer value, specified in base 10.

The `+`, `-`, `*`, and `/` operators perform addition, subtraction, multiplication, and division, respectively.  They should do the same computation as the corresponding operator in C and C++.

The `^` operator performs exponentiation.  For example, the expression

> `2 ^ 3`

should evaluate to the result value 8.

The `=` operator performs variable assignment.  Note that the left-hand operand of the `=` operator *must* be a identifier naming the variable being assigned.  For example, even though

> `2 = 3`

is a syntactically valid expression according to the [Syntax](#syntax) section above, it is not semantically valid because the left hand side is not an identifier.  The result of evaluating an assignment expression is the same as the result of evaluating the right-hand subexpression.  So, the result of evaluating `a = 3` is 3.  Note that because assignments are right-associative, they may be "chained".  For example, the expression `a = b = 3` will assign the value 3 to both `b` and `a`.

Your calculator program should evaluate each expression in order.  If a variable is assigned in an earlier expression, its value can be used in a later expression.  For variables defined by assignments, an assignment must occur before any use of the value of the variable.  The result of evaluating the last expression is the overall result of the entire unit.

Note that if you are taking 601.628, you will be required to support *weak assignments*, which work somewhat differently than normal assignments.  See [Additional requirements for 628 students](#additional-requirements-for-628-students).

# Requirements

This section details the functional requirements.

## Invocation

Your program should support two ways of being invoked.

If invoked without any command line arguments, it should read input from `stdin` (or `cin`).

If invoked with one (non-option) command line argument, it should read input from the file named by the command line argument.

Your program may, optionally, support "option" arguments.  When the program is invoked with a command line argument beginning with "-", it should treat the argument as an option.  There is no requirement to support any particular options, but one option you might want to support is a `-p` option to allow the program to print a parse tree of the input.  This should be useful when implementing the parser.

## Reporting the evaluation result

After evaluating all of the expressions in the input, the program should print a single line of output to `stdout` or `cout` of the form

<div class="highlighter-rouge">
<pre>
Result: <i>N</i>
</pre>
</div>

where <i>N</i> is the integer value resulting from evaluating the last expression.

Note that any lines of text of the form

<div class="highlighter-rouge">
<pre>
Debug: <i>arbitrary text</i>
</pre>
</div>

will be ignored by the [test harness](#testing).  So, you can use messages in this format to print debug messages as you work on the code.

## Error reporting

Lexical, syntax, and semantic errors should be reported by printing a single line of output to `stderr` or `cerr` of the form

<div class="highlighter-rouge">
<pre>
<i>filename</i>:<i>line</i>:<i>column</i>: Error: <i>explanation</i>
</pre>
</div>

In an error message:

* <i>filename</i> should be the name of the input file, with the special name `<stdin>` if the program is reading from standard input
* <i>line</i> is the line number associated with the error
* <i>column</i> is the column number associated with the error
* <i>explanation</i> is a message explaining the error

Line and column values should each start at 1.  Each newline character should increase the current by 1 and reset the column to 1.  All non-newline characters should increase the column by 1.

For syntax errors, the source location information (line and column) should reference the first token that cannot be parsed.

For semantic errors, the source location information (line and column) should reference the token involved in the semantic error. For example, when reporting a use of an undefined variable, the error message should reflect the location of the identifier naming the undefined variable.

There is no specific requirement for the *explanation* text in an error message, other than that it should be a meaningful explanation of the error.

## Optional extra-credit functionality

This section describes a completely optional feature that you can choose to implement for a *tiny* (at most 1 point) amount of extra credit.  Do **not** work on this unless you are confident that the required features are 100% working.

In addition to the base features, your calculator will can support *weak assignments*.  A weak assignment has the same precedence and associativity as a normal assignment, but uses the token `:-`.  Weak assignments must be at the top level of the expression in which they occur, i.e., they may not be nested in subexpressions.  Also, a calculator input may not contain a mix of normal assignments and weak assignments, and it is an error if both normal and weak assignments are used.

Weak assignments should be evaluated on demand.  For example, consider the following input:

```
a :- b + c;
b :- c * 3;
c :- 2;
a;
```

The overall evaluation result should be 8 because:

* `a` is the sum of `b` and `c`
* `b` is `c` times 3
* `c` is 2

Evaluating `a` will force on-demand evaluation of `b` and `c`, and evaluating `b` will force on-demand evaluation of `c`. There cannot be multiple weak assignments to the same variable. Inputs where there are multiple assignments to the same variable should result in an error.

Weak variables may not be defined cyclically.  For example, the input

```
a :- b;
b :- a;
a + b;
```

is not semantically valid because weak variables `a` and `b` are cyclic.  One way to formalize whether weak variables are defined cyclically is to think of each weak assignment as a node in a graph, with edges going to nodes representing the weak variables used in expression defining the weak variable.  The input is only valid if the graph is acyclic.

# Examples, hints, advice, etc.

This section has examples, hints, and advice about implementation.

## Example inputs and expected results

Example input:

<div class="highlighter-rouge">
<pre>
19 * (3 + 2^4 * 5);
</pre>
</div>

Example output:

<div class="highlighter-rouge">
<pre>
Result: 1577
</pre>
</div>

Example input:

<div class="highlighter-rouge">
<pre>
a = 11;
b = 9;
c = 24;
a * b + c;
</pre>
</div>

Example output:

<div class="highlighter-rouge">
<pre>
Result: 123
</pre>
</div>

## Testing

Tests can be found in the following repository: <https://github.com/jhucompilers/fall2021-tests>

You can clone this repository using the following command:

```bash
git clone https://github.com/jhucompilers/fall2021-tests.git
```

The tests for this assignment are in the `assign01` subdirectory.  Each test case consists of an input file, and either an expected output file or an expected error file.  The `run_test.rb` script executes a single test case.  Before running the script, you will need to set the `ASSIGN01_DIR` environment variable to the full path of the directory containing your `minicalc` executable.  For example, if your work for this assignment is in a directory called `git/minicalc` within your Unix home directory, you could use the command

```bash
export ASSIGN01_DIR=$HOME/git/minicalc
```

to set this environment variable.  You will also need to change directory into the `assign01` subdirectory: from the `fall2021-tests` directory, run the command

```bash
cd assign01
```

The `run_test.rb` script expects a single command line argument, which is the name of the test case.  For example, to run the `arith01` test case, invoke the `run_test.rb` script as follows:

```bash
./run_test.rb arith01
```

You can run all of the test cases using the `run_all.rb` script:

```bash
./run_all.rb
```

We highly encourage you to write your own tests.  To do so, add an input file to the `input` subdirectory.  The input file should have a filename ending in `.in`.  You can use the `genout.sh` script to generate an expected output or expected error file.  For example, if your input file is called `input/contrib17.in`, the command

```bash
./genout.sh input/contrib17.in
```

will generate an output file in either the `expected_output` or `expected_error` directory.

We also encourage you to contribute your tests to the repository.  To do so, fork the [fall2021-tests](https://github.com/jhucompilers/fall2021-tests) repository on Github, commit and push new tests, and then create a pull request.  Note that when your changes are incorporated into the repository, your Github identity will become part of the commit history.  Please name your tests using the `contrib` prefix so that they are distinguishable from the "official" tests.

## Approach

Your work will be divided roughly into the front end (lexical analysis and parsing) and the back end (construction of an intermediate representation, interpretation).

You may find the [example prefix calculator implementation](https://github.com/daveho/pfxcalc) useful as a reference.

## Front end

For implementing the lexical analyzer and parser, it will be helpful to support `-l` and `-p` command line options which, respectively, print out each input token and print a parse tree.  The skeleton code contains support for these options.  For example, let's say that the input file `input/assign02.in` contains the following:

<div class="highlighter-rouge">
<pre>
foo = 13;
bar = 24;
foo * bar;
</pre>
</div>

We could invoke `minicalc` to print the input tokens as follows (user input in **bold**):

<div class="highlighter-rouge">
<pre>
$ <b>./minicalc -l input/assign02.in</b>
0:foo
6:=
1:13
8:;
0:bar
6:=
1:24
8:;
0:foo
4:&#42;
0:bar
8:;
</pre>
</div>

Note that the token codes are just being printed as integers (0 means identifier, 6 means assignment, etc.)  Your lexer might use different token codes, but the lexemes it identifies should be the same as specified above.

Similarly, we could invoke `minicalc` to print a parse tree as follows (user input in **bold**):

<div class="highlighter-rouge">
<pre>
$ <b>./minicalc -p input/assign02.in</b>
Parse tree:
U
+--ASSIGN[=]
|  +--P
|  |  +--IDENTIFIER[foo]
|  +--P
|     +--INTEGER&#95;LITERAL[13]
+--SEMICOLON[;]
+--U
   +--ASSIGN[=]
   |  +--P
   |  |  +--IDENTIFIER[bar]
   |  +--P
   |     +--INTEGER&#95;LITERAL[24]
   +--SEMICOLON[;]
   +--U
      +--TIMES[*]
      |  +--P
      |  |  +--IDENTIFIER[foo]
      |  +--P
      |     +--IDENTIFIER[bar]
      +--SEMICOLON[;]
</pre>
</div>

Note that your parse tree will likely be structured differently, according to the grammar and parsing techniques you used.

Speaking of parsing techniques, the input langugage has left-associative operators, which often are implemented using left-recursive grammar productions.  Since recursive descent parsers can't handle left recursion, you'll either want to eliminate the left recursion, or use a general infix expression parsing technique such as precedence climbing.

## Back end

You can either use the parse tree directly as your intermediate representation, or you can have the interpreter build an abstract syntax tree from the parsed input.

An STL map of strings to `long` values is a good data structure to use for keeping track of the values of variables.

# Submitting

To submit, create a zipfile containing all of the files needed to compile your program.  Suggested command:

```bash
zip -9r solution.zip Makefile *.h *.c *.cpp
```

The suggested command would create a zipfile called `solution.zip`.  Note that if your solution uses C exclusively, you can omit `*.cpp` from the filename patterns.

Upload your submission as **Assignment 1** on [Gradescope](https://www.gradescope.com).
