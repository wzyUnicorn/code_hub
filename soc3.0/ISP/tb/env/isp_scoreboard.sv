class isp_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(isp_scoreboard)
	uvm_analysis_export #(isp_line) sb_export_isp;
	uvm_tlm_analysis_fifo #(isp_line) isp_fifo;

	isp_line isp_tx;

	function new(string name, uvm_component parent);
		super.new(name, parent);
        isp_tx  = new("isp_tx");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_export_isp     	= new("sb_export_isp", this);
        isp_fifo	  	    = new("isp_fifo", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
                sb_export_isp.connect(isp_fifo.analysis_export);
	endfunction: connect_phase

	task run();
        reg [7:0] golden_data[256];
        integer fd_1;
        integer fd_2;
        integer fd_3;

        integer fd_ok;
        string  result; 
        bit[7:0] rdata[16];
        bit[31:0] line_cnt;
        bit[31:0] pixl_cnt;
        bit[31:0] real_data;
        bit[31:0] c_data;

        fork
		    forever begin
		    	isp_fifo.get(isp_tx);
                
                if(isp_tx.frame_start==1) begin
                    fd_1 = $fopen("result_r.txt","r");
                    fd_2 = $fopen("result_g.txt","r");
                    fd_3 = $fopen("result_b.txt","r");
                end

                if(line_cnt>1) begin
                   pixl_cnt = 0;
                   for(int i=0;i<16;i++) begin
                       fd_ok = $fgets(result,fd_1);
                       $sscanf(result,"0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h",
                           rdata[0],rdata[1],rdata[2],rdata[3],rdata[4],rdata[5],rdata[6],rdata[7],rdata[8],rdata[9],rdata[10],rdata[11],rdata[12],rdata[13],rdata[14],rdata[15]);             
                       for(int p=0;p<16;p++) begin
                           real_data = isp_tx.r_line[pixl_cnt+1];
                           c_data = rdata[p];
                           if(((real_data+2 < c_data) || (real_data>c_data+2))&&(c_data != 0)&&(real_data != 0) && (line_cnt>3)&&(pixl_cnt>3)&&(pixl_cnt<253) )
                               `uvm_error("ISP_Scoreboard",$sformatf("R[%0d][%0d]  expect data 0x%h  real data 0x%h",line_cnt,pixl_cnt,rdata[p],isp_tx.r_line[pixl_cnt+1]));
                           pixl_cnt = pixl_cnt+1;
                       end
                   end

                   pixl_cnt = 0;
                   for(int i=0;i<16;i++) begin
                       fd_ok = $fgets(result,fd_2);
                       $sscanf(result,"0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h",
                           rdata[0],rdata[1],rdata[2],rdata[3],rdata[4],rdata[5],rdata[6],rdata[7],rdata[8],rdata[9],rdata[10],rdata[11],rdata[12],rdata[13],rdata[14],rdata[15]);             
                       for(int p=0;p<16;p++) begin
                           real_data = isp_tx.g_line[pixl_cnt+1];
                           c_data = rdata[p];
                           if(((real_data+2 < c_data) || (real_data>c_data+2))&&(c_data != 0)&&(real_data != 0)&& (line_cnt>3)&&(pixl_cnt<253))
                               `uvm_error("ISP_Scoreboard",$sformatf("G[%0d][%0d]  expect data 0x%h  real data 0x%h",line_cnt,pixl_cnt,rdata[p],isp_tx.g_line[pixl_cnt+1]));
                           pixl_cnt = pixl_cnt+1;
                       end
                   end

                   pixl_cnt = 0;
                   for(int i=0;i<16;i++) begin
                       fd_ok = $fgets(result,fd_3);
                       $sscanf(result,"0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h",
                           rdata[0],rdata[1],rdata[2],rdata[3],rdata[4],rdata[5],rdata[6],rdata[7],rdata[8],rdata[9],rdata[10],rdata[11],rdata[12],rdata[13],rdata[14],rdata[15]);             
                       for(int p=0;p<16;p++) begin
                           real_data = isp_tx.b_line[pixl_cnt+1];
                           c_data = rdata[p];
                           if(((real_data+2 < c_data) || (real_data>c_data+2))&&(c_data != 0)&&(real_data != 0)&& (line_cnt>3)&&(pixl_cnt<253))
                               `uvm_error("ISP_Scoreboard",$sformatf("B[%0d][%0d]  expect data 0x%h  real data 0x%h",line_cnt,pixl_cnt,rdata[p],isp_tx.b_line[pixl_cnt+1]));
                           pixl_cnt = pixl_cnt+1;
                       end
                   end
                end
                line_cnt = line_cnt + 1;

		    end
        join
	endtask: run

endclass: isp_scoreboard
