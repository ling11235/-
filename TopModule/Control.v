`timescale 1ns/1ps
// 控制模块，输出脉冲数、方向。
module Control #(parameter DATA_NUM = 1000, DATA_WIDTH = 10) (
	input sysclk,
	input[5:0] initFlag, // 初始化标志位
	input INIT, // 初始化标识
	input[3:0] i_Motor, // 电机编号 // 位数根据实际情况可以改
	input[9:0] Value, // 电机目标坐标
	input Busy, // Pulse模块标志位
	output reg[5:0] o_Motor, //输出电机号
	output reg[DATA_WIDTH-1:0] PulseNum, // 电机脉冲数
	output reg[5:0] DROut // 输入到Pulse的方向信号
	);

	(* ram_style = "block" *)
	reg[DATA_WIDTH-1:0] datas[DATA_NUM-1:0];
	initial $readmemh("data.txt", datas);

	reg FLAG; // 读数据标志
	reg [DATA_WIDTH-1:0] data_pulse; // 当前脉冲数

	reg[2:0] Motor; //输入电机号
	reg[5:0] DRSign; // 方向信号: 1反转，0正传
	reg[9:0] LastValue[5:0];	// 所有电机上次地址
	reg[9:0] DiffValue; //当前电机位移 // 数据地址

	// Motor输入缓存
	always @(posedge sysclk) begin
		if (INIT==1) 
			Motor <= 0;
		else if (&initFlag==1 && Busy==0) // 标定好原点且Pulse空闲
			Motor <= i_Motor[2:0];
	end
	// 方向信号
	always @(posedge sysclk) begin
		if (INIT==1) 
			DRSign <= 0;
		else if (&initFlag==1 && Busy==0)
			DRSign[Motor] <= Value<LastValue[Motor] ? 1 : (Value==LastValue[Motor] ?  DRSign[Motor] : 0);
	end
	// 位移值
	always @(posedge sysclk) begin
		if (INIT==1)
			DiffValue <= 0;
		else if (&initFlag==1 && Busy==0)
			DiffValue <= Value<LastValue[Motor] ? LastValue[Motor]-Value : Value-LastValue[Motor];
	end
	// 更新坐标值
	always @(posedge sysclk) begin
		if (INIT==1) begin
			LastValue[0] <= 0; LastValue[1] <= 0; LastValue[2] <= 0;
			LastValue[3] <= 0; LastValue[4] <= 0; LastValue[5] <= 0;
		end
		else if (&initFlag==1 && Busy==0)
			LastValue[Motor] <= Value;
	end

	// 根据位移值读脉冲数
	always @(posedge sysclk) begin
		if (INIT==1) begin
			data_pulse <= 0; FLAG <= 0;
		end
		else if (&initFlag==1 && Busy==0) begin
			data_pulse <= datas[DiffValue];
			FLAG <= 1;
		end
		else
			FLAG <= 0;
	end
	// 取得数据后输出
	always @(posedge sysclk) begin
		if (INIT==1) begin
			o_Motor <= 0;
			PulseNum <= 0;
			DROut <= 0;
		end
		else if (FLAG==1) begin
			o_Motor[0] <= ~(Motor[2] | Motor[1] | Motor[0]);
			o_Motor[1] <= ~(Motor[2] | Motor[1] | ~Motor[0]);
			o_Motor[2] <= Motor[1] & ~Motor[0];
			o_Motor[3] <= Motor[1] & Motor[0];
			o_Motor[4] <= Motor[2] & ~Motor[0];
			o_Motor[5] <= Motor[2] & Motor[0];

			PulseNum <= data_pulse;
			DROut <= DRSign;
		end
	end
endmodule
