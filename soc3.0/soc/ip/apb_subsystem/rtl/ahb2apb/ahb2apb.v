//  ==========================================================================
//
//                          CONFIDENTIAL
//  Copyright (c) 
//  All Rights Reserved.
//
//  ==========================================================================
//****************************************************************************
//* File Name        :
//* Author           : 
//* Version          :1.0
//* Generated Time   :2023-1-31
//* Modified Time    : 
//* Functions        : 
//****************************************************************************
module ahb2apb(/*AUTOARG*/
   // Outputs
   hrdata, hready, hresp, paddr, penable, pwrite, pwdata, psel0,
   psel1, psel2, psel3, psel4, psel5, psel6, psel7, psel8,
   // Inputs
   hclk, hreset_n, hsel, haddr, htrans, hwdata, hwrite, pready0,
   prdata0, pready1, prdata1, pready2, prdata2, pready3, prdata3,
   pready4, prdata4, pready5, prdata5, pready6, prdata6, pready7, 
   prdata7, pready8, prdata8
   );
//****************************************************************************
//Parameter Declaration.
//****************************************************************************
parameter  APB_SLAVE0_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE0_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE1_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE1_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE2_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE2_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE3_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE3_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE4_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE4_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE5_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE5_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE6_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE6_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE7_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE7_END_ADDR    = 32'h00000000;
parameter  APB_SLAVE8_START_ADDR  = 32'h00000000;
parameter  APB_SLAVE8_END_ADDR    = 32'h00000000;

//****************************************************************************
//Port Declaration.
//****************************************************************************
/*AUTOINPUT*/
/*AUTOOUTPUT*/
// AHB signals
input        hclk;
input        hreset_n;
input        hsel;
input [31:0] haddr;
input [1 :0] htrans;
input [31:0] hwdata;
input        hwrite;
output[31:0] hrdata;
output       hready;
output[1 :0] hresp;
// APB signals common to all APB slaves
//input        pclk;
//input        preset_n;
output[31:0] paddr;
output       penable;
output       pwrite;
output[31:0] pwdata;
// Slave 0 signals
output      psel0;
input       pready0;
input[31:0] prdata0;
// Slave 1 signals
output      psel1;
input       pready1;
input[31:0] prdata1;
// Slave 2 signals
output      psel2;
input       pready2;
input[31:0] prdata2;
// Slave 3 signals
output      psel3;
input       pready3;
input[31:0] prdata3;
// Slave 4 signals
output      psel4;
input       pready4;
input[31:0] prdata4;
// Slave 5 signals
output      psel5;
input       pready5;
input[31:0] prdata5;
// Slave 6 signals
output      psel6;
input       pready6;
input[31:0] prdata6;
// Slave 7 signals
output      psel7;
input       pready7;
input[31:0] prdata7;
// Slave 8 signals
output      psel8;
input       pready8;
input[31:0] prdata8;

//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
/*AUTOREG*/
reg  [31:0] hrdata;
reg  [31:0] paddr;
reg         penable;
reg         pwrite;
reg         ahb_addr_phase;
reg         ahb_data_phase;
reg  [31:0] haddr_reg;
reg         hwrite_reg;
reg  [2 :0] apb_state;
reg  [8 :0] slave_select;
reg  [8 :0] psel_vector;
wire        valid_ahb_trans;
wire        pready_muxed;
wire [31:0] prdata_muxed;
wire [2 :0] apb_state_idle;
wire [2 :0] apb_state_setup;
wire [2 :0] apb_state_access;
wire [8 :0] pready_vector;
wire [31:0] prdata0_q;
wire [31:0] prdata1_q;
wire [31:0] prdata2_q;
wire [31:0] prdata3_q;
wire [31:0] prdata4_q;
wire [31:0] prdata5_q;
wire [31:0] prdata6_q;
wire [31:0] prdata7_q;
wire [31:0] prdata8_q;

