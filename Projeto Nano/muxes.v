module mux2x3(input [2:0]in1, in2, output reg [2:0] out, input sel); // se (sel==0) out=in1

always@(sel)
begin
	 if(sel == 0)
	   out <= in1;
	 else
	   out <= in2; 

end

endmodule

module mux2x8(input [7:0]in1, in2, output  reg [7:0] out, input sel); // se (sel==0) out=in1

always@(sel)
 begin
 if(sel == 0)
   out <= in1;
 else
  out <= in2; 
 
 end 


endmodule

module mux3x8(input [7:0]in1, in2, in3, output reg [7:0] out, input[1:0] sel);   //multiplexador que substituirá o multiplexador de chave
																											//selDtWr para poder escolher o sinal da chave sw[7:0]
																											

always@(sel)
	begin
		case(sel)
			2'b00 : out <= in1;
			2'b01 : out <= in2;
			2'b10 : out <= in3;
		endcase
	end

endmodule

