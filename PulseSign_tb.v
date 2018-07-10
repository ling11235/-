`timescale 1ns/1ns
// PulseSign测试文件
module PulseSign_tb;
	reg clk, rst, Enable;
	reg[9:0] PulseNum;
	wire Sign;

	initial begin
		clk = 0;
		rst = 0;
		Enable = 0;
		PulseNum = 5;
		#10 rst = 1;
		//#10 rst = 0;
		#50 Enable = 1;
		#11000 Enable = 0;
	end
	always #5 clk = ~clk;
	PulseSign PS(.rst(rst),.clk(clk),.Enable(Enable),.PulseNum(PulseNum),.Sign(Sign));

endmodule
