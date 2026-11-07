```julia
RemoteChannel(pid::Integer=myid())
```

プロセス `pid` 上の `Channel{Any}(1)` への参照を作成します。デフォルトの `pid` は現在のプロセスです。

```julia
RemoteChannel(f::Function, pid::Integer=myid())
```

特定のサイズと型を持つリモートチャネルへの参照を作成します。`f` は、`pid` 上で実行すると、`AbstractChannel` の実装を返す関数です。

たとえば、`RemoteChannel(()->Channel{Int}(10), pid)` は、`pid` 上にある、型が `Int` でサイズが 10 のチャネルへの参照を返します。

デフォルトの `pid` は現在のプロセスです。
