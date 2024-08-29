class lpc_transaction extends uvm_sequence_item;

    rand bit [3:0] start;
    rand bit [3:0] cyctype;
    rand bit [3:0] size;
    rand bit [15:0] addr;
    rand bit [15:0] channel;
    rand bit [3:0] tar[0:1];
    rand bit [3:0] sync;
    rand bit [7:0] dataIn,dataOut;
    rand bit abort;
    constraint default_value{soft abort==0;}

    function new(string name="lpc_transaction");
        super.new(name);
    endfunction
    `uvm_object_utils_begin(lpc_transaction)
    `uvm_field_int(start,UVM_ALL_ON)
    `uvm_field_int(cyctype,UVM_ALL_ON)
    `uvm_field_int(size,UVM_ALL_ON)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(channel,UVM_ALL_ON)
    `uvm_field_int(sync,UVM_ALL_ON)
    `uvm_field_int(dataIn,UVM_ALL_ON)
    `uvm_field_int(dataOut,UVM_ALL_ON)
    `uvm_object_utils_end
endclass
