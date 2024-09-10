`ifndef TEST__SV
`define TEST__SV
typedef class isp_env;
class isp_test extends uvm_test;
  
  `uvm_component_utils(isp_test)
  isp_env env;
  isp_basic_sequence  isp_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      uvm_top.enable_print_topology= 1;
      env = isp_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
      phase.raise_objection(.obj(this));
      isp_seq = isp_basic_sequence::type_id::create("isp_seq");
      assert(isp_seq.randomize());
      isp_seq.start(env.my_sqr);
      phase.drop_objection(.obj(this));
  endtask: run_phase

endclass : isp_test
`endif //TEST__SV
