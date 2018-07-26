`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/19 13:52:28
// Design Name: 
// Module Name: Input
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
	output reg[9:0] Value, // 电机位移值
	output reg[3:0] Motor, // 电机编号
	// To LCD_Input
	output reg[1:0] Num, // 位号
	output reg LCD_Enable, // LCD使能信号
	output wire[3:0] LCD_Num // LCD显示数字
	);
	reg[3:0] Para_Value[3:0];
	
	// LCD使能信号:有任何输入就刷屏
	always @(posedge sysclk) begin
		if (INIT==1) 
			LCD_Enable <= 0;
		else begin
			LCD_Enable <= (Left|Right|Up|Down)==1 ? 1 : 0;
		end
	end
	// Num位
	always @(posedge sysclk) begin
		if (INIT==1) begin
			Num <= 0;
		end	
		else begin
			Num <= Left==1 ? Num-1 : (Right==1 ? Num+1 : Num);
		end
	end
	// 修改电机号/坐标值
	always @(posedge sysclk) begin
	 	if (INIT==1) begin
	 		Para_Value[0] <= 0; Para_Value[1] <= 0;
	 		Para_Value[2] <= 0; Para_Value[3] <= 0;
	 	end
	 	else begin
	 		if (Num==2'b00) begin
	 			Para_Value[0] <= Down==1 ? (Para_Value[0]==0 ? 5 : Para_Value[0]-1)
										: (Up==1 ? (Para_Value[0]==5 ? 0 : Para_Value[0]+1) : Para_Value[0]);
	 		end
	 		else begin
	 			Para_Value[Num] <= Down==1 ? (Para_Value[Num]==0 ? 9 : Para_Value[Num]-1)
									: (Up==1 ? (Para_Value[Num]==9 ? 0 : Para_Value[Num]+1) : Para_Value[Num]);
	 		end
		end
	 end

	 // LCD_Num
	 assign LCD_Num = Para_Value[Num];

	 // 读缓存
	 always @(posedge sysclk ) begin
		if (INIT==1) begin
			Value <= 0; Motor <= 0;
		end
		else begin
			Motor <= Enter==1 ? Para_Value[0] : Motor;
			Value <= Enter==1 ? Para_Value[1]*100 + Para_Value[2]*10 + Para_Value[3] : Value;
		end
	end
endmodule
