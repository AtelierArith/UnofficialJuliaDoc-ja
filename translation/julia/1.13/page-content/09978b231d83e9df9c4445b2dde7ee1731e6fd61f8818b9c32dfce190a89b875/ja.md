# [Distributed Computing](@id man-distributed)

```@docs
Distributed
Distributed.addprocs
Distributed.nprocs
Distributed.nworkers
Distributed.procs()
Distributed.procs(::Integer)
Distributed.workers
Distributed.rmprocs
Distributed.interrupt
Distributed.myid
Distributed.pmap
Distributed.RemoteException
Distributed.ProcessExitedException
Distributed.Future
Distributed.RemoteChannel
Distributed.fetch(::Distributed.Future)
Distributed.fetch(::RemoteChannel)
Distributed.remotecall(::Any, ::Integer, ::Any...)
Distributed.remotecall_wait(::Any, ::Integer, ::Any...)
Distributed.remotecall_fetch(::Any, ::Integer, ::Any...)
Distributed.remotecall_eval
Distributed.remote_do(::Any, ::Integer, ::Any...)
Distributed.put!(::RemoteChannel, ::Any...)
Distributed.put!(::Distributed.Future, ::Any)
Distributed.take!(::RemoteChannel, ::Any...)
Distributed.isready(::RemoteChannel, ::Any...)
Distributed.isready(::Distributed.Future)
Distributed.AbstractWorkerPool
Distributed.WorkerPool
Distributed.CachingPool
Distributed.default_worker_pool
Distributed.clear!
Distributed.remote
Distributed.remotecall(::Any, ::AbstractWorkerPool, ::Any...)
Distributed.remotecall_wait(::Any, ::AbstractWorkerPool, ::Any...)
Distributed.remotecall_fetch(::Any, ::AbstractWorkerPool, ::Any...)
Distributed.remote_do(::Any, ::AbstractWorkerPool, ::Any...)
Distributed.@spawn
Distributed.@spawnat
Distributed.@fetch
Distributed.@fetchfrom
Distributed.@distributed
Distributed.@everywhere
Distributed.remoteref_id
Distributed.channel_from_id
Distributed.worker_id_from_socket
Distributed.cluster_cookie()
Distributed.cluster_cookie(::Any)
```

## Cluster Manager Interface

このインターフェースを使うと、さまざまなクラスタ環境で Julia ワーカーを起動し、管理できます。Base には 2 種類のマネージャーがあります。`LocalManager` は同じホスト上でワーカーを追加起動し、`SSHManager` は `ssh` 経由でリモートホスト上にワーカーを起動します。プロセス間の接続とメッセージの転送には TCP/IP ソケットを使用します。クラスタマネージャーによっては、別のトランスポートを提供することもできます。

```@docs
Distributed.ClusterManager
Distributed.WorkerConfig
Distributed.launch
Distributed.manage
Distributed.kill(::ClusterManager, ::Int, ::WorkerConfig)
Distributed.connect(::ClusterManager, ::Int, ::WorkerConfig)
Distributed.init_worker
Distributed.start_worker
Distributed.process_messages
Distributed.default_addprocs_params
```
