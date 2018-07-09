`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/06
// Design Name: 
// Module Name: PULSE
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: 脉冲信号产生模块，产生指定个数的脉冲
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PULSE(
	input rst,   // 输入：复位信号，低电平有效，复位完成之后开始产生脉冲
	input sysclk, // 输入：系统时钟
	input[9:0] PulseNum, // 输入：脉冲个数
	output reg Enable, // 输出：使能信号，复位之后为高电平，产生脉冲结束后为低电平
	output reg Sign // 输出：脉冲串
	);

	parameter numFreqcnt = 10;  // 计数个数，等于输出脉冲周期*系统时钟频率*0.5

	reg [14:0] Freqcnt; // 计数器，用来设置输出脉冲的周期

	reg [9:0] Pulsecnt;  // 计数器，记录已经产生的脉冲个数
	
	always @(posedge sysclk or negedge rst) begin
		if (rst == 0) 
			Enable <= 1;
		else if (Pulsecnt == PulseNum)
			Enable <= 0;	
	end

	always @(posedge sysclk or negedge rst) begin
		if (rst == 0) 
			Sign <= 1;   
		else if (Freqcnt == numFreqcnt && Enable == 1)
			Sign <= ~Sign;
	end

	always @(posedge sysclk or negedge rst) begin
		if (rst == 0) 
			Freqcnt <= 0;
		else if (Freqcnt == numFreqcnt)
			Freqcnt <= 0;
		else Freqcnt <= Freqcnt + 1;
	end

	always @(posedge sysclk or negedge rst) begin
		if (rst == 0)
			Pulsecnt <= 0;
		else if (Freqcnt == numFreqcnt && Sign == 1)  // 输出脉冲下降沿起作用
			Pulsecnt <= Pulsecnt + 1;

	end



endmodule