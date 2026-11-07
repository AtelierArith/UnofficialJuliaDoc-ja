```julia
TCPSocket(; delay=true)
```

libuv を使用して TCP ソケットを開きます。`delay` が true の場合、libuv は最初の [`bind`](@ref) 呼び出しまで、ソケットのファイル記述子の作成を遅らせます。`TCPSocket` には、ソケットの状態と送受信バッファーを示すさまざまなフィールドがあります。
