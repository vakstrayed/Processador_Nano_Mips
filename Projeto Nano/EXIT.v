module EXIT(input[7:0] resultULA, input ld, input[2:0] rDest, input reset, output reg[7:0] out0, out1, out2, out3, out4, out5, out6, out7);

always@(posedge ld or negedge reset)
begin
	if(reset == 0)
		begin
			out1 <= 8'd0;
			out2 <= 8'd0;
			out3 <= 8'd0;
			out4 <= 8'd0;
			out5 <= 8'd0;
			out6 <= 8'd0;
			out7 <= 8'd0;
			out0 <= 8'd0;
		end
	else begin
		case(rDest)
			3'd0 : out0 <= resultULA;
			3'd1 : out1 <= resultULA;
			3'd2 : out2 <= resultULA;
			3'd3 : out3 <= resultULA;
			3'd4 : out4 <= resultULA;
			3'd5 : out5 <= resultULA;
			3'd6 : out6 <= resultULA;
			3'd7 : out7 <= resultULA;
		endcase
	end
end


endmodule