`ifndef MEM_BUS_PKG__SV
`define MEM_BUS_PKG__SV
    `include "mem_bus_if.sv"
    package mem_bus_pkg;
        import uvm_pkg::*;
        `include "mem_bus_tr.sv"
        `include "mem_bus_sqr.sv"
        `include "mem_bus_drv.sv"
        `include "mem_bus_agt.sv"
    endpackage
`endif
