---
layout: default
title: "Assignment 2: Interpreter"
---

Due: **Friday, Oct 8th** by 11pm

Points: This assignment is worth 200 points

# Overview

In this assignment you will implement an AST-based interpreter for a simple programming
language based on the calculator language from [Assignment 1](assign01.html).

## Grading criteria

The grading criteria are as follows:

* Packaging: 5%
* Design and coding style: 10% (see expectations for [design, coding style, and efficiency](design.html))
* Functional requirements: 85%

# Getting started

Start by downloading the assignment skeleton: [assign02.zip](assign02.zip).

Starter code is provided, including:

* the `main` function
* a skeleton lexical analyzer (`lex.l`)
* a skeleton parser (`parse.y`)
* a complete implementation of the `struct Node` data type, which can be used for representation of lexical tokens and tree nodes (parse tree and/or AST)
* a `scan_grammar_symbols.rb` script for scanning the parser specification file to determine the names of all terminal and nonterminal grammar symbols, and create source files `grammar_symbols.h` and `grammar_symbols.c`
* the `treeprint` module for printing trees built from `struct Node` instances
* the `util` module, which includes functions for memory allocation, string duplication, and reporting of fatal errors
* the `cpputil` module, which includes a function (`cpputil::format`) for creating a C++ `std::string` value using printf-style formatting
* a skeleton interpreter implementation (`interp.h`, `interp.cpp`)

You may use the provided code in whatever way you see fit, including making changes, or not using it at all.  However, it is a requirement of this assignment that you use flex and bison to create the lexical analyzer and parser.

# Language specification

This section describes the lexical structure, syntax, and semantics of the interpreter language.

## Lexical structure

The tokens (lexical units) of the interpreter language are very similar to those of the [calculator language](assign01.html).

There are several *keywords*: `var`, `function`, `if`, `else`, and `while`.

An *identifier* is a letter followed by 0 or more letters or digits.  (Letters can be either upper or lower case. Case is significant, so `foo` and `Foo` are different identifiers.)

An *integer literal* is a sequence of 1 or more digits.

The operators of the language are `+`, `-`, `*`, `/`, `==`, `!=`, `<`, `>`, `<=`, `>=`, `&&`, `||`, and `=`.

Tokens used for grouping, sequences, and terminating statements are `(`, `)`, `{`, `}`, `,`, and `;`.

Whitespace characters are not significant, and can be used to separate tokens.  For example, the character sequence `abc123` is a single identifier token, but the sequence `abc 123` is two tokens, an identifier (`abc`) followed by an integer literal `123`.

C++-style comments are supported: a comment begins with `//` and continues until the end of the source line.  Comments should be ignored by the interpreter.

## Syntax

A *translation unit* consists of a sequence of one or more *definitions*.

A *definition* is a *statement* or *function*.

There are several kinds of *statement*s:

* An *expression-statement* is an *expression* followed by a semicolon (`;`)
* A *variable-declaration-statement* is the `var` keyword, followed by a comma-separated list of one or more identifiers, followed by a semicolon
* An *if-statement* has the form <code class="highlighter-rouge">if (<i>condition</i>) { <i>statement-list</i> }</code>
* An *if-else-statement* has the form <code class="highlighter-rouge">if (<i>condition</i>) { <i>statement-list</i> } else { <i>statement-list</i> }</code>
* A *while-statement* has the form <code class="highlighter-rouge">while (<i>condition</i>) { <i>statement-list</i> }</code>

A *statement-list* is a sequence of 0 or more *statement*s.

A *function* has the form <code class="highlighter-rouge">function <i>identifier</i>(<i>opt-parameter-list</i>) { <i>statement-list</i> }</code>.  An *opt-parameter-list* is a comma-separated sequence of zero or more identifiers.

An *expression* is a sequence of one or more *unary-expression*s separated by infix operators.  The infix operators are as follows:

Operator(s)                      | Precedence  | Associativity
-------------------------------- | ----------- | -------------
`=`                              | 1 (lowest)  | right
`||`                             | 2           | left
`&&`                             | 3           | left
`==`, `!=`, `<`, `>`, `<=`, `>=` | 4           | left
`+`, `-`                         | 5           | left
`*`, `/`                         | 6 (highest) | left

A *unary* expression is either a single *primary-expression*, or the unary `-` operator followed by a *unary-expression*.

A *primary-expression* is an identifier, integer literal, parenthesized subexpression, or *function-call*.

A *function-call* has the form <code class="highlighter-rouge"><i>identifier</i> (<i>opt-argument-list</i>)</code>.  An *opt-argument-list* is a comma-separated sequence of zero or more expressions.

