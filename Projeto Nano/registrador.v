module registrador (load, rst, dadoIn, dadoOut);
input load, rst;
input [7:0] dadoIn;
output reg [7:0] dadoOut;

always@(negedge rst or posedge load)   //dada variaçao de descida do sinal para rst e subida do sinal para load,
begin                                  //executa os parametros abaixo

	if(rst == 0)                        //se rst for 0, dadoOut recebe 0
		begin
			dadoOut <= 8'b00000000;
		end
	else                                //se rst não for 0, dadoOut recebe dadoIn
		begin
			dadoOut <= dadoIn;
		end
		
end

endmodule
