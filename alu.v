`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2023 12:21:26
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`include "adder_subtractor.v"
//`include "multiplier.v"

module alu(input [2:0]OpCode,input [31:0]x1,input [31:0]x2,output reg [31:0]x3,input clk);
wire Overflow,Underflow,Exception;
wire [31:0] Adderx3,Subx3,Mulx3,Orx3,Andx3,Xorx3;


// Choosing operation via OpCode
assign ADD = !OpCode[2] & !OpCode[1] & !OpCode[0];  // 000
assign SUB = !OpCode[2] & !OpCode[1] &  OpCode[0];  // 001
//assign DIV = !OpCode[2] &  OpCode[1] & !OpCode[0];  // 010
assign MUL = !OpCode[2] &  OpCode[1] &  OpCode[0];  // 011
assign AND =  OpCode[2] & !OpCode[1] & !OpCode[0];  // 100
assign OR  =  OpCode[2] & !OpCode[1] &  OpCode[0];  // 101
assign XOR =  OpCode[2] &  OpCode[1] & !OpCode[0];  // 110

adder_subtracter dut1(x1, x2, Adderx3);
adder_subtracter dut2(x1, {~x2[31],x2[30:0]}, Subx3);
multiplier dut3(x1,x2,Exception,Overflow,Underflow,Mulx3);
assign Andx3 = x1 & x2;
assign Orx3 = x1 | x2;
assign Xorx3 = x1 ^ x2;


always @(posedge clk) begin
if(ADD) begin
x3=Adderx3;
end
else if(SUB) begin
x3=Subx3;
end
else if(MUL) begin
x3=Mulx3;
end
else if(OR) begin
x3=Orx3;
end
else if(AND) begin
x3=Andx3;
end
else if(XOR) begin
x3=Xorx3;
end
end
endmodule