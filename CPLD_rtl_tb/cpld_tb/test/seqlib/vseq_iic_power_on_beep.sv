class vseq_iic_power_on_beep extends uvm_sequence;
    `uvm_object_utils(vseq_iic_power_on_beep)
    `uvm_declare_p_sequencer(virtual_sequencer)
    uvm_component parent;
    btn_agent btn_agt;
    cpld_output_tr  tr0;
    iic_transaction tr;

    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
        parent=p_sequencer.vbtn_sqr.get_parent();
        $cast(btn_agt,parent);
    fork
        `uvm_do_on_with(tr0,p_sequencer.vbtn_sqr,{tr0.step==0;}) // button DCOKSby pull up
        begin 
        btn_agt.drv.DCOKSby.wait_trigger(); 
        // iic power on
        `uvm_do_on_with(tr,p_sequencer.viic_sqr,{tr.addr==7'h64;tr.trans==0;tr.regAddr==8'h00;tr.dataIN==8'h0f;})
        end
    join
        for(int i=0;i<=5;i++)
        // iic control buzzer frequency
        `uvm_do_on_with(tr,p_sequencer.viic_sqr,{tr.addr==7'h64;tr.trans==0;tr.regAddr==8'h08;tr.dataIN=={(5'b00001<<i),3'b001};})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
