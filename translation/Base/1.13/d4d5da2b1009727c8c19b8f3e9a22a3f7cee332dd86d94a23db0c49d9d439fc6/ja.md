```julia
minmax(x, y)
```

`(min(x,y), max(x,y))`を返します。

`(minimum(x), maximum(x))`を返す[`extrema`](@ref)も参照してください。

# Examples

```jldoctest
julia> minmax('c','b')
('b', 'c')
```
