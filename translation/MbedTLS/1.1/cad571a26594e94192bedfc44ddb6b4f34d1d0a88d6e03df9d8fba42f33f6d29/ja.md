```julia
unsafe_read(ctx::SSLContext, buf::Ptr{UInt8}, nbytes::UInt)
```

`ctx` から `buf` に `nbytes` の復号化されたデータをコピーします。十分な復号化データが利用可能になるまで待機します。`nbytes` がコピーされる前にピアが TLS `close_notify` を送信するか、接続を閉じた場合は `EOFError` をスローします。
