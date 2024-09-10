class cnn_virtual_sequencer extends uvm_sequencer;
   apb_sequencer		apb_sqr;
   ral_block_cnn        cnn_rgm;
   sys_memory           sys_mem;
   uvm_analysis_port#(cnn_txn) cnn_ap;
   `uvm_component_utils(cnn_virtual_sequencer)
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
endclass
