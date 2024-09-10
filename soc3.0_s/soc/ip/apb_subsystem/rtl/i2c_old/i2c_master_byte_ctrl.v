`include "i2c_master_defines.v"

//hubing 
module i2c_slave_bit_ctrl(clk, rst, din, dout, start, stop, read, write, ack_in,
                            scl_i, scl_o, scl_padoen_o, sda_i, sda_o, sda_padoen_o,
          i2c_busy, i2c_al, ena, clk_cnt, ack_out, byte_cmd_ack);

input          clk;
input          rst;
input [7:0]    din;       
input          start;
input          stop;
input          read;
input          write;
input          ena; //core enable
input [15:0]   clk_cnt;

input          ack_in;
input          scl_i;
input          sda_i;

output [7:0]   dout;

output reg     ack_out;
output         scl_o;
output         scl_padoen_o;

output          sda_o;
output          sda_padoen_o;

output          i2c_busy;
output          i2c_al;
output           byte_cmd_ack; //to clear Command Rigisters
reg              byte_cmd_ack;
//shift regs
reg  [7:0]       sr;
reg              core_txd;
wire             core_rxd;

reg [4:0]        byte_state;
reg [3:0]        core_cmd;
wire             bit_cmd_ack;

reg [2:0]        dcnt;
wire             cnt_done;

reg              ld;
reg              shift;
wire             dout_onebit;

parameter [4:0] ST_IDLE  = 5'b0_0000;
parameter [4:0] ST_START = 5'b0_0001;
parameter [4:0] ST_READ  = 5'b0_0010;
parameter [4:0] ST_WRITE = 5'b0_0100;
parameter [4:0] ST_ACK   = 5'b0_1000;
parameter [4:0] ST_STOP  = 5'b1_0000;


//data output
assign dout = sr;
//shift registers 
always @(posedge clk or negedge rst)
begin
   if(~rst)
       sr <= 8'b0;
   else if(ld)
       sr <= din;
   else if(shift)
       sr <= {sr[6:0], core_rxd};
end
 
//wire    din_onebit;
//assign  din_onebit = sr[7]; //data bit to send;
 reg din_onebit;
 
//cnt_done
always @(posedge clk or negedge rst)
begin
   if(~rst)
        dcnt <= 3'h7;
   else if(ld)
              dcnt <= 3'h7; 
   else if(shift)
        dcnt <= dcnt - 1'b1;
end

assign cnt_done = (~|dcnt);
 
assign core_rxd = dout_onebit;

 //instance bit_controller
  i2c_master_bit_ctrl bit_controller(
          .clk(clk),
          .rst(rst),
          .din_onebit(din_onebit),
          .scl_i(scl_i),
          .sda_i(sda_i),
          .bit_cmd(core_cmd),
          .ena(ena),
          .clk_cnt(clk_cnt),
    .bit_cmd_ack(bit_cmd_ack),
    .scl_o(scl_o),
    .scl_oen(scl_padoen_o),
    .sda_o(sda_o),
    .sda_oen( sda_padoen_o), 
          .dout_onebit(dout_onebit),
          .al(al),
          .busy(busy)
 ); 
 
//to insure that command registers are clear then execute another command
wire      go;
assign go = ~byte_cmd_ack;
 //state machine
always @(posedge clk or negedge rst)
begin
     if(~rst)
          begin
          shift <= 1'b0;
          ld <= 1'b0;
          byte_cmd_ack <= 1'b0;     
          byte_state <= ST_IDLE;
                      din_onebit <= 1'b1;
          end
     else  
     begin 
            shift <= 1'b0;
                  din_onebit <= sr[7];
                  ld <= 1'b0;   
                        byte_cmd_ack <= 1'b0;   
           case(byte_state)
          ST_IDLE:
                   if(go)  
                                          if(start)
                begin
                  byte_state <= ST_START;
                                          core_cmd   <= `I2C_CMD_START;
                          ld  <= 1'b1;
                end
                                                 else if(read)
                                    begin
                        byte_state <= ST_READ;
                  core_cmd <= `I2C_CMD_READ;
                                                            ld <= 1'b1; 
                end
             else if(write)
                    begin
                        byte_state <= ST_WRITE;
                        core_cmd <= `I2C_CMD_WRITE;
                              ld <= 1'b1;
                end                                                 
                
          ST_START:
                 if(bit_cmd_ack) 
                                          begin
               if(read)
                begin
                  byte_state <= ST_READ;
                        core_cmd   <= `I2C_CMD_READ;
                 
                end
            else 
                   begin
                 byte_state <= ST_WRITE;
                 core_cmd   <= `I2C_CMD_WRITE;
                 din_onebit <= sr[7];
              end 
           end
           ST_READ:
                 if(bit_cmd_ack)
                  begin
                       if(cnt_done)
                      begin
                          byte_state <= ST_ACK;
                    core_cmd   <= `I2C_CMD_WRITE;
                    din_onebit <= 1'b0;
                  end
                 else 
                    begin
                     byte_state <= ST_READ;
                           core_cmd   <= `I2C_CMD_READ;
                    end
                     shift <= 1'b1; //8 shift
                 end
                        
          ST_WRITE:
                                       if(bit_cmd_ack)    
             begin
                if(cnt_done)
               begin
                byte_state <= ST_ACK;
                 core_cmd   <= `I2C_CMD_READ; 
               end
                else 
               begin
                byte_state <= ST_WRITE;
                 core_cmd   <= `I2C_CMD_WRITE;
                 shift <= 1'b1;
                end
             end       
                       
          ST_ACK:
               if(bit_cmd_ack)
             begin
                 if(stop)
              begin
                byte_state <= ST_STOP;
                core_cmd   <= `I2C_CMD_STOP;
                end
                        else
                    begin
                      byte_state <= ST_IDLE;
                      core_cmd   <= `I2C_CMD_NOP;
                                                          byte_cmd_ack <= 1'b1; //ack for byte transfer, clear Command Register;
                    end
              ack_out <= core_rxd; //after write, receive a ack bit;
              din_onebit <= 1'b1;
             end
                     else
             din_onebit <= 1'b0;
                
          
           ST_STOP:
                 if(bit_cmd_ack)
              begin 
               byte_state <= ST_IDLE;
                core_cmd   <= `I2C_CMD_NOP; 
                                        byte_cmd_ack <= 1'b1;
              end

          endcase 
      end       
end 

endmodule
