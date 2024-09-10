//**********************************************
//  File Name: dma.v
//  Author   : hubing
//  Function : AHB bus interface
// *********************************************
`include   "dma_defs.v"             // DMA defines

module dma_ahb_csr(
  input         hclk            ,
  input         n_hreset        ,
  input  [19:0] haddr           ,
  input         hsel            ,
  input   [1:0] htrans          ,
  input         hwrite          ,
  input   [2:0] hsize           ,
  input  [31:0] hwdata          ,
  input         hready_in       ,
  
  input  [31:0] dma_tadd_ch0    ,        
  input  [31:0] dma_sadd_ch0    ,        
  input  [31:0] dma_xfer_ch0    ,        
  input  [31:0] dma_flow_ch0    ,        
  input  [31:0] taddr_ch0       ,
  input  [31:0] saddr_ch0       ,

  output reg    hready_out      ,
  output reg [ 1:0] hresp       ,
  output reg [31:0] hrdata      ,
  output reg [31:0] write_data  ,
  output reg [ 3:0] ahb_byte    ,

  output reg    ch0_taddr_sel   ,
  output reg    ch0_saddr_sel   ,
  output reg    ch0_trans_sel   ,
  output reg    ch0_flow_sel    ,
  output reg    ch0_abort_sel   ,

`ifdef one_channel
  input   [1:0] int_status      ,   
  input   [1:0] int_mask        ,    
`else
  input  [31:0] dma_tadd_ch1    ,        
  input  [31:0] dma_sadd_ch1    ,        
  input  [31:0] dma_xfer_ch1    ,        
  input  [31:0] dma_flow_ch1    ,        
  input  [31:0] taddr_ch1       ,
  input  [31:0] saddr_ch1       ,
  output reg    ch1_taddr_sel   ,
  output reg    ch1_saddr_sel   ,
  output reg    ch1_trans_sel   ,
  output reg    ch1_flow_sel    ,
  output reg    ch1_abort_sel   ,
`ifdef two_channel
  input   [3:0] int_status      ,  
  input   [3:0] int_mask        ,    
`else
  input  [31:0] dma_tadd_ch2    ,        
  input  [31:0] dma_sadd_ch2    ,        
  input  [31:0] dma_xfer_ch2    ,        
  input  [31:0] dma_flow_ch2    ,        
  input  [31:0] taddr_ch2       ,
  input  [31:0] saddr_ch2       ,
  output reg    ch2_taddr_sel   ,
  output reg    ch2_saddr_sel   ,
  output reg    ch2_trans_sel   ,
  output reg    ch2_flow_sel    ,
  output reg    ch2_abort_sel   ,
`ifdef three_channel
  input   [5:0] int_status      ,  
  input   [5:0] int_mask        ,    
