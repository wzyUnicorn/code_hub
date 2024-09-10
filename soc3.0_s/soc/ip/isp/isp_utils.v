module simple_dp_ram
#(
	parameter DW = 8,
	parameter AW = 4,
	parameter SZ = 2**AW
)
(
	input           clk,
	input           wen,
	input  [AW-1:0] waddr,
	input  [DW-1:0] wdata,
	input           ren,
	input  [AW-1:0] raddr,
	output [DW-1:0] rdata
);
	reg [DW-1:0] mem [SZ-1:0];
	always @ (posedge clk) begin
		if (wen) begin
			mem[waddr] <= wdata;
		end
	end
	reg [DW-1:0] q;
	always @ (posedge clk) begin
		if (ren) begin
			q <= mem[raddr];
		end
	end
	assign rdata = q;
endmodule

/* Shift Register based on Simple Dual-Port RAM */
module shift_register
#(
	parameter BITS = 8,
	parameter WIDTH = 480,
	parameter LINES = 3
)
(
	input                clock,
	input                clken,
	input  [BITS-1:0]    shiftin,
	output [BITS-1:0]    shiftout,
	output [BITS*LINES-1:0] tapsx
);

	localparam RAM_SZ = WIDTH - 1;
	localparam RAM_AW = clogb2(RAM_SZ);

	reg [RAM_AW-1:0] pos_r;
	wire [RAM_AW-1:0] pos = pos_r < RAM_SZ ? pos_r : (RAM_SZ[RAM_AW-1:0] - 1'b1);
	always @ (posedge clock) begin
		if (clken) begin
			if (pos_r < RAM_SZ - 1)
				pos_r <= pos_r + 1'b1;
			else
				pos_r <= 0;
		end
	end

	reg [BITS-1:0] in_r;
	always @ (posedge clock) begin
		if (clken) begin
			in_r <= shiftin;
		end
	end
	wire [BITS-1:0] line_out[LINES-1:0];
	generate
		genvar i;
		for (i = 0; i < LINES; i = i + 1) begin : gen_ram_inst
			simple_dp_ram #(BITS, RAM_AW, RAM_SZ) u_ram(clock, clken, pos, (i > 0 ? line_out[i-1] : in_r), clken, pos, line_out[i]);
		end
	endgenerate

	assign shiftout = line_out[LINES-1];
	generate
		genvar j;
		for (j = 0; j < LINES; j = j + 1) begin : gen_taps_assign
			assign tapsx[(BITS*j)+:BITS] = line_out[j];
		end
	endgenerate

	function integer clogb2;
	input integer depth;
	begin
		for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
			depth = depth >> 1;
	end
	endfunction
endmodule
