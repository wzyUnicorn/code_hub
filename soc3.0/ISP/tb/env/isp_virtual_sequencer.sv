class isp_virtual_sequencer extends uvm_sequencer;
   isp_sequencer   isp_sqr;   
   `uvm_component_utils(isp_virtual_sequencer)
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
endclass
