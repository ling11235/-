`timescale 1ns / 1ps
//`timescale 1ns/1ns // JUST FOR TEST !!
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/19 14:22:07
// Design Name: 
// Module Name: DEBOUNCE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DEBOUNCE(
    input sys_clk,   // 输入：系统时钟   
    input key_i,     // 输入：原始按键电平
    output reg key_o     // 输出：消抖后的按键电平
    );
    
    parameter TIME = 240000;  // 消抖的时钟周期个数，等于时钟周期*消抖时间，需要根据实际条件修改
    //parameter TIME = 50; // JUST FOR TEST!!
    parameter BITS = 20;   // 计数器的位数
    
    reg [BITS-1:0] count;   // 计数器
    reg key_count;          // 计数标志，输入按键电平出现翻转后变为高电平，并开始计数，计数结束后变为低电平
    reg key_i_temp;         // 输入按键电平的一个时钟周期的延时

    initial key_count = 0; // JUST FOR TEST !!
    initial key_i_temp = 0; // JUST FOR TEST !!
    initial key_o = 0; // JUST FOR TEST !!
    
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
