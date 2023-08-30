#### Process

create_bs_dev_ext

bs_init

get_io_unit_size

create_blob

open_blob

free_cluster_count

blob_resize

get_num_clusters

blob_sync_md

blob_write

bs_alloc_io_channel

blob_io_write

blob_io_read

blob_close

bs_delete_blob

bs_free_io_channel

bs_unload

### 注意事项

* 在开机重启后，需要配置rdma的ip，首先使用ifconfig -a 查看网络名称，然后用ifconfig 网络名称 set_ip netmask set_netmask broadcast set_broadcast 配置主机和DPU的网络。

* 在运行NOF时，使用 -m 0x1来控制cpu core， 0x1代表使用第一个cpu core（但是尽量换一个，否则会和其他运行的spdk程序有冲突）。

* 在将rdma传输嵌入另一个程序时，需要控制其unit test的文件里面也包括共有的.c文件，比如rdma_common.c。

* 配置貌似不需要自己配置，直接使用./configure --with-rdma，如果需要就用 CFLAGS += -libverbs -lrdmacm，有的可以使用 `pkg-config libmath --cflags --libs`
  
  



1、修改rdma 🐕

2、修改配置 🐕

3、阅读perf 

4、进行perf测试性能

5、阅读两篇论文（其实是一篇，因为两篇只不过是不同版本，看最新的就行）

疑惑：一开始没找到写入的正确函数，目前已找到dev_write。



![](C:\Users\86139\AppData\Roaming\marktext\images\2023-07-05-17-27-49-image.png)

问题

* 这边写的RNIC的PCIe需要两次，6倍的数据包，而SOC只需要一次PCIe。这个的SOC和RNIC的PCIe的编程形式是怎么样的，能理解意思但是具体含义不太懂。

* PCIe Switch 到 DPU的内联线路的单边带宽是200Gbps，这样才能解释图中的现象。

* 为什么1和2通路的读性能不同，但是写性能差不多，作者给出的解释是write是内核的异步完成，所以差不多，不太理解。

* **head-of-line blocking** 是什么意思？为什么当payload大于9MB时，snic2的read性能会产生崩溃是因为这原因。

* 在通路3时，DB为什么在SOC端有效，而在HOST端不一定。作者解释是因为SOC memory到NIC快而HOST memory到NIC慢，这个不理解。

* Figure11这图画得没看懂这意思，为什么画thpt和bandwidth的图，而且横坐标还不一样，感觉这样对比没有意义。

* 


