`timescale 1ns/1ns
// Pulse测试文件
module Pulse_tb;
reg sysclk;
reg[5:0] Motor;
reg[9:0] PulseNum;
reg[5:0] Stop;
wire Busy;
wire[5:0] initFlag;
wire[5:0] PU;
wire[5:0] MF;


Pulse PS(.sysclk(sysclk),.Motor(Motor),.PulseNum(PulseNum),.Stop(Stop),
		.Busy(Busy),.initFlag(initFlag),.PU(PU),.MF(MF));

initial begin
	sysclk = 0;
	Motor = 0;
	PulseNum = 0;
	Stop = 0;
	#10000 Stop = 6'b00_0001;
	#1000 Stop = 0;
	#10000 Stop = 6'b00_0010;
	#1000 Stop = 0;
	#10000 Stop = 6'b00_0100;
	#1000 Stop = 0;
	#10000 Stop = 6'b00_1000;
	#1000 Stop = 0;
	#10000 Stop = 6'b01_0000;
	#1000 Stop = 0;
	#10000 Stop = 6'b10_0000;
	#1000 Stop = 0;         // 原点标定完毕
	#10000 Motor = 6'b0_0010; PulseNum = 5;
	#10000 PulseNum = 2;
	#10000 Motor = 6'b0_1000; PulseNum = 5;
	
end
always #5 sysclk = ~sysclk; // 时钟周期10ns, 脉冲周期1000ns
endmodule
