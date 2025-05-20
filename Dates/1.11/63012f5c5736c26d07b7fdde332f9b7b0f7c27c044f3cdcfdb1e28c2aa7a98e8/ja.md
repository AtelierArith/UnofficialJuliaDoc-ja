```
tonext(func::Function, dt::TimeType; step=Day(1), limit=10000, same=false) -> TimeType
```

`dt`を調整し、`func`が`true`を返すまで、最大`limit`回の反復を`step`の増分で行います。`func`は単一の`TimeType`引数を受け取り、[`Bool`](@ref)を返す必要があります。`same`は`dt`が`func`を満たすことを考慮することを許可します。
