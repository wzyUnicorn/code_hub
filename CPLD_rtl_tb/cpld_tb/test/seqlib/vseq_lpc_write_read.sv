class vseq_lpc_write_read extends uvm_sequence;
    `uvm_object_utils(vseq_lpc_write_read)
    `uvm_declare_p_sequencer(virtual_sequencer)

    virtual task body();
        btn_base_sequence btn_seq;
        lpc_transaction tr;

    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(btn_seq,p_sequencer.vbtn_sqr) // btn power on
        // LPC write random data and then read
        for(int i=0;i<4;i++)
        `uvm_do_on_with(tr,p_sequencer.vlpc_sqr,{tr.cyctype==4'b0010;tr.addr==16'h0800+4*i;})
        for(int i=0;i<4;i++)
        `uvm_do_on_with(tr,p_sequencer.vlpc_sqr,{tr.cyctype==4'b0000;tr.addr==16'h0800+4*i;})

        // access random address 
        repeat(10) `uvm_do_on_with(tr,p_sequencer.vlpc_sqr,{tr.cyctype==4'b0010;tr.addr[11]==1;})
        repeat(10) `uvm_do_on_with(tr,p_sequencer.vlpc_sqr,{tr.cyctype==4'b0000;tr.addr[11]==1;})
                   `uvm_do_on_with(tr,p_sequencer.vlpc_sqr,{tr.cyctype==4'b0010;})

        // transmit random cycle type
        `uvm_do_on(tr,p_sequencer.vlpc_sqr)
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
