//
// command width  16bit
//
// command 0x6   write enable
//
// command 0x4   write disable
//
// command 0x3   read data
//
// command 0x2   page programming
//
// data width    32bit
//
// addr width    16bit
//
//

module qspi_device
(
input   spi_clk,
input   spi_csn0,
input   spi_csn1,
input   spi_csn2,
input   spi_csn3,
output  spi_sdo0,
output  spi_sdo1,
output  spi_sdo2,
output  spi_sdo3,
input   spi_oe0,
input   spi_oe1,
input   spi_oe2,
input   spi_oe3,
input   spi_sdi0,
input   spi_sdi1,
input   spi_sdi2,
input   spi_sdi3,
input   [31:0] command_width,
input   [31:0] addr_width,
input   [31:0] data_width,
input   [31:0] wdata_addr_dummy,
input   [31:0] rdata_addr_dummy,
input   spi_rw     

);
parameter IDLE = 3'b000;
parameter COMMAND = 3'b001;
parameter ADDR = 3'b010;
parameter WDATA = 3'b011;
parameter RDATA_DUMMY = 3'b100;
parameter WDATA_DUMMY = 3'b110;
parameter RDATA = 3'b101;


parameter COMMAND_WIDTH = 16;
parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 32;

parameter WRITE_ENABLE = 'h6;
parameter WRITE_DISABLE = 'h4;
parameter READ_DATA = 'h3;
parameter PAGE_PROGRAMMING = 'h2;


bit[7:0]  first_data;
bit[31:0]  command;
bit[15:0] addr;
bit[31:0] data[int];
bit[31:0] sdata;

bit[2:0]  device_state=IDLE;
bit[3:0]  sample_data;
bit[7:0]  vld_bit_cnt;
bit[7:0]  command_data_cnt;
bit[7:0]  addr_data_cnt;
bit[7:0]  sdata_cnt;
bit[4:0]  data_cnt;

bit[3:0]  sample_vld_bit;

bit  write_enable=0;
bit  is_write = 0;

reg  spi_sdo0 = 0;
reg  spi_sdo1 = 0;
reg  spi_sdo2 = 0;
reg  spi_sdo3 = 0;

