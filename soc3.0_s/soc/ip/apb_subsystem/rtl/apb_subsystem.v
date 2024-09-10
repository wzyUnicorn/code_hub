//hubing 2022.7.23
`include "SoC_amba-defines.v" 
module apb_subsystem(
    // AHB interface
    hclk,
    n_hreset,
    hsel,
    haddr,
    htrans,
    hsize,
    hwrite,
    hwdata,
    hready_in,
    hburst,
    hprot,
    hmaster,
    hmastlock,
    hrdata,
    hready,
    hresp,
    
    // APB system interface
    pclk,
    n_preset,
    
    // SPI ports
    //n_ss_out, 
    //sclk_out, 
    //mo, 
    //mi,
    spi0_clk,
    spi0_csn0,
    spi0_csn1,
    spi0_csn2,
    spi0_csn3,
    spi0_sdo0,
    spi0_sdo1,
    spi0_sdo2,
    spi0_sdo3,
    spi0_oe0,
    spi0_oe1,
    spi0_oe2,
    spi0_oe3,
    spi0_sdi0,
    spi0_sdi1,
    spi0_sdi2,
    spi0_sdi3,
   
    spi1_clk,
    spi1_csn0,
    spi1_csn1,
    spi1_csn2,
    spi1_csn3,
    spi1_sdo0,
    spi1_sdo1,
    spi1_sdo2,
    spi1_sdo3,
    spi1_oe0,
    spi1_oe1,
    spi1_oe2,
    spi1_oe3,
    spi1_sdi0,
    spi1_sdi1,
    spi1_sdi2,
    spi1_sdi3,
 
    //UART0 ports
    ua_rxd,
    ua_txd,

    //PWM port
    pwm_o,

    //GPIO ports
    //gpio_io

`ifdef I2C
    //I2C ports
    i2c0_scl_pad_i, 
    i2c0_scl_pad_o, 
    i2c0_scl_padoen_o, 

    i2c0_sda_pad_i, 
    i2c0_sda_pad_o, 
    i2c0_sda_padoen_o,

    i2c1_scl_pad_i,
    i2c1_scl_pad_o,
    i2c1_scl_padoen_o,

    i2c1_sda_pad_i,
    i2c1_sda_pad_o,
    i2c1_sda_padoen_o,

`endif
    
    r_io_reuse_pad2  ,                   
    r_io_reuse_pad1  ,                   
    r_io_reuse_pad4  ,                   
    r_io_reuse_pad3  ,                   
    r_io_reuse_pad6  ,                   
    r_io_reuse_pad5  ,                   
    r_io_reuse_pad8  ,                   
    r_io_reuse_pad7  ,                   
    r_io_reuse_pad10 ,                   
    r_io_reuse_pad9  ,                   
    r_io_reuse_pad12 ,                   
    r_io_reuse_pad11 ,                   
    r_io_reuse_pad14 ,                   
    r_io_reuse_pad13 ,                   
    r_io_reuse_pad16 ,                   
    r_io_reuse_pad15 ,                   
    r_io_reuse_pad18 ,                   
    r_io_reuse_pad17 ,                   
    r_io_reuse_pad20 ,                   
    r_io_reuse_pad19 ,

    paddr,
    psel_cnn,
    penable,
    pwrite,
    pwdata,
    pready_cnn,
    prdata_cnn
);

parameter GPIO_WIDTH = 16;       // GPIO width
parameter P_SIZE =   8;          // number of peripheral select lines
parameter NO_OF_IRQS  = 17;      //No of irqs read by apic 

// AHB interface
input         hclk;     // AHB Clock
input         n_hreset;  // AHB reset - Active low
input         hsel;     // AHB2APB select
input [31:0]  haddr;    // Address bus
input [1:0]   htrans;   // Transfer type
input [2:0]   hsize;    // AHB Access type - byte, half-word, word
input [31:0]  hwdata;   // Write data
input         hwrite;   // Write signal
input         hready_in;// Indicates that last master has finished bus access
input [2:0]   hburst;     // Burst type
input [3:0]   hprot;      // Protection control
input [3:0]   hmaster;    // Master select
input         hmastlock;  // Locked transfer
output [31:0] hrdata;       // Read data provided from target slave
output        hready;       // Ready for new bus cycle from target slave
output [1:0]  hresp;       // Response from the bridge
    
// APB system interface
input         pclk;     // APB Clock. 
input         n_preset;  // APB reset - Active low
   
// SPI ports
//output    n_ss_out; 
//output    sclk_out; 
//output    mo; 
//input     mi;
output      spi0_clk  ; 
output      spi0_csn0 ;
output      spi0_csn1 ;
output      spi0_csn2 ;
output      spi0_csn3 ;
output      spi0_sdo0 ;
output      spi0_sdo1 ;
output      spi0_sdo2 ;
output      spi0_sdo3 ;
output      spi0_oe0  ;
output      spi0_oe1  ;
output      spi0_oe2  ;
output      spi0_oe3  ;
input       spi0_sdi0 ;
input       spi0_sdi1 ;
input       spi0_sdi2 ;
input       spi0_sdi3 ;

output      spi1_clk  ;
output      spi1_csn0 ;
output      spi1_csn1 ;
output      spi1_csn2 ;
output      spi1_csn3 ;
output      spi1_sdo0 ;
output      spi1_sdo1 ;
output      spi1_sdo2 ;
output      spi1_sdo3 ;
output      spi1_oe0  ;
output      spi1_oe1  ;
output      spi1_oe2  ;
output      spi1_oe3  ;
input       spi1_sdi0 ;
input       spi1_sdi1 ;
input       spi1_sdi2 ;
input       spi1_sdi3 ;

//UART0 ports
input        ua_rxd;       // UART receiver serial input pin
output       ua_txd;        // UART transmitter serial output

output [3:0] pwm_o;    //PWM

//GPIO ports
//inout [23:0] gpio_io;


//I2C ports
`ifdef I2C
input     i2c0_scl_pad_i;
output    i2c0_scl_pad_o; 
output    i2c0_scl_padoen_o; 

input     i2c0_sda_pad_i; 
output    i2c0_sda_pad_o; 
output    i2c0_sda_padoen_o;


input     i2c1_scl_pad_i;
output    i2c1_scl_pad_o;
output    i2c1_scl_padoen_o;

input     i2c1_sda_pad_i;
output    i2c1_sda_pad_o;
output    i2c1_sda_padoen_o;

`endif

output             [2:0]               r_io_reuse_pad2     ;                   
output             [2:0]               r_io_reuse_pad1     ;                   
output             [2:0]               r_io_reuse_pad4     ;                   
output             [2:0]               r_io_reuse_pad3     ;                   
output             [2:0]               r_io_reuse_pad6     ;                   
output             [2:0]               r_io_reuse_pad5     ;                   
output             [2:0]               r_io_reuse_pad8     ;                   
output             [2:0]               r_io_reuse_pad7     ;                   
output             [2:0]               r_io_reuse_pad10    ;                   
output             [2:0]               r_io_reuse_pad9     ;                   
output             [2:0]               r_io_reuse_pad12    ;                   
output             [2:0]               r_io_reuse_pad11    ;                   
output             [2:0]               r_io_reuse_pad14    ;                   
output             [2:0]               r_io_reuse_pad13    ;                   
output             [2:0]               r_io_reuse_pad16    ;                   
output             [2:0]               r_io_reuse_pad15    ;                   
output             [2:0]               r_io_reuse_pad18    ;                   
output             [2:0]               r_io_reuse_pad17    ;                   
output             [2:0]               r_io_reuse_pad20    ;                   
output             [2:0]               r_io_reuse_pad19    ;                   

//cnn apb interface.
//pclk, preset_n
output [31:0]  paddr;
output         psel_cnn;
output         penable;
output         pwrite;
output [31:0]  pwdata;
input          pready_cnn;
input  [31:0]  prdata_cnn;

   wire         hsel; 
   wire         pclk;
   wire         n_preset;
//   wire [31:0]  prdata_spi;
   wire [31:0]  prdata_spi0;
   wire [31:0]  prdata_spi1;

   wire [7:0] prdata_uart0;
   wire [7:0] prdata_gpio;
  
`ifdef I2C  
   wire [7:0] prdata_i2c;
   wire [7:0] prdata_i2c0;
   wire [7:0] prdata_i2c1;
`endif

   wire        pready_spi;
   wire        pready_uart0;
   wire        pready_pwm;
   wire        pready_pinmux;
   wire        tie_hi_bit;
   wire [31:0] hrdata; 
   wire        hready;
   wire        hready_in;
   wire [1:0]  hresp;   
   wire   psel_spi0;
   wire   psel_spi1;
   wire   psel_uart0;
   wire   psel_pwm;
   wire   psel_gpio;
`ifdef I2C
   wire   psel_i2c0;
   wire   psel_i2c1;
`endif
   wire   psel07;
   wire   psel08;
   wire   psel09;
   wire   psel10;
   wire   psel11;
   wire   psel12;

   wire           cpu_debug;        // Inhibits watchdog counter 
   wire           rstn_non_srpg_urt;
   wire           save_edge_urt;
   wire           restore_edge_urt;
   wire           pclk_SRPG_urt;
   wire  [31:0]   tie_lo_32bit; 
   wire  [1:0]    tie_lo_2bit;
   wire           tie_lo_1bit;
   wire           psel_pinmux;
   wire [31:0]    prdata_pinmux;
   wire [31:0]    prdata_pwm;


   wire [15:0]    sft_adr_i ;                  
   wire [7:0]     sft_dat_i ;                   
   wire           sft_wr_i  ;                   
   wire           sft_rd_i  ;                   
   wire           sft_rd_cs ;                   
   wire [7:0]     sft_dat_o ;

  assign tie_hi_bit = 1'b1;


  assign  n_gpio_bypass_oe = {GPIO_WIDTH{1'b0}};        // bypass mode enable 
  assign  gpio_bypass_out  = {GPIO_WIDTH{1'b0}};
  assign  tri_state_enable = {GPIO_WIDTH{1'b0}};
  assign  cpu_debug = 1'b0;
  assign  tie_lo_32bit = 32'b0;
  assign  tie_lo_2bit  = 2'b0;
  assign  tie_lo_1bit  = 1'b0;

//  assign  prdata_spi = psel_spi0 ? prdata_spi0:prdata_spi1;
  assign  prdata_i2c = psel_i2c0 ? prdata_i2c0:prdata_i2c1;


//`protect128
ahb2apb #(
  32'h20000000, // Slave 0 Address Range
  32'h2000FFFF,

  32'h20010000, // Slave 1 Address Range
  32'h2001FFFF,

  32'h20020000, // Slave 2 Address Range 
  32'h2002FFFF,

  32'h20030000, // Slave 3 Address Range
  32'h2003FFFF,

  32'h20040000, // Slave 4 Address Range
  32'h2004FFFF,

  32'h20050000, // Slave 5 Address Range
  32'h2005FFFF,

  32'h20060000, // Slave 6 Address Range
  32'h2006FFFF,

  32'h20070000, // Slave 7 Address Range
  32'h2007FFFF,

  32'h20080000, // Slave 8 Address Range
  32'h2008FFFF

) i_ahb2apb (
     // AHB interface
    .hclk(hclk),         
    .hreset_n(n_hreset), 
    .hsel(hsel), 
    .haddr(haddr),        
    .htrans(htrans),       
    .hwrite(hwrite),       
    .hwdata(hwdata),       
    .hrdata(hrdata),   
    .hready(hready),   
    .hresp(hresp),     
    
     // APB interface
  //  .pclk(pclk),         
  //  .preset_n(n_preset),  
    .prdata0({prdata_spi0}),
    //.prdata1({24'b0,prdata_uart0}),
    .prdata1({24'd0,prdata_uart0}), 
    .prdata2({prdata_gpio,24'b0}),  
   
`ifdef I2C   
    .prdata3({24'b0,prdata_i2c}),  
`else
    .prdata3(32'h0),
`endif
    .prdata4(prdata_spi1),   
    .prdata5(32'h0),   /////////////////////
    .prdata6(prdata_pinmux),   ///////////////////
    .prdata7(prdata_pwm),
    .prdata8(prdata_cnn),
    //.pready0(pready_spi),  
    .pready0(tie_hi_bit),    
    .pready1(tie_hi_bit),
    .pready2(tie_hi_bit),     
    .pready3(tie_hi_bit),     
    .pready4(tie_hi_bit),     
    .pready5(tie_hi_bit),     
    .pready6(tie_hi_bit),     
    .pready7(tie_hi_bit),     
    .pready8(tie_hi_bit),     
    .pwdata(pwdata),       
    .pwrite(pwrite),       
    .paddr(paddr),        
    .psel0(psel_spi0),     
    .psel1(psel_uart0),   
    .psel2(psel_gpio),    
`ifdef I2C
    .psel3(psel_i2c0), 
`else
    .psel3(),
`endif    
    .psel4(psel_spi1),     
    .psel5(psel_i2c1),   
    .psel6(psel_pinmux),
    .psel7(psel_pwm),
    .psel8(psel_cnn),
    .penable(penable)    
);
//`endprotect128

//simple_spi_apb i_simple_spi_apb(
//  .pclk      (pclk        ), 
//  .preset_n  (n_preset    ), 
//  .paddr     (paddr [4:2] ), 
//  .pwdata    (pwdata[7:0] ), 
//  .prdata    (prdata_spi  ), 
//  .pwrite    (pwrite      ), 
//  .psel      (psel_spi    ), 
//  .penable   (penable     ),
//  .inta_o    (            ),
//  // SPI signals
//  .ss_o      (n_ss_out    ), 
//  .sck_o     (sclk_out    ), 
//  .mosi_o    (mo          ), 
//  .miso_i    (mi          )
//);
wire   [23:0] tmp;

apb_spi_master #(
     .BUFFER_DEPTH  (10 ),
     .APB_ADDR_WIDTH(12 )
)u_apb_spi_master_0(

     .HCLK          (pclk                ),
     .HRESETn       (n_preset            ),
     .PADDR         (paddr[11:0]         ),
     .PWDATA        (pwdata ),
     .PWRITE        (pwrite              ),
     .PSEL          (psel_spi0            ),
     .PENABLE       (penable             ),
     .PRDATA        (prdata_spi0     ),
     .PREADY        (                    ),
     .PSLVERR       (                    ),
     .events_o      (                    ),
     .spi_clk       (spi0_clk             ),
     .spi_csn0      (spi0_csn0            ),
     .spi_csn1      (spi0_csn1            ),
     .spi_csn2      (spi0_csn2            ),
     .spi_csn3      (spi0_csn3            ),
     .spi_sdo0      (spi0_sdo0            ),
     .spi_sdo1      (spi0_sdo1            ),
     .spi_sdo2      (spi0_sdo2            ),
     .spi_sdo3      (spi0_sdo3            ),
     .spi_oe0       (spi0_oe0             ),
     .spi_oe1       (spi0_oe1             ),
     .spi_oe2       (spi0_oe2             ),
     .spi_oe3       (spi0_oe3             ),
     .spi_sdi0      (spi0_sdi0            ),
     .spi_sdi1      (spi0_sdi1            ),
     .spi_sdi2      (spi0_sdi2            ),
     .spi_sdi3      (spi0_sdi3            )
);


apb_spi_master #(
     .BUFFER_DEPTH  (10 ),
     .APB_ADDR_WIDTH(12 )
)u_apb_spi_master_1(

     .HCLK          (pclk                ),
     .HRESETn       (n_preset            ),
     .PADDR         (paddr[11:0]         ),
     .PWDATA        (pwdata ),
     .PWRITE        (pwrite              ),
     .PSEL          (psel_spi1            ),
     .PENABLE       (penable             ),
     .PRDATA        (prdata_spi1     ),
     .PREADY        (                    ),
     .PSLVERR       (                    ),
     .events_o      (                    ),
     .spi_clk       (spi1_clk             ),
     .spi_csn0      (spi1_csn0            ),
     .spi_csn1      (spi1_csn1            ),
     .spi_csn2      (spi1_csn2            ),
     .spi_csn3      (spi1_csn3            ),
     .spi_sdo0      (spi1_sdo0            ),
     .spi_sdo1      (spi1_sdo1            ),
     .spi_sdo2      (spi1_sdo2            ),
     .spi_sdo3      (spi1_sdo3            ),
     .spi_oe0       (spi1_oe0             ),
     .spi_oe1       (spi1_oe1             ),
     .spi_oe2       (spi1_oe2             ),
     .spi_oe3       (spi1_oe3             ),
     .spi_sdi0      (spi1_sdi0            ),
     .spi_sdi1      (spi1_sdi1            ),
     .spi_sdi2      (spi1_sdi2            ),
     .spi_sdi3      (spi1_sdi3            )
);


uart_apb i_uart_apb (
  .pclk(pclk),
  .preset_n(n_preset),
  .paddr(paddr[6:2]),
  .pwdata(pwdata[7:0]),
  .prdata(prdata_uart0),
  .pwrite(pwrite),
  .psel(psel_uart0),
  .penable(penable),
  .pready(pready_uart0),
  .inta_o(),
  .stx_pad_o(ua_txd),
  .srx_pad_i(ua_rxd)
);    

pwm_apb i_pwm_apb (
  .pclk(pclk),
  .preset_n(n_preset),
  .paddr(paddr[15:0]),
  .pwdata(pwdata),
  .prdata(prdata_pwm),
  .pwrite(pwrite),
  .psel(psel_pwm),
  .penable(penable),
  .pready(pready_pwm),
  .pwm_o(pwm_o)
);


//gpio i_gpio(
//        .pclk(pclk),
//        .preset_n(n_preset),
//
//        .paddr(paddr[4:2]),
//        .pwrite(pwrite),
//        .pwdata(pwdata[7:0]),
//        .prdata(prdata_gpio),
//        .psel(psel_gpio),
//        .penable(penable),
//        .gpio_io(gpio_io)
//);
 
i2c_master_top i_i2c_master0_top(
    .pclk         ( pclk                 ), 
    .prst         ( n_preset             ), 
    .psel         ( psel_i2c0             ), 
    .penable      ( penable              ), 
    .paddr        ( paddr [4:2]          ), 
    .pwrite       ( pwrite               ),
    .pwdata       ( pwdata[7:0]          ), 
    .prdata       ( prdata_i2c0           ),
    .i2c_int      (                      ),
    .scl_pad_i    (i2c0_scl_pad_i            ), 
    .scl_pad_o    (i2c0_scl_pad_o             ),
    .scl_padoen_o (i2c0_scl_padoen_o          ), 
    .sda_pad_i    (i2c0_sda_pad_i             ), 
    .sda_pad_o    (i2c0_sda_pad_o             ), 
    .sda_padoen_o (i2c0_sda_padoen_o          )
);
  
i2c_master_top i_i2c_master1_top(
    .pclk              ( pclk                 ),
    .prst              ( n_preset             ),
    .psel              ( psel_i2c1             ),
    .penable           ( penable              ),
    .paddr             ( paddr [4:2]          ),
    .pwrite            ( pwrite               ),
    .pwdata            ( pwdata[7:0]          ),
    .prdata            ( prdata_i2c1           ),
    .i2c_int           (                      ),
    .scl_pad_i         (i2c1_scl_pad_i            ),
    .scl_pad_o         (i2c1_scl_pad_o             ),
    .scl_padoen_o      (i2c1_scl_padoen_o          ),
    .sda_pad_i         (i2c1_sda_pad_i             ),
    .sda_pad_o         (i2c1_sda_pad_o             ),
    .sda_padoen_o      (i2c1_sda_padoen_o          )
);

pin_mux_rf  pin_mux_register (
	.clk                (pclk),                   
	.rst_n              (n_preset),                   
	.r_io_reuse_pad2    (r_io_reuse_pad2 ),                   
	.r_io_reuse_pad1    (r_io_reuse_pad1 ),                   
	.r_io_reuse_pad4    (r_io_reuse_pad4 ),                   
	.r_io_reuse_pad3    (r_io_reuse_pad3 ),                   
	.r_io_reuse_pad6    (r_io_reuse_pad6 ),                   
	.r_io_reuse_pad5    (r_io_reuse_pad5 ),                   
	.r_io_reuse_pad8    (r_io_reuse_pad8 ),                   
	.r_io_reuse_pad7    (r_io_reuse_pad7 ),                   
	.r_io_reuse_pad10   (r_io_reuse_pad10),                   
	.r_io_reuse_pad9    (r_io_reuse_pad9 ),                   
	.r_io_reuse_pad12   (r_io_reuse_pad12),                   
	.r_io_reuse_pad11   (r_io_reuse_pad11),                   
	.r_io_reuse_pad14   (r_io_reuse_pad14),                   
	.r_io_reuse_pad13   (r_io_reuse_pad13),                   
	.r_io_reuse_pad16   (r_io_reuse_pad16),                   
	.r_io_reuse_pad15   (r_io_reuse_pad15),                   
	.r_io_reuse_pad18   (r_io_reuse_pad18),                   
	.r_io_reuse_pad17   (r_io_reuse_pad17),                   
	.r_io_reuse_pad20   (r_io_reuse_pad20),                   
	.r_io_reuse_pad19   (r_io_reuse_pad19),                   
	.sft_adr_i          (sft_adr_i           ),                   
	.sft_dat_i          (sft_dat_i          ),                   
	.sft_wr_i           (sft_wr_i          ),                   
	.sft_rd_i           (sft_rd_i         ),                   
	.sft_rd_cs          (sft_rd_cs     ),                   
	.sft_dat_o          (sft_dat_o   )                    
);


apb2pinmux apb2pin(
    .pclk      (pclk), 
    .preset_n  (n_preset), 
    .paddr     (paddr), 
    .penable   (penable), 
    .pwrite    (pwrite), 
    .pwdata    (pwdata), 
    .psel      (psel_pinmux), 
    .pready    (pready), 
    .prdata    (prdata_pinmux), 
	.sft_adr_i (sft_adr_i),                   
	.sft_dat_i (sft_dat_i),                   
	.sft_wr_i  (sft_wr_i),                   
	.sft_rd_i  (sft_rd_i),                   
    .sft_rd_cs (sft_rd_cs),                   
	.sft_dat_o (sft_dat_o)

);


endmodule

module apb2pinmux (

    input                                  pclk      , 
    input                                  preset_n  , 
    input             [31:0]               paddr     , 
    input                                  penable   , 
    input                                  pwrite    , 
    input             [31:0]               pwdata    , 
    
    input                                  psel     , 
    output                                 pready   , 
    output            [31:0]               prdata   , 

	output            [15:0]               sft_adr_i ,                   
	output            [7:0]                sft_dat_i ,                   
	output                                 sft_wr_i  ,                   
	output                                 sft_rd_i  ,                   
    input                                  sft_rd_cs ,                   
	input             [7:0]                sft_dat_o 
);

    reg [15:0] sft_adr_i;
    reg [7:0]  sft_dat_i;
    reg sft_wr_i;
    reg sft_rd_i;
    reg pready;
    //reg [31:0]               prdata;//update
    reg phase_state;
    
    assign  prdata = sft_dat_o;

    always @(posedge pclk or negedge preset_n )
    begin
        if(!preset_n) begin
             sft_adr_i <= 0;
             sft_dat_i <= 0;
             sft_wr_i <= 0;
             pready <= 0;
//             prdata <= 0;
             phase_state <= 0;
        end
        else begin
            if(psel && (phase_state==0)) begin
                sft_adr_i <= paddr;
                sft_dat_i <= pwdata;
                sft_wr_i  <= pwrite;
                sft_rd_i  <= ~pwrite;
                phase_state <= 1;
                pready <= 1;
//                if(pwrite==0) begin
//                   prdata <= sft_dat_o;
//                end
//                else begin
//                   prdata <= 0;
//                end
                phase_state <= 1;
            end
            else if(phase_state==1) begin
                if(penable==1) begin
                    phase_state <= 0;
                end
            end
            else begin
                sft_adr_i <= 0;
                sft_dat_i <= 0;
                sft_wr_i <= 0;
                pready <= 0;
                phase_state <= 0;
            end
        end
    end





endmodule
