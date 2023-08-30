### SPDK中使用NVMe Over Fabrics

[SPDK: NVMe over Fabrics Target](https://spdk.io/doc/nvmf.html)

创建nvme盘

```shell
build/bin/nvmf_tgt -m 0x1000

scripts/rpc.py nvmf_create_transport -t RDMA -u 8192 -c 0
scripts/rpc.py bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 0000:af:00.0
scripts/rpc.py nvmf_create_subsystem nqn.2016-06.io.spdk:cnode1 -a -s SPDK00000000000001 -d SPDK_Controller1
scripts/rpc.py nvmf_subsystem_add_ns nqn.2016-06.io.spdk:cnode1 Nvme0n1
scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.io.spdk:cnode1 -t rdma -a 192.168.2.138 -s 4420
```

1、使用./build/examples/hello_world（./examples/nvme/hello_world/hello_world.c）时，使用 -r（nvme over fabrics）参数，格式为："trtype:RDMA adrfam:IPv4 traddr:192.168.2.138 trsvcid:4420"。
