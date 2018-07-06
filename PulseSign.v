// 脉冲信号产生模块。
module PulseSign(
	input rst,
	input clk,
	input Enable, // 使能信号
	input[9:0] PulseNum, // 脉冲数
	output reg Sign // 脉冲信号
	);
	reg tmp;
	reg Freqclk;
	reg[9:0] cnt;
	reg[14:0] Freqcnt;
	
	// 分频器，假设分频1/100
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			Freqclk = 0;
			Freqcnt = 0;
		end
		else begin // 可更改此处参数以改变频率
			Freqclk <= Freqcnt==49 ? ~Freqclk : Freqclk;
			Freqcnt <= Freqcnt==49 ? 0 : Freqcnt + 1;
		end
	end
	always @(posedge Freqclk or posedge rst) begin
		if (rst || !Enable) begin
			Sign = 0;
			cnt = 0;
			tmp = 0;
		end
		else if (Enable) begin
			Sign <= cnt<PulseNum ? ~Sign : 0;
			cnt <= cnt<PulseNum ? (Sign ? cnt+1 : cnt) : cnt;
		end
	end
endmodule