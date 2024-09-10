// 
module max_pool(
    input  [7:0] A11,
    input  [7:0] A12,
    input  [7:0] A21,
    input  [7:0] A22,
    output [7:0] B
);
// 2*2 max pooling
wire [7:0] m1;
wire [7:0] m2;
assign m1 = (A11>A12)? A11: A12;
assign m2 = (A21>A22)? A21: A22;
assign B  = (m1>m2)  ? m1 :m2;

endmodule
