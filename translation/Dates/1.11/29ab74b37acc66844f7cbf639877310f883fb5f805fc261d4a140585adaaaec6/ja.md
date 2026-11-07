```julia
tonext(func::Function, dt::TimeType; step=Day(1), limit=10000, same=false)::TimeType
```

`dt`を、`func`が`true`を返すまで、`step`ずつ増やしながら、最大`limit`回の反復で調整します。`func`は、引数を`TimeType`ひとつだけ取り、[`Bool`](@ref)を返す必要があります。`same`を使うと、`func`を満たすかどうかの判定に`dt`を考慮できます。