//****************************************************************************
//Function Declaration.
//****************************************************************************
assign hready           = ahb_addr_phase;
assign pwdata           = hwdata;
assign hresp            = 2'b00;
assign valid_ahb_trans  = ((htrans == 2'b10) || (htrans == 2'b11)) && (hsel == 1'b1);
assign apb_state_idle   = 3'b001;
assign apb_state_setup  = 3'b010;
assign apb_state_access = 3'b100;
assign pready_muxed     = |(psel_vector & pready_vector);
assign prdata_muxed     = prdata0_q  | prdata1_q | prdata2_q | prdata3_q |
                          prdata4_q  | prdata5_q | prdata6_q | prdata7_q |
                          prdata8_q;

assign psel0            = psel_vector[0];
assign pready_vector[0] = pready0;
assign prdata0_q        = (psel0 == 1'b1) ? prdata0 : 'b0;

assign psel1            = psel_vector[1];
assign pready_vector[1] = pready1;
assign prdata1_q        = (psel1 == 1'b1) ? prdata1 : 'b0;

assign psel2            = psel_vector[2];
assign pready_vector[2] = pready2;
assign prdata2_q        = (psel2 == 1'b1) ? prdata2 : 'b0;

assign psel3            = psel_vector[3];
assign pready_vector[3] = pready3;
assign prdata3_q        = (psel3 == 1'b1) ? prdata3 : 'b0;

assign psel4            = psel_vector[4];
assign pready_vector[4] = pready4;
assign prdata4_q        = (psel4 == 1'b1) ? prdata4 : 'b0;

assign psel5            = psel_vector[5];
assign pready_vector[5] = pready5;
assign prdata5_q        = (psel5 == 1'b1) ? prdata5 : 'b0;

assign psel6            = psel_vector[6];
assign pready_vector[6] = pready6;
assign prdata6_q        = (psel6 == 1'b1) ? prdata6 : 'b0;

assign psel7            = psel_vector[7];
assign pready_vector[7] = pready7;
assign prdata7_q        = (psel7 == 1'b1) ? prdata7 : 'b0;

assign psel8            = psel_vector[8];
assign pready_vector[8] = pready8;
assign prdata8_q        = (psel8 == 1'b1) ? prdata8 : 'b0;


always @(posedge hclk) begin
  if (hreset_n == 1'b0) begin
    ahb_addr_phase <= 1'b1;
    ahb_data_phase <= 1'b0;
    haddr_reg      <= 'b0;
    hwrite_reg     <= 1'b0;
    hrdata         <= 'b0;
  end
  else begin
    if (ahb_addr_phase == 1'b1 && valid_ahb_trans == 1'b1) begin
      ahb_addr_phase <= 1'b0;
      ahb_data_phase <= 1'b1;
      haddr_reg      <= haddr;
      hwrite_reg     <= hwrite;
    end
    else if (ahb_data_phase == 1'b1 && pready_muxed == 1'b1 && apb_state == apb_state_access) begin
      ahb_addr_phase <= 1'b1;
      ahb_data_phase <= 1'b0;
      hrdata         <= prdata_muxed;
    end
  end
end

always @(posedge hclk or negedge hreset_n) begin
  if (hreset_n == 1'b0) begin
    apb_state   <= apb_state_idle;
    psel_vector <= 8'b0;
    penable     <= 1'b0;
    paddr       <= 1'b0;
    pwrite      <= 1'b0;
  end  
  else begin
    // IDLE -> SETUP
    if (apb_state == apb_state_idle) begin
      if (ahb_data_phase == 1'b1) begin
        apb_state   <= apb_state_setup;
        psel_vector <= slave_select;
        paddr       <= haddr_reg;
        pwrite      <= hwrite_reg;
      end  
    end
    // SETUP -> TRANSFER
    else if (apb_state == apb_state_setup) begin
      apb_state <= apb_state_access;
      penable   <= 1'b1;
    end
    // TRANSFER -> SETUP or
    // TRANSFER -> IDLE
    else if (apb_state == apb_state_access) begin
      if (pready_muxed == 1'b1) begin
        // TRANSFER -> SETUP
        if (valid_ahb_trans == 1'b1) begin
          apb_state   <= apb_state_setup;
          penable     <= 1'b0;
          psel_vector <= slave_select;
          paddr       <= haddr_reg;
          pwrite      <= hwrite_reg;
        end  
        // TRANSFER -> IDLE
        else begin
          apb_state   <= apb_state_idle;      
          penable     <= 1'b0;
          psel_vector <= 'b0;
        end  
      end
    end
  end
end

always @(posedge hclk or negedge hreset_n) begin
  if (hreset_n == 1'b0)
    slave_select <= 'b0;
  else begin  
     slave_select[0]   <= valid_ahb_trans && (haddr >= APB_SLAVE0_START_ADDR)  && (haddr <= APB_SLAVE0_END_ADDR);
     slave_select[1]   <= valid_ahb_trans && (haddr >= APB_SLAVE1_START_ADDR)  && (haddr <= APB_SLAVE1_END_ADDR);
     slave_select[2]   <= valid_ahb_trans && (haddr >= APB_SLAVE2_START_ADDR)  && (haddr <= APB_SLAVE2_END_ADDR);
     slave_select[3]   <= valid_ahb_trans && (haddr >= APB_SLAVE3_START_ADDR)  && (haddr <= APB_SLAVE3_END_ADDR);
     slave_select[4]   <= valid_ahb_trans && (haddr >= APB_SLAVE4_START_ADDR)  && (haddr <= APB_SLAVE4_END_ADDR);
     slave_select[5]   <= valid_ahb_trans && (haddr >= APB_SLAVE5_START_ADDR)  && (haddr <= APB_SLAVE5_END_ADDR); 
     slave_select[6]   <= valid_ahb_trans && (haddr >= APB_SLAVE6_START_ADDR)  && (haddr <= APB_SLAVE6_END_ADDR); 
     slave_select[7]   <= valid_ahb_trans && (haddr >= APB_SLAVE7_START_ADDR)  && (haddr <= APB_SLAVE7_END_ADDR); 
     slave_select[8]   <= valid_ahb_trans && (haddr >= APB_SLAVE8_START_ADDR)  && (haddr <= APB_SLAVE8_END_ADDR); 
 end
end

endmodule
