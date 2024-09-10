//
// Template for UVM-compliant transaction descriptor


`ifndef MEM_BUS_TR__SV
`define MEM_BUS_TR__SV


class mem_bus_tr extends uvm_sequence_item;

   typedef enum {READ, WRITE } kinds_e;
   rand kinds_e kind;
   typedef enum {IS_OK, ERROR} status_e;
   rand status_e status;
   rand bit[31:0] addr;
   rand bit[31:0] data;
   rand bit[3:0] byte_en;

   `uvm_object_utils_begin(mem_bus_tr) 
      `uvm_field_enum(kinds_e,kind,UVM_ALL_ON)
      `uvm_field_enum(status_e,status, UVM_ALL_ON)
   `uvm_object_utils_end
 
   extern function new(string name = "Trans");
endclass: mem_bus_tr


function mem_bus_tr::new(string name = "Trans");
   super.new(name);
endfunction: new


`endif // MEM_BUS_TR__SV
