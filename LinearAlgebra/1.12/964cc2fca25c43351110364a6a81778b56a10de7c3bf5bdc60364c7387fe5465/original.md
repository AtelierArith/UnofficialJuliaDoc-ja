```julia
axpby!(α, x::AbstractArray, β, y::AbstractArray)
```

Overwrite `y` with `x * α + y * β` and return `y`. If `x` and `y` have the same axes, it's equivalent with `y .= x .* a .+ y .* β`.

# Examples

```jldoctest
julia> x = [1; 2; 3];

julia> y = [4; 5; 6];

julia> axpby!(2, x, 2, y)
3-element Vector{Int64}:
 10
 14
 18
```
