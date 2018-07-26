//`timescale 1ns / 1ps
`timescale 1ns/1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/25
// Design Name: 
// Module Name: KEY_DEBOUNCE_DETECT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 检测输入按键电平，当检测到按键按下后，输出一个时钟周期的高电平
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module KEY_DEBOUNCE_DETECT(
    input sys_clk,   // 输入：系统时钟   
    input key_i,     // 输入：原始按键电平，按下时为高电平
    output reg key_o     // 输出：按键检测结果，如果检测到按键按下，输出一个时钟周期的高电平
    );
    
    parameter WAIT_TIME = 480000;  // 检测到从低电平变为高电平后等待WAIT_TIME个时钟周期
    parameter DISABLE_TIME = 1920000;  // 确认按键按下后等待DISABLE_TIME个时钟周期
    parameter STABLE_TIME = 120000;   // 如果电平在STABLE_TIME个时钟周期维持高电平，则确认按键按下
    parameter BITS = 21;   // 计数器的位数
    
    reg [1:0] state;   // 模块内部状态
    // state = 0 -> 空闲，等待电平变化
    // state = 1 -> 检测到电平变化后后等待状态
    // state = 2 -> 检测高电平可以维持STABLE_TIME个时钟周期的状态
    // state = 3 -> 确认按键按下后的等待状态
    reg [BITS-1:0] count;   // 计数器
    reg key_i_temp;         // 输入按键电平的一个时钟周期的延时

    initial state <= 0;
    initial key_o <= 0;
    
    always @ (posedge sys_clk) begin
        key_i_temp <= key_i;
    end

    always @ (posedge sys_clk) begin
        if (state == 0 && key_i == 1 && key_i_temp == 0) begin
            state <= 1;
            count <= 0;
            key_o <= 0;
        end
        else if (state == 1 && count == WAIT_TIME) begin
            state <= 2;
            count <= 0;
            key_o <= 0;
        end
        else if (state == 2 && count == STABLE_TIME) begin
            state <= 3;
            count <= 0;
            key_o <= 1;
        end
        else if (state == 2 && key_i == 0) begin
            state <= 0;
            count <= 0;
            key_o <= 0;
        end 
        else if (state == 3 && count == DISABLE_TIME) begin
            state <= 0;
            count <= 0;
            key_o <= 0;
        end
        else begin
            state <= state;
            key_o <= 0;
            count <= count + 1;
        end
    end

endmodule
