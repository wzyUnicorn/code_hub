class apb_txn extends uvm_sequence_item;
	rand bit[31:0] pdata;
	rand bit[11:0] paddr;
	rand bit       pwrite;
	function new(string name = "");
		super.new(name);
	endfunction: new
	`uvm_object_utils_begin(apb_txn)
		`uvm_field_int(pdata, UVM_ALL_ON)
		`uvm_field_int(paddr, UVM_ALL_ON)
		`uvm_field_int(pwrite, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: apb_txn
