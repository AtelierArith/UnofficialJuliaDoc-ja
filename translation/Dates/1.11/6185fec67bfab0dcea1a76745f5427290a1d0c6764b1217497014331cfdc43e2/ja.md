```julia
DateTime(d::Date, t::Time)
```

`Date`と`Time`から、`DateTime`型を構築します。`Time`型にゼロ以外のマイクロ秒またはナノ秒が含まれている場合、`InexactError`になります。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。


```jldoctest
julia> d = Date(2018, 1, 1)
2018-01-01

julia> t = Time(8, 15, 42)
08:15:42

julia> DateTime(d, t)
2018-01-01T08:15:42
```