You will need to add grammar rules to `parse.y` according to these specifications.

## Semantics

Your interpreter will evaluate programs for a real programming language, so the semantics are considerably more interesting than in [Assignment 1](assign01.html).

This section is a reasonably precise run-time semantics of interpreter programs; however, the [test suite](#testing) is also an extremely *useful* specification of run-time semantics.

### Values

The interpreter language is dynamically-typed: variables can contain any kind of value.

Values are defined by the `ValueKind` enumeration and the `Value` struct data type (in `value.h`):

```c
enum ValueKind {
  VAL_VOID,
  VAL_ERROR,
  VAL_INT,
  VAL_FN,
  VAL_INTRINSIC,
  // could add additional kinds of values...
};

struct Value {
  enum ValueKind kind;
  long ival;
  struct Function *fn;
  IntrinsicFunction *intrinsic_fn;

  // You may add additional struct members for additional kinds
  // of values.
};
```

Instances of `struct Value` in the interpreter are meant to be accessed by value (rather than being dynamically-allocated).

The `kind` field specifies what kind of value a `struct Value` instance represents.

For `VAL_INT` values, the `ival` field stores a (64 bit signed) integer value.

For `VAL_FN` values, the `fn` field stores a pointer to a `struct Function`.

For `VAL_INTRINSIC` values, the `intrinsic_fn` field stores a pointer to an `IntrinsicFunction`.  The `IntrinsicFunction` type is defined as follows:

```c
typedef struct Value IntrinsicFunction(struct Value *args, int num_args,
                                       struct Interp *interp);
```

All of the infix operators, with the important exception of `==` and `!=`, operate exclusively on integer values.  It is a run-time error to apply an infix operator other than `==` and `!=` to a non-integer value.

The unary `-` operator is also only defined for integer values, and it is a run-time error to apply it to a non-integer value.

### Variables

Variables must be explicitly declared with a variable declaration statement.  Variable declarations define in functions are local to the function.  Other variables are global variables.

Local variables in functions have the entire function as their scope, even if they are defined in nested blocks of loops or if/else statements.  (This is similar to JavaScript.)  Variables must be declared before being referenced.

Uninitialized variables have the initial integer value 0.

A primary expression which is an identifier is a variable reference.

### Expressions

An expression computes a value.

Primary expressions should be computed as follows:

* A variable reference yields the value of the named variable
* An integer literal is a `VAL_INT` value converted from the lexeme of the integer literal token
* A function call evaluates each argument expression in order from left to right and passes them as argument values to the called function

The infix operators, when operating on two `VAL_INT` values, should behave the same way as the corresponding C/C++ operators.  Note that the logical (`&&`, `||`) and relational (`<`, `>`, `<=`, `>=`, `==`, `!=`) operators, when operating on two `VAL_INT` values, should produce a `VAL_INT` with the integer value 1 to mean true, and a `VAL_INT` with the value 0 to mean false.

As a special case, the `==` and `!=` operators may also be used with `VAL_NIL` values.  Two `VAL_NIL` values should compare as equal to each other.  If a `VAL_INT` value is compared to a `VAL_NIL` value, they are not equal.

The logical operators `&&` and `||` are short circuiting.

The unary `-` operator, when applied to a `VAL_INT` value, should return the negation of that value.  I.e., the unary `-` operator applied to a variable reference `n` should do the same compuation as the expression `0 - n` would.

The `=` operator is the assignment operator.  The left-hand side must be a variable reference.

### Statements and statement lists

When evaluating a statement list, the value of the statement list is the value of the last statement.

Evaluating an expression statement yields the result of evaluating the expression.

An if or if/else statement should work as follows

* the condition is evaluated
* if the result of evaluating a condition is a "true" value, then the if clause is evaluated
* if the result of evaluating a condition is not a "true" value, and there is an else clause, then the else clause is evaluated
* the result of evaluating an if or if/else statement is a `VAL_VOID` value

A while loop is similar to an if statement (without an else clause), except that the loop body is evaluated repreatedly as long as the condition evaluates to a "true" value.  The result of evaluating a while statement is a `VAL_VOID` value.

Statement lists are evaluated by evaluating each statement in order.  The result of evaluating a statement list is the value of the last statement.  This means that in a function body, the last statement implicitly computes the return value of the function.

### "true" values

A nonzero `VAL_INT` value is a true value.

A `VAL_FN`, `VAL_INTRINSIC`, or `VAL_CONS` value is a true value.

Any other value is *not* a true value.

### Functions and function calls

When evaluating a call to a non-intrinsic function (a `VAL_FN` value), the interpreter should check whether the number of arguments being passed to the function matches the number of parameters.  If not, an error occurs.  Otherwise, the interpreter should allocate storage for all of the function's parameters and variables, set the value of each parameter to the corresponding argument value, set the value of each other local variable to a zero `VAL_INT` value, and then evaluate the function's body in this environment.  The result computed by the function call is the result of evaluating the last statement in the function body's statement list.

To evaluate a call to an intrinsic function (a `VAL_INTRINSIC` value), the interpreter should allocate an array of `struct Value` elements, one per argument, and copy the argument values to the array.  Then, it should invoke the function pointed to by the `intrinsic_fn` field of the function's `struct Value` instance.  The result of evaluating a call to an intrinsic function is the value returned by this call.  Note that any number of arguments may be passed to an intrinsic function, and it is possible for intrinsic functions to be variadic.

Note that function bodies may reference global variables.

Note that variables and functions are in the same namespace.  A variable reference naming a function produces a `VAL_FN` value; i.e., the value is the function the name refers to.  Function calls should do a variable lookup to find the function being called.  This means that a function can be passed as an argument to another function.  For example:

```
function add1(n) {
  n+1;
}
function apply(f, x) {
  f(x);
}
apply(add1, 42);
```

The result of this program is 43.

### Program

The overall program is defined by a *translation-unit*, which is a sequence of one or more *definitions*, where each definition is either a statement or function definition.

The overall result of the program is the result of evaluating the final definition.

If the final definition is not a statement (i.e., it is a function definition), then the result of the program is a `VAL_VOID` value.

### Intrinsic functions

The interpreter should support the following intrinsic functions.  These are essentially global variables with `VAL_INTRINSIC` values, with `intrinsic_fn` field values pointing to appropriately-implemented C or C++ functions.

It is an error to call an intrinsic function but pass an incorrect number of arguments.

Note that the functions printing output should print to standard output (<code>stdout</code> or <code>std::cout</code>.)

The `print` intrinsic takes one argument value, and prints the stringified representation of that value (as produced with `val_stringify`.)

The `println` intrinsic takes one argument value, prints it (the same way as the `print` intrinsic), and then prints a newline character.

The `printspace` intrinsic takes no arguments, and prints a single space character.

The `printnl` intrinsic takes no arguments, and prints a single newline (`'\n'`) character.

All of the print functions return a `VAL_VOID` result value.

The `readint` intrinsic takes no arguments, reads a single `long` value from standard input, and returns the input value as a `VAL_INT` value.

## Completely optional features

Here are two options to earn a tiny (at most 1 point) amount of extra credit.  Do not work on these features unless all required features are completely working.

**Feature 1**: Implement two additional data types, `VAL_CONS` and `VAL_NIL`, along with several intrinsic functions, and an enhancement to the `val_stringify` function.

In a a `VAL_CONS` value, the `struct Value` instance's `cons` field will point to a dynamically allocated object whose type is `struct Cons`.  A `struct Cons` instance should have two fields that are instances of `struct Value`.  The suggested names for these fields are `car` and `cdr`.  So, your definition of `struct Cons` (in your interpreter implementation module, i.e. `interp.cpp`) might look like this:

```c
struct Cons {
  struct Value car, cdr;
};
```

This dynamically-allocated instance of `struct Cons` is called a *cons cell*.  **Important**: your interpreter does *not* need to keep track of dynamically allocated cons cells so that their memory can be reclaimed when they are no longer in use.  In other words, you do not need to implement a reference counting or garbage collecting scheme.  It is fine to just leak them. (But: see Feature 2 below.)

A `VAL_NIL` value has no data associated with it.  The only real requirement for `VAL_NIL` is that it is distinguishable from other types of values.

Together, `VAL_CONS` and `VAL_NIL` values can can be used to represent arbitrary lists of values, as follows:

* A `VAL_NIL` value represents an empty list
* A `VAL_CONS` value represents a list, where its *car* value is the first element of the list, and its *cdr* value is a list containing the remaining elements

In a "proper" list, the last cons cell in a list will have a `VAL_NIL` value as its *cdr*.

You will need to implement the following intrinsic functions to work with `VAL_CONS` and `VAL_NIL` values.

The `cons` intrinsic function takes two arguments, and returns a `VAL_CONS` value where the associated cons cell has the first argument value as its *car*, and the second argument value as its *cdr*.

The `car` intrinsic function takes one argument, which must be a `VAL_CONS` value, and returns the associated cons cell's *car* value.

The `cdr` intrinsic function takes one argument, which must be a `VAL_CONS` value, and returns the associated cons cell's *cdr* value.

The `nil` intrinsic function takes no arguments, and returns a `VAL_NIL` value.

The `nilp` ("nil predicate") function takes one argument, and returns a `VAL_INT` value of either 0 or 1, 0 if the argument is *not* a `VAL_NIL` value, 1 if the argument *is* a `VAL_NIL` value.

The `list` intrinsic function takes 0 or more arguments, and returns a list containing the arguments as members, in order.

In addition to implementing these intrinsic functions, you will need to enhance `val_stringify` to produce a textual representation of list values, as follows.

By itself, a `VAL_NIL` value should be stringified as `()`.  So, the program

```
nil();
```

would produce the output

```
Result: ()
```

A `VAL_CONS` value that is the head of a chain of cons cells should be stringified in the form

<div class="highlighter-rouge">
<pre>
(<i>members</i>)
</pre>
</div>

where <i>members</i> is the textual representation of the *car* of each cons cell in the chain, separated by space characters. For example, the program

```
cons(1, cons(2, cons(3, nil())));
```

should produce the output

```
Result: (1 2 3)
```

As a special case, if the *cdr* of the last cons cell in the chain is not a `VAL_NIL` value, then the list is an "improper" list, and the characters "<code class="highlighter-rouge">&#32;.&#32;</code>" (space, dot, space) should be printed, then the last cdr value, then the closing right parenthesis.  For example, the program

```
cons(1, cons(2, 3));
```

should produce the output

```
Result: (1 2 . 3)
```

You may assume that the stringification of a list will require no more than 8,191 characters to represent.

The [test repository](https://github.com/jhucompilers/fall2021-tests) has some test cases for list processing types and functions: `cons01`, `cons02`, etc.  See the [Testing](#testing) section.

**Feature 2**:  If you have implemented cons cells and the various primitive functions
which support them, you can now try implementing a garbage collector. The idea is that
the program should manage a heap where dynamic objects — specifically, cons cells
and functions (with their body ASTs) — are allocated.  The heap should have
room for a fixed number of dynamic objects.  When the heap is completely full,
meaning all available space has been allocated, it should perform garbage collection,
whereby the memory being used by all dynamic objects no longer in use can be reclaimed.

The interpreter will need to keep track of which dynamic objects are reachable.
Names in the global environment are one way that dynamic objects will be reachable.
A somewhat trickier kind of reachable object are those referenced via local
variables in the interpreter.  Your interpreter will need some way of keeping track
of which heap objects are reachable this way.

A simple approach to garbage collection is *mark and sweep*. When the heap is
full, the garbage collector should clear a "mark flag" in each heap object.
Then, it should traverse all reachable objects, starting with
the immediately reachable objects (referenced from the global environment and
from local variables in active function calls in the interpreter.)  As
objects are reached, the mark flag should be set.  When this process is complete,
all unmarked objects can be reclaimed, so that they are available for future
allocations.

(Please note that I don't really expect you to implement a garbage collector.
I'm just throwing the idea out there.)

# Requirements

This section details the functional requirements (on top of the requirements to implement the language according to the specifications above.)

## Invocation

The `interp` program should take a single command line argument, which is the name of the text file containing the program to execute.

Optionally, the program may support command line options preceding the program filename.  For example, the `main` function in the assignment skeleton supports a `-p` option which prints the input program as a parse tree.  (Which is really handy for debugging the parser!)

## Reporting the evaluation result

Once a program has finished executing, the `interp` program should print a single line of output of the form

<div class="highlighter-rouge">
<pre>
Result: <i>stringified value</i>
</pre>
</div>

where <i>stringified value</i> is the result of calling the `val_stringify` function on the result value of the program.

## Error reporting

All errors may be (and should be) considered as fatal errors the cause the interpreter to
immediately print an error message and exit.  Error messages should be printed to
<code>stderr</code>/<code>std::cerr</code> in the form

<div class="highlighter-rouge">
<pre>
<i>filename</i>:<i>line</i>:<i>column</i>: Error: <i>error message</i>
</pre>
</div>

where <i>filename</i> is the name of the file containing the program, <i>line</i> is the line number of the construct or operation that failed, and <i>column</i> is the column number.  Error messages must have *exactly* this format.  Note that the column number won't be checked by the test suite or the autograder, but your interpreter should produce an accurate line number.

Examples of errors that should be reported:

* references to undefined variable or functions (the must be defined before use)
* redefinitions of variables or functions
* runtime operations on values belonging to an inappropriate type: for example, applying the <code>+</code> operator to values that aren't both integers, calling a value that isn't a function, etc.
* passing the wrong number of arguments to a function (either a user-defined function or an intrinsic function)
* attempt to divide by 0

**Note**: do not use the `VAL_ERROR` value type. All errors should be reported immediately, rather than propagating in the computation as error values.

# Examples, hints, advice, etc.

## Strategy

This is a very substantial assignment.  You will want to make progress in stages.  Here is a recommended approach.

Start by implementing the lexical analyzer and parser.  Using the `-p` command line option will cause the `interp` program to print a parse tree rather than executing the program.  For example, if `t/t1.txt` contains

```
1 + 2;
```

then the invocation `./interp -p t/t1.txt` might produce the following output:

```
translation_unit
+--statement_or_function
   +--statement
      +--expression
      |  +--assignment_expression
      |     +--logical_or_expression
      |        +--logical_and_expression
      |           +--relational_expression
      |              +--additive_expression
      |                 +--additive_expression
      |                 |  +--multiplicative_expression
      |                 |     +--unary_expression
      |                 |        +--primary_expression
      |                 |           +--INT_LITERAL[1]
      |                 +--PLUS[+]
      |                 +--multiplicative_expression
      |                    +--unary_expression
      |                       +--primary_expression
      |                          +--INT_LITERAL[2]
      +--SEMICOLON[;]
```

Note that the structure of the parse tree will depend on how you structure your grammar rules, so the parse tree produced by your interpreter could be different.

Once you're happy with lexical analyzer and parser, add code to create an AST for the program.  You could implement a recursive transformation of parse trees to ASTs, or you could modify the parser to create a ASTs.  It is possible to create a single AST for the entire program, or create separate ASTs for each definition in the program's translation unit.  For example, an AST representation of the expression statement evaluating `1 + 2` in the preceding program might be as follows:

```
AST_ADD
+--AST_INTLITERAL[1]
+--AST_INTLITERAL[2]
```

Once your interpreter is able to construct an AST-based representation for each definition, it can evaluate each definition.

## Testing

Tests can be found in the following repository: <https://github.com/jhucompilers/fall2021-tests>, in the `assign02` subdirectory.

The tests are set up in a way that is very similar to [Assignment 1](assign01.html#testing).  Make sure you set the `ASSIGN02_DIR` environment variable to the directory containing your `interp` executable, e.g.

```bash
export ASSIGN02_DIR=$HOME/git/assign02
```

if the directory containing your code is in an `assign02` subdirectory of your `git` directory.

Run a test using the `run_test.rb` script, e.g.

```bash
./run_test.rb arith01
```

You can run all of the test cases using the `run_all.rb` script, e.g.

```bash
./run_all.rb
```

We highly encourage you to write your own tests.  To do so, add an input file to the `input` subdirectory.  The input file should have a filename ending in `.in`.  You can use the `genout.sh` script to generate an expected output or expected error file.  For example, if your input file is called `input/contrib17.in`, the command

```bash
./genout.sh input/contrib17.in
```

will generate an output file in either the `expected_output` or `expected_error` directory.

If your test program needs to read input at runtime (i.e., because it uses the `readint` intrinsic function), the runtime input should be in a file called <code class="highlighter-rouge"><i>testname</i>.in</code> in the `data` subdirectory.  (*Testname* is the name of the test case, e.g., `contrib17`.)

We also encourage you to contribute your tests to the repository.  To do so, fork the [fall2021-tests](https://github.com/jhucompilers/fall2021-tests) repository on Github, commit and push new tests, and then create a pull request.  Note that when your changes are incorporated into the repository, your Github identity will become part of the commit history.  Please name your tests using the `contrib` prefix so that they are distinguishable from the "official" tests.

# Submitting

To submit, create a zipfile containing all of the files needed to compile your program.  Suggested commands:

```bash
make clean
zip -9r solution.zip Makefile *.h *.c *.y *.l *.cpp *.rb
```

The suggested command would create a zipfile called `solution.zip`.  Note that if your solution uses C exclusively, you can omit `*.cpp` from the filename patterns.  If you used the `scan_grammar_symbols.rb` script, them make sure you include the `*.rb` pattern as shown above.

Upload your submission to [Gradescope](https://www.gradescope.com).  If you are registered for 601.428, upload to **Assign02&#95;428**.  If you are registered for 601.628, upload to **Assign02&#95;628**.
