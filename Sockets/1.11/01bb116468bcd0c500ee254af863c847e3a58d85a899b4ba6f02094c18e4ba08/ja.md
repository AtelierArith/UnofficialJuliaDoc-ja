```julia
setopt(sock::UDPSocket; multicast_loop=nothing, multicast_ttl=nothing, enable_broadcast=nothing, ttl=nothing)
```

UDPソケットオプションを設定します。

  * `multicast_loop`: マルチキャストパケットのループバック（デフォルト: `true`）。
  * `multicast_ttl`: マルチキャストパケットのTTL（デフォルト: `nothing`）。
  * `enable_broadcast`: ソケットがブロードキャストメッセージに使用される場合はフラグを`true`に設定する必要があります。そうしないと、UDPシステムはアクセスエラーを返します（デフォルト: `false`）。
  * `ttl`: ソケットで送信されるパケットの生存時間（デフォルト: `nothing`）。
