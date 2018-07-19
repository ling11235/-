`timescale 1ns/1ps
// 通过5键{Left,Right,Enter,Up,Down}输入得到电机编号和坐标值
// 通过Left/Right键切换电机/坐标位，通过Up/Down键改变电机编号/坐标值，
// 通过Enter键确认执行
module Input(
	input sysclk,
	input Left,
	input Right,
	input Up,
	input Down,
	input Enter,
	input INIT,
	// To Control
	output reg[3:0] TValue0, // 电机位移值百位
	output reg[3:0] TValue1, // 电机位移值十位
	output reg[3:0] TValue2, // 电机位移值个位
	output reg[5:0] Motor, // 电机编号
	// To LCD_Input
	output reg[1:0] Num, // 位号
	output reg LCD_Enable, // LCD使能信号
	output reg[3:0] LCD_Num // LCD显示数字
	);
	reg LastL, LastR, LastU, LastD; // 输入缓存
	reg LL, RR, UU, DD; // 输入上升沿标志
	reg[3:0] Motor_LCD; // 电机号的二进制表示
	reg[5:0] MotorCache; // 电机编号缓存
	reg[3:0] CTValue0; // 电机位移值百位缓存
	reg[3:0] CTValue1; // 电机位移值十位缓存
	reg[3:0] CTValue2; // 电机位移值个位缓存
	

	// 检测输入的上升沿
	always @(posedge sysclk) begin
		if (INIT==1) begin
			LastL <= 0; LastR <= 0; LastU <= 0; LastD <= 0;
			LL <= 0; RR <= 0; UU <= 0; DD <= 0;
		end
		else begin
			LastL <= Left;
			LastR <= Right;
			LastU <= Up;
			LastD <= Down;
			LL <= LastL==Left ? 0 : Left;
			RR <= LastR==Right ? 0 : Right;
			UU <= LastU==Up ? 0 : Up;
			DD <= LastD==Down ? 0 : Down;
		end                              
	end
	// LCD使能信号:有任何输入就刷屏
	always @(posedge sysclk) begin
		if (INIT==1) 
			LCD_Enable <= 0;
		else begin
			LCD_Enable <= (LL|RR|UU|DD)==1 ? 1 : 0;
		end
	end
	// Num位
	always @(posedge sysclk) begin
		if (INIT==1) begin
			Num <= 0;
		end	
		else begin
			Num <= LL==1 ? Num-1 : (RR==1 ? Num+1 : Num);
		end
	end
	// 修改电机号/坐标值
	always @(posedge sysclk) begin
	 	if (INIT==1) begin
	 		CTValue0 <= 0; CTValue1 <= 0; CTValue2 <= 0;
	 		MotorCache <= 1; Motor_LCD <= 0;
	 		LCD_Num <= 0;
	 	end
	 	else begin
			case(Num)
				2'b00:begin // 6'b00_0001为1电机,...,6'b10_0000为6电机
					MotorCache <= DD==1 ? (MotorCache==1 ? 6'b10_0000 : MotorCache>>1)
										: (UU==1 ? (MotorCache==6'b10_0000 ? 1 : MotorCache<<1) : MotorCache);
					Motor_LCD <= DD==1 ? (Motor_LCD==0 ? 5 : Motor_LCD-1)
										: (UU==1 ? (Motor_LCD==5 ? 0 : Motor_LCD+1) : Motor_LCD);
					LCD_Num <= Motor_LCD;
				end
				2'b01:begin // 百位
					CTValue0 <= DD==1 ? (CTValue0==0 ? 9 : CTValue0-1)
									: (UU==1 ? (CTValue0==9 ? 0 : CTValue0+1) : CTValue0);
					LCD_Num <= CTValue0;
				end
				2'b10:begin //十位
					CTValue1 <= DD==1 ? (CTValue1==0 ? 9 : CTValue1-1)
									: (UU==1 ? (CTValue1==9 ? 0 : CTValue1+1) : CTValue1);
					LCD_Num <= CTValue1;
				end
				2'b11:begin // 个位
					CTValue2 <= DD==1 ? (CTValue2==0 ? 9 : CTValue2-1)
									: (UU==1 ? (CTValue2==9 ? 0 : CTValue2+1) : CTValue2);
					LCD_Num <= CTValue2;
				end
			endcase
		end
	 end
	 // 读缓存
	 always @(posedge sysclk ) begin
		if (INIT==1) begin
			TValue0 <= 0; TValue1 <= 0; TValue2 <= 0;
			Motor <= 0;
		end
		else begin
			TValue0 <= Enter==1 ? CTValue0 : TValue0;
			TValue1 <= Enter==1 ? CTValue1 : TValue1;
			TValue2 <= Enter==1 ? CTValue2 : TValue2;
			Motor <= Enter==1 ? MotorCache : Motor;
		end
	end
	
	
endmodule
