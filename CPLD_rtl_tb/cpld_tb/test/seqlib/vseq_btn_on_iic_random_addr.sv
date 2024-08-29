class vseq_btn_on_iic_random_addr extends uvm_sequence;
    `uvm_object_utils(vseq_btn_on_iic_random_addr)
    `uvm_declare_p_sequencer(virtual_sequencer)
    cpld_output_tr  tr1;
    iic_transaction tr2;

    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(tr1,p_sequencer.vbtn_sqr)        // button power on
        for(int i=0;i<4;i++)
        `uvm_do_on_with(tr2,p_sequencer.viic_sqr,{tr2.addr==7'h64;tr2.trans==0;tr2.regAddr==8'h00+4*i;})
        for(int i=0;i<4;i++)
        `uvm_do_on_with(tr2,p_sequencer.viic_sqr,{tr2.addr==7'h64;tr2.trans==1;tr2.regAddr==8'h00+4*i;})
        //repeat(10) `uvm_do_on_with(tr2,p_sequencer.viic_sqr,{tr2.addr==7'h64;tr2.trans==0;})
        // random slave address
        `uvm_do_on(tr2,p_sequencer.viic_sqr)
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
