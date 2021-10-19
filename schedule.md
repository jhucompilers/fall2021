---
layout: default
title: "Schedule"
category: "schedule"
---

This page lists lecture topics, readings, and exam dates.  It also lists assignment due dates.

The links to slides are provided for reference.  In general, there is no guarantee that they will be posted before class, or that their content will not change.

Readings:

* EaC is Cooper and Torczon, [Engineering a Compiler (2nd Ed.)](https://www.elsevier.com/books/engineering-a-compiler/cooper/978-0-12-088478-0)
* F&amp;B is Levine, [Flex and Bison](https://www.oreilly.com/library/view/flex-bison/9780596805418/)

*Note*: The schedule will become more concrete as the semester progresses. Expect it to be updated frequently.  Tentative topics are marked <span class="tentative">in a lighter italic font</span>: expect these to change.

Date               | Topic/Slides | Reading      | Assignment
:----------------: | ------------ | ------------ | ----------
Mon, Aug 30 | Course intro, lexical analysis: [slides](lectures/lecture01-public.pdf)
Wed, Sep 1 | Context free grammars, parse trees, ambiguity, recursive descent parsing: [slides](lectures/lecture02-public.pdf) | EaC 3.1–3.2
Mon, Sep 6 | *Holiday, no class*
Wed, Sep 8 | Limitations of recursive descent, precedence climbing: [slides](lectures/lecture03-public.pdf) | EaC 3.3
Mon, Sep 13 | Lexical analyzer generators, lex/flex: [slides](lectures/lecture04-public.pdf), [lexdemo.zip](lectures/lexdemo.zip) | EaC 2.1–2.5,<br>F&amp;B Chapters 1–2
Wed, Sep 15 | LL(1) parsing: [slides](lectures/lecture05-public.pdf) | EaC 3.3 | [A1](assign/assign01.html) due
Mon, Sep 20 | Parser generators, yacc/bison: [slides](lectures/lecture06-public.pdf)  | F&amp;B Chapter 3
Wed, Sep 22 | ASTs, Interpreters: [slides](lectures/lecture07-public.pdf)  | 
Mon, Sep 27 | Interpreter runtime structures: [slides](lectures/lecture08-public.pdf), Exam 1 review  | <!-- -->
Wed, Sep 29 | Bottom-up parsing: [slides](lectures/lecture09-public.pdf)  |  EaC 3.4
Mon, Oct 4 | **Exam 1** in class
Wed, Oct 6 | Context-sensitive analysis, attribute grammars: [slides](lectures/Context_sensitive_Analysis_I.pdf) | EaC 4.1–4.3 | [A2](assign/assign02.html) due Fri 10/8
Mon, Oct 11 | Compiler project intro, ASTs and symbol tables: [slides](lectures/lecture11-public.pdf)  |  
Wed, Oct 13 | AST visitors, symbol tables, context-sensitive analysis, ad-hoc techniques: [slides](lectures/Context_sensitive_Analysis_II.pdf) | EaC 4.4
Mon, Oct 18 | Intermediate representations: [slides](lectures/Intermediate_Representations.pdf) | EaC 5.1–5.5 |
Wed, Oct 20 | The procedure abstraction: [slides](lectures/The_Procedure_Abstraction_I.pdf) | EaC Chapter 6 |
Mon, Oct 25 | Code shape for expressions: [slides](/lectures/Code_Shape_I_Quick_Intro_to_Code_Generation_+_Code_Shape_for_Expressions.pdf) | EaC 7.1–7.4 |  [A3](assign/assign03.html) due
Wed, Oct 27 | x86-64 assembly language, code generation: [slides](lectures/lecture16-public.pdf) |  | 
Mon, Nov 1 | Arrays and strings: [slides](lectures/Code_Shape_II_Arrays_Aggregates_&_Strings.pdf) | EaC 7.5–7.7 |
Wed, Nov 3 | Boolean and relational expressions, decisions and loops: [slides](lectures/Code_Shape_III_Boolean_and_Relational_Expressions_+_Control_Flow.pdf) | EaC 7.8 | 
Mon, Nov 8 | **Exam 2** in class <!--Intro to Code optimization: [slides](lectures/Introduction_to_Optimization_terminology_&_local_value_numbering.pdf), [slides](lectures/Regional_Optimization_Superlocal_Value_Numbering_and_Loop_Unrolling.pdf) --> | <!-- EaC 8.1–8.5 --> | <!-- -->
Wed, Nov 10 | <!--Intro to Global optimization, Instruction selection: [slides](lectures/Global_Optimization_Live_Analysis.pdf), [slides](lectures/Introduction_to_Instruction_Selection_and_Peephole_based_Selection.pdf) --> | <!-- EaC 8.6, 11.5-->
Mon, Nov 15 | <!--Instruction selection, continued --> | <!-- --> | <!-- [A4](assign/assign04.html) due 11/13-->
Wed, Nov 17 | <!--<b>Exam 3 out</b>, Local register allocation: [slides](lectures/Local_Register_Allocation_and_Lab_1.pdf) --> | <!-- EaC 13.1–13.3-->
Mon, Nov 22 | *Thanksgiving break*
Wed, Nov 24 | *Thanksgiving break*
Mon, Nov 29 | <!--Discussion and [advice](assign/assign05-advice.html) on implementing code optimization -->
Wed, Dec 1 | <!--Dataflow analysis: [slides](lectures/foster-dataflow.pdf) --> | <!-- EaC 9.1–9.2, [Killdall-POPL73](lectures/killdall-popl73.pdf)-->
Mon, Dec 6 | <!--Dataflow analysis, continued; [more code optimization advice](lectures/dec02-outline.txt)  --> | <!-- --> | <!-- [A5](assign/assign05.html) due 12/4-->

<!--
See orig-sched.txt for original schedule for portion of the course
10/6 and later
-->
