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
module busmatrix(/*AUTOARG*/
   // Outputs
   hselm0, haddrm0, htransm0, hwritem0, hsizem0, hburstm0, hprotm0,
   hmasterm0, hwdatam0, hmastlackm0, hreadymuxm0, hselm1, haddrm1,
   htransm1, hwritem1, hsizem1, hburstm1, hprotm1, hmasterm1,
   hwdatam1, hmastlackm1, hreadymuxm1, hselm2, haddrm2, htransm2,
   hwritem2, hsizem2, hburstm2, hprotm2, hmasterm2, hwdatam2,
   hmastlackm2, hreadymuxm2, hselm3, haddrm3, htransm3, hwritem3,
   hsizem3, hburstm3, hprotm3, hmasterm3, hwdatam3, hmastlackm3,
   hreadymuxm3, hselm4, haddrm4, htransm4, hwritem4, hsizem4,
   hburstm4, hprotm4, hmasterm4, hwdatam4, hmastlackm4, hreadymuxm4,
   hrdatas0, hreadyouts0, hresps0, hrdatas1, hreadyouts1, hresps1,
   hrdatas2, hreadyouts2, hresps2, hrdatas3, hreadyouts3, hresps3,
   hrdatas4, hreadyouts4, hresps4, hrdatas5, hreadyouts5, hresps5,
   hrdatas6, hreadyouts6, hresps6,
   // Inputs
   hclk, hresetn, hsels0, haddrs0, htranss0, hwrites0, hsizes0,
   hbursts0, hprots0, hmasters0, hwdatas0, hmastlocks0, hreadys0,
   hsels1, haddrs1, htranss1, hwrites1, hsizes1, hbursts1, hprots1,
   hmasters1, hwdatas1, hmastlocks1, hreadys1, hsels2, haddrs2,
   htranss2, hwrites2, hsizes2, hbursts2, hprots2, hmasters2,
   hwdatas2, hmastlocks2, hreadys2, hsels3, haddrs3, htranss3,
   hwrites3, hsizes3, hbursts3, hprots3, hmasters3, hwdatas3,
   hmastlocks3, hreadys3, hsels4, haddrs4, htranss4, hwrites4,
   hsizes4, hbursts4, hprots4, hmasters4, hwdatas4, hmastlocks4,
   hreadys4, hsels5, haddrs5, htranss5, hwrites5, hsizes5, hbursts5, hprots5,
   hmasters5, hwdatas5, hmastlocks5, hreadys5, hsels6, haddrs6,
   htranss6, hwrites6, hsizes6, hbursts6, hprots6, hmasters6,
   hwdatas6, hmastlocks6, hreadys6,
   hrdatam0, hreadyoutm0, hrespm0, hrdatam1, hreadyoutm1,
   hrespm1, hrdatam2, hreadyoutm2, hrespm2, hrdatam3, hreadyoutm3,
   hrespm3, hrdatam4, hreadyoutm4, hrespm4
   );
//****************************************************************************
//Parameter Declaration.
//****************************************************************************

