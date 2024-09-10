//
// Template for UVM-compliant generic master agent
//

`ifndef MEM_BUS_AGT__SV
`define MEM_BUS_AGT__SV


class mem_bus_agt extends uvm_agent;
   mem_bus_sqr m_mem_bus_sqr;
   mem_bus_drv m_mem_bus_drv;
   typedef virtual mem_bus_if vif;
   vif mast_agt_if; 

   `uvm_component_utils_begin(mem_bus_agt)
   `uvm_component_utils_end

   function new(string name = "mast_agt", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(vif)::get(this, "", "mst_if", mast_agt_if)) begin
         `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance")
      end
      if (is_active == UVM_ACTIVE) begin
         m_mem_bus_sqr = mem_bus_sqr::type_id::create("m_mem_bus_sqr", this);
         m_mem_bus_drv = mem_bus_drv::type_id::create("m_mem_bus_drv", this);
         mast_agt_if.is_active = 1;
      end
      uvm_config_db# (vif)::set(this,"m_mem_bus_drv","mst_if",m_mem_bus_drv.drv_if);
   endfunction: build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (is_active == UVM_ACTIVE) begin
   		  m_mem_bus_drv.seq_item_port.connect(m_mem_bus_sqr.seq_item_export);
      end
   endfunction

   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
   endtask

   virtual function void report_phase(uvm_phase phase);
      super.report_phase(phase);
   endfunction

endclass: mem_bus_agt
 
`endif // MEM_BUS_AGT__SV

