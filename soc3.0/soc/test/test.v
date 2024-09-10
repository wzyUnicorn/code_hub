`define I2C

module test;

reg clk_cpu  ;
reg pclk     ;
reg prest_n  ;
reg rst_n_cpu;
wire [24:1] pad;

wire jtag_test_start;
wire jtag_test_done;

wire qspi0_test_start;
wire qspi1_test_start;
wire i2c_test_start;


initial begin
    force jtag_test_start  = test.inst_soc_top.jtag_test_start ;
    force qspi0_test_start = test.inst_soc_top.qspi0_test_start;
    force qspi1_test_start = test.inst_soc_top.qspi1_test_start;
    force i2c_test_start   = test.inst_soc_top.i2c_test_start  ;

end


initial 
 begin
  clk_cpu=1'b0;
  pclk   =1'b0;
  prest_n =1'b0;
  rst_n_cpu=1'b0;
 #1000
    prest_n=1'b1;
 #1000
    rst_n_cpu =1'b1;

 end  

//clk_cpu
always #(5)  clk_cpu=~clk_cpu;

always @(posedge clk_cpu or negedge rst_n_cpu)
  if(!rst_n_cpu)
    pclk <=1'b0;
  else 
    pclk<=~pclk;



wire spi0_clk ;
wire spi0_csn0;
wire spi0_csn1;
wire spi0_csn2;
wire spi0_csn3;
wire spi0_sdo0;
wire spi0_sdo1;
wire spi0_sdo2;
wire spi0_sdo3;
wire spi0_oe0 ;
wire spi0_oe1 ;
wire spi0_oe2 ;
wire spi0_oe3 ;
wire spi0_sdi0;
wire spi0_sdi1;
wire spi0_sdi2;
wire spi0_sdi3; 

wire spi1_clk ;
wire spi1_csn0;
wire spi1_csn1;
wire spi1_csn2;
wire spi1_csn3;
wire spi1_sdo0;
wire spi1_sdo1;
wire spi1_sdo2;
wire spi1_sdo3;
wire spi1_oe0 ;
wire spi1_oe1 ;
wire spi1_oe2 ;
wire spi1_oe3 ;
wire spi1_sdi0;
wire spi1_sdi1;
wire spi1_sdi2;
wire spi1_sdi3;

wire scl_pad_i;
wire scl_pad_o;
wire sda_pad_i;
wire sda_pad_o;

wire ua_txd   ; 
wire ua_rxd   ; 

wire tdo      ; 
wire tms      ;
wire tclk     ;
wire tdi      ;
wire trst     ; 

initial begin
force pad[21] = clk_cpu;
force pad[22] = rst_n_cpu;
force pad[23] = clk_cpu;
force pad[24] = prest_n;
end

always @({jtag_test_start,qspi0_test_start,qspi1_test_start,i2c_test_start}) begin
    if(jtag_test_start) begin
        force   tdo    = pad[16];
        force   pad[13]  = tms  ;
        force   pad[12]  = tclk ;
        force   pad[15]  = tdi  ;
        force   pad[14]  = trst ;
    end
    
    if(qspi0_test_start) begin
        force   spi0_clk   = pad[1] ; 
        force   spi0_csn0  = pad[2] ;
        force   spi0_csn1  = pad[5] ;
        force   spi0_csn2  = pad[8] ;
        force   spi0_csn3  = pad[11];
        force   pad[4]     = spi0_sdo0;
        force   pad[7]     = spi0_sdo1;
        force   pad[10]    = spi0_sdo2;
        force   pad[13]    = spi0_sdo3;
        force   spi0_sdi0  = pad[3]  ;
        force   spi0_sdi1  = pad[6]  ;
        force   spi0_sdi2  = pad[9]  ;
        force   spi0_sdi3  = pad[12] ;
    end

    if(qspi1_test_start) begin
        force   spi1_clk   = pad[2]  ; 
        force   spi1_csn0  = pad[3]  ;
        force   spi1_csn1  = pad[6]  ;
        force   spi1_csn2  = pad[9]  ;
        force   spi1_csn3  = pad[12] ;
        force   pad[5]     = spi1_sdo0;
        force   pad[8]     = spi1_sdo1;
        force   pad[11]    = spi1_sdo2;
        force   pad[14]    = spi1_sdo3;
        force   spi1_sdi0  = pad[4]  ;
        force   spi1_sdi1  = pad[7]  ;
        force   spi1_sdi2  = pad[10] ;
        force   spi1_sdi3  = pad[13] ;
    end

    if(i2c_test_start) begin
        force   scl_pad_i  = test.inst_soc_top.i2c0_scl_padoen_o;
        force   test.inst_soc_top.i2c0_scl_pad_i  = scl_pad_o;
        force   sda_pad_i  = test.inst_soc_top.i2c0_sda_padoen_o  ;
        force   test.inst_soc_top.i2c0_sda_pad_i     = sda_pad_o  ;
    end

end

assign  ua_txd     = pad[19] ;
assign  pad[20]    = ua_rxd  ;


soc_top inst_soc_top (
.pad(pad)
);

  
qspi_device inst_qspi_device0
(
.spi_clk (spi0_clk ),
.spi_csn0(spi0_csn0),
.spi_csn1(spi0_csn1),
.spi_csn2(spi0_csn2),
.spi_csn3(spi0_csn3),
.spi_sdo0(spi0_sdo0),
.spi_sdo1(spi0_sdo1),
.spi_sdo2(spi0_sdo2),
.spi_sdo3(spi0_sdo3),
.spi_sdi0(spi0_sdi0),
.spi_sdi1(spi0_sdi1),
.spi_sdi2(spi0_sdi2),
.spi_sdi3(spi0_sdi3) 
);

qspi_device inst_qspi_device1
(
.spi_clk (spi1_clk ),
.spi_csn0(spi1_csn0),
.spi_csn1(spi1_csn1),
.spi_csn2(spi1_csn2),
.spi_csn3(spi1_csn3),
.spi_sdo0(spi1_sdo0),
.spi_sdo1(spi1_sdo1),
.spi_sdo2(spi1_sdo2),
.spi_sdo3(spi1_sdo3),
.spi_sdi0(spi1_sdi0),
.spi_sdi1(spi1_sdi1),
.spi_sdi2(spi1_sdi2),
.spi_sdi3(spi1_sdi3)
);

i2c_device  i2c_dev (
    .scl_pad_i   (scl_pad_i), 
    .scl_pad_o   (scl_pad_o), 
    .sda_pad_i   (sda_pad_i), 
    .sda_pad_o   (sda_pad_o) 
);

// UART SLAVE 
uart_slave uart(
  .clk     (clk_cpu   ),
  .reset_n (rst_n_cpu ),
  .rx      (ua_txd    ),
  .tx      (ua_rxd    )
);

jtag_master jtag_mst
(
    .jtag_test_start(jtag_test_start),
    .trst(trst),
    .tdo (tdo),
    .tms (tms),
    .tclk(tclk),
    .tdi (tdi),
    .jtag_test_done(jtag_test_done)

);

initial
   begin  
        $display("Begin of reading hex");
        #1ns;
        $readmemh("mem.data",test.inst_soc_top.inst_sram.ram);
        $readmemh("dma_test.data",test.inst_soc_top.inst_sram.ram);
        //$readmemh("uart.vmem",test.inst_soc_top.inst_sram.ram);
        //$readmemh("led.vmem",test.inst_soc_top.inst_sram.ram);
        //$readmemh("hello_test.vmem",test.inst_soc_top.inst_sram.ram);
        $readmemh("cnn_input.data",test.inst_soc_top.inst_sram.ram);
        //$display("Byte 0 : %h",test.inst_soc_top.inst_sram.ram[0]);
        //$display("Byte 1 : %h",test.inst_soc_top.inst_sram.ram[1]);
        //$display("Byte 2 : %h",test.inst_soc_top.inst_sram.ram[2]);
        //$display("Byte 3 : %h",test.inst_soc_top.inst_sram.ram[3]);
        //$display("Byte 4 : %h",test.inst_soc_top.inst_sram.ram[4]);
        //$display("Byte 5 : %h",test.inst_soc_top.inst_sram.ram[5]);
        //$display("Byte 6 : %h",test.inst_soc_top.inst_sram.ram[6]);
        //$display("Byte 7 : %h",test.inst_soc_top.inst_sram.ram[7]);
        //$display("Byte 70 : %h",test.inst_soc_top.inst_sram.ram[70]);
        //$display("Byte 71 : %h",test.inst_soc_top.inst_sram.ram[71]);
  #3600000 
  $finish;
end

initial 
   begin
       wait(jtag_test_done==1);
       test.inst_soc_top.inst_sram.ram['h4002] = 2;
   end

initial 
  begin
      $display("Message! dump waveform to test.fsdb");
      $fsdbDumpfile("soc.fsdb");
      $fsdbDumpvars(0,test);
      $fsdbDumpSVA;
  end

  `ifdef SOC_TB_MODE
      `include "soc_tb_mod.sv"
  `endif


endmodule
