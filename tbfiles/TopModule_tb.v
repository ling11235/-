`timescale 1ns/1ps
// TopModule.v的测试文件
module TopModule_tb();
reg sysclk, L, R, U, D, E;
reg[5:0] Stop;
wire[4:0] LED;
wire[2:0] Wave;
wire reset_o, sck, sda, rs, cs;

initial begin
	sysclk = 0;
	L = 0; R = 0; U = 0; D = 0; E = 0;
	Stop = 0;

	// Original Point
	#10000 Stop = 6'b00_0001;
	#10000 Stop = 0;
	#30000 Stop = 6'b00_0010;
	#10000 Stop = 0;
	#30000 Stop = 6'b00_0100;
	#10000 Stop = 0;
	#40000 Stop = 6'b00_1000;
	#10000 Stop = 0;
	#50000 Stop = 6'b01_0000;
	#10000 Stop = 0;
	#20000 Stop = 6'b10_0000;
	#10000 Stop = 0;

	// set Values
	#100000 L = 1;
	#10000 L = 0;
	#50000 U = 1;
	#10000 U = 0;
	#50000 L = 1;
	#10000 L = 0;
	#50000 U = 1;
	#10000 U = 0;
	#50000 E = 1;
	#10000 E = 0;	//M0:Value:11,PulseNum:11

	#100000 D = 1;
	#10000 D = 0;
	#50000 R = 1;
	#10000 R = 0;
	#50000 D = 1;
	#10000 D = 0;
	#100000 D = 1;
	#10000 D = 0;
	#100000 D = 1;
	#10000 D = 0;
	#50000 E = 1;
	#10000 E = 0;	//M0:Value:8,PulseNum:3

	#100000 R = 1;
	#10000 R = 0;
	#50000 D = 1;
	#10000 D = 0;
	#50000 E = 1;
	#1000 E = 0;	//M5:Value:8,PulseNum:8
	#500 D = 1;
	#1000 D = 0;
	#500 E = 1;
	#1000 E = 0;	//M4:Value:8,PulseNum:8 (After Sending the LAST Pulse Signal.)
end

always #5 sysclk = ~sysclk;

TopModule TMpart(.sysclk(sysclk),.Stop(Stop),
			.L(L),.R(R),.U(U),.D(D),.E(E),
			.LED(LED),.Wave(Wave),
			.reset_o(reset_o),.sck(sck),.sda(sda),.rs(rs),.cs(cs));

endmodule
