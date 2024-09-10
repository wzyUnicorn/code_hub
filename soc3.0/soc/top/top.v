
module soc_top (
inout     [24 :1]  pad
);

//wire connect
 // Instruction memory interface
  wire                         instr_req_o;
  wire                         instr_gnt_i;
  wire                         instr_rvalid_i;
  wire [31:0]                  instr_addr_o;
  wire [31:0]                  instr_rdata_i;
  wire                         instr_err_i=1'b0;
  // Data memory interface
  wire                         data_req_o;
  wire                         data_gnt_i;
  wire                         data_rvalid_i;
  wire                         data_we_o;
  wire [3:0]                   data_be_o;
  wire [31:0]                  data_addr_o;
  wire [31:0]                  data_wdata_o;
  wire [31:0]                  data_rdata_i;
  wire                         data_err_i;

 //SRAM
 wire                          SRAM_HSELM0;
 wire                [31: 0]   SRAM_HADDRM0;
 wire                [1 : 0]   SRAM_HTRANSM0;
 wire                          SRAM_HWRITEM0;
 wire                [2 : 0]   SRAM_HSIZEM0;
 wire                [2 : 0]   SRAM_HBURSTM0;
 wire                [3 : 0]   SRAM_HPROTM0;
 wire                [3 : 0]   SRAM_HMASTERM0;
 wire                [31: 0]   SRAM_HWDATAM0;
 wire                          SRAM_HMASTLOCKM0;
 wire                          SRAM_HREADYMUXM0;
 wire               [31 : 0]   SRAM_HRDATAM0;
 wire                          SRAM_HREADYOUTM0;
 wire               [ 1 : 0]   SRAM_HRESPM0;

 //APB
 wire                          APB_HSELM1;
 wire                [31: 0]   APB_HADDRM1;
 wire                [1 : 0]   APB_HTRANSM1;
 wire                          APB_HWRITEM1;
 wire                [2 : 0]   APB_HSIZEM1;
 wire                [2 : 0]   APB_HBURSTM1;
 wire                [3 : 0]   APB_HPROTM1;
 wire                [3 : 0]   APB_HMASTERM1;
 wire                [31: 0]   APB_HWDATAM1;
 wire                          APB_HMASTLOCKM1;
 wire                          APB_HREADYMUXM1;
 wire               [31 : 0]   APB_HRDATAM1;
 wire                          APB_HREADYOUTM1;
 wire               [ 1 : 0]   APB_HRESPM1;

 //DMA
 wire                          DMA_HSELM2;
 wire                [31: 0]   DMA_HADDRM2;
 wire                [1 : 0]   DMA_HTRANSM2;
 wire                          DMA_HWRITEM2;
 wire                [2 : 0]   DMA_HSIZEM2;
 wire                [2 : 0]   DMA_HBURSTM2;
 wire                [3 : 0]   DMA_HPROTM2;
 wire                [3 : 0]   DMA_HMASTERM2;
 wire                [31: 0]   DMA_HWDATAM2;
 wire                          DMA_HMASTLOCKM2;
 wire                          DMA_HREADYMUXM2;
 wire               [31 : 0]   DMA_HRDATAM2;
 wire                          DMA_HREADYOUTM2;
 wire               [ 1 : 0]   DMA_HRESPM2;

//DMA
 wire                          DMA_HSELM3;
 wire                [31: 0]   DMA_HADDRM3;
 wire                [1 : 0]   DMA_HTRANSM3;
 wire                          DMA_HWRITEM3;
 wire                [2 : 0]   DMA_HSIZEM3;
 wire                [2 : 0]   DMA_HBURSTM3;
 wire                [3 : 0]   DMA_HPROTM3;
 wire                [3 : 0]   DMA_HMASTERM3;
 wire                [31: 0]   DMA_HWDATAM3;
 wire                          DMA_HMASTLOCKM3;
 wire                          DMA_HREADYMUXM3;
 wire               [31 : 0]   DMA_HRDATAM3;
 wire                          DMA_HREADYOUTM3;
 wire               [ 1 : 0]   DMA_HRESPM3;

//DM_MEM
 wire                          DM_MEM_HSELM4;
 wire                [31: 0]   DM_MEM_HADDRM4;
 wire                [1 : 0]   DM_MEM_HTRANSM4;
 wire                          DM_MEM_HWRITEM4;
 wire                [2 : 0]   DM_MEM_HSIZEM4;
 wire                [2 : 0]   DM_MEM_HBURSTM4;
 wire                [3 : 0]   DM_MEM_HPROTM4;
 wire                [3 : 0]   DM_MEM_HMASTERM4;
 wire                [31: 0]   DM_MEM_HWDATAM4;
 wire                          DM_MEM_HMASTLOCKM4;
 wire                          DM_MEM_HREADYMUXM4;
 wire               [31 : 0]   DM_MEM_HRDATAM4;
 wire                          DM_MEM_HREADYOUTM4;
 wire               [ 1 : 0]   DM_MEM_HRESPM4;

//unused in DM_MEM
//     DM_MEM_HTRANSM4
//     DM_MEM_HSIZEM4
//     DM_MEM_HBURSTM4
//     DM_MEM_HPROTM4
//     DM_MEM_HMASTERM4
//     DM_MEM_HMASTLOCKM4
assign DM_MEM_HRESPM4 = 2'b00;


wire [1:0]          inst_htrans_o; 
wire                  inst_hsel_o;
wire                inst_hready_o;
wire                inst_hwrite_o;
wire [31:0]        inst_haddr_o;
wire [2:0]           inst_hsize_o;
wire [2:0]          inst_hburst_o;
wire [3:0]           inst_hprot_o;
wire [31:0]       inst_hwdata_o;
wire                inst_hready_i;
wire                inst_hresp_i ;
wire                inst_hresp_tmp;
wire [31:0]          inst_hrdata_i;
 
