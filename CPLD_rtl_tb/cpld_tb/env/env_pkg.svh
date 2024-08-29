package env_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import btn_agent_pkg::*;
    import iic_agent_pkg::*;
    import lpc_agent_pkg::*;
    import tele_agent_pkg::*;
    `include "iic_adapter.sv"
    `include "lpc_adapter.sv"
    `include "iic_regs.sv"
    `include "lpc_regs.sv"
    `include "iic_reg_model.sv"
    `include "lpc_reg_model.sv"
    `include "functional_coverage.sv"
    `include "scoreboard.sv"
    `include "environment.sv"
endpackage
