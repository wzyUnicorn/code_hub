module line_mul(
    input  [7 :0] data,
    input  [7 :0] coe,
    output [15:0] mul
);

assign mul=data*coe;

endmodule
