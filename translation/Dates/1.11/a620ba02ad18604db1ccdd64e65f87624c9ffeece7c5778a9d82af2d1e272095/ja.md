```julia
toprev(func::Function, dt::TimeType; step=Day(-1), limit=10000, same=false)::TimeType
```

`func` が `true` を返すまで、最大 `limit` 回の反復で `step` ずつ増加させて `dt` を調整します。`func` は、単一の `TimeType` 引数を受け取り、[`Bool`](@ref) を返す必要があります。`same` を使用すると、`func` を満たすかどうかの判定で `dt` を考慮できます。
