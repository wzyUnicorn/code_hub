`ifndef QSPI_ENV
`define QSPI_ENV
class qspi_env extends uvm_env;
   apb_agent apb_agt;
   qspi_scoreboard qspi_sb;
   qspi_virtual_sequencer my_sqr;
   qspi_monitor qspi_mon;
   ral_block_qspi qspi_rgm;
   reg_adapter adapter;
   qspi_fun_cov qspi_cov;

   `uvm_component_utils(qspi_env)
   extern function new(string name="qspi_env", uvm_component parent=null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
endclass: qspi_env
function qspi_env::new(string name= "qspi_env",uvm_component parent=null);
   super.new(name,parent);
endfunction:new

function void qspi_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   apb_agt = apb_agent::type_id::create("apb_agt",this);
   qspi_sb = qspi_scoreboard::type_id::create("qspi_sb",this);
   my_sqr = qspi_virtual_sequencer::type_id::create("my_sqr", this);
   qspi_mon = qspi_monitor::type_id::create("qspi_mon", this);
   qspi_rgm = ral_block_qspi::type_id::create("qspi_rgm", this);
   qspi_cov = qspi_fun_cov::type_id::create("qspi_cov", this);
   adapter = reg_adapter::type_id::create("adapter", this);
   qspi_rgm.build();
   qspi_rgm.lock_model();
endfunction: build_phase

function void qspi_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   apb_agt.agent_ap.connect(qspi_sb.sb_export_apb);
   qspi_mon.mon_ap.connect(qspi_sb.sb_export_qspi);
   qspi_mon.mon_cov_ap.connect(qspi_cov.qspi_imp);
   qspi_rgm.default_map.set_sequencer(apb_agt.sqr,adapter);
   qspi_rgm.default_map.set_auto_predict(1);
   my_sqr.apb_sqr =  apb_agt.sqr;
   my_sqr.qspi_rgm = qspi_rgm;

endfunction: connect_phase
`endif // ARB_ENV
