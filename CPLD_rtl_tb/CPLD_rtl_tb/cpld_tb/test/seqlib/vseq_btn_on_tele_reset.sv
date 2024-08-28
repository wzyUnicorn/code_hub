class vseq_btn_on_tele_reset extends uvm_sequence;
    `uvm_object_utils(vseq_btn_on_tele_reset)
    `uvm_declare_p_sequencer(virtual_sequencer)
    cpld_output_tr  tr1;
    tele_ctrl_item  tr2;

    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(tr1,p_sequencer.vbtn_sqr)        // button power on
        `uvm_do_on_with(tr2,p_sequencer.vtel_sqr,   // tele reset
        {tr2.do_action==AST_RST;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
