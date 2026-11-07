```julia
IOContext(io::IO, context::IOContext)
```

`context`のプロパティを継承しつつ、別の`IO`をラップする`IOContext`を作成します。

!!! note
    ラップする`io`で明示的に設定しない限り、`io`の`displaysize`は継承されません。これは、デフォルトでは`displaysize`がIOオブジェクト自体のプロパティではなく、遅延的に推定されるためです。IOオブジェクトの存続中に、ターミナルウィンドウのサイズが変わる可能性があるからです。

