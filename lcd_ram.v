`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/12
// Design Name: 
// Module Name: LCD_RAM
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: 描述64行128列的LCD点阵的RAM，8行为一页，一共8页128列
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 地址说明：最高两位和最低一位构成页地址，中间位是列地址
//////////////////////////////////////////////////////////////////////////////////


module LCD_RAM(
    input sys_clk,   // 系统时钟
    input [9:0] addr_w,  // 写操作的地址
    input [7:0] data_w,      // 写入的一页数据
    input [9:0] addr_r,   // 读操作的地址
    output reg [7:0] data_r,     // 读出的一页数据
    input En_w            // 写入的使能信号，高电平有效
    );

    (* ram_style = "block" *)

    initial $readmemh("./lcd_matrix_ram.txt", lcd_data, 0, 1023);

    reg [7:0] lcd_data [0:1023];

    always @ (posedge sys_clk) begin
        data_r <= lcd_data[addr_r];
    end

    always @ (posedge sys_clk) begin
        if (En_w == 1)
            lcd_data[addr_w] <= data_w;
    end

   
endmodule
