//
// Template for UVM-compliant testcase

`ifndef I2C_READ_UVM_TEST__SV
`define I2C_READ_UVM_TEST__SV

class i2c_read_uvm_seq extends uvm_sequence;
    `uvm_object_utils(i2c_read_uvm_seq)
    `uvm_declare_p_sequencer(soc_sqr)

    function new(string name = "i2c_read_uvm_seq");
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
        bit[31:0] wdata =  0;
        wdata = 'h22;
        write_reg(32'h20060004,wdata); // pad pinmux
        write_reg(32'h90008,4); // i2c start
        $display("start i2c read uvm test body.");
        write_reg(32'h20030000,32'h10);
        write_reg(32'h20030004,32'h00);
        write_reg(32'h20030008,32'hc0);

        write_reg(32'h20030014,32'h5b);  // bit0 = 1, read_reg i2c device
        write_reg(32'h20030018,32'ha0);

        read_reg(32'h20030010,rdata);
        while((rdata&32'h02) ==32'h02)  begin
            $display("Wait I2C idle \n");
            read_reg(32'h20030010,rdata);
        end

        write_reg(32'h20030018,32'h60);   // read_reg i2c device data

        read_reg(32'h20030010,rdata);
        while((rdata&32'h02) ==32'h02)  begin
            $display("Wait I2C idle \n");
            read_reg(32'h20030010,rdata);
        end
        
        read_reg(32'h2003000c,rdata);
        
        if(rdata != 32'h73) begin
            $display("Error data not match ! \n");
        end else begin
            $display("read_reg data compare pass ! \n");
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

class i2c_read_uvm_test extends uvm_test;

  `uvm_component_utils(i2c_read_uvm_test)

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
    uvm_config_db#(uvm_object_wrapper)::set(this,"m_soc_env.m_soc_sqr.main_phase","default_sequence",i2c_read_uvm_seq::type_id::get());
  endfunction

  virtual task reset_phase(uvm_phase phase);
      super.reset_phase(phase);
      phase.raise_objection(this);
      @(posedge m_soc_env.m_mem_bus_agt.m_mem_bus_drv.drv_if.rst);
      phase.drop_objection(this);
  endtask: reset_phase

endclass : i2c_read_uvm_test

`endif //TEST__SV

