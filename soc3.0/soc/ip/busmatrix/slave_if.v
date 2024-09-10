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
module slave_if(/*AUTOARG*/
   // Outputs
   hresp_out, hready_out, hrdata_out, haddr_int, htrans_int,
   hwrite_int, hsize_int, hburst_int, hprot_int, req,
   // Inputs
   hclk, hresetn, hsel, haddr, htrans, hwrite, hsize, hburst, hprot,
   hready, gnt, s_hresp_from_all_slave, s_hready_from_all_slave,
   s_hrdata_from_all_slave
   );
//****************************************************************************
//Port Declaration.
//****************************************************************************
/*AUTOINPUT*/
/*AUTOOUTPUT*/
input                      hclk;
input                      hresetn;
input                      hsel;
input  [31       : 0]      haddr;
input  [1        : 0]      htrans;
input                      hwrite;
input  [2        : 0]      hsize;
input  [2        : 0]      hburst;
input  [3        : 0]      hprot;
input                      hready;
input [5 - 1     : 0]      gnt;
input [5 * 2 - 1 : 0]      s_hresp_from_all_slave;
input [5 - 1     : 0]      s_hready_from_all_slave;
input [5 * 32 -1 : 0]      s_hrdata_from_all_slave;
output [1        : 0]      hresp_out;
output                     hready_out;
output [31       : 0]      hrdata_out;
output [31       : 0]      haddr_int;
output [1        : 0]      htrans_int;
output                     hwrite_int;
output [2        : 0]      hsize_int;
output [2        : 0]      hburst_int;
output [3        : 0]      hprot_int;
output [5 - 1    : 0]      req;

//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
/*AUTOREG*/
wire [1    : 0] hresp_out;
wire [31   : 0] hrdata_out;
wire [1    : 0] hresp_from_slave;
wire            hready_out_from_slave;
wire            hready_out;
wire            hwrite_int;
wire [31   : 0] haddr_int;
wire [1    : 0] htrans_int;
wire [2    : 0] hsize_int;
wire [2    : 0] hburst_int;
wire [3    : 0] hprot_int;
wire [5 - 1: 0] req;
wire [5 - 1: 0] data_gnt;   
wire [2    : 0] mux_out;
wire [31   : 0] data_mux_out;
wire [2    : 0] resp0;
wire [31   : 0] data0;
wire [2    : 0] resp1;
wire [31   : 0] data1;
wire [2    : 0] resp2;
wire [31   : 0] data2;
wire [2    : 0] resp3;
wire [31   : 0] data3;
wire [2    : 0] resp4;
wire [31   : 0] data4;

//****************************************************************************
//Instance Declaration.
//****************************************************************************
req_register req_register_inst(
// input ports 
.hclk                         (hclk                         ),
.hresetn                      (hresetn                      ),   
.hsel                         (hsel                         ),
.haddr                        (haddr                        ),
.htrans                       (htrans                       ),
.hwrite                       (hwrite                       ),
.hsize                        (hsize                        ),
.hburst                       (hburst                       ),
.hprot                        (hprot                        ),
.hready                       (hready                       ),
.gnt                          (gnt                          ),
.hready_out_from_slave        (hready_out_from_slave        ),
.hresp_from_slave             (hresp_from_slave             ),
// output ports
.haddr_out                    (haddr_int                    ),
.htrans_out                   (htrans_int                   ),
.hwrite_out                   (hwrite_int                   ),
.hsize_out                    (hsize_int                    ),
.hburst_out                   (hburst_int                   ),
.hprot_out                    (hprot_int                    ),
.hresp_out                    (hresp_out                    ),
.hready_out                   (hready_out                   ),
.data_gnt                     (data_gnt                     ),
.master_sel                   (req                          )
);

multiplexer #(5,3) multiplexer_inst0(
// input ports
.input0                       (resp0                        ),
.input1                       (resp1                        ),
.input2                       (resp2                        ),
.input3                       (resp3                        ),
.input4                       (resp4                        ),
.input5                       (3'b0                         ),
.input6                       (3'b0                         ),
.select                       (( gnt | data_gnt)            ), 
// output ports
.out                          (mux_out                      )
);
multiplexer #(5,32) multiplexer_inst1(
// input ports
.input0                       (data0                        ),
.input1                       (data1                        ),
.input2                       (data2                        ),
.input3                       (data3                        ),
.input4                       (data4                        ),
.input5                       (32'b0                        ),
.input6                       (32'b0                        ),
.select                       (data_gnt                     ), 
// output ports
.out                          (data_mux_out                 )
);
//****************************************************************************
//Function Declaration.
//****************************************************************************
assign resp0 = { s_hresp_from_all_slave[ 1 : 0 ],  s_hready_from_all_slave[0]};
assign data0 =  s_hrdata_from_all_slave [32 - 1 : 0];
assign resp1 = { s_hresp_from_all_slave[ 2 * 2 - 1 : 2 ], s_hready_from_all_slave[1]};
assign data1 =  s_hrdata_from_all_slave [2 * 32 -1 : 32];
assign resp2 = { s_hresp_from_all_slave[ 3 * 2 - 1 : 2 * 2 ], s_hready_from_all_slave[2]};
assign data2 =  s_hrdata_from_all_slave [3 * 32 - 1 : 2 * 32];
assign resp3 = { s_hresp_from_all_slave[ 4 * 2 - 1 : 3 * 2 ], s_hready_from_all_slave[3]};
assign data3 =  s_hrdata_from_all_slave [4 * 32 - 1 : 3 * 32];
assign resp4 = { s_hresp_from_all_slave[ 5 * 2 - 1 : 4 * 2 ], s_hready_from_all_slave[4]};
assign data4 =  s_hrdata_from_all_slave [5 * 32 - 1 : 4 * 32];
assign hready_out_from_slave = mux_out[0];
assign hresp_from_slave = mux_out[2:1];
assign hrdata_out = data_mux_out;

endmodule
