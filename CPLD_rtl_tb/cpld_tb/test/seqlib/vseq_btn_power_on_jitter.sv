class vseq_btn_power_on_jitter extends btn_base_sequence;
    `uvm_object_utils(vseq_btn_power_on_jitter)
    `uvm_declare_p_sequencer(virtual_sequencer)
    cpld_output_tr tr;
    function new(string name="vseq_btn_power_on_jitter");
        super.new(name);
    endfunction
    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on_with(tr,p_sequencer.vbtn_sqr,{tr.step==7;tr.jitter==1;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
