// 控制模块，输出脉冲数、方向和上电信号。
module Control(
	input rst,
	input clk,
	input[5:0] InitFlag, // 初始化标志位
	input[2:0] Motor, // 当前电机编号
	input[9:0] Value, // 当前电机目标坐标
	input InputLock, // Input锁变量
	input Busy, // PulseSign模块标志位
	output reg[9:0] PulseNum, // 电机脉冲数
	output reg Enable, // PulseSign模块的使能信号
	output reg[5:0] DRs // 方向信号 // 1反转，0正传
	);
	reg[9:0] MotorValue; //当前电机归一化位移
	reg[9:0] LastValues[5:0]; // 所有电机上次坐标

	always @(posedge clk or negedge rst) begin
		if (rst) begin
			PulseNum <= 0; Enable <= 0; DRs <= 0;
			MotorValue <= 0;
			LastValues[0] <= 0; LastValues[1] <= 0; LastValues[2] <= 0;
			LastValues[3] <= 0; LastValues[4] <= 0; LastValues[5] <= 0;
		end
		else if (InputLock==0 && InitFlag==6'b11_1111 && Busy==0) begin
			// TODO:case语句实现归一化位移到脉冲数之间的转换
			// MotorValue -> Pulsecache
			// 计算当前电机的方向信号和位移值
			case(Motor)
				3'b000:begin
					MotorValue <= Value<LastValues[0] ? LastValues[0]-Value : Value-LastValues[0];
					DRs[0] <= Value<LastValues[0] ? 1 : (Value==LastValues[0] ?  DRs[0] : 0);
					LastValues[0] <= Value;
				end
				3'b001:begin
					MotorValue <= Value<LastValues[1] ? LastValues[1]-Value : Value-LastValues[1];
					DRs[1] <= Value<LastValues[1] ? 1 : (Value==LastValues[1] ?  DRs[1] : 0);
					LastValues[1] <= Value;
				end
				3'b010:begin
					MotorValue <= Value<LastValues[2] ? LastValues[2]-Value : Value-LastValues[2];
					DRs[2] <= Value<LastValues[2] ? 1 : (Value==LastValues[2] ?  DRs[2] : 0);
					LastValues[2] <= Value;
				end
				3'b011:begin
					MotorValue <= Value<LastValues[3] ? LastValues[3]-Value : Value-LastValues[3];
					DRs[3] <= Value<LastValues[3] ? 1 : (Value==LastValues[3] ?  DRs[3] : 0);
					LastValues[3] <= Value;
				end
				3'b100:begin
					MotorValue <= Value<LastValues[4] ? LastValues[4]-Value : Value-LastValues[4];
					DRs[4] <= Value<LastValues[4] ? 1 : (Value==LastValues[4] ?  DRs[4] : 0);
					LastValues[4] <= Value;
				end
				3'b101:begin
					MotorValue <= Value<LastValues[5] ? LastValues[5]-Value : Value-LastValues[5];
					DRs[5] <= Value<LastValues[5] ? 1 : (Value==LastValues[5] ?  DRs[5] : 0);
					LastValues[5] <= Value;
				end
			endcase
			// 假设脉冲数等于位移数
			PulseNum <= MotorValue==0 ? PulseNum : MotorValue;
			Enable <= MotorValue==0 ? 1 : 0;
		end
	end
endmodule
