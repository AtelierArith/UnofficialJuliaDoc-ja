```
randperm!([rng=default_rng(),] A::Array{<:Integer})
```

Construct in `A` a random permutation of length `length(A)`. The optional `rng` argument specifies a random number generator (see [Random Numbers](@ref)). To randomly permute an arbitrary vector, see [`shuffle`](@ref) or [`shuffle!`](@ref).

# Examples

```jldoctest
julia> randperm!(Xoshiro(123), Vector{Int}(undef, 4))
4-element Vector{Int64}:
 1
 4
 2
 3
```
