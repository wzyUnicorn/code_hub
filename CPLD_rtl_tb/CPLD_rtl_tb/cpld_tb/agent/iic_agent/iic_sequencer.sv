class iic_sequencer extends uvm_sequencer#(iic_transaction);
    `uvm_component_utils(iic_sequencer)

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction
endclass
