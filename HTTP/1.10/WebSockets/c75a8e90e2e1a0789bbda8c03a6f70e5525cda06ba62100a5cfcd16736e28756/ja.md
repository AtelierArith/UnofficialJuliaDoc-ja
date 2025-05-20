```
close(ws, body::WebSockets.CloseFrameBody=nothing)
```

WebSocket接続のクローズシーケンスを開始します。`body`は、ステータスコードとオプションの理由メッセージを持つオプションの`WebSockets.CloseFrameBody`です。CLOSEフレームがすでに受信されている場合、応答するCLOSEフレームが送信され、接続が閉じられます。CLOSEフレームがまだ受信されていない場合、CLOSEフレームが送信され、応答するCLOSEフレームを受信するために`receive`が試みられます。
