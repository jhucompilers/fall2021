#include <cassert>
#include "cfg.h"
#include "cfg_transform.h"

ControlFlowGraphTransform::ControlFlowGraphTransform(ControlFlowGraph *cfg)
  : m_cfg(cfg) {
}

ControlFlowGraphTransform::~ControlFlowGraphTransform() {
}

ControlFlowGraph *ControlFlowGraphTransform::get_orig_cfg() {
  return m_cfg;
}

ControlFlowGraph *ControlFlowGraphTransform::transform_cfg() {
  ControlFlowGraph *result = new ControlFlowGraph();

  // map of basic blocks of original CFG to basic blocks in transformed CFG
  std::map<BasicBlock *, BasicBlock *> block_map;

  // iterate over all basic blocks, transforming each one
  for (auto i = m_cfg->bb_begin(); i != m_cfg->bb_end(); i++) {
    BasicBlock *orig = *i;

    // transform the instructions
    InstructionSequence *result_iseq = transform_basic_block(orig);

    // create result basic block
    BasicBlock *result_bb = result->create_basic_block(orig->get_kind(), orig->get_label());
    block_map[orig] = result_bb;

    // copy instructions into result basic block
    for (auto j = result_iseq->cbegin(); j != result_iseq->cend(); j++) {
      result_bb->add_instruction((*j)->duplicate());
    }

    delete result_iseq;
  }

  // add edges to transformed CFG
  for (auto i = m_cfg->bb_begin(); i != m_cfg->bb_end(); i++) {
    BasicBlock *orig = *i;
    const ControlFlowGraph::EdgeList &outgoing_edges = m_cfg->get_outgoing_edges(orig);
    for (auto j = outgoing_edges.cbegin(); j != outgoing_edges.cend(); j++) {
      Edge *orig_edge = *j;

      BasicBlock *transformed_source = block_map[orig_edge->get_source()];
      BasicBlock *transformed_target = block_map[orig_edge->get_target()];

      result->create_edge(transformed_source, transformed_target, orig_edge->get_kind());
    }
  }

  return result;
}
