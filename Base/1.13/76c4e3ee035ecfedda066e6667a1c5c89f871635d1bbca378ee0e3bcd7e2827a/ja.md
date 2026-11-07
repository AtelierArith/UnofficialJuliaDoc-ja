```julia
link_pipe!(pipe; reader_supports_async=false, writer_supports_async=false)
```

`pipe`を初期化し、`in`エンドポイントを`out`エンドポイントに接続します。キーワード引数`reader_supports_async`/`writer_supports_async`は、Windowsでは`OVERLAPPED`、POSIXシステムでは`O_NONBLOCK`に対応します。外部プログラムで使用する場合（例：[`run`](@ref)で実行したコマンドの出力）を除き、これらは`true`にしてください。
