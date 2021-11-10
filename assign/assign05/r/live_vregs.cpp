#include <algorithm>
#include "debugvar.h"
#include "cfg.h"
#include "highlevel.h"
#include "live_vregs.h"

namespace {
  bool DEBUG_LIVE_VREGS;
  DebugVar d("DEBUG_LIVE_VREGS", DEBUG_LIVE_VREGS);
}

LiveVregs::LiveVregs(ControlFlowGraph *cfg)
  : m_cfg(cfg)
  , m_endfacts(cfg->get_num_blocks(), LiveSet())
  , m_beginfacts(cfg->get_num_blocks(), LiveSet()) {
}

LiveVregs::~LiveVregs() {
}

void LiveVregs::execute() {
  compute_iter_order();

  if (DEBUG_LIVE_VREGS) {
    // for now just print iteration order
    printf("Iteration order:\n");
    for (auto i = m_iter_order.begin(); i != m_iter_order.end(); i++) {
      printf("%u ", *i);
    }
    printf("\n");
  }

  bool done = false;

  unsigned num_iters = 0;
  while (!done) {
    num_iters++;
    bool change = false;

    // for each block (according to the iteration order)...
    for (auto i = m_iter_order.begin(); i != m_iter_order.end(); i++) {
      unsigned id = *i;
      BasicBlock *bb = m_cfg->get_block(id);

      // Compute the set of vregs we currently know to be alive at the
      // end of the basic block.  For the exit block, this is the empty set.
      // for all other blocks (which will have at least one successor),
      // then it's the union of the vregs we know to be alive at the
      // beginning of each successor.
      LiveSet live_set;
      if (bb->get_kind() != BASICBLOCK_EXIT) {
        const ControlFlowGraph::EdgeList &outgoing_edges = m_cfg->get_outgoing_edges(bb);
        for (auto j = outgoing_edges.cbegin(); j != outgoing_edges.cend(); j++) {
          Edge *e = *j;
          BasicBlock *successor = e->get_target();
          live_set |= m_beginfacts[successor->get_id()];
        }
      }

      // Update (currently-known) live vregs at the end of the basic block
      m_endfacts[id] = live_set;

      // for each Instruction in reverse order...
      for (auto j = bb->crbegin(); j != bb->crend(); j++) {
        Instruction *ins = *j;

        // model the instruction
        model_instruction(ins, live_set);
      }

      // did the live_set at the beginning of the block change?
      // if so, at least one more round will be needed
      if (live_set != m_beginfacts[id]) {
        change = true;
        m_beginfacts[id] = live_set;
      }
    }

    // if there was no change in the computed dataflow fact at the beginning
    // of any block, then the analysis has terminated
    if (!change) {
      done = true;
    }
  }
  if (DEBUG_LIVE_VREGS) {
    printf("Analysis finished in %u iterations\n", num_iters);
  }
}

const LiveVregs::LiveSet &LiveVregs::get_fact_at_end_of_block(BasicBlock *bb) const {
  return m_endfacts.at(bb->get_id());
}

const LiveVregs::LiveSet &LiveVregs::get_fact_at_beginning_of_block(BasicBlock *bb) const {
  return m_beginfacts.at(bb->get_id());
}

LiveVregs::LiveSet LiveVregs::get_fact_after_instruction(BasicBlock *bb, Instruction *ins) const {
  LiveSet live_set = m_endfacts[bb->get_id()];

  for (auto i = bb->crbegin(); i != bb->crend(); i++) {
    if (*i == ins) {
      break;
    }
    model_instruction(*i, live_set);
  }

  return live_set;
}

LiveVregs::LiveSet LiveVregs::get_fact_before_instruction(BasicBlock *bb, Instruction *ins) const {
  LiveSet live_set = m_endfacts[bb->get_id()];

  for (auto i = bb->crbegin(); i != bb->crend(); i++) {
    model_instruction(*i, live_set);
    if (*i == ins) {
      break;
    }
  }

  return live_set;
}

void LiveVregs::compute_iter_order() {
  // since this is a backwards problem,
  // desired iteration order is reverse postorder on
  // reversed CFG
  std::bitset<MAX_BLOCKS> visited;
  postorder_on_rcfg(visited, m_cfg->get_exit_block());
  std::reverse(m_iter_order.begin(), m_iter_order.end());
}

void LiveVregs::postorder_on_rcfg(std::bitset<LiveVregs::MAX_BLOCKS> &visited, BasicBlock *bb) {
  // already arrived at this block?
  if (visited.test(bb->get_id())) {
    return;
  }

  // this block is now guaranteed to be visited
  visited.set(bb->get_id());

  // recursively visit predecessors
  const ControlFlowGraph::EdgeList &incoming_edges = m_cfg->get_incoming_edges(bb);
  for (auto i = incoming_edges.begin(); i != incoming_edges.end(); i++) {
    Edge *e = *i;
    postorder_on_rcfg(visited, e->get_source());
  }

  // add this block to the order
  m_iter_order.push_back(bb->get_id());
}

void LiveVregs::model_instruction(Instruction *ins, LiveSet &fact) const {
  // Model an instruction (backwards).  If the instruction is a def,
  // it kills any vreg that was live.  Every use in the instruction
  // creates a live vreg (or keeps the vreg alive).

  if (HighLevel::is_def(ins)) {
    Operand operand = ins->get_operand(0);
    assert(operand.has_base_reg());
    fact.reset(operand.get_base_reg());
  }

  for (unsigned i = 0; i < ins->get_num_operands(); i++) {
    if (HighLevel::is_use(ins, i)) {
      Operand operand = ins->get_operand(i); 

      assert(operand.has_base_reg());
      fact.set(operand.get_base_reg());

      if (operand.has_index_reg()) {
        fact.set(operand.get_index_reg());
      }
    }
  }
}

LiveVregsControlFlowGraphPrinter::LiveVregsControlFlowGraphPrinter(ControlFlowGraph *cfg, LiveVregs *live_vregs)
  : HighLevelControlFlowGraphPrinter(cfg)
  , m_live_vregs(live_vregs) {
}

LiveVregsControlFlowGraphPrinter::~LiveVregsControlFlowGraphPrinter() {
}

void LiveVregsControlFlowGraphPrinter::print_basic_block(BasicBlock *bb) {
  printf("  Live at beginning: %s\n", format_set(m_live_vregs->get_fact_at_beginning_of_block(bb)).c_str());
  HighLevelControlFlowGraphPrinter::print_basic_block(bb);
  printf("  Live at end      : %s\n", format_set(m_live_vregs->get_fact_at_end_of_block(bb)).c_str());
}

std::string LiveVregsControlFlowGraphPrinter::format_instruction(BasicBlock *bb, Instruction *ins) {
  std::string s = HighLevelControlFlowGraphPrinter::format_instruction(bb, ins);
  unsigned len = unsigned(s.size());
  if (len < 39) {
    s += std::string(39 - len, ' ');
  }
  s += " ";
  s += format_set(m_live_vregs->get_fact_after_instruction(bb, ins));
  return s;
}

std::string LiveVregsControlFlowGraphPrinter::format_set(const LiveVregs::LiveSet &live_set) {
  std::string s;
  for (unsigned i = 0; i < LiveVregs::MAX_VREGS; i++) {
    if (live_set.test(i)) {
      if (!s.empty()) { s += ","; }
      s += std::to_string(i);
    }
  }
  return s;
}
