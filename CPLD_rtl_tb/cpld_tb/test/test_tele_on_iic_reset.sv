class test_tele_on_iic_reset extends test_base;
    `uvm_component_utils(test_tele_on_iic_reset)
    function new(string name="test_tele_on_iic_reset",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        env=environment::type_id::create("env",this);
        vsqr=virtual_sequencer::type_id::create("vsqr",this);
        uvm_config_db#(uvm_object_wrapper)::set(this,"vsqr.main_phase","default_sequence",
        vseq_tele_on_iic_reset::type_id::get());
    endfunction
endclass