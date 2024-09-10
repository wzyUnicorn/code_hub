module mini_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 13
)(
    input      clk,
    input      rstn,
    input      [ADDR_WIDTH-1  : 0] addr,
    input      [DATA_WIDTH-1  : 0] din,
    input      ce, // chip select
    input      we, // write:0 read:1
    output reg [DATA_WIDTH-1:0] dout
    //output     [DATA_WIDTH-1:0] dout

);

integer i;
localparam MEM_DEPTH = 1 << ADDR_WIDTH;

reg [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0]; 

always@(posedge clk or negedge rstn)begin
    if(rstn==1'b0)begin
        for(i=0;i<MEM_DEPTH;i=i+1)begin
            mem[i]<=8'h0;
        end
    end
    else if((!we) && ce)begin
        mem[addr] <=din;
    end
end

//assign dout=(we && ce) ? mem[addr] : 8'h0;

always@(posedge clk or negedge rstn)begin
    if(!rstn)
        dout<=8'h0;
    else if(we && ce)begin
        dout <=mem[addr];
    end
end

endmodule