//****************************************************************************
//Port Declaration.
//****************************************************************************
/*AUTOINPUT*/
/*AUTOOUTPUT*/
input                hclk;
input                hresetn;
// Slave 0 Input port
input                hsels0;
input [32 - 1 : 0]   haddrs0;
input [1      : 0]   htranss0;
input                hwrites0;
input [2      : 0]   hsizes0;
input [2      : 0]   hbursts0;
input [3      : 0]   hprots0;
input [3      : 0]   hmasters0;
input [32 - 1 : 0]   hwdatas0;
input                hmastlocks0; 
input                hreadys0;
// Slave 1 Input port
input                hsels1;
input [32 - 1 : 0]   haddrs1;
input [1      : 0]   htranss1;
input                hwrites1;
input [2      : 0]   hsizes1;
input [2      : 0]   hbursts1;
input [3      : 0]   hprots1;
input [3      : 0]   hmasters1;
input [32 - 1 : 0]   hwdatas1;
input                hmastlocks1; 
input                hreadys1;
// Slave 2 Input port
input                hsels2;
input [32 - 1 : 0]   haddrs2;
input [1      : 0]   htranss2;
input                hwrites2;
input [2      : 0]   hsizes2;
input [2      : 0]   hbursts2;
input [3      : 0]   hprots2;
input [3      : 0]   hmasters2;
input [32 - 1 : 0]   hwdatas2;
input                hmastlocks2; 
input                hreadys2;
// Slave 3 Input port
input                hsels3;
input [32 - 1 : 0]   haddrs3;
input [1      : 0]   htranss3;
input                hwrites3;
input [2      : 0]   hsizes3;
input [2      : 0]   hbursts3;
input [3      : 0]   hprots3;
input [3      : 0]   hmasters3;
input [32 - 1 : 0]   hwdatas3;
input                hmastlocks3; 
input                hreadys3;
// Slave 4 Input port
input                hsels4;
input [32 - 1 : 0]   haddrs4;
input [1      : 0]   htranss4;
input                hwrites4;
input [2      : 0]   hsizes4;
input [2      : 0]   hbursts4;
input [3      : 0]   hprots4;
input [3      : 0]   hmasters4;
input [32 - 1 : 0]   hwdatas4;
input                hmastlocks4; 
input                hreadys4;
// Slave 5 Input port
input                hsels5;
input [32 - 1 : 0]   haddrs5;
input [1      : 0]   htranss5;
input                hwrites5;
input [2      : 0]   hsizes5;
input [2      : 0]   hbursts5;
input [3      : 0]   hprots5;
input [3      : 0]   hmasters5;
input [32 - 1 : 0]   hwdatas5;
input                hmastlocks5; 
input                hreadys5;
// Slave 6 Input port
input                hsels6;
input [32 - 1 : 0]   haddrs6;
input [1      : 0]   htranss6;
input                hwrites6;
input [2      : 0]   hsizes6;
input [2      : 0]   hbursts6;
input [3      : 0]   hprots6;
input [3      : 0]   hmasters6;
input [32 - 1 : 0]   hwdatas6;
input                hmastlocks6; 
input                hreadys6;
// Master 0 Input port
input [32 - 1 : 0]   hrdatam0;
input                hreadyoutm0;
input [1      : 0]   hrespm0;
// Master 1 Input port
input [32 - 1 : 0]   hrdatam1;
input                hreadyoutm1;
input [1      : 0]   hrespm1;
// Master 2 Input port
input [32 - 1 : 0]   hrdatam2;
input                hreadyoutm2;
input [1      : 0]   hrespm2;
// Master 3 Input port
input [32 - 1 : 0]   hrdatam3;
input                hreadyoutm3;
input [1      : 0]   hrespm3;
// Master 4 Input port
input [32 - 1 : 0]   hrdatam4;
input                hreadyoutm4;
input [1      : 0]   hrespm4;
// Master 0 Output port
output               hselm0;
output [32 - 1 : 0]  haddrm0;
output [1      : 0]  htransm0;
output               hwritem0;
output [2      : 0]  hsizem0;
output [2      : 0]  hburstm0;
output [3      : 0]  hprotm0;
output [3      : 0]  hmasterm0;
output [32 - 1 : 0]  hwdatam0;
output               hmastlackm0;
output               hreadymuxm0;
// Master 1 Output port
output               hselm1;
output [32 - 1 : 0]  haddrm1;
output [1      : 0]  htransm1;
output               hwritem1;
output [2      : 0]  hsizem1;
output [2      : 0]  hburstm1;
output [3      : 0]  hprotm1;
output [3      : 0]  hmasterm1;
output [32 - 1 : 0]  hwdatam1;
output               hmastlackm1;
output               hreadymuxm1;
// Master 2 Output port
output               hselm2;
output [32 - 1 : 0]  haddrm2;
output [1      : 0]  htransm2;
output               hwritem2;
output [2      : 0]  hsizem2;
output [2      : 0]  hburstm2;
output [3      : 0]  hprotm2;
output [3      : 0]  hmasterm2;
output [32 - 1 : 0]  hwdatam2;
output               hmastlackm2;
output               hreadymuxm2;
// Master 3 Output port
output               hselm3;
output [32 - 1 : 0]  haddrm3;
output [1      : 0]  htransm3;
output               hwritem3;
output [2      : 0]  hsizem3;
output [2      : 0]  hburstm3;
output [3      : 0]  hprotm3;
output [3      : 0]  hmasterm3;
output [32 - 1 : 0]  hwdatam3;
output               hmastlackm3;
output               hreadymuxm3;
// Master 4 Output port
output               hselm4;
output [32 - 1 : 0]  haddrm4;
output [1      : 0]  htransm4;
output               hwritem4;
output [2      : 0]  hsizem4;
output [2      : 0]  hburstm4;
output [3      : 0]  hprotm4;
output [3      : 0]  hmasterm4;
output [32 - 1 : 0]  hwdatam4;
output               hmastlackm4;
output               hreadymuxm4;
// Slave 0 Output port
output [32 - 1 : 0]  hrdatas0;
output               hreadyouts0;
output [1      : 0]  hresps0;
// Slave 1 Output port
output [32 - 1 : 0]  hrdatas1;
output               hreadyouts1;
output [1      : 0]  hresps1;
// Slave 2 Output port
output [32 - 1 : 0]  hrdatas2;
output               hreadyouts2;
output [1      : 0]  hresps2;
// Slave 3 Output port
output [32 - 1 : 0]  hrdatas3;
output               hreadyouts3;
output [1      : 0]  hresps3;
// Slave 4 Output port
output [32 - 1 : 0]  hrdatas4;
output               hreadyouts4;
output [1      : 0]  hresps4;
// Slave 5 Output port
output [32 - 1 : 0]  hrdatas5;
output               hreadyouts5;
output [1      : 0]  hresps5;
// Slave 6 Output port
output [32 - 1 : 0]  hrdatas6;
output               hreadyouts6;
output [1      : 0]  hresps6;

