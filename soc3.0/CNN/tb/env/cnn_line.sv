class cnn_line extends uvm_sequence_item;

	rand bit[7:0] r_line[256];
	rand bit[7:0] g_line[256];
	rand bit[7:0] b_line[256];
    rand bit frame_start = 0;

	function new(string name = "");
		super.new(name);
	endfunction: new

endclass: cnn_line
