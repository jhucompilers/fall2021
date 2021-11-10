#include <cassert>
#include <cstdio>
#include <algorithm>
#include "cpputil.h"
#include "cfg.h"

////////////////////////////////////////////////////////////////////////
// Operand implementation
////////////////////////////////////////////////////////////////////////

Operand::Operand()
  : m_kind(OPERAND_NONE)
  , m_basereg(0)
  , m_indexreg(0)
  , m_ival(0)
 {
}

Operand::Operand(OperandKind kind, long ival)
  : m_kind(kind)
  , m_basereg(0)
  , m_indexreg(0)
  , m_ival(0) {
  assert(kind == OPERAND_VREG || kind == OPERAND_MREG ||
         kind == OPERAND_VREG_MEMREF || kind == OPERAND_MREG_MEMREF ||
         kind == OPERAND_INT_LITERAL);

  if (kind == OPERAND_INT_LITERAL) {
    m_ival = ival;
  } else {
    m_basereg = int(ival);
  }
}

Operand::Operand(OperandKind kind, int basereg, int offset_or_index)
  : m_kind(kind)
  , m_basereg(basereg)
  , m_indexreg(0)
  , m_ival(0) {
  assert(kind == OPERAND_VREG_MEMREF_OFFSET || kind == OPERAND_VREG_MEMREF_INDEX ||
         kind == OPERAND_MREG_MEMREF_OFFSET || kind == OPERAND_MREG_MEMREF_INDEX);

  if (kind == OPERAND_VREG_MEMREF_OFFSET || kind == OPERAND_MREG_MEMREF_OFFSET) {
    m_ival = offset_or_index;
  } else {
    m_indexreg = offset_or_index;
  }
}

Operand::Operand(OperandKind kind, int basereg, int indexreg, int offset)
  : m_kind(kind)
  , m_basereg(basereg)
  , m_indexreg(indexreg)
  , m_ival(offset) {
  // currently there is only one kind of reg+reg+offset operand
  assert(m_kind == OPERAND_MREG_MEMREF_OFFSET_INDEX);
}

Operand::Operand(const std::string &target_label, bool is_immediate)
  : m_kind(is_immediate ? OPERAND_LABEL_IMMEDIATE : OPERAND_LABEL)
  , m_basereg(0)
  , m_indexreg(0)
  , m_ival(0)
  , m_target_label(target_label) {
}

bool Operand::has_base_reg() const {
  return (m_kind & OPROP_HAS_BASEREG) != 0;
}

bool Operand::has_index_reg() const {
  return (m_kind & OPROP_HAS_INDEXREG) != 0;
}

int Operand::get_base_reg() const {
  assert(has_base_reg());
  return m_basereg;
}

int Operand::get_index_reg() const {
  assert(has_index_reg());
  return m_indexreg;
}

long Operand::get_int_value() const {
  assert(m_kind == OPERAND_INT_LITERAL);
  return m_ival;
}

int Operand::get_offset() const {
  assert((m_kind & OPROP_HAS_INTVAL) != 0 && (m_kind & OPROP_IS_MEMREF) != 0);
  return int(m_ival);
}

std::string Operand::get_target_label() const {
  assert((m_kind & OPROP_HAS_LABEL) != 0);
  return m_target_label;
}

////////////////////////////////////////////////////////////////////////
// Instruction implementation
////////////////////////////////////////////////////////////////////////

Instruction::Instruction(int opcode)
  : m_opcode(opcode)
  , m_num_operands(0) {
}

Instruction::Instruction(int opcode, Operand op1)
  : m_opcode(opcode)
  , m_num_operands(1) {
  m_operands[0] = op1;
}

Instruction::Instruction(int opcode, Operand op1, Operand op2)
  : m_opcode(opcode)
  , m_num_operands(2) {
  m_operands[0] = op1;
  m_operands[1] = op2;
}

Instruction::Instruction(int opcode, Operand op1, Operand op2, Operand op3)
  : m_opcode(opcode)
  , m_num_operands(3) {
  m_operands[0] = op1;
  m_operands[1] = op2;
  m_operands[2] = op3;
}

