class lpc_sequencer extends uvm_sequencer#(lpc_transaction);
    `uvm_component_utils(lpc_sequencer)

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    endfunction
endclass
