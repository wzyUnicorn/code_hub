class vseq_iic_power_on_off extends uvm_sequence;
    `uvm_object_utils(vseq_iic_power_on_off)
    `uvm_declare_p_sequencer(virtual_sequencer)
    uvm_component parent;
    btn_agent btn_agt;
    cpld_output_tr  tr1;
    iic_transaction tr2;

    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
        parent=p_sequencer.vbtn_sqr.get_parent();
        $cast(btn_agt,parent);
    fork
        `uvm_do_on_with(tr1,p_sequencer.vbtn_sqr,{tr1.step==0;})
    begin 
        btn_agt.drv.DCOKSby.wait_trigger(); 
        `uvm_do_on_with(tr2,p_sequencer.viic_sqr,{tr2.addr==7'h64;tr2.trans==0;tr2.regAddr==8'h00;tr2.dataIN==8'h0f;})
        `uvm_do_on_with(tr2,p_sequencer.viic_sqr,{tr2.addr==7'h64;tr2.trans==0;tr2.regAddr==8'h00;tr2.dataIN==8'hf0;})
    end
    join
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass