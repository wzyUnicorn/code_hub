module cnn(

    // AHB master interface  connect to cnn
    input                clk,
    input                rstn,
  //  output               hsel,
    output logic    [31:0] haddr,
    output logic    [ 1:0] htrans,
    output logic    [ 2:0] hsize,
    output logic           hwrite,
    output logic    [31:0] hwdata,
  //  output               hready,
    input           [31:0] hrdata,
    input                  hready,
    input            [1:0] hresp,

    //from csr
    input start,
    input clear,
    input [2:0 ] mode,
    input [15:0] pool_count,// half of total
    input [15:0] conv_count,// half of total
    input [15:0] line_count,// total

    input din_dma_en,
    input dout_dma_en,
    input [31:0] dma_src_addr,
    input [31:0] dma_dst_addr,
    // SRAM
    output logic ce_o,
    output logic we_o,
    output logic [12:0] addr_o,
    output logic [7 :0] wdata_o,
    input [7:0] rdata,
    // done and result
    output done,
    output overflow,
    output underflow,
    output result
);

// State Defination
parameter IDLE               =5'h00;
parameter CONV_CAB1_FETCH    =5'h01;// core 1 and bias 1 fetch
parameter CONV_CAB2_FETCH    =5'h02;
parameter CONV_DATA_FETCH    =5'h03;
parameter CONV_CAL           =5'h04;
parameter CONV_WBACK1        =5'h05;// write core 1 and bias 1's result
parameter CONV_WBACK2        =5'h06;// write core 2 and bias 2's result
parameter CONV_1_DONE        =5'h07;
parameter CONV_2_DONE        =5'h08;
parameter CONV_DONE          =5'h09;
parameter POOL_FETCH         =5'h0a;
parameter POOL_CAL           =5'h0b;
parameter POOL_WBACK         =5'h0c;
parameter POOL_DONE          =5'h0d;
parameter LINE_WEIGHT_FETCH  =5'h0e;
parameter LINE_DATA_FETCH    =5'h0f;
parameter LINE_CAL           =5'h10;
parameter LINE_BIAS1_FETCH   =5'h11;
parameter LINE_BIAS2_FETCH   =5'h12;
parameter LINE_DONE          =5'h13;
parameter TOTAL_DONE         =5'h14;

// DATA segment in SRAM
parameter ADDR_SRC_DATA       =13'd0;    // 1024
parameter ADDR_AC1_DATA       =13'd1024; // 900 after convlution of core 1
parameter ADDR_AC2_DATA       =13'd1924; // 900 of core 2
parameter ADDR_AP_DATA        =13'd2824; // 450 after pool
//parameter ADDR_AL_DATA        =13'd3274; // 2 after line
parameter ADDR_FINAL_RES      =13'd3274; // 1 result
// PARAMETER segment in SRAM
parameter ADDR_CONV_CB1       =13'd3276; // 10 core and bias
parameter ADDR_CONV_CB2       =13'd3286; // 10
parameter ADDR_LINE_WEIGHT    =13'd3296; // 900
parameter ADDR_LINE_BIAS      =13'd4196; // 2

reg  [4:0] cs; // current state
logic [4:0] ns; // next state

// for dma
// assign hsize=3'h0;
reg [ 7:0] dma_data_buf; // store data
reg [15:0] dma_wr_cnt; // external
reg [15:0] dma_rd_cnt; // external
parameter DMA_WR_CNT=16'd2251; // number of write result after every step
parameter DMA_RD_CNT=16'd1946; // number of read source data and parameter

parameter DMA_IDLE=5'h0;
// Read data from external to SRAM process
parameter DMA_READ_AHB_1  =5'h1;
parameter DMA_READ_AHB_2  =5'h2;
parameter DMA_READ_AHB_3  =5'h3; //cnt
parameter DMA_WSRAM_1     =5'h4;
parameter DMA_WSRAM_2     =5'h5;
// Sleep wait done  wait
parameter DMA_SLEEP       =5'h6;
//Write data from SRAM to external process
parameter DMA_RSRAM_1     =5'h7;
parameter DMA_RSRAM_2     =5'h8;
parameter DMA_WRITE_AHB_1 =5'h9;
parameter DMA_WRITE_AHB_2 =5'ha;
parameter DMA_WRITE_AHB_3 =5'hb; //cnt
parameter DMA_DONE        =5'hc;