wire [1:0]          data_htrans_o; 
wire                  data_hsel_o;
wire                data_hready_o;
wire                data_hwrite_o;
wire [31:0]        data_haddr_o;
wire [2:0]           data_hsize_o;
wire [2:0]          data_hburst_o;
wire [3:0]           data_hprot_o;
wire [31:0]       data_hwdata_o;
wire                data_hready_i;
wire                data_hresp_i ;
wire                data_hresp_tmp ;
wire [31:0]          data_hrdata_i;

wire [1:0]          dma_htrans_o; 
wire                dma_hsel_o;
wire                dma_hready_o;
wire                dma_hwrite_o;
wire [31:0]         dma_haddr_o;
wire [2:0]          dma_hsize_o;
wire [2:0]          dma_hburst_o;
wire [3:0]          dma_hprot_o;
wire [31:0]         dma_hwdata_o;
wire                dma_hready_i;
wire [1:0]          dma_hresp_i ;
wire                dma_hresp_tmp ;
wire [31:0]         dma_hrdata_i;

wire [1:0]          isp_rdma_htrans_o; 
wire                isp_rdma_hsel_o;
wire                isp_rdma_hready_o;
wire                isp_rdma_hwrite_o;
wire [31:0]         isp_rdma_haddr_o;
wire [2:0]          isp_rdma_hsize_o;
wire [2:0]          isp_rdma_hburst_o;
wire [3:0]          isp_rdma_hprot_o;
wire [31:0]         isp_rdma_hwdata_o;
wire                isp_rdma_hready_i;
wire [1:0]          isp_rdma_hresp_i ;
wire                isp_rdma_hresp_tmp ;
wire [31:0]         isp_rdma_hrdata_i;

wire [1:0]          isp_wdma_htrans_o; 
wire                isp_wdma_hsel_o;
wire                isp_wdma_hready_o;
wire                isp_wdma_hwrite_o;
wire [31:0]         isp_wdma_haddr_o;
wire [2:0]          isp_wdma_hsize_o;
wire [2:0]          isp_wdma_hburst_o;
wire [3:0]          isp_wdma_hprot_o;
wire [31:0]         isp_wdma_hwdata_o;
wire                isp_wdma_hready_i;
wire [1:0]          isp_wdma_hresp_i ;
wire                isp_wdma_hresp_tmp ;
wire [31:0]         isp_wdma_hrdata_i;




wire [2:0] r_io_reuse_pad2    ; 
wire [2:0] r_io_reuse_pad1    ; 
wire [2:0] r_io_reuse_pad4    ; 
wire [2:0] r_io_reuse_pad3    ; 
wire [2:0] r_io_reuse_pad6    ; 
wire [2:0] r_io_reuse_pad5    ; 
wire [2:0] r_io_reuse_pad8    ; 
wire [2:0] r_io_reuse_pad7    ; 
wire [2:0] r_io_reuse_pad10   ; 
wire [2:0] r_io_reuse_pad9    ; 
wire [2:0] r_io_reuse_pad12   ; 
wire [2:0] r_io_reuse_pad11   ; 
wire [2:0] r_io_reuse_pad14   ; 
wire [2:0] r_io_reuse_pad13   ; 
wire [2:0] r_io_reuse_pad16   ; 
wire [2:0] r_io_reuse_pad15   ; 
wire [2:0] r_io_reuse_pad18   ; 
wire [2:0] r_io_reuse_pad17   ; 
wire [2:0] r_io_reuse_pad20   ; 
wire [2:0] r_io_reuse_pad19   ; 




wire                 clk_cpu;
wire                 rst_n_cpu;
wire                 pclk;
wire                 prest_n;

wire                 spi0_clk; 
wire                 spi0_csn0;
wire                 spi0_csn1;
wire                 spi0_csn2;
wire                 spi0_csn3;
wire                 spi0_sdo0;
wire                 spi0_sdo1;
wire                 spi0_sdo2;
wire                 spi0_sdo3;
wire                 spi0_oe0;
wire                 spi0_oe1;
wire                 spi0_oe2;
wire                 spi0_oe3;
wire                 spi0_sdi0;
wire                 spi0_sdi1;
wire                 spi0_sdi2;
wire                 spi0_sdi3;
wire                 spi1_clk;
wire                 spi1_csn0;
wire                 spi1_csn1;
wire                 spi1_csn2;
wire                 spi1_csn3;
wire                 spi1_sdo0;
wire                 spi1_sdo1;
wire                 spi1_sdo2;
wire                 spi1_sdo3;
wire                 spi1_oe0;
wire                 spi1_oe1;
wire                 spi1_oe2;
wire                 spi1_oe3;
wire                 spi1_sdi0;
wire                 spi1_sdi1;
wire                 spi1_sdi2;
wire                 spi1_sdi3;
 
wire                 ua_rxd; 
wire                 ua_txd;  

wire [3:0]           pwm_o;  

wire                 i2c0_scl_pad_i;
wire                 i2c0_scl_pad_o; 
wire                 i2c0_scl_padoen_o; 

wire                 i2c0_sda_pad_i; 
wire                 i2c0_sda_pad_o; 
wire                 i2c0_sda_padoen_o;
 
wire                 i2c1_scl_pad_i;
wire                 i2c1_scl_pad_o;
wire                 i2c1_scl_padoen_o;

wire                 i2c1_sda_pad_i;
wire                 i2c1_sda_pad_o;
wire                 i2c1_sda_padoen_o;

//JTAG interface.
wire         tck_i;    // JTAG test clock pad
wire         tms_i;    // JTAG test mode select pad
wire         trst_ni;  // JTAG test reset pad
wire         td_i;     // JTAG test data input pad
wire         td_o;     // JTAG test data output pad
wire         tdo_oe_o;  // Data out output enable

// debug functionality is optional
localparam bit DBG = 1;
localparam int unsigned DbgHwBreakNum = (DBG == 1) ?    2 :    0;
localparam bit          DbgTriggerEn  = (DBG == 1) ? 1'b1 : 1'b0;

