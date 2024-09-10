//hubing
`include "timescale.v"
`include "uart_defines.v"

module uart_rfifo_hubing(
  clk, 
	rst_n, data_in, data_out,
	push, 
	pop,  
	overrun,
	count,
	error_bit,
	fifo_reset,
	reset_status
);
	
input clk;
input rst_n;
input [10:0] data_in;
input push;
input pop;
input fifo_reset;
input reset_status;

output [10:0] data_out;
output overrun;
output count;
output error_bit;

parameter fifo_width = `UART_FIFO_WIDTH; //8
parameter fifo_depth = `UART_FIFO_DEPTH; //16 
parameter fifo_pointer_w = `UART_FIFO_POINTER_W; //4
parameter fifo_counter_w = `UART_FIFO_COUNTER_W; //4

reg [fifo_pointer_w -1 : 0] top;
reg [fifo_pointer_w -1 : 0] bottom;
reg [fifo_counter_w -1 : 0] count;
reg overrun;

reg [2:0] fifo[fifo_depth -1 : 0]; //fifo_depth= 16
wire [7:0] data8_out;

raminfr_hubing raminfr_hubing_i( 
                                  .clk(clk),
					                   .we(push),
					                   .a(top),
				                    	 .dpra(bottom),
					                   .di(data_in[10:3]),
					                   .dqo(data8_out)
                                 );
////////////////////  hubing 2014/9/5 ////////////////////
always @(posedge clk or negedge rst_n)
begin
     if(!rst_n)
	     begin
	        top <= 1;
			  bottom <= 0;
			  count <= 0;
			  fifo[0] <= 0;
			  fifo[1] <= 0;
			  fifo[2] <= 0;
			  fifo[3] <= 0;
			  fifo[4] <= 0;
			  fifo[5] <= 0;
			  fifo[6] <= 0;
			  fifo[7] <= 0;
			  fifo[8] <= 0;
			  fifo[9] <= 0;
			  fifo[10] <= 0;
			  fifo[11] <= 0;
			  fifo[12] <= 0;
			  fifo[13] <= 0;
			  fifo[14] <= 0;
			  fifo[15] <= 0;
		  end
	   else if(fifo_reset)
		    begin
		     top <= 1;
			  bottom <= 0;
			  count <= 0;
			  fifo[0] <= 0;
			  fifo[1] <= 0;
			  fifo[2] <= 0;
			  fifo[3] <= 0;
			  fifo[4] <= 0;
			  fifo[5] <= 0;
			  fifo[6] <= 0;
			  fifo[7] <= 0;
			  fifo[8] <= 0;
			  fifo[9] <= 0;
			  fifo[10] <= 0;
			  fifo[11] <= 0;
			  fifo[12] <= 0;
			  fifo[13] <= 0;
			  fifo[14] <= 0;
			  fifo[15] <= 0;
		   end
		else begin
		      case ({push,pop})
				   2'b10 : if(count < fifo_depth)
					        begin
							       top <= top + 1'b1;
									 fifo[top] <= data_in[2:0];
									 count <= count + 1;
							  end
					2'b01 : if(count > 0)
					         begin
								     bottom <= bottom + 1;
									  fifo[bottom] <= 0;
								     count <= count - 1;
								end
					2'b11  : begin
					              top <= top + 1'b1;
									  bottom <= bottom + 1'b1;
									  fifo[top] <= data_in[2:0];
									  fifo[bottom] <= 0;
					         end
				    default : ;      	
				  endcase
		     end
end //always @(posedge clk or posedge wb_rst_i)
											
											

// overrun condition 
always @(posedge clk or negedge rst_n)
begin
      if(!rst_n)
		    overrun <= 0;
		else if(fifo_reset | reset_status)
          overrun <= 0;
      else if(push && ~pop && count == fifo_depth)
          overrun <= 1;		 
end 
// bear in mind.hubing ,that data_out is only valid one clock after pop signal
assign data_out = {data8_out, fifo[bottom]};

wire [2:0] word0 = fifo[0];
wire [2:0] word1 = fifo[1];
wire [2:0] word2 = fifo[2];
wire [2:0] word3 = fifo[3];
wire [2:0] word4 = fifo[4];
wire [2:0] word5 = fifo[5];
wire [2:0] word6 = fifo[6];
wire [2:0] word7 = fifo[7];
wire [2:0] word8 = fifo[8];
wire [2:0] word9 = fifo[9];
wire [2:0] word10 = fifo[10];
wire [2:0] word11 = fifo[11];
wire [2:0] word12 = fifo[12];
wire [2:0] word13 = fifo[13];
wire [2:0] word14 = fifo[14];
wire [2:0] word15 = fifo[15];

assign error_bit = | (  word0[2:0] | word1[2:0] | word2[2:0] | word3[2:0] | word4[2:0] 
                      | word5[2:0] | word6[2:0] | word7[2:0]
                      | word8[2:0] | word9[2:0] | word10[2:0] | word11[2:0] | word12[2:0] 
							 | word13[2:0] | word14[2:0] | word15[2:0]);
							 
endmodule
