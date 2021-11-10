#ifndef LIVE_VREGS_H
#define LIVE_VREGS_H

#include <bitset>
#include <vector>
#include "cfg.h"
#include "highlevel.h"

class LiveVregs {
public:
  // we assume that there are never more than this many vregs used
  static const unsigned MAX_VREGS = 256;

  // We use a bitset to represent the set of live vregs.
  // To check whether a vreg is live, check the bit indexed by
  // its register number.
  typedef std::bitset<MAX_VREGS> LiveSet;

  // we assume there are never more than this many basic blocks
  static const unsigned MAX_BLOCKS = 1024;

private:
  // the control flow graph
  ControlFlowGraph *m_cfg;
  // live vregs at end and beginning of each basic block
  std::vector<LiveSet> m_endfacts, m_beginfacts;
  // block iteration order
  std::vector<unsigned> m_iter_order;

public:
  LiveVregs(ControlFlowGraph *cfg);
  ~LiveVregs();

  // execute the analysis
  void execute();

  // get live vregs at end of specified block
  const LiveSet &get_fact_at_end_of_block(BasicBlock *bb) const;

  // get live vregs at beginning of specific block
  const LiveSet &get_fact_at_beginning_of_block(BasicBlock *bb) const;

  // get live vregs after specified instruction
  LiveSet get_fact_after_instruction(BasicBlock *bb, Instruction *ins) const;

  // get live vregs before specified instruction
  LiveSet get_fact_before_instruction(BasicBlock *bb, Instruction *ins) const;

private:
  void compute_iter_order();
  void postorder_on_rcfg(std::bitset<MAX_BLOCKS> &visited, BasicBlock *bb);
  void model_instruction(Instruction *ins, LiveSet &fact) const;
};

class LiveVregsControlFlowGraphPrinter : public HighLevelControlFlowGraphPrinter {
private:
  LiveVregs *m_live_vregs;

public:
  LiveVregsControlFlowGraphPrinter(ControlFlowGraph *cfg, LiveVregs *live_vregs);
  virtual ~LiveVregsControlFlowGraphPrinter();

  virtual void print_basic_block(BasicBlock *bb);
  virtual std::string format_instruction(BasicBlock *bb, Instruction *ins);

  static std::string format_set(const LiveVregs::LiveSet &live_set);
};

#endif // LIVE_VREGS_H
