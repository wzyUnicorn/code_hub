`ifndef TEST__SV
`define TEST__SV
typedef class cnn_env;
class cnn_test extends uvm_test;
  
  `uvm_component_utils(cnn_test)
  cnn_env env;
  cnn_basic_sequence  cnn_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      uvm_top.enable_print_topology= 1;
      env = cnn_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
      phase.raise_objection(.obj(this));
      cnn_seq = cnn_basic_sequence::type_id::create("cnn_seq");
      assert(cnn_seq.randomize());
      cnn_seq.start(env.my_sqr);
      phase.drop_objection(.obj(this));
  endtask: run_phase

endclass : cnn_test
`endif //TEST__SV
