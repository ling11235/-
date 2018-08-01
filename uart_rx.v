`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/26
// Design Name: 
// Module Name: UART_RX
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: UART串口接收
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module UART_RX #
(
    parameter DATA_WIDTH = 8   // 数据长度
)
(
    input sysclk,        // 系统时钟
    output reg [DATA_WIDTH-1:0] rx_data,   // 接收到的数据
    output reg rx_data_valid,    // 接收数据有效标志，一个时钟周期的高电平
    input rx             // 串口接收的信号
);

    parameter SCALE = 1250;   // FPGA时钟频率和波特率(9600)的比值
    parameter SCALE_BITS = 11;

    reg [SCALE_BITS-1:0] scale_cnt;   // 分频计数器

    reg [1:0] rx_state;   // UART接收状态
    // rx_state = 0, 空闲状态
    // rx_state = 1, 确认起始位到来状态
    // rx_state = 2, 正在接收状态
    // rx_state = 3, 等待终止位状态

    reg [2:0] data_cnt;      // 数据接收计数器，从0到DATA_WIDTH-1

    initial rx_state <= 0;

    initial rx_data_valid <= 0;

    always @ (posedge sysclk) begin
        if (rx == 0 && rx_state == 0) begin
            scale_cnt <= 0;
            rx_state <= 1;
        end 
        else if (rx == 1 && rx_state == 1) begin
            rx_state <= 0;  
        end
        else if (scale_cnt == (SCALE / 2 - 1) && rx_state == 1) begin
            scale_cnt <= 0;
            rx_state <= 2;
            data_cnt <= 0;  
        end
        else if (scale_cnt == (SCALE - 1) && rx_state == 2) begin
            scale_cnt <= 0;
            rx_state <= (data_cnt == DATA_WIDTH - 1) ? 3 : 2;
            data_cnt <= (data_cnt == DATA_WIDTH - 1) ? 0 : data_cnt + 1;
        end
        else if (scale_cnt == (SCALE - 1) && rx_state == 3) begin
            rx_state <= 0;
        end
        else scale_cnt <= scale_cnt + 1;
    end

    always @ (posedge sysclk) begin
        if (scale_cnt == (SCALE - 1) && rx_state == 2) 
            rx_data <= { rx, rx_data[DATA_WIDTH-1:1] };  
    end

    always @ (posedge sysclk) begin
        if (scale_cnt == (SCALE - 1) && rx_state == 2 && data_cnt == (DATA_WIDTH - 1))
            rx_data_valid <= 1;
        else rx_data_valid <= 0; 
    end



endmodule 