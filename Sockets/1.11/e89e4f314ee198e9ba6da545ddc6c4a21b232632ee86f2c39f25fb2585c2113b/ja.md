```
listen([addr, ]port::Integer; backlog::Integer=BACKLOG_DEFAULT) -> TCPServer
```

指定されたアドレス `addr` のポートでリッスンします。デフォルトでは、これは `localhost` のみでリッスンします。すべてのインターフェースでリッスンするには、適切に `IPv4(0)` または `IPv6(0)` を渡します。`backlog` は、サーバーが接続を拒否し始める前に、保留中の接続（[`accept`](@ref) を呼び出していない）をどれだけ受け入れられるかを決定します。`backlog` のデフォルト値は 511 です。
