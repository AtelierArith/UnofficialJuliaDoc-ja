```julia
listen([addr, ]port::Integer; backlog::Integer=BACKLOG_DEFAULT) -> TCPServer
```

`addr`で指定したアドレスのポートで待ち受けます。デフォルトでは、`localhost`のみで待ち受けます。すべてのインターフェースで待ち受けるには、状況に応じて`IPv4(0)`または`IPv6(0)`を渡します。`backlog`は、サーバーが接続を拒否し始めるまでに保留できる接続数（[`accept`](@ref)をまだ呼び出していない接続数）を指定します。`backlog`のデフォルト値は511です。