unsigned Instruction::get_num_operands() const {
  return m_num_operands;
}

Operand Instruction::get_operand(unsigned index) const {
  assert(index >= 0);
  assert(index < m_num_operands);
  return m_operands[index];
}

void Instruction::set_comment(const std::string &comment) {
  m_comment = comment;
}

bool Instruction::has_comment() const {
  return !m_comment.empty();
}

const std::string &Instruction::get_comment() const {
  return m_comment;
}

Instruction *Instruction::duplicate() const {
  return new Instruction(*this);
}

////////////////////////////////////////////////////////////////////////
// InstructionSequence implementation
////////////////////////////////////////////////////////////////////////

InstructionSequence::InstructionSequence() {
}

void InstructionSequence::add_instruction(Instruction *ins) {
  m_labels.push_back(m_next_label);
  m_instr_seq.push_back(ins);

  m_next_label = "";
}

void InstructionSequence::define_label(const std::string &label) {
  assert(m_next_label.empty());
  m_next_label = label;
  m_label_to_index[label] = unsigned(m_instr_seq.size());
}

void InstructionSequence::define_label_if_necessary(const std::string &label, Instruction *branch) {
  assert(branch->get_num_operands() == 1);
  assert((*branch)[0].get_target_label() == label);

  if (m_next_label.empty()) {
    // define the label
    define_label(label);
  } else {
    // use the existing label
    (*branch)[0] = Operand(m_next_label);
  }
}

Instruction *InstructionSequence::get_labeled_instruction(const std::string &label) const {
  auto i = m_label_to_index.find(label);
  if (i == m_label_to_index.cend()) {
    // nonexistent label
    return nullptr;
  }
  unsigned index = i->second;
  assert(index < unsigned(m_instr_seq.size()));
  return m_instr_seq[index];
}

unsigned InstructionSequence::get_index_of_labeled_instruction(const std::string &label) const {
  auto i = m_label_to_index.find(label);
  assert(i != m_label_to_index.cend());
  return i->second;
}

unsigned InstructionSequence::get_length() const {
  return unsigned(m_instr_seq.size());
}

Instruction *InstructionSequence::get_instruction(unsigned index) const {
  assert(index < unsigned(m_instr_seq.size()));
  return m_instr_seq[index];
}

Instruction *InstructionSequence::get_last() const {
  assert(!m_instr_seq.empty());
  return m_instr_seq.back();
}

bool InstructionSequence::has_label(unsigned index) const {
/*
  assert(index < unsigned(m_instr_seq.size()));
  return !m_labels[index].empty();
*/
  if (index == unsigned(m_instr_seq.size())) {
    return has_label_at_end();
  } else {
    return !m_labels[index].empty();
  }
}

std::string InstructionSequence::get_label(unsigned index) const {
  assert(has_label(index));
  return m_labels[index];
}

bool InstructionSequence::has_label_at_end() const {
  return !m_next_label.empty();
}

std::string InstructionSequence::get_label_at_end() const {
  assert(has_label_at_end());
  return m_next_label;
}

////////////////////////////////////////////////////////////////////////
// PrintInstructionSequence implementation 
////////////////////////////////////////////////////////////////////////

PrintInstructionSequence::PrintInstructionSequence(InstructionSequence *iseq)
  : m_iseq(iseq) {
}

std::string PrintInstructionSequence::format_instruction(const Instruction *ins) {
  std::string formatted_ins;
  formatted_ins += get_opcode_name(ins->get_opcode());
  formatted_ins += " ";
  for (unsigned j = 0; j < ins->get_num_operands(); j++) {
    Operand operand = ins->get_operand(j);
    if (j > 0) {
      formatted_ins += ", ";
    }
    formatted_ins += format_operand(operand);
  }
  unsigned len(formatted_ins.size());
  if (ins->has_comment()) {
    for (unsigned i = len; i < 28; i++) {
      formatted_ins += ' ';
    }
    formatted_ins += "/* ";
    formatted_ins += ins->get_comment();
    formatted_ins += " */";
  }
  return formatted_ins;
}

