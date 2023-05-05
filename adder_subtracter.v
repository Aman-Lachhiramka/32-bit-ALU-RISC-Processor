`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2023 16:42:02
// Design Name: 
// Module Name: adder_subtracter
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


module adder_subtracter(x1, x2, x3);
  // Inputs
  input  [31:0] x1, x2;
  
  // Outputs
  output [31:0] x3;
  
  // Wires
  wire [31:0] x3;
  wire [7:0] o_e;
  wire [24:0] o_m;
  
  // Registers
	reg s1;
	reg [7:0] e1;
	reg [23:0] m1;
	reg s2;
	reg [7:0] e2;
	reg [23:0] m2;
	reg s3;
	reg [7:0] e3;
	reg [24:0] m3;
	reg [7:0] diff;
	reg [23:0] m_temp;
	reg [7:0] e_temp;
	reg  [7:0] i_e;
	reg  [24:0] i_m;

  // Main
  addition_normaliser norm1
  (
    .in_e(i_e),
    .in_m(i_m),
    .out_e(o_e),
    .out_m(o_m)
  );

  assign x3[31] = s3;
  assign x3[30:23] = e3;
  assign x3[22:0] = m3[22:0];

  always @ ( * ) begin
  
		s1 = x1[31];
		
		if(x1[30:23] == 0) begin
			e1 = 8'b00000001;
			m1 = {1'b0, x1[22:0]};
		end else begin
			e1 = x1[30:23];
			m1 = {1'b1, x1[22:0]};
		end
		s2 = x2[31];
		if(x2[30:23] == 0) begin
			e2 = 8'b00000001;
			m2 = {1'b0, x2[22:0]};
		end else begin
			e2 = x2[30:23];
			m2 = {1'b1, x2[22:0]};
		end
		
    if (e1 == e2) begin // Equal exponents
      e3 = e1;
      if (s1 == s2) begin // Equal signs = add
        m3 = m1 + m2;
        //Signify to shift
        m3[24] = 1;
        s3 = s1;
      end else begin // Opposite signs = subtract
        if(m1 > m2) begin
          m3 = m1 - m2;
          s3 = s1;
        end else begin
          m3 = m2 - m1;
          s3 = s2;
        end
      end
    end else begin //Unequal exponents
      if (e1 > e2) begin // x1 is bigger
        e3 = e1;
        s3 = s1;
				diff = e1 - e2;
        m_temp = m2 >> diff;
        if (s1 == s2)
          m3 = m1 + m_temp;
        else
          	m3 = m1 - m_temp;
      end else if (e1 < e2) begin // x2 is bigger
        e3 = e2;
        s3 = s2;
        diff = e2 - e1;
        m_temp = m1 >> diff;
        if (s1 == s2) begin
          m3 = m2 + m_temp;
        end else begin
					m3 = m2 - m_temp;
        end
      end
    end
    if(m3[24] == 1) begin
      e3 = e3 + 1;
      m3 = m3 >> 1;
    end else if((m3[23] != 1) && (e3 != 0)) begin
      i_e = e3;
      i_m = m3;
      e3 = o_e;
      m3 = o_m;
    end

//----------------

//   if((e1 == 255 && m1 == 0)||(e2 == 255 && m2 == 0))
//   begin
//       if((e1 == 255 && m1 == 0)&&(e2 == 255 && m2 == 0))
//       begin
       
//       if(s1!=s2)
//       begin
//       e3=255;
//       m3=1;
//       s3=s1;
//       end
//       else
//       begin
//       e3=255;
//       m3=0;
//       s3=s1;
//       end
       
//       end
       
//       else //if any one is inf
//       begin
//       if((e1 == 255 && m1 == 0))
//       begin
//        e3=255;
//       m3=0;
//       s3=s1;
//       end
//       else
//       begin
//         e3=255;
//       m3=0;
//       s3=s2;
//       end
//       end
//   end

//    else  if ((e1 == 255 && m1 != 0) || (e2 == 255 && m2 != 0))       //operand is NaN
//    begin 
//   e3=255;
//   m3=1;
//    end
   
//2----------


//2----------
    if(e1==255||e2==255)
    begin
     if((e1 == 255)&&(e2 == 255))
       begin
       
       if(s1!=s2)
       begin
       e3=0;
       m3=0;
       s3=s1;
       end
       else
       begin
       e3=255;
       m3=0;
       s3=s1;
       end
       
       end
       
     
              else //if any one is inf
       begin
       if((e1 == 255))
       begin
        e3=255;
       m3=0;
       s3=s1;
       end
       else
       begin
         e3=255;
       m3=0;
       s3=s2;
       end
       end
    end
    
    //-------------
  end
endmodule
