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
module master_if(/*AUTOARG*/
   // Outputs
   m_hsel, m_haddr, m_htrans, m_hwrite, m_hsize, m_hburst, m_hprot,
   m_hready, m_hwdata, gnt, hready_out_from_slave, hresp_from_slave,
   // Inputs
   hclk, hresetn, s_haddr, s_htrans, s_hwrite, s_hsize, s_hburst,
   s_hprot, s_hready, s_req, s_hwdata, hready_in_from_slave,
   hresp_in_from_slave
   );
//****************************************************************************
//Parameter Declaration.
//****************************************************************************

//****************************************************************************
//Port Declaration.
//****************************************************************************
/*AUTOINPUT*/
/*AUTOOUTPUT*/
input hclk;
input hresetn;
input [7 * 32 - 1: 0] s_haddr;
input [7 * 2 - 1 : 0] s_htrans;
input [6         : 0] s_hwrite;
input [7 * 3 - 1 : 0] s_hsize;
input [7 * 3 - 1 : 0] s_hburst;
input [7 * 4 - 1 : 0] s_hprot;
input [6         : 0] s_hready;
input [6         : 0] s_req;
input [7 * 32 - 1: 0] s_hwdata;
input                 hready_in_from_slave;
input [1         : 0] hresp_in_from_slave;

output                m_hsel;
output [31       : 0] m_haddr;
output [1        : 0] m_htrans;
output                m_hwrite;
output [2        : 0] m_hsize;
output [2        : 0] m_hburst;
output [3        : 0] m_hprot;
output                m_hready;
output [31       : 0] m_hwdata;
output [6        : 0] gnt;
output                hready_out_from_slave;
output [1        : 0] hresp_from_slave;
//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
/*AUTOREG*/
wire                  m_hsel;
wire   [31: 0]        m_haddr;
wire   [1 : 0]        m_htrans;
wire                  m_hwrite;
wire   [2 : 0]        m_hsize;
wire   [2 : 0]        m_hburst;
wire   [3 : 0]        m_hprot;
wire                  m_hready;
wire   [31: 0]        m_hwdata;
wire                  hready_out_from_slave;
wire   [1 : 0]        hresp_from_slave;
wire   [6 : 0]        gnt;
wire   [45: 0]        mux_out;
wire   [31: 0]        data_mux_out;
wire   [45: 0]        tr0;
wire   [31: 0]        s_hwdata0;
wire   [45: 0]        tr1;
wire   [31: 0]        s_hwdata1;
wire   [45: 0]        tr2;
wire   [31: 0]        s_hwdata2;
wire   [45: 0]        tr3;
wire   [31: 0]        s_hwdata3;
wire   [45: 0]        tr4;
wire   [31: 0]        s_hwdata4;
wire   [45: 0]        tr5;
wire   [31: 0]        s_hwdata5;
wire   [45: 0]        tr6;
wire   [31: 0]        s_hwdata6;

reg    [6: 0]         data_gnt;
//****************************************************************************
//Instance Declaration.
//****************************************************************************
arbiter arbiter_inst(
.grant                        (gnt                          ),
.hclk                         (hclk                         ),
.hresetn                      (hresetn                      ),
.request                      (s_req                        ),
.hready_out                   (hready_in_from_slave         )
);

multiplexer #(7,46) multiplexer_inst0(
.out                          (mux_out                      ),
.input0                       (tr0                          ),
.input1                       (tr1                          ),
.input2                       (tr2                          ),
.input3                       (tr3                          ),
.input4                       (tr4                          ),
.input5                       (tr5                          ),
.input6                       (tr6                          ),
.select                       (gnt                          )
 );

multiplexer #(7,32) multiplexer_inst1(
.out                          (data_mux_out                 ),
.input0                       (s_hwdata0                    ),
.input1                       (s_hwdata1                    ),
.input2                       (s_hwdata2                    ),
.input3                       (s_hwdata3                    ),
.input4                       (s_hwdata4                    ),
.input5                       (s_hwdata5                    ),
.input6                       (s_hwdata6                    ),
.select                       (data_gnt                     )
 );
