```julia
send(ws::WebSocket, msg)
```

ウェブソケット接続でメッセージを送信します。`msg`が`AbstractString`の場合、TEXTウェブソケットメッセージが送信されます。`msg`が`AbstractVector{UInt8}`の場合、BINARYウェブソケットメッセージが送信されます。それ以外の場合、`msg`は`AbstractString`または`AbstractVector{UInt8}`のいずれかの反復可能なものである必要があり、反復された各要素に対して1つのフレームで断片化メッセージが送信されます。

制御フレームは、`ping(ws[, data])`、`pong(ws[, data])`、または`close(ws[, body::WebSockets.CloseFrameBody])`を呼び出すことで送信できます。`close`を呼び出すと、クローズシーケンスが開始され、基盤となる接続が閉じられます。
