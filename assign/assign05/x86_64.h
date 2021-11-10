#ifndef X86_64_H
#define X86_64_H

#include "cfg.h"

enum X86_64Reg {
  MREG_RAX,
  MREG_RBX,
  MREG_RCX,
  MREG_RDX,
  MREG_RDI,
  MREG_RSI,
  MREG_RSP,
  MREG_RBP,
  MREG_R8,
  MREG_R9,
  MREG_R10,
  MREG_R11,
  MREG_R12,
  MREG_R13,
  MREG_R14,
  MREG_R15,
};

enum X86_64Instruction {
  MINS_NOP,
  MINS_MOVQ,
  MINS_ADDQ,
  MINS_SUBQ,
  MINS_LEAQ,
  MINS_JMP,
  MINS_JE,
  MINS_JNE,
  MINS_JL,
  MINS_JLE,
  MINS_JG,
  MINS_JGE,
  MINS_CMPQ,
  MINS_CALL,
  MINS_IMULQ,
  MINS_IDIVQ,
  MINS_CQTO,
};

class PrintX86_64InstructionSequence : public PrintInstructionSequence {
public:
  PrintX86_64InstructionSequence(InstructionSequence *iseq);

  virtual std::string get_opcode_name(int opcode);
  virtual std::string get_mreg_name(int regnum);
};

class X86_64ControlFlowGraphBuilder : public ControlFlowGraphBuilder {
public:
  X86_64ControlFlowGraphBuilder(InstructionSequence *iseq);
  ~X86_64ControlFlowGraphBuilder();

  virtual bool is_branch(Instruction *ins);
  virtual bool falls_through(Instruction *ins);
};

class X86_64ControlFlowGraphPrinter : public ControlFlowGraphPrinter {
public:
  X86_64ControlFlowGraphPrinter(ControlFlowGraph *cfg);
  ~X86_64ControlFlowGraphPrinter();

  virtual void print_basic_block(BasicBlock *bb);
};

#endif // X86_64_H
