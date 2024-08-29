class vseq_lpc_power_off extends uvm_sequence;
    `uvm_object_utils(vseq_lpc_power_off)
    `uvm_declare_p_sequencer(virtual_sequencer)

    virtual task body();
        btn_base_sequence btn_seq;
        lpc_transaction tr;

    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(btn_seq,p_sequencer.vbtn_sqr) // btn power on
        `uvm_do_on_with(tr,p_sequencer.vlpc_sqr, // lpc power off
        {tr.cyctype==4'b0010;tr.addr==16'h0800;tr.dataIn==8'hf0;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
