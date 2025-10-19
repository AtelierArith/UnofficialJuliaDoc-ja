```julia
f = Returns(value)
```

呼び出し可能な `f` を作成し、`f(args...; kw...) === value` が成り立つようにします。

# 例

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
    `Returns` は少なくとも Julia 1.7 を必要とします。

