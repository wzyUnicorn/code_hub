class virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(virtual_sequencer)

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    btn_sequencer vbtn_sqr;
    iic_sequencer viic_sqr;
    lpc_sequencer vlpc_sqr;
    tele_sequencer vtel_sqr;
endclass