localparam logic [31:0] DEBUG_START   = 32'h1a110000;
localparam logic [31:0] DEBUG_SIZE    = 64 * 1024; // 64 KiB
localparam logic [31:0] DEBUG_MASK    = ~(DEBUG_SIZE-1);

dm_wrapper u_dm_wrapper(
  .clk_i(clk_cpu),       
  .rst_ni(rst_n_cpu),      
  .ndmreset_o(),  
  .debug_req_o(dm_debug_req), 

  //JTAG interface.
  .tck_i    ( tck_i    ), // JTAG test clock pad
  .tms_i    ( tms_i    ), // JTAG test mode select pad
  .trst_ni  ( trst_ni  ), // JTAG test reset pad
  .td_i     ( td_i     ), // JTAG test data input pad
  .td_o     ( td_o     ), // JTAG test data output pad
  .tdo_oe_o ( tdo_oe_o ),  // Data out output enable
/*
  output                dm_hmastlock,
  output [1:0]          dm_htrans_o,
  output                dm_hsel_o,
  output                dm_hready_o,
  output                dm_hwrite_o,
  output [31:0]         dm_haddr_o,
  output [2:0]          dm_hsize_o,
  output [2:0]          dm_hburst_o,
  output [3:0]          dm_hprot_o,
  output [31:0]         dm_hwdata_o,
  input                 dm_hreadyout_i,
  input                 dm_hresp_i,
  input  [31:0]         dm_hrdata_i,
*/
  .dm_mem_hsel(DM_MEM_HSELM4),
  .dm_mem_hwrite(DM_MEM_HWRITEM4),
  .dm_mem_hready(DM_MEM_HREADYMUXM4),
  .dm_mem_haddr(DM_MEM_HADDRM4),
  .dm_mem_hwdata(DM_MEM_HWDATAM4),
  .dm_mem_hreadyout(DM_MEM_HREADYOUTM4),
  .dm_mem_hrdata(DM_MEM_HRDATAM4)
);



