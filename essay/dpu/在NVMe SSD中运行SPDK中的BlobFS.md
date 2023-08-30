#### 在NVMe SSD中运行SPDK中的BlobFS

如果提示缺少libfuse3库，直接用本地的libfuse3里面的include文件在/usr/include/fuse3，然后再把libfuse3.so*的库改名成libfuse3.so然后放在/usr/lib/里面。

1. 根据SPDK官方github上配置，但是在./scripts/setup.sh时，会出现无法让NVMe SSD绑定SPDK的情况：<mark>Active devices: data@nvme0n1, so not binding PCI dev</mark> 

2. 是因为nvme0n1未成功初始化造成的，SPDK认为没初始化里面含有数据。

3. 采用命令：<mark>nvme format /dev/nvme0n1</mark>

4. 当然，也可以借助rpc框架，调用bdev子系统中Malloc Bdev模块，启用Blob FS文件系统，启用方法如下：
   
   ```shell
   ./configure --with-fuse && make  
   ./scripts/setup.sh
   scripts/gen_nvme.sh --json-with-subsystems > config.json 
   ./test/blobfs/mkfs/mkfs config.json Nvme0n1 
   mkdir /mnt/fuse 
   ./test/blobfs/fuse/fuse config.json Nvme0n1 /mnt/fuse 
   ```

5. 当然，也可以借助rpc框架，调用bdev子系统中Malloc Bdev模块，启用Blob FS文件系统，启用方法如下：
   
   ```shell
   ./build/bin/spdk_tgt  //  Terminal A
   ./scripts/rpc.py bdev_malloc_create 512 4096  // Terminal B
   ./scripts/rpc.py blobfs_create Malloc0 
   ./scripts/rpc.py blobfs_mount Malloc0 /mnt/fuse 
   ```

6. 运行hello_blob例子：
   
   ```shell
   ./build/examples/hello_blob ./examples/blob/hello_world/hello_blob.json
   ```

7. NVMe CLI命令了解：<mark>nvme sub-commands</mark>，sub-commands使用<mark>nvme --help</mark>获取。
