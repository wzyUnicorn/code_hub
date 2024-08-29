class vseq_tele_on_btn_reset extends uvm_sequence;
    `uvm_object_utils(vseq_tele_on_btn_reset)
    `uvm_declare_p_sequencer(virtual_sequencer)
    uvm_component parent;
    btn_agent btn_agt;
    cpld_output_tr  tr1;
    tele_ctrl_item  tr2;

    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
        parent=p_sequencer.vbtn_sqr.get_parent();
        $cast(btn_agt,parent);
    fork
        `uvm_do_on_with(tr1,p_sequencer.vbtn_sqr,{tr1.step==0;})
    begin 
        btn_agt.drv.DCOKSby.wait_trigger(); 
        `uvm_do_on_with(tr2,p_sequencer.vtel_sqr,{tr2.do_action==AST_ON;})
    end
    join
        `uvm_do_on_with(tr1,p_sequencer.vbtn_sqr,{tr1.step==0;tr1.last_step==RESET;})
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
