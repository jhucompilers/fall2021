#ifndef CFG_H
#define CFG_H

#include <cassert>
#include <vector>
#include <map>
#include <deque>
#include <string>

// "Properties" that an OperandKind can have.
// These are encoded into the ordinal value.  Because
// they occupy unique bits in the ordinal representation,
// their presence can be detected using bitwise AND (&).
enum OperandProperty {
  OPROP_HAS_BASEREG  = (1 << 16),
  OPROP_HAS_INTVAL   = (1 << 17),
  OPROP_HAS_INDEXREG = (1 << 18),
  OPROP_HAS_LABEL    = (1 << 19),
  OPROP_IS_IMMEDIATE = (1 << 20),
  OPROP_IS_MEMREF    = (1 << 21),
};

enum OperandKind {
  // used for invalid/nonexistent operands
  OPERAND_NONE                    =  1,
  // "virtual" register (vreg)
  OPERAND_VREG                    = (OPROP_HAS_BASEREG) + 2 ,
  // machine register (mreg)
  OPERAND_MREG                    = (OPROP_HAS_BASEREG) + 3,
  // memory reference with address specified by vreg
  OPERAND_VREG_MEMREF             = (OPROP_HAS_BASEREG|OPROP_IS_MEMREF) + 4,
  // memory reference with address specified by vreg+offset
  OPERAND_VREG_MEMREF_OFFSET      = (OPROP_HAS_BASEREG|OPROP_HAS_INTVAL|OPROP_IS_MEMREF) + 5,
  // memory reference with address specified by vreg+vref
  OPERAND_VREG_MEMREF_INDEX       = (OPROP_HAS_BASEREG|OPROP_HAS_INDEXREG|OPROP_IS_MEMREF) + 6,
  // memory reference with address specified by mreg
  OPERAND_MREG_MEMREF             = (OPROP_HAS_BASEREG|OPROP_IS_MEMREF) + 7,
  // memory reference with address specified by mreg+offset
  OPERAND_MREG_MEMREF_OFFSET      = (OPROP_HAS_BASEREG|OPROP_HAS_INTVAL|OPROP_IS_MEMREF) + 8,
  // memory reference with address specified by mreg+mreg
  OPERAND_MREG_MEMREF_INDEX       = (OPROP_HAS_BASEREG|OPROP_HAS_INDEXREG|OPROP_IS_MEMREF) + 9,
  // memory reference with address specified by mreg+mreg+offset
  OPERAND_MREG_MEMREF_OFFSET_INDEX = (OPROP_HAS_BASEREG|OPROP_HAS_INDEXREG|OPROP_HAS_INTVAL|OPROP_IS_MEMREF) + 10,
  // integer literal
  OPERAND_INT_LITERAL             = (OPROP_HAS_INTVAL|OPROP_IS_IMMEDIATE) + 11,
  // symbolic label
  OPERAND_LABEL                   = (OPROP_HAS_LABEL) + 12,
  // label used as an immediate operand
  OPERAND_LABEL_IMMEDIATE         = (OPROP_HAS_LABEL|OPROP_IS_IMMEDIATE) + 13,
};

struct Operand {
private:
  enum OperandKind m_kind;    // kind of operand
  int m_basereg;              // base register number
  int m_indexreg;             // index register number
  long m_ival;                // literal integer value or offset value
  std::string m_target_label;

public:
  // default ctor, creates invalid Operand
  Operand();

  // ctor for Operand with a single register or integer value
  // (e.g., OPERAND_VREG, OPERAND_MREG, OPERAND_INT_LITERAL)
  // Parameters:
  //   - kind: the OperandKind
  //   - ival: either a register number or a literal integer value
  Operand(OperandKind kind, long ival);

  // ctor for Operand with reg+integer or reg+reg
  // (e.g., OPERAND_VREG_MEMREF_OFFSET, OPERAND_VREG_MEMREF_INDEX,
  // OPERAND_MREG_MEMREF_OFFSET, OPERAND_MREG_MEMREF_INDEX)
  // Parameters:
  //   - kind: the OperandKind
  //   - basereg: base register number
  //   - offset_or_index: either the integer offset value or index register number
  Operand(OperandKind kind, int basereg, int offset_or_index);

