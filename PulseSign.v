// 脉冲信号产生模块。
module PulseSign(
	input rst,
	input clk,
	input Motor,
	input Enable, // 使能信号
	input[9:0] PulseNum, // 脉冲数
	output reg Sign // 脉冲信号
	);
	reg[9:0] cnt;
	reg[14:0] Freqcnt;
	
	always @(posedge clk or negedge rst) begin
		if (rst==1 || Enable==0) begin
			Freqcnt = 0;
			Sign = 0;
			cnt = 0;
		end
		else if (Enable==1) begin // 可更改此处参数以改变频率 // 电机可接受脉冲频率的要求
			if (Freqcnt==49) begin // 分频1/100
				Freqcnt <= 0;
				Sign <= cnt<PulseNum ? ~Sign : 0;
				cnt <= cnt<PulseNum ? (Sign==1 ? cnt+1 : cnt) : cnt;
			end
			else Freqcnt <= Freqcnt + 1;
		end
	end

endmodule
