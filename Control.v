// 控制模块，输出脉冲数、方向和上电信号。
// 未测试，待改进。
module Control(
	input rst,
	input[5:0] InitFlag, // 初始化标志位
	input[2:0] Motor, // 当前电机编号
	input[9:0] Value, // 当前电机目标坐标
	input Lock, // Input锁变量
	input[5:0] Busy, // PulseSign模块标志位
	output reg[5:0] PulseNums, // 电机脉冲数
	output reg[5:0] DRs, // 方向信号
	output reg[5:0] MFs // 上电信号，也即PulseSign模块的使能信号
	);
	reg[59:0] LastValues; // 所有电机上次坐标
	reg[9:0] MotorValue; //当前电机归一化位移
	reg[5:0] Pulsecache, // 电机脉冲数缓存
	reg[5:0] DRcache, // 方向信号缓存
	reg[5:0] MFcache // 上电信号缓存，也即PulseSign模块的使能信号缓存

	always @* begin
		if (rst) begin
			PUs = 0;
			DRs = 0;
			MFs = 0;
			LastValues = 0;
			MotorValue = 0;
		end
		else if (!Lock && InitFlag) begin
			// TODO:case语句实现归一化位移到脉冲数之间的转换
			// MotorValue -> Pulsecache
			// 计算当前电机的方向信号和位移值
			case(Motor)
				3'b000:begin
					DRcache[0] = Value>LastValues[9:0] ? 1'b1:1'b0;
					MotorValue = Value>LastValues[9:0] ? Value-LastValues[9:0] : LastValues[9:0]-Value;
					MFcache[0] = 1'b1;
					LastValues[9:0] = Value;

					if (!Busy[0]) begin
						DRs[0] = DRcache[0];
						PulseNums[0] = Pulsecache[0];
						MFs[0] = MFcache[0];
					end
				end
				3'b001:begin
					DRcache[1] = Value>LastValues[19:10] ? 1'b1:1'b0;
					MotorValue = Value>LastValues[19:10] ? Value-LastValues[19:10] : LastValues[19:10]-Value;
					MFcache[1] = 1'b1;
					LastValues[19:10] = Value;
					if (!Busy[1]) begin
						DRs[1] = DRcache[1];
						PulseNums[1] = Pulsecache[1];
						MFs[1] = MFcache[1];
					end
				end
				3'b010:begin
					DRcache[2] = Value>LastValues[29:20] ? 1'b1:1'b0;
					MotorValue = Value>LastValues[29:20] ? Value-LastValues[29:20] : LastValues[29:20]-Value;
					MFcache[2] = 1'b1;
					LastValues[29:20] = Value;
					if (!Busy[2]) begin
						DRs[2] = DRcache[2];
						PulseNums[2] = Pulsecache[2];
						MFs[2] = MFcache[2];
					end
				end
				3'b011:begin
					DRcache[3] = Value>LastValues[39:30] ? 1'b1:1'b0;
					MotorValue = Value>LastValues[39:30] ? Value-LastValues[39:30] : LastValues[39:30]-Value;
					MFcache[3] = 1'b1;
					LastValues[39:30] = Value;
					if (!Busy[3]) begin
						DRs[3] = DRcache[3];
						PulseNums[3] = Pulsecache[3];
						MFs[3] = MFcache[3];
					end
				end
				3'b100:begin
					DRcache[4] = Value>LastValues[49:40] ? 1'b1:1'b0;
					MotorValue = Value>LastValues[49:40] ? Value-LastValues[49:40] : LastValues[49:40]-Value;
					MFcache[4] = 1'b1;
					LastValues[49:40] = Value;
					if (!Busy[4]) begin
						DRs[4] = DRcache[4];
						PulseNums[4] = Pulsecache[4];
						MFs[4] = MFcache[4];
					end
				end
				3'b101:begin
					DRcache[5] = Value>LastValues[59:50] ? 1'b1:1'b0;
					MotorValue = Value>LastValues[59:50] ? Value-LastValues[59:50] : LastValues[59:50]-Value;
					MFcache[5] = 1'b1;
					LastValues[59:50] = Value;
					if (!Busy[5]) begin
						DRs[5] = DRcache[5];
						PulseNums[5] = Pulsecache[5];
						MFs[5] = MFcache[5];
					end
				end
			endcase
		end
	end
endmodule
