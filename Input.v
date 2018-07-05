module Input(
	input clk,
	input rst,
	input Left,
	input Right,
	input Up,
	input Down,
	input Enter,
	output reg [3:0] Value0, // 归一化位移值十位
	output reg [3:0] Value1, // 归一化位移值个位
	output reg [3:0] Value2, // 归一化位移值小数点后一位
	output reg [2:0] Motor, // 电机编号
	output reg Lock // 电机锁
	);
	reg[1:0] Num; // 位号
	always @(posedge clk or posedge rst)
	begin
		if (rst) begin
			Value0 = 4'b0000;
			Value1 = 4'b0000;
			Value2 = 4'b0000;
			Motor = 3'b000;
			Lock = 1'b0;
			Num = 2'b00;
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
						if (Down) begin
							Value0 = !Value0 ? Value0-4'b0111 : Value0-4'b0001;
						end
						if (Up) begin
							Value0 = (Value0==4'b1001) ? Value0+4'b0111 : Value0+4'b0001;
						end
					end
					2'b01:begin
						if (Down) begin
							Value1 = !Value1 ? Value1-4'b0111 : Value1-4'b0001;
						end
						if (Up) begin
							Value1 = (Value1==4'b1001) ? Value1+4'b0111 : Value1+4'b0001;
						end
					end
					2'b10:begin
						if (Down) begin
							Value2 = !Value2 ? Value2-4'b0111 : Value2-4'b0001;
						end
						if (Up) begin
							Value2 = (Value2==4'b1001) ? Value2+4'b0111 : Value2+4'b0001;
						end
					end
				endcase
			end
			Lock = Enter ? ~Lock : Lock;
		end
	end
endmodule