module ula (portA, portB, op, resultado);
	input [7:0]portA; 
	input [7:0]portB; 
	input [2:0]op; 
	output reg [7:0]resultado; 

always@(*)	                                //para qualquer variação detectada, executa os parametros abaixo
  begin
     case(op)                               //dado um op como chave, é retornado uma operação
	   3'b000 : resultado <= portA;
		3'b001 : resultado <= portA + portB;
		3'b010 : resultado <= portA & portB;
	   3'b011 : resultado <= portA | portB;
	   3'b100 : resultado <= portA - portB;
	   3'b101 : resultado <= -portA;
	   3'b110 : resultado <= ~portA;
	  endcase
  end
	
endmodule
