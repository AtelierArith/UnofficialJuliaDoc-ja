```
@something(x...)
```

[`something`](@ref) の短絡バージョンです。

# 例

```jldoctest
julia> f(x) = (println("f($x)"); nothing);

julia> a = 1;

julia> a = @something a f(2) f(3) error("`a` のデフォルトが見つかりません")
1

julia> b = nothing;

julia> b = @something b f(2) f(3) error("`b` のデフォルトが見つかりません")
f(2)
f(3)
ERROR: `b` のデフォルトが見つかりません
[...]

julia> b = @something b f(2) f(3) Some(nothing)
f(2)
f(3)

julia> b === nothing
true
```

!!! compat "Julia 1.7"
    このマクロは Julia 1.7 以降で利用可能です。

