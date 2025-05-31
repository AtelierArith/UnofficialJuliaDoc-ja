```
readbytes!(ctx::SSLContext, buf::Vector{UInt8}, nbytes=length(buf); kw...)
```

`ctx` から `buf` に最大 `nbytes` の復号化されたデータをコピーします。`all=true` の場合: 十分な復号化データが利用可能になるまで待機します。ピアが TLS `close_notify` を送信するか、接続を閉じると、`nbytes` 未満がコピーされる場合があります。`buf` にコピーされたバイト数を返します（`<= nbytes`）。