//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
/*AUTOREG*/
// Beginning of automatic regs (for this module's undeclared outputs)
//reg [32-1:0]            haddrm0;
//reg [32-1:0]            haddrm1;
//reg [32-1:0]            haddrm2;
//reg [32-1:0]            haddrm3;
//reg [32-1:0]            haddrm4;
//reg [2:0]               hburstm0;
//reg [2:0]               hburstm1;
//reg [2:0]               hburstm2;
//reg [2:0]               hburstm3;
//reg [2:0]               hburstm4;
//reg [3:0]               hprotm0;
//reg [3:0]               hprotm1;
//reg [3:0]               hprotm2;
//reg [3:0]               hprotm3;
//reg [3:0]               hprotm4;
//reg [32-1:0]            hrdatas0;
//reg [32-1:0]            hrdatas1;
//reg [32-1:0]            hrdatas2;
//reg [32-1:0]            hrdatas3;
//reg [32-1:0]            hrdatas4;
//reg [32-1:0]            hrdatas5;
//reg [32-1:0]            hrdatas6;
//reg                     hreadymuxm0;
//reg                     hreadymuxm1;
//reg                     hreadymuxm2;
//reg                     hreadymuxm3;
//reg                     hreadymuxm4;
//reg                     hreadyouts0;
//reg                     hreadyouts1;
//reg                     hreadyouts2;
//reg                     hreadyouts3;
//reg                     hreadyouts4;
//reg                     hreadyouts5;
//reg                     hreadyouts6;
//reg [1:0]               hresps0;
//reg [1:0]               hresps1;
//reg [1:0]               hresps2;
//reg [1:0]               hresps3;
//reg [1:0]               hresps4;
//reg [1:0]               hresps5;
//reg [1:0]               hresps6;
//reg                     hselm0;
//reg                     hselm1;
//reg                     hselm2;
//reg                     hselm3;
//reg                     hselm4;
//reg [2:0]               hsizem0;
//reg [2:0]               hsizem1;
//reg [2:0]               hsizem2;
//reg [2:0]               hsizem3;
//reg [2:0]               hsizem4;
//reg [1:0]               htransm0;
//reg [1:0]               htransm1;
//reg [1:0]               htransm2;
//reg [1:0]               htransm3;
//reg [1:0]               htransm4;
//reg [32-1:0]            hwdatam0;
//reg [32-1:0]            hwdatam1;
//reg [32-1:0]            hwdatam2;
//reg [32-1:0]            hwdatam3;
//reg [32-1:0]            hwdatam4;
//reg                     hwritem0;
//reg                     hwritem1;
//reg                     hwritem2;
//reg                     hwritem3;
//reg                     hwritem4;
// End of automatics
wire  [7 * 32-  1: 0] haddr_2_master_if;
wire  [7 * 2 - 1 : 0] htran_2_master_if;
wire  [7 - 1     : 0] hwrite_2_master_if;
wire  [7 * 3 - 1 : 0] hsize_2_master_if;
wire  [7 * 3 - 1 : 0] hburst_2_master_if;
wire  [7 * 4 - 1 : 0] hprot_2_master_if;
wire  [7 - 1     : 0] hready_2_master_if;
wire  [7 * 32 - 1: 0] hwdata_2_master_if;
wire  [5 * 2 - 1 : 0] s_hresp_from_all_slave;
wire  [5 - 1     : 0] s_hready_from_all_slave;
wire  [5 * 32 - 1: 0] s_hrdata_from_all_slave;
wire  [7 - 1     : 0] req_2_m0;
wire  [7 - 1     : 0] req_2_m1;
wire  [7 - 1     : 0] req_2_m2;
wire  [7 - 1     : 0] req_2_m3;
wire  [7 - 1     : 0] req_2_m4;
wire  [7 - 1     : 0] gnt_from_m0;
wire  [7 - 1     : 0] gnt_from_m1;
wire  [7 - 1     : 0] gnt_from_m2;
wire  [7 - 1     : 0] gnt_from_m3;
wire  [7 - 1     : 0] gnt_from_m4;
wire  [5 - 1     : 0] req_from_s0;
wire  [5 - 1     : 0] gnt_2_s0;
wire  [5 - 1     : 0] req_from_s1;
wire  [5 - 1     : 0] gnt_2_s1;
wire  [5 - 1     : 0] req_from_s2;
wire  [5 - 1     : 0] gnt_2_s2;
wire  [5 - 1     : 0] req_from_s3;
wire  [5 - 1     : 0] gnt_2_s3;
wire  [5 - 1     : 0] req_from_s4;
wire  [5 - 1     : 0] gnt_2_s4;
wire  [5 - 1     : 0] req_from_s5;
wire  [5 - 1     : 0] gnt_2_s5;
wire  [5 - 1     : 0] req_from_s6;
wire  [5 - 1     : 0] gnt_2_s6;

wire  [32 - 1    : 0] haddr_int_s0;
wire  [1         : 0] htrans_int_s0;
wire                  hwrite_int_s0;
wire  [2         : 0] hsize_int_s0;
wire  [2         : 0] hburst_int_s0;
wire  [3         : 0] hprot_int_s0;

