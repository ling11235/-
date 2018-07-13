`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/12
// Design Name: 
// Module Name: LCD_INST_ROM
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: 保存LCD的控制命令的ROM
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LCD_INST_ROM(
    input [3:0] addr_r,   // 读操作的地址
    output [7:0] data_r     // 读出的命令
    );

    (* ram_style = "distributed" *)

    reg [7:0] lcd_inst [0:12];

    initial $readmemh("./lcd_inst_rom.txt", lcd_inst, 0, 12);

    assign data_r = lcd_inst[addr_r];
   
endmodule
