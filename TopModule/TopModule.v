`timescale 1ns/1ps
// 五键输入，产生电机的控制信号，初始化时标定原点。
// 需要有传感器输入限位信号Stop。
module TopModule(
	input sysclk,
	input L,
	input R,
	input U,
	input D,
	input E,
	input[5:0] Stop, 
	output wire[9:0] LED, 
	output reset_o, // 输出的对LCD进行硬件复位的信号，要求输出至少1us的低电平，复位完成后保持高电平，复位完成以后至少等待1us
  output sck,  // LCD的串行时钟
  output sda,  // 串行数据或者指令
  output rs,   // 寄存器选择，发送数据时为高电平，发送指令时为低电平
  output cs   // 片选信号，在发送数据或者指令时保持低电平，其他时候为高电平
	);
	
	parameter DATA_NUM = 1000;
	parameter DATA_WIDTH = 10;

	wire Left, Right, Up, Down, Enter;
	wire LCD_Enable, Busy, INIT;
	wire[1:0] Num;
	wire[3:0] LCD_Num, Motor;
	wire[5:0] o_Motor, DROut, initFlag;
	wire[5:0] Stop_DB, PU, MF, DR;
	wire[9:0] Value;
	wire[DATA_WIDTH-1:0] PulseNum;

	assign LED[5:0] = initFlag;
	assign LED[6] = PU[0];
	assign LED[7] = MF[0];
	assign LED[8] = DR[0];
	assign LED[9] = Busy; 

	KEY_DEBOUNCE_DETECT LDB(.sys_clk(sysclk),.key_i(L),.key_o(Left));
	KEY_DEBOUNCE_DETECT RDB(.sys_clk(sysclk),.key_i(R),.key_o(Right));
	KEY_DEBOUNCE_DETECT UDB(.sys_clk(sysclk),.key_i(U),.key_o(Up));
	KEY_DEBOUNCE_DETECT DDB(.sys_clk(sysclk),.key_i(D),.key_o(Down));
	KEY_DEBOUNCE_DETECT EDB(.sys_clk(sysclk),.key_i(E),.key_o(Enter));

    DEBOUNCE SDB0(.sys_clk(sysclk),.key_i(Stop[0]),.key_o(Stop_DB[0]));
    DEBOUNCE SDB1(.sys_clk(sysclk),.key_i(Stop[1]),.key_o(Stop_DB[1]));
    DEBOUNCE SDB2(.sys_clk(sysclk),.key_i(Stop[2]),.key_o(Stop_DB[2]));
    DEBOUNCE SDB3(.sys_clk(sysclk),.key_i(Stop[3]),.key_o(Stop_DB[3]));
    DEBOUNCE SDB4(.sys_clk(sysclk),.key_i(Stop[4]),.key_o(Stop_DB[4]));
    DEBOUNCE SDB5(.sys_clk(sysclk),.key_i(Stop[5]),.key_o(Stop_DB[5]));

	Init initpart(.sysclk(sysclk),.INIT(INIT));

	Input inputpart(.sysclk(sysclk),.INIT(INIT),
				.Left(Left),.Right(Right),.Up(Up),.Down(Down),.Enter(Enter),
				.Num(Num),.LCD_Enable(LCD_Enable),.LCD_Num(LCD_Num),
				.Value(Value),.Motor(Motor));

	LCD_DISPLAY lcddisplay(.sys_clk(sysclk),
    				.number_index(Num),.number_in(LCD_Num),.number_modify_en(LCD_Enable),
    				.reset_o(reset_o),.sck(sck),.sda(sda),.rs(rs),.cs(cs));

	Control Ctrlpart(.sysclk(sysclk),.INIT(INIT),
					.initFlag(initFlag),.Busy(Busy),
					.i_Motor(Motor),.Value(Value),
					.o_Motor(o_Motor),.PulseNum(PulseNum),.DROut(DROut));

	Pulse pulsepart(.sysclk(sysclk),.INIT(INIT),.Stop(Stop_DB),
				.Motor(o_Motor),.PulseNum(PulseNum),.DRIn(DROut),
				.Busy(Busy),.initFlag(initFlag),.PU(PU),.MF(MF),.DR(DR));

endmodule
