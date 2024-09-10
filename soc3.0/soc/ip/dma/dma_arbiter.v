//**********************************************
//  File Name: dma_rx_sm.v
//  Author   : hubing
//  Function : channel arbiter
// *********************************************
`include   "dma_defs.v"             // DMA defines

module dma_slave_arbiter(
input         hclk          ,
input         n_hreset      ,
input         hgrant        ,
input         hready        ,
input         ch0_ahb_req   ,
output        ch0_ahb_grant ,
`ifdef one_channel
`else
input         ch1_ahb_req   ,
output        ch1_ahb_grant ,
    `ifdef two_channel
    `else
input         ch2_ahb_req   ,
output        ch2_ahb_grant ,
        `ifdef three_channel
        `else
input         ch3_ahb_req   ,
output        ch3_ahb_grant
        `endif
    `endif
`endif
);

//**********************************************
// reg wire declaration
//**********************************************
reg     [1:0] current_apb_state ;
reg     [1:0] next_apb_state    ;
reg     [3:0] current_ahb_state ;
reg     [3:0] next_ahb_state    ;
reg           hready_ff1        ;

//**********************************************
// Main code
//**********************************************
// AHB arbitration logic
always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)
        hready_ff1 <= 1'b0;
    else
        hready_ff1 <= hready;
end

wire grant_hb = hready & ~hready_ff1;

always @(*)begin
    next_ahb_state = current_ahb_state;
    case (current_ahb_state)
        `ch0_check :
            if (ch0_ahb_req)
                next_ahb_state = `ch0_reqst;
            else
                next_ahb_state = `ch1_check;
        `ch0_reqst :
            if (grant_hb)
                next_ahb_state = `ch1_check;
        `ch1_check :
            if (ch1_ahb_req)
                next_ahb_state = `ch1_reqst;
            else
                next_ahb_state = `ch2_check;
        `ch1_reqst :
            if (grant_hb)
                next_ahb_state = `ch2_check;
        `ch2_check :
            if (ch2_ahb_req)
                next_ahb_state = `ch2_reqst;
            else
                next_ahb_state = `ch0_check;
        `ch2_reqst :
            if (grant_hb)
                next_ahb_state = `ch0_check;
        default :
            next_ahb_state = `ch0_check;
    endcase
end

always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)
        current_ahb_state <= `ch0_check;
    else
        current_ahb_state <= next_ahb_state;
end

assign ch0_ahb_grant= (current_ahb_state == `ch0_reqst);
assign ch1_ahb_grant= (current_ahb_state == `ch1_reqst);
assign ch2_ahb_grant= (current_ahb_state == `ch2_reqst);
assign ch3_ahb_grant= 0;
endmodule
