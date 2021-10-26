#ifndef CFG_H
#define CFG_H

#include <cassert>
#include <vector>
#include <map>
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

  void set_comment(const std::string &comment);
  bool has_comment() const;
  const std::string &get_comment() const;
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

  // get the instruction labeled by the given label
  Instruction *get_labeled_instruction(const std::string &label) const;

  // get the number of instructions
  unsigned get_length() const;

  // get instruction at specified index
  Instruction *get_instruction(unsigned index) const;

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

#endif // CFG_H
