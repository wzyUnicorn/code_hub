//
// Template for UVM-compliant Program block

`ifndef SOC_TB_MOD__SV
`define SOC_TB_MOD__SV


    import uvm_pkg::*;
    
    mem_bus_if m_mem_bus_if(.clk(clk_cpu),.rst(rst_n_cpu));
    
    initial begin
        uvm_config_db #(virtual mem_bus_if)::set(null,"uvm_test_top.m_soc_env.m_mem_bus_agt*","mst_if",m_mem_bus_if); 
        run_test();
    end

    initial begin
        @(posedge rst_n_cpu);
        if(m_mem_bus_if.is_active) begin
            force test.inst_soc_top.inst_ibex_top.rst_ni = 1'b0;

            force test.inst_soc_top.inst_ibex_top.data_req_o = m_mem_bus_if.data_req_o;
            force test.inst_soc_top.inst_ibex_top.data_we_o = m_mem_bus_if.data_we_o;
            force test.inst_soc_top.inst_ibex_top.data_addr_o = m_mem_bus_if.data_addr_o;
            force test.inst_soc_top.inst_ibex_top.data_wdata_o = m_mem_bus_if.data_wdata_o;
            force test.inst_soc_top.inst_ibex_top.data_be_o = m_mem_bus_if.data_be_o;
            force test.inst_soc_top.inst_ibex_top.data_wdata_intg_o = mem_bus_if.data_wdata_intg_o;

            force m_mem_bus_if.data_rdata_i = test.inst_soc_top.inst_ibex_top.data_rdata_i;
            force m_mem_bus_if.data_rdata_intg_i = test.inst_soc_top.inst_ibex_top.data_rdata_intg_i;
            force m_mem_bus_if.data_err_i = test.inst_soc_top.inst_ibex_top.data_err_i;
            force m_mem_bus_if.data_gnt_i = test.inst_soc_top.inst_ibex_top.data_gnt_i; 
            force m_mem_bus_if.data_rvalid_i = test.inst_soc_top.inst_ibex_top.data_rvalid_i;
        end
    end

`endif // SOC_TB_MOD__SV

