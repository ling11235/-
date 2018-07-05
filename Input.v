module Input(
	input rst,
	input Left,
	input Right,
	input Up,
	input Down,
	input Enter,
	output reg [9:0] Value, // 电机位移值
	output reg [2:0] Motor, // 电机编号
	output reg Lock // 电机锁
	);
	reg[1:0] Num; // 位号
	reg[3:0] Value0;
	reg[3:0] Value1;
	reg[3:0] Value2;
	always @*
	begin
		if (rst) begin
			Value = 0;
			Motor = 0;
			Lock = 0;
			Num = 0;
			Value0 = 0;
			Value1 = 0;
			Value2 = 0;
		end	
		else if (!Lock) begin // 选择电机
			Motor = Left ? (!Motor ? Motor-3'b011 : Motor-3'b001) : Motor;
			Motor = Right ? ((Motor==3'b101) ? Motor+3'b011 : Motor+3'b001) : Motor;
		end
		else begin // 选择值
			Num = Left ? (!Num ? Num-2'b10 : Num-2'b01) : Num;
			Num = Right ? ((Num==2'b10) ? Num+2'b10 : Num+2'b01) : Num;
				
			case(Num)
				2'b00:begin
					Value0 = Down ? (!Value0 ? Value0-4'b0111 : Value0-4'b0001) : Value0;
					Value0 = Up ? ((Value0==4'b1001) ? Value0+4'b0111 : Value0+4'b0001) : Value0;
				end
				2'b01:begin
					Value1 = Down ? (!Value1 ? Value1-4'b0111 : Value1-4'b0001) : Value1;
					Value1 = Up ? ((Value1==4'b1001) ? Value1+4'b0111 : Value1+4'b0001) : Value1;
				end
				2'b10:begin
					Value2 = Down ? (!Value2 ? Value2-4'b0111 : Value2-4'b0001) : Value2;
					Value2 = Up ? ((Value2==4'b1001) ? Value2+4'b0111 : Value2+4'b0001) : Value2;
				end
			endcase
			Value = Value0*100 + Value1*10 + Value2;
		end
		Lock = Enter ? ~Lock : Lock;
	end
endmodule
