```julia
rmul!(A::AbstractArray, b::Number)
```

Scale an array `A` by a scalar `b` overwriting `A` in-place.  Use [`lmul!`](@ref) to multiply scalar from left.  The scaling operation respects the semantics of the multiplication [`*`](@ref) between an element of `A` and `b`.  In particular, this also applies to multiplication involving non-finite numbers such as `NaN` and `±Inf`.

!!! compat "Julia 1.1"
    Prior to Julia 1.1, `NaN` and `±Inf` entries in `A` were treated inconsistently.


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> rmul!(A, 2)
2×2 Matrix{Int64}:
 2  4
 6  8

julia> rmul!([NaN], 0.0)
1-element Vector{Float64}:
 NaN
```
