module core2ahb(/*autoarg*/
   // Outputs
   data_gnt, data_rvalid, data_rdata, ahb_hmastlock, ahb_htrans,
   ahb_hsel, ahb_hready, ahb_hwrite, ahb_haddr, ahb_hsize, ahb_hburst,
   ahb_hprot, ahb_hwdata,
   // Inputs
   clk, rst_n, data_req, data_we, data_be, data_addr, data_wdata,
   ahb_hreadyout, ahb_hresp, ahb_hrdata
   );

//==============================================================================
// Parameters Definitions
//==============================================================================
parameter BW_HADDR   = 32;
parameter BW_HDATA   = 32;
parameter IDLE       = 2'd0,
          DATA_PH    = 2'd1,
          ADDR_PH    = 2'd2;

//==============================================================================
// Ports declarations
//==============================================================================
input clk;
input rst_n;

//core interface
input                   data_req;
output                  data_gnt;
output                  data_rvalid;
input                   data_we;
input [3:0]             data_be;
input [BW_HADDR-1:0]    data_addr;
input [BW_HDATA-1:0]    data_wdata;
output  [BW_HDATA-1:0]  data_rdata;

//ahb interface
output                ahb_hmastlock;
output [1:0]          ahb_htrans;
output                ahb_hsel;
output                ahb_hready;
output                ahb_hwrite;
output [BW_HADDR-1:0] ahb_haddr;
output [2:0]          ahb_hsize;
output [2:0]          ahb_hburst;
output [3:0]          ahb_hprot;
output [BW_HDATA-1:0] ahb_hwdata;
input                 ahb_hreadyout;
input                 ahb_hresp;
input  [BW_HDATA-1:0] ahb_hrdata;

//==============================================================================
// Internal Wires declaration
//==============================================================================
/*autowire*/

reg [1:0] cs,ns;
reg [BW_HDATA-1:0] wdata_reg;
reg data_we_reg;
reg [BW_HADDR-1:0] addr_reg;
reg [3:0] data_be_reg;
wire [3:0] data_be_mux;
//==============================================================================
// Main Body
//==============================================================================


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case(cs)
        IDLE: begin
            ns = data_req ? (ahb_hreadyout ? DATA_PH : ADDR_PH) : IDLE;
        end
        DATA_PH: begin
            ns = (ahb_hreadyout & ~data_req) ? IDLE : DATA_PH;
        end
        ADDR_PH: begin
            ns = ahb_hreadyout ? DATA_PH : ADDR_PH;
        end
        default: begin 
            ns = IDLE;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_we_reg <= 1'b0;
    end
    else if((cs == IDLE) & data_req & (~ahb_hreadyout)) begin
        data_we_reg <= data_we;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr_reg <= {BW_HADDR{1'h0}};
    end
    else if((cs == IDLE) & data_req & (~ahb_hreadyout)) begin
        addr_reg <= data_addr;
    end
end
assign data_be_mux = (cs == ADDR_PH) ? data_be_reg : data_be;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_be_reg <= 4'h0;
    end
    else if((cs == IDLE) & data_req & (~ahb_hreadyout)) begin
        data_be_reg <= data_be;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wdata_reg <= {BW_HDATA{1'h0}};
    end
    else if(data_req & data_we & data_gnt) begin
        wdata_reg <= data_wdata;
    end
end

assign ahb_hwdata = wdata_reg;
//assign ahb_hsize = (data_be == 4'b1111) ? 3'd2 :
//                   ((data_be == 4'b0011) | (data_be == 4'b1100)) ? 3'd1 : 3'd0;
assign ahb_hsize = (data_be_mux == 4'b1111) ? 3'd2 :
                   ((data_be_mux == 4'b0011) | (data_be_mux == 4'b1100)) ? 3'd1 : 3'd0;
assign ahb_haddr = (cs == ADDR_PH) ? addr_reg : data_addr;
assign ahb_htrans = (data_req | cs == ADDR_PH)? 2'h2 : 2'h0;
assign ahb_hsel   = ahb_htrans[1];
assign ahb_hburst = 3'd0;
assign ahb_hmastlock = 1'b0;
assign ahb_hprot = 4'd0;
assign ahb_hwrite = (~(cs==ADDR_PH) & data_we) | ((cs==ADDR_PH) & data_we_reg);
assign ahb_hready = ahb_hreadyout;

//assign data_gnt = ((cs == ADDR_PH) | (cs == DATA_PH)) ? ahb_hreadyout : 1'b1;
assign data_gnt = (cs == IDLE) | ((cs == DATA_PH) & ahb_hreadyout);
assign data_rdata = ahb_hrdata;
assign data_rvalid = (cs == DATA_PH) & ahb_hreadyout ;
//==============================================================================

endmodule// core2ahb.v
