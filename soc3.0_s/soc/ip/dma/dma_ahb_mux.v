//**********************************************
//  File Name: dma.v
//  Author   : hubing
//  Function : DMA Top Level
// *********************************************
`include "dma_defs.v"

module dma_ahb_mux(
  input             hclk          ,
  input             n_hreset      ,
  input             hready_in     ,
  output reg [31:0] haddr         ,
  output reg  [1:0] htrans        ,
  output reg        hwrite        ,
  output reg  [2:0] hsize         ,
  output reg  [2:0] hburst        ,
  output reg  [3:0] hprot         ,
  output reg [31:0] hwdata        ,
  input      [31:0] hrdata        ,
  //input           addr_drive;
  //input           data_drive;
  input             ch0_ahb_grant ,
  input      [31:0] ch0_haddr     ,
  input       [1:0] ch0_htrans    ,
  input             ch0_hwrite    ,
  input       [2:0] ch0_hsize     ,
  input       [2:0] ch0_hburst    ,
  input       [3:0] ch0_hprot     ,
  input      [31:0] ch0_hwdata    ,
  output reg [31:0] ch0_hrdata    ,
`ifdef one_channel
`else
  input             ch1_ahb_grant ,
  input      [31:0] ch1_haddr     ,
  input       [1:0] ch1_htrans    ,
  input             ch1_hwrite    ,
  input       [2:0] ch1_hsize     ,
  input       [2:0] ch1_hburst    ,
  input       [3:0] ch1_hprot     ,
  input      [31:0] ch1_hwdata    ,
  output reg [31:0] ch1_hrdata    ,
`ifdef two_channel
`else
  input             ch2_ahb_grant ,
  input      [31:0] ch2_haddr     ,
  input       [1:0] ch2_htrans    ,
  input             ch2_hwrite    ,
  input       [2:0] ch2_hsize     ,
  input       [2:0] ch2_hburst    ,
  input       [3:0] ch2_hprot     ,
  input      [31:0] ch2_hwdata    ,
  output reg [31:0] ch2_hrdata    ,
`ifdef three_channel
`else
  input             ch3_ahb_grant ,
  input      [31:0] ch3_haddr     ,
  input       [1:0] ch3_htrans    ,
  input             ch3_hwrite    ,
  input       [2:0] ch3_hsize     ,
  input       [2:0] ch3_hburst    ,
  input       [3:0] ch3_hprot     ,
  input      [31:0] ch3_hwdata    ,
  output reg [31:0] ch3_hrdata
`endif
`endif
`endif
);
//**********************************************
// reg wire declaration
//**********************************************
  reg     [3:0] channel_addr;
  reg     [3:0] channel_addr_data;

//**********************************************
// Main code
//**********************************************
always @(*)begin
`ifdef one_channel
    channel_addr = {3'b000, ch0_ahb_grant};
`elsif two_channel
    channel_addr = {2'b00, ch1_ahb_grant, ch0_ahb_grant};
`elsif three_channel
    channel_addr = {1'b0, ch2_ahb_grant, ch1_ahb_grant, ch0_ahb_grant};
`else
    channel_addr = {ch3_ahb_grant, ch2_ahb_grant, ch1_ahb_grant, ch0_ahb_grant};
`endif
end

always @(*)begin
    case (channel_addr)
        `ch0_selected :begin
            haddr  = ch0_haddr ;
            htrans = ch0_htrans;
            hwrite = ch0_hwrite;
            hsize  = ch0_hsize ;
            hburst = ch0_hburst;
            hprot  = ch0_hprot ;
        end
`ifdef one_channel
`else
        `ch1_selected :begin
            haddr  = ch1_haddr ;
            htrans = ch1_htrans;
            hwrite = ch1_hwrite;
            hsize  = ch1_hsize ;
            hburst = ch1_hburst;
            hprot  = ch1_hprot ;
        end
    `ifdef two_channel
    `else
        `ch2_selected :begin
            haddr  = ch2_haddr ;
            htrans = ch2_htrans;
            hwrite = ch2_hwrite;
            hsize  = ch2_hsize ;
            hburst = ch2_hburst;
            hprot  = ch2_hprot ;
        end    
        `ifdef three_channel
        `else
        `ch3_selected :begin
            haddr  = ch3_haddr ;
            htrans = ch3_htrans;
            hwrite = ch3_hwrite;
            hsize  = ch3_hsize ;
            hburst = ch3_hburst;
            hprot  = ch3_hprot ;
        end    
        `endif
    `endif
`endif
        default :begin
            haddr  = 32'h0;
            htrans =  2'b0;
            hwrite =  1'b0;
            hsize  =  3'b0;
            hburst =  3'b0;
            hprot  =  4'b0;
        end
    endcase
end

// Register channel_addr to control the data
always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)
        channel_addr_data <= 4'b0;
    else if (hready_in)
        channel_addr_data <= channel_addr;
end

// Data mux - use channel data as selector
always @(*)begin
    case (channel_addr_data)
        `ch0_selected :
            hwdata = ch0_hwdata;
`ifdef one_channel
`else
        `ch1_selected :
            hwdata = ch1_hwdata;
    `ifdef two_channel
    `else
        `ch2_selected :
            hwdata = ch2_hwdata;
        `ifdef three_channel
        `else
        `ch3_selected :
            hwdata = ch3_hwdata;
        `endif
    `endif
`endif
        default :
            hwdata = 32'h00000000;
    endcase
end

// read data is just sent to each channel
always @(*)begin
    ch0_hrdata = hrdata;
`ifdef one_channel
`else
    ch1_hrdata = hrdata;
    `ifdef two_channel
    `else
    ch2_hrdata = hrdata;
        `ifdef three_channel
        `else
    ch3_hrdata = hrdata;
        `endif
    `endif
`endif
end

endmodule
