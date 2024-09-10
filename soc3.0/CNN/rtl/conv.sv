// PASS
module conv(
    input  [7:0] A11,
    input  [7:0] A12,
    input  [7:0] A13,
    input  [7:0] A21,
    input  [7:0] A22,
    input  [7:0] A23,
    input  [7:0] A31,
    input  [7:0] A32,
    input  [7:0] A33,
    //Core Parameter
    input  [7:0] P11, // enough
    input  [7:0] P12,
    input  [7:0] P13,
    input  [7:0] P21,
    input  [7:0] P22,
    input  [7:0] P23,
    input  [7:0] P31,
    input  [7:0] P32,
    input  [7:0] P33,
    // input bias
    input  [7:0] bias,
    // avoid calculate overflow
    output [7:0] B
);
// inside parameter
    wire [19:0] mul;
    assign mul=A11*P11+A12*P12+A13*P13+
             A21*P21+A22*P22+A23*P23+
             A31*P31+A32*P32+A33*P33;
    wire [20:0] added_bias;
    assign added_bias=mul+bias;
    assign B= added_bias[7:0];
    //assign B= added_bias[20] ? added_bias[20:13] : 8'h0;

endmodule
