// 脉冲信号产生模块。
module PulseSign(
	input rst,
	input clk,
	input[2:0] Motor,
	input Enable, // 使能信号
	input[9:0] PulseNum, // 脉冲数
	output reg[5:0] PUs, // 脉冲信号
	output reg[5:0] MFs,
	output reg Busy
	);
	reg[9:0] cnt;
	reg[14:0] Freqcnt;
	reg tmp;
	
	always @(posedge clk or negedge rst) begin
		if (rst==0 || Enable==0) begin
			Freqcnt = 0;
			PUs <= 0;
			cnt <= 0;
			tmp <= 0;
			Busy <= 0;
			MFs <= 0;
		end
		else if (Enable==1) begin // 可更改此处参数以改变频率 // 电机可接受脉冲频率的要求
			Busy <= cnt<PulseNum ? 1 : 0;
			if (Freqcnt==49) begin // 分频1/100
				Freqcnt <= 0;
				tmp <= cnt<PulseNum ? ~tmp : 0;
				cnt <= cnt<PulseNum ? (tmp==1 ? cnt+1 : cnt) : cnt;
			end
			else Freqcnt <= Freqcnt + 1;
			// send
			case(Motor)
				3'b000:begin
					PUs[0] <= tmp; MFs[0] <= Busy;
				end
				3'b001:begin
					PUs[1] <= tmp; MFs[1] <= Busy;
				end
				3'b010:begin
					PUs[2] <= tmp; MFs[2] <= Busy;
				end
				3'b011:begin
					PUs[3] <= tmp; MFs[3] <= Busy;
				end
				3'b100:begin
					PUs[4] <= tmp; MFs[4] <= Busy;
				end
				3'b101:begin
					PUs[5] <= tmp; MFs[5] <= Busy;
				end
			endcase
		end
	end

endmodule
