```julia
diff(A::AbstractVector)
diff(A::AbstractArray; dims::Integer)
```

Finite difference operator on a vector or a multidimensional array `A`. In the latter case the dimension to operate on needs to be specified with the `dims` keyword argument.

!!! compat "Julia 1.1"
    `diff` for arrays with dimension higher than 2 requires at least Julia 1.1.


# Examples

```jldoctest
julia> a = [2 4; 6 16]
2×2 Matrix{Int64}:
 2   4
 6  16

julia> diff(a, dims=2)
2×1 Matrix{Int64}:
  2
 10

julia> diff(vec(a))
3-element Vector{Int64}:
  4
 -2
 12
```
