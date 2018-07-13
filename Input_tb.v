`timescale 1ns/1ns
// Input模块测试文档
module Input_tb;
	reg rst,sysclk;
    reg Left, Right, Enter, Up, Down;
	wire[3:0] TValue0;
    wire[3:0] TValue1;
    wire[3:0] TValue2;
	wire[5:0] Motor;

	initial begin
    	rst = 1;
        sysclk = 1;
    	Left = 0;
    	Right = 0;
    	Enter = 0;
    	Up = 0;
    	Down = 0;
    	#100 rst = 0; // 复位
    	#100 rst = 1; // Motor:000000,MotorCache:000001,Num:00
                      // TValue0:0,TValue1:0,TValue2:0,
        #100 Down = 1;
        #100 Down = 0; // MotorCache:100000
        #100 Down = 1;
        #100 Down = 0; // MotorCache:010000
        #100 Left = 1;
        #100 Left = 0; // Num:11
        #100 Down = 1;
        #100 Down = 0; // TValue2:9
        #100 Down = 1;
        #100 Down = 0; // TValue2:8
        #100 Left = 1;
        #100 Left = 0; // Num:10
        #100 Down = 1;
        #100 Down = 0; // TValue1:9
        #100 Down = 1;
        #100 Down = 0; // TValue1:8
        #100 Left = 1;
        #100 Left = 0; // Num:01
        #100 Down = 1;
        #100 Down = 0; // TValue0:9
        #100 Down = 1;
        #100 Down = 0; // TValue0:8
        #100 Enter = 1;
        #100 Enter = 0; // Motor:010000
	end

    always #5 sysclk = ~sysclk;

	Input inputpart(.rst(rst),.sysclk(sysclk),
		.Left(Left),.Right(Right),.Up(Up),.Down(Down),.Enter(Enter),
		.TValue0(TValue0),.TValue1(TValue1),.TValue2(TValue2),.Motor(Motor));
endmodule
