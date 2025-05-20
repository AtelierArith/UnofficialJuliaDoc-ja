```
RemoteChannel(pid::Integer=myid())
```

プロセス `pid` の `Channel{Any}(1)` への参照を作成します。デフォルトの `pid` は現在のプロセスです。

```
RemoteChannel(f::Function, pid::Integer=myid())
```

特定のサイズと型のリモートチャネルへの参照を作成します。`f` は `pid` で実行されるときに `AbstractChannel` の実装を返さなければならない関数です。

例えば、`RemoteChannel(()->Channel{Int}(10), pid)` は、`pid` 上の型 `Int` とサイズ 10 のチャネルへの参照を返します。

デフォルトの `pid` は現在のプロセスです。
