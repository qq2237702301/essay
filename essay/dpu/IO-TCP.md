#### Rearchitecting the TCP Stack for I/O-Offloaded Content Delivery

###### Main idea：

1. 在线内容交付中的磁盘和网络IO操作之类的简单操作占用了大量的CPU周期（70%）

2. 如今随着smartNIC等智能网卡的兴起，有方法表明能将此类操作从CPU中卸载。

3. 但是那些方法具有一个问题，不能使用在TCP协议上。本文提出了IO-TCP，通过将这些简单任务的控制和实际操作解耦，CPU下达控制指令，由smartNIC具体执行，并通过TCP协议传输。

###### Introduction:

1. 造成CPU效率低下的原因：现代操作系统需要将所有磁盘数据传送到远程客户端之前带到主内存。

2. 现代CPU需要管理包括控制协议的正常运行和数据的创建传输，而数据路径更多依赖于内存带宽而不是计算，CPU需要对数据进行大量简单而重复的IO操作，这种设计使得CPU的吞吐量降低。

###### Background

1. 内容交付系统堆栈是低效的。
   
   ![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-10-17-23-09-image.png)
   
   **Figure 2**
   
   从`Figure 2`中可以看出，在CPU的功能分解图中，数据路径的处理占据了主要的CPU使用（71.76%）。

2. I/O设备发展与CPU性能的不匹配
   
   ![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-10-17-23-21-image.png)
   
   **Figure 1**
   
   从`Figure 1`中可以看出，CPU已经成为系统的主要瓶颈，当NVMe设备达到5 ~6个时，所有文件大小（Block Size）的传输都将使得CPU利用率达到100%，当文件大小较小时，甚至两个NVMe设备就将使得CPU利用率达到100%。

3. Mellanox BlueField NIC 能通过NVMe over Fabrics目标卸载支持P2PDMA，Arm处理器能通过该卸载直接从本地NVMe磁盘读取数据。这些磁盘直接安装在Arm处理器上运行的linux环境中，运行在主机操作系统所看到的相同文件系统上。
   
   ![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-10-19-58-27-image.png)
   
   **Figure 3**
   
   如`Figure 3`所示，普通的使用BF-2和CPU不能达到最好的性能，通过IO-TCP能达到普通的2倍性能。
   
   ![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-10-20-03-22-image.png)
   
   **Figure 4**
   
   `Figure 4`是BF-2的整体框架

###### Design

![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-11-26-41-image.png)

1. **将TCP的控制和数据平面分离**
   
   控制平面是指关键的TCP协议功能，如连接管理、可靠的数据传输、拥塞/流量控制和错误控制
   
   数据平面是指涉及数据包准备和传输的所有操作

2. **IO-TCP卸载API功能**：IO-TCP需要能合成任何要传输的数据，而不管它是否是文件内容
   
   offload_open() : 要求NIC堆栈打开文件并报告结果，异步实现，后续需要用epoll() 或其他函数调用检查其结果
   
   offload_close() : 与上述一致，要求NIC堆栈关闭文件 
   
   offload_ftat() : 用于检索文件的元数据，例如文件大小与权限
   
   offload_write() : 通过TCP连接发送文件内容，执行与linux中sendfile() 相同的操作，文件在NIC嵌入式系统中打开

3. **IO-TCP Host Stack**
   
   IO-TCP主机堆栈的作用是为应用程序提供完整的TCP功能，同时它与NIC堆栈交互以卸载数据平面操作。主机堆栈设计中的关键挑战是如何创建包含“丢失”文件数据的数据包。类似地，它应该在主机端处理没有实际文件数据的TCP数据包重传。
   
   ![](C:\Users\86139\AppData\Roaming\marktext\images\2022-12-11-10-52-39-image.png)

4. **IO-TCP NIC Stack**
   
   IO-TCP NIC堆栈负责执行主机堆栈的所有实际数据平面操作——它处理数据包传输的卸载文件I/O和网络I/O。它通过处理来自主机堆栈的自定义命令来进行操作，其中每个命令都承载在指定给NIC堆栈的特殊数据包上。

5. **Challenges with Integrated I/O**
   
   重传计时器和RTT测量：在开发过程中，发现一些数据包还没有发送客户端就已经开始重传了，原因是主机端并没有考虑在HOST端到NIC端的中间处理时间。为了解决这个问题，NIC在处理后会发送echo数据包给HOST，这时候HOST才开始计算RTT时间，为了准确，HOST还会加上echo数据包的时延，这样便能准确控制数据包传输。
   
   处理重传：重传如果从磁盘中重新读取文件内容会导致效率很低并且浪费内存和磁盘带宽，NIC stack将原始数据内容保存在内存中，直到主机堆栈确认已经发送给客户端。当主机收到ack命令时，会定期将“ACKD”命令包发送到NIC堆栈，这样NIC堆栈可以回收数据的内存缓冲区。主机堆栈会将上次客户端确认的阈值数据量发送给NIC堆栈以最小化开销。缓冲区大致为带宽和延迟的乘积，如100 Gbps的网卡，连接的平均RTT为30ms，总共需要375MB的缓冲内存。

6. **Handling Errors**
   
   HOST端的错误仍由HOST堆栈处理，NIC堆栈的错误由NIC以命令包发送给HOST堆栈，然后由HOST堆栈处理（例如返回给应用程序等等）。

7. **Support for TLS and QUIC**
   
   **TLS**（Transport Layer Security）：**传输层安全性协议**，用于在两个通信应用程序之间提供保密性和数据完整性。该协议由两层组成： TLS 记录协议（TLS Record）和 TLS 握手协议（TLS Handshake）。
   
   **QUIC**（Quick UDP Internet Connection）是谷歌制定的一种基于UDP的低时延的互联网传输层协议。
   
   IO-TCP可以支持TLS。对于卸载的数据而言，已有smartNICs支持AES和SHA，所以只需要CPU和NIC配合加密即可。但是对于未卸载的数据而言，可以发送给NIC加密，也可由CPU的AES-NI指令加密。其他的QUIC也可用类似方法实现。

###### Implementation

1. 
