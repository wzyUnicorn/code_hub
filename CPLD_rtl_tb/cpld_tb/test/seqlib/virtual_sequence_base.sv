class btn_base_sequence extends uvm_sequence#(cpld_output_tr);
    `uvm_object_utils(btn_base_sequence)
    cpld_output_tr tr;
    function new(string name="btn_base_sequence");
        super.new(name);
    endfunction
    virtual task body();
        `uvm_do(tr)
    endtask
endclass

class iic_base_sequence extends uvm_sequence#(iic_transaction);
    `uvm_object_utils(iic_base_sequence)
    iic_transaction tr;
    function new(string name="iic_base_sequence");
        super.new(name);
    endfunction
    virtual task body();
        `uvm_do_with(tr,{tr.addr==7'h64;tr.trans==0;tr.regAddr==8'h00;tr.dataIN==8'hf0;})
    endtask
endclass

class lpc_base_sequence extends uvm_sequence#(lpc_transaction);
    `uvm_object_utils(lpc_base_sequence)
    lpc_transaction tr;
    function new(string name="lpc_base_sequence");
        super.new(name);
    endfunction
    virtual task body();
        `uvm_do_with(tr,{tr.cyctype==4'b0010;tr.addr==16'h0800;tr.dataIn==8'h66;})
    endtask
endclass

class virtual_sequence_base extends uvm_sequence;
    `uvm_object_utils(virtual_sequence_base)
    `uvm_declare_p_sequencer(virtual_sequencer)

    virtual task body();
        cpld_output_tr  tr0;
        iic_transaction tr1;
        lpc_transaction tr2;

        btn_base_sequence btn_seq;
        iic_base_sequence iic_seq;
        lpc_base_sequence lpc_seq;

    if(starting_phase!=null) starting_phase.raise_objection(this);
        //`uvm_do_on_with(tr0,p_sequencer.vbtn_sqr,{tr0.step==6;})
        // or
        `uvm_do_on(btn_seq,p_sequencer.vbtn_sqr) // btn power on
        `uvm_do_on(iic_seq,p_sequencer.viic_sqr) // iic off
    if(starting_phase!=null) starting_phase.drop_objection(this);
    endtask
endclass

class tele_base_sequence extends uvm_sequence#(tele_ctrl_item);
    `uvm_object_utils(tele_base_sequence)
    tele_ctrl_item tr;
    function new(string name="btn_base_sequence");
        super.new(name);
    endfunction
    virtual task body();
        `uvm_do(tr)
    endtask
endclass
