module csr(
    // connect to apb_to_csr
    input clk,  // pclk
    input rstn, // prstn
    input  [31:0]     paddr,
    input             psel,
    input             penable,
    input             pwrite,
    input  [31:0]     pwdata,
    output            pready,
    output reg [31:0] prdata,
    // output registers
    output reg            start,
    output reg            clear,
    output reg [ 2:0]     mode,
    output reg [15:0]     conv_count,
    output reg [15:0]     pool_count,
    output reg [15:0]     line_count,

    output reg            din_dma_en,
    output reg            dout_dma_en,
    output reg [ 31:0]    dma_src_addr,
    output reg [ 31:0]    dma_dst_addr,

    // input status
    input             done,
    input             overflow,
    input             underflow,
    // interrupt request
    output            intr_done_req,
    output            intr_overflow_req,
    output            intr_underflow_req
);

parameter ADDR_CTRL0       = 8'h00; 
parameter ADDR_CTRL1       = 8'h04; 
parameter ADDR_COUNT0      = 8'h08;
parameter ADDR_COUNT1      = 8'h0c;
parameter ADDR_STATUS      = 8'h10; 
parameter ADDR_DIN         = 8'h14; 
parameter ADDR_DOUT        = 8'h18; 
parameter ADDR_DMA_EN      = 8'h1c; 
parameter ADDR_DMA_SRC_ADDR= 8'h20; 
parameter ADDR_DMA_DST_ADDR= 8'h24; 
parameter ADDR_INTR_EN     = 8'h28; 
parameter ADDR_INTR_STATUS = 8'h2c; 

// write and read valid signal
assign apb_write_vld=pwrite && psel && penable;
assign apb_read_vld =(!pwrite) && psel && penable;
assign pready=1'b1;

// -----------------------------
// Write enable
// -----------------------------
wire wr_ctrl0       = apb_write_vld & (paddr == ADDR_CTRL0       ); // start and clear(top toggle) 
wire wr_ctrl1       = apb_write_vld & (paddr == ADDR_CTRL1       ); // mode
wire wr_count0      = apb_write_vld & (paddr == ADDR_COUNT0         ); // conv count,max_pooling count
wire wr_count1      = apb_write_vld & (paddr == ADDR_COUNT1         ); // line count
wire wr_status      = apb_write_vld & (paddr == ADDR_STATUS      ); // just use to clear status
wire wr_dma_en      = apb_write_vld & (paddr == ADDR_DMA_EN      ); // dma_en and size
wire wr_dma_src_addr= apb_write_vld & (paddr == ADDR_DMA_SRC_ADDR      ); // dma_src addr
wire wr_dma_dst_addr= apb_write_vld & (paddr == ADDR_DMA_DST_ADDR      ); // dma_dst addr
wire wr_intr_en     = apb_write_vld & (paddr == ADDR_INTR_EN     ); // enable or disable overflow,underflow,done interrupt
wire wr_intr_status = apb_write_vld & (paddr == ADDR_INTR_STATUS ); // overflow,underflow,done interrupt

// wire rd_dout = apb_read_vld & (addr == ADDR_DOUT);

// ----------------------------
// CTRL0 Register
// ----------------------------
// Operation start (pulse)
//reg start;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        start <= 1'b0;
    else if (start)
        start <= 1'b0;
    else if (wr_ctrl0)
        start <= pwdata[0];
end

// Clear (pulse)
//reg clear;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        clear <= 1'b0;
    else if (clear)
        clear <= 1'b0;
    else if (wr_ctrl0)
        clear <= pwdata[1];
end

// ----------------------------
// CTRL1 Register
// ----------------------------
// Operation mode
//reg [2:0] mode;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        mode <= '0;
    else if (wr_ctrl1)
        mode <= pwdata[2:0]; 
end

// ----------------------------
// Count Register
// ----------------------------
// Operation count
//reg [15:0] conv_count;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        conv_count <= '0;
    else if (wr_count0)
        conv_count <= pwdata[31:16]; 
end

//reg [15:0] pool_count;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        pool_count <= '0;
    else if (wr_count0)
        pool_count <= pwdata[15:0]; 
end

//reg [15:0] line_count;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        line_count <= '0;
    else if (wr_count1)
        line_count <= pwdata[15:0]; 
end

// ----------------------------
// DMA Enable Register
// ----------------------------
//reg din_dma_en;
always @(posedge clk or negedge rstn) begin
    if (!rstn)
        din_dma_en <= 1'b0;
    else if (clear)
        din_dma_en <= 1'b0;
    else if (wr_dma_en)
        din_dma_en <= pwdata[0];
end

/*
reg [4:0] din_dma_burst_size;
always @ (posedge clk or negedge rstn) begin // support 1-16
    if (!rstn)
        din_dma_burst_size <= 5'd16;
    else if (wr_dma_en)
        din_dma_burst_size <= wdata[5:1];
end
*/

