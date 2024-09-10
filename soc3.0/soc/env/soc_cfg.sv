//
// Template for UVM-compliant configuration class
//

`ifndef SOC_CFG__SV
`define SOC_CFG__SV

class soc_cfg extends uvm_object; 

    bit mem_bus_is_active = 0;

   `uvm_object_utils_begin(soc_cfg)
   `uvm_object_utils_end

   extern function new(string name = "");
  
endclass: soc_cfg

function soc_cfg::new(string name = "");
   super.new(name);
endfunction: new


`endif // SOC_CFG__SV
