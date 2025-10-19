```julia
minmax(x, y)
```

Return `(min(x,y), max(x,y))`.

See also [`extrema`](@ref) that returns `(minimum(x), maximum(x))`.

# Examples

```jldoctest
julia> minmax('c','b')
('b', 'c')
```