void PrintInstructionSequence::print() {
  for (unsigned i = 0; i < m_iseq->get_length(); i++) {
    if (m_iseq->has_label(i)) {
      std::string label = m_iseq->get_label(i);
      printf("%s:\n", label.c_str());
    }
    Instruction *ins = m_iseq->get_instruction(i);
    std::string formatted_ins = format_instruction(ins);
    printf("\t%s\n", formatted_ins.c_str());
  }

  // special case: if there is a label at the end, print it
  if (m_iseq->has_label_at_end()) {
    printf("%s:\n", m_iseq->get_label_at_end().c_str());
  }
}

std::string PrintInstructionSequence::format_operand(const Operand &operand) {
  assert(operand.get_kind() != OPERAND_NONE);

  switch (operand.get_kind()) {
  case OPERAND_VREG:
    return cpputil::format("vr%d", operand.get_base_reg());
  case OPERAND_VREG_MEMREF:
    return cpputil::format("(vr%d)", operand.get_base_reg());
  case OPERAND_VREG_MEMREF_OFFSET:
    return cpputil::format("%d(vr%d)", operand.get_offset(), operand.get_base_reg());
  case OPERAND_VREG_MEMREF_INDEX:
    return cpputil::format("(vr%d,vr%d)", operand.get_base_reg(), operand.get_index_reg());
  case OPERAND_MREG:
    return get_mreg_name(operand.get_base_reg());
  case OPERAND_MREG_MEMREF:
    return cpputil::format("(%s)", get_mreg_name(operand.get_base_reg()).c_str());
  case OPERAND_MREG_MEMREF_OFFSET:
    return cpputil::format("%d(%s)", operand.get_offset(), get_mreg_name(operand.get_base_reg()).c_str());
  case OPERAND_MREG_MEMREF_INDEX:
    return cpputil::format("(%s,%s)",
                           get_mreg_name(operand.get_base_reg()).c_str(),
                           get_mreg_name(operand.get_index_reg()).c_str());
  case OPERAND_MREG_MEMREF_OFFSET_INDEX:
    return cpputil::format("%d(%s, %s)",
                           operand.get_offset(),
                           get_mreg_name(operand.get_base_reg()).c_str(),
                           get_mreg_name(operand.get_index_reg()).c_str());
  case OPERAND_INT_LITERAL:
    return cpputil::format("$%ld", operand.get_int_value());
  case OPERAND_LABEL:
    return operand.get_target_label();
  case OPERAND_LABEL_IMMEDIATE:
    return "$" + operand.get_target_label();
  default:
    assert(false);
    return "<invalid>";
  }
}

////////////////////////////////////////////////////////////////////////
// BasicBlock implementation
////////////////////////////////////////////////////////////////////////

BasicBlock::BasicBlock(BasicBlockKind kind, unsigned id, const std::string &label)
  : m_kind(kind)
  , m_id(id)
  , m_label(label) {
}

BasicBlock::~BasicBlock() {
}

BasicBlockKind BasicBlock::get_kind() const {
  return m_kind;
}

unsigned BasicBlock::get_id() const {
  return m_id;
}

bool BasicBlock::has_label() const {
  return !m_label.empty();
}

std::string BasicBlock::get_label() const {
  return m_label;
}

void BasicBlock::set_label(const std::string &label) {
  assert(!has_label());
  m_label = label;
}

////////////////////////////////////////////////////////////////////////
// Edge implementation
////////////////////////////////////////////////////////////////////////

Edge::Edge(BasicBlock *source, BasicBlock *target, EdgeKind kind)
  : m_kind(kind)
  , m_source(source)
  , m_target(target) {
}

Edge::~Edge() {
}

////////////////////////////////////////////////////////////////////////
// ControlFlowGraph implementation
////////////////////////////////////////////////////////////////////////

