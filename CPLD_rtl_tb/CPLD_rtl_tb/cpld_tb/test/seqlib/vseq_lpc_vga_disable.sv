class vseq_lpc_vga_disable extends uvm_sequence;
    `uvm_object_utils(vseq_lpc_vga_disable)
    `uvm_declare_p_sequencer(virtual_sequencer)
    uvm_component parent;
    btn_agent btn_agt;
    cpld_output_tr  tr1;
    lpc_transaction tr2;

    virtual task body();

    if(starting_phase!=null) starting_phase.raise_objection(this);
        parent=p_sequencer.vbtn_sqr.get_parent();
        $cast(btn_agt,parent);
        // button power on and reset
        `uvm_do_on_with(tr1,p_sequencer.vbtn_sqr,{tr1.step==7;tr1.last_step==RESET;}) 

        // lpc control vga soft reset
        `uvm_do_on_with(tr2,p_sequencer.vlpc_sqr,{tr2.cyctype==4'b0010;tr2.addr==16'h0800;tr2.dataIn==8'haa;}) 

        `uvm_do_on_with(tr2,p_sequencer.vlpc_sqr,{tr2.cyctype==4'b0010;tr2.addr==16'h0800;}) 

        //repeat(70) @(posedge btn_agt.drv.vif.clk); 
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
