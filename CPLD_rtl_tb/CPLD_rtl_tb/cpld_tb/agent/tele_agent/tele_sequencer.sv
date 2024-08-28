class tele_sequencer extends uvm_sequencer#(tele_ctrl_item);
    `uvm_component_utils(tele_sequencer)

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction
endclass
