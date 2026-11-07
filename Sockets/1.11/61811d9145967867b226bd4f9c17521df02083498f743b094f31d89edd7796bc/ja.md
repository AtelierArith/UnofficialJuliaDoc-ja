```julia
nagle(socket::Union{TCPServer, TCPSocket}, enable::Bool)
```

Nagleのアルゴリズムは、複数の小さなTCPパケットをまとめて、より大きなパケットにします。これによりスループットが向上する一方、レイテンシが悪化することがあります。Nagleのアルゴリズムはデフォルトで有効です。この関数は、指定したTCPサーバーまたはソケットでNagleのアルゴリズムを有効にするかどうかを設定します。他の言語では、反対の設定を`TCP_NODELAY`と呼びます。

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3以降が必要です。

