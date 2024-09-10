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
module req_register(/*AUTOARG*/
   // Outputs
   haddr_out, htrans_out, hwrite_out, hsize_out, hburst_out,
   hprot_out, hresp_out, hready_out, data_gnt, master_sel,
   // Inputs
   hclk, hresetn, hsel, haddr, htrans, hwrite, hsize, hburst, hprot,
   hready, gnt, hready_out_from_slave, hresp_from_slave
   );
//****************************************************************************
//Parameter Declaration.
//****************************************************************************
parameter  SEQ       = 2'b11;
parameter  NON_SEQ   = 2'b10;
parameter  IDLE      = 2'b00;
parameter  BUSY      = 2'b01;

parameter  OKAY      = 2'b00; 
parameter  ERROR     = 2'b01;
parameter  RETRY     = 2'b10;
parameter  SPLIT     = 2'b11;

parameter  SLAVE0_START_ADDR  = 32'h0000_0000;
parameter  SLAVE0_END_ADDR    = 32'h007f_ffff;
parameter  SLAVE1_START_ADDR  = 32'h2000_0000;
parameter  SLAVE1_END_ADDR    = 32'h2010_ffff;
parameter  SLAVE2_START_ADDR  = 32'h3000_0000;
parameter  SLAVE2_END_ADDR    = 32'h3010_ffff;
parameter  SLAVE3_START_ADDR  = 32'h40000000;
parameter  SLAVE3_END_ADDR    = 32'h4010ffff;
parameter  SLAVE4_START_ADDR  = 32'h5000_2000;
parameter  SLAVE4_END_ADDR    = 32'h5010ffff;

//****************************************************************************
//Port Declaration.
//****************************************************************************
/*AUTOINPUT*/
/*AUTOOUTPUT*/
input                hclk;
input                hresetn;
input                hsel;
input  [31:0]        haddr;
input  [1 :0]        htrans;
input                hwrite;
input  [2 :0]        hsize;
input  [2 :0]        hburst;
input  [3 :0]        hprot;
input                hready;
input  [4 :0]        gnt;
input                hready_out_from_slave;
input  [1 :0]        hresp_from_slave;

output [31:0]        haddr_out;
output [1 :0]        htrans_out;
output               hwrite_out;
output [2 :0]        hsize_out;
output [2 :0]        hburst_out;
output [3 :0]        hprot_out;
output [1 :0]        hresp_out;
output               hready_out;
output [4 :0]        data_gnt;
output [4: 0]        master_sel;
//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
/*AUTOREG*/
reg    [31:0]        haddr_out;
reg    [1 :0]        htrans_out;
reg                  hwrite_out;
reg    [2 :0]        hsize_out;
reg    [2 :0]        hburst_out;
reg    [3 :0]        hprot_out;
reg    [1 :0]        hresp_out;
reg                  hready_out;
reg                  hsel_out;
reg    [31:0]        haddr_r;
reg    [1 :0]        htrans_r;
reg                  hwrite_r;
reg    [2 :0]        hsize_r;
reg    [2 :0]        hburst_r;
reg    [3 :0]        hprot_r;
reg                  hsel_r;
//reg                  hready_r;
//reg                  hready_in;
reg                  seq_or_non_seq_tr;
reg                  store_tran;
reg    [4 :0]        data_gnt;
wire   [4 :0]        master_sel;
wire                 new_tran;
wire                 addr_phase;
wire                 seq_tran;
wire                 bus_new_tran;
wire                 stored_new_tran;
wire                 back2back;

//****************************************************************************
//Function Declaration.
//****************************************************************************
assign stored_new_tran = store_tran && (hsel_out  && (htrans_out == NON_SEQ));
assign bus_new_tran    = (hsel && hready && (htrans == NON_SEQ));
assign seq_tran        = (hsel && ((htrans == SEQ) || (htrans == BUSY))); 
assign back2back       = seq_or_non_seq_tr && bus_new_tran;
assign addr_phase      = hsel_out &&  (htrans_out != IDLE) && (htrans_out != BUSY);

