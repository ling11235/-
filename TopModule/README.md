## CtrlSystem

本文件夹包含输入和控制信号产生部分，顶层模块为CtrlSystem。

- CtrlSystem

  - 控制信号产生的顶层模块
  - 标定原点；输入坐标，产生控制信号驱动电机运动到指定坐标点；输出LCD显示所需要的信号。


- Input模块(适用于五键输入)

  - 通过按键输入得到电机编号和坐标值并输出。
  - 5键{Left,Right,Enter,Up,Down}：通过Left/Right键切换电机/坐标位，通过Up/Down键改变电机编号/坐标值，通过Enter键确认执行。
  

- Pulse模块

  - 标定原点；根据输入信号产生脉冲信号。
  - 关于到达限位后反向转动一步，即DR的设置。


- Control模块

  - 根据输入产生脉冲数PulseNum和方向信号DR。
  - 保存上次电机坐标，和输入坐标比较，计算出位移值和方向信号。
  - **TODO：存储给定关系表MotorValue->PulseNum，用时查表将输入位移值转换为脉冲数。** 


- Init模块

  - 产生全局初始化信号。


- KEY_DETECT模块

  - 按键检测，来自minnyres的key_detect.v


 - DEBOUNCE模块
 
  - 按键消抖，来自minnyres的debounce.v
