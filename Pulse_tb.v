`timescale 1ns/1ns
// Pulse测试文件
module Pulse_tb;
reg sysclk;
reg[5:0] Motor;
reg[5:0] Stop;
reg[5:0] DRIn;
reg[9:0] PulseNum;
wire Busy;
wire[5:0] initFlag;
wire[5:0] PU;
wire[5:0] MF;
wire[5:0] DR;

Pulse PS(.sysclk(sysclk),.Motor(Motor),.PulseNum(PulseNum),.DRIn(DRIn),.Stop(Stop),
		.Busy(Busy),.INIT(INIT),.initFlag(initFlag),.PU(PU),.MF(MF),.DR(DR));

initial begin
	sysclk = 0;
	Motor = 0;
	PulseNum = 0;
	Stop = 0;
	DRIn = 0;
	#10000 Stop = 6'b00_0001;
	#2000 Stop = 0;
	#10000 Stop = 6'b00_0010;
	#2000 Stop = 0;
	#10000 Stop = 6'b00_0100;
	#2000 Stop = 0;
	#10000 Stop = 6'b00_1000;
	#2000 Stop = 0;
	#10000 Stop = 6'b01_0000;
	#2000 Stop = 0;
	#10000 Stop = 6'b10_0000;
	#2000 Stop = 0;
	// 原点标定完毕
	#10000 Motor = 6'b0_0010; PulseNum = 5; DRIn = 6'b0_0000;
	#10000 PulseNum = 2; DRIn = 6'b0_0010;
	#10000 Motor = 6'b0_1000; PulseNum = 5; DRIn = 6'b0_0010;
	
end
always #5 sysclk = ~sysclk; // 时钟周期10ns, 脉冲周期1000ns
endmodule