//****************************************************************************
//Function Declaration.
//****************************************************************************
assign hready_out_from_slave = hready_in_from_slave;
assign hresp_from_slave      = hresp_in_from_slave;
assign m_hsel                = |gnt;
assign m_haddr               = mux_out[45:14];
assign m_htrans              = mux_out[13:12];
assign m_hwrite              = mux_out[11];
assign m_hsize               = mux_out[10:8];
assign m_hburst              = mux_out[7:5];
assign m_hprot               = mux_out[4:1];
assign m_hready              = (m_hsel || (|data_gnt) ) ? hready_in_from_slave : 1'b1;
assign m_hwdata              = data_mux_out;

assign tr0                   = {s_haddr[31: 0], s_htrans[1:0], s_hwrite[0], s_hsize[2:0], s_hburst[2:0], s_hprot[3:0], s_hready[0]};
assign s_hwdata0             = s_hwdata[31: 0];
assign tr1                   = {s_haddr[2 * 32 - 1: 32], s_htrans[2 * 2 - 1:2], s_hwrite[1], s_hsize[2 * 3 - 1:3], s_hburst[2 * 3 - 1:3], s_hprot[2 * 4 - 1:4], s_hready[1]};
assign s_hwdata1             = s_hwdata[2 * 32 - 1: 32];
assign tr2                   = {s_haddr[3 * 32 - 1: 2 * 32], s_htrans[3 * 2 - 1 : 2 * 2], s_hwrite[2], s_hsize[3 * 3 - 1: 2 * 3], s_hburst[3 * 3 - 1 : 2 * 3], s_hprot[3 * 4 - 1: 2 * 4], s_hready[2]};
assign s_hwdata2             = s_hwdata[3 * 32 - 1: 2 * 32];
assign tr3                   = {s_haddr[4 * 32 - 1: 3 * 32], s_htrans[4 * 2 - 1 : 3 * 2], s_hwrite[3], s_hsize[4 * 3 - 1: 3 * 3], s_hburst[4 * 3 - 1 : 3 * 3], s_hprot[4 * 4 - 1: 3 * 4], s_hready[3]};
assign s_hwdata3             = s_hwdata[4 * 32 - 1: 3 * 32];
assign tr4                   = {s_haddr[5 * 32 - 1: 4 * 32], s_htrans[5 * 2 - 1 : 4 * 2], s_hwrite[4], s_hsize[5 * 3 - 1: 4 * 3], s_hburst[5 * 3 - 1 : 4 * 3], s_hprot[5 * 4 - 1: 4 * 4], s_hready[4]};
assign s_hwdata4             = s_hwdata[5 * 32 - 1: 4 * 32];
assign tr5                   = {s_haddr[6 * 32 - 1: 5 * 32], s_htrans[6 * 2 - 1 : 5 * 2], s_hwrite[5], s_hsize[6 * 3 - 1: 5 * 3], s_hburst[6 * 3 - 1 : 5 * 3], s_hprot[6 * 4 - 1: 5 * 4], s_hready[5]};
assign s_hwdata5             = s_hwdata[6 * 32 - 1: 5 * 32];
assign tr6                   = {s_haddr[7 * 32 - 1: 6 * 32], s_htrans[7 * 2 - 1 : 6 * 2], s_hwrite[6], s_hsize[7 * 3 - 1: 6 * 3], s_hburst[7 * 3 - 1 : 6 * 3], s_hprot[7 * 4 - 1: 6 * 4], s_hready[6]};
assign s_hwdata6             = s_hwdata[7 * 32 - 1: 6 * 32];

always @ (posedge hclk or negedge hresetn) begin
    if (~hresetn) begin
        data_gnt <= 0;
    end    
    else if (|gnt && hready_in_from_slave) begin
        data_gnt <=gnt;
    end
end    

endmodule
