`timescale 1ns/1ns
module Control_tb;
reg rst;
reg clk;
reg[5:0] InitFlag;
reg[2:0] Motor;
reg[9:0] Value;
reg InputLock;
wire[9:0] PulseNum;
wire Enable;
wire[5:0] DRs;
wire[5:0] MFs;
wire[5:0] PUs;
wire Busy;

Control CtrlPart(.rst(rst),.clk(clk),
				.InitFlag(InitFlag),.Motor(Motor),.Value(Value),.InputLock(InputLock),.Busy(Busy),
				.PulseNum(PulseNum),.Enable(Enable),.DRs(DRs));

PulseSign PSPart(.rst(rst),.clk(clk),
				.Motor(Motor),.Enable(Enable),.PulseNum(PulseNum),
				.PUs(PUs),.MFs(MFs),.Busy(Busy));

initial begin
	rst = 0;
	clk = 0;
	InitFlag = 0;
	Motor = 0;
	Value = 0;
	InputLock = 0;
	#40 rst = 1;
	//#40 rst = 0;
	#40 InitFlag = 6'b11_1111;
	#40 Motor = 2;
	#40 InputLock = 1;
	#40 Value = 7;
	#40 InputLock = 0; // 正转7步
	#10000 Motor = 2;
	#40 InputLock = 1;
	#40 Value = 5;
	#40 InputLock = 0; // 反转2步
	#10000 Motor = 2;
	#40 InputLock = 1;
	#40 Value = 10;
	#40 InputLock = 0; // 正转5步
	#10000 Motor = 0;
	#40 InputLock = 1;
	#40 Value = 10;
	#40 InputLock = 0; // 正转10步
	#40 Motor = 0; // 模拟异常输入
	#40 InputLock = 1;
	#40 Value = 5;
	#40 InputLock = 0; // 由于上次电机还没转完，故等待正转10步完成后再进行反转5步
end

always #5 clk = ~clk;

endmodule
