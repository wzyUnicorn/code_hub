class vseq_iic_power_on_reset extends uvm_sequence;
    `uvm_object_utils(vseq_iic_power_on_reset)
    `uvm_declare_p_sequencer(virtual_sequencer)
    uvm_component parent;
    btn_agent btn_agt;
    cpld_output_tr  tr0;
    iic_transaction tr;

    virtual task body();
        parent=p_sequencer.vbtn_sqr.get_parent();
        $cast(btn_agt,parent);

    if(starting_phase!=null) starting_phase.raise_objection(this);
    fork
        `uvm_do_on_with(tr0,p_sequencer.vbtn_sqr,{tr0.step==0;})
        begin 
        btn_agt.drv.DCOKSby.wait_trigger(); 
        `uvm_do_on_with(tr,p_sequencer.viic_sqr,{tr.addr==7'h64;tr.trans==0;tr.regAddr==8'h00;tr.dataIN==8'h0f;})
        `uvm_do_on_with(tr,p_sequencer.viic_sqr,{tr.addr==7'h64;tr.trans==0;tr.regAddr==8'h00;tr.dataIN==8'hc3;})
        end
    join
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
