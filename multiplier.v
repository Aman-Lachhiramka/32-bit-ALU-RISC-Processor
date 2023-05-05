`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2023 14:42:45
// Design Name: 
// Module Name: multiplier
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


module multiplier(
		input [31:0] x1,
		input [31:0] x2,
		output Exception,Overflow,Underflow,
		output [31:0] x3
		);

wire sign,product_round,normalised,zero;
wire [8:0] exponent,sum_exponent;
wire [22:0] product_mantissa;
wire [23:0] temp_x1,temp_x2;
wire [47:0] product,product_normalised;


assign sign = x1[31] ^ x2[31];

//Exception flag sets 1 if either one of the exponent is 255.
assign Exception = (&x1[30:23]) | (&x2[30:23]);

//Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1

assign temp_x1 = (|x1[30:23]) ? {1'b1,x1[22:0]} : {1'b0,x1[22:0]};

assign temp_x2 = (|x2[30:23]) ? {1'b1,x2[22:0]} : {1'b0,x2[22:0]};

assign product = temp_x1 * temp_x2;			//Calculating Product

assign product_round = |product_normalised[22:0];  //Ending 22 bits are OR'ed for rounding operation.

assign normalised = product[47] ? 1'b1 : 1'b0;	

assign product_normalised = normalised ? product : product << 1;	//Assigning Normalised value based on 48th bit

//Final Manitssa.
assign product_mantissa = product_normalised[46:24] + (product_normalised[23] & product_round); 
assign zero = Exception ? 1'b0 : (product_mantissa == 23'd0) ? 1'b1 : 1'b0;
assign sum_exponent = x1[30:23] + x2[30:23];
assign exponent = sum_exponent - 8'd127 + normalised;
assign Overflow = ((exponent[8] & !exponent[7]) & !zero) ; 
//If overall exponent is greater than 255 then Overflow condition.
//Exception Case when exponent reaches its max value that is 384.

//If sum of both exponents is less than 127 then Underflow condition.
assign Underflow = ((exponent[8] & exponent[7]) & !zero) ? 1'b1 : 1'b0; 

assign x3 = Exception ? {sign,8'hFF,23'd0} : zero ? {sign,31'd0} : Overflow ? {sign,8'hFF,23'd0} : Underflow ? {sign,31'd0} : {sign,exponent[7:0],product_mantissa};

endmodule
