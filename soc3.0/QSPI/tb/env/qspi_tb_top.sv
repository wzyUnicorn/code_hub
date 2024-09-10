//`include "qspi_pkg.sv" 
//`include "apb_if.sv"
module qspi_tb_top;
	import uvm_pkg::*;
        bit rstn;
        bit clk;
        apb_if apb_vif();
	qspi_if qspi_vif();
        assign apb_vif.PCLK =clk;
	assign apb_vif.PRST = rstn;


        wire spi_clk;
        wire spi_csn0;
        wire spi_csn1;
        wire spi_csn2;
        wire spi_csn3;
        wire spi_sdo0;
        wire spi_sdo1;
        wire spi_sdo2;
        wire spi_sdo3;
        wire spi_oe0;
        wire spi_oe1;
        wire spi_oe2;
        wire spi_oe3;
        wire spi_sdi0;
        wire spi_sdi1;
        wire spi_sdi2;
        wire spi_sdi3;
        wire spi_rw;

        assign qspi_vif.spi_clk  = spi_clk;
        assign qspi_vif.spi_csn0 = spi_csn0;
        assign qspi_vif.spi_csn1 = spi_csn1;
        assign qspi_vif.spi_csn2 = spi_csn2;
        assign qspi_vif.spi_csn3 = spi_csn3;
        assign qspi_vif.spi_sdo0 = spi_sdo0;
        assign qspi_vif.spi_sdo1 = spi_sdo1;
        assign qspi_vif.spi_sdo2 = spi_sdo2;
        assign qspi_vif.spi_sdo3 = spi_sdo3;
        assign qspi_vif.spi_oe0  = spi_oe0;
        assign qspi_vif.spi_oe1  = spi_oe1;
        assign qspi_vif.spi_oe2  = spi_oe2;
        assign qspi_vif.spi_oe3  = spi_oe3;
        assign qspi_vif.spi_sdi0 = spi_sdi0;
        assign qspi_vif.spi_sdi1 = spi_sdi1;
        assign qspi_vif.spi_sdi2 = spi_sdi2;
        assign qspi_vif.spi_sdi3 = spi_sdi3;


	//Connects the Interface to the DUT
	apb_spi_master dut(
            .HCLK(clk),
            .HRESETn(rstn),
            .PADDR(apb_vif.PADDR),
            .PWDATA(apb_vif.PWDATA),
            .PWRITE(apb_vif.PWRITE),
            .PSEL(apb_vif.PSEL),
            .PENABLE(apb_vif.PENABLE),
            .PRDATA(apb_vif.PRDATA),
            .PREADY(apb_vif.PREADY),
            .PSLVERR(apb_vif.PSLVERR),
            .events_o(qspi_vif.interrupt),
            .spi_clk (spi_clk ),
            .spi_csn0(spi_csn0),
            .spi_csn1(spi_csn1),
            .spi_csn2(spi_csn2),
            .spi_csn3(spi_csn3),
            .spi_sdo0(spi_sdo0),
            .spi_sdo1(spi_sdo1),
            .spi_sdo2(spi_sdo2),
            .spi_sdo3(spi_sdo3),
            .spi_oe0 (spi_oe0 ),
            .spi_oe1 (spi_oe1 ),
            .spi_oe2 (spi_oe2 ),
            .spi_oe3 (spi_oe3 ),
            .spi_sdi0(spi_sdi0),
            .spi_sdi1(spi_sdi1),
            .spi_sdi2(spi_sdi2),
            .spi_sdi3(spi_sdi3)
                      );
        qspi_device device(
            .spi_clk (spi_clk ),
            .spi_csn0(spi_csn0),
            .spi_csn1(spi_csn1),
            .spi_csn2(spi_csn2),
            .spi_csn3(spi_csn3),
            .spi_sdo0(spi_sdi0),
            .spi_sdo1(spi_sdi1),
            .spi_sdo2(spi_sdi2),
            .spi_sdo3(spi_sdi3),
            .spi_oe0 (spi_oe0 ),
            .spi_oe1 (spi_oe1 ),
            .spi_oe2 (spi_oe2 ),
            .spi_oe3 (spi_oe3 ),
            .spi_sdi0(spi_sdo0),
            .spi_sdi1(spi_sdo1),
            .spi_sdi2(spi_sdo2),
            .spi_sdi3(spi_sdo3),
            .command_width(qspi_vif.command_width),
            .addr_width(qspi_vif.addr_width),
            .data_width(qspi_vif.data_width),
            .wdata_addr_dummy(qspi_vif.wdata_addr_dummy),
            .rdata_addr_dummy(qspi_vif.rdata_addr_dummy),
            .spi_rw(qspi_vif.spi_rw)
          
	    );

	initial begin
                uvm_config_db#(virtual apb_if)::set(uvm_root::get(),"uvm_test_top.env.apb_agt.*","apb_vif",apb_vif);
                uvm_config_db#(virtual qspi_if)::set(uvm_root::get(),"uvm_test_top.env.qspi_mon","qspi_vif",qspi_vif);
                uvm_config_db#(virtual qspi_if)::set(uvm_root::get(),"uvm_test_top.env.qspi_cov","qspi_vif",qspi_vif);
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
           #10000ns;
        end 
endmodule
