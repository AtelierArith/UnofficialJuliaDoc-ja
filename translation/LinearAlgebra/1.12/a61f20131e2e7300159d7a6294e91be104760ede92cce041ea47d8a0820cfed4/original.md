```julia
axpy!(α, x::AbstractArray, y::AbstractArray)
```

Overwrite `y` with `x * α + y` and return `y`. If `x` and `y` have the same axes, it's equivalent with `y .+= x .* a`.

# Examples

```jldoctest
julia> x = [1; 2; 3];

julia> y = [4; 5; 6];

julia> axpy!(2, x, y)
3-element Vector{Int64}:
  6
  9
 12
```
