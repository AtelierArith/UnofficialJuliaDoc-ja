```julia
tonext(func::Function, dt::TimeType; step=Day(1), limit=10000, same=false) -> TimeType
```

`dt`を調整し、`func`が`true`を返すまで`step`の増分で最大`limit`回の反復を行います。`func`は単一の`TimeType`引数を取り、[`Bool`](@ref)を返す必要があります。`same`は`dt`が`func`を満たすのに考慮されることを許可します。
