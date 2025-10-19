```julia
norm(x::Number, p::Real=2)
```

数値の場合、$\left( |x|^p \right)^{1/p}$を返します。

# 例

```jldoctest
julia> norm(2, 1)
2.0

julia> norm(-2, 1)
2.0

julia> norm(2, 2)
2.0

julia> norm(-2, 2)
2.0

julia> norm(2, Inf)
2.0

julia> norm(-2, Inf)
2.0
```
