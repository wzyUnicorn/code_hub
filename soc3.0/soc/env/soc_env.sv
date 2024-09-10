//
// Template for UVM-compliant verification environment
//

`ifndef SOC_ENV__SV
`define SOC_ENV__SV
class soc_env extends uvm_env;
   mem_bus_agt m_mem_bus_agt;
   soc_cfg m_soc_cfg;
   soc_sqr m_soc_sqr;

    `uvm_component_utils(soc_env)

   extern function new(string name="soc_env", uvm_component parent=null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern function void start_of_simulation_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   extern virtual task shutdown_phase(uvm_phase phase);

endclass: soc_env

function soc_env::new(string name= "soc_env",uvm_component parent=null);
   super.new(name,parent);
endfunction:new

function void soc_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   m_soc_sqr = soc_sqr::type_id::create("m_soc_sqr",this);
   m_mem_bus_agt = mem_bus_agt::type_id::create("m_mem_bus_agt",this);
   if(m_soc_cfg.mem_bus_is_active) m_mem_bus_agt.is_active = UVM_ACTIVE;
   else m_mem_bus_agt.is_active = UVM_PASSIVE;
endfunction: build_phase

function void soc_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   m_soc_sqr.m_mem_bus_sqr = m_mem_bus_agt.m_mem_bus_sqr;
endfunction: connect_phase

function void soc_env::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
	uvm_root::get().print_topology(); 
    uvm_factory::get().print();      
endfunction: start_of_simulation_phase


task soc_env::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
endtask:reset_phase

task soc_env::configure_phase (uvm_phase phase);
   super.configure_phase(phase);
endtask:configure_phase

task soc_env::run_phase(uvm_phase phase);
   super.run_phase(phase);
endtask:run_phase

function void soc_env::report_phase(uvm_phase phase);
   uvm_report_server m_uvm_report_server = uvm_report_server::get_server();
   int m_error_cnt = m_uvm_report_server.get_severity_count(UVM_ERROR);
   int m_fatal_cnt = m_uvm_report_server.get_severity_count(UVM_FATAL);
   super.report_phase(phase);
   $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
   if(m_error_cnt+m_fatal_cnt !=0) begin
       $display("    TEST FAIL!\n");
       $display("(uvm_error : %0d; uvm_fatal : %0d)\n",m_error_cnt,m_fatal_cnt);
   end else begin
       $display("    TEST PASS!\n");
   end
   $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
endfunction:report_phase

task soc_env::shutdown_phase(uvm_phase phase);
   super.shutdown_phase(phase);
endtask:shutdown_phase
`endif // SOC_ENV__SV

