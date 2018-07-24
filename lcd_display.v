`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/10
// Design Name: 
// Module Name: LCD_DISPLAY
// Project Name: 
// Target Devices: Arty S7
// Tool Versions: 
// Description: LCD显示模块
// 
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// Revision 1.1 - 增加修改显示数字的功能
//////////////////////////////////////////////////////////////////////////////////


module LCD_DISPLAY(
    input sys_clk,   // 系统时钟，这里频率设置为12MHz
    input [1:0] number_index,  // 输入的数字的显示位置
    // number_index = 0 -> 电机编号
    // number_index = 1 -> 位移第1位
    // number_index = 2 -> 位移第2位
    // number_index = 3 -> 位移第3位
    input [3:0] number_in,   // 输入的数字，0到9
    input number_modify_en,  // 修改数字的使能信号，一个时钟周期的高电平
    output reg reset_o, // 输出的对LCD进行硬件复位的信号，要求输出至少1us的低电平，复位完成后保持高电平，复位完成以后至少等待1us
    output sck,  // LCD的串行时钟
    output sda,  // 串行数据或者指令
    output reg rs,   // 寄存器选择，发送数据时为高电平，发送指令时为低电平
    output cs   // 片选信号，在发送数据或者指令时保持低电平，其他时候为高电平
    );

    reg [1:0] state;  // LCD的状态
    // state = 0, 复位状态
    // state = 1, 初始化状态
    // state = 2, 空闲状态
    // state = 3, 刷新屏幕状态
    reg begin_state_1;  // 一个时钟周期的高电平脉冲，作为初始化状态开始的控制信号
    reg begin_state_3;  // 一个时钟周期的高电平脉冲，作为刷新屏幕状态开始的控制信号
    

    // ######################################################## 
    // 实现上电后自动复位

    reg reset_label;     // 复位标志，初始状态为低电平，复位结束之后为高电平

    parameter RESET_WAIT_TIME = 1200;  // 在复位之前和复位之后的等待时间(设置为100us)对应的时钟周期个数
    parameter RESET_TIME = 1200;       // 复位时间(设置为100us)对应的时钟周期个数

    reg [11:0] reset_cnt;  // 对复位操作进行计时

    initial begin
        reset_o <= 1;
        reset_label <= 0;
        reset_cnt <= 0;
    end

    always @ (posedge sys_clk) begin
        if (reset_cnt == RESET_WAIT_TIME && reset_label == 0) 
            reset_o <= 0;
        else if (reset_cnt == ( RESET_WAIT_TIME + RESET_TIME ) )
            reset_o <= 1;
    end

    always @ (posedge sys_clk) begin
        if (reset_cnt == ( RESET_WAIT_TIME + RESET_TIME))
            reset_label <= 1;
    end

    always @ (posedge sys_clk) begin
        reset_cnt <= reset_cnt + 1;
    end

        
    // ############################################################
    // 设置串行数据发送

    reg [4:0] scnt;   // 用于串行数据或命令发送的计数器，计数周期为20
    reg [7:0] lcd_data;  // 并行的8位数据或者指令
    
    wire En;  // 使能信号，低电平有效

    assign En = ~state[0];

    always @ (posedge sys_clk) begin
        if (scnt == 19)
            scnt <= 0;
        else if (begin_state_1 == 1 || begin_state_3 == 1)
            scnt <= 0;
        else scnt <= scnt + 1;
    end

    assign sck = scnt[0];  // 串行时钟

    SERIAL serial(sys_clk, scnt, lcd_data, En, sda, cs);  


    ///////////////////////////////////////////////////
    // LCD指令ROM

    wire [7:0] inst_out;      // LCD的指令
    reg [3:0] addr_inst;  // LCD的指令在ROM中的地址

    LCD_INST_ROM lcd_inst_rom(addr_inst,inst_out);

    // 设置LCD的指令地址

    always @ (posedge sys_clk) begin
        if (begin_state_1 == 1)
            addr_inst <= 0;
        else if (state == 1 && scnt == 19)
            addr_inst <= addr_inst + 1;
    end

    ///////////////////////////////////////////////////////
    // LCD的点阵数据RAM
    reg [9:0] addr_write;   // 写入RAM的地址
    wire [7:0] data_write;   // 写入RAM的数据
    reg [9:0] addr_read;    // 读RAM的地址
    wire [7:0] data_read;    // 从RAM读出的数据
    reg write_en;       // 写入的使能信号，高电平有效


    reg [1:0] lcd_page_cnt; // 修改LCD的一页的计数器，周期为4
    // lcd_page_cnt = 0，设置页地址
    // lcd_page_cnt = 1，设置行地址高四位
    // lcd_page_cnt = 2，设置行地址低四位
    // lcd_page_cnt = 3，发送数据

    always @ (posedge sys_clk) begin
        if (begin_state_3 == 1)
            lcd_page_cnt <= 0;
        else if (scnt == 19)
            lcd_page_cnt <= lcd_page_cnt + 1;
    end

    // 设置读地址
    always @ (posedge sys_clk) begin
        if (begin_state_3 == 1)
            addr_read <= 0;
        else if (lcd_page_cnt == 3 && scnt == 19)
            addr_read <= addr_read + 1;
    end

    LCD_RAM lcd_ram(sys_clk,addr_write,data_write,addr_read,data_read,write_en);

    // #############################################################
    // 设置并行的数据或者指令

    //wire [7:0] inst_page_loc;  // 设置页地址
    //wire [7:0] inst_col_loc1;  // 设置列地址高4位
    //wire [7:0] inst_col_loc2;  // 设置列地址低4位
    
    always @ (posedge sys_clk) begin
        if (state == 1)
            lcd_data <= inst_out;    // 初始化命令
        else if (state == 3 && lcd_page_cnt == 0)
            lcd_data <= { 5'b10110,~addr_read[9:8],~addr_read[0] };   // 设置页地址
        else if (state == 3 && lcd_page_cnt == 1)
            lcd_data <= {5'b00010,addr_read[7:5]};   // 设置列地址高4位
        else if (state == 3 && lcd_page_cnt == 2)
            lcd_data <= {4'b0000,addr_read[4:1]};     // 设置列地址低4位
        else if (state == 3 && lcd_page_cnt == 3)
            lcd_data <= data_read;
    end
    

    // #############################################################
    // LCD的工作状态转移

    always @ (posedge sys_clk or negedge reset_o) begin
        if (reset_o == 0)    
            state <= 0;     // state = 0，LCD处于复位以及等待状态
        else if (begin_state_1 == 1)
            state <= 1;     // state = 1, 进入LCD初始化状态
        else if (begin_state_3 == 1)
            state <= 3;      // state = 3，进入刷新屏幕状态
        else if (addr_read == 1023 && state == 3 &&  lcd_page_cnt == 3 && scnt == 19)
            state <= 2;     // state = 2，进入空闲状态
    end

    always @ (posedge sys_clk or negedge reset_o) begin
        if (reset_o == 0)
            begin_state_1 <= 0;
        else if (reset_cnt == (RESET_TIME + 2 * RESET_WAIT_TIME) && state == 0)
            begin_state_1 <= 1;
        else begin_state_1 <= 0;
    end

    always @ (posedge sys_clk or negedge reset_o) begin
        if (reset_o == 0)
            begin_state_3 <= 0;
        else if (addr_inst == 13 && state == 1 && scnt == 19)
            begin_state_3 <= 1;
        else if (addr_write == 415 && state == 2)
            begin_state_3 <= 1;
        else begin_state_3 <= 0;
    end

    //////////////////////////////////////////////////////////
    // 设置寄存器选择信号
    always @ (posedge sys_clk or negedge reset_o) begin
        if (reset_o == 0)
            rs <= 0;
        else if (state == 3 && lcd_page_cnt == 3)
            rs <= 1;
        else rs <= 0;
    end

    ///////////////////////////////////////////////////////
    // 根据外部信号，修改显示的数字

    // 保存需要显示的4个数字的RAM
    (* ram_style = "distributed" *)
    reg [3:0] number_to_display [0:3];  

    // 记录需要显示的4位数字
    always @ (posedge sys_clk or negedge reset_o) begin
        if (reset_o == 0) begin
            number_to_display[0] <= 0;
            number_to_display[1] <= 0;
            number_to_display[2] <= 0;
            number_to_display[3] <= 0;
        end
        else if (number_modify_en == 1)
            number_to_display[number_index] <= number_in;   
    end

    // 设置写入LCD RAM的地址
    always @ (posedge sys_clk) begin
        if (number_modify_en == 1) 
            addr_write <= 144;   // 第一个数字在LCD点阵RAM中的地址
        else if (addr_write == 159) 
            addr_write <= 368;   // 第二个数字在LCD点阵RAM中的地址
        else addr_write <= addr_write + 1;
    end

    //使能信号有效时，把数字的显示位置保存到寄存器
    reg [1:0] number_index_reg;
    always @ (posedge sys_clk) begin
        if (number_modify_en == 1)
            number_index_reg <= number_index;
    end

    // 控制写入LCD RAM的使能信号
    always @ (posedge sys_clk or posedge reset_o) begin
        if (reset_o == 0)
            write_en <= 0;
        else if (number_modify_en == 1)
            write_en <= 1;
        else if (addr_write == 415)
            write_en <= 0;
    end

    
    reg [1:0] number_count;  // 对写入LCD RAM的数计数，从0开始，每写完一个加1

    always @ (posedge sys_clk) begin
        if (number_modify_en == 1)
            number_count <= 0;
        else if (addr_write[3:0] == 15)  // 当前的数字点阵已经全部写入LCD RAM
            number_count <= number_count + 1;
    end

    // 从LCD的数字点阵ROM中读取
    wire [7:0] data_write_temp;  // 从LCD数字点阵读出的数据
    wire [7:0] number_rom_read_addr;   // 读地址
    assign number_rom_read_addr = { number_to_display[number_count], addr_write[3:0]};
    LCD_NUMBER_ROM lcd_number_rom(number_rom_read_addr ,data_write_temp);
    
    // 当前设置的数字的点阵需要取反
    assign data_write = (number_count == number_index_reg) ? (~data_write_temp) : (data_write_temp); 

endmodule
