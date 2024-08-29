class lpc_driver extends uvm_driver#(lpc_transaction);
  `uvm_component_utils(lpc_driver)
  virtual cpld_if vif;
  lpc_transaction tr;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(uvm_config_db#(virtual cpld_if)::get(this,"","vif",vif))
      `uvm_info("LPC Driver","driver get virtual interface.",UVM_HIGH)
    else 
      `uvm_error("LPC Driver","miss vif !!")
  endfunction

task main_phase(uvm_phase phase);
    vif.i_Frame   =1; //start as high
    vif.lad_oe    =1;
    vif.i_LPCRst_n=0;
    repeat(4) @(posedge vif.LPCclk);
    vif.i_LPCRst_n=1;
  
    forever begin
    seq_item_port.get_next_item(tr);
    @(posedge vif.LPCclk);
    vif.i_Frame = 0;       // start I/O cycle
    `uvm_info("LPC Driver","I/O cycle start",UVM_LOW)
    vif.LAD_o  = 4'h0;     // START
    @(posedge vif.LPCclk);
    @(negedge vif.LPCclk);
    vif.i_Frame = 1;
    @(posedge vif.LPCclk); // CYCLE TYPE
    vif.LAD_o  = tr.cyctype;
    if(tr.abort==1) abort();
    `uvm_info("Driver",$sformatf("driving cyctype = %h",tr.cyctype),UVM_HIGH)
    for(int i=4;i>=1;i--) begin // ADDR, sent MSB first
        @(posedge vif.LPCclk);
        // expression below reference from IEEE1364 section 5.2.1 Vector bit-select and part-select adressing
        vif.LAD_o = tr.addr[4*i-1 -: 4];
    end     
    `uvm_info("Driver",$sformatf("drived addr = %h",tr.addr),UVM_HIGH)
    if(tr.cyctype[1]==1) begin  // cycle write
        @(posedge vif.LPCclk);
        vif.LAD_o = tr.dataIn[3:0];   // 8bit data send LSB
        @(posedge vif.LPCclk);
        vif.LAD_o = tr.dataIn[7:4];   // 8bit data
        @(posedge vif.LPCclk);
        vif.LAD_o = 4'b1111;          // Host Turn-Around
        @(posedge vif.LPCclk);        // Host TAR
        vif.lad_oe = 0;
        @(posedge vif.LPCclk);        // Peripheral SYNC 1
        @(posedge vif.LPCclk);        // Peripheral SYNC 2
        @(posedge vif.LPCclk);        // Peripheral TAR 1
        vif.lad_oe = 1;
        @(posedge vif.LPCclk);        // Peripheral TAR 2
    end
    else begin                  // cycle read
        @(posedge vif.LPCclk);
        vif.LAD_o = 4'b1111;          // Host Turn-Around
        @(posedge vif.LPCclk);        // Host TAR
        vif.lad_oe = 0;
        @(posedge vif.LPCclk);        // Peripheral SYNC 1
        @(posedge vif.LPCclk);        // Peripheral SYNC 2
        @(posedge vif.LPCclk);        // Peripheral data out 1
        @(posedge vif.LPCclk);        // Peripheral data out 2
        @(posedge vif.LPCclk);        // Peripheral TAR 1
        vif.lad_oe = 1;
        @(posedge vif.LPCclk);        // Peripheral TAR 2
    end
    `uvm_info("LPC Driver","I/O cycle finish",UVM_LOW)
    if(tr.dataIn==8'hc3 | tr.dataIn==8'haa | tr.dataIn==8'hee | tr.dataIn==8'hf0 | tr.dataIn==8'haa | tr.addr==16'h0808)
    repeat(50) @(posedge vif.LPCclk);
    else repeat(10) @(posedge vif.LPCclk);
    tr=null;
    seq_item_port.item_done();
    end
endtask

task abort();
    @(posedge vif.LPCclk);
    vif.i_Frame = 0;
    `uvm_info("LPC Driver","I/O cycle start",UVM_LOW)
    vif.LAD_o  = 4'hf;
    repeat(4) @(posedge vif.LPCclk);
    @(negedge vif.LPCclk);
    vif.i_Frame = 1;
endtask
endclass

