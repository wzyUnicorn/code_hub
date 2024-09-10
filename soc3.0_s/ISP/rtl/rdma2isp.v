//**********************************************
//  File Name: rdma2isp.v
// *********************************************
`include   "isp_dma_defs.v"
module rdma2isp
#(
  parameter BITS      = 8   
)
(
  //*********************************************
  //*********************************************
  // input/output declarations
  //*********************************************
  input             hclk       , //ahb clock
  input             n_hreset   , //ahb reset
  // input/output cfg
  input    [31:0]   isp_raddr , 
  input    [31:0]   isp_hsize , 
  input    [31:0]   isp_vsize , 
  input    [31:0]   isp_start ,
  output            isp_done  , 
  //*********************************************
  // ahb interface master signals
  //*********************************************
  output   [31:0]   dma_haddr  , // dma ahb address bus
  output    [1:0]   dma_htrans , // dma ahb transfer type
  output            dma_hwrite , // dma ahb write enable
  output    [2:0]   dma_hsize  , // dma ahb transfer size
  output    [2:0]   dma_hburst , // dma ahb burst type
  output    [3:0]   dma_hprot  , // dma ahb protected transfer signal
  output   [31:0]   dma_hwdata , // dma ahb write data bus
  output            dma_hbusreq, // dma ahb bus request signal to arbiter
  output            dma_hlock  , // dma ahb locked transfer
  input    [31:0]   hrdata_dma , // read data from mux to dma
  input             hready_dma , // ready signal from mux to dma
  input     [1:0]   hresp_dma  , // response signal from mux to dma
  input             hgrant     , // bus grant from the arbiter
  //*********************************************
  //isp signals
  //*********************************************
  output             in_href    ,
  output             in_vsync   ,
  output [BITS-1:0]  in_raw     
 );

 reg [2:0]       rdma_state;
 reg [2:0]       rdma_nxt_state;
 reg [31:0]      rdma_fifo [2000];
 reg [31:0]      rdata_cnt;
 reg [31:0]      href_cnt;
 reg [31:0]      line_cnt;
 reg [31:0]      rdma_addr;

 reg             isp_done;

 reg   [31:0]    dma_haddr  ; // dma ahb address bus
 reg    [1:0]    dma_htrans ; // dma ahb transfer type
 reg             dma_hwrite ; // dma ahb write enable
 reg    [2:0]    dma_hsize  ; // dma ahb transfer size
 reg    [2:0]    dma_hburst ; // dma ahb burst type
 reg    [3:0]    dma_hprot  ; // dma ahb protected transfer signal
 reg   [31:0]    dma_hwdata ; // dma ahb write data bus
 reg             dma_hbusreq; // dma ahb bus request signal to arbiter
 reg             dma_hlock  ; // dma ahb locked transfer

 reg             in_href    ;
 reg             in_vsync   ;
 reg [BITS-1:0]  in_raw     ;

//**********************************************

always @(posedge hclk or negedge n_hreset)
begin
    if (~n_hreset) begin
        rdma_state <= `rdma_idle;
        isp_done <= 0;
        rdata_cnt <= 0;
        href_cnt <= 0;
        line_cnt <= 0;

        dma_haddr <=   0;
        dma_htrans <=  0;
        dma_hwrite <=  0;
        dma_hsize  <=  0;
        dma_hburst <=  0;
        dma_hprot <=   0;
        dma_hwdata <=  0;
        dma_hbusreq <= 0;
        dma_hlock <=   0;

        in_href <= 0;
        in_vsync <= 0;
        in_raw <= 0;

    end
    else begin
        case(rdma_state)
            `rdma_idle : begin
                if(isp_start==1 && isp_done == 0) begin
                    rdma_state <= `rdma_read_ahb_addr;
                    rdma_addr <= isp_raddr;
                end
                else
                    rdma_state <= `rdma_idle;
                isp_done <= 0;
            end
            `rdma_read_ahb_addr : begin
                href_cnt <= 0;
                in_href <= 0;
                if(hready_dma == 1) begin
                   dma_haddr <= rdma_addr;
                   dma_htrans <= 'h2;
                   dma_hwrite <= 'h0;
                   dma_hsize  <= 'h2;
                   dma_hburst <= 'h0;
                   dma_hprot <= 'h0;
                   dma_hwdata <='h0;
                   dma_hbusreq <= 'h1;
                   dma_hlock <= 'h0;
                   rdma_state <=  `rdma_read_xfer_addr;
                end else begin
                   dma_haddr <=   0;
                   dma_htrans <=  0;
                   dma_hwrite <=  0;
                   dma_hsize  <=  0;
                   dma_hburst <=  0;
                   dma_hprot <=   0;
                   dma_hwdata <=  0;
                   dma_hbusreq <= 0;
                   dma_hlock <=   0;
                   rdma_state <= `rdma_read_ahb_addr;
                end

            end
            `rdma_read_xfer_addr : begin
                dma_haddr <=   0;
                dma_htrans <=  0;
                dma_hwrite <=  0;
                dma_hsize  <=  0;
                dma_hburst <=  0;
                dma_hprot <=   0;
                dma_hwdata <=  0;
                dma_hbusreq <= 0;
                dma_hlock <=   0;
                rdma_state <= `rdma_read_rcv_data;
            end
            `rdma_read_rcv_data : begin
                dma_haddr <=   0;
                dma_htrans <=  0;
                dma_hwrite <=  0;
                dma_hsize  <=  0;
                dma_hburst <=  0;
                dma_hprot <=   0;
                dma_hwdata <=  0;
                dma_hbusreq <= 0;
                dma_hlock <=   0;
                if(hready_dma == 1) begin
                   rdma_fifo[rdata_cnt] <= hrdata_dma; 
                   rdata_cnt <= rdata_cnt+1;
                   rdma_addr <= rdma_addr+4;
                   if(rdata_cnt < isp_hsize) begin
                      rdma_state <= `rdma_read_ahb_addr;
                   end 
                   else begin
                      rdma_state <= `rdma_xfer_line;
                   end
                end
            end
            `rdma_xfer_line : begin
                if(line_cnt==0 && href_cnt ==0) begin
                    in_vsync <= 1;
                    line_cnt <= line_cnt+1;
                end  else begin
                    in_vsync <= 0;
                    in_raw <= rdma_fifo[href_cnt];
                    in_href <= 1;
                    href_cnt <= href_cnt+1;
                    if(href_cnt==(isp_hsize-1)) begin
                        rdma_state <= `rdma_read_ahb_addr ;
                        rdata_cnt <= 0;
                        line_cnt <= line_cnt+1;
                        if(line_cnt == isp_vsize)
                            rdma_state <= `rdma_xfer_finish;
                    end
                end
            end
            `rdma_xfer_finish : begin
                isp_done <=1;
                rdata_cnt <= 0;
                line_cnt <= 0;
                href_cnt <= 0;
                rdma_state <= `rdma_idle;
                in_href <= 0;
            end
            default: begin
                rdma_state <= `rdma_idle;
                isp_done <= 0;
                rdata_cnt <= 0;
                href_cnt <= 0;
                line_cnt <= 0;
            end
        endcase
    end
end



endmodule
