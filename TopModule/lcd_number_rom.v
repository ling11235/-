`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/12
// Design Name: 
// Module Name: LCD_NUMBER_ROM
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: 保存数字0到9的16×8点阵
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LCD_NUMBER_ROM(
    input [7:0] addr_r,   // 读操作的地址
    output [7:0] data_r     // 读出的点阵
    );

    (* ram_style = "block" *)

    reg [7:0] lcd_number [0:159];

    initial $readmemh("./lcd_number_rom.txt", lcd_number, 0, 159);

    assign data_r = lcd_number[addr_r];
   
endmodule
