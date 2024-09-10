//  ==========================================================================
//
//                          CONFIDENTIAL
//  Copyright (c) 
//  All Rights Reserved.
//
//  ==========================================================================
//****************************************************************************
//* File Name        :
//* Author           : 
//* Version          :1.0
//* Generated Time   :2023-1-31
//* Modified Time    : 
//* Functions        : 
//****************************************************************************
module arbiter(/*AUTOARG*/
   // Outputs
   grant,
   // Inputs
   hclk, hresetn, request, hready_out
   );
//****************************************************************************
//Parameter Declaration.
//****************************************************************************

//****************************************************************************
//Port Declaration.
//****************************************************************************
/*AUTOINPUT*/
/*AUTOOUTPUT*/
input             hclk;
input             hresetn;
input   [6 :0]    request;
input             hready_out;
output  [6 :0]    grant;
//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
wire                    busy;
wire    [6 :0]          grant;

/*AUTOREG*/
reg     [6 :0]          state;

genvar                  i;
//****************************************************************************
//Function Declaration.
//****************************************************************************
assign   busy  = |(state[6:0]);
assign   grant = state[6:0]; 

always @(posedge hclk or negedge hresetn) begin
    if (!hresetn) begin
        state[0] <= 1'b0;
    end
    else if (!busy && request[0] && hready_out) begin
        state[0] <= 1'b1;
    end
    else if (!request[0]) begin
        state[0] <= 1'b0;
    end
end

generate 
    for(i = 1; i <= 6; i = i + 1)
    begin
        always @(posedge hclk or negedge hresetn) begin
            if(!hresetn) begin
                state[i] <= 1'b0;
            end
            else if (!busy && (request[i] && (~|request[i-1 :0])) && hready_out) begin
                state[i] <= 1'b1;
            end
            else if (~request[i]) begin
                state[i] <= 1'b0;
            end
        end    
    end    
endgenerate

endmodule
