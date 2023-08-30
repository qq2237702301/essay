blobfs的对外接口所在地址：/home/zqj/spdk/include/spdk/blobfs.h。

blobfs的main函数所在地址：/home/zqj/spdk/test/blobfs/fuse/fuse.c，可以从其中找到装载函数spdk_blobfs_bdev_mount。

该装载函数所在地址：/home/zqj/spdk/module/blobfs/bdev/blobfs_bdev.c。

blobfs的主要写入函数所在地址为：/home/zqj/spdk/lib/blobfs/blobfs.c，其中有两个函数spdk_file_read和spdk_file_write，这两个函数负责将数据从NVMe SSD读取和写入。