  // ctor for Operand with reg+reg+integer
  // (e.g., OPERAND_MREG_MEMREF_OFFSET_INDEX)
  // Parameters:
  //   - kind: the OperandKind
  //   - basereg: base register number
  //   - indexreg: index register number
  //   - offset: offset value
  Operand(OperandKind kind, int basereg, int indexreg, int offset);

  // ctor for label
  // (e.g., OPERAND_LABEL, OPERAND_LABEL_IMMEDIATE)
  // Parameters:
  Operand(const std::string &target_label, bool is_immediate = false);

  OperandKind get_kind() const { return m_kind; }

  // does this Operand have a base register?
  bool has_base_reg() const;

  // does this Operand have an index register?
  bool has_index_reg() const;

  // is this operand a memory reference?
  bool is_memref() const { return (m_kind & OPROP_IS_MEMREF) != 0; }

  // Convert a register into a memory reference
  Operand to_memref() {
    assert(m_kind == OPERAND_VREG || m_kind == OPERAND_MREG);
    Operand memref(*this);
    memref.m_kind = (m_kind == OPERAND_VREG) ? OPERAND_VREG_MEMREF : OPERAND_MREG_MEMREF;
    return memref;
  }

  // get base register number
  int get_base_reg() const;

  // get index register number
  int get_index_reg() const;

  // get literal integer value
  long get_int_value() const;

  // get offset
  int get_offset() const;

  // get target label name
  std::string get_target_label() const;
};

class Instruction {
private:
  int m_opcode;
  unsigned m_num_operands;
  Operand m_operands[3];
  std::string m_comment;

public:
  Instruction(int opcode);
  Instruction(int opcode, Operand op1);
  Instruction(int opcode, Operand op1, Operand op2);
  Instruction(int opcode, Operand op1, Operand op2, Operand op3);

  int get_opcode() const { return m_opcode; }

  unsigned get_num_operands() const;
  Operand get_operand(unsigned index) const;

  // more convenient notation for referring to operand
  Operand operator[](unsigned index) const {
    assert(index < m_num_operands);
    return m_operands[index];
  }

  // this operator can be used for changing an operand in place;
  // useful in cases where a jump instruction needs to be changed to
  // a different target
  Operand &operator[](unsigned index) {
    assert(index < m_num_operands);
    return m_operands[index];
  }

  void set_comment(const std::string &comment);
  bool has_comment() const;
  const std::string &get_comment() const;

  // create an exact duplicate of this Instruction
  Instruction *duplicate() const;
};

class InstructionSequence {
private:
  std::vector<Instruction *> m_instr_seq;

  // vector of labels (corresponding to instruction indices)
  std::vector<std::string> m_labels;

  // map of label names to instruction indices
  std::map<std::string, unsigned> m_label_to_index;

  // this will be set of the next instruction should be labeled
  std::string m_next_label;

public:
  typedef std::vector<Instruction *>::iterator iterator;
  typedef std::vector<Instruction *>::const_iterator const_iterator;

  InstructionSequence();

  void add_instruction(Instruction *ins);

  // define label to refer to the next instruction to be added
  // to the InstructionSequence; note that at most ONE label
  // should be added to a particular instruction
  void define_label(const std::string &label);

  // define a label if necessary: if there already is an active label
  // at the current position, then update the specified Instruction
  // to use it
  void define_label_if_necessary(const std::string &label, Instruction *branch);

  // get the instruction labeled by the given label
  Instruction *get_labeled_instruction(const std::string &label) const;

  // get the index of the instruction labeled by given label
  unsigned get_index_of_labeled_instruction(const std::string &label) const;

  // get the number of instructions
  unsigned get_length() const;

  // get instruction at specified index
  Instruction *get_instruction(unsigned index) const;

  // get last instruction
  Instruction *get_last() const;

  // determine whether instruction at specified index is labeled
  bool has_label(unsigned index) const;

  // get the label at specified index: returns empty string if there is
  // no label at the index
  std::string get_label(unsigned index) const;

  // returns true if there is a label at the end of the instruction
  // sequence (i.e., not labeling any actual Instruction)
  bool has_label_at_end() const;

  // get the label at the end
  std::string get_label_at_end() const;

