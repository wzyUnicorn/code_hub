module final_res(
    input [25:0] A1,
    input [25:0] A2,
    output kind
);
// binary classfication problem
    assign kind = A1 > A2 ? 1'b0 : 1'b1;

endmodule