ControlFlowGraph::ControlFlowGraph()
  : m_entry(nullptr)
  , m_exit(nullptr) {
}

ControlFlowGraph::~ControlFlowGraph() {
}

BasicBlock *ControlFlowGraph::get_entry_block() const {
  return m_entry;
}

BasicBlock *ControlFlowGraph::get_exit_block() const {
  return m_exit;
}

BasicBlock *ControlFlowGraph::create_basic_block(BasicBlockKind kind, const std::string &label) {
  BasicBlock *bb = new BasicBlock(kind, unsigned(m_basic_blocks.size()), label);
  m_basic_blocks.push_back(bb);
  if (bb->get_kind() == BASICBLOCK_ENTRY) {
    assert(m_entry == nullptr);
    m_entry = bb;
  }
  if (bb->get_kind() == BASICBLOCK_EXIT) {
    assert(m_exit == nullptr);
    m_exit = bb;
  }
  return bb;
}

Edge *ControlFlowGraph::create_edge(BasicBlock *source, BasicBlock *target, EdgeKind kind) {
  // make sure BasicBlocks belong to this ControlFlowGraph
  assert(std::find(m_basic_blocks.begin(), m_basic_blocks.end(), source) != m_basic_blocks.end());
  assert(std::find(m_basic_blocks.begin(), m_basic_blocks.end(), target) != m_basic_blocks.end());

  // make sure this Edge doesn't already exist
  assert(lookup_edge(source, target) == nullptr);

  // create the edge, add it to outgoing/incoming edge maps
  Edge *e = new Edge(source, target, kind);
  m_outgoing_edges[source].push_back(e);
  m_incoming_edges[target].push_back(e);

  return e;
}

Edge *ControlFlowGraph::lookup_edge(BasicBlock *source, BasicBlock *target) const {
  auto i = m_outgoing_edges.find(source);
  if (i == m_outgoing_edges.cend()) {
    return nullptr;
  }
  const EdgeList &outgoing = i->second;
  for (auto j = outgoing.cbegin(); j != outgoing.cend(); j++) {
    Edge *e = *j;
    assert(e->get_source() == source);
    if (e->get_target() == target) {
      return e;
    }
  }
  return nullptr;
}

const ControlFlowGraph::EdgeList &ControlFlowGraph::get_outgoing_edges(BasicBlock *bb) const {
  EdgeMap::const_iterator i = m_outgoing_edges.find(bb);
  return i == m_outgoing_edges.end() ? m_empty_edge_list : i->second;
}

const ControlFlowGraph::EdgeList &ControlFlowGraph::get_incoming_edges(BasicBlock *bb) const {
  EdgeMap::const_iterator i = m_incoming_edges.find(bb);
  return i == m_incoming_edges.end() ? m_empty_edge_list : i->second;
}

