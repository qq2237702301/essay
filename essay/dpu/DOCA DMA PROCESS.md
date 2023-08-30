#### DOCA DMA PROCESS

1、init_cc：初始化ep, cc_dev, cc_dev_rep结构。

2、open_doca_device_with_capabilities：打开具有dma功能的doca_dev，作为core_state的一部分。

3、create_core_objs：创建core_state的组成部分，包括doca_mmap、doca_buf_inventory、doca_ctx、doca_dma、doca_workq。

4、init_core_objs：将core_state的组成部分进行一些初始化，他们之间需要用函数进行绑定和启动，例如：doca_mmap_start(state->mmap)，该函数用来启动core_state中的doca_mmap，其次：doca_mmap_dev_add(state->mmap, state->dev)，该函数是为doca_mmap绑定doca_dev，该doca_dev就是前面的具有dma功能的设备。

5、进行host和dpu的实际dma复制：

1. host_negotiate_dma_direction_and_size(dma_cfg, ep, peer_addr)：
   
   dpu_negotiate_dma_direction_and_size(dma_cfg, ep, peer_addr)：
   
   这两个函数是用comm channel来沟通文件传输的
