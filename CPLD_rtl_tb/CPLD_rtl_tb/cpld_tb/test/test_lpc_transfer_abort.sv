class test_lpc_transfer_abort extends test_base;
    `uvm_component_utils(test_lpc_transfer_abort)
    function new(string name="test_lpc_transfer_abort",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        env=environment::type_id::create("env",this);
        vsqr=virtual_sequencer::type_id::create("vsqr",this);
        uvm_config_db#(uvm_object_wrapper)::set(this,"vsqr.main_phase","default_sequence",
        vseq_lpc_transfer_abort::type_id::get());
    endfunction
endclass