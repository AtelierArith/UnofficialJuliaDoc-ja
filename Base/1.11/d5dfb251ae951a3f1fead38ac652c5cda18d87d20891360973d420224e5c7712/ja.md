```
@coalesce(x...)
```

短絡評価バージョンの [`coalesce`](@ref)。

# 例

```jldoctest
julia> f(x) = (println("f($x)"); missing);

julia> a = 1;

julia> a = @coalesce a f(2) f(3) error("`a` はまだ missing です")
1

julia> b = missing;

julia> b = @coalesce b f(2) f(3) error("`b` はまだ missing です")
f(2)
f(3)
ERROR: `b` はまだ missing です
[...]
```

!!! compat "Julia 1.7"
    このマクロは Julia 1.7 以降で利用可能です。

