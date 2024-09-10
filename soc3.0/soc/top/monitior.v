module monitior (
hclk, 
hresetn,
haddr,
htrans,
hwrite,
hsize,
hburst,
hprot, 
hwdata, 
hreadyi,
hsel,
jtag_test_start,
qspi0_test_start ,
qspi1_test_start ,
i2c_test_start
//hrdata
//hresp,
//hready,
);
input  hclk;
input  hresetn;
input  [31:0] haddr;
input  [1:0] htrans;
input  hwrite;
input  [2:0] hsize;
input  [2:0] hburst;
input  [3:0] hprot;
input  [31:0] hwdata;
input  hreadyi;
input  hsel;
output jtag_test_start;
output qspi0_test_start ;
output qspi1_test_start ;
output i2c_test_start;

wire [31:0] hwdata_in;
assign hwdata_in =  hwdata[31:0];
reg [31:0] temp1; 
reg [31:0] temp2; 
reg [31:0] temp3;
reg [31:0] jtag_test_start;
reg [31:0] qspi0_test_start;
reg [31:0] qspi1_test_start;
reg [31:0] i2c_test_start;


reg print_message=0;

reg temp1wen, temp1wen_d1;
reg temp2wen, temp2wen_d1;
reg temp3wen;
reg jtagwen;

reg [3:0] tempwbe_d1;

reg[3:0]  wbe;         //write byte enable

