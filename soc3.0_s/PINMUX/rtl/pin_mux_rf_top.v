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
//* Generated Time   :2022-11-20
//* Modified Time    : 
//* Functions        : 
//****************************************************************************
module pin_mux_rf_top(/*AUTOARG*/
   //apb interface
   pclock,
   preset_n,
   paddr,
   pwdata,
   pwrite,
   psel,
   penable,
   prdata,
   //io reuse register.  
   r_io_reuse_pad1, 
   r_io_reuse_pad10,
   r_io_reuse_pad11,
   r_io_reuse_pad12,
   r_io_reuse_pad13,
   r_io_reuse_pad14,
   r_io_reuse_pad15,
   r_io_reuse_pad16,
   r_io_reuse_pad17,
   r_io_reuse_pad18,
   r_io_reuse_pad19,
   r_io_reuse_pad2, 
   r_io_reuse_pad20,
   r_io_reuse_pad3, 
   r_io_reuse_pad4, 
   r_io_reuse_pad5, 
   r_io_reuse_pad6, 
   r_io_reuse_pad7, 
   r_io_reuse_pad8, 
   r_io_reuse_pad9 
   );
//****************************************************************************
//Port Declaration.
//****************************************************************************
input                   pclock;
input                   preset_n;
input [15:0]            paddr;
input [7 :0]            pwdata;
input                   pwrite;
input                   psel;
input                   penable;
output[7 :0]            prdata;             

output [2:0]            r_io_reuse_pad1;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad10;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad11;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad12;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad13;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad14;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad15;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad16;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad17;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad18;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad19;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad2;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad20;       // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad3;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad4;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad5;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad6;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad7;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad8;        // From pin_mux_rf_inst of pin_mux_rf.v
output [2:0]            r_io_reuse_pad9;        // From pin_mux_rf_inst of pin_mux_rf.v
//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [2:0]              r_io_reuse_pad1;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad10;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad11;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad12;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad13;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad14;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad15;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad16;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad17;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad18;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad19;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad2;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad20;       // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad3;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad4;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad5;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad6;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad7;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad8;        // From pin_mux_rf_inst of pin_mux_rf.v
wire [2:0]              r_io_reuse_pad9;        // From pin_mux_rf_inst of pin_mux_rf.v
// End of automatics
wire                    pclock;
wire                    preset_n;
wire  [15:0]            paddr;
wire  [7 :0]            pwdata;
wire                    pwrite;
wire                    psel;
wire                    penable;
wire  [7 :0]            prdata; 

wire  [15:0]            sft_adr_i;                   
wire  [7:0]             sft_dat_i;                   
wire                    sft_wr_i;                   
wire                    sft_rd_i;                   
wire  [7:0]             sft_dat_o;  
/*AUTOREG*/
//****************************************************************************
//APB to general interface Declaration.
//****************************************************************************
assign     prdata      = sft_dat_o;
assign     clk         = pclock;  
assign     rst_n       = preset_n; 
assign     sft_adr_i   = paddr[15:0];
assign     sft_dat_i   = pwdata[7:0];
assign     sft_wr_i    = psel && penable && pwrite;
assign     sft_rd_i    = psel && penable && (!pwrite);
//****************************************************************************
//Instance Declaration.
//****************************************************************************
pin_mux_rf pin_mux_rf_inst(/*AUTOINST*/
                           // Outputs
                           .r_io_reuse_pad2     (r_io_reuse_pad2[2:0]),
                           .r_io_reuse_pad1     (r_io_reuse_pad1[2:0]),
                           .r_io_reuse_pad4     (r_io_reuse_pad4[2:0]),
                           .r_io_reuse_pad3     (r_io_reuse_pad3[2:0]),
                           .r_io_reuse_pad6     (r_io_reuse_pad6[2:0]),
                           .r_io_reuse_pad5     (r_io_reuse_pad5[2:0]),
                           .r_io_reuse_pad8     (r_io_reuse_pad8[2:0]),
                           .r_io_reuse_pad7     (r_io_reuse_pad7[2:0]),
                           .r_io_reuse_pad10    (r_io_reuse_pad10[2:0]),
                           .r_io_reuse_pad9     (r_io_reuse_pad9[2:0]),
                           .r_io_reuse_pad12    (r_io_reuse_pad12[2:0]),
                           .r_io_reuse_pad11    (r_io_reuse_pad11[2:0]),
                           .r_io_reuse_pad14    (r_io_reuse_pad14[2:0]),
                           .r_io_reuse_pad13    (r_io_reuse_pad13[2:0]),
                           .r_io_reuse_pad16    (r_io_reuse_pad16[2:0]),
                           .r_io_reuse_pad15    (r_io_reuse_pad15[2:0]),
                           .r_io_reuse_pad18    (r_io_reuse_pad18[2:0]),
                           .r_io_reuse_pad17    (r_io_reuse_pad17[2:0]),
                           .r_io_reuse_pad20    (r_io_reuse_pad20[2:0]),
                           .r_io_reuse_pad19    (r_io_reuse_pad19[2:0]),
                           .sft_rd_cs           (),
                           .sft_dat_o           (sft_dat_o[7:0]),
                           // Inputs
                           .clk                 (clk),
                           .rst_n               (rst_n),
                           .sft_adr_i           (sft_adr_i[15:0]),
                           .sft_dat_i           (sft_dat_i[7:0]),
                           .sft_wr_i            (sft_wr_i),
                           .sft_rd_i            (sft_rd_i));

endmodule