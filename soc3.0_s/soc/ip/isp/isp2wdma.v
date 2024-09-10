//**********************************************
//  File Name: isp2wdma.v
// *********************************************
`include   "isp_dma_defs.v"
module isp2wdma
#(
  parameter BITS      = 8   
)
(
  //*********************************************
  //*********************************************
  // input/output declarations
  //*********************************************
  input               hclk       , //ahb clock
  input               n_hreset   , //ahb reset
  // input/output cfg
  input    [31:0]     isp_waddr , 
  input    [31:0]     isp_hsize , 
  input    [31:0]     isp_vsize , 
  //*********************************************
  // ahb interface master signals
  //*********************************************
  output   [31:0]     dma_haddr  , // dma ahb address bus
  output    [1:0]     dma_htrans , // dma ahb transfer type
  output              dma_hwrite , // dma ahb write enable
  output    [2:0]     dma_hsize  , // dma ahb transfer size
  output    [2:0]     dma_hburst , // dma ahb burst type
  output    [3:0]     dma_hprot  , // dma ahb protected transfer signal
  output   [31:0]     dma_hwdata , // dma ahb write data bus
  output              dma_hbusreq, // dma ahb bus request signal to arbiter
  output              dma_hlock  , // dma ahb locked transfer
  input    [31:0]     hrdata_dma , // read data from mux to dma
  input               hready_dma , // ready signal from mux to dma
  input     [1:0]     hresp_dma  , // response signal from mux to dma
  input               hgrant     , // bus grant from the arbiter
  //*********************************************
  //isp signals
  //*********************************************
  input               dm_href_o  ,
  input               dm_vsync_o ,
  input [BITS-1:0]    dm_r_o     ,
  input [BITS-1:0]    dm_g_o     ,
  input [BITS-1:0]    dm_b_o     

 );

 reg [2:0]       wdma_state;
 //reg [31:0]      wdma_fifo [2000]; //update
 reg [31:0]      wdma_fifo [1999:0]; 
 reg [31:0]      wdata_cnt;
 reg [31:0]      href_cnt;
 reg [31:0]      line_cnt;
 reg [31:0]      wdma_addr;

 reg   [31:0]    dma_haddr  ; // dma ahb address bus
 reg    [1:0]    dma_htrans ; // dma ahb transfer type
 reg             dma_hwrite ; // dma ahb write enable
 reg    [2:0]    dma_hsize  ; // dma ahb transfer size
 reg    [2:0]    dma_hburst ; // dma ahb burst type
 reg    [3:0]    dma_hprot  ; // dma ahb protected transfer signal
 reg   [31:0]    dma_hwdata ; // dma ahb write data bus
 reg             dma_hbusreq; // dma ahb bus request signal to arbiter
 reg             dma_hlock  ; // dma ahb locked transfer
 reg   [23:0]    rcv_data;


//**********************************************
//`define wdma_idle                  3'b000
//`define wdma_xfer_finish           3'b001
//`define wdma_rcv_line              3'b010
//`define wdma_write_xfer_addr       3'b011
//`define wdma_write_xfer_data       3'b100


always @(posedge hclk or negedge n_hreset)
begin
    if (~n_hreset) begin
        wdma_state <= `wdma_idle;
        wdata_cnt <= 0;
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
        wdma_addr <= 0;

    end
    else begin
        case(wdma_state)
        `wdma_idle: begin
            if(dm_vsync_o==1) begin 
               wdma_state <= `wdma_rcv_line;
               wdma_addr <= isp_waddr;
            end
        end
        `wdma_rcv_line: begin
            if(dm_href_o==1) begin
                 href_cnt <= href_cnt+1;
                 wdma_fifo[href_cnt] <= {8'h0,dm_r_o,dm_g_o,dm_b_o};
                 if(href_cnt == isp_hsize-1 ) begin
                    wdma_state <=  `wdma_write_xfer_addr;
                 end
            end
        end
        `wdma_write_xfer_addr: begin
                if(hready_dma == 1) begin
                   dma_haddr <= wdma_addr;
                   dma_htrans <= 'h2;
                   dma_hwrite <= 'h1;
                   dma_hsize  <= 'h2;
                   dma_hburst <= 'h0;
                   dma_hprot <= 'h0;
                   dma_hwdata <= 'h0;
                   dma_hbusreq <= 'h1;
                   dma_hlock <= 'h0;
                   wdma_state <=  `wdma_write_xfer_data;
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
                   wdma_state <= `wdma_write_xfer_addr;
                end
        end
        `wdma_write_xfer_data: begin
              dma_haddr <= 'h0;
              dma_htrans <= 'h0;
              dma_hwrite <= 'h0;
              dma_hsize  <= 'h0;
              dma_hburst <= 'h0;
              dma_hprot <= 'h0;
              dma_hwdata <= 'h0;
              dma_hbusreq <= 'h0;
              dma_hlock <= 'h0;
              dma_hwdata <= wdma_fifo[wdata_cnt];
              wdma_state <= `wdma_write_xfer_done;
        end
        `wdma_write_xfer_done: begin
            if(hready_dma ==1) begin
                if(wdata_cnt == isp_hsize-1) begin
                    if(line_cnt == isp_vsize-1) begin
                        wdma_state <= `wdma_xfer_finish;
                    end
                    else begin
                        wdma_state <= `wdma_rcv_line;
                        line_cnt <= line_cnt+1;
                    end
                    wdata_cnt <= 0;
                    href_cnt <= 0;
                end else begin
                    wdata_cnt <= wdata_cnt+1;
                    wdma_state <= `wdma_write_xfer_addr;
                    wdma_addr <= wdma_addr+4;
                end
            end
        end
        `wdma_xfer_finish: begin
            wdma_state <= `wdma_idle;
            wdata_cnt <= 0;
            href_cnt <= 0;
            line_cnt <= 0;
            wdma_addr <= 0;
        end
        default : begin
            wdma_state <= `wdma_idle;
            wdata_cnt <= 0;
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
            wdma_addr <= 0;
        end
        endcase
    end
end



endmodule
