```
nagle(socket::Union{TCPServer, TCPSocket}, enable::Bool)
```

ナグルのアルゴリズムは、複数の小さなTCPパケットを大きなパケットにバッチ処理します。これによりスループットが向上する可能性がありますが、レイテンシが悪化することがあります。ナグルのアルゴリズムはデフォルトで有効になっています。この関数は、特定のTCPサーバーまたはソケットでナグルのアルゴリズムがアクティブかどうかを設定します。反対のオプションは、他の言語では`TCP_NODELAY`と呼ばれます。

!!! compat "Julia 1.3"
    この関数はJulia 1.3以降が必要です。

