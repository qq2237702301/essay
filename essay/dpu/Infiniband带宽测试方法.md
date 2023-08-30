#### Infiniband带宽测试方法

* 初始化操作
  
  * 找任意两台服务器，先查看其IB状态
  
  * 两台服务器都要重启IB的服务
  
  * 两台服务器都要开子网管理器，暂停子网管理器的命令（不用使用）如下
    
    ```shell
    ibstat
    /etc/init.d/openibd restart
    /etc/init.d/opensmd start
    /etc/init.d/opensmd stop           
    ```

* 带宽测试
  
  * 第一台执行(ip_0)
  
  * ```shell
    ib_write_bw
    ```
  
  * 第二台执行(ip_1)
  
  * ```shell
    ib_write_bw ip_0
    ```
  
  * 测试读带宽和上诉一样，不过是变成`ib_read_bw`命令

* 延迟测试
  
  * 只需要把命令做一些小调整，变成`ib_write_lat`

#### bf-2 测试数据(MB/sec & usec)

**DPU ---> HOST**

读带宽：6292.93

写带宽：6824.54

读延迟：3.24

写延迟：1.64

**HOST ---> DPU**

读带宽：6794.60

写带宽：6315.06

读延迟：2.54

写延迟：1.75
