#include <cassert>
#include "x86_64.h"

PrintX86_64InstructionSequence::PrintX86_64InstructionSequence(InstructionSequence *iseq)
  : PrintInstructionSequence(iseq) {
}

std::string PrintX86_64InstructionSequence::get_opcode_name(int opcode) {
  const char *s;
  switch (opcode) {
  case MINS_NOP:  return "nop";
  case MINS_MOVQ: return "movq";
  case MINS_ADDQ: return "addq";
  case MINS_SUBQ: return "subq";
  case MINS_LEAQ: return "leaq";
  case MINS_JMP:  return "jmp";
  case MINS_JE:   return "je";
  case MINS_JNE:  return "jne";
  case MINS_JL:   return "jl";
  case MINS_JLE : return "jle";
  case MINS_JG:   return "jg";
  case MINS_JGE : return "jge";
  case MINS_CMPQ: return "cmpq";
  case MINS_CALL: return "call";
  case MINS_IMULQ: return "imulq";
  default:
    assert(false);
    s = "<invalid>";
  }
  return std::string(s);
}

std::string PrintX86_64InstructionSequence::get_mreg_name(int regnum) {
  const char *s;
  switch (regnum) {
  case MREG_RAX: s = "%rax"; break;
  case MREG_RBX: s = "%rbx"; break;
  case MREG_RCX: s = "%rcx"; break;
  case MREG_RDX: s = "%rdx"; break;
  case MREG_RDI: s = "%rdi"; break;
  case MREG_RSI: s = "%rsi"; break;
  case MREG_RSP: s = "%rsp"; break;
  case MREG_RBP: s = "%rbp"; break;
  case MREG_R8:  s = "%r8"; break;
  case MREG_R9:  s = "%r9"; break;
  case MREG_R10: s = "%r10"; break;
  case MREG_R11: s = "%r11"; break;
  case MREG_R12: s = "%r12"; break;
  case MREG_R13: s = "%r13"; break;
  case MREG_R14: s = "%r14"; break;
  case MREG_R15: s = "%r15"; break;
  default:
    assert(false);
    s = "<invalid>";
  }
  return std::string(s);
}