InstructionSequence *ControlFlowGraph::create_instruction_sequence() const {
  assert(m_entry != nullptr);
  assert(m_exit != nullptr);
  assert(m_outgoing_edges.size() == m_incoming_edges.size());

  // Find all Chunks (groups of basic blocks connected via fall-through)
  typedef std::map<BasicBlock *, Chunk *> ChunkMap;
  ChunkMap chunk_map;
  for (auto i = m_outgoing_edges.cbegin(); i != m_outgoing_edges.cend(); i++) {
    const EdgeList &outgoing_edges = i->second;
    for (auto j = outgoing_edges.cbegin(); j != outgoing_edges.cend(); j++) {
      Edge *e = *j;

      if (e->get_kind() != EDGE_FALLTHROUGH) {
        continue;
      }

      BasicBlock *pred = e->get_source();
      BasicBlock *succ = e->get_target();

      Chunk *pred_chunk = (chunk_map.find(pred) == chunk_map.end()) ? nullptr : chunk_map[pred];
      Chunk *succ_chunk = (chunk_map.find(succ) == chunk_map.end()) ? nullptr : chunk_map[succ];

      if (pred_chunk == nullptr && succ_chunk == nullptr) {
        // create a new chunk
        Chunk *chunk = new Chunk();
        chunk->append(pred);
        chunk->append(succ);
        chunk_map[pred] = chunk;
        chunk_map[succ] = chunk;
      } else if (pred_chunk == nullptr) {
        // prepend predecessor to successor's chunk (successor should be the first block)
        assert(succ_chunk->is_first(succ));
        succ_chunk->prepend(pred);
        chunk_map[pred] = succ_chunk;
      } else if (succ_chunk == nullptr) {
        // append successor to predecessor's chunk (predecessor should be the last block)
        assert(pred_chunk->is_last(pred));
        pred_chunk->append(succ);
        chunk_map[succ] = pred_chunk;
      } else {
        // merge the chunks
        Chunk *merged = pred_chunk->merge_with(succ_chunk);
        // update every basic block to point to the merged chunk
        for (auto i = merged->blocks.begin(); i != merged->blocks.end(); i++) {
          BasicBlock *bb = *i;
          chunk_map[bb] = merged;
        }
        // delete old Chunks
        delete pred_chunk;
        delete succ_chunk;
      }
    }
  }

  InstructionSequence *result = new InstructionSequence();
  std::vector<bool> finished_blocks(get_num_blocks(), false);
  Chunk *exit_chunk = nullptr;

  // Traverse the CFG, appending basic blocks to the generated InstructionSequence.
  // If we find a block that is part of a Chunk, the entire Chunk is emitted.
  // (This allows fall through to work.)
  std::deque<BasicBlock *> work_list;
  work_list.push_back(m_entry);

  while (!work_list.empty()) {
    BasicBlock *bb = work_list.front();
    work_list.pop_front();
    unsigned block_id = bb->get_id();

    if (finished_blocks[block_id]) {
      // already added this block
      continue;
    }

    ChunkMap::iterator i = chunk_map.find(bb);
    if (i != chunk_map.end()) {
      // This basic block is part of a Chunk: append all of its blocks
      Chunk *chunk = i->second;

      // If this chunk contains the exit block, it needs to be at the end
      // of the generated InstructionSequence, so defer appending any of
      // its blocks.  (But, *do* find its control successors.)
      bool is_exit_chunk = false;
      if (chunk->contains_exit_block()) {
        exit_chunk = chunk;
        is_exit_chunk = true;
      }

      for (auto j = chunk->blocks.begin(); j != chunk->blocks.end(); j++) {
        BasicBlock *b = *j;
        if (is_exit_chunk) {
          // mark the block as finished, but don't append its instructions yet
          finished_blocks[b->get_id()] = true;
        } else {
          append_basic_block(result, b, finished_blocks);
        }

        // Visit control successors
        visit_successors(b, work_list);
      }
    } else {
      // This basic block is not part of a Chunk
      append_basic_block(result, bb, finished_blocks);

      // Visit control successors
      visit_successors(bb, work_list);
    }
  }

  // append exit chunk
  if (exit_chunk != nullptr) {
    append_chunk(result, exit_chunk, finished_blocks);
  }

  return result;
}

void ControlFlowGraph::append_basic_block(InstructionSequence *iseq, const BasicBlock *bb, std::vector<bool> &finished_blocks) const {
  if (bb->has_label()) {
    iseq->define_label(bb->get_label());
  }
  for (auto i = bb->cbegin(); i != bb->cend(); i++) {
    iseq->add_instruction((*i)->duplicate());
  }
  finished_blocks[bb->get_id()] = true;
}

void ControlFlowGraph::append_chunk(InstructionSequence *iseq, Chunk *chunk, std::vector<bool> &finished_blocks) const {
  for (auto i = chunk->blocks.begin(); i != chunk->blocks.end(); i++) {
    append_basic_block(iseq, *i, finished_blocks);
  }
}

void ControlFlowGraph::visit_successors(BasicBlock *bb, std::deque<BasicBlock *> &work_list) const {
  const EdgeList &outgoing_edges = get_outgoing_edges(bb);
  for (auto k = outgoing_edges.cbegin(); k != outgoing_edges.cend(); k++) {
    Edge *e = *k;
    work_list.push_back(e->get_target());
  }
}

