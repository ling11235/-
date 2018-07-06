`timescale 1ns/1ns
// Input模块测试文件
module Input_tb;
	reg rst, Left, Right, Enter, Up, Down;
	wire[9:1'b0] Value;
	wire[2:1'b0] Motor;
	wire Lock;

	initial begin
    	rst = 1'b0;
    	Left = 1'b0;
    	Right = 1'b0;
    	Enter = 1'b0;
    	Up = 1'b0;
    	Down = 1'b0;
    	#40 rst = 1'b1; // Value:0,Motor:0,Lock:0
    	#10 rst = 1'b0;
    	#40 Right = 1'b1; // Motor:1
    	#10 Right = 1'b0;
    	#40 Left = 1'b1; // Motor:0
    	#10 Left = 1'b0;
        #40 Left = 1'b1; // Motor:5
        #10 Left = 1'b0;
    	#40 Enter = 1'b1; // Lock:1
    	#10 Enter = 1'b0;
        #40 Up = 1'b1; // Value:100
        #10 Up = 1'b0;
        #40 Down = 1'b1; // Value:000
        #10 Down = 1'b0;
        #40 Down = 1'b1; // Value:900
        #10 Down = 1'b0;
    	#40 Right = 1'b1; // 十位
    	#10 Right = 1'b0;
        #40 Up = 1'b1; // Value:910
        #10 Up = 1'b0;
        #40 Down = 1'b1; // Value:900
        #10 Down = 1'b0;
        #40 Down = 1'b1; // Value:990
        #10 Down = 1'b0;
        #40 Right = 1'b1; // 个位
        #10 Right = 1'b0;
        #40 Up = 1'b1; // Value:991
        #10 Up = 1'b0;
        #40 Down = 1'b1; // Value:990
        #10 Down = 1'b0;
        #40 Down = 1'b1; // Value:999
        #10 Down = 1'b0;
        #40 Right = 1'b1; // 百位
        #10 Right = 1'b0;
        #40 Up = 1'b1; // Value:099
        #10 Up = 1'b0;
        #40 Down = 1'b1; // Value:999
        #10 Down = 1'b0;
        #40 Down = 1'b1; // Value:899
        #10 Down = 1'b0;
    	#40 Enter = 1'b1; // Lock:0
    	#10 Enter = 1'b0;
	end

	Input inputpart(.rst(rst),
		.Left(Left),.Right(Right),.Enter(Enter),.Up(Up),.Down(Down),
		.Value(Value),.Motor(Motor),.Lock(Lock));

endmodule
