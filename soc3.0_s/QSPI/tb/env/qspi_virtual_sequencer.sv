class qspi_virtual_sequencer extends uvm_sequencer;
   apb_sequencer   apb_sqr;   
   ral_block_qspi        qspi_rgm;  
   `uvm_component_utils(qspi_virtual_sequencer)
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
endclass
