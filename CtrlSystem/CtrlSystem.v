`timescale 1ns/1ps
// 五键输入，产生电机的控制信号，初始化时标定原点。
// 需要有传感器输入限位信号Stop。
module CtrlSystem(
	input sysclk,
	input L,
	input R,
	input U,
	input D,
	input E,
	input[5:0] Stop,
	output wire[1:0] Num, // 位号
	output wire LCD_Enable, // LCD使能信号
	output wire[3:0] LCD_Num, // LCD显示数字
	output wire[5:0] PU, // 脉冲
	output wire[5:0] MF, // 上电
	output wire[5:0] DR // 方向
	);
	wire L_DB, Left, R_DB, Right;
	wire U_DB, Up, D_DB, Down;
	wire E_DB, Enter, Busy, INIT;
	wire[3:0] TValue0, TValue1, TValue2;
	wire[5:0] Motor, MotorOut, DROut, initFlag;
	wire[9:0] PulseNum;

	DEBOUNCE LDB(.sys_clk(sysclk),.key_i(L),.key_o(L_DB));
	DEBOUNCE RDB(.sys_clk(sysclk),.key_i(R),.key_o(R_DB));
	DEBOUNCE UDB(.sys_clk(sysclk),.key_i(U),.key_o(U_DB));
	DEBOUNCE DDB(.sys_clk(sysclk),.key_i(D),.key_o(D_DB));
	DEBOUNCE EDB(.sys_clk(sysclk),.key_i(E),.key_o(E_DB));

    KEY_DETECT LKD(.sys_clk(sysclk),.key_i(L_DB),.key_down(Left));
    KEY_DETECT RKD(.sys_clk(sysclk),.key_i(R_DB),.key_down(Right));
    KEY_DETECT UKD(.sys_clk(sysclk),.key_i(U_DB),.key_down(Up));
    KEY_DETECT DKD(.sys_clk(sysclk),.key_i(D_DB),.key_down(Down));
    KEY_DETECT EKD(.sys_clk(sysclk),.key_i(E_DB),.key_down(Enter));

	Init initpart(.sysclk(sysclk),.INIT(INIT));

	Input inputpart(.sysclk(sysclk),.INIT(INIT),
				.Left(Left),.Right(Right),.Up(Up),.Down(Down),.Enter(Enter),
				.TValue0(TValue0),.TValue1(TValue1),.TValue2(TValue2),
				.Motor(Motor),.Num(Num),.LCD_Enable(LCD_Enable),
				.LCD_Num(LCD_Num));

	Control controlpart(.sysclk(sysclk),.initFlag(initFlag),.INIT(INIT),
				.Motor(Motor),.TValue0(TValue0),.TValue1(TValue1),
				.TValue2(TValue2),.Busy(Busy),
				.MotorOut(MotorOut),.PulseNum(PulseNum),.DROut(DROut));

	Pulse pulsepart(.sysclk(sysclk),.INIT(INIT),.Motor(MotorOut),
				.PulseNum(PulseNum),.DRIn(DROut),.Stop(Stop),
				.Busy(Busy),.initFlag(initFlag),
				.PU(PU),.MF(MF),.DR(DR));
endmodule
