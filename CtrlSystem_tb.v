`timescale 1ns/1ns
// CtrlSystem测试文件
module CtrlSystem_tb;
reg rst, sysclk;
reg Left, Right, Up, Down, Enter;
reg[5:0] Stop;
wire[5:0] PU, MF, DR;

initial begin
	rst = 1; sysclk = 0;
	Left = 0; Right = 0; Up = 0; Down = 0; Enter = 0;
	Stop = 0;
	// 共6个电机：0,1,2,3,4,5
	#5000 Stop = 6'b00_0001;
	#2000 Stop = 0;         // 0标定
	#10000 Stop = 6'b00_0010;
	#2000 Stop = 0;         // 1标定
	#3000 Stop = 6'b00_0100;
	#2000 Stop = 0;         // 2标定
	#5000 Stop = 6'b00_1000;
	#2000 Stop = 0;         // 3标定
	#7000 Stop = 6'b01_0000;
	#2000 Stop = 0;         // 4标定
	#4000 Stop = 6'b10_0000;
	#2000 Stop = 0;         // 5标定

	#10000 Up = 1;
	#1000 Up = 0;			// 1号
	#10000 Down = 1;
	#1000 Down = 0;			// 0号
	#10000 Down = 1;
	#1000 Down = 0;			// 5号

	#10000 Right = 1;		// 百位
	#1000 Right = 0;
	#10000 Right = 1;		// 十位
	#1000 Right = 0;
	#10000 Right = 1;		// 个位
	#1000 Right = 0;
	#10000 Up = 1;
	#1000 Up = 0;			// 1
	#10000 Left = 1;
	#1000 Left = 0;			// 十位
	#10000 Up = 1;
	#1000 Up = 0;			// 1
	#10000 Enter = 1;
	#1000 Enter = 0;		// 设定5号电机坐标为011

	#100000 Down = 1;		// 0
	#1000 Down = 0;
	#10000 Right = 1;		// 个位
	#1000 Right = 0;
	#10000 Down = 1;		// 0
	#1000 Down = 0;
	#100000 Down = 1;		// 9
	#1000 Down = 0;
	#100000 Down = 1;
	#1000 Down = 0;			// 8
	#10000 Enter = 1;
	#1000 Enter = 0;		// 设定5号电机坐标为008

	#100000 Right = 1;		// 电机位
	#1000 Right = 0;
	#10000 Up = 1;			// 0
	#1000 Up = 0;
	#10000 Up = 1;
	#1000 Up = 0;			// 1

	#10000 Left = 1;		// 个位
	#1000 Left = 0;
	#10000 Up = 1;			// 9
	#1000 Up = 0;
	#10000 Up = 1;			// 0
	#1000 Up = 0;
	#10000 Up = 1;			// 1
	#1000 Up = 0;
	#10000 Left = 1;		// 十位
	#1000 Left = 0;
	#10000 Up = 1;			// 1
	#1000 Up = 0;
	#10000 Enter = 1;
	#1000 Enter = 0;		// 设定1号电机坐标为011

	#100000 rst = 0;		// 异步复位
	#1000 rst = 1;
end

always #5 sysclk = ~sysclk;

CtrlSystem CSpart(.rst(rst),.sysclk(sysclk),.Stop(Stop),
			.Left(Left),.Right(Right),.Up(Up),.Down(Down),.Enter(Enter),
			.PU(PU),.MF(MF),.DR(DR));

endmodule