wire  [32 - 1    : 0] haddr_int_s1;
wire  [1         : 0] htrans_int_s1;
wire                  hwrite_int_s1;
wire  [2         : 0] hsize_int_s1;
wire  [2         : 0] hburst_int_s1;
wire  [3         : 0] hprot_int_s1;

wire  [32 - 1    : 0] haddr_int_s2;
wire  [1         : 0] htrans_int_s2;
wire                  hwrite_int_s2;
wire  [2         : 0] hsize_int_s2;
wire  [2         : 0] hburst_int_s2;
wire  [3         : 0] hprot_int_s2;

wire  [32 - 1    : 0] haddr_int_s3;
wire  [1         : 0] htrans_int_s3;
wire                  hwrite_int_s3;
wire  [2         : 0] hsize_int_s3;
wire  [2         : 0] hburst_int_s3;
wire  [3         : 0] hprot_int_s3;

wire  [32 - 1    : 0] haddr_int_s4;
wire  [1         : 0] htrans_int_s4;
wire                  hwrite_int_s4;
wire  [2         : 0] hsize_int_s4;
wire  [2         : 0] hburst_int_s4;
wire  [3         : 0] hprot_int_s4;

wire  [32 - 1    : 0] haddr_int_s5;
wire  [1         : 0] htrans_int_s5;
wire                  hwrite_int_s5;
wire  [2         : 0] hsize_int_s5;
wire  [2         : 0] hburst_int_s5;
wire  [3         : 0] hprot_int_s5;

wire  [32 - 1    : 0] haddr_int_s6;
wire  [1         : 0] htrans_int_s6;
wire                  hwrite_int_s6;
wire  [2         : 0] hsize_int_s6;
wire  [2         : 0] hburst_int_s6;
wire  [3         : 0] hprot_int_s6;

wire                  hready_from_m0;
wire  [1         : 0] hresp_from_m0;

wire                  hready_from_m1;
wire  [1         : 0] hresp_from_m1;

wire                  hready_from_m2;
wire  [1         : 0] hresp_from_m2;

wire                  hready_from_m3;
wire  [1         : 0] hresp_from_m3;

wire                  hready_from_m4;
wire  [1         : 0] hresp_from_m4;

//****************************************************************************
//Instance Declaration.
//****************************************************************************
slave_if  slave_if_inst0(
   // input ports
   .hclk(hclk),
   .hresetn(hresetn),
   .hsel(hsels0),
   .haddr(haddrs0),
   .htrans(htranss0),
   .hwrite(hwrites0),
   .hsize(hsizes0),
   .hburst(hbursts0),
   .hprot(hprots0),
   .hready(hreadys0),
   .gnt(gnt_2_s0[5 - 1 : 0]),   // From master interface
   .s_hresp_from_all_slave(s_hresp_from_all_slave),  // From master interface
   .s_hready_from_all_slave(s_hready_from_all_slave),  // From master interface
   .s_hrdata_from_all_slave(s_hrdata_from_all_slave),
   // output ports
   .hresp_out(hresps0),
   .hready_out(hreadyouts0),
   .hrdata_out(hrdatas0),
   .haddr_int(haddr_int_s0),
   .htrans_int(htrans_int_s0),
   .hwrite_int(hwrite_int_s0),
   .hsize_int(hsize_int_s0),
   .hburst_int(hburst_int_s0),
   .hprot_int(hprot_int_s0),
   .req(req_from_s0)
);

slave_if slave_if_inst1(
   // input ports
   .hclk(hclk),
   .hresetn(hresetn),
   .hsel(hsels1),
   .haddr(haddrs1),
   .htrans(htranss1),
   .hwrite(hwrites1),
   .hsize(hsizes1),
   .hburst(hbursts1),
   .hprot(hprots1),
   .hready(hreadys1),
   .gnt(gnt_2_s1[5 - 1 : 0]),   // From master interface
   .s_hresp_from_all_slave(s_hresp_from_all_slave),  // From master interface
   .s_hready_from_all_slave(s_hready_from_all_slave),  // From master interface
   .s_hrdata_from_all_slave(s_hrdata_from_all_slave),
   // output ports
   .hresp_out(hresps1),
   .hready_out(hreadyouts1),
   .hrdata_out(hrdatas1),
   .haddr_int(haddr_int_s1),
   .htrans_int(htrans_int_s1),
   .hwrite_int(hwrite_int_s1),
   .hsize_int(hsize_int_s1),
   .hburst_int(hburst_int_s1),
   .hprot_int(hprot_int_s1),
   .req(req_from_s1)
);

