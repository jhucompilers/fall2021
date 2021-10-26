#include <cassert>
#include <cstdio>
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

unsigned InstructionSequence::get_length() const {
  return unsigned(m_instr_seq.size());
}

Instruction *InstructionSequence::get_instruction(unsigned index) const {
  assert(index < unsigned(m_instr_seq.size()));
  return m_instr_seq[index];
}

bool InstructionSequence::has_label(unsigned index) const {
  assert(index < unsigned(m_instr_seq.size()));
  return !m_labels[index].empty();
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
