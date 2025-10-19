```julia
close(ws, body::WebSockets.CloseFrameBody=nothing)
```

ウェブソケット接続のクローズシーケンスを開始します。`body`は、ステータスコードとオプションの理由メッセージを持つオプションの`WebSockets.CloseFrameBody`です。もしCLOSEフレームがすでに受信されている場合、応答するCLOSEフレームが送信され、接続は閉じられます。CLOSEフレームがまだ受信されていない場合、CLOSEフレームが送信され、応答するCLOSEフレームを受信するために`receive`が試みられます。
