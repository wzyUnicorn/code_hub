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
module multiplexer(/*AUTOARG*/
   // Outputs
   out,
   // Inputs
   select, 
   input0, input1, input2, input3, input4, input5, input6
   );
//****************************************************************************
//Parameter Declaration.
//****************************************************************************
parameter MUX_SIZE = 7;
parameter MUX_INPUT_SIZE = 46;
//****************************************************************************
//Port Declaration.
//****************************************************************************
/*AUTOINPUT*/
/*AUTOOUTPUT*/
input [MUX_INPUT_SIZE - 1 : 0]  input0;
input [MUX_INPUT_SIZE - 1 : 0]  input1;
input [MUX_INPUT_SIZE - 1 : 0]  input2;
input [MUX_INPUT_SIZE - 1 : 0]  input3;
input [MUX_INPUT_SIZE - 1 : 0]  input4;
input [MUX_INPUT_SIZE - 1 : 0]  input5;
input [MUX_INPUT_SIZE - 1 : 0]  input6;
input [MUX_SIZE - 1       : 0]  select;
output[MUX_INPUT_SIZE - 1 : 0]  out;

//****************************************************************************
//Signal Declaration.
//****************************************************************************
/*AUTOWIRE*/
/*AUTOREG*/
reg   [MUX_INPUT_SIZE - 1 : 0]  out;

//****************************************************************************
//Function Declaration.
//****************************************************************************
always @( * ) begin
    case (select[MUX_SIZE - 1 : 0]) 
    7'h01 : out = input0;
    7'h02 : out = input1;
    7'h04 : out = input2;
    7'h08 : out = input3;
    7'h10 : out = input4;
    7'h20 : out = input5;
    7'h40 : out = input6;
    default  : out = {MUX_INPUT_SIZE{1'b0}};
    endcase
end    

endmodule
