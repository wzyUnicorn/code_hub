//
// Template for UVM-compliant testcase

`ifndef SOC_DMA_UVM_TEST__SV
`define SOC_DMA_UVM_TEST__SV

class soc_dma_uvm_seq extends uvm_sequence;
    `uvm_object_utils(soc_dma_uvm_seq)
    `uvm_declare_p_sequencer(soc_sqr)

    function new(string name = "soc_dma_uvm_seq");
        super.new(name);
        set_response_queue_depth(-1);
    endfunction

    virtual task pre_body();
        uvm_phase starting_phase = get_starting_phase();
        if(starting_phase != null) starting_phase.raise_objection(this);
    endtask

    virtual task body();
        
        mem_bus_tr m_mem_bus_tr;

        bit [31:0] rdata=0;

        $display("DMA Test write debug 1\n"); 

        write_reg(32'h30000000,32'h00061000);   //target
        write_reg(32'h30000004,32'h00062000);   //src
        write_reg(32'h3000000c,32'h00010010);   //xfer start + xfer_size

        $display("Wait dma done! \n"); 

        while(rdata!=1) begin
            read_reg(32'h3000008c,rdata);
        end

        $display("Dma done! \n");

        #1us;
    endtask

    virtual task write_reg(bit[31:0] address,bit[31:0] wdata);
        mem_bus_tr m_mem_bus_tr;
        `uvm_do_on_with(m_mem_bus_tr,p_sequencer.m_mem_bus_sqr,{
            kind == mem_bus_tr::WRITE;
            addr == address;
            data == wdata;
            byte_en == 4'hf;
        })
    endtask
   
    virtual task read_reg(bit[31:0] address,ref bit[31:0] rdata);
        mem_bus_tr m_mem_bus_tr;
        `uvm_do_on_with(m_mem_bus_tr,p_sequencer.m_mem_bus_sqr,{
            kind == mem_bus_tr::READ;
            addr == address;
            byte_en == 4'hf;
        })
        get_response(rsp);
        rdata = m_mem_bus_tr.data;
    endtask


    virtual task post_body();
        uvm_phase starting_phase = get_starting_phase();
        if(starting_phase != null) starting_phase.drop_objection(this);
    endtask

endclass

class soc_dma_uvm_test extends uvm_test;

  `uvm_component_utils(soc_dma_uvm_test)

  soc_env m_soc_env;
  soc_cfg m_soc_cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    m_soc_cfg = soc_cfg::type_id::create("m_soc_cfg");
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_soc_cfg.mem_bus_is_active = 1;
    m_soc_env = soc_env::type_id::create("m_soc_env", this);
    m_soc_env.m_soc_cfg = m_soc_cfg;
    uvm_config_db#(uvm_object_wrapper)::set(this,"m_soc_env.m_soc_sqr.main_phase","default_sequence",soc_dma_uvm_seq::type_id::get());
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this);
      @(posedge m_soc_env.m_mem_bus_agt.m_mem_bus_drv.drv_if.rst);
      phase.drop_objection(this);
  endtask: reset_phase

endclass : soc_dma_uvm_test

`endif //TEST__SV

