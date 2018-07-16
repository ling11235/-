# 步进电机控制
## ling11235
- Input.v: 通过5键{Left,Right,Enter,Up,Down}输入得到电机编号和坐标值并输出。通过Left/Right键切换电机/坐标位，通过Up/Down键改变电机编号/坐标值，通过Enter键确认执行。
- Control.v: 根据输入计算脉冲数、方向。
- Pulse.v: 标定原点；根据输入产生脉冲、方向和上电标志。
- CtrlSystem.v: 组合Input,Control和Pulse模块。

## minnyres
- debounce.v: 按键消抖模块，消抖时间为20ms。当检测到输入按键电平的改变后，立即改变输出电平，并且在防抖时间内忽略输入按键电平的改变。
- key_detect.v: 检测按键按下的动作，在按键松开时输出一个时钟周期的高电平。在本模块钟，按键按下时，按键电平为高电平，可以根据实际情况修改。
- pulse.v：输入脉冲数和电机号以产生相应脉冲信号。
- lcd_display.v: LCD显示模块。
- lcd_inst_rom.v, lcd_inst_rom.txt:保存LCD的控制命令的ROM，.txt文件中存储LCD的控制命令。
- lcd_matrix_ram.v, lcd_ram.txt: 描述64行128列的LCD点阵的RAM，8行为一页，一共8页128列。最高两位和最低一位构成页地址，中间位是列地址。
- serial.v: 把8位的并行输入转化位串行输出，先输出高位，再输出低位。


## TODO(ling11235)
- 了解数据表存储方式，增加Control模块中位移值到角度（脉冲数）的数据表和查找逻辑。
- 修改已有模块以适应minnyres的模块。
- 记录实习过程以便日后撰写实习报告。
