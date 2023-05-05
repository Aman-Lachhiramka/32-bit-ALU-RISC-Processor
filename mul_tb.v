`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2023 14:47:18
// Design Name: 
// Module Name: mul_tb
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


module mul_tb;

reg [31:0] x1,x2;
wire Exception,Overflow,Underflow;
wire [31:0] x3;

multiplier dut(x1,x2,Exception,Overflow,Underflow,x3);

initial begin

// 45.13 * 63.13 = 2849.0569
x1=32'h4234851F;
x2=32'h427C851F;

#100
//3.15 * -14.39 = -45.3285
x1=32'h4049999A;
x2=32'hC1663D71;

#100
//-13.15 * -48.16 = 633.304
x1=32'hC1526666;
x2=32'hC240A3D7;

#100
//inf*inf
x1=32'h7F800000;
x2=32'h7F800000;


#100
//-inf*inf
x1=32'b11111111100000000000000000000000;
x2=32'h7F800000;


#100
//-inf*-inf
x1=32'b11111111100000000000000000000000;
x2=32'b11111111100000000000000000000000;

end
endmodule
