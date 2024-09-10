//
// Template for UVM-compliant sequencer class
//


`ifndef MEM_BUS_SQR__SV
`define MEM_BUS_SQR__SV


typedef class mem_bus_tr;
class mem_bus_sqr extends uvm_sequencer # (mem_bus_tr);

   `uvm_component_utils(mem_bus_sqr)
   function new (string name,
                 uvm_component parent);
   super.new(name,parent);
   endfunction:new 
endclass:mem_bus_sqr

`endif // MEM_BUS_SQR__SV
