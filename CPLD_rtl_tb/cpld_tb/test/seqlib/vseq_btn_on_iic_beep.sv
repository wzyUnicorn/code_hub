class vseq_btn_on_iic_beep extends uvm_sequence;
    `uvm_object_utils(vseq_btn_on_iic_beep)
    `uvm_declare_p_sequencer(virtual_sequencer)
    cpld_output_tr  tr1;
    iic_transaction tr2;

    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
        `uvm_do_on(tr1,p_sequencer.vbtn_sqr)        // button power on
        for(int i=1;i<=6;i++)
        `uvm_do_on_with(tr2,p_sequencer.viic_sqr,   // iic control beep
        {tr2.addr==7'h64;tr2.trans==0;tr2.regAddr==8'h08;tr2.dataIN=={5'b00001<<i,3'b001};})

        `uvm_do_on_with(tr2,p_sequencer.viic_sqr,{tr2.addr==7'h64;tr2.trans==0;tr2.regAddr==8'h08;tr2.dataIN==8'h0;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