  iterator begin() { return m_instr_seq.begin(); }
  iterator end() { return m_instr_seq.end(); }
  const_iterator cbegin() const { return m_instr_seq.cbegin(); }
  const_iterator cend() const { return m_instr_seq.cend(); }
};

// For debugging: print a textual representation of an InstructionSequence
class PrintInstructionSequence {
private:
  // disallow copy ctor and assignment operator
  PrintInstructionSequence(const PrintInstructionSequence &);
  PrintInstructionSequence &operator=(const PrintInstructionSequence &);

  InstructionSequence *m_iseq;

public:
  PrintInstructionSequence(InstructionSequence *iseq);

  // subclasses must override the following member functions
  virtual std::string get_opcode_name(int opcode) = 0;
  virtual std::string get_mreg_name(int regnum) = 0;

  std::string format_instruction(const Instruction *ins);

  void print();

private:
  std::string format_operand(const Operand &operand);
};

enum BasicBlockKind {
  BASICBLOCK_ENTRY,     // special "entry" block
  BASICBLOCK_EXIT,      // special "exit" block
  BASICBLOCK_INTERIOR,  // normal basic block in the "interior" of the CFG
};

// A BasicBlock is an InstructionSequence in which only the last instruction
// can be a branch.
class BasicBlock : public InstructionSequence {
private:
  BasicBlockKind m_kind;
  unsigned m_id;
  std::string m_label;

public:
  BasicBlock(BasicBlockKind kind, unsigned id, const std::string &label = "");
  ~BasicBlock();

  BasicBlockKind get_kind() const;
  unsigned get_id() const;

  bool has_label() const;
  std::string get_label() const;

  // it is sometimes necessary to set a BasicBlock's label after it is created
  void set_label(const std::string &label);
};

// Edges can be
//   - "fall through", meaning the target block's first instruction
//     follows the source block's last instruction in the original
//     InstructionSequence
//   - "branch", meaning that the target BasicBlock's first instruction
//     is *not* the immediate successor of the source block's last instruction
enum EdgeKind {
  EDGE_FALLTHROUGH,
  EDGE_BRANCH,
};

// An Edge is a predecessor/successor connection between a source BasicBlock
// and a target BasicBlock.
class Edge {
private:
  EdgeKind m_kind;
  BasicBlock *m_source, *m_target;

public:
  Edge(BasicBlock *source, BasicBlock *target, EdgeKind kind);
  ~Edge();

  EdgeKind get_kind() const { return m_kind; }
  BasicBlock *get_source() const { return m_source; }
  BasicBlock *get_target() const { return m_target; }
};

// ControlFlowGraph: graph of BasicBlocks connected by Edges.
// There are dedicated empty entry and exit blocks.
class ControlFlowGraph {
public:
  typedef std::vector<BasicBlock *> BlockList;
  typedef std::vector<Edge *> EdgeList;
  typedef std::map<BasicBlock *, EdgeList> EdgeMap;

private:
  BlockList m_basic_blocks;
  BasicBlock *m_entry, *m_exit;
  EdgeMap m_incoming_edges;
  EdgeMap m_outgoing_edges;
  EdgeList m_empty_edge_list;

  // A "Chunk" is a collection of BasicBlocks
  // connected by fall-through edges.  All of the blocks
  // in a Chunk must be emitted contiguously in the
  // resulting InstructionSequence when the CFG is flattened.
  struct Chunk {
    ControlFlowGraph::BlockList blocks;
    bool is_exit;

    void append(BasicBlock *bb) {
      blocks.push_back(bb);
      if (bb->get_kind() == BASICBLOCK_EXIT) { is_exit = true; }
    }
    void prepend(BasicBlock *bb) {
      blocks.insert(blocks.begin(), bb);
      if (bb->get_kind() == BASICBLOCK_EXIT) { is_exit = true; }
    }

    Chunk *merge_with(Chunk *other) {
      Chunk *merged = new Chunk();
      for (auto i = blocks.begin(); i != blocks.end(); i++) {
        merged->append(*i);
      }
      for (auto i = other->blocks.begin(); i != other->blocks.end(); i++) {
        merged->append(*i);
      }
      return merged;
    }

    bool is_first(BasicBlock *bb) const {
      return !blocks.empty() && blocks.front() == bb;
    }

