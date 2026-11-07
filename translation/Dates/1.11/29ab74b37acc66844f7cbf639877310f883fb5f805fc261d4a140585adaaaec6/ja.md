```julia
tonext(func::Function, dt::TimeType; step=Day(1), limit=10000, same=false)::TimeType
```

`dt`を、`step`ずつ増やしながら最大`limit`回反復し、`func`が`true`を返すまで調整します。`func`は、引数を`TimeType`ひとつだけ取り、[`Bool`](@ref)を返す必要があります。`same`を使うと、`dt`を`func`を満たすものとして考慮できます。
