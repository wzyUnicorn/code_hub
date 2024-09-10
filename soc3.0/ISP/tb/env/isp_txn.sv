typedef enum {FMT_B,FMT_Gb,FMT_Gr,FMT_R} isp_fmt_e;
class isp_pixl extends uvm_sequence_item;
    rand bit[7:0] pixl;
    rand bit[7:0] pixl_diff;
    constraint pixl_c {
         pixl inside {['h0:'h3f]};
    }
	function new(string name = "");
		super.new(name);
	endfunction: new
endclass: isp_pixl

class isp_txn extends uvm_sequence_item;

	rand isp_pixl pixl_data[256][256];
    isp_fmt_e data_fmt[256][256];
	rand bit  demosic_en;
    rand bit  dgain_en;
    rand bit  [7:0] dgain_gain;
    rand bit  [7:0] dgain_offset;
    rand bit  [31:0] isp_width;
    rand bit  [31:0] isp_height;
    rand bit  [31:0] isp_dummy_cycle;

    constraint dgain_gain_c {
        dgain_gain inside {[1:100]};
    };

    constraint dgain_offset_c {
        dgain_offset == 0;
    };

    constraint isp_size_c {
        isp_width inside {[10:512]};
        isp_height inside {[10:512]};
    };

    constraint isp_dummy_cycle_c {
        isp_dummy_cycle inside {[50:512]};
    };

	function new(string name = "");
		super.new(name);
        for(int i=0;i<256;i++) begin
            for(int j=0;j<256;j++) begin
                 pixl_data[i][j] =  new($sformatf("pixl_data_%0d_%0d",i,j));
            end 
        end
	endfunction: new

endclass: isp_txn

