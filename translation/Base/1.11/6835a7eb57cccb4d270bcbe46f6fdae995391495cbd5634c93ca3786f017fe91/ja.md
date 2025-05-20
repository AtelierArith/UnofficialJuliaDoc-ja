```
link_pipe!(pipe; reader_supports_async=false, writer_supports_async=false)
```

`pipe`を初期化し、`in`エンドポイントを`out`エンドポイントにリンクします。キーワード引数`reader_supports_async`/`writer_supports_async`は、Windowsの`OVERLAPPED`およびPOSIXシステムの`O_NONBLOCK`に対応します。外部プログラム（例：[`run`](@ref)で実行されたコマンドの出力）によって使用されない限り、`true`であるべきです。
