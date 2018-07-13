`timescale 1ns/1ns
module Control_tb;
reg rst,sysclk;
reg[3:0] TValue0;
reg[3:0] TValue1;
reg[3:0] TValue2;
reg[5:0] Stop;
reg[5:0] Motor;
wire Busy,INIT;
wire[5:0] DR;
wire[5:0] PU;
wire[5:0] MF;
wire[5:0] DROut;
wire[5:0] MotorOut;
wire[5:0] initFlag;
wire[9:0] PulseNum;

Control CtrlPart(.rst(rst),.sysclk(sysclk),.initFlag(initFlag),.INIT(INIT),
				.Motor(Motor),.TValue0(TValue0),.TValue1(TValue1),.TValue2(TValue2),.Busy(Busy),
				.MotorOut(MotorOut),.PulseNum(PulseNum),.DROut(DROut));

Pulse PS(.sysclk(sysclk),
		.Motor(MotorOut),.PulseNum(PulseNum),.DRIn(DROut),.Stop(Stop),
		.Busy(Busy),.INIT(INIT),.initFlag(initFlag),.PU(PU),.MF(MF),.DR(DR));

initial begin
	rst = 1; sysclk = 0;
	Motor = 0;
	TValue0 = 0; TValue1 = 0; TValue2 = 0;
	Stop = 0;
	#1000 rst = 0;
	#1000 rst = 1;
	#5000 Stop = 6'b00_0001;
	#2000 Stop = 0;
	#10000 Stop = 6'b00_0010;
	#2000 Stop = 0;
	#3000 Stop = 6'b00_0100;
	#2000 Stop = 0;
	#5000 Stop = 6'b00_1000;
	#2000 Stop = 0;
	#7000 Stop = 6'b01_0000;
	#2000 Stop = 0;
	#4000 Stop = 6'b10_0000;
	#2000 Stop = 0;         // 原点标定完毕
	#10000 Motor = 6'b0_0010; TValue0 = 0; TValue1 = 1; TValue2 = 0;
	// 正转10步
	#30000 Motor = 6'b0_0010; TValue0 = 0; TValue1 = 0; TValue2 = 3;
	// 反转7步
	#30000 Motor = 6'b0_0001; TValue0 = 0; TValue1 = 0; TValue2 = 5;
	// 正转5步
	#30000 Motor = 6'b0_0001; TValue0 = 0; TValue1 = 0; TValue2 = 9;
	// 正转4步
	#100 Motor = 6'b0_0001; TValue0 = 0; TValue1 = 0; TValue2 = 7;
	// 模拟异常输入，由于后面的输入将此处缓存替换，故该行不起作用
	#100 Motor = 6'b0_0001; TValue0 = 0; TValue1 = 0; TValue2 = 5;
		// 模拟异常输入，应当上述正转4步后完成后再反转4步。
end

always #5 sysclk = ~sysclk;

endmodule