assign master_sel[0]   = (bus_new_tran || (stored_new_tran && ~gnt[0]) || (seq_tran && gnt[0])) && (haddr_out >=  SLAVE0_START_ADDR) && (haddr_out <= SLAVE0_END_ADDR);
assign master_sel[1]   = (bus_new_tran || (stored_new_tran && ~gnt[1]) || (seq_tran && gnt[1])) && (haddr_out >=  SLAVE1_START_ADDR) && (haddr_out <= SLAVE1_END_ADDR);
assign master_sel[2]   = (bus_new_tran || (stored_new_tran && ~gnt[2]) || (seq_tran && gnt[2])) && (haddr_out >=  SLAVE2_START_ADDR) && (haddr_out <= SLAVE2_END_ADDR);
assign master_sel[3]   = (bus_new_tran || (stored_new_tran && ~gnt[3]) || (seq_tran && gnt[3])) && (haddr_out >=  SLAVE3_START_ADDR) && (haddr_out <= SLAVE3_END_ADDR);
assign master_sel[4]   = (bus_new_tran || (stored_new_tran && ~gnt[4]) || (seq_tran && gnt[4])) && (haddr_out >=  SLAVE4_START_ADDR) && (haddr_out <= SLAVE4_END_ADDR);

always @(posedge hclk or negedge hresetn) begin
    if (~hresetn) begin
        seq_or_non_seq_tr <= 1'b0;
    end    
    else if ((seq_tran && hready) || bus_new_tran) begin
        seq_or_non_seq_tr <=  1'b1;
    end    
    else begin 
        seq_or_non_seq_tr <= 1'b0;
    end    
end

always @(posedge hclk or negedge hresetn) begin
    if (~hresetn) begin
        store_tran <= 1'b0;
    end    
    else begin
        if (bus_new_tran && ( ~|gnt || back2back)) begin
            store_tran <= 1'b1;
        end    
        else if (store_tran && |gnt && hready_out_from_slave) begin
            store_tran <= 1'b0;
        end
    end    
end

always @(posedge hclk or negedge hresetn) begin
    if (~hresetn) begin
        hsel_r            <= 1'b0;
        haddr_r           <= 32'b0;
        htrans_r          <= 2'b0;
        hwrite_r          <= 1'b0;
        hsize_r           <= 1'b0;
        hburst_r          <= 3'b0;
        hprot_r           <= 4'b0;
        //hready_r          <= 1'b1;
    end
    else if (bus_new_tran) begin
        hsel_r            <= hsel;
        haddr_r           <= haddr;
        htrans_r          <= htrans;
        hwrite_r          <= hwrite;
        hsize_r           <= hsize;
        hburst_r          <= hburst;
        hprot_r           <= hprot;
        //hready_r          <= hready;
    end
end

always @( * ) begin
    if(store_tran) begin
        hsel_out          = hsel_r;
        haddr_out         = haddr_r;
        htrans_out        = htrans_r;
        hwrite_out        = hwrite_r;
        hsize_out         = hsize_r;
        hburst_out        = hburst_r;
        hprot_out         = hprot_r;
        //hready_in         = hready_r;
    end
    else if(back2back) begin
        hsel_out          = 1'b0; 
        haddr_out         = haddr;
        htrans_out        = IDLE;
        hwrite_out        = hwrite;
        hsize_out         = hsize;
        hburst_out        = hburst;
        hprot_out         = hprot;
        //hready_in         = hready;
    end
    else begin
        hsel_out          = hsel; 
        haddr_out         = haddr;
        htrans_out        = htrans;
        hwrite_out        = hwrite;
        hsize_out         = hsize;
        hburst_out        = hburst;
        hprot_out         = hprot;
        //hready_in         = hready;
    end
end

always @( * ) begin
      hresp_out           =  OKAY;
      hready_out          = 1'b1;
    if (store_tran) begin
      hresp_out           = OKAY;
      hready_out          = 1'b0;
    end
    else if (|data_gnt) begin
      hresp_out           = hresp_from_slave;
      hready_out          = hready_out_from_slave;
    end
    else if (~store_tran && ~|gnt) begin
      hresp_out           = OKAY;
      hready_out          = 1'b1;
    end
end 

always @ (posedge hclk or negedge hresetn) begin
    if (~hresetn) begin
        data_gnt          <= 5'b0;
    end    
    else if (addr_phase && |gnt && hready_out_from_slave) begin
        data_gnt          <= gnt;
    end    
    else if (hready_out_from_slave) begin
        data_gnt          <= 5'b0;
    end    
end    

endmodule
