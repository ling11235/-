`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/06
// Design Name: 
// Module Name: KEY_DETECT
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: 检测按键按下的动作，在按键松开时输出一个时钟周期的高电平
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 在本模块钟，按键按下时，按键电平为高电平，可以根据实际情况修改
//////////////////////////////////////////////////////////////////////////////////


module KEY_DETECT(
    input sys_clk,   // 输入：系统时钟   
    input key_i,     // 输入：消除抖动后的按键电平
    output reg key_down     // 输出：对按键动作的检测结果，高电平有效
    );
    

    reg key_i_temp;         // 输入按键电平的一个时钟周期的延时
    
    always @ (posedge sys_clk) begin
        key_i_temp <= key_i;
    end

    always @ (posedge sys_clk) begin
        if (key_i == 0 && key_i_temp == 1)
            key_down <= 1;
        else
            key_down <= 0;
    end
    

endmodule
