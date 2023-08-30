开机安装完host端的doca环境，使用`dmesg -l err`发现错误：

![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-22-25-21-210025d748aeb35fcd753f9b9686e74.png)

之后使用doca comm channel的连接例子程序：

![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-22-30-25-97dd0d206fc0dc23ccfe8a0f89ff131.png)

提示device未发现，之后再使用`dmesg -l err`:

![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-22-31-19-fa5cb33c06fc40c38abd31fb7fc7bdc.png)

然后我搜索关于`mlx5_core`的问题，在一篇blog（关于Infiniband网卡安装、使用）上发现命令`sudo hca_self_test.ofed`：

![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-22-52-17-image.png)

这里可以看出`Host Driver Initialization`是处于FAIL状态的，这说明Device是有问题的。

上面那篇blog上有两个命令我看着好像是重启相关系统，上面的Infiniband网卡安装过程也需要用到，我就尝试着使用了以下两个命令

`sudo /etc/init.d/openibd restart`

`sudo /etc/init.d/opensmd restart`

之后再使用`sudo hca_self_test.ofed`查看：

![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-22-59-56-image.png)

发现`Host Driver Initialization`已经成功，之后在运行cc例子程序，成功运行。

![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-23-00-58-image.png)

以上解决问题的blog网址为：[Infiniband网卡安装、使用总结_abin在路上的博客-CSDN博客_infiniband网卡配置](https://blog.csdn.net/t1506376703/article/details/106911631/)