//****************************************************************************
//ibex core 
ibex_top #(
    .DbgTriggerEn    ( DbgTriggerEn                            ),
    .DbgHwBreakNum   ( DbgHwBreakNum                           ),
    .DmHaltAddr      ( DEBUG_START + dm::HaltAddress[31:0]     ),
    .DmExceptionAddr ( DEBUG_START + dm::ExceptionAddress[31:0])
  ) 
    inst_ibex_top (
    .clk_i    (  clk_cpu),
    .rst_ni   (rst_n_cpu),
    .test_en_i  (   1'b0),
    .hart_id_i  (  32'd1),
    .boot_addr_i(  32'd0),
    .ram_cfg_i  (10'd0),
    .instr_req_o    (instr_req_o    ),
    .instr_gnt_i    (instr_gnt_i    ),
    .instr_rvalid_i (instr_rvalid_i ),
    .instr_addr_o   (instr_addr_o   ),
    .instr_rdata_i  (instr_rdata_i  ),
    .instr_err_i    (instr_err_i    ),
    .data_rdata_intg_i(7'd0),
    .instr_rdata_intg_i(7'd0),

    .data_req_o    (data_req_o    ),
    .data_gnt_i    (data_gnt_i    ),
    .data_rvalid_i (data_rvalid_i ),
    .data_we_o     (data_we_o     ),
    .data_be_o     (data_be_o     ),
    .data_addr_o   (data_addr_o   ),
    .data_wdata_o  (data_wdata_o  ),
    .data_rdata_i  (data_rdata_i  ),
    .data_err_i    (1'b0    ),

    .irq_software_i(          1'd0),
    .irq_timer_i   (          1'd0),
    .irq_external_i(          1'd0),
    .irq_fast_i    (          15'd0),
    .irq_nm_i      (          1'd0),
    .scramble_key_valid_i(1'd0),
    .scramble_key_i      (128'd0),
    .scramble_nonce_i    (64'd0),
    .scramble_req_o      (),
    .debug_req_i         (dm_debug_req),//update
    .crash_dump_o        (),
    .double_fault_seen_o (),

`ifdef RVFI
    .rvfi_valid,
    .rvfi_order,
    .rvfi_insn,
    .rvfi_trap,i
    .rvfi_halt,
    .rvfi_intr,
    .rvfi_mode,
    .rvfi_ixl,
    .rvfi_rs1_addr,
    .rvfi_rs2_addr,
    .rvfi_rs3_addr,
    .rvfi_rs1_rdata,
    .rvfi_rs2_rdata,
    .rvfi_rs3_rdata,
    .rvfi_rd_addr,
    .rvfi_rd_wdata,
    .rvfi_pc_rdata,
    .rvfi_pc_wdata,
    .rvfi_mem_addr,
    .rvfi_mem_rmask,
    .rvfi_mem_wmask,
    .rvfi_mem_rdata,
    .rvfi_mem_wdata,
    .rvfi_ext_mip,
    .rvfi_ext_nmi,
    .rvfi_ext_debug_req,
    .rvfi_ext_mcycle,
    .rvfi_ext_mhpmcounters,
    .rvfi_ext_mhpmcountersh,
`endif

    .fetch_enable_i        (4'b0101),
    .alert_minor_o         (),
    .alert_major_internal_o(core_alert_major_internal),
    .alert_major_bus_o     (core_alert_major_bus),
    //.core_busy_o           (core_busy_d),
    .scan_rst_ni           (1'b1)
  );

//core interface
core2ahb inst_instr_core2ahb(
.clk  (   clk_cpu),
.rst_n( rst_n_cpu),

.data_req   (   instr_req_o),
.data_gnt   (   instr_gnt_i),
.data_rvalid(instr_rvalid_i),
.data_we    (          1'd0),
.data_be    (          4'hf),
.data_addr  (  instr_addr_o),
.data_wdata (         32'd0),
.data_rdata ( instr_rdata_i),

//ahb interface
.ahb_hmastlock(),
.ahb_htrans   (inst_htrans_o),
.ahb_hsel     (  inst_hsel_o),
.ahb_hready   (inst_hready_o),
.ahb_hwrite   (inst_hwrite_o),
.ahb_haddr    ( inst_haddr_o),
.ahb_hsize    ( inst_hsize_o),
.ahb_hburst   (inst_hburst_o),
.ahb_hprot    ( inst_hprot_o),
.ahb_hwdata   (inst_hwdata_o),
.ahb_hreadyout(inst_hready_i),
.ahb_hresp    (inst_hresp_i ),
.ahb_hrdata   (inst_hrdata_i)
);

core2ahb inst_data_core2ahb(
.clk  (   clk_cpu),
.rst_n( rst_n_cpu),

.data_req   (   data_req_o),
.data_gnt   (   data_gnt_i),
.data_rvalid(data_rvalid_i),
.data_we    (    data_we_o),
.data_be    (    data_be_o),
.data_addr  (  data_addr_o),
.data_wdata ( data_wdata_o),
.data_rdata ( data_rdata_i),

//ahb interface
.ahb_hmastlock(),
.ahb_htrans   (data_htrans_o),
.ahb_hsel     (  data_hsel_o),
.ahb_hready   (data_hready_o),
.ahb_hwrite   (data_hwrite_o),
.ahb_haddr    ( data_haddr_o),
.ahb_hsize    ( data_hsize_o),
.ahb_hburst   (data_hburst_o),
.ahb_hprot    ( data_hprot_o),
.ahb_hwdata   (data_hwdata_o),
.ahb_hreadyout(data_hready_i),
.ahb_hresp    (data_hresp_i),
.ahb_hrdata   (data_hrdata_i)
);

`ifndef SYNTHESIS
monitior (
.hclk   (clk_cpu      ), 
.hresetn(rst_n_cpu    ),
.haddr  (data_haddr_o ),
.htrans (data_htrans_o),
.hwrite (data_hwrite_o),
.hsize  (data_hsize_o ),
.hburst (data_hburst_o),
.hprot  (         4'h0), 
.hwdata (data_hwdata_o), 
.hreadyi(data_hready_o),
.hsel   (data_hsel_o  ) 
);

`endif

//bus martix
busmatrix inst_busmatrix (
         .hclk       (    clk_cpu),
         .hresetn    (  rst_n_cpu),
// Slave 0  Input port
         .hsels0     (inst_hsel_o  ),
         .haddrs0    (inst_haddr_o ),
         .htranss0   (inst_htrans_o),
         .hwrites0   (inst_hwrite_o),
         .hsizes0    (inst_hsize_o ),
         .hbursts0   (inst_hburst_o),
         .hprots0    (inst_hprot_o ),
         .hmasters0  (        4'd0 ),
         .hwdatas0   (inst_hwdata_o),
         .hmastlocks0(         1'b0),
         .hreadys0   (inst_hready_o),
// Slave 1 Input port
         .hsels1     (data_hsel_o  ),
         .haddrs1    (data_haddr_o ),
         .htranss1   (data_htrans_o),
         .hwrites1   (data_hwrite_o), 
         .hsizes1    (data_hsize_o ),
         .hbursts1   (data_hburst_o),
         .hprots1    (data_hprot_o ),
         .hmasters1  (        4'd0 ),
         .hwdatas1   (data_hwdata_o),
         .hmastlocks1(         1'b0),
         .hreadys1   (data_hready_o),
// Slave 2 Input port
         .hsels2     (dma_hsel_o  ),
         .haddrs2    (dma_haddr_o ),
         .htranss2   (dma_htrans_o),
         .hwrites2   (dma_hwrite_o),
         .hsizes2    (dma_hsize_o ),
         .hbursts2   (dma_hburst_o),
         .hprots2    (dma_hprot_o ),
         .hmasters2  (       4'd0 ),
         .hwdatas2   (dma_hwdata_o),
         .hmastlocks2(        1'b0),
         .hreadys2   (dma_hready_i),
// Slave 3 Input port
         .hsels3     (isp_wdma_hsel_o  ),
         .haddrs3    (isp_wdma_haddr_o ),
         .htranss3   (isp_wdma_htrans_o),
         .hwrites3   (isp_wdma_hwrite_o),
         .hsizes3    (isp_wdma_hsize_o ),
         .hbursts3   (isp_wdma_hburst_o),
         .hprots3    (isp_wdma_hprot_o ),
         .hmasters3  (      4'd0 ),
         .hwdatas3   (isp_wdma_hwdata_o),
         .hmastlocks3(       1'b0),
         .hreadys3   (isp_wdma_hready_i),
// Slave 4 Input port
         .hsels4     (isp_rdma_hsel_o  ),
         .haddrs4    (isp_rdma_haddr_o ),
         .htranss4   (isp_rdma_htrans_o),
         .hwrites4   (isp_rdma_hwrite_o),
         .hsizes4    (isp_rdma_hsize_o ),
         .hbursts4   (isp_rdma_hburst_o),
         .hprots4    (isp_rdma_hprot_o ),
         .hmasters4  (       4'd0 ),
         .hwdatas4   (isp_rdma_hwdata_o),
         .hmastlocks4(        1'b0),
         .hreadys4   (isp_rdma_hready_i),
// Master 0 Input port
         .hrdatam0   (SRAM_HRDATAM0   ),
         .hreadyoutm0(SRAM_HREADYOUTM0),
         .hrespm0    (SRAM_HRESPM0    ),
// Master 1 Input port
         .hrdatam1   (APB_HRDATAM1   ),
         .hreadyoutm1(APB_HREADYOUTM1),
         .hrespm1    (APB_HRESPM1    ),
// Master 1 Input port
         .hrdatam2   (DMA_HRDATAM2   ),
         .hreadyoutm2(DMA_HREADYOUTM2),
         .hrespm2    (DMA_HRESPM2    ),
// Master 1 Input port
         .hrdatam3   (DMA_HRDATAM3   ),
         .hreadyoutm3(DMA_HREADYOUTM3),
         .hrespm3    (DMA_HRESPM3    ),
// Master 1 Input port
         .hrdatam3   (DM_MEM_HRDATAM4   ),
         .hreadyoutm3(DM_MEM_HREADYOUTM4),
         .hrespm3    (DM_MEM_HRESPM4    ),
// Master 0 Output port
         .hselm0      (SRAM_HSELM0      ),
         .haddrm0     (SRAM_HADDRM0     ),
         .htransm0    (SRAM_HTRANSM0    ),
         .hwritem0    (SRAM_HWRITEM0    ),
         .hsizem0     (SRAM_HSIZEM0     ),
         .hburstm0    (SRAM_HBURSTM0    ),
         .hprotm0     (SRAM_HPROTM0     ),
         .hmasterm0   (SRAM_HMASTERM0   ),
         .hwdatam0    (SRAM_HWDATAM0    ),
         .hreadymuxm0 (SRAM_HREADYMUXM0 ),
// Master 1 Output port
         .hselm1     (APB_HSELM1     ),
         .haddrm1    (APB_HADDRM1    ),
         .htransm1   (APB_HTRANSM1   ),
         .hwritem1   (APB_HWRITEM1   ),
         .hsizem1    (APB_HSIZEM1    ),
         .hburstm1   (APB_HBURSTM1   ),
         .hprotm1    (APB_HPROTM1    ),
         .hmasterm1  (APB_HMASTERM1  ),
         .hwdatam1   (APB_HWDATAM1   ),
         .hreadymuxm1(APB_HREADYMUXM1),
// Master 2 Output port
         .hselm2     (DMA_HSELM2     ),
         .haddrm2    (DMA_HADDRM2    ),
         .htransm2   (DMA_HTRANSM2   ),
         .hwritem2   (DMA_HWRITEM2   ),
         .hsizem2    (DMA_HSIZEM2    ),
         .hburstm2   (DMA_HBURSTM2   ),
         .hprotm2    (DMA_HPROTM2    ),
         .hmasterm2  (DMA_HMASTERM2  ),
         .hwdatam2   (DMA_HWDATAM2   ),
         .hreadymuxm2(DMA_HREADYMUXM2),
// Master 3 Output port
         .hselm3     (DMA_HSELM3     ),
         .haddrm3    (DMA_HADDRM3    ),
         .htransm3   (DMA_HTRANSM3   ),
         .hwritem3   (DMA_HWRITEM3   ),
         .hsizem3    (DMA_HSIZEM3    ),
         .hburstm3   (DMA_HBURSTM3   ),
         .hprotm3    (DMA_HPROTM3    ),
         .hmasterm3  (DMA_HMASTERM3  ),
         .hwdatam3   (DMA_HWDATAM3   ),
         .hreadymuxm3(DMA_HREADYMUXM3),
// Master 4 Output port
         .hselm4     (DM_MEM_HSELM4     ),
         .haddrm4    (DM_MEM_HADDRM4    ),
         .htransm4   (DM_MEM_HTRANSM4   ),
         .hwritem4   (DM_MEM_HWRITEM4   ),
         .hsizem4    (DM_MEM_HSIZEM4    ),
         .hburstm4   (DM_MEM_HBURSTM4   ),
         .hprotm4    (DM_MEM_HPROTM4    ),
         .hmasterm4  (DM_MEM_HMASTERM4  ),
         .hwdatam4   (DM_MEM_HWDATAM4   ),
         .hreadymuxm4(DM_MEM_HREADYMUXM4),
// Slave 0 Output port
         .hrdatas0   (inst_hrdata_i),
         .hreadyouts0(inst_hready_i),
         .hresps0    ({inst_hresp_tmp,inst_hresp_i} ),
// Slave 1 Output port
         .hrdatas1   (data_hrdata_i),
         .hreadyouts1(data_hready_i),
         .hresps1    ({data_hresp_tmp,data_hresp_i} ),
// Slave 2 Output port
         .hrdatas2   (dma_hrdata_i),
         .hreadyouts2(dma_hready_i),
         .hresps2    (dma_hresp_i),
// Slave 2 Output port
         .hrdatas3   (isp_wdma_hrdata_i),
         .hreadyouts3(isp_wdma_hready_i),
         .hresps3    (isp_wdma_hresp_i),
// Slave 2 Output port
         .hrdatas4   (isp_rdma_hrdata_i),
         .hreadyouts4(isp_rdma_hready_i),
         .hresps4    (isp_rdma_hresp_i)
);

//sram instance

  wire   [31:0] SRAMRDATA; // SRAM Read Data
  wire   [29:0] SRAMADDR ;  // SRAM address
  wire    [3:0] SRAMWEN  ;   // SRAM write enable (active high)
  wire   [31:0] SRAMWDATA; // SRAM write data
  wire          SRAMCS   ;   // SRAM Chip Select  (active high)


cmsdk_ahb_to_sram  #(
  .AW(32)) // Address width
inst_cmsdk_ahb_to_sram (
 
// --------------------------------------------------------------------------
// Port Definitions
// --------------------------------------------------------------------------
  .HCLK     (          clk_cpu),     
  .HRESETn  (        rst_n_cpu),   
  .HSEL     (SRAM_HSELM0      ),      
  .HREADY   (SRAM_HREADYMUXM0 ),    
  .HTRANS   (SRAM_HTRANSM0    ),    
  .HSIZE    (SRAM_HSIZEM0     ),    
  .HWRITE   (SRAM_HWRITEM0    ),  
  .HADDR    (SRAM_HADDRM0     ),     
  .HWDATA   (SRAM_HWDATAM0    ),    
  .HREADYOUT(SRAM_HREADYOUTM0 ), 
  .HRESP    (SRAM_HRESPM0[0]  ),     
  .HRDATA   (SRAM_HRDATAM0   ),    
              
  .SRAMRDATA(SRAMRDATA), 
  .SRAMADDR (SRAMADDR ),  
  .SRAMWEN  (SRAMWEN  ),   
  .SRAMWDATA(SRAMWDATA), 
  .SRAMCS   (SRAMCS   )
);   

sram  #(
    .DATA_WIDTH(32),
    //.NUM_WORDS (16384*8)
    .NUM_WORDS (256*8) //updated for syn.
)inst_sram(
    .clk_i  (clk_cpu),

    .req_i  (SRAMCS),
    .we_i   (|SRAMWEN),
    //.addr_i (SRAMADDR[16:0]),
    .addr_i (SRAMADDR[10:0]),//update
    .wdata_i(SRAMWDATA),
    .be_i   ({{8{SRAMWEN[3]}},{8{SRAMWEN[2]}},{8{SRAMWEN[1]}},{8{SRAMWEN[0]}}}),
    .rdata_o(SRAMRDATA) 
);

//apb system 
apb_subsystem inst_apb_subsystem(
    // AHB interface
    .hclk     (         clk_cpu), 
    .n_hreset (       rst_n_cpu),
    .hsel     (APB_HSELM1      ),
    .haddr    (APB_HADDRM1     ),
    .htrans   (APB_HTRANSM1    ),
    .hsize    (APB_HSIZEM1     ),
    .hwrite   (APB_HWRITEM1    ),
    .hwdata   (APB_HWDATAM1    ),
    .hready_in(APB_HREADYMUXM1 ),
    .hburst   (APB_HBURSTM1    ),
    .hprot    (APB_HPROTM1     ),
    .hmaster  (APB_HMASTERM1   ),
    .hmastlock(APB_HMASTLOCKM1 ),
    .hrdata   (APB_HRDATAM1    ),
    .hready   (APB_HREADYOUTM1 ),
    .hresp    (APB_HRESPM1     ),
    
    // APB system inte
    .pclk     (            pclk),
    .n_preset (         prest_n),
    
    // SPI ports
    //n_ss_out, 
    //sclk_out, 
    //mo, 
    //mi,
    .spi0_clk (spi0_clk ),
    .spi0_csn0(spi0_csn0),
    .spi0_csn1(spi0_csn1),
    .spi0_csn2(spi0_csn2),
    .spi0_csn3(spi0_csn3),
    .spi0_sdo0(spi0_sdo0),
    .spi0_sdo1(spi0_sdo1),
    .spi0_sdo2(spi0_sdo2),
    .spi0_sdo3(spi0_sdo3),
    .spi0_oe0 (spi0_oe0 ),
    .spi0_oe1 (spi0_oe1 ),
    .spi0_oe2 (spi0_oe2 ),
    .spi0_oe3 (spi0_oe3 ),
    .spi0_sdi0(spi0_sdi0),
    .spi0_sdi1(spi0_sdi1),
    .spi0_sdi2(spi0_sdi2),
    .spi0_sdi3(spi0_sdi3),
    
    .spi1_clk (spi1_clk ),
    .spi1_csn0(spi1_csn0),
    .spi1_csn1(spi1_csn1),
    .spi1_csn2(spi1_csn2),
    .spi1_csn3(spi1_csn3),
    .spi1_sdo0(spi1_sdo0),
    .spi1_sdo1(spi1_sdo1),
    .spi1_sdo2(spi1_sdo2),
    .spi1_sdo3(spi1_sdo3),
    .spi1_oe0 (spi1_oe0 ),
    .spi1_oe1 (spi1_oe1 ),
    .spi1_oe2 (spi1_oe2 ),
    .spi1_oe3 (spi1_oe3 ),
    .spi1_sdi0(spi1_sdi0),
    .spi1_sdi1(spi1_sdi1),
    .spi1_sdi2(spi1_sdi2),
    .spi1_sdi3(spi1_sdi3),   
    //UART0 ports
    .ua_rxd (ua_rxd ),
    .ua_txd (ua_txd ),

    //PWM
    .pwm_o  (pwm_o),

    //GPIO ports
    //gpio_io

`ifdef I2C
    //I2C ports
    .i2c0_scl_pad_i   (i2c0_scl_pad_i   ), 
    .i2c0_scl_pad_o   (i2c0_scl_pad_o   ), 
    .i2c0_scl_padoen_o(i2c0_scl_padoen_o), 
    .i2c0_sda_pad_i   (i2c0_sda_pad_i   ), 
    .i2c0_sda_pad_o   (i2c0_sda_pad_o   ), 
    .i2c0_sda_padoen_o(i2c0_sda_padoen_o),

    .i2c1_scl_pad_i   (i2c1_scl_pad_i   ),
    .i2c1_scl_pad_o   (i2c1_scl_pad_o   ),
    .i2c1_scl_padoen_o(i2c1_scl_padoen_o),
    .i2c1_sda_pad_i   (i2c1_sda_pad_i   ),
    .i2c1_sda_pad_o   (i2c1_sda_pad_o   ),
    .i2c1_sda_padoen_o(i2c1_sda_padoen_o),

`endif

    .r_io_reuse_pad2  (r_io_reuse_pad2 ),                   
    .r_io_reuse_pad1  (r_io_reuse_pad1 ),                   
    .r_io_reuse_pad4  (r_io_reuse_pad4 ),                   
    .r_io_reuse_pad3  (r_io_reuse_pad3 ),                   
    .r_io_reuse_pad6  (r_io_reuse_pad6 ),                   
    .r_io_reuse_pad5  (r_io_reuse_pad5 ),                   
    .r_io_reuse_pad8  (r_io_reuse_pad8 ),                   
    .r_io_reuse_pad7  (r_io_reuse_pad7 ),                   
    .r_io_reuse_pad10 (r_io_reuse_pad10),                   
    .r_io_reuse_pad9  (r_io_reuse_pad9 ),                   
    .r_io_reuse_pad12 (r_io_reuse_pad12),                   
    .r_io_reuse_pad11 (r_io_reuse_pad11),                   
    .r_io_reuse_pad14 (r_io_reuse_pad14),                   
    .r_io_reuse_pad13 (r_io_reuse_pad13),                   
    .r_io_reuse_pad16 (r_io_reuse_pad16),                   
    .r_io_reuse_pad15 (r_io_reuse_pad15),                   
    .r_io_reuse_pad18 (r_io_reuse_pad18),                   
    .r_io_reuse_pad17 (r_io_reuse_pad17),                   
    .r_io_reuse_pad20 (r_io_reuse_pad20),                   
    .r_io_reuse_pad19 (r_io_reuse_pad19)  

);


pin_mux  chip_pin_mux(
   // Outputs
   .clk_cpu              (clk_cpu),
   .rst_n_cpu            (rst_n_cpu),
   .pclk                 (pclk),
   .prest_n              (prest_n),

   //JTAG interface.
   .tck_i                (tck_i            ), // JTAG test clock pad
   .tms_i                (tms_i            ), // JTAG test mode select pad
   .trst_ni              (trst_ni          ), // JTAG test reset pad
   .td_i                 (td_i             ), // JTAG test data input pad
   .td_o                 (td_o             ), // JTAG test data output pad
   .tdo_oe_o             (tdo_oe_o         ), // Data out output enable

   .spi0_sdi0            (spi0_sdi0        ),
   .spi0_sdi1            (spi0_sdi1        ),
   .spi0_sdi2            (spi0_sdi2        ),
   .spi0_sdi3            (spi0_sdi3        ),
   .spi1_sdi0            (spi1_sdi0        ),
   .spi1_sdi1            (spi1_sdi1        ),
   .spi1_sdi2            (spi1_sdi2        ),
   .spi1_sdi3            (spi1_sdi3        ),
   .ua_rxd               (ua_rxd           ),
                                           
   .i2c0_scl_pad_i       (i2c0_scl_pad_i   ),
   .i2c0_sda_pad_i       (i2c0_sda_pad_i   ),
   .i2c1_scl_pad_i       (i2c1_scl_pad_i   ),
   .i2c1_sda_pad_i       (i2c1_sda_pad_i   ),
                                           
   // Inouts             // Inouts
   .pad                  (pad              ),
   // Inputs             // Inputs
   .spi0_clk             (spi0_clk         ),
   .spi0_csn0            (spi0_csn0        ),
   .spi0_csn1            (spi0_csn1        ),
   .spi0_csn2            (spi0_csn2        ),
   .spi0_csn3            (spi0_csn3        ),
   .spi0_sdo0            (spi0_sdo0        ),
                                           
   .spi0_sdo1            (spi0_sdo1        ),
   .spi0_sdo2            (spi0_sdo2        ),
   .spi0_sdo3            (spi0_sdo3        ),
   .spi0_oe0             (spi0_oe0         ),
   .spi0_oe1             (spi0_oe1         ),
   .spi0_oe2             (spi0_oe2         ),
                                           
   .spi0_oe3             (spi0_oe3         ),
   .spi1_clk             (spi1_clk         ),
   .spi1_csn0            (spi1_csn0        ),
   .spi1_csn1            (spi1_csn1        ),
   .spi1_csn2            (spi1_csn2        ),
   .spi1_csn3            (spi1_csn3        ),
                                           
   .spi1_sdo0            (spi1_sdo0        ),
   .spi1_sdo1            (spi1_sdo1        ),
   .spi1_sdo2            (spi1_sdo2        ),
   .spi1_sdo3            (spi1_sdo3        ),
   .spi1_oe0             (spi1_oe0         ),
   .spi1_oe1             (spi1_oe1         ),
                                           
   .spi1_oe2             (spi1_oe2         ),
   .spi1_oe3             (spi1_oe3         ),
   .ua_txd               (ua_txd           ),
   .pwm_o                (pwm_o            ),
   .i2c0_scl_pad_o       (i2c0_scl_pad_o   ),
   .i2c0_scl_padoen_o    (i2c0_scl_padoen_o),
                                           
   .i2c0_sda_pad_o       (i2c0_sda_pad_o   ),
   .i2c0_sda_padoen_o    (i2c0_sda_padoen_o),
   .i2c1_scl_pad_o       (i2c1_scl_pad_o   ),
                                           
   .i2c1_scl_padoen_o    (i2c1_scl_padoen_o),
   .i2c1_sda_pad_o       (i2c1_sda_pad_o   ),
   .i2c1_sda_padoen_o    (i2c1_sda_padoen_o),
                                           
   .r_io_reuse_pad2      (r_io_reuse_pad2  ),
   .r_io_reuse_pad1      (r_io_reuse_pad1  ),
   .r_io_reuse_pad4      (r_io_reuse_pad4  ),
   .r_io_reuse_pad3      (r_io_reuse_pad3  ),
                                           
   .r_io_reuse_pad6      (r_io_reuse_pad6  ),
   .r_io_reuse_pad5      (r_io_reuse_pad5  ),
   .r_io_reuse_pad8      (r_io_reuse_pad8  ),
   .r_io_reuse_pad7      (r_io_reuse_pad7  ),
                                           
   .r_io_reuse_pad10     (r_io_reuse_pad10 ),
   .r_io_reuse_pad9      (r_io_reuse_pad9  ),
   .r_io_reuse_pad12     (r_io_reuse_pad12 ),
                                           
   .r_io_reuse_pad11     (r_io_reuse_pad11 ),
   .r_io_reuse_pad14     (r_io_reuse_pad14 ),
   .r_io_reuse_pad13     (r_io_reuse_pad13 ),
                                           
   .r_io_reuse_pad16     (r_io_reuse_pad16 ),
   .r_io_reuse_pad15     (r_io_reuse_pad15 ),
   .r_io_reuse_pad18     (r_io_reuse_pad18 ),
                                           
   .r_io_reuse_pad17     (r_io_reuse_pad17 ),
   .r_io_reuse_pad20     (r_io_reuse_pad20 ),
   .r_io_reuse_pad19     (r_io_reuse_pad19 )
);

wire  in_href;
wire  in_vsync;
wire [7:0] in_raw;

wire  dm_href_o;
wire  dm_vsync_o;
wire  [7:0] dm_r_o;
wire  [7:0] dm_g_o;
wire  [7:0] dm_b_o;



isp_top isp(
   .pclk         (clk_cpu),
   .rst_n        (rst_n_cpu),

   .in_href      (in_href),
   .in_vsync     (in_vsync),
   .in_raw       (in_raw),
   
   .dm_href_o    (dm_href_o),
   .dm_vsync_o   (dm_vsync_o),
   .dm_r_o       (dm_r_o),
   .dm_g_o       (dm_g_o),
   .dm_b_o       (dm_b_o),
   
   .dgain_en     (1'b0), 
   .demosic_en   (1'b1), 

   .dgain_gain   (8'b1),
   .dgain_offset (8'b0)    
);

isp_dma isp_dma_top
(
  .hclk       (clk_cpu),
  .n_hreset   (rst_n_cpu),
  .haddr      (DMA_HADDRM3),
  .hsel       (DMA_HSELM3),
  .htrans     (DMA_HTRANSM3),
  .hwrite     (DMA_HWRITEM3),
  .hsize      (DMA_HSIZEM3),
  .hwdata     (DMA_HWDATAM3),
  .hburst     (DMA_HBURSTM3),
  .hprot      (DMA_HPROTM3),
  .hmaster    (DMA_HMASTERM3),
  .hmastlock  (DMA_HMASTLOCKM3),
  .hready_in  (DMA_HREADYMUXM3),
  .dma_hready (DMA_HREADYOUTM3),
  .dma_hresp  (DMA_HRESPM3),
  .dma_hrdata (DMA_HRDATAM3),

  .rdma_haddr  (isp_rdma_haddr_o),
  .rdma_htrans (isp_rdma_htrans_o),
  .rdma_hwrite (isp_rdma_hwrite_o),
  .rdma_hsize  (isp_rdma_hsize_o),
  .rdma_hburst (isp_rdma_hburst_o),
  .rdma_hprot  (isp_rdma_hprot_o),
  .rdma_hwdata (isp_rdma_hwdata_o),
  .rdma_hbusreq(),
  .rdma_hlock  (),
  .hrdata_rdma (isp_rdma_hrdata_i),
  .hready_rdma (isp_rdma_hready_i),
  .hresp_rdma  (isp_rdma_hresp_i),
  .hgrant     (1'b1), 

  .wdma_haddr  (isp_wdma_haddr_o),
  .wdma_htrans (isp_wdma_htrans_o),
  .wdma_hwrite (isp_wdma_hwrite_o),
  .wdma_hsize  (isp_wdma_hsize_o),
  .wdma_hburst (isp_wdma_hburst_o),
  .wdma_hprot  (isp_wdma_hprot_o),
  .wdma_hwdata (isp_wdma_hwdata_o),
  .wdma_hbusreq(),               
  .wdma_hlock  (),               
  .hrdata_wdma (isp_wdma_hrdata_i),
  .hready_wdma (isp_wdma_hready_i),
  .hresp_wdma  (isp_wdma_hresp_i),   

  .in_href    (in_href),
  .in_vsync   (in_vsync),
  .in_raw     (in_raw),

  .dm_vsync_o   (dm_vsync_o),
  .dm_href_o    (dm_href_o),
  .dm_r_o       (dm_r_o),
  .dm_g_o       (dm_g_o),
  .dm_b_o       (dm_b_o)

 );



dma soc_dma(
  .hclk       (clk_cpu),
  .n_hreset   (rst_n_cpu),
  .dma_int    (),
  .haddr      (DMA_HADDRM2),
  .hsel       (DMA_HSELM2),
  .htrans     (DMA_HTRANSM2),
  .hwrite     (DMA_HWRITEM2),
  .hsize      (DMA_HSIZEM2),
  .hwdata     (DMA_HWDATAM2),
  .hburst     (DMA_HBURSTM2),
  .hprot      (DMA_HPROTM2),
  .hmaster    (DMA_HMASTERM2),
  .hmastlock  (DMA_HMASTLOCKM2),
  .hready_in  (DMA_HREADYMUXM2),
  .dma_hready (DMA_HREADYOUTM2),
  .dma_hresp  (DMA_HRESPM2),
  .dma_hrdata (DMA_HRDATAM2),    
  .dma_haddr  (dma_haddr_o),
  .dma_htrans (dma_htrans_o),
  .dma_hwrite (dma_hwrite_o),
  .dma_hsize  (dma_hsize_o),
  .dma_hburst (dma_hburst_o),
  .dma_hprot  (dma_hprot_o),
  .dma_hwdata (dma_hwdata_o),
  .dma_hbusreq(),
  .dma_hlock  (),
  .hrdata_dma (dma_hrdata_i),
  .hready_dma (dma_hready_i),
  .hresp_dma  (dma_hresp_i),
  .hgrant     (1'b1),
  .scan_en    (1'b0),
  .scan_in    (1'b0),
  .scan_out   () 
 );

assign dma_hsel_o = dma_htrans_o[1];

assign isp_rdma_hsel_o = isp_rdma_htrans_o[1];

assign isp_wdma_hsel_o = isp_wdma_htrans_o[1];


endmodule

