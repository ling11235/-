`timescale 1ns/1ps
// 控制模块，输出脉冲数、方向。
module Control #(parameter DATA_NUM = 1000, DATA_WIDTH = 10) (
	input sysclk,
	input[5:0] initFlag, // 初始化标志位
	input INIT, // 初始化标识
	input[2:0] i_Motor, // 电机编号 // 位数根据实际情况可以改
	input[9:0] Value, // 电机目标坐标
	input Busy, // Pulse模块标志位
	output reg[5:0] o_Motor, //输出电机号
	output reg[DATA_WIDTH-1:0] PulseNum, // 电机脉冲数
	output reg[5:0] DRSign // 方向信号: 1反转，0正传
	);

	(* ram_style = "block" *)
	reg[DATA_WIDTH-1:0] datas[DATA_NUM-1:0];
	initial $readmemh("data.txt", datas);

	reg[9:0] LastValue[5:0];	// 所有电机上次地址
	reg[9:0] DiffValue; //当前电机位移 // 数据地址

	// 方向信号
	always @(posedge sysclk) begin
		if (INIT==1) 
			DRSign <= 0;
		else if (&initFlag==1 && Busy==0)
			DRSign[i_Motor] <= Value<LastValue[i_Motor] ? 1 : (Value==LastValue[i_Motor] ?  DRSign[i_Motor] : 0);
	end
	// 位移值
	always @(posedge sysclk) begin
		if (INIT==1)
			DiffValue <= 0;
		else if (&initFlag==1 && Busy==0)
			DiffValue <= Value<LastValue[i_Motor] ? LastValue[i_Motor]-Value : Value-LastValue[i_Motor];
	end
	
	// 更新坐标值
	always @(posedge sysclk) begin
		if (INIT==1) begin
			LastValue[0] <= 0; LastValue[1] <= 0; LastValue[2] <= 0;
			LastValue[3] <= 0; LastValue[4] <= 0; LastValue[5] <= 0;
		end
		else if (&initFlag==1 && Busy==0)
			LastValue[i_Motor] <= Value;
	end

	// 读脉冲数
	always @(posedge sysclk) begin
		if (INIT==1) begin
			PulseNum <= 0;
		end
		else if (&initFlag==1 && Busy==0)
			PulseNum <= DiffValue==0 ? PulseNum : datas[DiffValue];
	end

	// 输出电机标志
	always @(posedge sysclk) begin
		if (INIT) begin
			o_Motor <= 0;
		end
		else if (&initFlag==1 && Busy==0) begin
			o_Motor[0] <= ~(i_Motor[2] | i_Motor[1] | i_Motor[0]);
			o_Motor[1] <= ~(i_Motor[2] | i_Motor[1] | ~i_Motor[0]);
			o_Motor[2] <= i_Motor[1] & ~i_Motor[0];
			o_Motor[3] <= i_Motor[1] & i_Motor[0];
			o_Motor[4] <= i_Motor[2] & ~i_Motor[0];
			o_Motor[5] <= i_Motor[2] & i_Motor[0];	
		end
	end

endmodule
