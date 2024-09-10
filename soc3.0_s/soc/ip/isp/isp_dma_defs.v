
//--------- RDMA FSM Status-----------------------------
`define rdma_idle                  3'b000
`define rdma_xfer_finish           3'b001
`define rdma_xfer_line             3'b010
`define rdma_read_xfer_addr        3'b011
`define rdma_read_ahb_addr         3'b100
`define rdma_read_rcv_data         3'b101
//----------WDMA FSM Status-----------------------------
`define wdma_idle                  3'b000
`define wdma_xfer_finish           3'b001
`define wdma_rcv_line              3'b010
`define wdma_write_xfer_addr       3'b011
`define wdma_write_xfer_data       3'b100
`define wdma_write_xfer_done       3'b101


