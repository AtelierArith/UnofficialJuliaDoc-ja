```julia
setopt(sock::UDPSocket; multicast_loop=nothing, multicast_ttl=nothing, enable_broadcast=nothing, ttl=nothing)
```

UDPソケットのオプションを設定します。

  * `multicast_loop`: マルチキャストパケットのループバック（デフォルト: `true`）。
  * `multicast_ttl`: マルチキャストパケットのTTL（デフォルト: `nothing`）。
  * `enable_broadcast`: ソケットをブロードキャストメッセージに使用する場合は、このフラグを`true`に設定する必要があります。設定しないと、UDPシステムからアクセスエラーが返されます（デフォルト: `false`）。
  * `ttl`: ソケットから送信されるパケットの有効期間（デフォルト: `nothing`）。
