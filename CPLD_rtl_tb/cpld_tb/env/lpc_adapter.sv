class lpc_adapter extends uvm_reg_adapter;
    `uvm_object_utils(lpc_adapter)
    function new(string name="lpc_adapter");
        super.new(name);
    endfunction

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        lpc_transaction tr; tr=new("tr");
        tr.addr = rw.addr;
        tr.cyctype[1] = (rw.kind==UVM_READ)? 0:1;
        if(tr.cyctype==1) 
            tr.dataIn= rw.data;
        return tr;
    endfunction

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        lpc_transaction tr; tr=new("tr");
        if(!$cast(tr,bus_item)) begin
            `uvm_error(get_type_name(),"bus_item did not match tr")
            return;
        end
        rw.kind=(tr.cyctype[1]==1)? UVM_WRITE:UVM_READ;
        rw.addr=tr.addr;
        rw.data=(tr.cyctype[1]==1)? tr.dataIn:tr.dataOut;
        rw.status=UVM_IS_OK;
    endfunction
endclass

