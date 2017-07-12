module bancoRegistradores(rst, clk, wrEn, addR1, addR2, addWr, dadoR1, dadoR2, dadoWr);
input clk, rst, wrEn;
input [2:0] addR1, addR2, addWr;
input [7:0] dadoWr;
output reg [7:0] dadoR1; 
output reg [7:0] dadoR2;

reg [7:0] registers [0:7];


always@(posedge clk)                //given clock rising performs the parameters
begin
	if (rst == 0) begin 					//if reset is in logical high level, registers will be filled
				registers[0]<=8'd0;
				registers[1]<=8'd0;
				registers[2]<=8'd0;
				registers[3]<=8'd0;
				registers[4]<=8'd0;
				registers[5]<=8'd0;
				registers[6]<=8'd0;
				registers[7]<=8'd0;
		end
  if(wrEn == 1)                    //if wrEn is active, the dadoWr will be written in addWr
    begin
	  registers[addWr] <= dadoWr;
    end
  else                             //if wrEn is not active, returns query addresses
    begin
	  dadoR1 <= registers[addR1];
	  dadoR2 <= registers[addR2];
	 end
end

endmodule