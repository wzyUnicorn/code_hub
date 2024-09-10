class cnn_txn extends uvm_sequence_item;

	rand bit [31:0]  cnn_data[];

    rand bit [31:0]  cnn_conv_out[];

    rand bit [31:0]  cnn_pool_out[];
    
    rand bit [31:0]  cnn_line_out[];
    
    rand bit [31:0]  cnn_kernel0[];

    rand bit [31:0]  cnn_kernel1[];

    rand bit [31:0]  kernel_bias0;
    
    rand bit [31:0]  kernel_bias1;

    rand bit [31:0]  lines0[];

    rand bit [31:0]  lines1[];

    rand bit [31:0]  lines0_bias0;

    rand bit [31:0]  lines1_bias1;

    constraint data_size_con {
        cnn_data.size() == 1024;
        cnn_conv_out.size() == 1800;
        cnn_pool_out.size() == 450;
        cnn_line_out.size() == 2;
        cnn_kernel0.size() == 10;
        cnn_kernel1.size() == 10;
        lines0.size() == 450;
        lines1.size() == 450;
    }

    constraint data_value_con {
        foreach(cnn_data[i])  cnn_data[i][31:8] == 0;
        foreach(cnn_kernel0[i])  cnn_kernel0[i][31:8] == 0;
        foreach(cnn_kernel1[i])  cnn_kernel1[i][31:8] == 0;

        foreach(cnn_conv_out[i])  cnn_conv_out[i] == 0;
        foreach(cnn_pool_out[i])  cnn_pool_out[i] == 0;
        foreach(cnn_line_out[i])  cnn_line_out[i][31:8] == 0;

        foreach(lines0[i])  lines0[i][31:8] == 0;
        foreach(lines1[i])  lines1[i][31:8] == 0;

        lines0_bias0[31:8] == 0;
        lines1_bias1[31:8] == 0;

    }

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(cnn_txn)
	    `uvm_field_array_int(cnn_data, UVM_ALL_ON )
        `uvm_field_array_int(cnn_conv_out, UVM_ALL_ON )
        `uvm_field_array_int(cnn_pool_out, UVM_ALL_ON )
        `uvm_field_array_int(cnn_line_out, UVM_ALL_ON )
        `uvm_field_array_int(cnn_kernel0, UVM_ALL_ON )
        `uvm_field_array_int(cnn_kernel1, UVM_ALL_ON )
        `uvm_field_int(kernel_bias0, UVM_ALL_ON )
        `uvm_field_int(kernel_bias1, UVM_ALL_ON )
        `uvm_field_array_int(lines0, UVM_ALL_ON )
        `uvm_field_array_int(lines1, UVM_ALL_ON )
        `uvm_field_int(lines0_bias0, UVM_ALL_ON )
        `uvm_field_int(lines1_bias1, UVM_ALL_ON )
	`uvm_object_utils_end

endclass: cnn_txn

