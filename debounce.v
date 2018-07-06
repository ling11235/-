`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/06
// Design Name: 
// Module Name: DEBOUNCE
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: 按键消抖模块，消抖时间为20ms
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 消抖原理：当检测到输入按键电平的改变后，立即改变输出电平，并且在防抖时间内忽略输入按键电平的改变
//////////////////////////////////////////////////////////////////////////////////


module DEBOUNCE(
    input sys_clk,   // 输入：系统时钟   
    input key_i,     // 输入：原始按键电平
    output reg key_o     // 输出：消抖后的按键电平
    );
    
    parameter TIME = 240000;  // 消抖的时钟周期个数，等于时钟周期*消抖时间，需要根据实际条件修改
    parameter BITS = 20;   // 计数器的位数
    
    reg [BITS-1:0] count;   // 计数器
    reg key_count;          // 计数标志，输入按键电平出现翻转后变为高电平，并开始计数，计数结束后变为低电平
    reg key_i_temp;         // 输入按键电平的一个时钟周期的延时
    
    always @ (posedge sys_clk) begin
        key_i_temp <= key_i;
    end
    
    always @ (posedge sys_clk) begin
        if (key_count == 0 && key_i_temp != key_i) begin
            key_count <= 1;
        end
        else if ( count == (TIME-1) )
            key_count <= 0;
    end
    
    always @ (posedge sys_clk) begin
        if (key_count == 1)
            count <= count + 1;
        else
            count <= 0;
    end

    always @ (posedge sys_clk) begin
        if (key_count == 0 && key_i_temp != key_i)
            key_o <= key_i;
    end
        
    
endmodule
