```julia
reverse(A; dims=:)
```

Reverse `A` along dimension `dims`, which can be an integer (a single dimension), a tuple of integers (a tuple of dimensions) or `:` (reverse along all the dimensions, the default).  See also [`reverse!`](@ref) for in-place reversal.

# Examples

```jldoctest
julia> b = Int64[1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> reverse(b, dims=2)
2×2 Matrix{Int64}:
 2  1
 4  3

julia> reverse(b)
2×2 Matrix{Int64}:
 4  3
 2  1
```

!!! compat "Julia 1.6"
    Prior to Julia 1.6, only single-integer `dims` are supported in `reverse`.

