```julia
median(A::AbstractArray; dims)
```

Compute the median of an array along the given dimensions.

# Examples

```jldoctest
julia> using Statistics

julia> median([1 2; 3 4], dims=1)
1×2 Matrix{Float64}:
 2.0  3.0
```
