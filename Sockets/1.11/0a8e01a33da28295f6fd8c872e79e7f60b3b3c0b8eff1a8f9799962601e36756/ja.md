```
TCPSocket(; delay=true)
```

libuvを使用してTCPソケットを開きます。`delay`がtrueの場合、libuvは最初の[`bind`](@ref)呼び出しまでソケットのファイルディスクリプタの作成を遅延させます。`TCPSocket`には、ソケットの状態や送受信バッファを示すさまざまなフィールドがあります。
