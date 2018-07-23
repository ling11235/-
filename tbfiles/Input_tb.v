`timescale 1ns/1ns
// Input模块测试文档
module Input_tb;
	reg sysclk;
    reg Left, Right, Enter, Up, Down;
    reg INIT;
	wire[3:0] TValue0;
    wire[3:0] TValue1;
    wire[3:0] TValue2;
	wire[5:0] Motor;
    wire[1:0] Num; // 位号
    wire LCD_Enable; // LCD使能信号
    wire[3:0] LCD_Num; // LCD显示数字

	initial begin
    	sysclk = 1;
    	Left = 0; Right = 0;
    	Enter = 0;
    	Up = 0; Down = 0;
        INIT = 1;
        #50 INIT = 0;

        #200 Down = 1;
        #200 Down = 0;
        #200 Down = 1;
        #200 Down = 0;
        #200 Left = 1;
        #200 Left = 0;
        #200 Down = 1;
        #200 Down = 0;
        #200 Down = 1;
        #200 Down = 0;
        #200 Left = 1;
        #200 Left = 0;
        #200 Down = 1;
        #200 Down = 0;
        #200 Down = 1;
        #200 Down = 0;
        #200 Left = 1;
        #200 Left = 0;
        #200 Down = 1;
        #200 Down = 0;
        #200 Down = 1;
        #200 Down = 0;
        #200 Enter = 1;
        #200 Enter = 0;
        
	end

    always #5 sysclk = ~sysclk;

	Input inputpart(.sysclk(sysclk),.INIT(INIT),
		.Left(Left),.Right(Right),.Up(Up),.Down(Down),.Enter(Enter),
		.TValue0(TValue0),.TValue1(TValue1),.TValue2(TValue2),.Motor(Motor),
        .Num(Num),.LCD_Enable(LCD_Enable),.LCD_Num(LCD_Num));
endmodule
