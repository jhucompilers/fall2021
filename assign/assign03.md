---
layout: default
title: "Assignment 3: Semantic analysis"
---

**Due**: <strike>Monday, Oct 25th</strike> Wednesday, Oct 27th by 11pm

Points: This assignment is worth 100 points

# Overview

In this assignment, you will build a front end (lexical analyzer and parser) for a
simple [Pascal](https://en.wikipedia.org/wiki/Pascal_(programming_language))-like programming
language, and implement a *semantic analysis* phase that builds symbol tables representing the
data types and storage requirements for each program construct that requires them.

One of the main things you will create in this assignment is an AST-based intermediate
representation to represent the source program.

The programming language that your compiler will support, and this assignment,
are both heavily inspired by/stolen from
[Peter Fröhlich's spring 2018 compilers course](http://www.cs.jhu.edu/~phf/2018/spring/cs328/).

## Grading criteria

The grading criteria are as follows:

* Packaging: 5%
* Design and coding style: 10% (see expectations for [design, coding style, and efficiency](design.html))
* Functional requirements: 85%

# Getting started

Download [assign03.zip](assign03.zip).

The starter code is similar to that provided for [Assignment 2](assign02.html), but note that there are some significant changes:

* A lexical analyzer (`lex.l`) is provided; you will just need to implement a parser (`parse.y`)
* The `Node` type is now a C++ class, fully defined in the `node.h` header file; the C functions used in previous assignments are provided for backwards-compatilibility
* The `Node` type has some commented-out code showing one possible way of allowing AST nodes to be annotated with a symbol table entry (pointer to `Symbol`) or a type (pointer to `Type`)
* The `ast.h` and `ast.cpp` source files show a reasonable way to implement ASTs for the source language, and include support for printing ASTs textually or in [graphviz](https://graphviz.org/) format
* The `astvisitor.h` and `astvisitor.cpp` source files implement the visitor design pattern for ASTs
* The `context.h` and `context.cpp` source files are intended to collect all of the data structures used in the compilation process
* The main function is now in a C++ module, `main.cpp`, and has support for handling command line options (you can probably use this as-is)

Note that you may freely use any of the starter code, but you are not obligated to use it, and you are free to make any changes that you feel would be helpful.  For example, if you would like to use different AST node types, you can modify `ast.h`/`ast.cpp` and `astvisitor.h`/`astvisitor.cpp`.

# Language specification

## Lexical structure

The language has the following kinds of tokens:

* Keywords: `PROGRAM` `BEGIN` `END` `CONST` `TYPE` `VAR` `ARRAY` `OF` `RECORD` `IF` `THEN` `ELSE` `REPEAT` `UNTIL` `WHILE` `DO` `READ` `WRITE`
* Operators: `:=` `=` `+` `-` `*` `DIV` `MOD` `#` `<` `>` `<=` `:=`
* Brackets/grouping: `(` `)` `[` `]`
* Misc/punctuation:  `:` `;` `.` `,`
* Identifers: a letter or underscore (`_`), followed by 0 or more letters, underscores, and/or digits
* Integer literals: a sequence of one or more digit characters
* Comments: start with `--` and continue to the end of the source line

Tokens may be separated by whitespace.

## Syntax

The overall input is a *program*, which has the form

<div class="highlighter-rouge"><pre>
PROGRAM <i>identifier</i> ; <i>opt-declarations</i> BEGIN <i>opt-instructions</i> END .
</pre></div>

*opt-declarations* is a sequence of 0 or more *declaration*s.

*opt-instructions* is a sequence of 0 or more *instruction*s.

### Declarations and types

A *declaration* is a *const-declaration*, *var-declaration*, or *type-declaration*.

A *const-declaration* has the form

<div class="highlighter-rouge"><pre>
CONST <i>const-definitions</i>
</pre></div>

*const-definitions* is a sequence of one or more occurrences of *const-definition*.

A *const-definition* has the form

<div class="highlighter-rouge"><pre>
<i>identifier</i> = <i>expression</i> ;
</pre></div>

A *var-declaration* has the form

<div class="highlighter-rouge"><pre>
VAR <i>var-definitions</i>
</pre></div>

*var-definitions* is a sequence of one or more occurrences of *var-definition*.

A *var-definition* has the form

<div class="highlighter-rouge"><pre>
<i>identifier-list</i> : <i>type</i> ;
</pre></div>

An *identifier-list* is a sequence of 1 or more identifiers, separated by commas (`,`).

A *type-declaration* has the form

<div class="highlighter-rouge"><pre>
TYPE <i>type-definitions</i>
</pre></div>

*type-definitions* is a sequence of one or more occurrences of *type-definition*.

A *type-definition* has the form

<div class="highlighter-rouge"><pre>
<i>identifier</i> = <i>type</i> ;
</pre></div>

A *type* is a *named-type*, *array-type*, or *record-type*.

A *named-type* is simply an *identifier*.

An *array-type* has the form

<div class="highlighter-rouge"><pre>
ARRAY <i>expression</i> OF <i>type</i>
</pre></div>

A *record-type* has the form

<div class="highlighter-rouge"><pre>
RECORD <i>var-definitions</i> END
</pre></div>

### Expressions

A *primary-expression* is an integer literal, *designator*, or parenthesized expression.

A *unary-expression* is either a *primary-expression*, or a *unary-expression* preceded by either `-` or `+`.

The following infix operators may be used in expressions, with the operands being *unary-expression*s:

Operator          | Precedence | Associativity
----------------- | ---------- | -------------
`+`, `-`          | lower      | left
`*`, `DIV`, `MOD` | higher     | left

Note that relational operators may *not* appear in *expression*s.  (They are only used in *condition*s.)

### Instructions

An *instruction* is an *assignment-statement*, *if-statement*, *repeat-statement*, *while-statement*,
*read-statement*, or *write-statement*.  Each *instruction* must be followed by a semicolon (`;`).

An *assignment-statement* has the form

<div class="highlighter-rouge"><pre>
<i>designator</i> := <i>expression</i>
</pre></div>

An *if-statement* can have either of the following forms:

<div class="highlighter-rouge"><pre>
IF <i>condition</i> THEN <i>opt-instructions</i> END
</pre></div>

<div class="highlighter-rouge"><pre>
IF <i>condition</i> THEN <i>opt-instructions</i> ELSE <i>opt-instructions</i> END
</pre></div>

A *repeat-statement* has the form

<div class="highlighter-rouge"><pre>
REPEAT <i>opt-instructions</i> UNTIL <i>condition</i> END
</pre></div>

A *while-statement* has the form

<div class="highlighter-rouge"><pre>
WHILE <i>condition</i> DO <i>opt-instructions</i> END
</pre></div>

A *write-statement* has the form

<div class="highlighter-rouge"><pre>
WRITE <i>expression</i>
</pre></div>

A *read-statement* has the form

<div class="highlighter-rouge"><pre>
READ <i>designator</i>
</pre></div>

A *condition* has the form

<div class="highlighter-rouge"><pre>
<i>expression</i> <i>relational-op</i> <i>expression</i>
</pre></div>

where *relational-op* is one of `<`, `<=`, `>`, `>=`, `=`, or `#` (not equals).

A *designator* has one of the following forms:

<div class="highlighter-rouge"><pre>
<i>identifier</i>
</pre></div>

<div class="highlighter-rouge"><pre>
<i>designator</i> [ <i>expression-list</i> ]
</pre></div>

<div class="highlighter-rouge"><pre>
<i>designator</i> . <i>identifier</i>
</pre></div>

These three forms of designators correspond to variable references, array element
references, and record field references, respectively.

An <i>expression-list</i> is a sequence of one or more *expression*s, separated by commas (`,`).

## Semantics, type checking

The source language is a [Pascal](https://en.wikipedia.org/wiki/Pascal_(programming_language))-like
imperative programming language.

There are two primitive data types, `INTEGER` and `CHAR`. These are the *integral* types.

The two kinds of composite data types are arrays and records.  An array type specifies an integer size and an element type, which can be an arbitrary type.  A record type consists of fields, each of which has a name and type.

Within a lexical scope in the program, a name may only refer to a single variable, constant, or type.  For example, the program:

```
PROGRAM names;
  TYPE a = INTEGER;
  VAR a : ARRAY 10 OF CHAR;

BEGIN
  READ a;
END.
```

is not legal because the name `a`, originally referring to a type, is reused to name a variable.

`RECORD` types are a lexical scope distinct from the enclosing scope, so it is legal for field names to shadow names used in the outer scope.

The operands of numeric operators (`+`, `-`, `*`, `DIV`, etc.) must be integral.  Mixed type expressions (consisting of one `INTEGER` and one `CHAR`) are allowed, and the result of a mixed type expression is `INTEGER`.  For non-mixed expressions, the result type is the same as the operand types.

The operands of comparison operators (`<`, `>`, etc.) must be integral.

Integer literals have type `INTEGER`.

Variable references have the type specified by the corresponding variable declaration.

For an array subscript reference, the designator must have an array type, and the expression(s) designating the index(es) must have an integral type (`INTEGER` or `CHAR`.) The type of the subscript reference is the array type's element type.

For a field reference, the designator must have a record type, and the type of the field reference is the type of the field named by the identifier on the right hand side of the `.`.

`WRITE` statements are used for output, and the expression specifying the value to output must be either `INTEGER`, `CHAR`, or array of `CHAR` (any length).

`READ` statements are used for input, and the designator specifying the variable where the input should be stored must be either `INTEGER`, `CHAR`, or array of `CHAR`.

For this assignment, the follow type checking rules should be applied for assignments:

* Only `INTEGER` and `CHAR` values may be assigned
* The type of the designator on the left hand side of the assignment must be exactly the same as the type of the right hand side

These rules may be relaxed for subsequent assignments.

## Errors

Your compiler must do semantic analysis of the input to ensure that each name used in the program refers to a valid type or variable, that array element and field references refer are valid, and that the type rules are followed.

If a semantic error is found, the compiler should print (to `stderr` or `std::cerr`) a message of the form

<div class="highlighter-rouge"><pre>
<i>sourcefile</i>:<i>line</i>:<i>col</i>: Error: <i>message</i>
</pre></div>

where <i>sourcefile</i> is the name of the input file, <i>line</i> is the source line number of the invalid construct, and <i>col</i> is the source column number of the invalid construct.

Examples of errors that should be reported include:

* Use of a named type that is not defined
* Use of an undefined variable
* Attempt to use the array subscript operator on something that is not an array
* Using a non-integral value as an array index
* Attempting to access a field of something that is not a record type
* Attempting to access a nonexistent field of a record
* Using a non-integral value as an operand to a binary operator
* Using a non-constant value in a constant expression (e.g., in a `CONST` declaration or as an array size)
* Attempting a division by 0 (either using `DIV` or `MOD`) in a constant expression
* The expression in a `WRITE` statement has an inappropriate type
* The designator in a `READ` statement has an inappropriate type

## Running the program, dumping symbol table information

The `compiler` executable is invoked using a command of the form

<div class="highlighter-rouge"><pre>
./compiler [<i>option</i>] <i>filename</i>
</pre></div>

where <i>filename</i> is the input program.  There is one required <i>option</i> that must be supported, which is `-s`.  When this option is used, then the program should print out information about symbol table entries as they are added to the symbol tables.  Each symbol table entry should be output as a single line, in the form

<div class="highlighter-rouge"><pre>
<i>depth</i>,<i>symkind</i>,<i>name</i>,<i>type</i>
</pre></div>

<i>depth</i> is the lexical depth of the symbol table entry, with 0 being an entry in the symbol table representing the global scope, and higher numbers representing nested scopes.  Note that the only kind of nested scope is a `RECORD` type.

<i>symkind</i> is one of `VAR`, `TYPE`, or `CONST`, corresponding to variable definitions, type definitions, and constant definitions.

<i>name</i> is the identifier naming the entity represented by the symbol table entry.

<i>type</i> is a textual representation of the data type associated with the symbol table entry: for example, if the entry is for a variable, then <i>type</i> represents the variable's data type.  Types should be represented textually as follows:

* Primitive types (`INTEGER` and `CHAR`) should be represented by name
* Array types should be represented in the form <code class="highlighter-rouge">ARRAY <i>size</i> OF <i>eltype</i></code>, where <i>size</i> is the size of the array and <i>eltype</i> is the textual representation of the element type
* Record types should be represented in the form <code class="highlighter-rouge">RECORD (<i>field1</i> x <i>field2</i> x <i>...</i>)</code> where <i>field1</i> is the representation of the first field's data type, <i>field2</i> is the representation of the second field's data type, etc.

As an example, here is an example of the expected output for the [input/record01.in](https://github.com/jhucompilers/fall2021-tests/blob/master/assign03/input/record01.in) example input in the tests repository (user input in **bold**):

<div class="highlighter-rouge"><pre>
$ <b>./compiler -s input/record01.in</b>
1,VAR,name,ARRAY 10 OF CHAR
1,VAR,age,INTEGER
0,TYPE,Person,RECORD (ARRAY 10 OF CHAR x INTEGER)
0,VAR,p,RECORD (ARRAY 10 OF CHAR x INTEGER)
</pre></div>

The expected order of the printed symbol table entries corresponds to the order in which definitions appear in the source code.  If your symbol table builder uses a general in-order traversal of the AST, this is the natural order in which it will encounter definitions to add to the symbol tables.

## Extra credit: multidimensional arrays

For a tiny (at most 1 point) amount of extra credit, you may choose to implement support for multidimensional arrays.

For example, the following program uses a multidimensional array:

```
PROGRAM multidim;
  TYPE Grid = ARRAY 10 OF ARRAY 10 OF INTEGER;
  VAR mygrid : Grid;

BEGIN
  mygrid[0][0] := 2;
  mygrid[1, 1] := 3;
END.
```

Note that both assignments in the program above show valid ways to refer to an element of a multidimensional array.

# Hints, specifications, and advice

## Approach

Rough outline:

* Implement lexical analyzer and parser using flex and bison
* Add semantic actions in the parser to build an AST
* Create an object-based representation of types
* Implement a traversal of the AST to build symbol table entries and do type checking

Some recommendations to make this assignment fairly straightforward:

* Have the parser (`parse.y`) build an AST directly from the source (i.e., don't bother to build a parse tree)
* Implement `SymbolTable`, `Symbol`, and `Type` classes following the approach we discussed in [Lecture 12](../lectures/lecture12-public.pdf) (see Campuswire files area for annotated slides with design sketches)
* Use a visitor to build symbol tables, annotate AST nodes with symbol table entries and type, and perform type checking (again, following the approach from Lecture 12)

## Testing

Tests can be found in the following repository: <https://github.com/jhucompilers/fall2021-tests>, in the `assign03` subdirectory.

Set the `ASSIGN03_DIR` environment variable to the name of the directory containing your project.  For example, if your project is in the `git/assign03` subdirectory of your home directory, use the command

```bash
export ASSIGN03_DIR=$HOME/git/assign03
```

To run a test:

<div class="highlighter-rouge"><pre>
./run&#95;test.rb <i>testname</i>
</pre></div>

where <i>testname</i> is one of the tests, e.g., <code>arith01.in</code>.

To run all of the tests:

<div class="highlighter-rouge"><pre>
./run&#95;all.rb
</pre></div>

As with previous assignments, we encourage you to contribute your own tests to the repository.  See the [Testing section of Assignment 2](assign02.html#testing) for details regarding how to contribute additional tests.

# Submitting

To submit, create a zipfile containing all of the files needed to compile your program.  Suggested commands:

```bash
make clean
zip -9r solution.zip Makefile *.h *.c *.y *.l *.cpp *.rb
```

The suggested command would create a zipfile called `solution.zip`.  Note that if your solution uses C exclusively, you can omit `*.cpp` from the filename patterns.  If you used the `scan_grammar_symbols.rb` script, them make sure you include the `*.rb` pattern as shown above.

Upload your submission to [Gradescope](https://www.gradescope.com) as **Assignment 3**.