slave_if slave_if_inst2(
   // input ports
   .hclk(hclk),
   .hresetn(hresetn),
   .hsel(hsels2),
   .haddr(haddrs2),
   .htrans(htranss2),
   .hwrite(hwrites2),
   .hsize(hsizes2),
   .hburst(hbursts2),
   .hprot(hprots2),
   .hready(hreadys2),
   .gnt(gnt_2_s2[5 - 1 : 0]),   // From master interface
   .s_hresp_from_all_slave(s_hresp_from_all_slave),  // From master interface
   .s_hready_from_all_slave(s_hready_from_all_slave),  // From master interface
   .s_hrdata_from_all_slave(s_hrdata_from_all_slave),
   // output ports
   .hresp_out(hresps2),
   .hready_out(hreadyouts2),
   .hrdata_out(hrdatas2),
   .haddr_int(haddr_int_s2),
   .htrans_int(htrans_int_s2),
   .hwrite_int(hwrite_int_s2),
   .hsize_int(hsize_int_s2),
   .hburst_int(hburst_int_s2),
   .hprot_int(hprot_int_s2),
   .req(req_from_s2)

);
slave_if slave_if_inst3(
   // input ports
   .hclk(hclk),
   .hresetn(hresetn),
   .hsel(hsels3),
   .haddr(haddrs3),
   .htrans(htranss3),
   .hwrite(hwrites3),
   .hsize(hsizes3),
   .hburst(hbursts3),
   .hprot(hprots3),
   .hready(hreadys3),
   .gnt(gnt_2_s3[5 - 1 : 0]),   // From master interface
   .s_hresp_from_all_slave(s_hresp_from_all_slave),  // From master interface
   .s_hready_from_all_slave(s_hready_from_all_slave),  // From master interface
   .s_hrdata_from_all_slave(s_hrdata_from_all_slave),
   // output ports
   .hresp_out(hresps3),
   .hready_out(hreadyouts3),
   .hrdata_out(hrdatas3),
   .haddr_int(haddr_int_s3),
   .htrans_int(htrans_int_s3),
   .hwrite_int(hwrite_int_s3),
   .hsize_int(hsize_int_s3),
   .hburst_int(hburst_int_s3),
   .hprot_int(hprot_int_s3),
   .req(req_from_s3)
);

slave_if slave_if_inst4(
   // input ports
   .hclk(hclk),
   .hresetn(hresetn),
   .hsel(hsels4),
   .haddr(haddrs4),
   .htrans(htranss4),
   .hwrite(hwrites4),
   .hsize(hsizes4),
   .hburst(hbursts4),
   .hprot(hprots4),
   .hready(hreadys4),
   .gnt(gnt_2_s4[5 - 1 : 0]),   // From master interface
   .s_hresp_from_all_slave(s_hresp_from_all_slave),  // From master interface
   .s_hready_from_all_slave(s_hready_from_all_slave),  // From master interface
   .s_hrdata_from_all_slave(s_hrdata_from_all_slave),
   // output ports
   .hresp_out(hresps4),
   .hready_out(hreadyouts4),
   .hrdata_out(hrdatas4),
   .haddr_int(haddr_int_s4),
   .htrans_int(htrans_int_s4),
   .hwrite_int(hwrite_int_s4),
   .hsize_int(hsize_int_s4),
   .hburst_int(hburst_int_s4),
   .hprot_int(hprot_int_s4),
   .req(req_from_s4)
);

slave_if slave_if_inst5(
   // input ports
   .hclk(hclk),
   .hresetn(hresetn),
   .hsel(hsels5),
   .haddr(haddrs5),
   .htrans(htranss5),
   .hwrite(hwrites5),
   .hsize(hsizes5),
   .hburst(hbursts5),
   .hprot(hprots5),
   .hready(hreadys5),
   .gnt(gnt_2_s5[5 - 1 : 0]),   // From master interface
   .s_hresp_from_all_slave(s_hresp_from_all_slave),  // From master interface
   .s_hready_from_all_slave(s_hready_from_all_slave),  // From master interface
   .s_hrdata_from_all_slave(s_hrdata_from_all_slave),
   // output ports
   .hresp_out(hresps5),
   .hready_out(hreadyouts5),
   .hrdata_out(hrdatas5),
   .haddr_int(haddr_int_s5),
   .htrans_int(htrans_int_s5),
   .hwrite_int(hwrite_int_s5),
   .hsize_int(hsize_int_s5),
   .hburst_int(hburst_int_s5),
   .hprot_int(hprot_int_s5),
   .req(req_from_s5)
);

slave_if slave_if_inst6(
   // input ports
   .hclk(hclk),
   .hresetn(hresetn),
   .hsel(hsels6),
   .haddr(haddrs6),
   .htrans(htranss6),
   .hwrite(hwrites6),
   .hsize(hsizes6),
   .hburst(hbursts6),
   .hprot(hprots6),
   .hready(hreadys6),
   .gnt(gnt_2_s6[5 - 1 : 0]),   // From master interface
   .s_hresp_from_all_slave(s_hresp_from_all_slave),  // From master interface
   .s_hready_from_all_slave(s_hready_from_all_slave),  // From master interface
   .s_hrdata_from_all_slave(s_hrdata_from_all_slave),
   // output ports
   .hresp_out(hresps6),
   .hready_out(hreadyouts6),
   .hrdata_out(hrdatas6),
   .haddr_int(haddr_int_s6),
   .htrans_int(htrans_int_s6),
   .hwrite_int(hwrite_int_s6),
   .hsize_int(hsize_int_s6),
   .hburst_int(hburst_int_s6),
   .hprot_int(hprot_int_s6),
   .req(req_from_s6)
);

