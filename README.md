# 步进电机控制
## liing11235
- Input.v: 用L、R、U、D、E五键输入电机目标坐标值并输出到Control模块。
- Control.v: 标定原点后计算电机位移值和转动方向并输出到Pulse模块（假设位移值等于脉冲数）。
- Pulse.v: 标定原点；输入脉冲数和电机号以产生相应脉冲信号。
- CtrlSystem.v: 组合Input,Control和Pulse模块。

## 
- debounce.v: 按键消抖。
- key_detect.v: 按键检测。
- pulse.v：输入脉冲数和电机号以产生相应脉冲信号。
- lcd_display.v: 
- lcd_inst_rom.v, lcd_inst_rom.txt:
- lcd_matrix_ram.v, lcd_ram.txt:
- serial.v:


## TODO
- 了解数据表存储方式，增加Control模块中位移值到角度（脉冲数）的数据表和查找逻辑。
- 了解LCD显示模块的输入数据，并修改已有模块来输出相应数据。
- 记录实习过程以便日后撰写实习报告。
