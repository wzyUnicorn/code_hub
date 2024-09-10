//  ==========================================================================
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
module pin_mux(/*AUTOARG*/
   // Outputs
   clk_cpu, rst_n_cpu, pclk, prest_n, spi0_sdi0, spi0_sdi1, spi0_sdi2,
   spi0_sdi3, spi1_sdi0, spi1_sdi1, spi1_sdi2, spi1_sdi3, ua_rxd,
   i2c0_scl_pad_i, i2c0_sda_pad_i, i2c1_scl_pad_i, i2c1_sda_pad_i,
   tck_i,tms_i,trst_ni,td_i,
   // Inouts
   pad,
   // Inputs
   spi0_clk, spi0_csn0, spi0_csn1, spi0_csn2, spi0_csn3, spi0_sdo0,
   spi0_sdo1, spi0_sdo2, spi0_sdo3, spi0_oe0, spi0_oe1, spi0_oe2,
   spi0_oe3, spi1_clk, spi1_csn0, spi1_csn1, spi1_csn2, spi1_csn3,
   spi1_sdo0, spi1_sdo1, spi1_sdo2, spi1_sdo3, spi1_oe0, spi1_oe1,
   spi1_oe2, spi1_oe3, ua_txd, pwm_o, i2c0_scl_pad_o, i2c0_scl_padoen_o,
   i2c0_sda_pad_o, i2c0_sda_padoen_o, i2c1_scl_pad_o,
   i2c1_scl_padoen_o, i2c1_sda_pad_o, i2c1_sda_padoen_o,
   td_o,tdo_oe_o,
   r_io_reuse_pad2, r_io_reuse_pad1, r_io_reuse_pad4, r_io_reuse_pad3,
   r_io_reuse_pad6, r_io_reuse_pad5, r_io_reuse_pad8, r_io_reuse_pad7,
   r_io_reuse_pad10, r_io_reuse_pad9, r_io_reuse_pad12,
   r_io_reuse_pad11, r_io_reuse_pad14, r_io_reuse_pad13,
   r_io_reuse_pad16, r_io_reuse_pad15, r_io_reuse_pad18,
   r_io_reuse_pad17, r_io_reuse_pad20, r_io_reuse_pad19
   );    
//****************************************************************************
//Parameter Declaration.
//****************************************************************************     
parameter PAD_NUM = 24;

//****************************************************************************
//Port Declaration.
//****************************************************************************    
output                 clk_cpu;
output                 rst_n_cpu;
output                 pclk;
output                 prest_n;

input                  spi0_clk; 
input                  spi0_csn0;
input                  spi0_csn1;
input                  spi0_csn2;
input                  spi0_csn3;
input                  spi0_sdo0;
input                  spi0_sdo1;
input                  spi0_sdo2;
input                  spi0_sdo3;
input                  spi0_oe0;
input                  spi0_oe1;
input                  spi0_oe2;
input                  spi0_oe3;
output                 spi0_sdi0;
output                 spi0_sdi1;
output                 spi0_sdi2;
output                 spi0_sdi3;

input                  spi1_clk;
input                  spi1_csn0;
input                  spi1_csn1;
input                  spi1_csn2;
input                  spi1_csn3;
input                  spi1_sdo0;
input                  spi1_sdo1;
input                  spi1_sdo2;
input                  spi1_sdo3;
input                  spi1_oe0;
input                  spi1_oe1;
input                  spi1_oe2;
input                  spi1_oe3;
output                 spi1_sdi0;
output                 spi1_sdi1;
output                 spi1_sdi2;
output                 spi1_sdi3;

output                 ua_rxd; 
input                  ua_txd;  

input [3:0]            pwm_o;

output                 i2c0_scl_pad_i;
input                  i2c0_scl_pad_o; 
input                  i2c0_scl_padoen_o; 

output                 i2c0_sda_pad_i; 
input                  i2c0_sda_pad_o; 
input                  i2c0_sda_padoen_o;

output                 i2c1_scl_pad_i;
input                  i2c1_scl_pad_o;
input                  i2c1_scl_padoen_o;

output                 i2c1_sda_pad_i;
input                  i2c1_sda_pad_o;
input                  i2c1_sda_padoen_o;

output                 tck_i;
output                 tms_i;
output                 trst_ni;
output                 td_i;
input                  td_o;
input                  tdo_oe_o;

