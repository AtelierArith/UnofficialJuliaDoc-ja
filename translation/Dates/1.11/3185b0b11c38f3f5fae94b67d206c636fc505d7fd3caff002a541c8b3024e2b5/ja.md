```
DateTime(d::Date, t::Time)
```

`Date`と`Time`によって`DateTime`型を構築します。`Time`型のマイクロ秒またはナノ秒がゼロでない場合、`InexactError`が発生します。

!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1を必要とします。


```jldoctest
julia> d = Date(2018, 1, 1)
2018-01-01

julia> t = Time(8, 15, 42)
08:15:42

julia> DateTime(d, t)
2018-01-01T08:15:42
```
