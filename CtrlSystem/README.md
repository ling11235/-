## 步进电机控制(ling11235)

本文件由于记录实际过程中code的变化，以便于将来撰写实习报告时方便查资料。
给定总路程长度、角度（脉冲数）和坐标的关系表，要求输入坐标，电机运动到指定坐标点。

### CtrlSystem

- 控制信号产生的顶层模块
- 输入：sysclk,Left,Right,Up,Down,Enter,Stop
  - sysclk为系统时钟，上升沿有效；
  - Left,Right,Enter,Up,Down为输入控制，假设下降沿有效；
  - Stop为传感器输入信号，高电平表示到达限位。

- 输出：Num,LCD_Enable,LCD_Num,PU,MF,DR
  - Num，位号，2bit；
  - LCD_Enable，LCD显示的使能信号。
  - LCD_Num，显示的数字，4bit。
  - PU为脉冲信号，下降沿有效，频率和电机有关；
  - MF为上电信号，高电平有效；
  - DR为电机方向，高电平表示反转；

### Input模块(适用于五键输入)

- 注意<=的并行性！
- 通过按键输入得到电机编号和坐标值并输出。
- 5键{Left,Right,Enter,Up,Down}：通过Left/Right键切换电机/坐标位，通过Up/Down键改变电机编号/坐标值，通过Enter键确认执行。
- 输入：~~rst,~~ sysclk,Left,Right,Enter,Up,Down,INIT
  - ~~rst为外部复位，下降沿有效；~~
  - sysclk为系统时钟，上升沿有效；
  - INIT和初始化有关；
  - Left,Right,Enter,Up,Down为输入控制，假设下降沿有效。


- 输出：Motor,TValue0,TValue1,TValue2,Num,LCD_Enable,LCD_Num

  - Motor，电机编号输出到Control模块和Pulse模块；

    6bit，比特位为1表示该电机选中，1比特位不超过1个，后续用组合逻辑选择电机发送信号。

  - TValue0-2，坐标值输出到Control模块，百位，十位，个位；

    比特位数=4

  - Num，位号，2bit；
  
  - LCD_Enable，LCD显示的使能信号。
  
  - LCD_Num，显示的数字，4bit。


### Pulse模块

- 标定原点；根据输入信号产生脉冲信号。
- 关于到达限位后反向转动一步，即DR的设置。
- 输入：sysclk,Motor,DRIn,PulseNum,Stop
  - sysclk为系统时钟，上升沿有效；
  - Motor为Input模块输出；
  - DRin为Control模块输出；
  - PulseNum为Control模块输出。
  - Stop为传感器输入信号，高电平表示到达限位。
- 输出：PU,MF,DR,INIT,Busy,initFlag
  - PU为脉冲信号，下降沿有效，频率和电机有关；
  - MF为上电信号，高电平有效；
  - DR为电机方向，高电平表示反转；
  - INIT和初始化有关。
  - Busy为回馈信号，高电平表示正在发送脉冲，对新信号暂时无响应。
  - initFlag为原点标志，为真表示已标定原点。



### Control模块

- 根据输入产生脉冲数PulseNum和方向信号DR。

- 保存上次电机坐标，和输入坐标比较，计算出位移值和方向信号。

- **TODO：存储给定关系表MotorValue->PulseNum，用时查表将输入位移值转换为脉冲数。** 

- 输入：sysclk,~~rst,~~ initFlag,INIT,Motor,TValue0,TValue1,TValue2,Busy

  - sysclk为系统时钟，上升沿有效；
  - ~~rst为复位信号，下降沿有效；~~
  - Motor,TValue0-2为Input模块输出；
  - initFlag为Pulse模块输出，全部高电平代表原点已全部标定；
  - INIT和初始化有关；
  - Busy为Pulse模块输出，低电平代表此时Control模块可对Pulse模块发送控制信号。

- 输出：MotorOut,PulseNum,DROut

  - MotorOut为输出电机编号

  - 输出PulseNum，即脉冲数到Pulse模块；

    比特位数与存储表有关。

  - 输出DROut到Pulse模块，高电平表示反转。



------



## 关于电机

- 二相混合式，20步/周，$18^\circ\pm10^\circ$ /步。

------



## 关于驱动器

- 细分可调，最大128。
- PU：下降沿有效，低0-0.5V，高4-5V，脉宽>2.5us（f<150kHz，考虑到实际，f初始值应当较小），占空比默认为50%。
- DR：控制方向
- MF：低电平有效（断电）
