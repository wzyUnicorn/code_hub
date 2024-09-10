`include "i2c_master_defines.v"

//hubing
module i2c_slave_byte_ctrl(
      
	input          clk,
	input          rst,
	input          din_onebit,
	input          scl_i,
	input          sda_i,
	input [3:0]    bit_cmd,
	
	input          ena, //core enable;
	
	input [15:0]      clk_cnt,
	
	output reg        bit_cmd_ack, //output to byte controller;
	output            scl_o,
	output reg        scl_oen,
	output            sda_o,
	output reg        sda_oen, 
	
	output reg        dout_onebit,
	output reg        al,
	output reg        busy

 ); 
 
reg [1:0]            cSDA;
reg [1:0]            cSCL;

reg [2:0]            fSCL;
reg [2:0]            fSDA;

reg                  sSCL, dSCL;
reg                  sSDA, dSDA;

reg                  dscl_oen;
reg [15:0]           cnt;
reg [3:0]            filter;
reg                  slave_wait;
reg                  sda_chk;

//capture scl_i, sda_i yk_debug_327_2349
always @(posedge clk or negedge rst)
begin
   if(~rst)
	     begin
		   cSCL <= 2'b00;
			cSDA <= 2'b00;
		  end
	 else 
	      begin
			 cSCL <= {cSCL[0], scl_i};
			 cSDA <= {cSDA[0], sda_i};
			end
end

//filter to avoid glitch
always @(posedge clk or negedge rst)
begin
	   if(~rst)
		     filter <= 0;
	   else if(filter == 4'hf)
           filter <= 0;
	   else
		     filter <= filter + 1'b1;
end

//hubing
always @(posedge clk or negedge rst)
begin
      if(~rst)
		     begin
		       fSCL <= 3'b000;
				 fSDA <= 3'b000;
	     	  end	
	    else if(~|filter)
		     begin
			    fSCL <= {fSCL[1:0], cSCL[1]};
				 fSDA <= {fSDA[1:0], cSDA[1]};
			  end
end

//hubing
always @(posedge clk or negedge rst)
begin
    if(~rst)
	     begin
		    sSCL <= 1'b1;
			 sSDA <= 1'b1;
		  end
	  else 
	     begin
		    sSCL <= (&fSCL[2:1] | &fSCL[1:0] | (fSCL[2] & fSCL[0]));
			 sSDA <= (&fSDA[2:1] | &fSDA[1:0] | (fSDA[2] & fSDA[0]));
			 
			 dSDA <= sSDA;
			 dSCL <= sSCL;
		  end
end

//detect sta_condition and sto_condition
reg        sta_condition;
reg        sto_condition;

always @(posedge clk or negedge rst)
begin
    if(~rst)
	      begin
			  sta_condition <= 0;
			  sto_condition <= 0;
			end
	  else 
	      begin
			   sta_condition <= (dSDA & ~sSDA & sSCL);
				sto_condition <= (~dSDA & sSDA & sSCL);
			end
end

//Hubing  busy
always @(posedge clk or negedge rst)
begin
   if(~rst)
       busy <= 1'b0;
   else 
       busy <= (sta_condition | busy) & ~sto_condition;
end


    // generate arbitration lost signal
    // aribitration lost when:
    // 1) master drives SDA high, but the i2c bus is low
    // 2) stop detected while not requested
reg       cmd_stop;
always @(posedge clk or negedge rst)
begin
   if(~rst)
	    cmd_stop <= 1'b0;
	else if(bit_cmd == `I2C_CMD_STOP)
       cmd_stop <= 	1'b1;   
end	 

always @(posedge clk or negedge rst)
begin
   if(~rst)
	    al <= 1'b0;
	else
       al <= (sda_chk & sda_oen & ~sSDA) & (~cmd_stop & sto_condition);	 
end	 
//////////////////////////////////////////
//receive one bit data
always @(posedge clk )
       if(~dSCL & sSCL)
              dout_onebit <= sSDA;
//////////////////////////////////////////

//slave_wait
always @(posedge clk )
    dscl_oen <= scl_oen;     

always @(posedge clk or negedge rst)
begin
     if(~rst)
	       slave_wait <= 1'b0;
     else if(scl_oen & ~dscl_oen & ~sSCL || slave_wait & ~sSCL)
               slave_wait <= 1'b1;	    
     else
               slave_wait <= 1'b0;
end

//generate clk_en
wire  clk_en;

always @(posedge clk or negedge rst)
begin
     if(~rst)  
         cnt <= clk_cnt;
	  else if(~ena)
	      cnt <= clk_cnt;
	  else if(slave_wait)
	      cnt <= cnt;
          else if(~|cnt) 
              cnt <= clk_cnt;
	  else
	      cnt <= cnt - 1'b1;
end

