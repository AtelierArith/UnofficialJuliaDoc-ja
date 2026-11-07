```julia
norm(x::Number, p::Real=2)
```

数値の場合は、``\left( |x|^p \right)^{1/p}``を返してください。

# Examples

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
