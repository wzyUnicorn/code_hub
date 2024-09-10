//**********************************************
//  File Name: dma_int_control.v
//  Author   : hubing
//  Function : interrupt controller
// *********************************************
`include   "dma_defs.v" 

module dma_int_control(
  input             hclk         ,
  input             n_hreset     ,
  input             mask_en_sel  ,             
  input             mask_dis_sel ,          
  input             int_sel      ,               
  //input    [31:0] write_data   ,
  input      [ 7:0] write_data   ,
  //input    [ 3:0] ahb_byte     ,          
  input             ahb_byte     ,            
// dma status inputs
  input             ch0_complete ,
  input             ch0_abort    ,
`ifdef one_channel
`else
  input             ch1_complete ,
  input             ch1_abort    ,
`ifdef two_channel
`else
  input             ch2_complete ,
  input             ch2_abort    , 
`ifdef three_channel
`else
  input             ch3_complete ,
  input             ch3_abort    , 
`endif
`endif
`endif
// register outputs
`ifdef one_channel
  output reg  [1:0] int_mask     ,
  output reg  [1:0] int_status   ,
`else
`ifdef two_channel
  output reg  [3:0] int_mask     ,
  output reg  [3:0] int_status   ,
`else
`ifdef three_channel
  output reg  [5:0] int_mask     ,
  output reg  [5:0] int_status   ,
`else
  output reg  [7:0] int_mask     ,
  output reg  [7:0] int_status   , //update
`endif
`endif
`endif
output reg          dma_int
);

//***********************************************
// reg wire declaration
//**********************************************
reg     reg_ch3_complete;
reg     reg_ch2_complete;
reg     reg_ch1_complete;
reg     reg_ch0_complete;
reg     reg_ch3_abort   ;
reg     reg_ch2_abort   ;
reg     reg_ch1_abort   ;
reg     reg_ch0_abort   ;
//**********************************************
// Main code
//**********************************************
// This module implements a mask and a status register.  The mask is a register
// triplet and the status register is read clear - with all status bits being 
// triggered (do not need to perform anti-metastability as status signals
// are generated synchronously

always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)begin
`ifdef one_channel 
        int_mask <= 2'b0;
`else
`ifdef two_channel
	      int_mask <= 4'b0;
`else
`ifdef three_channel
	      int_mask <= 6'b0;
`else
	      int_mask <= 8'b0;
`endif
`endif
`endif
    end
    else begin
        //if (ahb_byte[0]) // only bottom byte ever used(unless more 
        if (ahb_byte)      // only bottom byte ever used(unless more 
                           // channel/interrupts added)
        begin
            if (mask_en_sel)
`ifdef one_channel
                int_mask <= int_mask | write_data[1:0];
            else if (mask_dis_sel)
                int_mask <= int_mask & ~write_data[1:0];
`else
`ifdef two_channel
                int_mask <= int_mask | write_data[3:0];
            else if (mask_dis_sel)
                int_mask <= int_mask & ~write_data[3:0];
`else
`ifdef three_channel
                int_mask <= int_mask | write_data[5:0];
            else if (mask_dis_sel)
                int_mask <= int_mask & ~write_data[5:0];
`else
                int_mask <= int_mask | write_data[7:0];
            else if (mask_dis_sel)
                int_mask <= int_mask & ~write_data[7:0];
`endif
`endif
`endif
        end
    end
end

// all status inputs are pulses therefore no edge detection is required
// the inputs are registered and cleared when a read occurs.

always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)begin
        reg_ch0_complete <= 1'b0;
        reg_ch0_abort    <= 1'b0;
    end
    else begin
        if (ch0_complete)
            reg_ch0_complete <= 1'b1;
        else if (int_sel & write_data[0] & ahb_byte)
            reg_ch0_complete <= 1'b0;

        if (ch0_abort)
            reg_ch0_abort <= 1'b1;
        else if (int_sel & write_data[1] & ahb_byte)
            reg_ch0_abort <= 1'b0;
    end
end

`ifdef one_channel
`else
always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)begin
        reg_ch1_complete <= 1'b0;
        reg_ch1_abort    <= 1'b0;
    end
    else begin
        if (ch1_complete)
            reg_ch1_complete <= 1'b1;
        else if (int_sel & write_data[2] & ahb_byte)
            reg_ch1_complete <= 1'b0;

        if (ch1_abort)
            reg_ch1_abort <= 1'b1;
        else if (int_sel & write_data[3] & ahb_byte)
            reg_ch1_abort <= 1'b0;
    end
end

`ifdef two_channel
`else
always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)begin
        reg_ch2_complete <= 1'b0;
        reg_ch2_abort    <= 1'b0;  
    end
    else begin
        if (ch2_complete)
            reg_ch2_complete <= 1'b1;
        else if (int_sel & write_data[4] & ahb_byte)
            reg_ch2_complete <= 1'b0;

        if (ch2_abort)
            reg_ch2_abort <= 1'b1;
        else if (int_sel & write_data[5] & ahb_byte)
            reg_ch2_abort <= 1'b0;
    end
end

`ifdef three_channel
`else
always @(posedge hclk or negedge n_hreset)begin
    if (~n_hreset)begin
        reg_ch3_complete <= 1'b0;
        reg_ch3_abort    <= 1'b0;  
    end
    else begin
        if (ch3_complete)
            reg_ch3_complete <= 1'b1;
        else if (int_sel & write_data[6] & ahb_byte)
            reg_ch3_complete <= 1'b0;

        if (ch3_abort)
            reg_ch3_abort <= 1'b1;
        else if (int_sel & write_data[7] & ahb_byte)
            reg_ch3_abort <= 1'b0;
    end
end
`endif
`endif
`endif

// build int_status register
always @(*)begin
`ifdef one_channel
    int_status = {reg_ch0_abort, reg_ch0_complete};
`elsif two_channel
    int_status = {reg_ch1_abort, reg_ch1_complete,
                  reg_ch0_abort, reg_ch0_complete};
`elsif three_channel
    int_status = {reg_ch2_abort, reg_ch2_complete,
                  reg_ch1_abort, reg_ch1_complete,
                  reg_ch0_abort, reg_ch0_complete};
`else
    int_status = {reg_ch3_abort, reg_ch3_complete,
                  reg_ch2_abort, reg_ch2_complete,
                  reg_ch1_abort, reg_ch1_complete,
                  reg_ch0_abort, reg_ch0_complete};
`endif
end

// generate dma_int
// should be set if both the appropriate mask and status bits are set of any interrupt
always @(int_status or int_mask)begin
    dma_int = |(int_mask & int_status);
end

endmodule
