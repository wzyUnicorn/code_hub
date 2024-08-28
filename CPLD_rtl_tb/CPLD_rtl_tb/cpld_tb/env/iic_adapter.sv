class iic_adapter extends uvm_reg_adapter;
    `uvm_object_utils(iic_adapter)
    function new(string name="iic_adapter");
        super.new(name);
    endfunction

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        iic_transaction tr; tr=new("tr");
        tr.regAddr = rw.addr;
        tr.trans= (rw.kind==UVM_READ)? 1:0;
        if(tr.trans==0) 
            tr.dataIN= rw.data;
        return tr;
    endfunction

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        iic_transaction tr; tr=new("tr");
        if(!$cast(tr,bus_item)) begin
            `uvm_error(get_type_name(),"bus_item did not match tr")
            return;
        end
        rw.kind=(tr.trans==0)? UVM_WRITE:UVM_READ;
        rw.addr=tr.regAddr;
        rw.data=(tr.trans==0)? tr.dataIN:tr.dataOUT;
        rw.status=UVM_IS_OK;
    endfunction
endclass

