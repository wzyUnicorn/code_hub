class iic_transaction extends uvm_sequence_item;

    //iic slave transmit
    rand bit [6:0] addr;
    rand bit trans; //slave read(0) or write(1)
    rand bit [7:0] regAddr;
    rand bit ack;
    rand bit [7:0] dataIN,dataOUT;

    function new(string name="iic_transaction");
        super.new(name);
    endfunction
    `uvm_object_utils_begin(iic_transaction)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_int(trans,UVM_ALL_ON)
    `uvm_field_int(regAddr,UVM_ALL_ON)
    `uvm_field_int(ack,UVM_ALL_ON)
    `uvm_field_int(dataIN,UVM_ALL_ON)
    `uvm_field_int(dataOUT,UVM_ALL_ON)
    `uvm_object_utils_end
endclass
