```julia
isreadable(ctx::SSLContext)
```

真である場合を除きます：

  * TLS `close_notify` が受信された場合、または
  * ピアが接続を閉じた場合（TLS バッファが空である）、または
  * 読み取り中に未処理の例外が発生した場合。
