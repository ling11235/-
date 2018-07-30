`timescale 1ns/1ps
// 全局初始化
module Init(
	input sysclk,
	output reg INIT  // 初始化标识
	);
	reg[1:0] CLKCNT;  // 时钟沿计数器 //仅初始化使用

	initial INIT = 1;
	initial CLKCNT = 0;

	always @(posedge sysclk) begin
		CLKCNT = INIT==1 ? CLKCNT+1 : 0;
		INIT <= CLKCNT==2'b10 ? 0 : INIT; // 2个周期后初始化结束
	end

endmodule