//reg dout_dma_en;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        dout_dma_en <= 1'b0;
    else if (clear)
        dout_dma_en <= 1'b0;
    else if (wr_dma_en)
        dout_dma_en <= pwdata[16];
end

/*
reg [4:0] dout_dma_burst_size;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        dout_dma_burst_size <= 5'd16;
    else if (wr_dma_en)
        dout_dma_burst_size <= wdata[13:9];
end
*/

//reg [31:0] dma_src_addr;
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        dma_src_addr<='d0;
    else if(wr_dma_src_addr)
        dma_src_addr<=pwdata[31:0];
end

//reg [31:0] dma_dst_addr;
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        dma_dst_addr<='d0;
    else if(wr_dma_dst_addr)
        dma_dst_addr<=pwdata[31:0];
end
// ----------------------------
// Interrupt Enable Register
// ----------------------------
reg intr_done_en;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        intr_done_en <= 1'b0;
    else if (clear)
        intr_done_en <= 1'b0;
    else if (wr_intr_en)
        intr_done_en <= pwdata[0];
end

reg intr_underflow_en;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        intr_underflow_en <= 1'b0;
    else if (clear)
        intr_underflow_en <= 1'b0;
    else if (wr_intr_en)
        intr_underflow_en <= pwdata[1];
end

reg intr_overflow_en;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        intr_overflow_en <= 1'b0;
    else if (clear)
        intr_overflow_en <= 1'b0;
    else if (wr_intr_en)
        intr_overflow_en <= pwdata[2];
end


// ----------------------------
// Status Register
// ----------------------------

reg done_status;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        done_status <= 1'b0;
    else if (clear)
        done_status <= 1'b0;
    else if (done)
        done_status <= 1'b1;
    else if (wr_status & pwdata[0])
        done_status <= 1'b0;
end

reg underflow_status;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        underflow_status <= 1'b0;
    else if (clear)
        underflow_status <= 1'b0;
    else if (underflow)
        underflow_status <= 1'b1;
    else if (wr_status & pwdata[1])  // support write 1 to clear, not only clear
        underflow_status <= 1'b0;
end

reg overflow_status;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        overflow_status <= 1'b0;
    else if (clear)
        overflow_status <= 1'b0;
    else if (overflow)
        overflow_status <= 1'b1;
    else if (wr_status & pwdata[2])  // support write 1 to clear, not only clear
        overflow_status <= 1'b0;
end


// ----------------------------
// Interrupt Status Register
// ----------------------------
reg intr_done;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        intr_done <= 1'b0;
    else if (clear)
        intr_done <= 1'b0;
    else if (done & intr_done_en)
        intr_done <= 1'b1;
    else if (wr_intr_status & pwdata[0])
        intr_done <= 1'b0;
end

reg intr_underflow;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        intr_underflow <= 1'b0;
    else if (clear)
        intr_underflow <= 1'b0;
    else if (underflow & intr_underflow_en)
        intr_underflow <= 1'b1;
    else if (wr_intr_status & pwdata[1])  // support write 1 to clear, not only clear
        intr_underflow <= 1'b0;
end

reg intr_overflow;
always @ (posedge clk or negedge rstn) begin
    if (!rstn)
        intr_overflow <= 1'b0;
    else if (clear)
        intr_overflow <= 1'b0;
    else if (overflow & intr_overflow_en)
        intr_overflow <= 1'b1;
    else if (wr_intr_status & pwdata[2])  // support write 1 to clear, not only clear
        intr_overflow <= 1'b0;
end

// ----------------------------
// Read data
// ----------------------------
always@(*) begin
    if(apb_read_vld)begin
         case (paddr[7:0])
             ADDR_CTRL0        : prdata = {30'h0, clear, start};
             ADDR_CTRL1        : prdata = {29'h0, mode};
             ADDR_COUNT0       : prdata = {conv_count, pool_count};
             ADDR_COUNT1       : prdata = {16'h0, line_count};
             ADDR_STATUS       : prdata = {31'h0, overflow_status,underflow_status,done_status};
             ADDR_DMA_EN       : prdata = {15'h0, dout_dma_en, 15'h0, din_dma_en};
             ADDR_DMA_SRC_ADDR : prdata = {dma_src_addr};
             ADDR_DMA_DST_ADDR : prdata = {dma_dst_addr};
             ADDR_INTR_EN      : prdata = {29'h0, intr_overflow_en ,intr_underflow_en  ,intr_done_en};
             ADDR_INTR_STATUS  : prdata = {29'h0, intr_overflow_req,intr_underflow_req ,intr_done_req};
             //ADDR_DIN        : prdata = '0;
             //ADDR_DOUT       : rdata = dout_byte_reorder(dout_bus_rdata, byte_size);
             default           : prdata = '0;
         endcase
    end
    else
        prdata <= 32'd0;
end

endmodule