master_if  master_if_inst0(
  // input ports
  .hclk(hclk),
  .hresetn(hresetn),
  .s_haddr(haddr_2_master_if),
  .s_htrans(htran_2_master_if),
  .s_hwrite(hwrite_2_master_if),
  .s_hsize(hsize_2_master_if),
  .s_hburst(hburst_2_master_if),
  .s_hprot(hprot_2_master_if),
  .s_hready(hready_2_master_if),
  .s_req(req_2_m0[7 - 1 : 0]),
  .s_hwdata(hwdata_2_master_if),
  .hready_in_from_slave(hreadyoutm0),
  .hresp_in_from_slave(hrespm0),
  // output ports
  .m_hsel(hselm0),
  .m_haddr(haddrm0),
  .m_htrans(htransm0),
  .m_hwrite(hwritem0),
  .m_hsize(hsizem0),
  .m_hburst(hburstm0),
  .m_hprot(hprotm0),
  .m_hready(hreadymuxm0),
  .m_hwdata(hwdatam0),
  .hready_out_from_slave(hready_from_m0),
  .hresp_from_slave(hresp_from_m0),
  .gnt(gnt_from_m0)
);

master_if master_if_inst1(
  // input ports
  .hclk(hclk),
  .hresetn(hresetn),
  .s_haddr(haddr_2_master_if),
  .s_htrans(htran_2_master_if),
  .s_hwrite(hwrite_2_master_if),
  .s_hsize(hsize_2_master_if),
  .s_hburst(hburst_2_master_if),
  .s_hprot(hprot_2_master_if),
  .s_hready(hready_2_master_if),
  .s_req(req_2_m1[7 - 1 : 0]),
  .s_hwdata(hwdata_2_master_if),
  .hready_in_from_slave(hreadyoutm1),
  .hresp_in_from_slave(hrespm1),
  // output ports
  .m_hsel(hselm1),
  .m_haddr(haddrm1),
  .m_htrans(htransm1),
  .m_hwrite(hwritem1),
  .m_hsize(hsizem1),
  .m_hburst(hburstm1),
  .m_hprot(hprotm1),
  .m_hready(hreadymuxm1),
  .m_hwdata(hwdatam1),
  .hready_out_from_slave(hready_from_m1),
  .hresp_from_slave(hresp_from_m1),
  .gnt(gnt_from_m1)
);

master_if master_if_inst2(
  // input ports
  .hclk(hclk),
  .hresetn(hresetn),
  .s_haddr(haddr_2_master_if),
  .s_htrans(htran_2_master_if),
  .s_hwrite(hwrite_2_master_if),
  .s_hsize(hsize_2_master_if),
  .s_hburst(hburst_2_master_if),
  .s_hprot(hprot_2_master_if),
  .s_hready(hready_2_master_if),
  .s_req(req_2_m2[7 - 1 : 0]),
  .s_hwdata(hwdata_2_master_if),
  .hready_in_from_slave(hreadyoutm2),
  .hresp_in_from_slave(hrespm2),
  // output ports
  .m_hsel(hselm2),
  .m_haddr(haddrm2),
  .m_htrans(htransm2),
  .m_hwrite(hwritem2),
  .m_hsize(hsizem2),
  .m_hburst(hburstm2),
  .m_hprot(hprotm2),
  .m_hready(hreadymuxm2),
  .m_hwdata(hwdatam2),
  .hready_out_from_slave(hready_from_m2),
  .hresp_from_slave(hresp_from_m2),
  .gnt(gnt_from_m2)
);

master_if master_if_inst3(
  // input ports
  .hclk(hclk),
  .hresetn(hresetn),
  .s_haddr(haddr_2_master_if),
  .s_htrans(htran_2_master_if),
  .s_hwrite(hwrite_2_master_if),
  .s_hsize(hsize_2_master_if),
  .s_hburst(hburst_2_master_if),
  .s_hprot(hprot_2_master_if),
  .s_hready(hready_2_master_if),
  .s_req(req_2_m3[7 - 1 : 0]),
  .s_hwdata(hwdata_2_master_if),
  .hready_in_from_slave(hreadyoutm3),
  .hresp_in_from_slave(hrespm3),
  // output ports
  .m_hsel(hselm3),
  .m_haddr(haddrm3),
  .m_htrans(htransm3),
  .m_hwrite(hwritem3),
  .m_hsize(hsizem3),
  .m_hburst(hburstm3),
  .m_hprot(hprotm3),
  .m_hready(hreadymuxm3),
  .m_hwdata(hwdatam3),
  .hready_out_from_slave(hready_from_m3),
  .hresp_from_slave(hresp_from_m3),
  .gnt(gnt_from_m3)
);

