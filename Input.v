module Input(
	input rst,
	input Left,
	input Right,
	input Up,
	input Down,
	input Enter,
	output reg [9:0] Value, // 归一化位移值
	output reg [2:0] Motor, // 电机编号
	output reg Lock // 电机锁
	);
	reg[1:0] Num; // 位号
	reg[3:0] Value0;
	reg[3:0] Value1;
	reg[3:0] Value2;
	always @(posedge rst or posedge Left or posedge Right 
		or posedge Enter or posedge Up or posedge Down)
	begin
		if (rst) begin
			Value = 10'b00_0000_0000;
			Motor = 3'b000;
			Lock = 1'b0;
			Num = 2'b00;
			Value0 = 4'b0000;
			Value1 = 4'b0000;
			Value2 = 4'b0000;
		end	
		else begin
			if (!Lock) begin // 选择电机
				if (Left) begin
					Motor = !Motor ? Motor-3'b011 : Motor-3'b001;
				end
				if (Right) begin
					Motor = (Motor==3'b101) ? Motor+3'b011 : Motor+3'b001;
				end
			end
			else begin // 选择值
				if (Left) begin
					Num = !Num ? Num-2'b10 : Num-2'b01;
				end
				if (Right) begin
					Num = (Num==2'b10) ? Num+2'b10 : Num+2'b01;
				end
				
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
	end
endmodule