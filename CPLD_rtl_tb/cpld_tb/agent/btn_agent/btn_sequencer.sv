class btn_sequencer extends uvm_sequencer#(cpld_output_tr);
    `uvm_component_utils(btn_sequencer)

    function new(string name,uvm_component parent);
        super.new(name,parent);
    endfunction
endclass
