`ifndef ISP_ENV
`define ISP_ENV

class isp_env extends uvm_env;

   isp_agent             isp_agt;
   isp_scoreboard        isp_sb;
   isp_virtual_sequencer my_sqr;
   isp_monitor           isp_mon;
   `uvm_component_utils(isp_env)
   
   extern function new(string name="isp_env", uvm_component parent=null);
   
   extern virtual function void build_phase(uvm_phase phase);
   
   extern virtual function void connect_phase(uvm_phase phase);

endclass: isp_env

function isp_env::new(string name= "isp_env",uvm_component parent=null);
   super.new(name,parent);
endfunction:new

function void isp_env::build_phase(uvm_phase phase);
   super.build_phase(phase);

   isp_agt = isp_agent::type_id::create("isp_agt",this);

   isp_sb = isp_scoreboard::type_id::create("isp_sb",this);

   my_sqr = isp_virtual_sequencer::type_id::create("my_sqr", this);

   isp_mon = isp_monitor::type_id::create("isp_mon", this);
endfunction: build_phase

function void isp_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);

   isp_mon.mon_ap.connect(isp_sb.sb_export_isp);

   my_sqr.isp_sqr =  isp_agt.sqr;

endfunction: connect_phase

`endif // ISP_ENV