reg  [4:0] dma_cs;
logic [4:0] dma_ns;
// dma connect with sram
logic dma_ce;
logic dma_we;
logic [12:0] dma_addr;
logic [ 7:0] dma_wdata;

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        dma_data_buf<='d0;
    else if(dma_cs==DMA_READ_AHB_2)begin
        if(hready && hresp==2'b00)
            dma_data_buf<=hrdata[7:0];
        else
            dma_data_buf<='d0;
    end
    else if(dma_cs==DMA_RSRAM_1)begin
        dma_data_buf<=rdata;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)begin
        dma_wr_cnt<='d0;
    end
    else if(done)
        dma_wr_cnt<='d0;
    else begin 
        if(dma_cs==DMA_WRITE_AHB_2 && hready)
            dma_wr_cnt<=dma_wr_cnt+1;
        else
            dma_wr_cnt<=dma_wr_cnt;
    end
end

assign underflow=dma_wr_cnt>DMA_WR_CNT;

always@(posedge clk or negedge rstn)begin
    if(!rstn)begin
        dma_rd_cnt<='d0;
    end
    else if(done)
        dma_rd_cnt<='d0;
    else begin
        if(dma_cs==DMA_READ_AHB_2 && hready && hresp==2'b00)
            dma_rd_cnt<=dma_rd_cnt+1;
        else
            dma_rd_cnt<=dma_rd_cnt;
    end
end
assign overflow=dma_rd_cnt>DMA_RD_CNT;

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        dma_cs<='d0;
    else 
        dma_cs<=dma_ns;
end

always_comb begin
    dma_ns=DMA_IDLE;
    case(dma_cs)
        DMA_IDLE:begin
            if(start)begin
                if(din_dma_en)
                    dma_ns=DMA_READ_AHB_1;
                else
                    dma_ns=DMA_SLEEP;
            end
            else begin
                dma_ns=DMA_IDLE;
            end
        end
        DMA_READ_AHB_1:begin
            dma_ns=DMA_READ_AHB_2;
        end
        /*
        DMA_READ_AHB_2:begin
            if(hready && hresp==2'b00)
                dma_ns=DMA_READ_AHB_3;
            else
                dma_ns=DMA_READ_AHB_2;
        end
        */
        DMA_READ_AHB_2:begin
            if(hready && hresp==2'b00)
                dma_ns=DMA_WSRAM_1;
            else
                dma_ns=DMA_READ_AHB_2;
        end
        DMA_WSRAM_1:begin
            dma_ns=DMA_WSRAM_2;
        end
        DMA_WSRAM_2:begin
            if(dma_rd_cnt<DMA_RD_CNT)  // it can still jump once when less
                dma_ns=DMA_READ_AHB_1;
            else
                dma_ns=DMA_SLEEP;
        end

        DMA_SLEEP:begin
            if(cs==TOTAL_DONE)begin
                if(dout_dma_en)
                    dma_ns=DMA_RSRAM_1;
                else
                    dma_ns=DMA_DONE;
            end
            else 
                dma_ns=DMA_SLEEP;
        end

        DMA_RSRAM_1:begin
            dma_ns=DMA_RSRAM_2;
        end
        DMA_RSRAM_2:begin
            dma_ns=DMA_WRITE_AHB_1;
        end
        DMA_WRITE_AHB_1:begin
            dma_ns=DMA_WRITE_AHB_2;
        end
        /*
        DMA_WRITE_AHB_2:begin
            dma_ns=DMA_WRITE_AHB_3;
        end
        */
        DMA_WRITE_AHB_2:begin
            if(hready)begin
                if(dma_wr_cnt<DMA_WR_CNT-1) // due to same time
                    dma_ns=DMA_RSRAM_1;
                else
                    dma_ns=DMA_DONE;
            end
            else
                dma_ns=DMA_WRITE_AHB_2;
        end
        DMA_DONE:begin
            dma_ns=DMA_IDLE;
            //dma_ns=DMA_DONE;
        end
    endcase
end

always_comb begin
    haddr  =32'h0;
    htrans =2'b10;
    hsize  =3'b000;
    hwrite =1'b0;
    hwdata =32'd0;
    if(dma_cs==DMA_READ_AHB_1 || dma_cs==DMA_READ_AHB_2)begin
        haddr  =dma_src_addr+dma_rd_cnt;
        htrans =2'b10;
        hsize  =3'b000;
        hwrite =1'b0;
        //hwdata =32'd0;
    end
    else if(dma_cs==DMA_WRITE_AHB_1)begin
        haddr  =dma_dst_addr+dma_wr_cnt;
        htrans =2'b10;
        hsize  =3'b000;
        hwrite =1'b1;
        //hwdata =dma_data;
    end
    else if(dma_cs==DMA_WRITE_AHB_2)begin
        haddr  =dma_dst_addr+dma_wr_cnt;
        htrans =2'b10;
        hsize  =3'b000;
        hwrite =1'b1;
        hwdata =dma_data_buf;
    end
end

// write and read from sram
always_comb begin
   dma_ce     = 1'b0;
   dma_we     = 1'b1;
   dma_addr   = 13'd0;
   dma_wdata  = 8'd0;
   if(dma_cs==DMA_WSRAM_1 || dma_cs==DMA_WSRAM_2)begin
       if(dma_rd_cnt<=16'd1023)begin
         dma_ce     = 1'b1;
         dma_we     = 1'b0;
         dma_addr   = ADDR_SRC_DATA+dma_rd_cnt-1;
         dma_wdata  = dma_data_buf;
       end
       else begin
         dma_ce     = 1'b1;
         dma_we     = 1'b0;
         dma_addr   = ADDR_CONV_CB1+(dma_rd_cnt-16'd1024-1);
         dma_wdata  = dma_data_buf;
       end
   end
   else if(dma_cs==DMA_RSRAM_1 || dma_cs==DMA_RSRAM_2)begin
       dma_ce     = 1'b1;
       dma_we     = 1'b1;
       dma_addr   = ADDR_AC1_DATA+dma_wr_cnt;
       //dma_wdata  = dma_data_buf;
   end
end

// end for dma

/*
// State Defination
parameter IDLE               =5'h00;
parameter CONV_CAB1_FETCH    =5'h01;// core 1 and bias 1 fetch
parameter CONV_CAB2_FETCH    =5'h02;
parameter CONV_DATA_FETCH    =5'h03;
parameter CONV_CAL           =5'h04;
parameter CONV_WBACK1        =5'h05;// write core 1 and bias 1's result
parameter CONV_WBACK2        =5'h06;// write core 2 and bias 2's result
parameter CONV_1_DONE        =5'h07;
parameter CONV_2_DONE        =5'h08;
parameter CONV_DONE          =5'h09;
parameter POOL_FETCH         =5'h0a;
parameter POOL_CAL           =5'h0b;
parameter POOL_WBACK         =5'h0c;
parameter POOL_DONE          =5'h0d;
parameter LINE_WEIGHT_FETCH  =5'h0e;
parameter LINE_DATA_FETCH    =5'h0f;
parameter LINE_CAL           =5'h10;
parameter LINE_BIAS1_FETCH   =5'h11;
parameter LINE_BIAS2_FETCH   =5'h12;
parameter LINE_DONE          =5'h13;
parameter TOTAL_DONE         =5'h14;

// DATA segment in SRAM
parameter ADDR_SRC_DATA       =13'd0;    // 1024
parameter ADDR_AC1_DATA       =13'd1024; // 900 after convlution of core 1
parameter ADDR_AC2_DATA       =13'd1924; // 900 of core 2
parameter ADDR_AP_DATA        =13'd2824; // 450 after pool
//parameter ADDR_AL_DATA        =13'd3274; // 2 after line
parameter ADDR_FINAL_RES      =13'd3274; // 1 result
// PARAMETER segment in SRAM
parameter ADDR_CONV_CB1       =13'd3276; // 10 core and bias
parameter ADDR_CONV_CB2       =13'd3286; // 10
parameter ADDR_LINE_WEIGHT    =13'd3296; // 900
parameter ADDR_LINE_BIAS      =13'd4196; // 2

*/

wire [7 :0] col_cnt=conv_count[7 :0];
wire [7 :0] raw_cnt=conv_count[15:8];
wire [15:0] conv_mul_cnt=col_cnt*raw_cnt;

wire [7:0] conv_out;
wire [7:0] pool_out;

wire final_res_kind;

//reg  [4:0] cs; // current state
//logic [4:0] ns; // next state

logic ce;
logic we;
logic [12:0] addr;
logic [7 :0] wdata;

assign ce_o    = (cs==IDLE || cs==TOTAL_DONE) ? dma_ce : ce;
assign we_o    = (cs==IDLE || cs==TOTAL_DONE) ? dma_we : we;
assign addr_o  = (cs==IDLE || cs==TOTAL_DONE) ? dma_addr : addr;
assign wdata_o = (cs==IDLE || cs==TOTAL_DONE) ? dma_wdata : wdata;


//-------------------------------------//
//-------sram contrl signal------------//
//-------------------------------------//
reg [4:0] fetch_cnt;
reg wr_cnt;// write and read sram need 2 cycle,so there need a wr_cnt
reg [15:0] conv_exe_cnt; // record conv count
// conv_exe_cnt record 2'core count,so it's 2 times conv_count
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        conv_exe_cnt<='d0;
    else if(done)
        conv_exe_cnt<='d0;
    else if(conv_exe_cnt==(conv_mul_cnt<<1))
        conv_exe_cnt<='d0;
    else if(cs==CONV_CAB2_FETCH)
        conv_exe_cnt<=conv_mul_cnt;
    else
        conv_exe_cnt<=conv_exe_cnt+((cs==CONV_WBACK1 || cs==CONV_WBACK2) && (ns==CONV_DATA_FETCH));
end

// 2's core need 2's times pool_count,if use 1 cnt,there exists some question
reg [15:0] pool_exe_cnt;
reg [7:0] pool_line_cnt; // last one can't be the start
wire pool_flag=(pool_line_cnt==(col_cnt-2)>>1);
reg [15:0] pool_true_cnt;

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        pool_true_cnt<='d0;
    else if(done)
        pool_true_cnt<='d0;
    else if(pool_true_cnt==(pool_count<<1))
        pool_true_cnt<='d0;
    else
        pool_true_cnt<=pool_true_cnt+(cs==POOL_WBACK && wr_cnt==1'b1);
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        pool_exe_cnt<='d0;
    else if(done)
        pool_exe_cnt<='d0;
   // else if(pool_exe_cnt==(pool_count<<2))
   //     pool_exe_cnt<='d0;
    else if(cs==POOL_WBACK && wr_cnt==1'b1)begin
        if(pool_flag)
            pool_exe_cnt<=pool_exe_cnt+((col_cnt+2)>>1);
        else
            pool_exe_cnt<=pool_exe_cnt+1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        pool_line_cnt<='d0;
    else if(done)
        pool_line_cnt<='d0;
    else if(cs==POOL_WBACK && wr_cnt==1'b1)begin
        if(pool_line_cnt==((col_cnt-2)>>1))
            pool_line_cnt<='d0;
        else
        pool_line_cnt<=pool_line_cnt+1;
    end
end

// line's count directly use total number
reg [15:0] line_exe_cnt; 
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        line_exe_cnt<='d0;
    else if(done)
        line_exe_cnt<='d0;
    else if(line_exe_cnt==(line_count<<2)-1)
        line_exe_cnt<='d0;
    else
        line_exe_cnt<=line_exe_cnt+(cs==LINE_CAL);
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        wr_cnt<=1'b0;
    else if(done)
        wr_cnt<=1'b0;
    else if(cs==IDLE && ns==CONV_CAB1_FETCH)
        wr_cnt<=1'b0; 
    else if(cs==CONV_1_DONE && ns==CONV_CAB2_FETCH)
        wr_cnt<=1'b0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH || cs==CONV_WBACK1 || cs==CONV_WBACK2) && ns==CONV_DATA_FETCH)
        wr_cnt<=1'b0; 
    else if(cs==CONV_CAL && (ns==CONV_WBACK1 || ns==CONV_WBACK2))
        wr_cnt<=1'b0;
    else if((cs==CONV_DONE || cs==POOL_WBACK) && ns==POOL_FETCH)
        wr_cnt<=1'b0;
    else if(cs==POOL_CAL && ns==POOL_WBACK)
        wr_cnt<=1'b0;
    else if((cs==POOL_DONE || cs==LINE_CAL) && ns==LINE_WEIGHT_FETCH)
        wr_cnt<=1'b0;
    else if((cs==LINE_WEIGHT_FETCH && ns==LINE_DATA_FETCH)||(cs==LINE_CAL && ns==LINE_BIAS1_FETCH)||(cs==LINE_BIAS1_FETCH && ns==LINE_BIAS2_FETCH)||(cs==LINE_BIAS2_FETCH && ns==LINE_DONE))
        wr_cnt<=1'b0;
    else if(cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH || cs==CONV_DATA_FETCH || cs==POOL_FETCH || cs==LINE_WEIGHT_FETCH || cs==LINE_DATA_FETCH || cs==CONV_WBACK1 || cs==CONV_WBACK2 || cs==POOL_WBACK || cs==LINE_BIAS1_FETCH || cs==LINE_BIAS2_FETCH || cs==LINE_DONE)begin
        wr_cnt<=wr_cnt+1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        fetch_cnt<='d0;
    else if(done)
        fetch_cnt<='d0;
    else if(cs==IDLE && ns==CONV_CAB1_FETCH)
        fetch_cnt<=5'd10;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_WBACK1 || cs==CONV_CAB2_FETCH || cs==CONV_WBACK2) && ns==CONV_DATA_FETCH)
        fetch_cnt<=5'd9;
    else if(cs==CONV_1_DONE && ns==CONV_CAB2_FETCH)
        fetch_cnt<=5'd10;
    else if((cs==CONV_DONE || cs==POOL_WBACK) && ns==POOL_FETCH)
        fetch_cnt<=5'd4;
    else if((cs==POOL_DONE || cs==LINE_CAL) && ns==LINE_WEIGHT_FETCH)
        fetch_cnt<=5'd1;
    else if(cs==LINE_WEIGHT_FETCH && ns==LINE_DATA_FETCH)
        fetch_cnt<=5'd1;
    else if(cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH || cs==CONV_DATA_FETCH || cs==POOL_FETCH || cs==LINE_WEIGHT_FETCH || cs==LINE_DATA_FETCH)begin
        fetch_cnt<=fetch_cnt-(wr_cnt==1'b1);
    end
end

reg [7:0] col_exe_cnt;
reg [7:0] raw_exe_cnt;
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        col_exe_cnt<='d0;
    else if(done)
        col_exe_cnt<='d0;
    else if((col_exe_cnt==(col_cnt-1) && (((cs==CONV_WBACK1 || cs==CONV_WBACK2) && wr_cnt==1'b0))))
        col_exe_cnt<='d0;
    else
        col_exe_cnt<=col_exe_cnt+((cs==CONV_WBACK1 || cs==CONV_WBACK2) && wr_cnt==1'b0);
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        raw_exe_cnt<='d0;
    else if(done)
        raw_exe_cnt<='d0;
    else if((raw_exe_cnt==(raw_cnt-1)) && (col_exe_cnt==(col_cnt-1)) && (fetch_cnt==0) && (cs==CONV_1_DONE))
    //else if((raw_exe_cnt==(raw_cnt-1)) && (cs==CONV_CAB2_FETCH))
        raw_exe_cnt<='d0;
    else if(cs==CONV_CAB2_FETCH)
        raw_exe_cnt<='d0;
    else
        raw_exe_cnt<=raw_exe_cnt+((col_exe_cnt==(col_cnt-1) && (((cs==CONV_WBACK1 || cs==CONV_WBACK2) && wr_cnt==1'b0))));
end

wire [9:0] true_num; // some point can't fetch as start of 3,3 pattern
assign true_num=raw_exe_cnt*32+col_exe_cnt;

always_comb begin
    if(!rstn)begin
        ce   = 1'b0;
        we   = 1'b1;
        addr = 13'd0;
        wdata  = 8'd0;
    end
    else if(cs==CONV_CAB1_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        addr = ADDR_CONV_CB1-fetch_cnt+13'd10;
    end
    else if(cs==CONV_CAB2_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        addr = ADDR_CONV_CB2-fetch_cnt+13'd10;
    end
    else if(cs==CONV_DATA_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        case(fetch_cnt)
            5'd9:
                addr=ADDR_SRC_DATA+true_num;
            5'd8:
                addr=ADDR_SRC_DATA+true_num+1;
            5'd7:
                addr=ADDR_SRC_DATA+true_num+2;
            5'd6:
                addr=ADDR_SRC_DATA+true_num+32;
            5'd5:
                addr=ADDR_SRC_DATA+true_num+33;
            5'd4:
                addr=ADDR_SRC_DATA+true_num+34;
            5'd3:
                addr=ADDR_SRC_DATA+true_num+64;
            5'd2:
                addr=ADDR_SRC_DATA+true_num+65;
            5'd1:
                addr=ADDR_SRC_DATA+true_num+66;
            default:
                addr='d0;
        endcase
    end
    else if(cs==CONV_WBACK1)begin
        ce   = 1'b1;
        we   = 1'b0; // write
        addr = ADDR_AC1_DATA+conv_exe_cnt;
        wdata= conv_out;
    end
    else if(cs==CONV_WBACK2)begin
        ce   = 1'b1;
        we   = 1'b0; // write
        addr = ADDR_AC1_DATA+conv_exe_cnt;
        wdata= conv_out;
    end
    else if(cs==POOL_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        case(fetch_cnt)
            5'd4:
               // if(pool_exe_cnt>=pool_count)
               //     addr=ADDR_AC2_DATA+((pool_exe_cnt-pool_count)<<1);
               // else
                    addr=ADDR_AC1_DATA+(pool_exe_cnt<<1);
            5'd3:
               // if(pool_exe_cnt>=pool_count)
               //     addr=ADDR_AC2_DATA+((pool_exe_cnt-pool_count)<<1)+1;
               // else
                    addr=ADDR_AC1_DATA+(pool_exe_cnt<<1)+1;
            5'd2:
               // if(pool_exe_cnt>=pool_count)
               //     addr=ADDR_AC2_DATA+((pool_exe_cnt-pool_count)<<1)+30;
               // else
                    addr=ADDR_AC1_DATA+(pool_exe_cnt<<1)+30;
            5'd1:
               // if(pool_exe_cnt>=pool_count)
               //     addr=ADDR_AC2_DATA+((pool_exe_cnt-pool_count)<<1)+31;
               // else
                    addr=ADDR_AC1_DATA+(pool_exe_cnt<<1)+31;
            default:
                addr='d0;
        endcase
    end
    else if(cs==POOL_WBACK)begin
        ce   = 1'b1;
        we   = 1'b0; // write
        addr = ADDR_AP_DATA+pool_true_cnt;
        wdata= pool_out;
    end
    else if(cs==LINE_WEIGHT_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        addr = ADDR_LINE_WEIGHT+line_exe_cnt;
    end
    else if(cs==LINE_DATA_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        addr = ADDR_AP_DATA+((line_exe_cnt>=450)?(line_exe_cnt-450):line_exe_cnt);
    end
    else if(cs==LINE_BIAS1_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        addr = ADDR_LINE_BIAS;
    end
    else if(cs==LINE_BIAS2_FETCH)begin
        ce   = 1'b1;
        we   = 1'b1; // read
        addr = ADDR_LINE_BIAS+1;
    end
    else if(cs==LINE_DONE)begin
        ce   = 1'b1;
        we   = 1'b0; // write
        addr = ADDR_FINAL_RES;
        wdata= final_res_kind;
    end
    else begin
        ce   =1'b0;
    end
end

wire [12:0] view_addr=addr-1024; // just for view
/*
mini_ram #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) u_mini_ram(
   .clk(clk),
   .rstn(rstn),
   .addr(mini_ram_addr),
   .din(mini_ram_din),
   .ce(mini_ram_ce), // chip select
   .we(mini_ram_we), // write:0 read:1
   .dout(mini_ram_dout)
);
*/

//---------------------------------------------//
//-------------convolution layer---------------//
//---------------------------------------------//
reg [7:0] sram_buff[18:0];

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[0]<='d0;
    else if((cs==CONV_DATA_FETCH && fetch_cnt==5'd9)||(cs==POOL_FETCH && fetch_cnt==5'd4) ||(cs==LINE_WEIGHT_FETCH) || (cs==LINE_BIAS1_FETCH && wr_cnt==1'b1))
        sram_buff[0]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[1]<='d0;
    else if((cs==CONV_DATA_FETCH && fetch_cnt==5'd8)||(cs==POOL_FETCH && fetch_cnt==5'd3) ||(cs==LINE_DATA_FETCH) || (cs==LINE_BIAS2_FETCH && wr_cnt==1'b1))
        sram_buff[1]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[2]<='d0;
    else if((cs==CONV_DATA_FETCH && fetch_cnt==5'd7)||(cs==POOL_FETCH && fetch_cnt==5'd2))
        sram_buff[2]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[3]<='d0;
    else if((cs==CONV_DATA_FETCH && fetch_cnt==5'd6)||(cs==POOL_FETCH && fetch_cnt==5'd1))
        sram_buff[3]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[4]<='d0;
    else if(cs==CONV_DATA_FETCH && fetch_cnt==5'd5)
        sram_buff[4]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[5]<='d0;
    else if(cs==CONV_DATA_FETCH && fetch_cnt==5'd4)
        sram_buff[5]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[6]<='d0;
    else if(cs==CONV_DATA_FETCH && fetch_cnt==5'd3)
        sram_buff[6]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[7]<='d0;
    else if(cs==CONV_DATA_FETCH && fetch_cnt==5'd2)
        sram_buff[7]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[8]<='d0;
    else if(cs==CONV_DATA_FETCH && fetch_cnt==5'd1)
        sram_buff[8]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[9]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd10)
        sram_buff[9]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[10]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd9)
        sram_buff[10]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[11]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd8)
        sram_buff[11]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[12]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd7)
        sram_buff[12]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[13]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd6)
        sram_buff[13]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[14]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd5)
        sram_buff[14]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[15]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd4)
        sram_buff[15]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[16]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd3)
        sram_buff[16]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[17]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd2)
        sram_buff[17]<=rdata;
end

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        sram_buff[18]<='d0;
    else if((cs==CONV_CAB1_FETCH || cs==CONV_CAB2_FETCH) && fetch_cnt==5'd1)
        sram_buff[18]<=rdata;
end

wire [7:0] D11,D12,D13,D21,D22,D23,D31,D32,D33;
wire [7:0] C11,C12,C13,C21,C22,C23,C31,C32,C33;
wire [7:0] conv_bias;

assign D11=sram_buff[0];
assign D12=sram_buff[1];
assign D13=sram_buff[2];
assign D21=sram_buff[3];
assign D22=sram_buff[4];
assign D23=sram_buff[5];
assign D31=sram_buff[6];
assign D32=sram_buff[7];
assign D33=sram_buff[8];

assign C11=sram_buff[9];
assign C12=sram_buff[10];
assign C13=sram_buff[11];
assign C21=sram_buff[12];
assign C22=sram_buff[13];
assign C23=sram_buff[14];
assign C31=sram_buff[15];
assign C32=sram_buff[16];
assign C33=sram_buff[17];

assign conv_bias=sram_buff[18];
//assign 
//wire [7:0] conv_out;
conv u_conv(
   .A11(D11),// pixl in [7:0]
   .A12(D12),
   .A13(D13),
   .A21(D21),
   .A22(D22),
   .A23(D23),
   .A31(D31),
   .A32(D32),
   .A33(D33),
   //Core Parameter
   .P11(C11),// core [7:0]
   .P12(C12),
   .P13(C13),
   .P21(C21),
   .P22(C22),
   .P23(C23),
   .P31(C31),
   .P32(C32),
   .P33(C33),
   //
   .bias(conv_bias),
    // avoid calculate overflow
   .B(conv_out) // output [19:0]
);


//--------------------------------------------------//
//-----------max pooling layer----------------------//
//--------------------------------------------------//
wire [7:0] pool_in_11,pool_in_12,pool_in_21,pool_in_22;
assign pool_in_11=sram_buff[0]; // TODO
assign pool_in_12=sram_buff[1];
assign pool_in_21=sram_buff[2];
assign pool_in_22=sram_buff[3];
//wire [7:0] pool_out;
max_pool u_max_pool(
    .A11(pool_in_11),
    .A12(pool_in_12),
    .A21(pool_in_21),
    .A22(pool_in_22),
    .B(pool_out)
);
//-----------------------------------------------//
//-------------------liner layer-----------------//
//-----------------------------------------------//
wire [7 :0] line_mul_data;
wire [7 :0] line_mul_coe;
wire [15:0] line_mul_re;
assign line_mul_coe  =(cs==LINE_CAL)?sram_buff[0]:8'd0;
assign line_mul_data =(cs==LINE_CAL)?sram_buff[1]:8'd0;
line_mul u_line_mul(
   .data(line_mul_data), // 8 bits
   .coe(line_mul_coe),   // 8 bits
   .mul(line_mul_re)        // 16 bits
);

wire [7:0] b1,b2;
//assign b1=(cs==LINE_BIAS1_FETCH)? sram_buff[0]: 8'd0;
//assign b2=(cs==LINE_BIAS2_FETCH)? sram_buff[1]: 8'd0;
reg [25:0] line_sum_1;
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        line_sum_1<='d0;
    else if(done)
        line_sum_1<='d0;
    else if(cs==LINE_CAL && line_exe_cnt<=line_count-1)
        line_sum_1<=line_sum_1+line_mul_re;
    else if(cs==LINE_BIAS1_FETCH && wr_cnt==1'b1)
        line_sum_1<=line_sum_1+rdata;
    else
        line_sum_1<=line_sum_1;
end


reg [25:0] line_sum_2;
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        line_sum_2<='d0;
    else if(done)
        line_sum_2<='d0;
    else if(cs==LINE_CAL && (line_exe_cnt>=line_count && line_exe_cnt<(line_count<<1)))
        line_sum_2<=line_sum_2+line_mul_re;
    else if(cs==LINE_BIAS2_FETCH && wr_cnt==1'b1)
        line_sum_2<=line_sum_2+rdata;
    else
        line_sum_2<=line_sum_2;
end

//------------------------------------------//
//---------------output layer  -------------//
//------------------------------------------//
// wire final_res_kind;
final_res u_final_res(
   .A1(line_sum_1),// input [25:0]
   .A2(line_sum_2),// input [25:0]
   .kind(final_res_kind) // output kind
);

reg conv_1_done;
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        conv_1_done<='d0;
    else if(clear || done)
        conv_1_done<='d0;
    else
        conv_1_done<=conv_1_done || (cs==CONV_1_DONE);
end
//------------------------------------------//
//----------------main state----------------//
//------------------------------------------//
always@(posedge clk or negedge rstn)begin
    if(!rstn)
        cs<=4'h0;
    else 
        cs<=ns;
end

always_comb begin
    ns=IDLE;
    case(cs)
        IDLE:begin
           // if(start)begin
            if(dma_cs==DMA_SLEEP)begin
                if(mode[2])
                    ns=CONV_CAB1_FETCH;
                else if(mode[1])
                    ns=POOL_FETCH;
                else if(mode[0])
                    ns=LINE_WEIGHT_FETCH;
                else
                    ns=TOTAL_DONE;
            end
            else
                ns=IDLE;
        end
        CONV_CAB1_FETCH:begin
            if(fetch_cnt=='d1 && wr_cnt==1'b1)
                ns=CONV_DATA_FETCH;
            else
                ns=CONV_CAB1_FETCH;
        end
        CONV_CAB2_FETCH:begin
            if(fetch_cnt=='d1 && wr_cnt==1'b1)
                ns=CONV_DATA_FETCH;
            else
                ns=CONV_CAB2_FETCH;
        end
        CONV_DATA_FETCH:begin
            if(fetch_cnt=='d1 && wr_cnt==1'b1)
                ns=CONV_CAL;
            else
                ns=CONV_DATA_FETCH;
        end
        CONV_CAL:begin
            if(conv_1_done)
                ns=CONV_WBACK2;
            else
                ns=CONV_WBACK1;
        end
        CONV_WBACK1:begin
            if(wr_cnt==1'b1)begin
                if(conv_exe_cnt==conv_mul_cnt-1)
                    ns=CONV_1_DONE;
                else
                    ns=CONV_DATA_FETCH;
            end
            else
                ns<=CONV_WBACK1;
        end
        CONV_WBACK2:begin
            if(wr_cnt==1'b1)begin
                if(conv_exe_cnt==(conv_mul_cnt<<1)-1)
                    ns=CONV_2_DONE;
                else
                    ns=CONV_DATA_FETCH;
            end
            else
                ns<=CONV_WBACK2;
        end
        CONV_1_DONE:begin
            ns=CONV_CAB2_FETCH;
        end
        CONV_2_DONE:begin
            ns=CONV_DONE;
        end
        CONV_DONE:begin
            if(mode[1])
                ns=POOL_FETCH;
            else if(mode[0])
                ns=LINE_WEIGHT_FETCH;
            else
                ns=TOTAL_DONE;
        end
        POOL_FETCH:begin
            if(fetch_cnt=='d0)
                ns=POOL_CAL;
            else
                ns=POOL_FETCH;
        end
        POOL_CAL:begin
            ns=POOL_WBACK;
        end
        POOL_WBACK:begin
            if(wr_cnt==1'b1)begin
                if(pool_true_cnt==((pool_count<<1)-1))
                    ns=POOL_DONE;
                else
                    ns=POOL_FETCH;
            end
            else
                ns=POOL_WBACK;
        end
        POOL_DONE:begin
            if(mode[0])
                ns=LINE_WEIGHT_FETCH;
            else
                ns=TOTAL_DONE;
        end
        LINE_WEIGHT_FETCH:begin
            if(wr_cnt==1'b1)
                ns=LINE_DATA_FETCH;
            else
                ns=LINE_WEIGHT_FETCH;
        end
        LINE_DATA_FETCH:begin
            if(wr_cnt==1'b1)
                ns=LINE_CAL;
            else
                ns=LINE_DATA_FETCH;
        end
        LINE_CAL:begin
            if(line_exe_cnt==((line_count<<1)-1))
                ns=LINE_BIAS1_FETCH;
            else
                ns=LINE_WEIGHT_FETCH;
        end
        LINE_BIAS1_FETCH:begin
            if(wr_cnt==1'b1)
                ns=LINE_BIAS2_FETCH;
            else
                ns=LINE_BIAS1_FETCH;
        end
        LINE_BIAS2_FETCH:begin
            if(wr_cnt==1'b1)
                ns=LINE_DONE;
            else
                ns=LINE_BIAS2_FETCH;
        end
        LINE_DONE:begin
            if(wr_cnt==1'b1)
                ns=TOTAL_DONE;
            else
                ns=LINE_DONE;
        end
        TOTAL_DONE:begin
            if(dma_cs==DMA_DONE)
                ns=IDLE;
            else
                ns=TOTAL_DONE;
        end
        default:
            ns=IDLE;
    endcase
end
assign done=(!dout_dma_en && cs==TOTAL_DONE) || (dout_dma_en && dma_cs==DMA_DONE);
assign result=final_res_kind;
endmodule
