import "DPI-C" function int cnn(int cnn_data[1024],int cnn_kernel0[9],int cnn_kernel1[9], int cnn_line[900], int cnn_line_bias0,int cnn_line_bias1,int c_out0[900],int c_out1[900],int pool_out[450] , int cnn_result[2]);

class cnn_scoreboard extends uvm_scoreboard;
    sys_memory           sys_mem;

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
    bit[31:0] rdata;
    bit [31:0] dst_addr;

    integer file_id;

    integer ref_out;
    
    cnn_txn cnn_item;

    bit cnn_ongoing = 0;

	`uvm_component_utils(cnn_scoreboard)
	uvm_analysis_imp #(cnn_txn,cnn_scoreboard) cnn_imp;
	virtual cnn_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
        if (!uvm_config_db#(virtual cnn_if)::get(uvm_root::get(),this.get_full_name(),"cnn_vif", vif)) begin
           `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance ")
        end
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cnn_imp     	= new("cnn_imp", this);
        cnn_item        = new("cnn_item");
	endfunction: build_phase

	task run();

        wait(cnn_ongoing == 1);
        wait(vif.cnn_done_irq == 1);
        cnn_ongoing = 0;
        dst_addr = 'h0000007d0;

        file_id = $fopen("output.txt", "w");

        $fwrite(file_id, "cnn_conv_out: \n");

        for(int i=0;i<1800;i++) begin
            sys_mem.read(dst_addr+i*4,rdata);
            if(cnn_item.cnn_conv_out[i] != rdata) begin
                 `uvm_error("Data compare error", $sformatf("Error @cnn_conv_out[%d] ,Expect 0x%h while 0x%h",i,cnn_item.cnn_conv_out[i],rdata))
            end
            $fwrite(file_id, "0x%h \n",rdata);
        end

        $fwrite(file_id, "cnn_pool_out: \n");

        for(int i=0;i<450;i++) begin
            sys_mem.read(dst_addr+'h1c20+i*4,rdata);
            if(cnn_item.cnn_pool_out[i] != rdata) begin
               `uvm_error("Data compare error", $sformatf("Error @pool_out[%d] ,Expect 0x%h while 0x%h",i,cnn_item.cnn_pool_out[i],rdata))
            end
            $fwrite(file_id, "0x%h \n",rdata);
        end

        sys_mem.read(dst_addr+'h2328,rdata);

        $fwrite(file_id, "cnn_line_out: \n");
        $fwrite(file_id, "0x%h \n",rdata);

        if(cnn_item.cnn_line_out[0] != rdata) begin
            `uvm_error("Data compare error", $sformatf("Error CNN result  ,Expect 0x%h while 0x%h",cnn_item.cnn_line_out[0],rdata))
        end

        $fclose(file_id);
        `uvm_info("CNN SCOREBOARD ", $sformatf("CNN Simulation Done! "),UVM_LOW)

	endtask: run

    function void write(cnn_txn tr);
       tr.print();
       cnn_item.copy(tr);
       cnn_ongoing = 1;
       cnn_data_a     = "";
       cnn_kernel0_a  = "";
       cnn_kernel1_a  = "";
       cnn_out0_a     = "";
       cnn_out1_a     = "";
       cnn_line0_a    = "";
       cnn_line1_a    = "";
       pool_out_a     = "";
       lines0_bias0_a = "";
       lines1_bias1_a = "";

       for(int i=0;i<1024;i++) begin
           cnn_data[i] = cnn_item.cnn_data[i];
       end

       for(int i=0;i<1024;i++) begin
           cnn_data_a = {cnn_data_a,$sformatf("0x%h ", cnn_data[i][7:0])};
           if(i%32==31) cnn_data_a = {cnn_data_a," \n"};
       end
       $display("Get cnn_data_a:\n%s \n",cnn_data_a);

       for(int i=0;i<9;i++) begin
           cnn_kernel0[i] = cnn_item.cnn_kernel0[i];
           cnn_kernel0_a = {cnn_kernel0_a,$sformatf("0x%h ",cnn_kernel0[i][7:0])};
           if(i%3==2) cnn_kernel0_a = {cnn_kernel0_a," \n"};
       end
       $display("Get cnn_kernel0:\n%s \n",cnn_kernel0_a);

       for(int i=0;i<9;i++) begin
           cnn_kernel1[i] = cnn_item.cnn_kernel1[i];
           cnn_kernel1_a = {cnn_kernel1_a,$sformatf("0x%h ",cnn_kernel1[i][7:0])};
           if(i%3==2) cnn_kernel1_a = {cnn_kernel1_a," \n"};
       end
       $display("Get cnn_kernel1:\n%s \n",cnn_kernel1_a);


       for(int i=0;i<450;i++) begin
           cnn_line[i] = cnn_item.lines0[i];
           cnn_line0_a = {cnn_line0_a,$sformatf("0x%h ",cnn_line[i][7:0])};
           if(i%15==14) cnn_line0_a = {cnn_line0_a," \n"};
       end
       $display("Get cnn_line0:\n%s \n",cnn_line0_a);

       for(int i=0;i<450;i++) begin
           cnn_line[450+i] = cnn_item.lines1[i];
           cnn_line1_a = {cnn_line1_a,$sformatf("0x%h ",cnn_line[450+i][7:0])};
           if(i%15==14) cnn_line1_a = {cnn_line1_a," \n"};
       end
       $display("Get cnn_line1:\n%s \n",cnn_line1_a);


       lines0_bias0_a = $sformatf("0x%h ",cnn_item.lines0_bias0);
       $display("Get lines0_bias0_a:\n%s \n",lines0_bias0_a);

       lines1_bias1_a = $sformatf("0x%h ",cnn_item.lines1_bias1);
       $display("Get lines0_bias0_a:\n%s \n",lines1_bias1_a);

       cnn_line_bias0 = cnn_item.lines0_bias0;
       cnn_line_bias1 = cnn_item.lines1_bias1;
       
       $display("Before DPI-C:\n");
       ref_out = cnn(cnn_data,cnn_kernel0,cnn_kernel1,cnn_line,cnn_line_bias0,cnn_line_bias1,c_out0,c_out1,pool_out,cnn_result);
       $display("After DPI-C:c_out0[0] = %h \n",c_out0[0]);

       for(int i=0;i<900;i++) begin
           cnn_item.cnn_conv_out[i] = c_out0[i][7:0];
       end

       for(int i=0;i<900;i++) begin
           cnn_out0_a = {cnn_out0_a,$sformatf("0x%h ",c_out0[i][7:0])};
           if(i%30==29) cnn_out0_a = {cnn_out0_a," \n"};
       end
       $display("Get cnn_out0_a:\n%s \n",cnn_out0_a);

       for(int i=0;i<900;i++) begin
           cnn_out1_a = {cnn_out1_a,$sformatf("0x%h ",c_out1[i][7:0])};
           if(i%30==29) cnn_out1_a = {cnn_out1_a," \n"};
       end
       $display("Get cnn_out1_a:\n%s \n",cnn_out1_a);

       for(int i=0;i<900;i++) begin
          cnn_item.cnn_conv_out[i+900] = c_out1[i][7:0];
       end

       for(int i=0;i<450;i++) begin
           cnn_item.cnn_pool_out[i] = pool_out[i][7:0];
           pool_out_a = {pool_out_a,$sformatf("0x%h ",pool_out[i][7:0])};
           if(i%15==14) pool_out_a = {pool_out_a," \n"};
       end
       $display("Get pool_out_a:\n%s \n",pool_out_a);

       cnn_item.cnn_line_out[0] = cnn_result[0];

       cnn_item.print();
    endfunction

endclass: cnn_scoreboard