input    [2:0]         r_io_reuse_pad2;                   
input    [2:0]         r_io_reuse_pad1;                   
input    [2:0]         r_io_reuse_pad4;                   
input    [2:0]         r_io_reuse_pad3;                   
input    [2:0]         r_io_reuse_pad6;                   
input    [2:0]         r_io_reuse_pad5;                   
input    [2:0]         r_io_reuse_pad8;                   
input    [2:0]         r_io_reuse_pad7;                   
input    [2:0]         r_io_reuse_pad10;                   
input    [2:0]         r_io_reuse_pad9;                   
input    [2:0]         r_io_reuse_pad12;                   
input    [2:0]         r_io_reuse_pad11;                   
input    [2:0]         r_io_reuse_pad14;                   
input    [2:0]         r_io_reuse_pad13;                   
input    [2:0]         r_io_reuse_pad16;                   
input    [2:0]         r_io_reuse_pad15;                   
input    [2:0]         r_io_reuse_pad18;                   
input    [2:0]         r_io_reuse_pad17;                   
input    [2:0]         r_io_reuse_pad20;                   
input    [2:0]         r_io_reuse_pad19;                   

inout    [PAD_NUM :1]  pad;
//****************************************************************************
//Signal Declaration.
//****************************************************************************
wire                   spi0_clk; 
wire                   spi0_csn0;
wire                   spi0_csn1;
wire                   spi0_csn2;
wire                   spi0_csn3;
wire                   spi0_sdo0;
wire                   spi0_sdo1;
wire                   spi0_sdo2;
wire                   spi0_sdo3;
wire                   spi0_oe0;
wire                   spi0_oe1;
wire                   spi0_oe2;
wire                   spi0_oe3;
wire                   spi0_sdi0;
wire                   spi0_sdi1;

wire                   spi1_clk;
wire                   spi1_csn0;
wire                   spi1_csn1;
wire                   spi1_csn2;
wire                   spi1_csn3;
wire                   spi1_sdo0;
wire                   spi1_sdo1;
wire                   spi1_sdo2;
wire                   spi1_sdo3;
wire                   spi1_oe0;
wire                   spi1_oe1;
wire                   spi1_oe2;
wire                   spi1_oe3;
wire                   spi1_sdi0;
wire                   spi1_sdi1;

wire                   ua_rxd; 
wire                   ua_txd;  
wire                   i2c0_scl_pad_i;
wire                   i2c0_scl_pad_o; 
wire                   i2c0_scl_padoen_o; 
wire                   i2c0_sda_pad_i; 
wire                   i2c0_sda_pad_o; 
wire                   i2c0_sda_padoen_o;
wire                   i2c1_scl_pad_i;
wire                   i2c1_scl_pad_o;
wire                   i2c1_scl_padoen_o;
wire                   i2c1_sda_pad_i;
wire                   i2c1_sda_pad_o;
wire                   i2c1_sda_padoen_o;
wire     [2:0]         r_io_reuse_pad2;                   
wire     [2:0]         r_io_reuse_pad1;                   
wire     [2:0]         r_io_reuse_pad4;                   
wire     [2:0]         r_io_reuse_pad3;                   
wire     [2:0]         r_io_reuse_pad6;                   
wire     [2:0]         r_io_reuse_pad5;                   
wire     [2:0]         r_io_reuse_pad8;                   
wire     [2:0]         r_io_reuse_pad7;                   
wire     [2:0]         r_io_reuse_pad10;                   
wire     [2:0]         r_io_reuse_pad9;                   
wire     [2:0]         r_io_reuse_pad12;                   
wire     [2:0]         r_io_reuse_pad11;                   
wire     [2:0]         r_io_reuse_pad14;                   
wire     [2:0]         r_io_reuse_pad13;                   
wire     [2:0]         r_io_reuse_pad16;                   
wire     [2:0]         r_io_reuse_pad15;                   
wire     [2:0]         r_io_reuse_pad18;                   
wire     [2:0]         r_io_reuse_pad17;                   
wire     [2:0]         r_io_reuse_pad20;                   
wire     [2:0]         r_io_reuse_pad19;   

wire     [PAD_NUM:1]   pad;
wire     [PAD_NUM:1]   pad_i_ival;
reg      [PAD_NUM:1]   pad_o_ie;
reg      [PAD_NUM:1]   pad_o_oval;
reg      [PAD_NUM:1]   pad_o_oe;
reg                    spi0_sdi2;
reg                    spi0_sdi3;
reg                    spi1_sdi2;
reg                    spi1_sdi3;
reg                    spi0_sdi0_pad4;     
reg                    spi0_sdi1_pad7;
reg                    spi0_sdi0_pad17;
reg                    spi0_sdi1_pad20;              
reg                    spi1_sdi0_pad5;
reg                    spi1_sdi1_pad8;
reg                    spi1_sdi0_pad17;
reg                    spi1_sdi1_pad20;              
reg                    i2c0_sda_pad3;
reg                    i2c0_scl_pad4;
reg                    i2c0_sda_pad19;
reg                    i2c0_scl_pad20;             
reg                    i2c1_sda_pad5;
reg                    i2c1_scl_pad6;
reg                    i2c1_sda_pad16;
reg                    i2c1_scl_pad17;             
reg                    uart_rxd_pad4;
reg                    uart_rxd_pad20;
reg                    clk_cpu;
reg                    rst_n_cpu;
reg                    pclk;
reg                    prest_n;

