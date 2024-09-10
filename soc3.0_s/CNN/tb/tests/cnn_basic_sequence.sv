class cnn_basic_sequence extends uvm_sequence;
    
    cnn_txn   cnn_item;
    int cnn_data[1024];
    int cnn_kernel0[9];
    int cnn_kernel1[9];
    int c_out0[900];
    int c_out1[900];
    int pool_out[450];
    int line_out[450];
    int cnn_line[900];
    int cnn_result[2];
    int cnn_line_bias0;
    int cnn_line_bias1;



    integer ref_out;

	`uvm_object_utils(cnn_basic_sequence)
    `uvm_declare_p_sequencer(cnn_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
       uvm_status_e status;

       bit[31:0] wdata;
       bit[31:0] rdata;
       bit [31:0] mem_data[];
       bit [31:0] dst_addr;
       bit [31:0] line_cnt;
       
       string cnn_data_a;
       string cnn_kernel0_a;
       string cnn_kernel1_a;
       string cnn_out0_a;
       string cnn_out1_a;
       string cnn_line0_a;
       string cnn_line1_a;
       string pool_out_a;
       string lines0_bias0_a;
       string lines1_bias1_a;

       integer file_id;

       cnn_item = new("cnn_item");

       line_cnt = 0;

       cnn_item.randomize();

       cnn_item.pack_ints(mem_data);

       for(int i=0;i<1024;i++) begin
           cnn_data[i] = cnn_item.cnn_data[i];
       end

       for(int i=0;i<9;i++) begin
           cnn_kernel0[i] = cnn_item.cnn_kernel0[i];
           mem_data[3276+i] = cnn_kernel0[i];
       end

       for(int i=0;i<9;i++) begin
           cnn_kernel1[i] = cnn_item.cnn_kernel1[i];
           mem_data[3286+i] = cnn_kernel1[i];
       end

       for(int i=0;i<450;i++) begin
           cnn_line[i] = cnn_item.lines0[i];
           mem_data[3296+i] = cnn_line[i];
       end

       for(int i=0;i<450;i++) begin
           cnn_line[450+i] = cnn_item.lines1[i];
           mem_data[3746+i] = cnn_line[450+i];
       end

       mem_data[4196] = cnn_item.lines0_bias0;

       mem_data[4197] = cnn_item.lines1_bias1;

       cnn_line_bias0 = cnn_item.lines0_bias0;
       cnn_line_bias1 = cnn_item.lines1_bias1;

       p_sequencer.cnn_ap.write(cnn_item);

       p_sequencer.sys_mem.load_mem('h00000100,mem_data);

       file_id = $fopen("input.txt", "w");

       $fwrite(file_id, "cnn_input_data: \n");
       $fwrite(file_id, "@%h ",32'h00004000);
       foreach(mem_data[i]) begin
           $fwrite(file_id, "%h ",mem_data[i][7:0]);
           if(i%16==15) begin
               line_cnt = line_cnt+1;
               $fwrite(file_id, " \n@%h ",line_cnt*32'h10+32'h00004000);
           end
       end
       $fclose(file_id);

       dst_addr = 'h0000007d0;
       wdata = dst_addr;
       p_sequencer.cnn_rgm.CNN_DST_ADDR.write(status,wdata);
//
       wdata = 'h000000100;
       p_sequencer.cnn_rgm.CNN_SRC_ADDR.write(status,wdata);
//
       wdata = 'h00010001;
       p_sequencer.cnn_rgm.CNN_DMA_EN.write(status,wdata);
// 
       wdata = 'h202000e1;
       p_sequencer.cnn_rgm.CNN_COUNT0.write(status,wdata);
// 
       wdata = 'h000001c2;
       p_sequencer.cnn_rgm.CNN_COUNT1.write(status,wdata);
// cnn mode conv/pool/line
       wdata = 7;
       p_sequencer.cnn_rgm.CNN_CTRL1.write(status,wdata);

// cnn interrupt enable
       wdata= 'h7;
       p_sequencer.cnn_rgm.CNN_INT_EN.write(status,wdata);

// cnn start
       wdata= 'h1;
       p_sequencer.cnn_rgm.CNN_CTRL0.write(status,wdata);
       
       rdata = 0;
       while(rdata == 0) begin
           p_sequencer.cnn_rgm.CNN_INT.read(status,rdata);
       end


       #8000ns;
	endtask: body

endclass: cnn_basic_sequence
