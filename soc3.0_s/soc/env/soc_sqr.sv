//
// Template for UVM-compliant sequencer class
//


`ifndef SOC_SQR__SV
`define SOC_SQR__SV

class soc_sqr extends uvm_sequencer;

    mem_bus_sqr m_mem_bus_sqr;

   `uvm_component_utils(soc_sqr)
   function new (string name,
                 uvm_component parent);
   super.new(name,parent);
   endfunction:new 
endclass:soc_sqr

`endif // SOC_SQR__SV
