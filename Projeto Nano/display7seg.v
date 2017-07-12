module  display7seg(dp, dado, leds);
input dp;
input [3:0] dado;
output reg [7:0] leds;


always @(*)  		//for any variation in entering below
	begin
		if(dp==1)
		begin
			case(dado)	//Command case, for variable dado the following options:
		
				4'b0000: leds =  7'b1000000; //0
				4'b0001: leds =  7'b1111001; //1
				4'b0010: leds =  7'b0100100; //2
				4'b0011: leds =  7'b0110000; //3
				4'b0100: leds =  7'b0011001; //4
				4'b0101: leds =  7'b0010010; //5
				4'b0110: leds =  7'b0000010; //6
				4'b0111: leds =  7'b1111000; //7
				4'b1000: leds =  7'b0000000; //8
				4'b1001: leds =  7'b0010000; //9
				4'b1010: leds =  7'b0001000; //A
				4'b1011: leds =  7'b0000011; //B
				4'b1100: leds =  7'b1000110; //C
				4'b1101: leds =  7'b0100001; //D
				4'b1110: leds =  7'b0000110; //E
				4'b1111: leds =  7'b0001110; //F
				
			default 
			
				leds = 7'b1111111; //for the options that the case does not meet the default
													//will play such outputs for display	
			endcase
	
		end
		
		else
		begin
			leds = 7'b0111111;
		end
		
	end

endmodule