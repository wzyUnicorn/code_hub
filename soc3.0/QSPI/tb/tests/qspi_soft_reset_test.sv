`ifndef TEST_SOFT_RESET__SV
`define TEST_SOFT_RESET__SV
typedef class qspi_env;
class qspi_soft_reset_test extends uvm_test;
  
  `uvm_component_utils(qspi_soft_reset_test)
  qspi_env env;
  qspi_soft_reset_sequence  qspi_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      uvm_top.enable_print_topology= 1;
      env = qspi_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
      phase.raise_objection(.obj(this));
      qspi_seq = qspi_soft_reset_sequence::type_id::create("qspi_seq");
      assert(qspi_seq.randomize());
      qspi_seq.start(env.my_sqr);
      phase.drop_objection(.obj(this));
  endtask: run_phase

endclass : qspi_soft_reset_test
`endif //TEST__SV
