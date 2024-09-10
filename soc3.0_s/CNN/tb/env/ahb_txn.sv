class ahb_txn extends uvm_sequence_item;
    rand bit    [31:0] haddr     ;
    rand bit    [ 1:0] htrans    ;
    rand bit    [ 2:0] hsize     ;
    rand bit    [2:0]  hburst    ;
    rand bit           hwrite    ;
    rand bit    [31:0] hwdata    ;
    rand bit    [31:0] hrdata    ;
    rand bit           hresp     ;
	
    function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(ahb_txn)
        `uvm_field_int(haddr ,UVM_ALL_ON)    
        `uvm_field_int(htrans,UVM_ALL_ON)    
        `uvm_field_int(hsize ,UVM_ALL_ON)    
        `uvm_field_int(hburst,UVM_ALL_ON)    
        `uvm_field_int(hwrite,UVM_ALL_ON)    
        `uvm_field_int(hwdata,UVM_ALL_ON)    
        `uvm_field_int(hrdata,UVM_ALL_ON)    
        `uvm_field_int(hresp ,UVM_ALL_ON)    
	`uvm_object_utils_end

endclass: ahb_txn
