```julia
init_worker(cookie::AbstractString, manager::ClusterManager=DefaultClusterManager())
```

カスタムトランスポートを実装するクラスターマネージャによって呼び出されます。新しく起動されたプロセスをワーカーとして初期化します。コマンドライン引数 `--worker[=<cookie>]` は、TCP/IPソケットを使用してプロセスをワーカーとして初期化する効果があります。`cookie` は [`cluster_cookie`](@ref) です。
