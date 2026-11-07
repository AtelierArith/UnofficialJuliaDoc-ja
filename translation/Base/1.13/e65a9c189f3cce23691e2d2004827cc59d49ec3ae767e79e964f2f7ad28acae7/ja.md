```julia
f = Returns(value)
```

`f` が `f(args...; kw...) === value` を満たすように、呼び出し可能なものを作成します。

# Examples

```jldoctest
julia> f = Returns(42);

julia> f(1)
42

julia> f("hello", x=32)
42

julia> f.value
42
```

!!! compat "Julia 1.7"
    `Returns` には Julia 1.7 以降が必要です。

