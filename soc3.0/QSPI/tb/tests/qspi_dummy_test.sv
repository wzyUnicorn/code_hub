`ifndef TEST_DUMMY__SV
`define TEST_DUMMY__SV
typedef class qspi_env;
class qspi_dummy_test extends uvm_test;
  
  `uvm_component_utils(qspi_dummy_test)
  qspi_env env;
  qspi_dummy_sequence  qspi_seq;

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
      qspi_seq = qspi_dummy_sequence::type_id::create("qspi_seq");
      assert(qspi_seq.randomize());
      qspi_seq.start(env.my_sqr);
      phase.drop_objection(.obj(this));
  endtask: run_phase

endclass : qspi_dummy_test
`endif //TEST__SV