reg                    tck_i;
reg                    tms_i;
reg                    trst_ni;
reg                    td_i;

//****************************************************************************
//PAD Instance Declaration @ ykja_29285.
//****************************************************************************
genvar  pad_cnt;
generate
    for(pad_cnt = 1; pad_cnt <= PAD_NUM; pad_cnt = pad_cnt + 1) begin:gnrl_io_pad_inst
        gnrl_io_pad x_gnrl_io_pad(
        .pad_i_ival           (pad_i_ival[pad_cnt]          ),
        .pad_o_ie             (pad_o_ie[pad_cnt]            ),
        .pad_o_oval           (pad_o_oval[pad_cnt]          ),
        .pad_o_oe             (pad_o_oe[pad_cnt]            ),
        .pad_o_pue            (1'b0                         ),
        .pad_o_pde            (1'b0                         ),
        .pad_o_os             (1'b0                         ),
        .pad_o_od             (1'b0                         ),
        .pad_o_cs             (1'b0                         ),
        .pad_o_dr             (1'b0                         ),
        .pad_o_sr             (1'b0                         ),
        .pad                  (pad[pad_cnt]                 ),
        .analog_io            (                             )                  
        );
    end
endgenerate
//****************************************************************************
//Input Signal MUX Function Declaration.
//****************************************************************************
assign  spi0_sdi0 = (r_io_reuse_pad4 == 3'b000) ? spi0_sdi0_pad4 : (r_io_reuse_pad17 == 3'b000) ? spi0_sdi0_pad17 : 1'b0;
assign  spi0_sdi1 = (r_io_reuse_pad7 == 3'b000) ? spi0_sdi1_pad7 : (r_io_reuse_pad20 == 3'b000) ? spi0_sdi1_pad20 : 1'b0;

assign  spi1_sdi0 = (r_io_reuse_pad5 == 3'b001) ? spi1_sdi0_pad5 : (r_io_reuse_pad17 == 3'b001) ? spi1_sdi0_pad17 : 1'b0;
assign  spi1_sdi1 = (r_io_reuse_pad8 == 3'b001) ? spi1_sdi1_pad8 : (r_io_reuse_pad20 == 3'b001) ? spi1_sdi1_pad20 : 1'b0;

assign  i2c0_sda_pad_i  = (r_io_reuse_pad3 == 3'b010) ? i2c0_sda_pad3  : (r_io_reuse_pad19 == 3'b010) ? i2c0_sda_pad19  : 1'b0;
assign  i2c0_scl_pad_i  = (r_io_reuse_pad4 == 3'b010) ? i2c0_scl_pad4  : (r_io_reuse_pad20 == 3'b010) ? i2c0_scl_pad20  : 1'b0;

assign  i2c1_sda_pad_i  = (r_io_reuse_pad5 == 3'b011) ? i2c1_sda_pad5  : (r_io_reuse_pad16 == 3'b011) ? i2c1_sda_pad16  : 1'b0;
assign  i2c1_scl_pad_i  = (r_io_reuse_pad6 == 3'b011) ? i2c1_scl_pad6  : (r_io_reuse_pad17 == 3'b011) ? i2c1_scl_pad17  : 1'b0;

assign  ua_rxd    = (r_io_reuse_pad4 == 3'b100) ? uart_rxd_pad4  : (r_io_reuse_pad20 == 3'b100) ? uart_rxd_pad20  : 1'b0;

//****************************************************************************
//IOMUX Function Declaration.
//****************************************************************************
always @ (*) begin
    case(r_io_reuse_pad1)
        3'b000: begin
            //internal_sgl  = pad_i_ival[1];
            pad_o_ie[1]   = 1'b0;
            pad_o_oval[1] = spi0_clk;
            pad_o_oe[1]   = 1'b1;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[1];
            pad_o_ie[1]   = 1'b0;
            pad_o_oval[1] = 1'b0;
            pad_o_oe[1]   = 1'b0;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[1];
            pad_o_ie[1]   = 1'b0;
            pad_o_oval[1] = 1'b0;
            pad_o_oe[1]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[1];
            pad_o_ie[1]   = 1'b0;
            pad_o_oval[1] = 1'b0;
            pad_o_oe[1]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[1];
            pad_o_ie[1]   = 1'b0;
            pad_o_oval[1] = 1'b0;
            pad_o_oe[1]   = 1'b0;
        end       
        default: begin
            //internal_sgl  = pad_i_ival[1];
            pad_o_ie[1]   = 1'b0;
            pad_o_oval[1] = 1'b0;
            pad_o_oe[1]   = 1'b0; 
        end
    endcase    
end    

always @ (*) begin
    case(r_io_reuse_pad2)
        3'b000: begin
            //internal_sgl  = pad_i_ival[2];
            pad_o_ie[2]   = 1'b0;
            pad_o_oval[2] = spi0_csn0;
            pad_o_oe[2]   = 1'b1;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[2];
            pad_o_ie[2]   = 1'b0;
            pad_o_oval[2] = spi1_clk;
            pad_o_oe[2]   = 1'b1;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[2];
            pad_o_ie[2]   = 1'b0;
            pad_o_oval[2] = 1'b0;
            pad_o_oe[2]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[2];
            pad_o_ie[2]   = 1'b0;
            pad_o_oval[2] = 1'b0;
            pad_o_oe[2]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[2];
            pad_o_ie[2]   = 1'b0;
            pad_o_oval[2] = 1'b0;
            pad_o_oe[2]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[2];
            pad_o_ie[2]   = 1'b0;
            pad_o_oval[2] = 1'b0;
            pad_o_oe[2]   = 1'b0; 
        end
    endcase    
end 

always @ (*) begin
            i2c0_sda_pad3 = 1'b0;
    case(r_io_reuse_pad3)
        3'b000: begin
            //internal_sgl  = pad_i_ival[3];
            pad_o_ie[3]   = 1'b0;
            pad_o_oval[3] = spi0_sdo0;
            pad_o_oe[3]   = spi0_oe0;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[3];
            pad_o_ie[3]   = 1'b0;
            pad_o_oval[3] = spi1_csn0;
            pad_o_oe[3]   = 1'b1;
        end    
        3'b010: begin
            i2c0_sda_pad3 = pad_i_ival[3];
            pad_o_ie[3]   = 1'b1;
            pad_o_oval[3] = i2c0_sda_pad_o;
            pad_o_oe[3]   = i2c0_sda_padoen_o;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[3];
            pad_o_ie[3]   = 1'b0;
            pad_o_oval[3] = 1'b0;
            pad_o_oe[3]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[3];
            pad_o_ie[3]   = 1'b0;
            pad_o_oval[3] = ua_txd;
            pad_o_oe[3]   = 1'b1;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[3];
            pad_o_ie[3]   = 1'b0;
            pad_o_oval[3] = 1'b0;
            pad_o_oe[3]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi0_sdi0_pad4= 1'b0;
            i2c0_scl_pad4 = 1'b0;
            uart_rxd_pad4 = 1'b0;
    case(r_io_reuse_pad4)
        3'b000: begin
            spi0_sdi0_pad4= pad_i_ival[4];
            pad_o_ie[4]   = 1'b1;
            pad_o_oval[4] = 1'b0;
            pad_o_oe[4]   = 1'b0;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[4];
            pad_o_ie[4]   = 1'b0;
            pad_o_oval[4] = spi1_sdo0;
            pad_o_oe[4]   = 1'b1;
        end    
        3'b010: begin
            i2c0_scl_pad4 = pad_i_ival[4];
            pad_o_ie[4]   = 1'b1;
            pad_o_oval[4] = i2c0_scl_pad_o;
            pad_o_oe[4]   = i2c0_scl_padoen_o;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[4];
            pad_o_ie[4]   = 1'b0;
            pad_o_oval[4] = 1'b0;
            pad_o_oe[4]   = 1'b0;
        end
        3'b100: begin
            uart_rxd_pad4 = pad_i_ival[4];
            pad_o_ie[4]   = 1'b1;
            pad_o_oval[4] = 1'b0;
            pad_o_oe[4]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[4];
            pad_o_ie[4]   = 1'b0;
            pad_o_oval[4] = 1'b0;
            pad_o_oe[4]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi1_sdi0_pad5= 1'b0;
            i2c1_sda_pad5 = 1'b0;
    case(r_io_reuse_pad5)
        3'b000: begin
            //internal_sgl  = pad_i_ival[5];
            pad_o_ie[5]   = 1'b0;
            pad_o_oval[5] = spi0_csn1;
            pad_o_oe[5]   = 1'b1;  
        end
        3'b001: begin
            spi1_sdi0_pad5= pad_i_ival[5];
            pad_o_ie[5]   = 1'b1;
            pad_o_oval[5] = 1'b0;
            pad_o_oe[5]   = 1'b0;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[5];
            pad_o_ie[5]   = 1'b0;
            pad_o_oval[5] = 1'b0;
            pad_o_oe[5]   = 1'b0;
        end 
        3'b011: begin
            i2c1_sda_pad5 = pad_i_ival[5];
            pad_o_ie[5]   = 1'b1;
            pad_o_oval[5] = i2c1_sda_pad_o;
            pad_o_oe[5]   = i2c1_sda_padoen_o;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[5];
            pad_o_ie[5]   = 1'b0;
            pad_o_oval[5] = 1'b0;
            pad_o_oe[5]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[5];
            pad_o_ie[5]   = 1'b0;
            pad_o_oval[5] = 1'b0;
            pad_o_oe[5]   = 1'b0; 
        end
    endcase    
end
always @ (*) begin
            i2c1_scl_pad6  = 1'b0;
    case(r_io_reuse_pad6)
        3'b000: begin
            //internal_sgl  = pad_i_ival[6];
            pad_o_ie[6]   = 1'b0;
            pad_o_oval[6] = spi0_sdo1;
            pad_o_oe[6]   = spi0_oe1;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[6];
            pad_o_ie[6]   = 1'b0;
            pad_o_oval[6] = spi1_csn1;
            pad_o_oe[6]   = 1'b1;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[6];
            pad_o_ie[6]   = 1'b0;
            pad_o_oval[6] = 1'b0;
            pad_o_oe[6]   = 1'b0;
        end 
        3'b011: begin
            i2c1_scl_pad6  = pad_i_ival[6];
            pad_o_ie[6]   = 1'b1;
            pad_o_oval[6] = i2c1_scl_pad_o;
            pad_o_oe[6]   = i2c1_scl_padoen_o;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[6];
            pad_o_ie[6]   = 1'b0;
            pad_o_oval[6] = 1'b0;
            pad_o_oe[6]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[6];
            pad_o_ie[6]   = 1'b0;
            pad_o_oval[6] = 1'b0;
            pad_o_oe[6]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi0_sdi1_pad7= 1'b0;
    case(r_io_reuse_pad7)
        3'b000: begin
            spi0_sdi1_pad7= pad_i_ival[7];
            pad_o_ie[7]   = 1'b1;
            pad_o_oval[7] = 1'b0;
            pad_o_oe[7]   = 1'b0;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[7];
            pad_o_ie[7]   = 1'b0;
            pad_o_oval[7] = spi1_sdo1;
            pad_o_oe[7]   = spi1_oe1;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[7];
            pad_o_ie[7]   = 1'b0;
            pad_o_oval[7] = pwm_o[0];
            pad_o_oe[7]   = 1'b1;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[7];
            pad_o_ie[7]   = 1'b0;
            pad_o_oval[7] = 1'b0;
            pad_o_oe[7]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[7];
            pad_o_ie[7]   = 1'b0;
            pad_o_oval[7] = 1'b0;
            pad_o_oe[7]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[7];
            pad_o_ie[7]   = 1'b0;
            pad_o_oval[7] = 1'b0;
            pad_o_oe[7]   = 1'b0; 
        end
    endcase    
end
always @ (*) begin
            spi1_sdi1_pad8= 1'b0;
    case(r_io_reuse_pad8)
        3'b000: begin
            //internal_sgl  = pad_i_ival[8];
            pad_o_ie[8]   = 1'b0;
            pad_o_oval[8] = spi0_csn2;
            pad_o_oe[8]   = 1'b1;  
        end
        3'b001: begin
            spi1_sdi1_pad8= pad_i_ival[8];
            pad_o_ie[8]   = 1'b1;
            pad_o_oval[8] = 1'b0;
            pad_o_oe[8]   = 1'b0;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[8];
            pad_o_ie[8]   = 1'b0;
            pad_o_oval[8] = pwm_o[1];
            pad_o_oe[8]   = 1'b1;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[8];
            pad_o_ie[8]   = 1'b0;
            pad_o_oval[8] = 1'b0;
            pad_o_oe[8]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[8];
            pad_o_ie[8]   = 1'b0;
            pad_o_oval[8] = 1'b0;
            pad_o_oe[8]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[8];
            pad_o_ie[8]   = 1'b0;
            pad_o_oval[8] = 1'b0;
            pad_o_oe[8]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
    case(r_io_reuse_pad9)
        3'b000: begin
            //internal_sgl  = pad_i_ival[9];
            pad_o_ie[9]   = 1'b0;
            pad_o_oval[9] = spi0_sdo2;
            pad_o_oe[9]   = spi0_oe2;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[9];
            pad_o_ie[9]   = 1'b0;
            pad_o_oval[9] = spi1_csn2;
            pad_o_oe[9]   = 1'b1;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[9];
            pad_o_ie[9]   = 1'b0;
            pad_o_oval[9] = pwm_o[2];
            pad_o_oe[9]   = 1'b1;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[9];
            pad_o_ie[9]   = 1'b0;
            pad_o_oval[9] = 1'b0;
            pad_o_oe[9]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[9];
            pad_o_ie[9]   = 1'b0;
            pad_o_oval[9] = 1'b0;
            pad_o_oe[9]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[9];
            pad_o_ie[9]   = 1'b0;
            pad_o_oval[9] = 1'b0;
            pad_o_oe[9]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi0_sdi2      = 1'b0;
    case(r_io_reuse_pad10)
        3'b000: begin
            spi0_sdi2      = pad_i_ival[10];
            pad_o_ie[10]   = 1'b1;
            pad_o_oval[10] = 1'b0;
            pad_o_oe[10]   = 1'b0;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[10];
            pad_o_ie[10]   = 1'b0;
            pad_o_oval[10] = spi1_sdo2;
            pad_o_oe[10]   = spi1_oe2;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[10];
            pad_o_ie[10]   = 1'b0;
            pad_o_oval[10] = pwm_o[3];
            pad_o_oe[10]   = 1'b1;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[10];
            pad_o_ie[10]   = 1'b0;
            pad_o_oval[10] = 1'b0;
            pad_o_oe[10]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[10];
            pad_o_ie[10]   = 1'b0;
            pad_o_oval[10] = 1'b0;
            pad_o_oe[10]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[10];
            pad_o_ie[10]   = 1'b0;
            pad_o_oval[10] = 1'b0;
            pad_o_oe[10]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi1_sdi2      = 1'b0;
    case(r_io_reuse_pad11)
        3'b000: begin
            //internal_sgl  = pad_i_ival[11];
            pad_o_ie[11]   = 1'b0;
            pad_o_oval[11] = spi0_csn3;
            pad_o_oe[11]   = 1'b1;  
        end
        3'b001: begin
            spi1_sdi2      = pad_i_ival[11];
            pad_o_ie[11]   = 1'b1;
            pad_o_oval[11] = 1'b0;
            pad_o_oe[11]   = 1'b0;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[11];
            pad_o_ie[11]   = 1'b0;
            pad_o_oval[11] = 1'b0;
            pad_o_oe[11]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[11];
            pad_o_ie[11]   = 1'b0;
            pad_o_oval[11] = 1'b0;
            pad_o_oe[11]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[11];
            pad_o_ie[11]   = 1'b0;
            pad_o_oval[11] = 1'b0;
            pad_o_oe[11]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[11];
            pad_o_ie[11]   = 1'b0;
            pad_o_oval[11] = 1'b0;
            pad_o_oe[11]   = 1'b0; 
        end
    endcase    
end
always @ (*) begin
            tck_i          = 0;
    case(r_io_reuse_pad12)
        3'b000: begin
            //internal_sgl  = pad_i_ival[12];
            pad_o_ie[12]   = 1'b0;
            pad_o_oval[12] = spi0_sdo3;
            pad_o_oe[12]   = spi0_oe3;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[12];
            pad_o_ie[12]   = 1'b0;
            pad_o_oval[12] = spi1_csn3;
            pad_o_oe[12]   = 1'b1;
        end    
        3'b010: begin
            tck_i          = pad_i_ival[12];
            pad_o_ie[12]   = 1'b1;
            pad_o_oval[12] = 1'b0;
            pad_o_oe[12]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[12];
            pad_o_ie[12]   = 1'b0;
            pad_o_oval[12] = 1'b0;
            pad_o_oe[12]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[12];
            pad_o_ie[12]   = 1'b0;
            pad_o_oval[12] = 1'b0;
            pad_o_oe[12]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[12];
            pad_o_ie[12]   = 1'b0;
            pad_o_oval[12] = 1'b0;
            pad_o_oe[12]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi0_sdi3      = 1'b0;
            tms_i          = 1'b0;
    case(r_io_reuse_pad13)
        3'b000: begin
            spi0_sdi3      = pad_i_ival[13];
            pad_o_ie[13]   = 1'b1;
            pad_o_oval[13] = 1'b0;
            pad_o_oe[13]   = 1'b0;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[13];
            pad_o_ie[13]   = 1'b0;
            pad_o_oval[13] = spi1_sdo3;
            pad_o_oe[13]   = spi1_oe3;
        end    
        3'b010: begin
            tms_i          = pad_i_ival[13];
            pad_o_ie[13]   = 1'b1;
            pad_o_oval[13] = 1'b0;
            pad_o_oe[13]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[13];
            pad_o_ie[13]   = 1'b0;
            pad_o_oval[13] = 1'b0;
            pad_o_oe[13]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[13];
            pad_o_ie[13]   = 1'b0;
            pad_o_oval[13] = 1'b0;
            pad_o_oe[13]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[13];
            pad_o_ie[13]   = 1'b0;
            pad_o_oval[13] = 1'b0;
            pad_o_oe[13]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi1_sdi3      = 1'b0;
            trst_ni        = 1'b0;
    case(r_io_reuse_pad14)
        3'b000: begin
            //internal_sgl  = pad_i_ival[14];
            pad_o_ie[14]   = 1'b0;
            pad_o_oval[14] = 1'b0;
            pad_o_oe[14]   = 1'b0;  
        end
        3'b001: begin
            spi1_sdi3      = pad_i_ival[14];
            pad_o_ie[14]   = 1'b1;
            pad_o_oval[14] = 1'b0;
            pad_o_oe[14]   = 1'b0;
        end    
        3'b010: begin
            trst_ni        = pad_i_ival[14];
            pad_o_ie[14]   = 1'b1;
            pad_o_oval[14] = 1'b0;
            pad_o_oe[14]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[14];
            pad_o_ie[14]   = 1'b0;
            pad_o_oval[14] = 1'b0;
            pad_o_oe[14]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[14];
            pad_o_ie[14]   = 1'b0;
            pad_o_oval[14] = 1'b0;
            pad_o_oe[14]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[14];
            pad_o_ie[14]   = 1'b0;
            pad_o_oval[14] = 1'b0;
            pad_o_oe[14]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            td_i           = 1'b0;
    case(r_io_reuse_pad15)
        3'b000: begin
            //internal_sgl  = pad_i_ival[15];
            pad_o_ie[15]   = 1'b0;
            pad_o_oval[15] = spi0_csn0;
            pad_o_oe[15]   = 1'b1;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[15];
            pad_o_ie[15]   = 1'b0;
            pad_o_oval[15] = spi1_csn0;
            pad_o_oe[15]   = 1'b1;
        end    
        3'b010: begin
            td_i           = pad_i_ival[15];
            pad_o_ie[15]   = 1'b1;
            pad_o_oval[15] = 1'b0;
            pad_o_oe[15]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[15];
            pad_o_ie[15]   = 1'b0;
            pad_o_oval[15] = 1'b0;
            pad_o_oe[15]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[15];
            pad_o_ie[15]   = 1'b0;
            pad_o_oval[15] = 1'b0;
            pad_o_oe[15]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[15];
            pad_o_ie[15]   = 1'b0;
            pad_o_oval[15] = 1'b0;
            pad_o_oe[15]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            i2c1_sda_pad16 = 1'b0;
    case(r_io_reuse_pad16)
        3'b000: begin
            //internal_sgl  = pad_i_ival[16];
            pad_o_ie[16]   = 1'b0;
            pad_o_oval[16] = spi0_sdo0;
            pad_o_oe[16]   = spi0_oe0;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[16];
            pad_o_ie[16]   = 1'b0;
            pad_o_oval[16] = spi1_sdo0;
            pad_o_oe[16]   = spi1_oe0;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[16];
            pad_o_ie[16]   = 1'b0;
            pad_o_oval[16] = td_o;
            pad_o_oe[16]   = tdo_oe_o;
        end 
        3'b011: begin
            i2c1_sda_pad16 = pad_i_ival[16];
            pad_o_ie[16]   = 1'b1;
            pad_o_oval[16] = i2c1_sda_pad_o;
            pad_o_oe[16]   = i2c1_sda_padoen_o;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[16];
            pad_o_ie[16]   = 1'b0;
            pad_o_oval[16] = 1'b0;
            pad_o_oe[16]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[16];
            pad_o_ie[16]   = 1'b0;
            pad_o_oval[16] = 1'b0;
            pad_o_oe[16]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            spi0_sdi0_pad17= 1'b0;
            spi1_sdi0_pad17= 1'b0;
            i2c1_scl_pad17 = 1'b0;
    case(r_io_reuse_pad17)
        3'b000: begin
            spi0_sdi0_pad17= pad_i_ival[17];
            pad_o_ie[17]   = 1'b1;
            pad_o_oval[17] = 1'b0;
            pad_o_oe[17]   = 1'b0;  
        end
        3'b001: begin
            spi1_sdi0_pad17= pad_i_ival[17];
            pad_o_ie[17]   = 1'b1;
            pad_o_oval[17] = 1'b0;
            pad_o_oe[17]   = 1'b0;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[17];
            pad_o_ie[17]   = 1'b0;
            pad_o_oval[17] = 1'b0;
            pad_o_oe[17]   = 1'b0;
        end 
        3'b011: begin
            i2c1_scl_pad17 = pad_i_ival[17];
            pad_o_ie[17]   = 1'b1;
            pad_o_oval[17] = i2c1_scl_pad_o;
            pad_o_oe[17]   = i2c1_scl_padoen_o;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[17];
            pad_o_ie[17]   = 1'b0;
            pad_o_oval[17] = 1'b0;
            pad_o_oe[17]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[17];
            pad_o_ie[17]   = 1'b0;
            pad_o_oval[17] = 1'b0;
            pad_o_oe[17]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
    case(r_io_reuse_pad18)
        3'b000: begin
            //internal_sgl  = pad_i_ival[18];
            pad_o_ie[18]   = 1'b0;
            pad_o_oval[18] = spi0_csn1;
            pad_o_oe[18]   = 1'b1;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[18];
            pad_o_ie[18]   = 1'b0;
            pad_o_oval[18] = spi1_csn1;
            pad_o_oe[18]   = 1'b1;
        end    
        3'b010: begin
            //internal_sgl  = pad_i_ival[18];
            pad_o_ie[18]   = 1'b0;
            pad_o_oval[18] = 1'b0;
            pad_o_oe[18]   = 1'b0;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[18];
            pad_o_ie[18]   = 1'b0;
            pad_o_oval[18] = 1'b0;
            pad_o_oe[18]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[18];
            pad_o_ie[18]   = 1'b0;
            pad_o_oval[18] = 1'b0;
            pad_o_oe[18]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[18];
            pad_o_ie[18]   = 1'b0;
            pad_o_oval[18] = 1'b0;
            pad_o_oe[18]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin
            i2c0_sda_pad19 = 1'b0;
    case(r_io_reuse_pad19)
        3'b000: begin
            //internal_sgl  = pad_i_ival[19];
            pad_o_ie[19]   = 1'b0;
            pad_o_oval[19] = spi0_sdo1;
            pad_o_oe[19]   = spi0_oe1;  
        end
        3'b001: begin
            //internal_sgl  = pad_i_ival[19];
            pad_o_ie[19]   = 1'b0;
            pad_o_oval[19] = spi1_sdo1;
            pad_o_oe[19]   = spi1_oe1;
        end    
        3'b010: begin
            i2c0_sda_pad19 = pad_i_ival[19];
            pad_o_ie[19]   = 1'b1;
            pad_o_oval[19] = i2c0_sda_pad_o;
            pad_o_oe[19]   = i2c0_sda_padoen_o;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[19];
            pad_o_ie[19]   = 1'b0;
            pad_o_oval[19] = 1'b0;
            pad_o_oe[19]   = 1'b0;
        end
        3'b100: begin
            //internal_sgl  = pad_i_ival[19];
            pad_o_ie[19]   = 1'b0;
            pad_o_oval[19] = ua_txd;
            pad_o_oe[19]   = 1'b1;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[19];
            pad_o_ie[19]   = 1'b0;
            pad_o_oval[19] = 1'b0;
            pad_o_oe[19]   = 1'b0; 
        end
    endcase    
end

always @ (*) begin

    spi0_sdi1_pad20 =  1'b0;
    spi1_sdi1_pad20 =  1'b0;
    i2c0_scl_pad20  =  1'b0;
    uart_rxd_pad20  =  1'b0;

    pad_o_ie[21]    =  1'b1;
	pad_o_ie[22]    =  1'b1;
	pad_o_ie[23]    =  1'b1;
	pad_o_ie[24]    =  1'b1;

    case(r_io_reuse_pad20)
        3'b000: begin
            spi0_sdi1_pad20= pad_i_ival[20];
            pad_o_ie[20]   = 1'b1;
            pad_o_oval[20] = 1'b0;
            pad_o_oe[20]   = 1'b0;  
        end
        3'b001: begin
            spi1_sdi1_pad20= pad_i_ival[20];
            pad_o_ie[20]   = 1'b1;
            pad_o_oval[20] = 1'b0;
            pad_o_oe[20]   = 1'b0;
        end    
        3'b010: begin
            i2c0_scl_pad20 = pad_i_ival[20];
            pad_o_ie[20]   = 1'b1;
            pad_o_oval[20] = i2c0_scl_pad_o;
            pad_o_oe[20]   = i2c0_scl_padoen_o;
        end 
        3'b011: begin
            //internal_sgl  = pad_i_ival[20];
            pad_o_ie[20]   = 1'b0;
            pad_o_oval[20] = 1'b0;
            pad_o_oe[20]   = 1'b0;
        end
        3'b100: begin
            uart_rxd_pad20 = pad_i_ival[20];
            pad_o_ie[20]   = 1'b1;
            pad_o_oval[20] = 1'b0;
            pad_o_oe[20]   = 1'b0;
        end         
        default: begin
            //internal_sgl  = pad_i_ival[20];
            pad_o_ie[20]   = 1'b0;
            pad_o_oval[20] = 1'b0;
            pad_o_oe[20]   = 1'b0; 
        end
    endcase    
end

//assign pad_o_ie[21] = 1'b1;//update
//assign pad_o_ie[22] = 1'b1;
//assign pad_o_ie[23] = 1'b1;
//assign pad_o_ie[24] = 1'b1;
//always @ (*) begin
//	pad_o_ie[21] = 1'b1;
//	pad_o_ie[22] = 1'b1;
//	pad_o_ie[23] = 1'b1;
//	pad_o_ie[24] = 1'b1;
//end

always @ (*) begin
    clk_cpu        = pad_i_ival[21];
    pad_o_oval[21] = 1'b0;
    pad_o_oe[21]   = 1'b0; 

    rst_n_cpu      = pad_i_ival[22];
    pad_o_oval[22] = 1'b0;
    pad_o_oe[22]   = 1'b0; 

    pclk           = pad_i_ival[23];
    pad_o_oval[23] = 1'b0;
    pad_o_oe[23]   = 1'b0; 

    prest_n        = pad_i_ival[24];
    pad_o_oval[24] = 1'b0;
    pad_o_oe[24]   = 1'b0; 
end    

endmodule
