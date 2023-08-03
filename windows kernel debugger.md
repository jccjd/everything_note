# windows Kernel Debugger 

> 官方文档： https://learn.microsoft.com/zh-cn/windows-hardware/drivers/debugger/setting-up-a-null-modem-cable-connection

对windows 进行kernel debugger 通过debugger 的方式有多种
1. 通过网络进行debugger 这种方式需要网卡支持不同的系统有不同支持网卡，查询网站  https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/supported-ethernet-nics-for-network-kernel-debugging-in-windows-8-1?redirectedfrom=MSDN
2. 通过USB进行网口调试，这个USB需要两端都是USB的口
3. 通过串口进行调试

运行调试器的计算机被称为主机 host  ， 被调试的计算机称为  target。

## 对 target 进行设置
> 在使用 bcdedit更改启动信息之前，需要关闭各种安全模式


- 在target 上用管理员命令打开cmd，然后输入命令

```shell
bcdedit /debug on
bcdedit /dbgsettings serial debugport:n baudrate:115200  # n 代表 com1 com2 
```
- 重启 target, target 重启后，如果配置成功，会在开机的系统界面有debugger  

## 在host 上 启动调试会话
在host上 打开 WinDbg  在 file菜单里 选择kernel debugger， 然后打开 COM选项卡，然后进入。当target 重启 显示内核连接，点击ctrl+BREAK
这时target系统会冻结，输入g target 才会重行能用。 

debugg 操作链接： https://learn.microsoft.com/zh-cn/windows-hardware/drivers/debugger/controlling-the-target


