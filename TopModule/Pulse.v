`timescale 1ns/1ps
// 有初始化的脉冲信号产生模块。
module Pulse(
	input sysclk,
	input INIT,
	input[5:0] Motor,
	input[9:0] PulseNum,
	input[5:0] DRIn,
	input[5:0] Stop, // 限位触发信号
	output reg Busy, // 工作标志
	output reg[5:0] initFlag, // 原点标定标志
	output reg[5:0] PU, // 脉冲
	output reg[5:0] MF, // 上电
	output reg[5:0] DR // 方向
	);
	reg Sign,SS,DSS;
	wire[5:0] SignCopys;
	wire[5:0] BusyCopys;
	reg[5:0] LastStop;
	reg[5:0] LastMotor; // 上次电机
	reg[9:0] LastPulse; // 上次脉冲数
	reg[9:0] Signcnt;
	reg[14:0] Freqcnt;

	parameter Boundry = 3000000; // 0.25Hz
	//parameter Boundry = 50; // 分频倍数

	//Stop上升沿检测
	always @(posedge sysclk) begin
		LastStop <= Stop;
		SS <= LastStop==Stop ? 0 : (|Stop); // Stop上升沿
		DSS <= LastStop==Stop ? 0 : (|LastStop); // Stop下降沿
	end
	
	// initFlag信号初始化为0, 假定Stop初始时为0
	always @(posedge sysclk) begin
		if (INIT==1)
			initFlag <= 0;
		else
			initFlag <= DSS==1 ? (initFlag<<1) + 1 : initFlag;
	end
	// LastPulse
	always @(posedge sysclk) begin
		if (&initFlag) // 已标定原点
			LastPulse <= LastPulse==PulseNum ? LastPulse : PulseNum;
		else begin //标定原点时步进脉冲数为1
			LastPulse <= 1;
		end
	end
	// LastMotor
	always @(posedge sysclk) begin
		if (&initFlag) // 已标定原点
			LastMotor <= LastMotor==Motor ? LastMotor : Motor;
		else begin// 初值为1,6次移位后终值为0
			if (INIT==1)
				LastMotor <= 1;
			else
				LastMotor <= DSS==1 ? LastMotor<<1 : LastMotor;
		end
	end
	// DR
	always @(posedge sysclk) begin
		if (&initFlag)
			DR <= DRIn;
		else
			DR <= Stop;
	end
	// Busy
	always @(posedge sysclk) begin
		if (&initFlag) begin  // 已标定原点
			// 脉冲发射完后置0
			if (DR==DRIn && LastPulse==PulseNum && LastMotor==Motor)
				Busy <= Signcnt<LastPulse ? Busy : 0;
			else // 脉冲数或电机号或者转动方向发生变化后置1
				Busy <= 1;
		end
		else begin
			if (INIT==1)
				Busy <= 0;
			else if (Stop==0) 
				Busy <= (Signcnt<LastPulse ? 1 : 0);
			else begin
				if (SS==1)
					Busy <= 0;
				else begin
					Busy <= Signcnt<LastPulse ? 1 : (DSS==1 ? 0 : Busy);
				end
			end
		end
	end
	// 分频计数器 // 频率可调
	always @(posedge sysclk) begin
		if (Busy==0)
			Freqcnt <= 0;
		else
			Freqcnt <= Freqcnt==Boundry-1 ? 0 : Freqcnt + 1;
	end
	// 脉冲计数器
	always @(posedge sysclk) begin
		if (Busy==0)
			Signcnt <= 0;
		else begin
			if (Freqcnt==Boundry-1) begin
				if (Signcnt<LastPulse) 
					Signcnt <= Sign==0 ? Signcnt+1 : Signcnt;
				else
					Signcnt <=  Signcnt;
			end
			else
				Signcnt <= Signcnt;
		end
	end
	// 脉冲信号
	always @(posedge sysclk) begin
		if (Busy==0)
			Sign <= 1;
		else begin
			if (Freqcnt==Boundry-1) begin
				Sign <= Signcnt<LastPulse ? ~Sign : 1;
			end
			else
				Sign <= Sign;
		end
	end
	// 根据电机编号输出控制信号
	assign SignCopys = {Sign,Sign,Sign,Sign,Sign,Sign};
	assign BusyCopys = {Busy,Busy,Busy,Busy,Busy,Busy};

	always @(posedge sysclk) begin
		if (Busy==0) begin
			PU <= 6'b11_1111; MF <= 0;
		end
		else begin
			PU <= (~LastMotor) | SignCopys;
			MF <= LastMotor & BusyCopys;
		end
	end
endmodule
