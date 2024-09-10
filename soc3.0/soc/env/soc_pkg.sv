`ifndef SOC_PKG__SV
`define SOC_PKG__SV
    package soc_pkg;
        import uvm_pkg::*;
        import mem_bus_pkg::*;
        `include "soc_cfg.sv"
        `include "soc_sqr.sv"
        `include "soc_env.sv"
    endpackage
`endif

