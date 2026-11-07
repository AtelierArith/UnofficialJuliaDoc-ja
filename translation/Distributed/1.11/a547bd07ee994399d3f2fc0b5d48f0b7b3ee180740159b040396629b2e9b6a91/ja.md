```julia
init_worker(cookie::AbstractString, manager::ClusterManager=DefaultClusterManager())
```

独自のトランスポートを実装するクラスターマネージャーから呼び出されます。新たに起動したプロセスをワーカーとして初期化します。コマンドライン引数 `--worker[=<cookie>]` を指定すると、TCP/IP ソケットをトランスポートに使用するワーカーとしてプロセスが初期化されます。`cookie` は [`cluster_cookie`](@ref) です。
