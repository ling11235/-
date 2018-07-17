`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/10
// Design Name: 
// Module Name: SERIAL
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: 把8位的并行输入转化位串行输出，先输出低位，再输出高位
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SERIAL(
    input sys_clk,   // 系统时钟
    input [4:0] scnt,      // 串行输出计数器，5比特，计数周期等于20
    input [7:0] data_i,     // 输入的并行数据
    input En,               // 使能信号，低电平有效
    output data_o,  // 串行输出
    output reg cs   // 片选信号，在发送串行数据时保持低电平，其他时候保持高电平
    );
    
    initial cs <= 1;

    reg [7:0] data_tmp;   // 存储输入的并行数据

    always @ (posedge sys_clk) begin
        if (scnt == 19)  // 在传输结束后，片选信号保持高电平
            cs <= 1;
        else if  (scnt == 3)   // 开始传输
            cs <= En;
    end

    always @ (posedge sys_clk) begin
        if (scnt == 3)
            data_tmp <= data_i;
        else if (scnt[0] == 1)
            data_tmp <= data_tmp >> 1;
    end
    
    assign data_o = data_tmp[0];
   
endmodule
