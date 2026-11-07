```julia
shuffle([rng=default_rng(),] v::Union{NTuple,AbstractArray})
```

Return a randomly permuted copy of `v`. The optional `rng` argument specifies a random number generator (see [Random Numbers](@ref)). To permute `v` in-place, see [`shuffle!`](@ref). To obtain randomly permuted indices, see [`randperm`](@ref).

!!! compat "Julia 1.13"
    Shuffling an `NTuple` value requires Julia v1.13 or above.


# Examples

```jldoctest
julia> shuffle(Xoshiro(0), 1:6)
6-element Vector{Int64}:
 5
 1
 2
 6
 3
 4
```
