```julia
kill(manager::ClusterManager, pid::Int, config::WorkerConfig)
```

クラスタマネージャーによって実装されます。マスタープロセス上で、[`rmprocs`](@ref)によって呼び出されます。`pid`で指定されたリモートワーカーを終了させます。`kill(manager::ClusterManager.....)`は、`pid`上でリモートの`exit()`を実行します。
