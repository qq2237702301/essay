#### 将DOCA通信转移在SPDK的BlobFS中：

1. 将doca的dma读懂，并整合成需要的host->dpu结构，改写c代码。

2. 将doca的dma编译读懂，将系统的编译过程转换成一个meson编译文件编译，改写meson代码。

3. 将doca的dma编译形式从meson转换到makefile，转移一些文件，并改写makefile代码。

4. 将已有的doca的makefile转移到blobfs中，其中库文件的装载以及代码冲突需要修改。
   
   1. 具体而言，有几点需要修改：
   
   2. 在将doca的文件转移到blobfs中时，需要找到其库的添加方式。在doca中，我在编写其makefile文件时就了解了他添加库的方式是通过pkgconfig添加的。在blobfs中，需要找到在什么地方添加pkgconfig，除此之外就是找到添加include的头文件的地方。pkgconfig配置的库和头文件目前添加在/home/zqj/spdk/mk/spdk.app.mk、/home/zqj/spdk/mk/spdk.modules.mk、/home/zqj/spdk/mk/spdk.unittest.mk中。
   
   3. 修改doca_log.h里面的DOCA_LOG_REGISTER，该函数是通过注册一个log实例用来输出错误信息的，也就是和printf相同的功能，但是能体现注册的文件信息，知道在log实例出错，输出的错误也是doca自定义的错误。这个DOCA_LOG_REGISTER在doca中是没问题的，问题就在于多个.c文件都使用了DOCA_LOG_REGISTER，而有的SPDK组件需要include多个.c文件才能编译，而这样会造成DOCA_LOG_REGISTER的重定义，该定义在一个.o文件里只能出现一次。所以该问题的出现原因也找了不少时间，解决办法就是将doca的功能实现都和所使用的他的.c文件放在一起，这样就只有一个.c文件进行了DOCA_LOG_REGISTER，而且别的.c文件想要用blobfs的那个.c文件的话，也只需要include一个.c文件，这样就能不出现重定义现象。