`else
  input  [31:0] dma_tadd_ch3    ,        
  input  [31:0] dma_sadd_ch3    ,        
  input  [31:0] dma_xfer_ch3    ,        
  input  [31:0] dma_flow_ch3    ,        
  input  [31:0] taddr_ch3       ,
  input  [31:0] saddr_ch3       ,
  output reg    ch3_taddr_sel   ,
  output reg    ch3_saddr_sel   ,
  output reg    ch3_trans_sel   ,
  output reg    ch3_flow_sel    ,
  output reg    ch3_abort_sel   ,
  input   [7:0] int_status      ,  
  input   [7:0] int_mask        ,    
`endif
`endif
`endif
  output reg    mask_en_sel     , 
  output reg    mask_dis_sel    ,
  output reg    int_sel
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
        hresp   <= `rsp_okay;
        r_hresp <= 0;
    end
    else if ((htrans == `trn_idle) & hready_in)begin
        hresp   <= `rsp_okay;
        r_hresp <= 0;
    end
    else if (mis_err)begin
        hresp   <= `rsp_error;
        r_hresp <= 1;
    end
    else if (r_hresp == 1'b1)begin
        hresp   <= `rsp_error;
        r_hresp <= 0;
    end
    else begin
        hresp <= `rsp_okay;
        r_hresp <= 0;
    end
end

// ahb ready signal
always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)
        hready_out <= 1'b1;
    else if ((((htrans == `trn_idle) | (htrans == `trn_busy)) & hsel & hready_in & ~mis_err) 
                | r_hresp | ~hsel )
        hready_out <= 1'b1;
    else if (valid == 1'b1) //assumes accesses will always complete with zero wait states
        hready_out <= 1'b1;
    else
        hready_out <= 1'b0;
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

//==============
// CH0 registers
//==============

always @(*)begin
    ch0_taddr_sel = 1'b0;
    ch0_saddr_sel = 1'b0;
    ch0_trans_sel = 1'b0;
    ch0_abort_sel = 1'b0;
    if (n_read & access_valid)
        case ({addr[15:2], 2'b00})
            `ch0_taddr :
                ch0_taddr_sel = 1'b1;
            `ch0_saddr :
                ch0_saddr_sel = 1'b1;
            `ch0_trans :begin
                ch0_trans_sel = 1'b1;
                if (write_data[17] & ahb_byte[2])
                    ch0_abort_sel = 1'b1;
            end
            default: begin
                ch0_taddr_sel = 1'b0;
                ch0_saddr_sel = 1'b0;
                ch0_trans_sel = 1'b0;
                ch0_abort_sel = 1'b0;
            end
        endcase
end

`ifdef one_channel
`else
//==============
// ch1 registers
//==============

always @(*)begin
    ch1_taddr_sel = 1'b0;
    ch1_saddr_sel = 1'b0;
    ch1_trans_sel = 1'b0;
    ch1_abort_sel = 1'b0;
    if (n_read & access_valid)
        case ({addr[15:2], 2'b00})
            `ch1_taddr :
                ch1_taddr_sel = 1'b1;
            `ch1_saddr :
                ch1_saddr_sel = 1'b1;
            `ch1_trans :begin
                ch1_trans_sel = 1'b1;
                if (write_data[17] & ahb_byte[2])
                    ch1_abort_sel = 1'b1;
            end
            default begin
                ch1_taddr_sel = 1'b0;
                ch1_saddr_sel = 1'b0;
                ch1_trans_sel = 1'b0;
                ch1_abort_sel = 1'b0;
            end
        endcase
end

`ifdef two_channel
`else
//==============
// ch2 registers
//==============

always @(*)begin
    ch2_taddr_sel = 1'b0;
    ch2_saddr_sel = 1'b0;
    ch2_trans_sel = 1'b0;
    ch2_abort_sel = 1'b0;
    if (n_read & access_valid)
        case ({addr[15:2], 2'b00})
            `ch2_taddr :
                ch2_taddr_sel = 1'b1;
            `ch2_saddr :
                ch2_saddr_sel = 1'b1;
            `ch2_trans :begin
                ch2_trans_sel = 1'b1;
                if (write_data[17] & ahb_byte[2])
                    ch2_abort_sel = 1'b1;
            end
            default begin
                ch2_taddr_sel = 1'b0;
                ch2_saddr_sel = 1'b0;
                ch2_trans_sel = 1'b0;
                ch2_abort_sel = 1'b0;
            end
        endcase
end

`ifdef three_channel
`else
//==============
// ch3 registers
//==============

always @(*)begin
    ch3_taddr_sel = 1'b0;
    ch3_saddr_sel = 1'b0;
    ch3_trans_sel = 1'b0;
    ch3_abort_sel = 1'b0;
    if (n_read & access_valid)
        case ({addr[15:2], 2'b00})
            `ch3_taddr :
                ch3_taddr_sel = 1'b1;
            `ch3_saddr :
                ch3_saddr_sel = 1'b1;
            `ch3_trans :begin
                ch3_trans_sel = 1'b1;
                if (write_data[17] & ahb_byte[2])
                    ch3_abort_sel = 1'b1;
            end
            default begin
                ch3_taddr_sel = 1'b0;
                ch3_saddr_sel = 1'b0;
                ch3_trans_sel = 1'b0;
                ch3_abort_sel = 1'b0;
            end
        endcase
end
`endif
`endif
`endif

// Interrupt control registers
always @(*)begin
    mask_en_sel = 1'b0;
    mask_dis_sel = 1'b0;
    int_sel = 1'b0;
    if (n_read & access_valid)
        case ({addr[15:2], 2'b00})
            `int_mask_en :
                mask_en_sel = 1'b1;
            `int_mask_dis :
                mask_dis_sel = 1'b1;
            `int_status :
                int_sel = 1'b1;
            default : begin
                mask_en_sel  = 1'b0;
                mask_dis_sel = 1'b0;
                int_sel      = 1'b0;
            end
        endcase
end

//=============
// read process
//=============
always @(*)begin
    hrdata = 32'h00000000;
    if (access_valid & ~n_read)begin
        case ({addr[15:2], 2'b00})
            `ch0_taddr :
                hrdata = dma_tadd_ch0;
            `ch0_saddr :
                hrdata = dma_sadd_ch0;
            `ch0_trans :
                hrdata = dma_xfer_ch0;
`ifdef one_channel
            `int_status :
                hrdata[1:0] = int_status;
            `int_mask :
                hrdata[1:0] = int_mask;
`else
            `ch1_taddr :
                hrdata = dma_tadd_ch1;
            `ch1_saddr :
                hrdata = dma_sadd_ch1;
            `ch1_trans :
                hrdata = dma_xfer_ch1;
`ifdef two_channel
            `int_status :
                hrdata[3:0] = int_status;
            `int_mask :
                hrdata[3:0] = int_mask;
`else
            `ch2_taddr :
                hrdata = dma_tadd_ch2;
            `ch2_saddr :
                hrdata = dma_sadd_ch2;
            `ch2_trans :
                hrdata = dma_xfer_ch2;
`ifdef three_channel
            `int_status :
                hrdata[5:0] = int_status;
            `int_mask :
                hrdata[5:0] = int_mask;
`else
            `ch3_taddr :
                hrdata = dma_tadd_ch3;
            `ch3_saddr :
                hrdata = dma_sadd_ch3;
            `ch3_trans :
                hrdata = dma_xfer_ch3;
            `int_status :
                hrdata[7:0] = int_status;
            `int_mask :
                hrdata[7:0] = int_mask;
`endif
`endif
`endif
            default :
                hrdata = 32'h00000000;
        endcase
    end
end

endmodule
