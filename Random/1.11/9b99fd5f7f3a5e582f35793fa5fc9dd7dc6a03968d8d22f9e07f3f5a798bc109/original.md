```julia
randperm!([rng=default_rng(),] A::AbstractArray{<:Integer})
```

Construct in `A` a random permutation of length `length(A)`. The optional `rng` argument specifies a random number generator (see [Random Numbers](@ref)). To randomly permute an arbitrary vector, see [`shuffle`](@ref) or [`shuffle!`](@ref).

!!! compat "Julia 1.13"
    `A isa Array` was required prior to Julia v1.13.


# Examples

```jldoctest
julia> randperm!(Xoshiro(0), Vector{Int}(undef, 6))
6-element Vector{Int64}:
 5
 1
 2
 6
 3
 4
```
