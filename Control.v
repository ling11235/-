// 控制模块，输出脉冲数、方向。
module Control(
	input rst,
	input sysclk,
	input[5:0] initFlag, // 初始化标志位
	input SS, // Stop上升沿信号
	input DSS, // Stop下降沿信号
	input[5:0] Motor, // 电机编号
	input[3:0] TValue0, // 电机目标坐标百位
	input[3:0] TValue1, // 电机目标坐标十位
	input[3:0] TValue2, // 电机目标坐标个位
	input Busy, // Pulse模块标志位
	output reg[9:0] PulseNum, // 电机脉冲数
	output reg[5:0] DR // 方向信号: 1反转，0正传
	);
	reg[9:0] Value;
	reg[9:0] MotorValue; //当前电机位移
	reg[9:0] LastValue[5:0]; // 所有电机上次坐标

	always @(posedge sysclk or negedge rst) begin
		if (rst==0 || initFlag==0) begin // 异步复位/初始值
			PulseNum <= 0; Enable <= 0; DR <= 0;
			Value <= 0; MotorValue <= 0;
			LastValue[0] <= 0; LastValue[1] <= 0; LastValue[2] <= 0;
			LastValue[3] <= 0; LastValue[4] <= 0; LastValue[5] <= 0;
			LastinitFlag <= 0;
		end
		else if (&initFlag==1 && Busy==0) begin // 标定好原点后
			// 计算当前电机的方向信号和位移值
			Value <= TValue0*100 + TValue1*10 + TValue2;
			case(Motor)
				6'b00_0001:begin
					MotorValue <= Value<LastValue[0] ? LastValue[0]-Value : Value-LastValue[0];
					DR[0] <= Value<LastValue[0] ? 1 : (Value==LastValue[0] ?  DR[0] : 0);
					LastValue[0] <= Value;
				end
				6'b00_0010:begin
					MotorValue <= Value<LastValue[1] ? LastValue[1]-Value : Value-LastValue[1];
					DR[1] <= Value<LastValue[1] ? 1 : (Value==LastValue[1] ?  DR[1] : 0);
					LastValue[1] <= Value;
				end
				6'b00_0100:begin
					MotorValue <= Value<LastValue[2] ? LastValue[2]-Value : Value-LastValue[2];
					DR[2] <= Value<LastValue[2] ? 1 : (Value==LastValue[2] ?  DR[2] : 0);
					LastValue[2] <= Value;
				end
				6'b00_1000:begin
					MotorValue <= Value<LastValue[3] ? LastValue[3]-Value : Value-LastValue[3];
					DR[3] <= Value<LastValue[3] ? 1 : (Value==LastValue[3] ?  DR[3] : 0);
					LastValue[3] <= Value;
				end
				6'b01_0000:begin
					MotorValue <= Value<LastValue[4] ? LastValue[4]-Value : Value-LastValue[4];
					DR[4] <= Value<LastValue[4] ? 1 : (Value==LastValue[4] ?  DR[4] : 0);
					LastValue[4] <= Value;
				end
				6'b10_0000:begin
					MotorValue <= Value<LastValue[5] ? LastValue[5]-Value : Value-LastValue[5];
					DR[5] <= Value<LastValue[5] ? 1 : (Value==LastValue[5] ?  DR[5] : 0);
					LastValue[5] <= Value;
				end
				6'b00_0000:begin
					MotorValue <= MotorValue;
					DR <= DR;
					LastValue <= LastValue;
				end
			endcase
			// 假设脉冲数等于位移数
			PulseNum <= MotorValue==0 ? PulseNum : MotorValue;
		end
		else begin // Stop上升沿时电机反转,下降沿时变回正转
			DR <= SS==1 ? 1 : (DSS==1 ? 0 : DR);
		end
	end
endmodule