master_if master_if_inst4(
  // input ports
  .hclk(hclk),
  .hresetn(hresetn),
  .s_haddr(haddr_2_master_if),
  .s_htrans(htran_2_master_if),
  .s_hwrite(hwrite_2_master_if),
  .s_hsize(hsize_2_master_if),
  .s_hburst(hburst_2_master_if),
  .s_hprot(hprot_2_master_if),
  .s_hready(hready_2_master_if),
  .s_req(req_2_m4[7 - 1 : 0]),
  .s_hwdata(hwdata_2_master_if),
  .hready_in_from_slave(hreadyoutm4),
  .hresp_in_from_slave(hrespm4),
  // output ports
  .m_hsel(hselm4),
  .m_haddr(haddrm4),
  .m_htrans(htransm4),
  .m_hwrite(hwritem4),
  .m_hsize(hsizem4),
  .m_hburst(hburstm4),
  .m_hprot(hprotm4),
  .m_hready(hreadymuxm4),
  .m_hwdata(hwdatam4),
  .hready_out_from_slave(hready_from_m4),
  .hresp_from_slave(hresp_from_m4),
  .gnt(gnt_from_m4)
);

//****************************************************************************
//Function Declaration.
//****************************************************************************
assign haddr_2_master_if[32 - 1 : 0] = haddr_int_s0;
assign htran_2_master_if[1 : 0] = htrans_int_s0;
assign hwrite_2_master_if[0] = hwrite_int_s0;
assign hsize_2_master_if[2 : 0] = hsize_int_s0;
assign hburst_2_master_if[2 : 0] = hburst_int_s0;
assign hprot_2_master_if[3 : 0] = hprot_int_s0;
assign hready_2_master_if[0] = hreadys0;
assign hwdata_2_master_if[32 - 1 : 0] = hwdatas0;
assign gnt_2_s0 = {gnt_from_m4[0], gnt_from_m3[0], gnt_from_m2[0], gnt_from_m1[0], gnt_from_m0[0] };

assign haddr_2_master_if[2 * 32 - 1 : 32] = haddr_int_s1;
assign htran_2_master_if[2 * 2 - 1 : 2] = htrans_int_s1;
assign hwrite_2_master_if[1] = hwrite_int_s1;
assign hsize_2_master_if[2 * 3 - 1: 3] = hsize_int_s1;
assign hburst_2_master_if[2 * 3  - 1: 3] = hburst_int_s1;
assign hprot_2_master_if[2 * 4 - 1 : 4] = hprot_int_s1;
assign hready_2_master_if[1] = hreadys1;
assign hwdata_2_master_if[2 * 32 - 1 : 32] = hwdatas1;
assign gnt_2_s1 = {gnt_from_m4[1], gnt_from_m3[1], gnt_from_m2[1], gnt_from_m1[1], gnt_from_m0[1] };

assign haddr_2_master_if[3 * 32 - 1 : 2 * 32] = haddr_int_s2;
assign htran_2_master_if[3 * 2 - 1 : 2 * 2] = htrans_int_s2;
assign hwrite_2_master_if[2] = hwrite_int_s2;
assign hsize_2_master_if[3 * 3 - 1: 2 * 3] = hsize_int_s2;
assign hburst_2_master_if[3 * 3  - 1: 2 * 3] = hburst_int_s2;
assign hprot_2_master_if[3 * 4 - 1 : 2 * 4] = hprot_int_s2;
assign hready_2_master_if[2] = hreadys2;
assign hwdata_2_master_if[3 * 32 - 1 : 2 * 32] = hwdatas2;
assign gnt_2_s2 = {gnt_from_m4[2], gnt_from_m3[2], gnt_from_m2[2], gnt_from_m1[2], gnt_from_m0[2] };

assign haddr_2_master_if[4 * 32 - 1: 3 * 32] = haddr_int_s3;
assign htran_2_master_if[4 * 2 - 1 : 3 * 2] = htrans_int_s3;
assign hwrite_2_master_if[3] = hwrite_int_s3;
assign hsize_2_master_if[4 * 3 - 1: 3 * 3] = hsize_int_s3;
assign hburst_2_master_if[4 * 3  - 1: 3 * 3] = hburst_int_s3;
assign hprot_2_master_if[4 * 4 - 1 : 3 * 4] = hprot_int_s3;
assign hready_2_master_if[3] = hreadys3;
assign hwdata_2_master_if[4 * 32 - 1 : 3 * 32] = hwdatas3;
assign gnt_2_s3 = {gnt_from_m4[3], gnt_from_m3[3], gnt_from_m2[3], gnt_from_m1[3], gnt_from_m0[3] };

