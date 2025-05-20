```
lmul!(a::Number, B::AbstractArray)
```

Scale an array `B` by a scalar `a` overwriting `B` in-place.  Use [`rmul!`](@ref) to multiply scalar from right.  The scaling operation respects the semantics of the multiplication [`*`](@ref) between `a` and an element of `B`.  In particular, this also applies to multiplication involving non-finite numbers such as `NaN` and `±Inf`.

!!! compat "Julia 1.1"
    Prior to Julia 1.1, `NaN` and `±Inf` entries in `B` were treated inconsistently.


# Examples

```jldoctest
julia> B = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> lmul!(2, B)
2×2 Matrix{Int64}:
 2  4
 6  8

julia> lmul!(0.0, [Inf])
1-element Vector{Float64}:
 NaN
```
