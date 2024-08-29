class vseq_lpc_mt_reset extends uvm_sequence;
    `uvm_object_utils(vseq_lpc_mt_reset)
    `uvm_declare_p_sequencer(virtual_sequencer)
    lpc_transaction tr;

    virtual task body();
        btn_base_sequence btn_seq;

    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(btn_seq,p_sequencer.vbtn_sqr) // button power on
        `uvm_do_on_with(tr,p_sequencer.vlpc_sqr, // lpc maintain reset
        {tr.cyctype==4'b0010;tr.addr==16'h0800;tr.dataIn==8'hee;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
