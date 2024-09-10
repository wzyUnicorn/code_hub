//
// Template for UVM-compliant interface
//

`ifndef MEM_BUS_IF__SV
`define MEM_BUS_IF__SV

interface mem_bus_if (input bit clk, input bit rst);

   parameter setup_time = 1/*ns*/;
   parameter hold_time  = 0/*ns*/;

   bit is_active = 0;

   logic [0:0] data_req_o;
   logic [0:0] data_gnt_i;
   logic [0:0] data_rvalid_i;
   logic [0:0] data_we_o;
   logic [3:0] data_be_o;
   logic [31:0] data_addr_o;
   logic [31:0] data_wdata_o;
   logic [6:0] data_wdata_intg_o;
   logic [31:0] data_rdata_i;
   logic [6:0] data_rdata_intg_i;
   logic [0:0] data_err_i;

   clocking mck @(posedge clk);
      default input #setup_time output #hold_time;
      output data_req_o;
       input data_gnt_i;
       input data_rvalid_i;
      output data_we_o;
      output data_be_o;
      output data_addr_o;
      output data_wdata_o;
      output data_wdata_intg_o;
       input data_rdata_i;
       input data_rdata_intg_i;
       input data_err_i;
   endclocking: mck

   clocking sck @(posedge clk);
      default input #setup_time output #hold_time;
   endclocking: sck

   clocking pck @(posedge clk);
      default input #setup_time output #hold_time;
   endclocking: pck

endinterface: mem_bus_if

`endif // MEM_BUS__SV
