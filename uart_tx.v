`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/26
// Design Name: 
// Module Name: UART_TX
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: UART串口发送
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module UART_TX #
(
    parameter DATA_WIDTH = 8   // 数据长度
)
(
    input sysclk,        // 系统时钟
    input [DATA_WIDTH-1:0] tx_data,   // 待发送的数据
    input tx_data_valid,    // 发送数据有效标志
    output tx,              // 串口发射的信号
    output reg tx_busy          // 发送忙标志，正在发送时为高电平，空闲时为低电平
);

    parameter SCALE = 1250;   // FPGA时钟频率和波特率(9600)的比值
    parameter SCALE_BITS = 11;

    reg [SCALE_BITS-1:0] scale_cnt;   // 分频计数器
    reg [3:0] data_cnt;              // 数据传输计数器，从0到DATA_WIDTH+1

    reg [DATA_WIDTH+1:0] tx_data_reg;   // 保存待发送数据的寄存器，其中最高位为终止位1，最低位为起始位0

    initial tx_busy <= 0;

    always @ (posedge sysclk) begin
        if (tx_data_valid == 1 && tx_busy == 0) begin
            scale_cnt <= 0;
            data_cnt <= 0;
            tx_busy <= 1;
        end
        else if (scale_cnt == (SCALE - 1) && tx_busy == 1) begin
            if (data_cnt == (DATA_WIDTH + 1)) begin
                data_cnt <= 0;
                tx_busy <= 0;
                scale_cnt <= 0;
            end
            else begin
                data_cnt <= data_cnt + 1;
                tx_busy <= 1;
                scale_cnt <= 0;
            end           
        end
        else begin
            scale_cnt <= scale_cnt + 1;
            tx_busy <= tx_busy;
            data_cnt <= data_cnt;   
        end
        
    end

    always @ (posedge sysclk) begin
        if (tx_data_valid == 1 && tx_busy == 0)
            tx_data_reg <= {1'b1, tx_data, 1'b0};
        else if (scale_cnt == (SCALE - 1))
            tx_data_reg <= tx_data_reg >> 1;
    end

    assign tx = (tx_busy == 1)? tx_data_reg[0] : 1;


endmodule