class qspi_txn extends uvm_sequence_item;
	rand bit[31:0] data[int];
	rand bit[15:0] addr;
	rand bit[15:0] command;
	rand bit       qspi_write;
	function new(string name = "");
		super.new(name);
	endfunction: new
	`uvm_object_utils_begin(qspi_txn)
		`uvm_field_aa_int_int(data, UVM_ALL_ON)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(command, UVM_ALL_ON)
		`uvm_field_int(qspi_write, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: qspi_txn
