//**********************************************
//  File Name: dma.v
// *********************************************
module isp_dma
#(
  parameter BITS      = 8   
)
(
  //*********************************************
  // input/output declarations
  //*********************************************
  input             hclk       , //ahb clock
  input             n_hreset   , //ahb reset
  //*********************************************
  // ahb interface slave signals
  //*********************************************
  input    [31:0]   haddr      , // ahb adress bus from mux
  input             hsel       , // dma select from decoder
  input     [1:0]   htrans     , // ahb transfer type from mux
  input             hwrite     , // ahb write enable from mux
  input     [2:0]   hsize      , // ahb transfer size from mux
  input    [31:0]   hwdata     , // ahb write data bus from mux
  input     [2:0]   hburst     , // Burst type
  input     [3:0]   hprot      , // Protection control
  input     [3:0]   hmaster    , // Master select
  input             hmastlock  , // Locked transfer
  input             hready_in  , // Transfer done
  output            dma_hready , // hready from dma to mux
  output    [1:0]   dma_hresp  , // response from dma to mux
  output   [31:0]   dma_hrdata , // dma read data to mux
  //*********************************************
  // ahb interface rdma master signals
  //*********************************************
  output   [31:0]   rdma_haddr  , // dma ahb address bus
  output    [1:0]   rdma_htrans , // dma ahb transfer type
  output            rdma_hwrite , // dma ahb write enable
  output    [2:0]   rdma_hsize  , // dma ahb transfer size
  output    [2:0]   rdma_hburst , // dma ahb burst type
  output    [3:0]   rdma_hprot  , // dma ahb protected transfer signal
  output   [31:0]   rdma_hwdata , // dma ahb write data bus
  output            rdma_hbusreq, // dma ahb bus request signal to arbiter
  output            rdma_hlock  , // dma ahb locked transfer
  input    [31:0]   hrdata_rdma , // read data from mux to dma
  input             hready_rdma , // ready signal from mux to dma
  input     [1:0]   hresp_rdma  , // response signal from mux to dma
  input             hgrant     , // bus grant from the arbiter

  //*********************************************
  // ahb interface wdma master signals
  //*********************************************
  output   [31:0]   wdma_haddr  , // dma ahb address bus
  output    [1:0]   wdma_htrans , // dma ahb transfer type
  output            wdma_hwrite , // dma ahb write enable
  output    [2:0]   wdma_hsize  , // dma ahb transfer size
  output    [2:0]   wdma_hburst , // dma ahb burst type
  output    [3:0]   wdma_hprot  , // dma ahb protected transfer signal
  output   [31:0]   wdma_hwdata , // dma ahb write data bus
  output            wdma_hbusreq, // dma ahb bus request signal to arbiter
  output            wdma_hlock  , // dma ahb locked transfer
  input    [31:0]   hrdata_wdma , // read data from mux to dma
  input             hready_wdma , // ready signal from mux to dma
  input     [1:0]   hresp_wdma  , // response signal from mux to dma
  //*********************************************
  //isp signals
  //*********************************************
  output             in_href    ,
  output             in_vsync   ,
  output [BITS-1:0]  in_raw     ,

  input              dm_href_o  ,
  input              dm_vsync_o ,
  input [BITS-1:0]   dm_r_o     ,
  input [BITS-1:0]   dm_g_o     ,
  input [BITS-1:0]   dm_b_o     

 );


//**********************************************
// Main code
//**********************************************
  reg    [15:0] addr;
  reg     [1:0] size;
  reg           n_read;
  reg           access_valid;
  reg           valid;
  reg           mis_err;
  reg           r_hresp;
  reg    [31:0] write_data;
  reg    [3:0]  ahb_byte;

  reg            dma_hready ; // hready from dma to mux
  reg    [1:0]   dma_hresp  ; // response from dma to mux
  reg   [31:0]   dma_hrdata ; // dma read data to mux


  reg isp_raddr_sel = 1'b0;
  reg isp_waddr_sel = 1'b0;
  reg isp_hsize_sel = 1'b0;
  reg isp_vsize_sel = 1'b0;
  reg isp_start_sel = 1'b0;
  reg isp_status_sel = 1'b0;

