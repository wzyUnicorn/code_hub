class isp_basic_sequence extends uvm_sequence#(isp_txn);
	`uvm_object_utils(isp_basic_sequence)
        `uvm_declare_p_sequencer(isp_virtual_sequencer);
	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
        integer file_;
        string  line_data =  "";
        bit     fmt_revert=0;
		isp_txn isp_tx;
        isp_tx = new("isp_tx");
        file_ = $fopen("isp_input.txt","w");


        assert(isp_tx.randomize()with {
	       demosic_en == 1;
           dgain_en == 0;
           dgain_gain == 1;
           dgain_offset == 0;
           isp_width == 256;
           isp_height == 20;
           isp_dummy_cycle == 60;
        })

// Gen correct data

        for(int j=0;j<isp_tx.isp_height;j++) begin
            for(int i=0;i<isp_tx.isp_width;i++) begin
                if(fmt_revert ==0) begin
                    if(i%2==0) begin
                        isp_tx.data_fmt[j][i] = FMT_B ;
                        isp_tx.pixl_data[j][i].pixl = isp_tx.pixl_data[j][i].pixl+'h40;
                    end else
                        isp_tx.data_fmt[j][i] = FMT_Gb ;
                end 
                else begin
                    if(i%2==0) begin
                        isp_tx.data_fmt[j][i] = FMT_Gr ;
                    end
                    else begin
                        isp_tx.data_fmt[j][i] = FMT_R ;
                        isp_tx.pixl_data[j][i].pixl = isp_tx.pixl_data[j][i].pixl+'h40;
                    end
                end
            end
            if(fmt_revert == 0)
                fmt_revert = 1;
            else
                fmt_revert = 0;
        end

//
        
        for(int j=0;j<isp_tx.isp_height;j++) begin
            for(int i=0;i<isp_tx.isp_width;i++) begin
               line_data =  $sformatf("%s0x%h ",line_data,isp_tx.pixl_data[j][i].pixl);
               if(i%16==15) begin
                   $fwrite(file_,"%s\n",line_data);
                   line_data =  "";
               end
            end
        end

        $fclose(file_);

        $system("./isp_demosaic");

        start_item(isp_tx,-1,p_sequencer.isp_sqr);
        finish_item(isp_tx);
        get_response(rsp);
	endtask: body

endclass: isp_basic_sequence
