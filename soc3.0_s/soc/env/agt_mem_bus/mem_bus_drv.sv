//
// Template for UVM-compliant physical-level transactor
//

`ifndef MEM_BUS_DRV__SV
`define MEM_BUS_DRV__SV

class mem_bus_drv extends uvm_driver # (mem_bus_tr);

   
   typedef virtual mem_bus_if v_if; 
   v_if drv_if;
   
   extern function new(string name = "mem_bus_drv",
                       uvm_component parent = null); 
 
      `uvm_component_utils_begin(mem_bus_drv)
      `uvm_component_utils_end


   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task tx_driver();

endclass: mem_bus_drv


function mem_bus_drv::new(string name = "mem_bus_drv",
                   uvm_component parent = null);
   super.new(name, parent);

   
endfunction: new


function void mem_bus_drv::build_phase(uvm_phase phase);
   super.build_phase(phase);
endfunction: build_phase

function void mem_bus_drv::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "mst_if", drv_if);
endfunction: connect_phase

function void mem_bus_drv::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
   if (drv_if == null)
       `uvm_fatal("NO_CONN", "Virtual port not connected to the actual interface instance");   
endfunction: end_of_elaboration_phase

function void mem_bus_drv::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
   //ToDo: Implement this phase here
endfunction: start_of_simulation_phase

 
task mem_bus_drv::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
   drv_if.data_req_o = 'h0;
   drv_if.data_gnt_i = 'h0;
   drv_if.data_rvalid_i = 'h0;
   drv_if.data_we_o = 'h0;
   drv_if.data_be_o = 'h0;
   drv_if.data_addr_o = 'h0;
   drv_if.data_wdata_o = 'h0;
   drv_if.data_wdata_intg_o = 'h0;
   drv_if.data_rdata_i = 'h0;
   drv_if.data_rdata_intg_i = 'h0;
   drv_if.data_err_i = 'h0;
endtask: reset_phase

task mem_bus_drv::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
   //ToDo: Configure your component here
endtask:configure_phase


task mem_bus_drv::run_phase(uvm_phase phase);
   super.run_phase(phase);
   tx_driver();
endtask: run_phase


task mem_bus_drv::tx_driver();
 forever begin
      mem_bus_tr tr;
      seq_item_port.get_next_item(tr);
      @(drv_if.mck);
      drv_if.mck.data_req_o <= 1'b1;
      drv_if.mck.data_addr_o <= tr.addr;
      drv_if.mck.data_be_o <= tr.byte_en;
      case (tr.kind) 
         mem_bus_tr::READ: begin
             drv_if.mck.data_we_o <= 1'b0;
             drv_if.mck.data_wdata_o <= 'h0;
         end
         mem_bus_tr::WRITE: begin
             drv_if.mck.data_we_o <= 1'b1;
             drv_if.mck.data_wdata_o <= tr.data;
         end
      endcase
      @(drv_if.mck);
      wait(drv_if.mck.data_gnt_i);
      drv_if.mck.data_req_o <= 'h0;
      drv_if.mck.data_addr_o <= 'h0;
      drv_if.mck.data_be_o <= 'h0;
      drv_if.mck.data_we_o <= 'h0;
      drv_if.mck.data_wdata_o <= 'h0;
      @(drv_if.mck);
      wait(drv_if.mck.data_rvalid_i);
      tr.status = drv_if.mck.data_err_i ? mem_bus_tr::ERROR : mem_bus_tr::IS_OK;
      if(tr.kind == mem_bus_tr::READ) tr.data = drv_if.mck.data_rdata_i;
      seq_item_port.item_done(tr);
   end
endtask : tx_driver

`endif // MEM_BUS_DRV__SV


