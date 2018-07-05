`timescale 1ns/1ns

module Input_tb;
	reg rst, clk;
	reg Left, Right, Enter, Up, Down;
	wire[3:0] Value0;
	wire[3:0] Value1;
	wire[3:0] Value2;
	wire[2:0] Motor;
	wire Lock;

	initial begin
    	rst = 1'b0;
    	clk = 1'b0;
    	Left = 1'b0;
    	Right = 1'b0;
    	Enter = 1'b0;
    	Up = 1'b0;
    	Down = 1'b0;
    	#30 rst = 1;
    	#10 rst = 0;
    	#30 Right = 1;
    	#10 Right = 0;
    	#30 Right = 1;
    	#10 Right = 0;
    	#30 Right = 1;
    	#10 Right = 0;
    	#30 Right = 1;
    	#10 Right = 0;
    	#30 Right = 1;
    	#10 Right = 0;
    	#30 Left = 1;
    	#10 Left = 0;
    	#30 Left = 1;
    	#10 Left = 0;
    	#30 Left = 1;
    	#10 Left = 0;
    	#30 Enter = 1;
    	#10 Enter = 0;
    	#30 Right = 1;
    	#10 Right = 0;
    	#30 Right = 1;
    	#10 Right = 0;
    	#30 Up = 1;
    	#10 Up = 0;
    	#30 Up = 1;
    	#10 Up = 0;
    	#30 Down = 1;
    	#10 Down = 0;
    	#30 Down = 1;
    	#10 Down = 0;
    	#30 Down = 1;
    	#10 Down = 0;
    	#30 Down = 1;
    	#10 Down = 0;
    	#30 Enter = 1;
    	#10 Enter = 0;
	end
	always #5 clk = ~clk;

	Input inputpart(.clk(clk),.rst(rst),
		.Left(Left),.Right(Right),.Enter(Enter),.Up(Up),.Down(Down),
		.Value0(Value0),.Value1(Value1),.Value2(Value2),
		.Motor(Motor),.Lock(Lock));

endmodule
