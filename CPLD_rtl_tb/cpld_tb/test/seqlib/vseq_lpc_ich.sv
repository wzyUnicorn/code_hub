class vseq_lpc_ich extends uvm_sequence;
    `uvm_object_utils(vseq_lpc_ich)
    `uvm_declare_p_sequencer(virtual_sequencer)

    virtual task body();
        btn_base_sequence btn_seq;
        lpc_transaction tr;

    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(btn_seq,p_sequencer.vbtn_sqr) // button power on
        `uvm_do_on_with(tr,p_sequencer.vlpc_sqr, // lpc ich LinkUp enable
        {tr.cyctype==4'b0010;tr.addr==16'h0800;tr.dataIn==8'hff;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
