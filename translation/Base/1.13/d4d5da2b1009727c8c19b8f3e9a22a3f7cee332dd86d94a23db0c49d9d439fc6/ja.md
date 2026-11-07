```julia
minmax(x, y)
```

`(min(x,y), max(x,y))`を返します。

[`extrema`](@ref)も参照してください。`(minimum(x), maximum(x))`を返します。

# Examples

```jldoctest
julia> minmax('c','b')
('b', 'c')
```
