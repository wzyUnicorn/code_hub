//
// Template for UVM-compliant testcase

`ifndef CNN_UVM_TEST__SV
`define CNN_UVM_TEST__SV

class cnn_uvm_seq extends uvm_sequence;
    `uvm_object_utils(cnn_uvm_seq)
    `uvm_declare_p_sequencer(soc_sqr)

    function new(string name = "cnn_uvm_seq");
        super.new(name);
        set_response_queue_depth(-1);
    endfunction

    virtual task pre_body();
        uvm_phase starting_phase = get_starting_phase();
        if(starting_phase != null) starting_phase.raise_objection(this);
    endtask

    virtual task body();
        
        mem_bus_tr m_mem_bus_tr;

        bit[31:0] rdata;
        bit[31:0] dst_addr;
        bit[31:0] src_addr;
        bit[31:0] cnn_dma_en;
        bit[31:0] cnn_count0;
        bit[31:0] cnn_count1;
        bit[31:0] cnn_ctrl0;
        bit[31:0] cnn_ctrl1;
        bit[31:0] cnn_int_en;
        bit[31:0] addr;
        bit[31:0] expect_data[10];

        $display("start cnn body.");

        dst_addr = 'h15000;
        write_reg('h2008001c,dst_addr);

        src_addr = 'h10000;
        write_reg('h20080018,src_addr);

        cnn_dma_en = 'h00010001;
        write_reg('h20080014,cnn_dma_en);

        cnn_count0 = 'h202000e1;
        write_reg('h20080008,cnn_count0);
 
        cnn_count1 = 'h000001c2;
        write_reg('h2008000c,cnn_count1);

// cnn mode conv/pool/line
        cnn_ctrl1  = 7;
        write_reg('h20080004,cnn_ctrl1);

// cnn interrupt enable
        cnn_int_en = 'h7;
        write_reg('h20080020,cnn_int_en);


// cnn start
        $display("CNN Test Start !! \n"); 

        cnn_ctrl0 = 'h1;
        write_reg('h20080000,cnn_ctrl0);

        rdata = 0;
        while(rdata == 0) begin
            read_reg('h20080024,rdata);
        end
        $display("CNN Output Data compare !! \n");

        expect_data[0] = 'h000000e6;
        expect_data[1] = 'h000000c9;
        expect_data[2] = 'h0000009b;
        expect_data[3] = 'h000000a7;
        expect_data[4] = 'h000000ac;
        expect_data[5] = 'h00000076;
        expect_data[6] = 'h000000ef;
        expect_data[7] = 'h00000027;
        expect_data[8] = 'h00000052;
        expect_data[9] = 'h0000005e;

        for(int i=0;i<10;i++) begin
            addr = 'h15000+i*4;
            read_reg(addr,rdata);
            if(rdata != expect_data[i]) begin
                $display("CNN Data compare error !! \n"); 
            end
        end

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

class cnn_uvm_test extends uvm_test;

  `uvm_component_utils(cnn_uvm_test)

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
    uvm_config_db#(uvm_object_wrapper)::set(this,"m_soc_env.m_soc_sqr.main_phase","default_sequence",cnn_uvm_seq::type_id::get());
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this);
      @(posedge m_soc_env.m_mem_bus_agt.m_mem_bus_drv.drv_if.rst);
      phase.drop_objection(this);
  endtask: reset_phase

endclass : cnn_uvm_test

`endif //TEST__SV