////////////////////////////////////////////////////////////////////////
// ControlFlowGraphBuilder implementation
////////////////////////////////////////////////////////////////////////

ControlFlowGraphBuilder::ControlFlowGraphBuilder(InstructionSequence *iseq)
  : m_iseq(iseq)
  , m_cfg(new ControlFlowGraph()) {
}

ControlFlowGraphBuilder::~ControlFlowGraphBuilder() {
}

ControlFlowGraph *ControlFlowGraphBuilder::build() {
  unsigned num_instructions = m_iseq->get_length();

  BasicBlock *entry = m_cfg->create_basic_block(BASICBLOCK_ENTRY);
  BasicBlock *exit = m_cfg->create_basic_block(BASICBLOCK_EXIT);

  // exit block is reached by any branch that targets the end of the
  // InstructionSequence
  m_basic_blocks[num_instructions] = exit;

  std::deque<WorkItem> work_list;
  work_list.push_back({ ins_index: 0, pred: entry, edge_kind: EDGE_FALLTHROUGH });

  BasicBlock *last = nullptr;
  while (!work_list.empty()) {
    WorkItem item = work_list.front();
    work_list.pop_front();

    assert(item.ins_index <= m_iseq->get_length());

    // if item target is end of InstructionSequence, then it targets the exit block
    if (item.ins_index == m_iseq->get_length()) {
      m_cfg->create_edge(item.pred, exit, item.edge_kind);
      continue;
    }

    BasicBlock *bb;
    bool is_new_block;
    std::map<unsigned, BasicBlock *>::iterator i = m_basic_blocks.find(item.ins_index);
    if (i != m_basic_blocks.end()) {
      // a block starting at this instruction already exists
      bb = i->second;
      is_new_block = false;

      // Special case: if this block was originally discovered via a fall-through
      // edge, but is also reachable via a branch, then it might not be labeled
      // yet.  Set the label if necessary.
      if (item.edge_kind == EDGE_BRANCH && !bb->has_label()) {
        bb->set_label(item.label);
      }
    } else {
      // no block starting at this instruction currently exists:
      // scan the basic block and add it to the map of known basic blocks
      // (indexed by instruction index)
      bb = scan_basic_block(item, item.label);
      is_new_block = true;
      m_basic_blocks[item.ins_index] = bb;
    }

    // if the edge is a branch, make sure the work item's label matches
    // the BasicBlock's label (if it doesn't, then somehow this block
    // is reachable via two different labels, which shouldn't be possible)
    assert(item.edge_kind != EDGE_BRANCH || bb->get_label() == item.label);

    // connect to predecessor
    m_cfg->create_edge(item.pred, bb, item.edge_kind);

    if (!is_new_block) {
      // we've seen this block already
      continue;
    }

    // if this basic block ends in a branch, prepare to create an edge
    // to the BasicBlock for the target (creating the BasicBlock if it
    // doesn't exist yet)
    if (ends_in_branch(bb)) {
      unsigned target_index = get_branch_target_index(bb);
      // Note: we assume that branch instructions have a single Operand,
      // which is a label
      Instruction *branch = bb->get_last();
      assert(branch->get_num_operands() == 1);
      Operand operand = (*branch)[0];
      assert(operand.get_kind() == OPERAND_LABEL);
      std::string target_label = operand.get_target_label();
      work_list.push_back({ ins_index: target_index, pred: bb, edge_kind: EDGE_BRANCH, label: target_label });
    }

    // if this basic block falls through, prepare to create an edge
    // to the BasicBlock for successor instruction (creating it if it doesn't
    // exist yet)
    if (falls_through(bb)) {
      unsigned target_index = item.ins_index + bb->get_length();
      assert(target_index <= m_iseq->get_length());
      if (target_index == num_instructions) {
        // this is the basic block at the end of the instruction sequence,
        // its fall-through successor should be the exit block
        last = bb;
      } else {
        // fall through to basic block starting at successor instruction
        work_list.push_back({ ins_index: target_index, pred: bb, edge_kind: EDGE_FALLTHROUGH });
      }
    }
  }

  assert(last != nullptr);
  m_cfg->create_edge(last, exit, EDGE_FALLTHROUGH);

  return m_cfg;
}

