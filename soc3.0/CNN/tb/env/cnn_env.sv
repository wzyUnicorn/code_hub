`ifndef CNN_ENV
`define CNN_ENV

class cnn_env extends uvm_env;

   apb_agent                   apb_agt     ;
   cnn_virtual_sequencer       my_sqr      ;
   ahb_slave_agent             ahb_slv_agt ;
   ral_block_cnn               cnn_rgm     ;
   reg_adapter                 adapter     ;
   cnn_scoreboard              cnn_scb     ;
   uvm_analysis_port#(cnn_txn) cnn_ap;

   `uvm_component_utils(cnn_env)
   
   extern function new(string name="cnn_env", uvm_component parent=null);
   
   extern virtual function void build_phase(uvm_phase phase);
   
   extern virtual function void connect_phase(uvm_phase phase);

endclass: cnn_env

function cnn_env::new(string name= "cnn_env",uvm_component parent=null);
   super.new(name,parent);
endfunction:new

function void cnn_env::build_phase(uvm_phase phase);
   super.build_phase(phase);

   my_sqr = cnn_virtual_sequencer::type_id::create("my_sqr", this);

   ahb_slv_agt = ahb_slave_agent::type_id::create("ahb_slv_agt", this);

   apb_agt = apb_agent::type_id::create("apb_agt", this);

   cnn_rgm = ral_block_cnn::type_id::create("cnn_rgm", this);
   adapter = reg_adapter::type_id::create("adapter", this);
   cnn_scb = cnn_scoreboard::type_id::create("cnn_scb", this);

   cnn_ap = new("cnn_ap", this);

   cnn_rgm.build();

   cnn_rgm.lock_model();

endfunction: build_phase

function void cnn_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);

   cnn_ap.connect(cnn_scb.cnn_imp);

   my_sqr.apb_sqr =  apb_agt.sqr;
   cnn_rgm.default_map.set_sequencer(apb_agt.sqr,adapter);
   cnn_rgm.default_map.set_auto_predict(1);
   my_sqr.cnn_rgm = cnn_rgm;
   my_sqr.sys_mem = ahb_slv_agt.sys_mem;
   cnn_scb.sys_mem = ahb_slv_agt.sys_mem;
   my_sqr.cnn_ap = cnn_ap;
endfunction: connect_phase

`endif // CNN_ENV
