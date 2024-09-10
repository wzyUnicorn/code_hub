`include "timescale.v"
`include "uart_defines.v"

module uart_tfifo_hubing(clk, rst_n, data_in, data_out, 
                push, pop, overrun, count, fifo_reset, reset_status);

input clk;
input rst_n;
input [7:0] data_in;
input push;
input pop;
input fifo_reset;
input reset_status;

output [7:0] data_out;
output overrun;
output [4:0] count;

// FIFO parameters
parameter fifo_width = `UART_FIFO_WIDTH;  //`define UART_FIFO_WIDTH	8
parameter fifo_depth = `UART_FIFO_DEPTH; //`define UART_FIFO_DEPTH	16
parameter fifo_pointer_w = `UART_FIFO_POINTER_W; //`define UART_FIFO_POINTER_W	4
parameter fifo_counter_w = `UART_FIFO_COUNTER_W; //`define UART_FIFO_COUNTER_W	5

reg [3:0] top;
reg [3:0] bottom;
reg [4:0] count;
reg overrun;

raminfr_hubing tfifo(
                .clk(clk), 
					 .we(push), 
					 .a(top), 
					 .dpra(bottom), 
					 .di(data_in), 
					 .dqo(data_out)
					 ); 
					 
always @(posedge clk or negedge rst_n)
begin
        if(!rst_n)
		  begin
			      top <= 0;
			      bottom <= 0;
			      count <= 0;		
		  end
	else if(fifo_reset)
		  begin
	                top <= 0;
			bottom <= 0;
			count <= 0;
                  end	
	else
	         case({push, pop})	  
				  2'b10 : if(count < fifo_depth)  //16
				            begin
				             top <= top + 4'b1;
								 count <= count + 5'b1;
							   end
				  2'b01 : if(count > 0)
					           begin
								    bottom <= bottom + 4'b1;
								    count <= count - 5'b1;	 
								  end
				  2'b11 :  begin
				               top <= top + 4'b1;
								bottom <= bottom + 4'b1;
								count <= count;
				           end
				  default : ; 
				endcase
end			

//overrun
 always @(posedge clk or negedge rst_n)
 begin
     if(!rst_n)
	      overrun <= 1'b0;
	  else if(reset_status | fifo_reset)
	      overrun <= 1'b0;
	  else if(count == fifo_depth & push)
	      overrun <= 1'b1;
 end


endmodule 
