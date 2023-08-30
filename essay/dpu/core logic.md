记录元数据操作，用于FS语义卸载：

* fuse_getattr、spdk_fs_file_stat、

* fuse_readdir、spdk_fs_iter_first

* fuse_mknod、spdk_fs_create_file、spdk_bs_create_blob

* fuse_unlink、spdk_fs_delete_file、spdk_bs_delete_blob

* fuse_open、spdk_fs_open_file、fs_open_blob_create_cb

* fuse_release、spdk_file_close、spdk_file_close&spdk_blob_close



~（只做一个，if else），*只做一个（逻辑决定）

* spdk_bs_init(cb_fn = cpl.u.bs_handle.cb_fn, cb_arg = cpl.u.bs_handle.cb_arg)
  
  * bs_sequence_to_batch(set->cb_args.cb_fn = bs_batch_completion, set->u.batch.cb_fn = bs_init_trim_cpl, set->u.batch.cb_arg = ctx)
  
  * bs_sequence_write_dev(set->u.sequence.cb_fn = bs_init_persist_super_cpl;
    
        set->u.sequence.cb_arg = ctx;)
  
  * bs_call_cpl(&cpl, bserrno); 

* spdk_bs_init
  
  * bs_batch_write_zeroes_dev
    
    * bs_batch_completion
      
      * bs_init_trim_cpl~ *
      
      * bs_request_set_complete~
  
  * bs_batch_unmap_dev
    
    * bs_batch_completion
      
      * bs_init_trim_cpl ~*（两个函数只有一个会运行，batch会记录最后一个执行完成的函数来进行sequence写入）
        
        * bs_init_persist_super_cpl
          
          * bs_sequence_finish
            
            * bs_request_set_complete
      
      * bs_request_set_complete~
  
  * bs_batch_close
    
    * bs_init_trim_cpl ~*
    
    * bs_request_set_complete~

* spdk_bdev_write_blocks
  
  * bdev_write_blocks_with_md（有可能就是将函数内的desc->write换成所需要的rdma函数即可）
    
    * bdev_io_init
    
    * bdev_io_submit

* reactor_run
  
  * _reactor_run
    
    * spdk_thread_poll
      
      * thread_poll
        
        * msg_queue_run_batch
        
        * thread_execute_poller
        
        * 
