class reg_adapter extends uvm_reg_adapter;
     `uvm_object_utils(reg_adapter)
     function new(string name = "reg_adapter");
        super.new(name);
     endfunction
   
     virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        apb_txn  tr = apb_txn::type_id::create("tr");
        tr.pwrite = (rw.kind == UVM_READ) ? 0 : 1;  
        tr.pdata = rw.data;
        tr.paddr = rw.addr;     
        `uvm_info("reg2bus", $sformatf("ADDR: %h",tr.paddr),UVM_HIGH) 
        return tr;
     endfunction
        
     virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        apb_txn  tr;           
        if(!$cast(tr, bus_item)) begin
           `uvm_fatal("NOT_APB_TYPES","Provided bus_item is not correct type");
           return;
        end
        rw.kind = (tr.pwrite == 1) ? UVM_WRITE : UVM_READ;
        rw.data = tr.pdata;
        rw.addr = tr.paddr;    
        rw.status=UVM_IS_OK; 
     endfunction
endclass