always @(posedge spi_clk)
begin
    case(device_state)
    IDLE: begin
		      $display("Device In IDLE");
		      command_data_cnt = 0;
		      addr_data_cnt = 0;
		      data_cnt = 0;
		      is_write = 0;
              command = 0 ;
              addr = 0;
              sdata = 0;
              sample_input_signal();

              if(command_width != 0) begin
		          command = command << vld_bit_cnt;
		          for(int i=0;i<vld_bit_cnt;i++) begin
		              command[i] = sample_data[i];
	              end
                  command_data_cnt = command_data_cnt+vld_bit_cnt;
                  device_state = COMMAND;
              end
              else  if(addr_width != 0) begin
		          addr = addr << vld_bit_cnt;
		          for(int i=0;i<vld_bit_cnt;i++) begin
		              addr[i] = sample_data[i];
	              end
                  addr_data_cnt = addr_data_cnt+vld_bit_cnt;
                  device_state = ADDR;
                  is_write = ~spi_rw;
              end
              else  begin
		          sdata = sdata << vld_bit_cnt;
		          for(int i=0;i<vld_bit_cnt;i++) begin
		              sdata[i] = sample_data[i];
	              end
                  sdata_cnt = sdata_cnt+vld_bit_cnt;
                  addr = 'ha55a;                            // write default address

                  if((rdata_addr_dummy != 0)&&(spi_rw==1)) begin
                      device_state = RDATA_DUMMY;
                      sdata_cnt = 1;
                  end
                  else if((wdata_addr_dummy != 0) && (spi_rw==0)) begin
                      device_state = WDATA_DUMMY;
                      sdata_cnt = 1;
                  end
                  else begin
                      if(spi_rw==1) begin
                          device_state = RDATA;
                          sdata = data[addr];
                          drive_output_signal();
		                  sdata = sdata << vld_bit_cnt;
                      end
                      else 
                          device_state = WDATA;
                  end
                  if(spi_rw == 1)
                      $display("Will read data from 'ha55a"); 
                  else
                      $display("Will write data to 'ha55a"); 
              end

	      end
	COMMAND: begin
		  $display("Device In COMMAND");
          sample_input_signal();
		  command = command << vld_bit_cnt;

		  for(int i=0;i<vld_bit_cnt;i++) begin
		      command[i] = sample_data[i];
	      end

          command_data_cnt = command_data_cnt+vld_bit_cnt;
		  if(command_data_cnt==command_width) 
              begin
                 $display("Device get command %h",command); 
		         case(command)
			     WRITE_ENABLE: begin
			         write_enable =1; 
			         device_state = IDLE;     
			     end     
			     WRITE_DISABLE: begin
			         write_enable =0; 
			         device_state = IDLE;        
		             end
			     READ_DATA:begin
                     if(addr_width != 0) begin
                         device_state = ADDR;
			             is_write = 0;
                     end else begin
                         addr = 'ha55a; 
                         if(rdata_addr_dummy != 0)
                             device_state = RDATA_DUMMY;
                         else
                             device_state = RDATA;
                     end
			     end
                 PAGE_PROGRAMMING:begin
                     if(addr_width != 0) begin
                        device_state = ADDR;
			            is_write = 1;
                     end else begin
                         addr = 'ha55a;
                         if(wdata_addr_dummy != 0)
                             device_state = WDATA_DUMMY;
                         else
                             device_state = WDATA;
                     end
			     end
			     default: begin
			         $warning("unsupport command %h \n",command);
			         device_state = IDLE;
			     end
	             endcase
		         command_data_cnt = 0;
	          end
	      end
	ADDR: begin
		  $display("Device In ADDR");
          sample_input_signal();
		  addr = addr << vld_bit_cnt;
		  for(int i=0;i<vld_bit_cnt;i++) begin
		      addr[i] = sample_data[i];
	      end
          addr_data_cnt = addr_data_cnt+vld_bit_cnt;
		  if(addr_data_cnt==addr_width)	 begin
	          if(is_write) begin
                  if(wdata_addr_dummy != 0) begin
		               device_state = WDATA_DUMMY;
                  end else begin
		               device_state = WDATA;
                  end
                  sdata_cnt = 0;
		      end else begin
                  if(rdata_addr_dummy != 0) begin
			         device_state = RDATA_DUMMY;
                  end else begin
			         device_state = RDATA;
                  end
                  sdata_cnt = 0;
		      end
		      addr_data_cnt = 0;
		  end 	  
	      end
	WDATA_DUMMY: begin
		  $display("Device In WDATA_DUMMY");
		   sdata_cnt = sdata_cnt+1;
		   if(sdata_cnt == wdata_addr_dummy) begin
		       device_state = WDATA;
		       sdata = 0; 
		       sdata_cnt = 0; 
	       end
	      end
	WDATA: begin
		      $display("Device In WDATA");
              sample_input_signal();
		      sdata = sdata << vld_bit_cnt;
		      for(int i=0;i<vld_bit_cnt;i++) begin
		          sdata[i] = sample_data[i];
	          end
              sdata_cnt = sdata_cnt+vld_bit_cnt;
              $display("sdata_cnt %h sdata %h \n",sdata_cnt,sdata);
		      if((sdata_cnt == data_width) || (sdata_cnt%32==0)) begin
                  data[addr] = sdata;
                  $display("Write data %h to addr %h",sdata,addr);
                  if((sdata_cnt%32==0) &&(sdata_cnt<data_width)) begin
                      addr = addr + 4;
                  end
                  sdata = 0;
                  if(sdata_cnt == data_width) begin
		              device_state = IDLE;
		              sdata_cnt = 0; 
                  end
	          end
	      end
	RDATA_DUMMY: begin
		  $display("Device In RDATA_DUMMY");
           sample_data = 0;
           drive_output_signal();
		   sdata = sdata << vld_bit_cnt;
		   sdata_cnt = sdata_cnt+1;
		   if(sdata_cnt == rdata_addr_dummy) begin
		       device_state = RDATA;
		       sdata = 0; 
		       sdata_cnt = 0; 
	       end
	      end
	RDATA: begin
		  $display("Device In RDATA");
		   if(sdata_cnt%32==0) begin
	            sdata = data[addr];
                $display("read data %h from addr %h",sdata,addr);
		   end
           sample_data = sdata[31:28];
           drive_output_signal();
		   sdata = sdata << vld_bit_cnt;
		   sdata_cnt = sdata_cnt+vld_bit_cnt;
           if((sdata_cnt%32==0)&&(sdata_cnt < data_width)) begin
               addr = addr+4;
           end
		   if(sdata_cnt == data_width) begin
		       device_state = IDLE;
		       sdata = 0; 
		       sdata_cnt = 0; 
	       end
	      end

        default:;
    endcase
end


task sample_input_signal();
    vld_bit_cnt = 0;
    sample_data[0] =  spi_sdi0 & (spi_csn0==0)&(spi_oe0==1);
    sample_data[1] =  spi_sdi1 & (spi_csn1==0)&(spi_oe1==1);
    sample_data[2] =  spi_sdi2 & (spi_csn2==0)&(spi_oe2==1);
    sample_data[3] =  spi_sdi3 & (spi_csn3==0)&(spi_oe3==1);
    if((spi_csn0==0)&&(spi_oe0==1)) vld_bit_cnt = vld_bit_cnt+1;
    if((spi_csn1==0)&&(spi_oe1==1)) vld_bit_cnt = vld_bit_cnt+1;
    if((spi_csn2==0)&&(spi_oe2==1)) vld_bit_cnt = vld_bit_cnt+1;
    if((spi_csn3==0)&&(spi_oe3==1)) vld_bit_cnt = vld_bit_cnt+1;
    sample_vld_bit[0] = spi_csn0;
    sample_vld_bit[1] = spi_csn1;
    sample_vld_bit[2] = spi_csn2;
    sample_vld_bit[3] = spi_csn3;
endtask


task drive_output_signal();
    vld_bit_cnt = 0;
    $display("will drive data %h to port \n ",sample_data);

    if(spi_csn1==1 && spi_csn2==1 && spi_csn3==1 ) begin
        spi_sdo0 = sample_data[3];
        spi_sdo1 = 0;
        spi_sdo2 = 0;
        spi_sdo3 = 0;
    end
    else begin
        spi_sdo0 = sample_data[0];
        spi_sdo1 = sample_data[1];
        spi_sdo2 = sample_data[2];
        spi_sdo3 = sample_data[3];
    end

    if(spi_csn0==0) vld_bit_cnt = vld_bit_cnt+1;
    if(spi_csn1==0) vld_bit_cnt = vld_bit_cnt+1;
    if(spi_csn2==0) vld_bit_cnt = vld_bit_cnt+1;
    if(spi_csn3==0) vld_bit_cnt = vld_bit_cnt+1;
endtask



endmodule
