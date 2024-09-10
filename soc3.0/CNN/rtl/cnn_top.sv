module cnn_top(
    // AHB master interface  connect to cnn
    input                hclk,
    input                hrstn,
    //output               hsel,
    output        [31:0] haddr,
    output        [ 1:0] htrans,
    output        [ 2:0] hsize,
    output               hwrite,
    //output               hready,
    output        [31:0] hwdata,
    input         [31:0] hrdata,
    input                hready,
    input         [1:0]  hresp,
    // APB slave interface   connect to csr
    input                pclk,
    input                prstn,
    input         [31:0] paddr,
    input                psel,
    input                penable,
    input                pwrite,
    input         [31:0] pwdata,
    output               pready,
    output        [31:0] prdata,
    // Interrupt   csr's output
    output               cnn_intr_done_req,
    output               cnn_intr_ovf_req,
    output               cnn_intr_unf_req
);

wire start;
wire clear;
wire [2:0] mode;
wire [15:0] conv_count;
wire [15:0] pool_count;
wire [15:0] line_count;
wire din_dma_en;
wire dout_dma_en;
wire [31:0] dma_src_addr;
wire [31:0] dma_dst_addr;
wire done;
wire overflow;
wire underflow;

csr u_csr(
 // connect to apb_to_csr
    .clk(pclk),  // pclk
    .rstn(prstn), // prstn
    .paddr(paddr),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .pready(pready),
    .prdata(prdata),
    // output registers
    .start(start),
    .clear(clear),
    .mode(mode),
    .conv_count(conv_count),
    .pool_count(pool_count),
    .line_count(line_count),

    .din_dma_en(din_dma_en),
    .dout_dma_en(dout_dma_en),
    .dma_src_addr(dma_src_addr),
    .dma_dst_addr(dma_dst_addr),

    // input status
    .done(done),
    .overflow(overflow),
    .underflow(underflow),
    // interrupt request
    .intr_done_req(cnn_intr_done_req),
    .intr_overflow_req(cnn_intr_ovf_req),
    .intr_underflow_req(cnn_intr_unf_req)
);

wire ce;
wire we;
wire [12:0] addr;
wire [7:0] wdata;
wire [7:0] rdata;

cnn u_cnn(
    .clk(hclk),
    .rstn(hrstn),
    //
    .haddr(haddr),
    .htrans(htrans),
    .hsize(hsize),
    .hwrite(hwrite),
    .hwdata(hwdata),
    .hrdata(hrdata),
    .hready(hready),
    .hresp(hresp),
    //from csr
    .start(start),
    .clear(clear),
    .mode(mode),
    .pool_count(pool_count),// half of total
    .conv_count(conv_count),// half of total
    .line_count(line_count),// total
    // dma
    .din_dma_en(din_dma_en),
    .dout_dma_en(dout_dma_en),
    .dma_src_addr(dma_src_addr),
    .dma_dst_addr(dma_dst_addr),
    // SRAM
    .ce_o(ce),
    .we_o(we),
    .addr_o(addr),
    .wdata_o(wdata),
    .rdata(rdata),
    // status and result
    .done(done),
    .overflow(overflow),
    .underflow(underflow),
    .result(result)
);

mini_ram #(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(13)
) u_mini_ram(
   .clk(hclk),
   .rstn(hrstn),
   .addr(addr),
   .din(wdata),
   .ce(ce), // chip select
   .we(we), // write:0 read:1
   .dout(rdata)
);

endmodule
