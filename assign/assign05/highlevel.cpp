#ifndef HIGHLEVEL_H
#define HIGHLEVEL_H

#include "cfg.h"

// "High-level" opcodes
enum HighLevelOpcode {
  HINS_NOP,
  HINS_LOAD_ICONST,
  HINS_INT_ADD,
  HINS_INT_SUB,
  HINS_INT_MUL,
  HINS_INT_DIV,
  HINS_INT_MOD,
  HINS_INT_NEGATE,
  HINS_LOCALADDR,
  HINS_LOAD_INT,
  HINS_STORE_INT,
  HINS_READ_INT,
  HINS_WRITE_INT,
  HINS_JUMP,
  HINS_JE,
  HINS_JNE,
  HINS_JLT,
  HINS_JLTE,
  HINS_JGT,
  HINS_JGTE,
  HINS_INT_COMPARE,
  HINS_LEA,
};

class PrintHighLevelInstructionSequence : public PrintInstructionSequence {
public:
  PrintHighLevelInstructionSequence(InstructionSequence *ins);

  virtual std::string get_opcode_name(int opcode);
  virtual std::string get_mreg_name(int regnum);
};

class HighLevelControlFlowGraphBuilder : public ControlFlowGraphBuilder {
public:
  HighLevelControlFlowGraphBuilder(InstructionSequence *iseq);
  virtual ~HighLevelControlFlowGraphBuilder();

  virtual bool falls_through(Instruction *ins);
};

class HighLevelControlFlowGraphPrinter : public ControlFlowGraphPrinter {
public:
  HighLevelControlFlowGraphPrinter(ControlFlowGraph *cfg);
  ~HighLevelControlFlowGraphPrinter();

  virtual void print_basic_block(BasicBlock *bb);
};

#endif // HIGHLEVEL_H