assign clk_en = ~|cnt; 

    // nxt_state decoder
    parameter [17:0] idle    = 18'b0_0000_0000_0000_0000;
    parameter [17:0] start_a = 18'b0_0000_0000_0000_0001;
    parameter [17:0] start_b = 18'b0_0000_0000_0000_0010;
    parameter [17:0] start_c = 18'b0_0000_0000_0000_0100;
    parameter [17:0] start_d = 18'b0_0000_0000_0000_1000;
    parameter [17:0] start_e = 18'b0_0000_0000_0001_0000;
    parameter [17:0] stop_a  = 18'b0_0000_0000_0010_0000;
    parameter [17:0] stop_b  = 18'b0_0000_0000_0100_0000;
    parameter [17:0] stop_c  = 18'b0_0000_0000_1000_0000;
    parameter [17:0] stop_d  = 18'b0_0000_0001_0000_0000;
    parameter [17:0] rd_a    = 18'b0_0000_0010_0000_0000;
    parameter [17:0] rd_b    = 18'b0_0000_0100_0000_0000;
    parameter [17:0] rd_c    = 18'b0_0000_1000_0000_0000;
    parameter [17:0] rd_d    = 18'b0_0001_0000_0000_0000;
    parameter [17:0] wr_a    = 18'b0_0010_0000_0000_0000;
    parameter [17:0] wr_b    = 18'b0_0100_0000_0000_0000;
    parameter [17:0] wr_c    = 18'b0_1000_0000_0000_0000;
    parameter [17:0] wr_d    = 18'b1_0000_0000_0000_0000;
	
reg [17:0] bit_state; 

always @(posedge clk or negedge rst)
begin
   if(~rst)
	      begin
			    bit_state <= idle;
				 scl_oen <= 1'b1;
				 sda_oen <= 1'b1;
				 sda_chk <= 1'b0;
                                 bit_cmd_ack <= 1'b0;
			end
   else 
      begin
         bit_cmd_ack <= 1'b0;
         if(clk_en)
	    case(bit_state)
		    idle : 
	             begin
	                case(bit_cmd)
					   `I2C_CMD_START: bit_state <= start_a;
				           `I2C_CMD_READ:  bit_state <= rd_a;
				           `I2C_CMD_WRITE: bit_state <= wr_a;
				           `I2C_CMD_STOP:  bit_state <= stop_a;	
                                                 default:  bit_state <= idle;
                                       	  
						 endcase
						 
						 scl_oen <= scl_oen;
						 sda_oen <= sda_oen;
                end 	
		  start_a:
		           begin
					     bit_state <= start_b;
						  scl_oen <= 1'b0;          //set scl_o low
						  sda_oen <= sda_oen;
					  end
		  start_b:
		           begin
					     bit_state <= start_c;
						  scl_oen <= 1'b0;  //keep scl high
						  sda_oen <= 1'b1;  //set sda high
					  end
			start_c:
			        begin
					    bit_state <= start_d;
						 scl_oen <= 1'b1; //set scl high
						 sda_oen <= 1'b1; //keep sda high
					  end
		   start_d: 
		            begin
						   bit_state <= start_e;
							scl_oen <= 1'b1; //keep scl high
							sda_oen <= 1'b0; //set sda low
						end
			start_e:
			          begin
						    bit_state <= idle;
							 scl_oen <= 1'b0;  //set scl low 
							 sda_oen <= 1'b0; //keep sda low
							 bit_cmd_ack <= 1'b1;
						 end
		  	wr_a:
			      begin
					  bit_state <= wr_b;
					  scl_oen <= 1'b0;
					  sda_oen <= din_onebit;
					end
			 wr_b: 
			      begin
					  bit_state <= wr_c;
					  scl_oen <= 1'b1;
					  sda_oen <= din_onebit;
					end
			 wr_c:
			      begin
					 bit_state <= wr_d;
					 scl_oen <= 1'b1;
					 sda_oen <= din_onebit;
					 sda_chk <= 1'b1;   //to do a sda check; 
					end
			  wr_d: 
			       begin
					   bit_state <= idle;
						scl_oen <= 1'b0;
						sda_oen <= din_onebit;
						sda_chk <= 1'b0;
				      bit_cmd_ack <= 1'b1;
				 	 end
			  rd_a:
			       begin
					   bit_state <= rd_b;
						scl_oen <= 1'b0;
						sda_oen <= 1'b1;
					 end
				rd_b:
				     begin
					    bit_state <= rd_c;
						 scl_oen <= 1'b1;
						 sda_oen <= 1'b1;
						 
					  end
				rd_c:
				   begin
					  bit_state <= rd_d;
					  scl_oen <= 1'b1;
					  sda_oen <= 1'b1;
					  
					end
				rd_d:
				      begin
						  bit_state <= idle;
						  scl_oen <= 1'b0;
						  sda_oen <= 1'b1;
						  bit_cmd_ack <= 1'b1;
						end
				 stop_a:
				      begin
						  bit_state <= stop_b;
						  scl_oen <= 1'b0;
						  sda_oen <= 1'b1;
						end
						
				 stop_b:
				       begin
						   bit_state <= stop_c;
							scl_oen <= 1'b1;
							sda_oen <= 1'b1;
						 end
				 stop_c:
				       begin
						   bit_state <= stop_d;
							scl_oen <= 1'b1;
							sda_oen <= 1'b1;
						 end
				  stop_d:
				          begin
							    bit_state <= idle;
								 scl_oen <= 1'b0;
							    sda_oen <= 1'b1;
						 	 bit_cmd_ack <= 1'b1;
							 end
		 endcase
   end
end	
//output signals (always gnd)
assign  scl_o = 1'b0;
assign  sda_o = 1'b0;

endmodule
