module isp_tb_top;
	import uvm_pkg::*;
    bit rstn;
    bit clk;
	isp_if isp_vif();
    assign isp_vif.pclk =clk;
	assign isp_vif.rst_n = rstn;



	//Connects the Interface to the DUT
	isp_top #(8,256,10,0)dut (
      .pclk         (isp_vif.pclk),
      .rst_n        (isp_vif.rst_n),

      .in_href      (isp_vif.in_href),
      .in_vsync     (isp_vif.in_vsync),
      .in_raw       (isp_vif.in_raw),
      
      .dm_href_o    (isp_vif.dm_href_o),
      .dm_vsync_o   (isp_vif.dm_vsync_o),
      .dm_r_o       (isp_vif.dm_r_o),
      .dm_g_o       (isp_vif.dm_g_o),
      .dm_b_o       (isp_vif.dm_b_o),
      
      .dgain_en     (isp_vif.dgain_en), 
      .demosic_en   (isp_vif.demosic_en), 

      .dgain_gain   (isp_vif.dgain_gain),
      .dgain_offset (isp_vif.dgain_offset)
            
	    );

	  initial begin
                  uvm_config_db#(virtual isp_if)::set(uvm_root::get(),"uvm_test_top.env.isp_mon","isp_vif",isp_vif);
                  uvm_config_db#(virtual isp_if)::set(uvm_root::get(),"uvm_test_top.env.isp_agt.isp_drv","isp_vif",isp_vif);
                  run_test();
	  end


        initial forever #5ns clk <= !clk;
        initial begin
            rstn = 0;
            #1ns;
            rstn = 1;
        end
        initial begin
             $fsdbDumpfile("tb.fsdb");
             $fsdbDumpvars("+all");
        end
        initial begin
           #100000ns;
        end 
endmodule
