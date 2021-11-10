#ifndef CFG_TRANSFORM_H
#define CFG_TRANSFORM_H

class ControlFlowGraph;

class ControlFlowGraphTransform {
private:
  ControlFlowGraph *m_cfg;

public:
  ControlFlowGraphTransform(ControlFlowGraph *cfg);
  virtual ~ControlFlowGraphTransform();

  ControlFlowGraph *get_orig_cfg();
  ControlFlowGraph *transform_cfg();

  virtual InstructionSequence *transform_basic_block(InstructionSequence *iseq) = 0;
};

#endif // CFG_TRANSFORM_H
