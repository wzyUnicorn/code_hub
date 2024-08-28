class vseq_btn_power_on_interrupt extends btn_base_sequence;
    `uvm_object_utils(vseq_btn_power_on_interrupt)
    `uvm_declare_p_sequencer(virtual_sequencer)
    cpld_output_tr tr;
    function new(string name="vseq_btn_power_on_interrupt");
        super.new(name);
    endfunction
    virtual task body();
    if(starting_phase!=null) starting_phase.raise_objection(this);
    for(int i=1; i<=7; i++) begin
        `uvm_do_on_with(tr,p_sequencer.vbtn_sqr,{tr.step==i;tr.last_step==POWER_OFF;})
    end
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass
