module dm_wrapper #(
  parameter int          NrHarts = 1,
  parameter logic [31:0] IdcodeValue = 32'h 0000_0001,
  parameter int          BusWidth = 32
)(
  input  logic         clk_i,       
  input  logic         rst_ni,      
  output logic         ndmreset_o,  
  output logic         debug_req_o, 

  input  logic         tck_i,    // JTAG test clock pad
  input  logic         tms_i,    // JTAG test mode select pad
  input  logic         trst_ni,  // JTAG test reset pad
  input  logic         td_i,     // JTAG test data input pad
  output logic         td_o,     // JTAG test data output pad
  output logic         tdo_oe_o, // Data out output enable

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

  input                 dm_mem_hsel,
  input                 dm_mem_hwrite,
  input                 dm_mem_hready,
  input  [31:0]         dm_mem_haddr,
  input  [31:0]         dm_mem_hwdata,
  output                dm_mem_hreadyout,
  output [31:0]         dm_mem_hrdata
);

logic                  dm_req_o;
logic [BusWidth-1:0]   dm_addr_o;
logic                  dm_we_o;
logic [BusWidth-1:0]   dm_wdata_o;
logic [BusWidth/8-1:0] dm_be_o;
logic                  dm_gnt_i;
logic                  dm_rvalid_i;
logic [BusWidth-1:0]   dm_r_rdata_i;

logic                  slave_req_i;
logic                  slave_we_i;
logic [BusWidth-1:0]   slave_addr_i;
logic [BusWidth/8-1:0] slave_be_i;
logic [BusWidth-1:0]   slave_wdata_i;
logic [BusWidth-1:0]   slave_rdata_o;


dm_top u_dm_top (
  .clk_i(clk_i),
  .rst_ni(rst_ni),
  .testmode_i(1'b0),
  .ndmreset_o(ndmreset_o), //TODO
  .dmactive_o(),
  .debug_req_o(debug_req_o),
  .unavailable_i(1'b0), 

  // bus device with debug memory, for an execution based technique
  .slave_req_i   (slave_req_i    ),
  .slave_we_i    (slave_we_i     ),
  .slave_addr_i  (slave_addr_i   ),
  .slave_be_i    (slave_be_i     ),
  .slave_wdata_i (slave_wdata_i  ),
  .slave_rdata_o (slave_rdata_o  ),

  // bus host, for system bus accesses
  .master_req_o    (dm_req_o    ),
  .master_add_o    (dm_addr_o   ),
  .master_we_o     (dm_we_o     ),
  .master_wdata_o  (dm_wdata_o  ),
  .master_be_o     (dm_be_o     ),
  .master_gnt_i    (dm_gnt_i    ),
  .master_r_valid_i(dm_rvalid_i),
  .master_r_rdata_i(dm_r_rdata_i),

  //JTAG interface.
  .tck_i    ( tck_i    ), // JTAG test clock pad
  .tms_i    ( tms_i    ), // JTAG test mode select pad
  .trst_ni  ( trst_ni  ), // JTAG test reset pad
  .td_i     ( td_i     ), // JTAG test data input pad
  .td_o     ( td_o     ), // JTAG test data output pad
  .tdo_oe_o ( tdo_oe_o )  // Data out output enable
);

//dm interface to ahb
core2ahb inst_dm_core2ahb(
  .clk  (   clk_i),
  .rst_n( rst_ni),
  .data_req   (   dm_req_o),
  .data_gnt   (   dm_gnt_i),
  .data_rvalid(dm_rvalid_i),
  .data_we    (    dm_we_o),
  .data_be    (    dm_be_o),
  .data_addr  (  dm_addr_o),
  .data_wdata ( dm_wdata_o),
  .data_rdata ( dm_r_rdata_i),
  //ahb interface
  .ahb_hmastlock(),
  .ahb_htrans   (dm_htrans_o),
  .ahb_hsel     (  dm_hsel_o),
  .ahb_hready   (dm_hready_o),
  .ahb_hwrite   (dm_hwrite_o),
  .ahb_haddr    ( dm_haddr_o),
  .ahb_hsize    ( dm_hsize_o),
  .ahb_hburst   (dm_hburst_o),
  .ahb_hprot    ( dm_hprot_o),
  .ahb_hwdata   (dm_hwdata_o),
  .ahb_hreadyout(dm_hreadyout_i),
  .ahb_hresp    (dm_hresp_i ),
  .ahb_hrdata   (dm_hrdata_i)
);


always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni) 
        slave_req_i<=1'b0;
    else 
        slave_req_i<=dm_mem_hsel&dm_mem_hready;
end

always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni) 
        slave_we_i<=1'b0;
    else 
        slave_we_i<=dm_mem_hsel&dm_mem_hready&dm_mem_hwrite;
end

always@(posedge clk_i or negedge rst_ni)begin
    if(~rst_ni) 
        slave_addr_i<=1'b0;
    else if(dm_mem_hsel&dm_mem_hready)
        slave_addr_i<=dm_mem_haddr;
end

assign slave_be_i=4'b1111;

assign slave_wdata_i = dm_mem_hwdata;

assign dm_mem_hrdata = slave_rdata_o;
assign dm_mem_hreadyout=1;


endmodule
