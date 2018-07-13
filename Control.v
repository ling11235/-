// 控制模块，输出脉冲数、方向。
module Control(
	input rst,
	input sysclk,
	input[5:0] initFlag, // 初始化标志位
	input INIT, // 初始化标识
	input[5:0] Motor, // 电机编号
	input[3:0] TValue0, // 电机目标坐标百位
	input[3:0] TValue1, // 电机目标坐标十位
	input[3:0] TValue2, // 电机目标坐标个位
	input Busy, // Pulse模块标志位
	output reg[5:0] MotorOut, //输出电机号
	output reg[9:0] PulseNum, // 电机脉冲数
	output reg[5:0] DROut // 输入到Pulse的方向信号
	);
	reg[5:0] MotorIn; //输入电机号
	reg[5:0] DRSign; // 方向信号: 1反转，0正传
	reg[9:0] MotorValue; //当前电机位移
	reg[9:0] Value;
	reg[9:0] LastValue0;
	reg[9:0] LastValue1;
	reg[9:0] LastValue2;
	reg[9:0] LastValue3;
	reg[9:0] LastValue4;
	reg[9:0] LastValue5;

	always @(posedge sysclk or negedge rst) begin
		if (rst==0 || INIT==1) begin // 异步复位/初始值
			PulseNum <= 0; DRSign <= 0;
			Value <= 0; DROut <= 0;
			MotorValue <= 0; MotorIn <= 0; MotorOut <= 0;
			LastValue0 <= 0; LastValue1 <= 0; LastValue2 <= 0;
			LastValue3 <= 0; LastValue4 <= 0; LastValue5 <= 0;
		end
		else if (&initFlag==1 && Busy==0) begin // 标定好原点后
			// 计算输入电机的方向信号和位移值
			MotorIn <= MotorIn==Motor ? MotorIn : Motor;
			Value <= TValue0*100 + TValue1*10 + TValue2;
			case(MotorIn)
				6'b00_0001:begin
					MotorValue <= Value<LastValue0 ? LastValue0-Value : Value-LastValue0;
					DRSign[0] <= Value<LastValue0 ? 1 : (Value==LastValue0 ?  DRSign[0] : 0);
					LastValue0 <= Value;
				end
				6'b00_0010:begin
					MotorValue <= Value<LastValue1 ? LastValue1-Value : Value-LastValue1;
					DRSign[1] <= Value<LastValue1 ? 1 : (Value==LastValue1 ?  DRSign[1] : 0);
					LastValue1 <= Value;
				end
				6'b00_0100:begin
					MotorValue <= Value<LastValue2 ? LastValue2-Value : Value-LastValue2;
					DRSign[2] <= Value<LastValue2 ? 1 : (Value==LastValue2 ?  DRSign[2] : 0);
					LastValue2 <= Value;
				end
				6'b00_1000:begin
					MotorValue <= Value<LastValue3 ? LastValue3-Value : Value-LastValue3;
					DRSign[3] <= Value<LastValue3 ? 1 : (Value==LastValue3 ?  DRSign[3] : 0);
					LastValue3 <= Value;
				end
				6'b01_0000:begin
					MotorValue <= Value<LastValue4 ? LastValue4-Value : Value-LastValue4;
					DRSign[4] <= Value<LastValue4 ? 1 : (Value==LastValue4 ?  DRSign[4] : 0);
					LastValue4 <= Value;
				end
				6'b10_0000:begin
					MotorValue <= Value<LastValue5 ? LastValue5-Value : Value-LastValue5;
					DRSign[5] <= Value<LastValue5 ? 1 : (Value==LastValue5 ?  DRSign[5] : 0);
					LastValue5 <= Value;
				end
				6'b00_0000:begin
					MotorValue <= MotorValue;
					DRSign <= DRSign;
					LastValue0 <= LastValue0; LastValue1 <= LastValue1;
					LastValue2 <= LastValue2; LastValue3 <= LastValue3;
					LastValue4 <= LastValue4; LastValue5 <= LastValue5;
				end
			endcase
			// 假设脉冲数等于位移数
			// 若是查表，则等待查表成功后再写缓存，否则保持原值。
			PulseNum <= MotorValue==0 ? PulseNum : MotorValue;
			DROut <= MotorValue==0 ? DROut : DRSign;
			MotorOut <= MotorOut==MotorIn ? MotorOut : MotorIn;
		end
	end
endmodule