always @ (posedge hclk)
begin
   case (hsize)
     3'b000:
        begin
        wbe[3] <= ( haddr[1:0] == 2'b11 );
        wbe[2] <= ( haddr[1:0] == 2'b10 );
        wbe[1] <= ( haddr[1:0] == 2'b01 );
        wbe[0] <= ( haddr[1:0] == 2'b00 );
        end
     3'b001:
        begin
        wbe[3:2] <= {  haddr[1],  haddr[1] };
        wbe[1:0] <= { ~haddr[1], ~haddr[1] };
        end
     3'b010:
       wbe[3:0] <= 4'b1111;
     default:
       wbe[3:0] <= 4'b0000;
   endcase
end

always @ (posedge hclk or negedge hresetn)
begin
if(~hresetn)
  begin
       temp1 <= 32'h0;
       temp2 <= 32'h0;
       temp3 <= 32'h0;
       temp1wen <= 0;
       temp2wen <= 0;
       temp3wen <= 0;

       temp1wen_d1 <= 0;
       temp2wen_d1 <= 0;
       tempwbe_d1  <= 0;
  end
else
  begin
        temp1wen<=hsel & hwrite & htrans[1] & hreadyi & (haddr[19:0]==20'h8_0000);
        temp2wen<=hsel & hwrite & htrans[1] & hreadyi & (haddr[19:0]==20'h8_0004);
        temp3wen<=hsel & hwrite & htrans[1] & hreadyi & (haddr[19:0]==20'h8_0008);
        
        temp1wen_d1<=temp1wen;
        temp2wen_d1<=temp2wen;

        tempwbe_d1 <=wbe;

        if(temp1wen&wbe[3]) temp1[31:24]<= hwdata_in[31:24];
        if(temp1wen&wbe[2]) temp1[23:16]<= hwdata_in[23:16];
        if(temp1wen&wbe[1]) temp1[15: 8]<= hwdata_in[15: 8];
        if(temp1wen&wbe[0]) temp1[ 7: 0]<= hwdata_in[ 7: 0];

        if(temp2wen&wbe[3]) temp2[31:24]<= hwdata_in[31:24];
        if(temp2wen&wbe[2]) temp2[23:16]<= hwdata_in[23:16];
        if(temp2wen&wbe[1]) temp2[15: 8]<= hwdata_in[15: 8];
        if(temp2wen&wbe[0]) temp2[ 7: 0]<= hwdata_in[ 7: 0];

        if(temp3wen&wbe[3]) temp3[31:24]<= hwdata_in[31:24];
        if(temp3wen&wbe[2]) temp3[23:16]<= hwdata_in[23:16];
        if(temp3wen&wbe[1]) temp3[15: 8]<= hwdata_in[15: 8];
        if(temp3wen&wbe[0]) temp3[ 7: 0]<= hwdata_in[ 7: 0];

  end
end

always @ (posedge hclk or negedge hresetn)
begin
if(~hresetn)
  begin
      jtag_test_start  <= 0;
      qspi0_test_start <= 0;
      qspi1_test_start <= 0;
      i2c_test_start <= 0;
  end
else
  begin
        jtagwen<=hsel & hwrite & htrans[1] & hreadyi & (haddr[19:0]==20'h9_0008);
        if(jtagwen&&wbe[3]) temp1[31:24]<= hwdata_in[31:24];
        if(jtagwen&&wbe[2]) temp1[23:16]<= hwdata_in[23:16];
        if(jtagwen&&wbe[1]) temp1[15: 8]<= hwdata_in[15: 8];
        if(jtagwen&&wbe[0]) temp1[ 7: 0]<= hwdata_in[ 7: 0];
        if(jtagwen&&(hwdata_in==32'h00000001)) begin
            jtag_test_start <= 1;
        end

        if(jtagwen&&(hwdata_in==32'h00000002)) begin
            qspi0_test_start <= 1;
        end

        if(jtagwen&&(hwdata_in==32'h00000003)) begin
            qspi1_test_start <= 1;
        end

        if(jtagwen&&(hwdata_in==32'h00000004)) begin
            i2c_test_start <= 1;
        end

  end
end


integer _i, _j;
reg [9:0] _cnt, temp_cnt;
reg [100*8-1:0] _string;
always @ (posedge hclk)
if(temp1wen_d1 & (temp1[31:8]==24'hdddd_11))
begin
  _cnt=temp1[7:0];
  temp_cnt=100*8-1;
  _string = 0;
end

always @ (posedge hclk)
if(temp2wen_d1)
begin
  case(tempwbe_d1)
  4'b0001: begin _cnt=_cnt-1;
                 for(_i=0;_i<8;_i=_i+1)
                   _string[temp_cnt-_i] = temp2[7-_i];
                 temp_cnt=temp_cnt-8;
           end
  4'b0010: begin _cnt=_cnt-1;
                 for(_i=0;_i<8;_i=_i+1)
                   _string[temp_cnt-_i] = temp2[15-_i];
                 temp_cnt=temp_cnt-8;
           end
  4'b0100: begin _cnt=_cnt-1;
                 for(_i=0;_i<8;_i=_i+1)
                   _string[temp_cnt-_i] = temp2[23-_i];
                 temp_cnt=temp_cnt-8;
           end
  4'b1000: begin _cnt=_cnt-1;
                 for(_i=0;_i<8;_i=_i+1)
                   _string[temp_cnt-_i] = temp2[31-_i];
                 temp_cnt=temp_cnt-8;
           end
  4'b0011: begin _cnt=_cnt-1;
                 for(_i=0;_i<16;_i=_i+1)
                   _string[temp_cnt-_i] = temp2[15-_i];
                 temp_cnt=temp_cnt-16;
           end
  4'b1100: begin _cnt=_cnt-1;
                 for(_i=0;_i<16;_i=_i+1)
                   _string[temp_cnt-_i] = temp2[31-_i];
                 temp_cnt=temp_cnt-16;
           end
  4'b1111: begin _cnt=_cnt-4;
                 for(_i=0;_i<32;_i=_i+1)
                   _string[temp_cnt-_i] = temp2[31-_i];
                 temp_cnt=temp_cnt-32;
           end
  endcase
end

always @ (posedge hclk)
if(temp1wen_d1 & (temp1[31:0]==32'hdddd_eeee))
begin
  print_message=1;
//$display("%s",_string[80*8-1:temp_cnt+1]);
  $display("%0s",_string);
  print_message=0;
end


endmodule 