//---------------RDMA register------------------
  reg [31:0] isp_raddr;
  reg [31:0] isp_waddr;
  reg [31:0] isp_hsize;
  reg [31:0] isp_vsize;
  reg [31:0] isp_start;
  reg [31:0] isp_status;

  wire isp_done;

//**********************************************
// Main code
//**********************************************
// valid access control - ahb interface (ahb specific)
// generates all ahb responses.

always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)begin
        addr   <= 16'h0;
        size   <=  2'b0;
        n_read <=  1'b0;
        access_valid <= 1'b0;
    end
    else begin 
        access_valid <= valid;
        if (hready_in & hsel)begin
            addr   <= haddr[15:0];
            size   <= hsize[ 1:0];
            n_read <= hwrite     ;
        end
        else;
    end
end

always @(*)begin
    if (((htrans == `trn_nonseq) | (htrans == `trn_seq)) & hsel & hready_in & ~mis_err)begin
        valid = 1'b1; 
    end
    else begin
        valid = 1'b0;
    end
end

always @(*)begin
    if ((( haddr[0]             & (hsize == {1'b0,`sz_half}))  |
         ((haddr[1:0] != 2'b00) & (hsize == {1'b0,`sz_word}))) & 
        ((htrans == `trn_nonseq) | (htrans == `trn_seq)) & hsel )
        mis_err = 1'h1; //hubing 
    else
        mis_err = 1'h0;
end 

always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)begin
        dma_hresp   <= `rsp_okay;
        dma_hrdata  <= 0;
        r_hresp <= 0;
    end
    else if ((htrans == `trn_idle) & hready_in)begin
        dma_hresp   <= `rsp_okay;
        r_hresp <= 0;
    end
    else if (mis_err)begin
        dma_hresp   <= `rsp_error;
        r_hresp <= 1;
    end
    else if (r_hresp == 1'b1)begin
        dma_hresp   <= `rsp_error;
        r_hresp <= 0;
    end
    else begin
        dma_hresp <= `rsp_okay;
        r_hresp <= 0;
    end
end

// ahb ready signal
always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)
        dma_hready <= 1'b1;
    else if ((((htrans == `trn_idle) | (htrans == `trn_busy)) & hsel & hready_in & ~mis_err) 
                | r_hresp | ~hsel )
        dma_hready <= 1'b1;
    else if (valid == 1'b1) //assumes accesses will always complete with zero wait states
        dma_hready <= 1'b1;
    else
        dma_hready <= 1'b0;
end

always @(*)begin
    write_data = hwdata;
end

// generate byte select strobes to easily allow byte access
// Assume arm replicates data across the bus as necessary.

always @(*)begin
    ahb_byte = 4'hf;
    if (size == `sz_byte)begin
        if (addr[1:0] == 2'b00)
            ahb_byte = 4'b0001;
        else if (addr[1:0] == 2'b01)
            ahb_byte = 4'b0010;
        else if (addr[1:0] == 2'b10)
            ahb_byte = 4'b0100;
        else
            ahb_byte = 4'b1000;
    end
    else if (size == `sz_half)begin
        if (addr[1] == 1'b0)
            ahb_byte = 4'b0011;
        else
            ahb_byte = 4'b1100;
    end
    else
        ahb_byte = 4'b1111;
end

always @(*)begin

    isp_raddr_sel = 1'b0;
    isp_waddr_sel = 1'b0;
    isp_hsize_sel = 1'b0;
    isp_vsize_sel = 1'b0;
    isp_start_sel = 1'b0;
    isp_status_sel = 1'b0;

    if (n_read & access_valid)
        case ({addr[15:2], 2'b00})
            'h00:
               isp_raddr_sel = 1'b1;
            'h04:
               isp_waddr_sel = 1'b1;
            'h08:
               isp_hsize_sel = 1'b1;
            'h0c:
               isp_vsize_sel = 1'b1;
            'h10:
               isp_start_sel = 1'b1;      
            'h14:
               isp_status_sel = 1'b1;      
            default: begin
               isp_raddr_sel = 1'b0;
               isp_waddr_sel = 1'b0;
               isp_hsize_sel = 1'b0;
               isp_vsize_sel = 1'b0;
               isp_start_sel = 1'b0;
               isp_status_sel = 1'b0;
            end
        endcase
end

//------------------store rdma cfg---------------------------
always @(posedge hclk or negedge n_hreset)
begin
    if (~n_hreset)
    begin
        isp_raddr <= 32'h0;
        isp_hsize <= 32'h0;
        isp_vsize <= 32'h0;
        isp_start <= 32'h0;
        isp_status <= 32'h0;
        isp_waddr <= 32'h0;
    end
    else begin
        if (isp_raddr_sel)
        begin
            isp_raddr <= write_data;
        end 

        if (isp_waddr_sel)
        begin
            isp_waddr <= write_data;
        end 

        if (isp_hsize_sel)
        begin
            isp_hsize <= write_data;
        end  

        if (isp_vsize_sel)
        begin
            isp_vsize <= write_data;
        end
        if (isp_start_sel)
        begin
            isp_start <= write_data;
        end
        if (isp_status_sel && (write_data[0]==1))
        begin
            isp_status <= 0;
        end 
        if(isp_done) 
        begin
            isp_start <= 0;
            isp_status <= 1;
        end
    end
end
//---------------------------------------------
//dma_hrdata
//=============================================

always @(*)begin
    dma_hrdata = 32'h00000000;
    if (access_valid & ~n_read)begin
        case ({addr[15:2], 2'b00})
            'h00 :
                dma_hrdata = isp_raddr;
            'h04 :
                dma_hrdata = isp_waddr;
            'h08 :
                dma_hrdata = isp_hsize;
            'h0c :
                dma_hrdata = isp_vsize;
            'h10 :
                dma_hrdata = isp_start;
            'h14 :
                dma_hrdata = isp_status;
        default :
                dma_hrdata = 32'h00000000;
        endcase
    end
end


//---------------ISP RDMA/WDMA------------------------------

rdma2isp rdma_to_isp (
  .hclk       (hclk), 
  .n_hreset   (n_hreset), 
  .isp_raddr  (isp_raddr), 
  .isp_hsize  (isp_hsize), 
  .isp_vsize  (isp_vsize),
  .isp_start  (isp_start),
  .isp_done   (isp_done),
  .dma_haddr  (rdma_haddr), 
  .dma_htrans (rdma_htrans),
  .dma_hwrite (rdma_hwrite), 
  .dma_hsize  (rdma_hsize), 
  .dma_hburst (rdma_hburst), 
  .dma_hprot  (rdma_hprot), 
  .dma_hwdata (rdma_hwdata),  
  .dma_hbusreq(rdma_hbusreq), 
  .dma_hlock  (rdma_hlock), 
  .hrdata_dma (hrdata_rdma), 
  .hready_dma (hready_rdma),  
  .hresp_dma  (hresp_rdma),  
  .hgrant     (hgrant),   
  .in_href    (in_href),
  .in_vsync   (in_vsync),
  .in_raw     (in_raw)
);

isp2wdma isp_to_wdma(
  .hclk       (hclk), 
  .n_hreset   (n_hreset), 
  .isp_waddr  (isp_waddr), 
  .isp_hsize  (isp_hsize), 
  .isp_vsize  (isp_vsize), 
  .dma_haddr  (wdma_haddr), 
  .dma_htrans (wdma_htrans), 
  .dma_hwrite (wdma_hwrite), 
  .dma_hsize  (wdma_hsize), 
  .dma_hburst (wdma_hburst), 
  .dma_hprot  (wdma_hprot), 
  .dma_hwdata (wdma_hwdata), 
  .dma_hbusreq(wdma_hbusreq), 
  .dma_hlock  (wdma_hlock), 
  .hrdata_dma (hrdata_wdma), 
  .hready_dma (hready_wdma), 
  .hresp_dma  (hresp_wdma), 
  .hgrant     (1), 
  .dm_href_o  (dm_href_o), 
  .dm_vsync_o (dm_vsync_o),
  .dm_r_o     (dm_r_o),
  .dm_g_o     (dm_g_o),
  .dm_b_o     (dm_b_o)

 );


endmodule