// Note that subclasses may override this method.
bool ControlFlowGraphBuilder::is_branch(Instruction *ins) {
  // assume that any branch instruction will have a single operand which is
  // a label
  return (ins->get_num_operands() != 1) ? false : (*ins)[0].get_kind() == OPERAND_LABEL;
}

BasicBlock *ControlFlowGraphBuilder::scan_basic_block(const WorkItem &item, const std::string &label) {
  unsigned index = item.ins_index;

  BasicBlock *bb = m_cfg->create_basic_block(BASICBLOCK_INTERIOR, label);

  // keep adding instructions until we
  // - reach an instruction that is a branch
  // - reach an instruction that is a target of a branch
  // - reach the end of the overall instruction sequence
  while (index < m_iseq->get_length()) {
    Instruction *ins = m_iseq->get_instruction(index);

    // this instruction is part of the basic block
    ins = ins->duplicate();
    bb->add_instruction(ins);
    index++;

    if (m_iseq->has_label(index)) {
      // instruction at index is a control target
      break;
    }
    if (is_branch(ins)) {
      // this is a branch instruction
      break;
    }
  }

  assert(bb->get_length() > 0);

  return bb;
}

bool ControlFlowGraphBuilder::ends_in_branch(BasicBlock *bb) {
  return is_branch(bb->get_last());
}

unsigned ControlFlowGraphBuilder::get_branch_target_index(BasicBlock *bb) {
  assert(ends_in_branch(bb));
  Instruction *last = bb->get_last();

  // assume that any branch instruction will have a single operand which is
  // a label
  assert(last->get_num_operands() == 1);
  Operand label = (*last)[0];
  assert(label.get_kind() == OPERAND_LABEL);

  // look up the index of the instruction targeted by this label
  unsigned target_index = m_iseq->get_index_of_labeled_instruction(label.get_target_label());
  return target_index;
}

bool ControlFlowGraphBuilder::falls_through(BasicBlock *bb) {
  return falls_through(bb->get_last());
}

////////////////////////////////////////////////////////////////////////
// ControlFlowGraphPrinter implementation
////////////////////////////////////////////////////////////////////////

ControlFlowGraphPrinter::ControlFlowGraphPrinter(ControlFlowGraph *cfg)
  : m_cfg(cfg) {
}

ControlFlowGraphPrinter::~ControlFlowGraphPrinter() {
}

void ControlFlowGraphPrinter::print() {
  for (auto i = m_cfg->bb_begin(); i != m_cfg->bb_end(); i++) {
    BasicBlock *bb = *i;
    printf("BASIC BLOCK %u", bb->get_id());
    BasicBlockKind bb_kind = bb->get_kind();
    if (bb_kind != BASICBLOCK_INTERIOR) {
      printf(" %s", bb_kind == BASICBLOCK_ENTRY ? "[entry]" : "[exit]");
    }
    if (bb->has_label()) {
      printf(" (label %s)", bb->get_label().c_str());
    }
    printf("\n");
    print_basic_block(bb);
    const ControlFlowGraph::EdgeList &outgoing_edges = m_cfg->get_outgoing_edges(bb);
    for (auto j = outgoing_edges.cbegin(); j != outgoing_edges.cend(); j++) {
      const Edge *e = *j;
      assert(e->get_kind() == EDGE_BRANCH || e->get_kind() == EDGE_FALLTHROUGH);
      printf("  %s EDGE to BASIC BLOCK %u\n", e->get_kind() == EDGE_FALLTHROUGH ? "fall-through" : "branch", e->get_target()->get_id());
    }
    printf("\n");
  }
}
