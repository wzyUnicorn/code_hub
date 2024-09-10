module cnn_tb_top;
	import uvm_pkg::*;
//    import "DPI-C" function int cnn(int cnn_data[1024],int cnn_kernel0[9],int cnn_kernel1[9], int c_out0[900],int c_out1[900],int line_out[450]); //yadebug here 6540 
    bit rstn;
    bit clk;
	apb_if apb_vif();
	ahb_if ahb_vif();
    cnn_if cnn_vif();
    int c_in[1024];
    integer ref_out;

    assign apb_vif.PCLK =clk;
	assign apb_vif.PRST = rstn;
    assign ahb_vif.hclk = clk;
    assign ahb_vif.hrstn = rstn;

	//Connects the Interface to the DUT

     cnn_top cnn_inst(
         // AHB master interface  connect to cnn
         .hclk              (ahb_vif.hclk),
         .hrstn             (ahb_vif.hrstn),
     //    .hsel              (ahb_vif.hsel),
         .haddr             (ahb_vif.haddr),
         .htrans            (ahb_vif.htrans),
         .hsize             (ahb_vif.hsize),
         .hwrite            (ahb_vif.hwrite),
         .hready            (ahb_vif.hready),
         .hwdata            (ahb_vif.hwdata),
         .hrdata            (ahb_vif.hrdata),
    //     .hreadyout         (ahb_vif.hreadyout),
         .hresp             (ahb_vif.hresp),
         .pclk              (apb_vif.PCLK),
         .prstn             (apb_vif.PRST),
         .paddr             (apb_vif.PADDR),
         .psel              (apb_vif.PSEL),
         .penable           (apb_vif.PENABLE),
         .pwrite            (apb_vif.PWRITE),
         .pwdata            (apb_vif.PWDATA),
         .pready            (apb_vif.PREADY),
         .prdata            (apb_vif.PRDATA),
         .cnn_intr_done_req (cnn_vif.cnn_done_irq),
         .cnn_intr_ovf_req  (),
         .cnn_intr_unf_req  ()
     );



	  initial begin
          uvm_config_db#(virtual apb_if)::set(uvm_root::get(),"uvm_test_top.env.apb_agt.apb_drv","apb_vif",apb_vif);
          uvm_config_db#(virtual apb_if)::set(uvm_root::get(),"uvm_test_top.env.apb_agt.apb_mon","apb_vif",apb_vif);
          uvm_config_db#(virtual ahb_if)::set(uvm_root::get(),"uvm_test_top.env.ahb_slv_agt.ahb_slv_drv","ahb_vif",ahb_vif);
          uvm_config_db#(virtual cnn_if)::set(uvm_root::get(),"uvm_test_top.env.cnn_scb","cnn_vif",cnn_vif);

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
           $fsdbDumpvars(0);
      end

      initial begin
         #100000ns;
      end

//      initial begin
//          int cnn_data[1024];
//          int cnn_kernel0[9];
//          int cnn_kernel1[9];
//          int c_out0[900];
//          int c_out1[900];
//          int line_out[450];
//          $display("Before DPI-C:\n",c_in);
//          ref_out = cnn(cnn_data,cnn_kernel0,cnn_kernel1,c_out0,c_out1,line_out);
//          #100;
//          $display("After DPI-C:%d\n",ref_out);
//      end

endmodule
