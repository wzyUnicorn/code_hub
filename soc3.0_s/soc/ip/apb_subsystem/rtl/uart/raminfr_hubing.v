
// modified by hubing 2013/9/5
module raminfr_hubing(clk, we, a, dpra, di, dqo); 

parameter addr_width = 4;
parameter data_width = 8;
parameter depth = 16;
 
input clk;
input we;
input [addr_width -1:0] a;
input [addr_width -1:0] dpra;
input [data_width -1:0] di;
output [data_width -1:0] dqo;

reg [data_width -1:0] ram [depth -1:0];

always @(posedge clk)
begin
      if(we)
	   ram[a] <= di;
end

assign dqo = ram[dpra];

endmodule