assign haddr_2_master_if[5 * 32 - 1: 4 * 32] = haddr_int_s4;
assign htran_2_master_if[5 * 2 - 1 : 4 * 2] = htrans_int_s4;
assign hwrite_2_master_if[4] = hwrite_int_s4;
assign hsize_2_master_if[5 * 3 - 1: 4 * 3] = hsize_int_s4;
assign hburst_2_master_if[5 * 3  - 1: 4 * 3] = hburst_int_s4;
assign hprot_2_master_if[5 * 4 - 1 : 4 * 4] = hprot_int_s4;
assign hready_2_master_if[4] = hreadys4;
assign hwdata_2_master_if[5 * 32 - 1 : 4 * 32] = hwdatas4;
assign gnt_2_s4 = {gnt_from_m4[4], gnt_from_m3[4], gnt_from_m2[4], gnt_from_m1[4], gnt_from_m0[4] };

assign haddr_2_master_if[6 * 32 - 1: 5 * 32] = haddr_int_s5;
assign htran_2_master_if[6 * 2 - 1 : 5 * 2] = htrans_int_s5;
assign hwrite_2_master_if[5] = hwrite_int_s5;
assign hsize_2_master_if[6 * 3 - 1: 5 * 3] = hsize_int_s5;
assign hburst_2_master_if[6 * 3  - 1: 5 * 3] = hburst_int_s5;
assign hprot_2_master_if[6 * 4 - 1 : 5 * 4] = hprot_int_s5;
assign hready_2_master_if[5] = hreadys5;
assign hwdata_2_master_if[6 * 32 - 1 : 5 * 32] = hwdatas5;
assign gnt_2_s5 = {gnt_from_m4[5], gnt_from_m3[5], gnt_from_m2[5], gnt_from_m1[5], gnt_from_m0[5] };

assign haddr_2_master_if[7 * 32 - 1: 6 * 32] = haddr_int_s6;
assign htran_2_master_if[7 * 2 - 1 : 6 * 2] = htrans_int_s6;
assign hwrite_2_master_if[6] = hwrite_int_s6;
assign hsize_2_master_if[7 * 3 - 1: 6 * 3] = hsize_int_s6;
assign hburst_2_master_if[7 * 3  - 1: 6 * 3] = hburst_int_s6;
assign hprot_2_master_if[7 * 4 - 1 : 6 * 4] = hprot_int_s6;
assign hready_2_master_if[6] = hreadys6;
assign hwdata_2_master_if[7 * 32 - 1 : 6 * 32] = hwdatas6;
assign gnt_2_s6 = {gnt_from_m4[6], gnt_from_m3[6], gnt_from_m2[6], gnt_from_m1[6], gnt_from_m0[6] };

assign hmastlackm0 = 0;
assign hmasterm0 = 4'b0;
assign s_hresp_from_all_slave[1 : 0]   =  hresp_from_m0;
assign s_hready_from_all_slave[0]  = hready_from_m0;
assign s_hrdata_from_all_slave[32 - 1 : 0]   = hrdatam0;
assign req_2_m0 = {req_from_s6[0], req_from_s5[0], req_from_s4[0], req_from_s3[0], req_from_s2[0], req_from_s1[0], req_from_s0[0] };

assign hmastlackm1 = 0;
assign hmasterm1 = 4'b0;
assign s_hresp_from_all_slave[2 * 2 - 1 : 2]   =  hresp_from_m1;
assign s_hready_from_all_slave[1]  = hready_from_m1;
assign s_hrdata_from_all_slave[2 * 32 - 1 : 32]   = hrdatam1;
assign req_2_m1 = {req_from_s6[1], req_from_s5[1], req_from_s4[1], req_from_s3[1], req_from_s2[1], req_from_s1[1], req_from_s0[1] };

assign hmastlackm2 = 0;
assign hmasterm2 = 4'b0;
assign s_hresp_from_all_slave[3 * 2 - 1 : 2 * 2]   =  hresp_from_m2;
assign s_hready_from_all_slave[2]  = hready_from_m2;
assign s_hrdata_from_all_slave[3 * 32 - 1 : 2 * 32]   = hrdatam2;
assign req_2_m2 = {req_from_s6[2], req_from_s5[2], req_from_s4[2], req_from_s3[2], req_from_s2[2], req_from_s1[2], req_from_s0[2] };

assign hmastlackm3 = 0;
assign hmasterm3 = 4'b0;
assign s_hresp_from_all_slave[4 * 2 - 1 : 3 * 2]   =  hresp_from_m3;
assign s_hready_from_all_slave[3]  = hready_from_m3;
assign s_hrdata_from_all_slave[4 * 32 - 1 : 3 * 32]   = hrdatam3;
assign req_2_m3 = {req_from_s6[3], req_from_s5[3], req_from_s4[3], req_from_s3[3], req_from_s2[3], req_from_s1[3], req_from_s0[3] };

assign hmastlackm4 = 0;
assign hmasterm4 = 4'b0;
assign s_hresp_from_all_slave[5 * 2 - 1 : 4 * 2]   =  hresp_from_m4;
assign s_hready_from_all_slave[4]  = hready_from_m4;
assign s_hrdata_from_all_slave[5 * 32 - 1 : 4 * 32]   = hrdatam4;
assign req_2_m4 = {req_from_s6[4], req_from_s5[4], req_from_s4[4], req_from_s3[4], req_from_s2[4], req_from_s1[4], req_from_s0[4] };


endmodule
