class vseq_lpc_transfer_abort extends uvm_sequence;
    `uvm_object_utils(vseq_lpc_transfer_abort)
    `uvm_declare_p_sequencer(virtual_sequencer)

    virtual task body();
        btn_base_sequence btn_seq;
        lpc_transaction tr;

    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(btn_seq,p_sequencer.vbtn_sqr) // btn power on
        `uvm_do_on_with(tr,p_sequencer.vlpc_sqr,{tr.cyctype==4'b0010;tr.addr==16'h0800;tr.abort==1;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
