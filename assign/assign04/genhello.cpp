// Generate a "hello, world" assembly language program
// as a demonstration of x86-64 code generation

// The generated program is actually a bit more complicated than
// just printing "hello, world" since it allocates and uses a
// local variable, and demonstrates control flow

#include <cstdio>
#include "cfg.h"
#include "x86_64.h"

int main() {
  // print prologue
  printf("\t.section .rodata\n"
         "sHelloMsg:  .string \"hello, world\\n\"\n"
         "sPromptMsg: .string \"Enter an integer (negative to exit): \"\n"
         "sInputFmt:  .string \"%%ld\"\n"
         "sOutputMsg: .string \"You entered: %%ld\\n\"\n"
         "\t.section .text\n"
         "\t.globl main\n"
         "main:\n"
         "\tsubq $8, %%rsp\n");

  // the local variable is at offset 0 from %rsp
  Operand localvar(OPERAND_MREG_MEMREF_OFFSET, MREG_RSP, 0);

  // convenient shorthands for rsp, rdi, rsi, and r10
  Operand rsp(OPERAND_MREG, MREG_RSP);
  Operand rdi(OPERAND_MREG, MREG_RDI);
  Operand rsi(OPERAND_MREG, MREG_RSI);
  Operand r10(OPERAND_MREG, MREG_R10);

  // convenient shortcuts for referenced labels
  Operand hellomsg("sHelloMsg", true);
  Operand promptmsg("sPromptMsg", true);
  Operand inputfmt("sInputFmt", true);
  Operand outputmsg("sOutputMsg", true);
  Operand printf_label("printf");
  Operand scanf_label("scanf");

  InstructionSequence *code = new InstructionSequence();
  code->add_instruction(new Instruction(MINS_MOVQ, hellomsg, rdi));
  code->add_instruction(new Instruction(MINS_CALL, printf_label));

  code->define_label(".L0"); // top of loop

  // print the prompt
  code->add_instruction(new Instruction(MINS_MOVQ, promptmsg, rdi));
  code->add_instruction(new Instruction(MINS_CALL, printf_label));

  // read input value
  code->add_instruction(new Instruction(MINS_MOVQ, inputfmt, rdi));
  code->add_instruction(new Instruction(MINS_LEAQ, localvar, rsi));
  code->add_instruction(new Instruction(MINS_CALL, scanf_label));

  // if entered value was negative, terminate loop
  code->add_instruction(new Instruction(MINS_MOVQ, localvar, r10));
  code->add_instruction(new Instruction(MINS_CMPQ, Operand(OPERAND_INT_LITERAL, 0), r10));
  code->add_instruction(new Instruction(MINS_JL, Operand(".L1")));

  // print the input value
  code->add_instruction(new Instruction(MINS_MOVQ, outputmsg, rdi));
  code->add_instruction(new Instruction(MINS_MOVQ, localvar, rsi));
  code->add_instruction(new Instruction(MINS_CALL, printf_label));

  // jump back to top of loop
  code->add_instruction(new Instruction(MINS_JMP, Operand(".L0")));

  // out label
  code->define_label(".L1");

  PrintX86_64InstructionSequence print_ins(code);
  print_ins.print();

  // print epilogue
  printf("\taddq $8, %%rsp\n"
         "\tmovl $0, %%eax\n"
         "\tret\n");

  return 0;
}
