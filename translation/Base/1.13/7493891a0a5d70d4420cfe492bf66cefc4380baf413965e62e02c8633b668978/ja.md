```julia
isfinite(f)::Bool
```

数値が有限かどうかを判定します。

# Examples

```jldoctest
julia> isfinite(5)
true

julia> isfinite(NaN32)
false
```