    bool is_last(BasicBlock *bb) const {
      return !blocks.empty() && blocks.back() == bb;
    }

    bool contains_exit_block() const { return is_exit; }
  };

public:
  ControlFlowGraph();
  ~ControlFlowGraph();

  // get total number of BasicBlocks (including entry and exit)
  unsigned get_num_blocks() const { return unsigned(m_basic_blocks.size()); }

  // Get pointer to the dedicated empty entry block
  BasicBlock *get_entry_block() const;

  // Get pointer to the dedicated empty exit block
  BasicBlock *get_exit_block() const;

  // iterator over pointers to BasicBlocks
  BlockList::const_iterator bb_begin() const { return m_basic_blocks.cbegin(); }
  BlockList::const_iterator bb_end() const   { return m_basic_blocks.cend(); }

  // Create a new BasicBlock: use BASICBLOCK_INTERIOR for all blocks
  // except for entry and exit. The label parameter should be a non-empty
  // string if the BasicBlock is reached via one or more branch instructions
  // (which should have this label as their Operand.)
  BasicBlock *create_basic_block(BasicBlockKind kind, const std::string &label = "");

  // Create Edge of given kind from source to target
  Edge *create_edge(BasicBlock *source, BasicBlock *target, EdgeKind kind);

  // Look up edge from specified source block to target block:
  // returns a null pointer if no such block exists
  Edge *lookup_edge(BasicBlock *source, BasicBlock *target) const;

  // Get vector of all outgoing edges from given block
  const EdgeList &get_outgoing_edges(BasicBlock *bb) const;

  // Get vector of all incoming edges to given block
  const EdgeList &get_incoming_edges(BasicBlock *bb) const;

  // Return a "flat" InstructionSequence created from this ControlFlowGraph;
  // this is useful for optimization passes which create a transformed ControlFlowGraph
  InstructionSequence *create_instruction_sequence() const;

private:
  void append_basic_block(InstructionSequence *iseq, const BasicBlock *bb, std::vector<bool> &finished_blocks) const;
  void append_chunk(InstructionSequence *iseq, Chunk *chunk, std::vector<bool> &finished_blocks) const;
  void visit_successors(BasicBlock *bb, std::deque<BasicBlock *> &work_list) const;
};

class ControlFlowGraphBuilder {
private:
  InstructionSequence *m_iseq;
  ControlFlowGraph *m_cfg;
  // map of instruction index to pointer to BasicBlock starting at that instruction
  std::map<unsigned, BasicBlock *> m_basic_blocks;

  struct WorkItem {
    unsigned ins_index;
    BasicBlock *pred;
    EdgeKind edge_kind;
    std::string label;
  };

public:
  ControlFlowGraphBuilder(InstructionSequence *iseq);
  virtual ~ControlFlowGraphBuilder();

  // Build a ControlFlowGraph from the original InstructionSequence, and return
  // a pointer to it
  ControlFlowGraph *build();

  // Subclasses may override this method to specify which Instructions are
  // branches (i.e., have a control successor other than the next instruction
  // in the original InstructionSequence).  The default implementation assumes
  // that any Instruction with an operand of type OPERAND_LABEL
  // is a branch.
  virtual bool is_branch(Instruction *ins);

  // Subclasses must override this to check whether given Instruction
  // can fall through to the next instruction.  This method should return
  // true for all Instructions *except* unconditional branches.
  virtual bool falls_through(Instruction *ins) = 0;

private:
  BasicBlock *scan_basic_block(const WorkItem &item, const std::string &label);
  bool ends_in_branch(BasicBlock *bb);
  unsigned get_branch_target_index(BasicBlock *bb);
  bool falls_through(BasicBlock *bb);
};

// For debugging, print a textual representation of a ControlFlowGraph.
// Subclasses must override the print_basic_block method.
class ControlFlowGraphPrinter {
private:
  const ControlFlowGraph *m_cfg;

public:
  ControlFlowGraphPrinter(ControlFlowGraph *cfg);
  ~ControlFlowGraphPrinter();

  void print();

  // The intended way to implement this method is to use a specialized
  // variant of PrintInstructionSequence.
  virtual void print_basic_block(BasicBlock *bb) = 0;
};

#endif // CFG_H
