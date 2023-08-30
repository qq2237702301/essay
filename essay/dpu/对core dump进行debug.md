程序Crash,去追踪，找core dump,始终没有找到，后来到了 /proc/sys/kernel/core_pattern这个文件夹下找到。

在linux平台下，设置core dump文件生成的方法：

1) 在终端中输入ulimit -c 如果结果为0，说明当程序崩溃时， [系统](http://www.2cto.com/os/)并不能生成core dump。

2) 使用ulimit -c unlimited命令，开启core dump功能，并且不限制生成core dump文件的大小。如果需要限制，加数字限制即可。ulimit - c 1024

3) 默认情况下，core dump生成的文件名为core，而且就在程序当前目录下。新的core会覆盖已存在的core。通过修改/proc/sys/kernel/core_uses_pid文件，可以将进程的pid作为作为扩展名，生成的core文件格式为core.xxx，其中xxx即为pid

4) 通过修改/proc/sys/kernel/core_pattern可以控制core文件保存位置和文件格式。例如：将所有的core文件生成到/corefile目录下，文件名的格式为core-命令名-pid-时间戳. echo "/corefile/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
   
   %p ： insert pid into filename 添加pid
   %u ：insert current uid into filename 添加当前uid
   %g ： insert current gid into filename 添加当前gid
   %s ： insert signal that caused the coredump into the filename 添加导致产生core的信号
   %t  ： insert UNIX time that the coredump occurred into filename 添加core文件生成时的unix时间
   %h ： insert hostname where the coredump happened into filename 添加主机名
   %e ： insert coredumping executable name into filename 添加命令名

5、除了上一条的方法外，也可以做如下操作：

```shell
 vi /etc/sysctl.conf
 kernel.core_pattern = /tmp/core-%e-%p
 sysctl -p /etc/sysctl.conf
```

6、core文件的解析：

```shell
gdb executable_file core_file


(gdb)bt
```
